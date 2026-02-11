#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash
ARCH := $(shell dpkg-architecture -qDEB_HOST_ARCH)
DIST := 'bookworm'
BACKPORT := true
SOURCE := true
SECURITY := true
UEFISECBOOT := disable
MWDEBINT := 'live'
LABEL := CEPHEUS-$(DIST)-$(ARCH)
USER := cepheus
SKEL := config/includes.chroot/etc/skel
ETC := config/includes.chroot/etc
PKG := config/package-lists
BOOT := config/bootloaders
INSTALL := config/includes.installer


##############################

build:
	# Build the live system/ISO image
	lb clean --all

	lb config --debug \
		-a $(ARCH) \
		--memtest memtest86+ \
		--bootappend-live "boot=live component username="$(USER) \
		--bootappend-install "net.ifnames=0" \
		--debian-installer $(MWDEBINT) \
		--backports $(BACKPORT) \
		--source $(SOURCE) \
		--security $(SECURITY) \
		--archive-areas "main contrib non-free non-free-firmware" \
		--distribution $(DIST) \
		--hdd-label $(LABEL) \
		--image-name $(LABEL) \
		--linux-packages "linux-image linux-headers" \
		--uefi-secure-boot $(UEFISECBOOT) \
		--win32-loader false

	
	# configure installer
	echo "debian-installer-launcher" > config/package-lists/installer.list.chroot
	echo "d-i debian-installer/locale string en_UK" > $(INSTALL)/preseed.cfg
	# add packages
	cat packages.list > $(PKG)/desktop.list.chroot
	# add User-Config
	#mkdir -p config/includes.chroot/etc/calamares/modules/
	# dir for color scheme for vim
	mkdir -p $(SKEL)/.vim/colors
	# vim packages installer
	mkdir -p $(SKEL)/.vim/bundle
	# vim packages
	mkdir -p $(SKEL)/.vim/nerdtree
	mkdir -p $(SKEL)/.vim/plugin
	mkdir -p $(SKEL)/.vim/bundle/YouCompleteMe
	mkdir -p $(SKEL)/.vim/pack/tpope/start
	# i3
	mkdir -p $(SKEL)/.config/i3
	# systemd
	mkdir -p $(ETC)/systemd/system
	# config for vim
	git clone https://github.com/gmarik/Vundle.vim.git $(SKEL)/.vim/plugin/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git $(SKEL)/.vim/bundle/vundle.vim
	git clone https://github.com/ycm-core/YouCompleteMe.git $(SKEL)/.vim/bundle/YouCompleteMe/
	git clone https://tpope.io/vim/fugitive.git $(SKEL)/.vim/pack/tpope/start/
	git clone https://github.com/preservim/nerdtree $(SKEL)/.vim/nerdtree/
	# add bashrc
	cp .bashrc config/includes.chroot/etc/skel.bashrc
	# set list of packages to remove by calamares after installation
	#cp packages.conf config/includes.chroot/etc/calamares/modules/
	# add script for modifying live build
	#cp modifier.sh config/hooks/live/startscript.hook.chroot
	# set i3 configuration
	cp i3config $(SKEL)/.config/i3/config
	cp kraut.png $(SKEL)/.config/i3/
	# add vimrc for costumizing vim
	cp vimrc $(SKEL)/.vimrc
	# add color scheme for vim
	cp forest_refuge.vim $(SKEL)/.vim/colors/
	echo "exec --no-startup-id feh --bg-scale /home/cepheus/.config/i3/kraut.png" >>config/includes.chroot/etc/skel/.config/i3/config
	#echo "exec --no-startup-id feh --geometry 1920x1080+0+0 /home/"$(USER)"/.config/i3/kraut.png" >>$(SKEL)/.config/i3/config
	# modify grub -> not in VM with QEMU??
	cp -r /usr/share/live/build/bootloaders config/
	cp My_cephei_pxi.png $(BOOT)/grub-pc/splash.png
	lb build 2>&1 | tee build.log

clean:
	echo "[LOG]\tclean up old configurations.."
	rm -rf config
	rm -rf auto
	rm -rf local
