#!/bin/bash

volume=5

file=/home/alxminyaev/Projects/eltex_course/labs_linux_networks/task3_Alarm/sounds/Cool-alarm-tone-notification-sound.mp3

param=$1


alarm_start()
{
	jbs=('ps axf | grep mplayer | grep -v grep | awk '{print "kill -9 " $1}'')
	for job in ${jbs[*]} ; do
		kill -15 $jbs
	done
	
	if [ -z "$1" ] ; then
		mplayer $file -loop 0 &> /dev/null &
	fi
}

set_time(){
    if [[ $# > 0 ]] ; then
        if [[ "$1" == [0-9]:[0-9][0-9] ]] || [[ "$1" == [0-9][0-9]:[0-9][0-9] ]] ; then
            tm=$1
        else
            echo 'Input right time".' >&2
            exit 10
        fi
    fi

    date1=$(date -d "`date +%m/%d/%y` $tm" +%s)
    date2=$(date -d "`date +%m/%d/%y` $tm tomorrow" +%s)

    err=$?
    if [[ $err > 0 ]] ; then
        echo 'Input right time".' >&2
        exit $err
    fi

    if [[ $date1 < `date -u +%s` ]] ; then
        date=$date2
    else
        date=$date1
    fi

}

case $param in
    "-t")
        set_time $2
        #sudo rtcwake -m mem -t $date
        
        echo $date
        amixer -c 1 sset Master $volume% &> /dev/null &
        alarm_start 
        ;;
    "-off")
        alarm_start "off"
        ;;
    *)
        ;;
esac

