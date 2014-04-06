#!/bin/bash
set -x
sudo umount /mnt/temp/proc
sudo umount /mnt/temp
sudo kpartx -d disk.img
#rm disk.img
