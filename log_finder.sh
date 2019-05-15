# This script was made for text search through all running docker containers logs.
# Don't forget to add execute permission for log_finder.sh file.
# Usage: ./log_finder.sh $pattern_to_find

#!/bin/bash

set -u # exit script if you try to use uninitialized variable
set -e # exit script if any statement returns a non-true value

if [ $# -eq 0 ]
then
        echo 'Pattern variable not set. Script usage: ./log_finder.sh $pattern_to_find'
        exit 1
fi

pattern=$1
containers=$( docker ps --format "{{.Image}} {{.ID}}" ) || { echo "failed docker ps --format {{.ID}}"; exit 1; } # get docker container ids as array

i=0
for item in $containers;
do
        if [ $(($i % 2)) -eq 0 ] # even elements are image names, odd elements are ids 
        then
                echo "Image: $item"
                i=$((++i))
                continue
        fi

        echo "Container: $item" # prints container id

        echo "Match in log:"
        docker logs $item 2>&1 | grep --color -E "$pattern" || { echo "no matches"; } # 
        echo "" # for new line
        i=$((++i))
done

echo "script done"
