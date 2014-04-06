Vagrant Ubuntu Core image builder
=================================

Easily generate a minimal Ubuntu Core 13.10 x64 image
with a `vagrant` user built in.

Dependencies
------------

* `make`
* `kpartx`
* `qemu-img`
* `sudo`
* `wget`

A version of `extlinux` suitable to be installed on the image
is included.

Usage
-----

Due to the way the project uses `aptitude` to download packages,
you probably need to build the image on an Ubuntu 13.10 x64 machine.

With that said, all you likely need to do is

```
make
```

and you'll eventually end up with `disk.vdi`.

Notes
-----

* The root user's password is `toor`.