FROM java:8-jre

MAINTAINER Tim Turner <timdturner@gmail.com>

# Updating container
RUN apt-get update && \
	apt-get upgrade --yes --force-yes && \
	apt-get clean && \ 
	rm -rf /var/lib/apt/lists/*

# Setting workdir
WORKDIR /minecraft

# Changing user to root
USER root

# Creating user and downloading files
RUN useradd -m -U minecraft && \
        mkdir /tmp/ftb && cd /tmp/ftb && \
        wget -c https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-10/files/2447188/download -O ftb.zip && \
        unzip ftb.zip && \
        rm ftb.zip && \
        chmod u+x FTBInstall.sh ServerStart.sh && \
        echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.txt && \
	echo "eula=TRUE" >> eula.txt && \
        chown -R minecraft:minecraft /tmp/ftb

USER minecraft

RUN /minecraft/FTBInstall.sh

EXPOSE 25565

VOLUME /minecraft
COPY server.properties /tmp/server.properties
WORKDIR /minecraft

CMD ["/bin/bash", "/minecraft/ServerStart.sh"]

ENV MOTD A Minecraft (Direwolf20 1.10 1.13) Server Powered by Docker
ENV LEVEL world
ENV NVM_OPTS -Xms2048m -Xmx2048m