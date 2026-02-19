ARG BASE_IMAGE=core-ubuntu-noble \
    BASE_TAG=1.18.0-rolling-daily
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN curl -s "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html" \
    | grep -oP 'https?://downloads.citrix.com/[0-9]+/(icaclient|ctxusb)[0-9.]+_amd64.deb?[^"]+' \
    | while read -r url; do fname="$(echo "$url" | sed 's#.*/##;s/?__gda__.*//')"; echo "Downloading $fname"; curl -L -o "$fname" "$url"; done; \
    apt install -y ./icaclient*.deb ./ctxusb*.deb; \
    rm -f ./icaclient*.deb ./ctxusb*.deb; \
    apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
