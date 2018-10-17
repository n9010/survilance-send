#!/bin/bash
#Script for sending the struff via telegram

#Dir where motion puts the videos
DIR="/home/tizio/caio"
#dir where to save locally the videos
DIR_S="/home/tizio/peio"
#Set threshold for video size to be sent
MINIMUM_VIDEO_SIZE_K="-300k"
MINIMUM_IMAGE_SIZE_K="-10k"
SEND="telegram-send --config /home/nico/.config/telegram-send.conf --file"


find /home/nico/camera -mindepth 1 -maxdepth 1 -printf "%A@ %f\0" | 
  sort  | 
  sed -z 's/^[0-9.]\+ //' |
  while IFS= read -r -d '' filename
  do 
#do md5 for files and check if they are the same , in that case send them to bot
   MD5="/usr/bin/md5sum $DIR$filename"
   sleep 0.5
   MD5_1="/usr/bin/md5sum $DIR$filename"
F1=$MD5 | gawk  '{ print $1 }' 
F2=$MD5_1 | gawk  '{ print $1 }'

        if [ $F1 == $F2 ]
        then 
            if [[ $(find $DIR$filename -name "*.avi" -size $MINIMUM_VIDEO_SIZE_K 2>/dev/null) ]]
            
                $SEND $DIR$filename
                mv $DIR$filename $DIR_S
            else
              rm $DIR$filename
            fi
        fi
    sleep 1
  done

