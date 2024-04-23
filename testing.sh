#!/bin/bash

funct(){
   echo "new PID of ' $$ ' with PPID ' ${PPID} '"
}

a="1234567890abcdef"
echo "${a:1:3}"
echo "${a:4:3}"
echo "${a:7:3}"

echo "${a:0:3}"
echo "${a:3:3}"
echo "${a:6:3}"

echo "ls -l | awk '{print $1}'"

b=false
if ! $b; then echo "correct!"; else echo "incorrect"; fi

echo "BITWISE:"

CSPRNG=$(openssl rand -hex 31)
hex="0x${CSPRNG:15:2}"
echo $hex

printf '%X\n' $(( 0x80 | ( "0x${CSPRNG:15:2}" & 0x3F ) ))
echo 0x$(( 0x80 | ( "0x${CSPRNG:15:2}" & 0x3F ) ))

echo "bin and hex:"
echo 0xF


ShaOne=$(echo -n "text" | sha1sum)
echo $ShaOne
hex1=$(echo "obase=2;ibase=16; ${ShaOne:16:16}" | tr '[:lower:]' '[:upper:]' | xxd -r -p | xxd -b -c 256 | cut -d' ' -f2- | tr -d ' \n')
echo $hex1

VariantField="10"
ShaOneLowExtraBin="${VariantField}${ShaOnePart:3:62}"
ShaOneLowExtraHex=$(echo $((2#${ShaOneLowExtraBin})) | xxd -p)
echo $ShaOneLowExtraHex

UUIDHex="${CSPRNG:0:12}${Version}${CSPRNG:12:3}0x$((0x80|("0x${CSPRNG:15:2}"&0x3F)))${CSPRNG:17:14}"

echo $(numfmt --to=iec "1024")

echo "new PID of ' $$ ' with PPID ' ${PPID} '"
funct