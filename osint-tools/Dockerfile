ARG BASE_IMAGE=core-ubuntu-noble \
    BASE_TAG=1.18.0-rolling-daily
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update \
    && apt-get install -y sudo openjdk-17-jre \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/*

ADD ./download_zaproxy.sh $INST_SCRIPTS/download_zaproxy.sh
RUN chmod +x $INST_SCRIPTS/download_zaproxy.sh && $INST_SCRIPTS/download_zaproxy.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
