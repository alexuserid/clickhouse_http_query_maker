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

# define colors for readability
blue='\033[0;34m'
purple='\033[0;35m'
grey='\033[0;30m'
green='\033[0;32m'
nc='\033[0m'

containers=$( docker ps --format "{{.Image}} {{.ID}}" ) || { echo 'failed docker ps --format "{{.Image}} {{.ID}}"'; exit 1; } # get docker container ids as array

i=0
for item in $containers;
do
        if [ $(($i % 2)) -eq 0 ] # even elements are image names, odd elements are ids 
        then
                printf "${blue}Image:${nc} $item\n"
                i=$((++i))
                continue
        fi

        printf "${purple}Container:${nc} $item\n" # prints container id

        printf "${green}Match in log:${nc}\n"
        docker logs $item 2>&1 | grep --color -E "$pattern" || { printf "${grey}no matches${nc}\n"; } # 
        echo "" # for new line
        i=$((++i))
done

echo "script done"
