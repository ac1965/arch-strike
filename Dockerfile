FROM ac1965/archlinux:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# archstrike
USER root
WORKDIR /root
RUN echo -e "\
\n\
[archstrike]\n\
Server = https://mirror.archstrike.org/\$arch/\$repo\n\
\n\
[archstrike-testing]\n\
Server = https://mirror.archstrike.org/\$arch/\$repo"\
                >> /etc/pacman.conf
RUN pacman -Syy
RUN pacman-key --init
RUN dirmngr < /dev/null && \
	pacman-key -r DE64825E7CBC0D51 && pacman-key --lsign-key DE64825E7CBC0D51 && \
	pacman -S --noconfirm archstrike-keyring && pacman -S --noconfirm archstrike-mirrorlist
RUN sed -i '/archstrike/{N;d}' /etc/pacman.conf
RUN sed -i '/archstrike-testing/{N;d}' /etc/pacman.conf
RUN echo -e "\
\n\
[archstrike]\n\
Include = /etc/pacman.d/archstrike-mirrorlist\n\
\n\
[archstrike-testing]\n\
Include = /etc/pacman.d/archstrike-mirrorlist"\
                >> /etc/pacman.conf

# A feeling of fondness :p
COPY ["packages/", "/tmp/packages/"]
RUN pacman -Syyu --force --noconfirm --needed $(egrep -v '^#|^$' /tmp/packages/base.txt)

USER pwner
WORKDIR /tmp
