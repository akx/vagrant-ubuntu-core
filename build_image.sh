#!/bin/bash
set -x
set -e
MOUNTPOINT=/mnt/temp
dd if=/dev/zero of=disk.img bs=1048576 count=500
parted -a optimal -- disk.img mklabel msdos
parted -a optimal -- disk.img unit compact mkpart primary ext4 "1" "-1"
parted -a optimal -- disk.img set 1 boot on
DEVICE=/dev/mapper/$(sudo kpartx -av disk.img | grep -oE 'loop[0-9]p[0-9]')
echo $DEVICE
sudo mkfs.ext4 $DEVICE
[[ -d $MOUNTPOINT ]] || sudo mkdir $MOUNTPOINT
sudo mount -t ext4 $DEVICE $MOUNTPOINT
sudo tar --extract --directory $MOUNTPOINT --file ubuntu-core-13.10-core-amd64.tar.gz
sudo rsync -vr into-target/ $MOUNTPOINT/tmp/
# procfs required for kernel install
sudo mount -t proc proc $MOUNTPOINT/proc
sudo chroot $MOUNTPOINT bash /tmp/install.sh
sudo umount $MOUNTPOINT/proc
UUID=$(blkid -s UUID -o value /dev/mapper/loop0p1)
echo "UUID=$UUID / ext4 defaults 0 1" | sudo tee -a $MOUNTPOINT/etc/fstab
dd if=mbr.bin conv=notrunc bs=440 count=1 of=disk.img
sudo tee $MOUNTPOINT/boot/extlinux.conf <<EOF
DEFAULT linux
LABEL   linux
LINUX   /vmlinuz
APPEND  root=/dev/disk/by-uuid/$UUID ro
INITRD  /initrd.img
EOF
sudo tee $MOUNTPOINT/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
EOF

sudo ./extlinux-6.02 --install $MOUNTPOINT/boot --device $DEVICE
sudo umount $MOUNTPOINT
sudo kpartx -d disk.img
qemu-img convert -f raw -O vdi disk.img disk.vdi
rm disk.img