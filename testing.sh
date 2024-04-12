#!/bin/bash

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

echo $(numfmt --to=iec "1024")
