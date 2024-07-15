#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash

##############################

build:
	# Build the live system/ISO image↵
	sudo lb clean --all
	#sudo lb config --image-name CEPHEUS-CALAMARES- --hdd-label CEPHEUS-CALAMARES- --archive-areas main non-free-firmware
	#sudo lb config --distribution bullseye --image-name CEPHEUS- --hdd-label CEPHEUS --archive-areas main non-free-firmware
	sudo lb config --debug --distribution bookworm --memtest memtest86+ --bootappend-live "boot=live component username=cepheus" --debian-installer live --backports true --archive-areas "main contrib non-free non-free-firmware" --hdd-label CEPHEUS-bookworm --uefi-secure-boot disable --image-name CEPHEUS-bookworm --linux-packages "linux-image linux-headers" 
	#lb config --debug --debian-installer live --distribution bookworm --backports true --archive-areas "main contrib non-free non-free-firmware" --uefi-secure-boot disable --hdd-label CEPHEUS --image-name CEPHEUS-bookworm --linux-packages "linux-image linux-headers"
	# configure installer
	echo "debian-installer-launcher" > config/package-lists/installer.list.chroot
	echo "d-i debian-installer/locale string en_UK" > config/includes.installer/preseed.cfg
	# add packages
	cat packages.list > config/package-lists/desktop.list.chroot
	# add User-Config
	#mkdir -p config/includes.chroot/etc/calamares/modules/
	# dir for color scheme for vim
	mkdir -p config/includes.chroot/etc/skel/.vim/colors
	# vim packages installer
	mkdir -p config/includes.chroot/etc/skel/.vim/bundle
	# vim packages
	mkdir -p config/includes.chroot/etc/skel/.vim/nerdtree
	mkdir -p config/includes.chroot/etc/skel/.vim/plugin
	mkdir -p config/includes.chroot/etc/skel/.vim/bundle/YouCompleteMe
	mkdir -p config/includes.chroot/etc/skel/.vim/pack/tpope/start
	# i3
	mkdir -p config/includes.chroot/etc/skel/.config/i3
	# systemd
	mkdir -p config/includes.chroot/etc/systemd/system
	# config for vim
	git clone https://github.com/gmarik/Vundle.vim.git config/includes.chroot/etc/skel/.vim/plugin/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git config/includes.chroot/etc/skel/.vim/bundle/vundle.vim
	git clone https://github.com/ycm-core/YouCompleteMe.git config/includes.chroot/etc/skel/.vim/bundle/YouCompleteMe/
	git clone https://tpope.io/vim/fugitive.git config/includes.chroot/etc/skel/.vim/pack/tpope/start/
	git clone https://github.com/preservim/nerdtree config/includes.chroot/etc/skel/.vim/nerdtree/
	# add bashrc
	cp .bashrc config/includes.chroot/etc/skel.bashrc
	# set list of packages to remove by calamares after installation
	#cp packages.conf config/includes.chroot/etc/calamares/modules/
	# add script for modifying live build
	#cp modifier.sh config/hooks/live/startscript.hook.chroot
	# set i3 configuration
	cp i3config config/includes.chroot/etc/skel/.config/i3/config
	cp kraut.png config/includes.chroot/etc/skel/.config/i3/
	# add vimrc for costumizing vim
	cp vimrc config/includes.chroot/etc/skel/.vimrc
	# add color scheme for vim
	cp forest_refuge.vim config/includes.chroot/etc/skel/.vim/colors/
	echo "exec --no-startup-id feh --bg-scale /home/cepheus/.config/i3/kraut.png" >>config/includes.chroot/etc/skel/.config/i3/config
	#echo "exec --no-startup-id feh --geometry 1920x1080+0+0 /home/user/.config/i3/kraut.png" >>config/includes.chroot/etc/skel/.config/i3/config
	# modify grub -> not in VM with QEMU??
	cp -r /usr/share/live/build/bootloaders config/
	cp My_cephei_pxi.png config/bootloaders/grub-pc/splash.png
	sudo lb build 2>&1 | tee build.log
