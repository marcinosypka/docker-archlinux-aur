# Arch Linux base docker container
# with base-devel group and yaourt installed for aur access
FROM l3iggs/archlinux

# update pacman db
RUN pacman -Suy --noconfirm

# install development packages
RUN pacman -Suy --noconfirm --needed base-devel

# here is some garbage to work around the fact that makepkg's --asroot was removed by the stupid devs
RUN pacman -Suy --noconfirm --needed sudo
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
RUN useradd docker -G wheel
RUN cp /etc/skel /home/docker
RUN chown -R docker /home/docker
RUN chgrp -R docker /home/docker
WORKDIR /tmp
RUN su -c "(bash <(curl aur.sh) -si --noconfirm package-query yaourt)" -s /bin/bash docker
WORKDIR /
USER docker
RUN yaourt -Suya
USER 0

# must switch to user "docker" to use yaourt going forward
