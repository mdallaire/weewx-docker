FROM debian:buster-slim
ENV WEEWX_VERSION 4.5.1
WORKDIR /tmp/setup

RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates wget ssh rsync fonts-freefont-ttf python3-paho-mqtt python3-ujson python3-ephem python3-requests
RUN wget "http://www.weewx.com/downloads/released_versions/python3-weewx_${WEEWX_VERSION}-1_all.deb" && \
    dpkg -i "python3-weewx_${WEEWX_VERSION}-1_all.deb" || apt-get -y --no-install-recommends -f install && \
    wget -O weewx-influx.zip https://github.com/matthewwall/weewx-influx/archive/master.zip && wee_extension --install weewx-influx.zip && \
    wget -O weewx-mqtt.zip https://github.com/matthewwall/weewx-mqtt/archive/master.zip && wee_extension --install weewx-mqtt.zip && \
    wget -O weewx-owm.zip https://github.com/matthewwall/weewx-owm/archive/master.zip && wee_extension --install weewx-owm.zip && \
    wget -O weewx-prompush.tar.gz https://github.com/sulrich/weewx-prompush/archive/v1.0.0.tar.gz && wee_extension --install weewx-prompush.tar.gz && \
    apt-get clean && rm -rf /tmp/setup /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /etc/weewx /var/www/html/weewx /var/lib/weewx

CMD /usr/bin/weewxd /etc/weewx/weewx.conf