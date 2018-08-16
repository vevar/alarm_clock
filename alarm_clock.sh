#!/bin/bash

#location of script
DIR="$(cd "$(dirname "$0")" && pwd)"

#default sound of alarm
tmpMusic=sounds/Cool-alarm-tone-notification-sound.mp3

#Turn off alarms
offAlarms(){
    jbs=( `ps axf | grep mplayer | grep -v grep | awk '{print $1}'` )
	for job in ${jbs[*]} ; do
		kill -15 $jbs
	done
}

#Turn on alarm
onAlarm(){
    
    #default value of sound
    local volume=20
    #Set music of alarm
    local music=$1

    if [ -z "$music" ]
    then
        music="$DIR/$tmpMusic"
    fi
    
    amixer -c 1 sset Master $volume% &> /dev/null &
    mplayer $music -loop 0 &> /dev/null &
}

#New alarm clock
addNewAlarm(){
    echo "Input time: "
    
    echo "Hours:"
    local hours
    read hours
        if [[ "$hours" != [0-9] ]] && [[ "$hours" != [0-2][0-9] ]] ; then
            echo 'Input right time".' >&2
            exit 10
        fi
        
    echo "Minutes"
    local minutes
    read minutes
        if [[ "$minutes" != [0-9] ]] && [[ "$minutes" != [0-9][0-9] ]] ; then
            echo 'Input right time".' >&2
            exit 10
        fi
        
    echo "Input path to file: "
    local music
    read music

    
    local me=`basename "$0"`
    local scriptFile="$DIR/$me"
    #Name of crontab file
    local cronFile=crontab_rec_file

    crontab -l > $cronFile
    echo "$minutes $hours * * * $scriptFile -on $music" >> $cronFile
    crontab $cronFile
    rm $cronFile

}

for (( arg=1; arg<=$#; arg++))
do
    rec=${!arg:0:1}
    if [ "$rec" = "-" ]
    then
        case ${!arg} in
            #New alarm clock
            "-n")
                addNewAlarm
                ;;
            #Turn off alarms
            "-off")
                offAlarms
                ;;
            #Turn on alarm
            "-on")
                param=$(( arg + 1 ))
                onAlarm ${!param}
                ;;
            *)
                echo "Incorrect parametrs"
                ;;
        esac
    fi
done


