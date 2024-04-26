#!/bin/bash

#region menu and assistance

initialise(){
  case $1 in
    "help") help ;;
    "uuid") UUID "$2" ;;
    "analyse") analyse "$2" ;;
    *) printf "%b" "Invalid or no argument provided!
Use argument ' help ' to view all possible arguments.
    " ;;
    esac
    log "$1" "$2"
}

help(){
  printf "%b" "Welcome to this BASH script program!
\033[1mCommands/arguments | extra argument | purpose :\033[0m\n
help | N/A | shows arguments for commands with purpose and any extra argument
uuid | '4' or '5' for either version (4 or 5 respectrfully) | generates a UUID
analyse | directory path (using '/', not '\') | generates a comprehensive report of subjected directory
  "
}

#endregion
#region logging system

log(){
    if [ ! -e "user_activity.log" ]; then echo "Making new log file (no existing one detected)."; fi
    #^ notifying user that if there is already a file to output to
    #: determine action based on argument(s)
    if [[ $2 == "" ]]; then arg="without arguments"; else arg="with argument ' $2 '"; fi
    case $1 in
    "1") action="started executing this script - log on" ;;
    "0") action="finished executing this script - log off" ;;
    *) action="called the command ' $1 ' $arg" ;;
    esac

    echo "$(date +"%Y-%m-%d %H:%M:%S"): user ' $(whoami) ' has $action | user's primary group: $(id -g)" >> "user_activity.log"
    #^ the log to be outputted
}

#endregion
#region UUID generation

UUIDV4(){
  #! made in accordance to: https://www.ietf.org/archive/id/draft-ietf-uuidrev-rfc4122bis-01.html#name-uuid-version-4
  CSPRNG=$(openssl rand -hex 31)
  #^ a cryptographically secure pseudo-random number generator value
  Version=4
  #^ UUID version an an integer value
  UUIDHex="${CSPRNG:0:12}${Version}${CSPRNG:12:3}0x$((0x80|("0x${CSPRNG:15:2}"&0x3F)))${CSPRNG:17:14}"
  #^ Concaternating into UUID4 in hex form (4122)
  #^ uuid as: 12 random hex > version as int '4' in a single hex > 3 more random hexes > 2 bits as '10' > 62 bits
  UUID="${UUIDHex:0:8}-${UUIDHex:8:4}-${UUIDHex:12:4}-${UUIDHex:16:4}-${UUIDHex:20:12}"
  #^ making it the proper format
  echo "UUID Version 4 (in hex): $UUID"
  #^ output/result of the function
}

