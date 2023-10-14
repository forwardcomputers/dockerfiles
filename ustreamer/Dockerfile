#
#APPNEW curl -sL "https://api.github.com/repos/pikvm/ustreamer/tags" | jq -r '.[0].name[1:]'
#
FROM alpine:latest as build
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
RUN apk add --no-cache \
		alpine-sdk \
		linux-headers \
		libjpeg-turbo-dev \
		libevent-dev \
		libbsd-dev \
		libgpiod-dev
#
WORKDIR /opt
RUN git clone https://github.com/pikvm/ustreamer \
&&  make -C ustreamer
#
#
#
FROM alpine:latest as run
RUN apk add --no-cache \
		libevent \
		libjpeg-turbo \
		libevent \
		libgpiod \
		libbsd \
		v4l-utils \
#
# Clean-up
#
&&  rm -rf \
    /etc/apk \
    /lib/apk \
    /sbin/apk \
    /usr/share/apk \
    /var/lib/apk
#
COPY --from=build /opt/ustreamer/src/ustreamer.bin /usr/local/bin/ustreamer
EXPOSE 8080
