#!/bin/bash

while [[ "$#" -gt 0 ]]
do case $1 in
    -f|--firstname) firstname="$2"
    shift;;
    -s|--secondname) secondname="$2"
esac
shift
done
echo "My name is $firstname $secondname"
