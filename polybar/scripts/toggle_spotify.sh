#!/bin/sh

stdbuf -oL spotified --json listen toggled |
    while IFS= read -r LINE
    do
        STATUS=$(echo "$LINE" | jq -r ".status")

        if [[ $STATUS == "Playing" ]]
        then
            echo "Pause"
        else
            echo "Play"
        fi

    done
