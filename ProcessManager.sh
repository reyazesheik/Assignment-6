#!/bin/bash

FILE="services.txt"

operation=$2

case $operation in

register)
    path=$4
    alias=$6

    echo "$alias:$path" >> $FILE
    echo "Service registered"
    ;;

start)
    alias=$4

    path=$(grep "^$alias:" $FILE | cut -d ':' -f2)

    if [ -z "$path" ]; then
        echo "Service not found"
        exit 1
    fi

    nohup bash $path > $alias.log 2>&1 &
    echo $! > $alias.pid

    echo "Service started"
    ;;

status)
    alias=$4

    if [ -f "$alias.pid" ] && ps -p $(cat $alias.pid) > /dev/null
    then
        echo "Running"
    else
        echo "Stopped"
    fi
    ;;

kill)
    alias=$4

    if [ -f "$alias.pid" ]; then
        kill -9 $(cat $alias.pid)
        echo "Service stopped"
    else
        echo "Service not found"
    fi
    ;;

priority)
    priority=$4
    alias=$6

    pid=$(cat $alias.pid)

    if [ "$priority" == "low" ]; then
        renice 10 -p $pid
    elif [ "$priority" == "med" ]; then
        renice 0 -p $pid
    elif [ "$priority" == "high" ]; then
        renice -10 -p $pid
    fi

    echo "Priority changed"
    ;;

list)
    cut -d ':' -f1 $FILE
    ;;

top)
    for i in $(cut -d ':' -f1 $FILE)
    do
        if [ -f "$i.pid" ]; then
            pid=$(cat $i.pid)
            ps -p $pid -o pid,stat,ni,cmd
        fi
    done
    ;;

*)
    echo "Invalid option"
    ;;

esac
