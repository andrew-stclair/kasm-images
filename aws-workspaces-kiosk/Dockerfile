ARG BASE_IMAGE=core-ubuntu-noble \
    BASE_TAG=1.18.0-rolling-daily
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# URL the kiosk browser opens on startup
ENV AWS_WORKSPACES_URL=https://ap-southeast-2.webclient.amazonworkspaces.com

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && wget -q -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/google-chrome-stable_current_amd64.deb \
    && rm -f /tmp/google-chrome-stable_current_amd64.deb \
    && apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace the default session startup with our kiosk-only startup
COPY ./custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
