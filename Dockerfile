FROM java:8-jre

LABEL Tim Turner <timdturner@gmail.com>

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
        wget -c https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2615411/download -O ftb.zip && \
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

# Copy server.properties file & white-list
COPY server.properties server.properties
COPY whitelist.json whitelist.json
COPY ops.json ops.json
COPY settings-local.sh settings-local.sh

# Expose volume
VOLUME ["/minecraft/world", "/minecraft/backups"]

CMD ["/bin/bash", "./ServerStart.sh"]

##ENV MOTD A Minecraft (Direwolf20 1.10 1.13) Server Powered by Docker
##ENV NVM_OPTS -Xms6144m -Xmx6144m -Dfml.queryResult=confirm