#!/bin/bash

volume=20


DIR="$(cd "$(dirname "$0")" && pwd)"
me=`basename "$0"`

scriptFile="$DIR/$me"

tmpMusic=/home/alxminyaev/Projects/eltex_course/labs_linux_networks/task3_Alarm/sounds/Cool-alarm-tone-notification-sound.mp3

music=$2

if [ -z $music ]
    then
    music=$tmpMusic
fi

cronFile=cron.txt

param=$1


off_alarms(){
    jbs=( `ps axf | grep mplayer | grep -v grep | awk '{print $1}'` )
	for job in ${jbs[*]} ; do
		kill -15 $jbs
	done
}

set_time(){
    echo "Input time: "
    echo "Hours:"
    read hours
        if [[ "$hours" != [0-9] ]] && [[ "$hours" != [0-2][0-9] ]] ; then
            echo 'Input right time".' >&2
            exit 10
        fi
    echo "Minutes"
    read minutes
        if [[ "$minutes" != [0-9] ]] && [[ "$minutes" != [0-9][0-9] ]] ; then
            echo 'Input right time".' >&2
            exit 10
        fi
    echo $tm
    echo "Input path to file: "
    read music
    
    
}

case $param in
    "")
        set_time
        echo "$minutes $hours * * * $scriptFile -on $music" > $cronFile
        crontab $cronFile
        #sudo rtcwake -m mem -t $date
        ;;
    "-off")
        off_alarms
        ;;
    "-on")
        amixer -c 1 sset Master $volume% &> /dev/null &
        mplayer $music -loop 0 &> /dev/null &
        ;;    
    *)
        ;;
esac



