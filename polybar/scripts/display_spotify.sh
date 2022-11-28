#!/bin/sh

stdbuf -oL spotified --json listen song |
    while IFS= read -r LINE
    do
        ARTIST=$(echo "$LINE" | jq -r ".artists[0]")
        SONG=$(echo "$LINE" | jq -r ".title")

        if [[ $SONG == "Advertisement" ]]
        then
            echo "$SONG"
        else
            echo "$SONG - $ARTIST"
        fi

    done
