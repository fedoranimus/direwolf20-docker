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
        mkdir -p /minecraft/world && \
        wget -c https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-10/files/2447188/download -O ftb.zip && \
        unzip ftb.zip && \
        rm ftb.zip && \
        chmod u+x FTBInstall.sh ServerStart.sh && \
        echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.txt && \
	echo "eula=TRUE" >> eula.txt && \
        chown -R minecraft:minecraft /minecraft

USER minecraft

# Run install
RUN /minecraft/FTBInstall.sh

# Expose port
EXPOSE 25565

# Expose volume
VOLUME ["/minecraft/world", "/minecraft/backups", "/minecraft/server.properties", "/minecraft/white-list.txt"]

RUN echo ""

# Copy server.properties file & white-list
COPY server.properties /minecraft/server.properties
COPY white-list.txt /minecraft/white-list.txt

CMD ["/bin/bash", "./ServerStart.sh"]

##ENV MOTD A Minecraft (Direwolf20 1.10 1.13) Server Powered by Docker
##ENV NVM_OPTS -Xms2048m -Xmx2048m