disk.vdi: ubuntu-core-13.10-core-amd64.tar.gz packages
	./build_image.sh

ubuntu-core-13.10-core-amd64.tar.gz:
	wget http://cdimage.ubuntu.com/ubuntu-core/releases/13.10/release/ubuntu-core-13.10-core-amd64.tar.gz

packages:
	(cd into-target && aptitude download busybox dropbear linux-image-3.11.0-18-generic net-tools sudo udhcpc)
	touch packages