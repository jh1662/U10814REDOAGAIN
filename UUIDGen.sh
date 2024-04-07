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