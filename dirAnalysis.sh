#!/usr/bin/env bash

#! line indents are different because some code was made on https://www.shellcheck.net/ while the rest on VS Code
analyseFiles(){
    #! $1 is file path of subjected dir
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
        echo "$name $size"
        echo "before is ${#fileTypes[@]}"

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

        echo "after is ${#fileTypes[@]}"

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

    for size in "${fileSizeTot[@]}"; do ((totalDirSize+=$size)); done
    #^ calculate total size of subjected dir

    #: output results - each file type and corrosponding total size and corrosponding count
    echo "analysis of directory from $1:"
    echo "File type | cumulative size | file count:"
    for i in "${!fileTypes[@]}"; do
        readableSize=$(numfmt --to=iec "${fileSizeTot[i]}")
        #^ makes storage size more human readable
        echo "${fileTypes[i]} | $readableSize | ${fileCount[i]}"
    done
    printf "\n"
    echo "overall statistics:"
    echo "shortest file name: $shortestName, more than one shorest file name = $shortestDraw"
    echo "longest file name: $longestName, more than one longest file name = $longestDraw"
    echo "total size of subjected dir: $(numfmt --to=iec "$totalDirSize")"
}

analyseFiles "$1"