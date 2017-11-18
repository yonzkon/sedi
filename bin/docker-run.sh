#!/bin/sh

usage()
{
    echo "Usage: docker-run.sh DOCKER"
    echo "  DOCKER: archlinux | debian | wine | poseidon | mssql"
}

archlinux()
{
    docker run -d -it --name=archlinux -h archlinux \
           -e 'LANG=en_US.UTF-8' \
           -e 'DISPLAY=:0' \
           -p 10000-10999:10000-10999 \
           -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
           -v /dev/dri/:/dev/dri/ \
           -v /root/:/root/ \
           -v /home/:/home/ \
           base/archlinux
}

debian()
{
    docker run -d -it --name=debian -h debian \
           -e 'LANG=en_US.UTF-8' \
           -e 'DISPLAY=:0' \
           -p 11000-11999:11000-11999 \
           -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
           -v /dev/dri/:/dev/dri/ \
           -v /root/:/root/ \
           -v /home/:/home/ \
           debian
}

wine()
{
    docker run --rm -it --name=wine -h wine \
           -e 'LANG=zh_US.UTF-8' \
           -e 'DISPLAY=:0' \
           -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
           -v /dev/dri/:/dev/dri/ \
           -v /wine/:/wine/ \
           -v /root/:/root/ \
           -v /home/:/home/ \
           --entrypoint='' \
           yon2kong/wine bash
}

poseidon()
{
    docker run --rm -d --name=cro -h cro \
           -e 'LANG=en_US.UTF-8' \
           -p 24390:24390 -p 6900:6900 \
           -p 6901-6903:6901-6903 \
           -v /root/:/root/ \
           -v /home/:/home/ \
           yon2kong/poseidon
}

mssql()
{
    docker run --rm -d --name=mssql -h mssql \
           -p 1433:1433 \
           -v /var/docker-data/mssql/:/var/opt/mssql/ \
           -v /root/:/root/ \
           -v /home/:/home/ \
           -e'ACCEPT_EULA=Y' -e'SA_PASSWORD=Test1234' \
           microsoft/mssql-server-linux
}

case $1 in
    archlinux) archlinux;;
    debian) debian;;
    wine) wine;;
    poseidon) poseidon;;
    mssql) mssql;;
    *) usage && exit 1;;
esac
