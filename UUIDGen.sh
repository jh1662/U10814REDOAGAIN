#!/usr/bin/env bash

UUIDV4(){
  #! made in accordance to: https://www.ietf.org/archive/id/draft-ietf-uuidrev-rfc4122bis-01.html#name-uuid-version-4
  CSPRNG=$(openssl rand -hex 31)
  #^ a cryptographically secure pseudo-random number generator value
  Version=4
  #^ UUID version an an integer value
  UUIDHex="${CSPRNG:0:12}${Version}${CSPRNG:12:3}$(echo "${CSPRNG:15:16}" | sed 's/./1/2')"
  #^ Concaternating into UUID4 in hex form (4122)
  #^ uuid as: 12 random hex > version as int '4' in a single hex > 3 more random hexes > 2 bits as '10' > 62 bits
  UUID="${UUIDHex:0:8}-${UUIDHex:8:4}-${UUIDHex:12:4}-${UUIDHex:16:4}-${UUIDHex:20:12}"
  #^ making it the proper format
  echo "UUID Version 4 (in hex): $UUID"   
  #^ output/result of the function
}

UUIDV4

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

UUIDV5