#!/bin/bash

declare -a opti=()

rm ./test/output*.png

for opti in "-O0" "-O1" "-O2" "-O3" "-Ofast"; do
    printf "%-8s" "${opti}: "
    for file in ./test/input*; do
        name=${file##*/}
        make build OPTIMIZATION="${opti}" > /dev/null 2> /dev/null
        echo -n `echo "100 100 500 500" | qemu-aarch64 image.out ${file} test/output${name}`
        printf " "
    done
    echo
done

printf "asm:    "
for file in ./test/input*; do
    name=${file##*/}
    make buildasm OPTIMIZATION="${opti}" > /dev/null 2> /dev/null
    echo -n `echo "100 100 500 500" | qemu-aarch64 image.out ${file} test/output${name}`
    printf " "
done
echo
echo
