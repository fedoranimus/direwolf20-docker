docker-minecraft-ftb-direwolf20-1.10
===============

## Attaching data directory to host filesystem

In order to persist the Minecraft data, which you *probably want to do for a real server setup*, use the `-v` argument to map a directory of the host to ``/data``:

    docker run --name minecraft -d -v /path/on/host:/minecraft/world -p 25565:25565 timdturner/direwolf20

When attached in this way you can stop the server, edit the configuration under your attached ``/path/on/host`` and start the server again with `docker start CONTAINERID` to pick up the new configuration.