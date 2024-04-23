#!/bin/bash

funct(){
   global+="$1"
}

$global
$global2

for i in {1..20}; do
   global2+=$(funct "$i" &)
done

wait

echo "$global"
echo "$global2"