#!/bin/bash

log(){
    if [ ! -e "user_activity.log" ]; then echo "Making new log file (no existing one detected)."; fi
    #^ notifying user that if there is a file to output to
    #: determine action based on argument
    if [[ $2 == "" ]]; then arg="without arguments"; else arg="with argument ' $2 '"; fi
    case $1 in
    "1") action="started executing this script - log on" ;;
    "0") action="finished executing this script - log off" ;;
    *) action="called the command ' $1 ' $arg" ;;
    esac
    echo "$(date +"%Y-%m-%d %H:%M:%S"): user ' $(whoami) ' has $action | user's primary group: $(id -g)" >> "user_activity.log"
    #^ the log to be outputted
}

log "$1" "$2"