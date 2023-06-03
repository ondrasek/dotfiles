#!/usr/bin/env zsh

# <xbar.title>lima docker vm status</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Ondrej Krajicek</xbar.author>
# <xbar.author.github>ondrasek</xbar.author.github>
# <xbar.desc>Shows lima docker VM status and CPU usage, with the option to start or stop it.</xbar.desc>
# <xbar.image></xbar.image>
# !xbar.dependencies>zsh</xbar.dependencies>

NAME=docker
VMNAME=VirtualMachine # Virtual Machine Service on MacOS
LIMACTL=/opt/homebrew/bin/limactl
CPUTHR=5.0

STATUS=${$($LIMACTL list $NAME --format="{{.Status}}")##*( )}
VMTYPE=${$($LIMACTL list $NAME --format="{{.VMType}}")##*( )}
CPU=$(ps -p $(pgrep $VMNAME) -o %cpu | tail -n 1)

if (( $CPU <= $CPUTHR )); then
	CPU=""
else
	CPU=$CPU"%"
fi

if [[ $STATUS == *Running* ]]; then
	echo $NAME "($VMTYPE)$CPU"
else
	echo X
fi
