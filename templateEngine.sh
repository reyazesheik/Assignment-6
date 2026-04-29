#!/bin/bash

# First argument = template file
file=$1
shift   # remove first argument

content=$(cat $file)

# Loop through all key=value arguments
for arg in "$@"
do
    key=$(echo $arg | cut -d '=' -f1)
    value=$(echo $arg | cut -d '=' -f2)

    # Replace {{key}} with value
    content=$(echo "$content" | sed "s/{{$key}}/$value/g")
done

# Print final result
echo "$content"
