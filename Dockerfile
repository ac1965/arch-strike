FROM ac1965/archlinux:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# archstrike
USER root
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
RUN dirmngr < /dev/null && pacman-key -r 7CBC0D51 && \
	pacman-key --lsign-key 7CBC0D51 && \
	pacman -Syu --noconfirm archstrike-keyring && \
	pacman -Syu --noconfirm archstrike-mirrorlist
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
RUN pacman -Syyu

# A feeling of fondness :p
# RUN pacman -Syu --noconfirm archstrike
COPY ["packages/", "/tmp/packages/"]
RUN pacman -S --noconfirm --needed $(cat /tmp/packages/base.txt)

# Metasploit
USER root
RUN mkdir /run/postgresql
RUN chown -R postgres:postgres /run/postgresql
RUN chown -R postgres:postgres /var/lib/postgres
USER postgres
RUN initdb -E UTF8 -D '/var/lib/postgres/data'
RUN pg_ctl -D /var/lib/postgres/data -l logfile start

USER pwner
