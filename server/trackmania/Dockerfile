FROM evoesports/trackmania:latest

COPY --chown=trackmania:trackmania maplist.txt /server/UserData/Maps/MatchSettings/

RUN curl -sSLf -o /tmp/scripts.zip https://git.virtit.fr/beu/TM2020-Gamemodes/archive/master.zip \
    && mkdir -p /server/UserData/Scripts/Modes \
    && unzip /tmp/scripts.zip -d /tmp \
    && mv /tmp/tm2020-gamemodes /server/UserData/Scripts/Modes/TM2020-Gamemodes \
    && rm /tmp/scripts.zip
