#!/bin/bash

info()
{
    echo "usage: vm-inst [-n VM name] | <optional> [-r RAM] [-c vcpus] [-g hard drive size in GB]"
}

ram=8192
num_cpu=4
hd_size=20

while getopts ":n:r:c:g:" arg; do
    case ${arg} in
        n)      vm=$OPTARG      ;;
        r)      ram=$OPTARG     ;;
        c)      num_cpu=$OPTARG ;;
        g)      hd_size=$OPTARG ;;
        ?)      info
                exit            ;;
    esac
done
shift $((OPTIND -1))

if [ -z "$vm" ]; then
    info
    exit
fi

echo "Building VM"

sudo virt-install --name $vm \
                  --ram $ram \
                  --disk path=./$vm,size=$hd_size \
                  --vcpus $num_cpu \
                  --os-type linux --os-variant generic \
                  --network bridge=br0 \ # or virbr0, however you're set up
                  --graphics none --console pty,target_type=serial \
                  --location '/path/to/iso' \
                  --extra-args "console=ttyS0,115200n8 serial"
