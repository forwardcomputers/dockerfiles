FROM gitpod/workspace-full

USER root
RUN apt-get update \
&&  apt-get -y install docker.io \
&&  apt-get clean \
&&  apt-get -y autoremove \
&&  apt-get -y clean \
&&  rm -rf /var/cache/apt/* \
&&  rm -rf /var/lib/apt/lists/* \
&&  rm -rf /tmp/*
