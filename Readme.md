## About
Script that automatically changes CPU governor and runs tlp.
<br>
When charger is connected, the CPU governor is set to _performance_ otherwise it is set to _powersave_.
<br>
Requirements:
* cpupower
* tlp
* bash
* systemd

## Packages
Script is packaged for following distributions:
* Ubuntu

## Manual install
1. place `auto-cpu-governor.service` in `/etc/systemd/system`
2. place `auto-cpu-governor.sh` in `/usr/bin`
3. execute command: `systemctl daemon-reload` as root
4. execute command: `sudo systemctl start auto-cpu-governor.service` as root
5. execute command: `systemctl status auto-cpu-governor.service` in order to verify that the program is running