UUIDV5(){
  #! made in accordance to: https://www.ietf.org/archive/id/draft-ietf-uuidrev-rfc4122bis-01.html#name-uuid-version-5
  NameSpace="AssaignmentForOS"
  #^ Namespace to make input unique
  Version=5
  #^ UUID version an an integer value
  VariantField="10"
  #^ Leach-Salz variant
  read -r -p "input text here for UUID (V5)" Input
  #^ User chooses value for UUID creation
  ShaOne=$(echo -n "${NameSpace}${Input}" | sha1sum)
  #^ perfom sha1sum algorithm on the input
  ShaOnePart=$(echo "obase=2;ibase=16; ${ShaOne:16:16}" | tr '[:lower:]' '[:upper:]' | xxd -r -p | xxd -b -c 256 | cut -d' ' -f2- | tr -d ' \n')
  #^ get hex to convert to bin
  #^ apparently there's no direct way to convert hex to binary dispite there is vice versa (using only the coreutils part of bash)
  ShaOneLowExtraBin="${VariantField}${ShaOnePart:3:62}"
  #^ add the UUID variant value on left-most
  ShaOneLowExtraHex=$(echo $((2#${ShaOneLowExtraBin})) | xxd -p)
  #^ convert back to hex
  UUIDHex="${ShaOne:0:12}${Version}${ShaOne:13:3}${ShaOneLowExtraHex}"
  #^ add the UUID variant value on left-most
  #^ uuid as: first 12 hexes of sha1 > version as int '5' in a single hex > 3 hexes after the 13th hex of sha1 > 2 bits as '10' > 62 bits
  UUID="${UUIDHex:0:8}-${UUIDHex:8:4}-${UUIDHex:12:4}-${UUIDHex:16:4}-${UUIDHex:20:12}"
  #^ making it the proper format
  echo "UUID Version 5 (in hex): $UUID"
  #^ output/result of the function
}

UUID(){
  ##echo "$1"
  #: generates UUID where version depends on input - coded as a switch
  if [[ $1 == 4 ]]; then result=$(UUIDV4 | head -n 1)
  elif [[ $1 == 5 ]]; then result=$(UUIDV5 | head -n 1)
  else
    echo "argument must be either '4' or '5'"
    return 0
  #^ case of invalid input
  fi

  fileName="UUID$1.txt"

  #^ concaternating arguments doesn't require '{}' or it gives error
  #: has an UUID (same ver) already been generated?
  if [[ ! -f "$fileName" ]];
  then
    echo "No previous UUID V$1 detected"
    echo "$result" > "$fileName"
    #^ makes new file to store the generated UUID
    #^ double quotes to prevent "globbing and word splitting"
    #^ because files doesn't exist, it gets made
    echo "UUID V$1 generated as file $fileName"
    return 0
  fi

  #: is previous UUID (same ver) the same as the current one?
  if [[ $(cat "$fileName") == result ]];
  then
    echo "previous UUID V$1 matches current one. Please try again!"
    return 0
  else
    echo "previous UUID V$1 does not matches current one. Current UUID overwites previous one in ${fileName}!"
    echo "$result" > "$fileName"
    #^ stores (by overwrittting) UUID in the text file
  fi
}

#endregion
#region analysing dir

analyse(){
  #? is multiplexing impossible with only Coreutils? I was told that each parallel process is its own shell.
  #: setup
  $all
  mkdir "cache"
  analyseDir "$1"

  for file in "cache"/*; do all+=$(cat "$file"); done
  #^ combine outputs from all parallel processes
  echo -e "$all" > "directory_analysis.txt"
  #^ save to file ("-e" arg conciders new lines)
  printf "%b" "$all"
  #^ print to terminal
  rm -r "cache"
  #^ delete all the cache
}

analyseDir(){
    echo "new (except not new on first call) PID of ' $BASHPID ' with PPID ' $PPID ' - process of analysing files of dir with path: $1"
    #^ new PID for every call from the second call
    #: filepath validation
    if [ ! -e "$1" ]; then
        #^ does file path exists or is valid?
        echo "file path is invalid or does not exist"
        return; fi
    if [ ! -d "$1" ]; then
        #^ does file lead to a dir?
        echo "file path leads to a file instead of a dir"
        return; fi

    #: analysing all dirs using recursion
    for entity in "$1"/*; do
        if [ -d "$entity" ]; then
            echo ">>> sub-directory detected - entering $entity <<<"
            analyseDir "$entity" &
            #^ recurse with a sub dir
        fi
    done
    analyseFiles "$1" &
    #^ end of recursion
    wait
    #^ prevents program to end while function executions are still running
}

#! code style may be different because some code was made on https://www.shellcheck.net/ while the rest on VS Code
analyseFiles(){
    #! $1 is file path of subjected dir
    echo "new PID of ' $$ ' with PPID ' ${PPID} ' - process of analysing files of dir with path: $1"
    #^ new PID due to being called in parallel
    #: all 3 arrays' indexes corrospond with each other
    fileTypes=()
    #^ show all file extentions in dir
    #^ primary array - like a primary key in databases
    fileSizeTot=()
    #^ total size of each file type
    fileCount=()
    #^ number of files of same file type

    longestName=""; shortestName=""
    longestDraw=false; shortestDraw=false
    totalDirSize=0

    firstLoop=true
    #^ for setting up the longest and shortest variables

    for file in "$1"/*; do
        typeFound=false
        #^ has file type (ext) been found previously?
        #: stats of the file
        name=$(basename "$file")
        type="${name##*.}"
        size=$(stat -c %s "$file")
        ##echo "$name $size"

        if [ -d "$file" ]; then continue; fi
        #^ verifies thats its a file

        #: tries to find record of subjected file type
        for i in "${!fileTypes[@]}"; do
        #^ '!' indicates to use keys instead of values
            if [[ "${fileTypes[i]}" == "$type" ]]; then
                ((fileCount[i]++))
                #^ double brackets for doing maths on smth
                ((fileSizeTot[i]+=size))
                typeFound=true
                break;
                fi
        done

        #: add file type (with corrosponding data) if not already discovered
        if ! $typeFound; then
        #^ adding square backets causes logic errors...
            fileTypes+=("$type")
            fileCount+=(1)
            fileSizeTot+=("$size")
        fi

        #: compare file name length
        if ((${#name}>${#longestName})); then
        #^ current name is longest name yet
            longestName=$name
            longestDraw=false
        elif ((${#name}==${#longestName})); then
        #^ current name is same length as the longest name yet
            longestName=$name
            longestDraw=true
        fi
        if ((${#name}<${#shortestName})); then
        #^ current name is shortest name yet
            shortestName=$name
            shortestDraw=false
        else
        #^ current name is same length as the shortest name yet
            shortestName=$name
            shortestDraw=true
        fi

        #: executed once to set up the longest and shortest names
        if $firstLoop; then
            longestName="$name"
            shortestName="$name"
            firstLoop=false
            #^ prevents from repeating
        fi

    done

    for size in "${fileSizeTot[@]}"; do ((totalDirSize+="$size")); done
    #^ calculate total size of subjected dir

    #: output results - shows each file type and corrosponding total size and corrosponding count
    #^ prevent echos to mix with echos from other parallel processes
    result="analysis of directory from $1:\n"
    if (( ${#fileTypes[@]} > 0 )); then
        result+="\033[1mFile type | cumulative size | file count:\033[0m\n"
        for i in "${!fileTypes[@]}"; do
            #: shows info of each file type
            readableSize=$(numfmt --to=iec "${fileSizeTot[i]}")
            #^ makes storage size more human readable
            result+="${fileTypes[i]} | ${readableSize}B | ${fileCount[i]}\n"
        done
    else result+="no files detected in this directory\n"
    fi
    #: output results - shows extremities in the subjected dir
    result+="\n"
    result+="overall statistics:\n"
    result+="shortest file name: $shortestName, more than one shorest file name = $shortestDraw\n"
    result+="longest file name: $longestName, more than one longest file name = $longestDraw\n"
    result+="total size of subjected dir: $(numfmt --to=iec "$totalDirSize")B\n"
    result+="----------------------------------------------------------------\n"
    ##printf "%b" "$result"
    ##^ apparently it is not good practive to use 'printf "$result"' instead
    ##^ https://www.shellcheck.net/wiki/SC2059
    echo "$result" > "cache/${1//\//,}"
    #^ if i just print instead of writting to file, the print statement outputs will sometimes merge with each other (even with the 'wait' statement)
}

#endregion
#region bodycode


echo "new PID of ' $BASHPID ' with PPID ' ${PPID} ' - beginning of the script"
log "1"
initialise "$1" "$2"
log "0"

#endregion