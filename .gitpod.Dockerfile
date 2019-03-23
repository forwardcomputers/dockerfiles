FROM gitpod/workspace-full

RUN apt-get update \
&&  apt-get -y install docker.io \
&&  apt-get clean \
&&  apt-get -y autoremove \
&&  apt-get -y clean \
&&  rm -rf /var/lib/apt/lists/* \
&&  rm -rf /var/cache/apt/* \
&&  rm -rf /tmp/*
