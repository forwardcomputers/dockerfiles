#
#APPNEW curl -sL "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | jq -r '.tag_name[1:]'
#
# Alpine image
FROM alpine:latest AS alpine
#
RUN apk update && apk add jq && rm -rf /var/cache/apk/* \
&&  arch="$(uname -m)" \
&&  url_base='https://github.com/koalaman/shellcheck/releases/download/' \
&&  tag=$( wget -qO- "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | jq -r '.tag_name' ) \
&&  tar_file="${tag}/shellcheck-${tag}.linux.${arch}.tar.xz" \
&&  wget -q "${url_base}${tar_file}" -O - | tar xJf - \
&&  mv "shellcheck-${tag}/shellcheck" /bin/ \
&&  rm -rf "shellcheck-${tag}"
#
# Resulting ShellCheck image
FROM scratch
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
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
WORKDIR /mnt
COPY --from=alpine /bin/shellcheck /bin/
ENTRYPOINT ["/bin/shellcheck"]
