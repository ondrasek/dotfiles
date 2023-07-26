#!/usr/bin/env zsh

# <xbar.title>lima docker vm status</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Ondrej Krajicek</xbar.author>
# <xbar.author.github>ondrasek</xbar.author.github>
# <xbar.desc>Shows lima docker VM status and CPU usage, with the option to start or stop it.</xbar.desc>
# <xbar.image></xbar.image>
# !xbar.dependencies>zsh</xbar.dependencies>

function bytes_to_human() {
  local -i bytes="$1"
  local -a units=("KiB" "MiB" "GiB" "TiB" "PiB")
  local -i unit_index=0

  while (( bytes >= 1024 && unit_index < ${#units[@]} - 1 )); do
    let "bytes /= 1024"
    let "unit_index += 1"
  done

  printf "%d %s\n" "$bytes" "${units[$unit_index]}"
}

NAME=docker
VMNAME=VirtualMachine # Virtual Machine Service on MacOS
LIMACTL=/opt/homebrew/bin/limactl
CPUTHR=5.0

STATUS=${$($LIMACTL list $NAME --format="{{.Status}}")##*( )}
VMTYPE=${$($LIMACTL list $NAME --format="{{.VMType}}")##*( )}
VMTYPE=$VMTYPE[1]
CPUS=${$($LIMACTL list $NAME --format="{{.CPUs}}")##*( )}
MEMORY=${$($LIMACTL list $NAME --format="{{.Memory}}")##*( )}
DISK=${$($LIMACTL list $NAME --format="{{.Disk}}")##*( )}
SSH=${$($LIMACTL show-ssh $NAME)##*( )}

MEMORY=$(bytes_to_human $MEMORY)
DISK=$(bytes_to_human $DISK)

# If the VMTYPE is qemu, we need to check the CPU usage of the qemu process instead of VZ
[[ $VMTYPE == *vz* ]] || VMNAME=qemu-system-aarch64

# CPU Usage
CPU=$(ps -p $(pgrep $VMNAME) -o %cpu | tail -n 1)

if (( $CPU <= $CPUTHR )); then
	SHORTCPU=""
else
	SHORTCPU=$CPU"%"
fi

[ -z $CPU ] || CPU=$CPU%

if [[ $STATUS == *Running* ]]; then
	HEADER=$NAME"($VMTYPE)$SHORTCPU"
else
	HEADER=X
fi

echo $HEADER
echo "---"
echo VM Name: $VMNAME
echo CPU Usage: $CPU
echo CPUs: $CPUS
echo Memory: $MEMORY
echo Disk: $DISK

