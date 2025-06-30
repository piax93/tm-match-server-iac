FROM php:8-cli

RUN  apt-get update && apt-get install -y libzip-dev curl unzip

RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

RUN  install-php-extensions curl zip mysqli

RUN curl -sSLf -o /tmp/maniacontrol.zip https://git.virtit.fr/beu/TrackManiaControl/archive/master.zip \
    && unzip /tmp/maniacontrol.zip -d / \
    && mv /trackmaniacontrol /maniacontrol \
    && rm /tmp/maniacontrol.zip

RUN curl -sSLf -o /tmp/plugins.zip https://git.virtit.fr/beu/ManiacontrolPlugins/archive/master.zip \
    && unzip /tmp/plugins.zip -d /tmp \
    && mkdir /maniacontrol/plugins/Beu \
    && mv /tmp/maniacontrolplugins/Beu/GameModeLoader.php /maniacontrol/plugins/Beu/ \
    && mv /tmp/maniacontrolplugins/Beu/GuestlistManager.php /maniacontrol/plugins/Beu/ \
    && mv /tmp/maniacontrolplugins/Beu/MoreModesTools.php /maniacontrol/plugins/Beu/ \
    && mv /tmp/maniacontrolplugins/MatchManagerSuite /maniacontrol/plugins/ \
    && rm -r /tmp/plugins.zip /tmp/maniacontrolplugins

COPY server.xml.php /maniacontrol/configs/
COPY --chmod=0755 run.sh /maniacontrol

WORKDIR /maniacontrol

CMD  ["/maniacontrol/run.sh"]
