FROM ubuntu:16.04
MAINTAINER Calvin Nguyen, <calvin4084@gmail.com>
EXPOSE 27015/udp
VOLUME ["/home/container/unturned/Servers/"]

ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN         apt-get update
RUN         apt-get install -y apt-utils cron ca-certificates lib32gcc1 unzip net-tools lib32stdc++6 lib32z1 lib32z1-dev curl wget screen tmux libmono-cil-dev mono-runtime
RUN         apt install screen htop unzip #Utils
RUN         dpkg --add-architecture i386
RUN         apt install lib32stdc++6 #SteamCMD dependencies
RUN         apt install mono-runtime mono-reference-assemblies-2.0		                        
RUN         apt install libc6:i386 libgl1-mesa-glx:i386 libxcursor1:i386 libxrandr2:i386 # 32 bit prerequisites for Unity 3D
RUN         apt install libc6-dev-i386 libgcc-4.8-dev:i386 # prequesites for BattlEye

RUN         useradd -m -d /home/container container

USER        container
ENV         HOME /home/container

WORKDIR     /home/container
RUN mkdir -p /home/container/steamcmd && curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/container/steamcmd -zx
RUN mkdir -p /home/container/unturned
ADD bash/start.sh /home/container/start.sh
RUN chmod a+x /home/container/start.sh
RUN (crontab -l ; echo "* * * * * /home/container/steamcmd/start.sh rocket") | sort - | uniq - | crontab -

ADD bash/update.sh /home/container/update.sh
RUN chmod a+x /home/container/update.sh
RUN (crontab -l ; echo "@daily /home/container/steamcmd/update.sh") | sort - | uniq - | crontab -

ADD credentials/STEAM_USERNAME /root/.steam_user
ADD credentials/STEAM_PASSWORD /root/.steam_pass
ADD credentials/ROCKET_API_KEY /root/.rocket_id

CMD         ["/bin/bash", "/start.sh"]