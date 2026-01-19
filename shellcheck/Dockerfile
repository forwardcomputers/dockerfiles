#
#APPNEW curl -sL "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | jq -r '.tag_name[1:]'
#
# Alpine image
FROM alpine:latest
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
# Install application
#
RUN url_base='https://github.com/koalaman/shellcheck/releases/download/' \
&&  tag=$( wget -qO- "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' ) \
&&  tar_file="${tag}/shellcheck-${tag}.linux.x86_64.tar.xz" \
&&  wget -qO- "${url_base}${tar_file}" | tar -xJC /bin --strip-components=1 "shellcheck-${tag}/shellcheck" \
#
# Clean-up
#
&& rm -rf \
   /etc/apk \
   /lib/apk \
   /sbin/apk \
   /usr/share/apk \
   /var/lib/apk
#
WORKDIR /mnt
ENTRYPOINT ["/bin/shellcheck"]

