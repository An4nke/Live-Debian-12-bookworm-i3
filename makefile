#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash

##############################

build:
	# Build the live system/ISO image↵
	sudo lb clean --all
	sudo lb config --image-name CEPHEUS- --hdd-label CEPHEUS --debian-installer live --archive-areas main non-free-firmware
	#sudo lb config --debug --distribution bookworm --backports true --archive-areas "main contrib non-free non-free-firmware" --hdd-label CEPHEUS-bookworm --uefi-secure-boot disable --image-name CEPHEUS-bookworm --linux-packages "linux-image linux-headers"i 
	#lb config --debug --debian-installer live --distribution bookworm --backports true --archive-areas "main contrib non-free non-free-firmware" --uefi-secure-boot disable --hdd-label CEPHEUS --image-name CEPHEUS-bookworm --linux-packages "linux-image linux-headers"
	# configure installer
	echo "debian-installer-launcher" > config/package-lists/installer.list.chroot
	echo "d-i debian-installer/locale string en_UK" > config/includes.installer/preseed.cfg
	# add packages
	cat packages.list > config/package-lists/desktop.list.chroot
	# add User-Config
	mkdir -p config/includes.chroot/etc/skel/.vim/colors
	mkdir -p config/includes.chroot/etc/skel/.config/i3
	cp i3config config/includes.chroot/etc/skel/.config/i3/config
	cp kraut.png config/includes.chroot/etc/skel/.config/i3/
	cp vimrc config/includes.chroot/etc/skel/.vim/.vimrc
	#cp /etc/vim/vimrc config/includes.chroot/etc/skel/.vimrc
	cp forest_refuge.vim config/includes.chroot/etc/skel/.vim/colors/
	#cp /usr/share/vim/vim81/colors/forest_refuge.vim config/includes.chroot/etc/skel/
	echo "exec --no-startup-id feh --bg-scale /home/user/.config/i3/kraut.png" >>config/includes.chroot/etc/skel/.config/i3/config
	# modify grub -> not in VM with QEMU??
	cp -r /usr/share/live/build/bootloaders config/
	cp kraut.png config/bootloaders/grub-pc/splash.png
	sudo lb build 2>&1 | tee build.log
