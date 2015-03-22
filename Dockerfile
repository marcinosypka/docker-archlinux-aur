# Arch Linux base docker container
# with base-devel group and yaourt installed for aur access
FROM l3iggs/archlinux
MAINTAINER l3iggs <l3iggs@live.com>

# update pacman db
RUN pacman -Suy --noconfirm

# install development packages
RUN pacman -Suy --noconfirm --needed base-devel

# no sudo password for users in wheel group
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# create docker user
RUN useradd -m -G wheel docker
WORKDIR /home/docker

# install yaourt
RUN su -c "(bash <(curl aur.sh) -si --noconfirm package-query yaourt)" -s /bin/bash docker

# the default user is now "docker" and so commands requiring root permissions
# should be prefixed with sudo from now on
USER docker

# clean up
RUN sudo rm -rf /home/docker/*

# install packer and update databases
RUN yaourt -Syyua --noconfirm --needed packer
