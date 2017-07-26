FROM java:8

MAINTAINER Tim Turner <timdturner@gmail.com>

RUN apt-get update && apt-get install -y wget unzip
RUN addgroup -gid 1234 minecraft
RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft

RUN mkdir /tmp/ftb && cd /tmp/ftb && \
        wget -c https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-10/files/2447188/download -O ftb.zip && \
        unzip ftb.zip && \
        rm ftb.zip && \
        bash -x FTBInstall.sh && \
        chown -R minecraft /tmp/ftb

USER minecraft
EXPOSE 25565

ADD start.sh /start

VOLUME /minecraft
ADD server.properties /tmp/server.properties
WORKDIR /minecraft

RUN chmod +x start.sh

CMD /start

ENV MOTD A Minecraft (Direwolf20 1.10 1.13) Server Powered by Docker
ENV LEVEL world
ENV NVM_OPTS -Xms2048m -Xmx2048m