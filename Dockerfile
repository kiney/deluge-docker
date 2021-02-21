FROM ubuntu:20.10

ENV V 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y software-properties-common locales psmisc \
 && add-apt-repository ppa:deluge-team/stable \
 && apt-get update \
 && apt-get install -y deluged deluge-web deluge-console

# Set the locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# set timezone
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# deluge stuff
EXPOSE 61939/udp
EXPOSE 61939
EXPOSE 58846

RUN deluged; sleep 1; killall deluged
RUN echo "kiney:lESReJ1WYWULKjV:10" >> ~/.config/deluge/auth
#RUN deluge-console "config -s allow_remote True"
#RUN deluge-console "config allow_remote"
RUN sed -i 's/"allow_remote": false/"allow_remote": true/' ~/.config/deluge/core.conf

CMD deluged
