#!/bin/bash

UEVENT_PATH=/sys/class/power_supply/ACAD/uevent
PROBE_INTERVAL_SECONDS=15

check_requirements() {
    if [ "$EUID" -ne 0 ]
        then echo "error: program must run under root"
        exit 1
    fi

    if ! command -v "cpupower" &> /dev/null
    then
        echo "error: cpupower not found"
        exit 1
    fi

    if [ -f "$UEVENT_PATH" ]; then
        echo "uevent file exists"
    else
        echo "error: uevent file does not exist"
        exit 1
    fi
}

check_requirements
echo "probing interval: $PROBE_INTERVAL_SECONDS s"

# 1 - plugged in, 0 - on battery, 2 - not checked
LAST_STATE=2

set_governor() {
    CURRENT_STATE=$(grep "POWER_SUPPLY_ONLINE" $UEVENT_PATH | grep -Eo '[0-9]')

    if [ $CURRENT_STATE -ne $LAST_STATE ]; then
        if [ $CURRENT_STATE -eq 1 ]; then
            echo "switching to performance"
            cpupower frequency-set -g performance > /dev/null 2> /dev/null
        else
            echo "switching to powersave"
            cpupower frequency-set -g powersave > /dev/null 2> /dev/null
        fi
        tlp start > /dev/null 2> /dev/null
    fi

    LAST_STATE=$CURRENT_STATE
}

while true
do
    set_governor
    sleep $PROBE_INTERVAL_SECONDS
done
