#!/bin/bash

input_file=$1

while read -r line; do
    if [[ "$line" =~ "Name:".* ]]; then
        echo ""
        echo $line
        continue
    fi
    if [[ "$line" =~ "Taints:".* ]]; then
        echo $line
        continue
    fi
    if [[ "$line" =~ "Events:".* ]]; then
        echo $line
        continue
    fi
    if [[ "$line" =~ .*"OOM".* ]]; then
        echo $line
        continue
    fi
done < $input_file
