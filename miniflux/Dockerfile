#
#APPNEW curl -sL "https://api.github.com/repos/miniflux/v2/commits/main" | jq -r '.sha'
#
FROM golang:latest AS build
ENV CGO_ENABLED=0
ADD . /go/src/app
WORKDIR /go/src/app

RUN git clone https://github.com/miniflux/v2 /miniflux.app/v2 \
&&  ls -la \
&&  pwd \
&&  go build \
    -o miniflux \
    -ldflags="-s -w -X 'miniflux.app/v2/internal/version.Version=`git describe --tags --abbrev=0`' -X 'miniflux.app/v2/internal/version.Commit=`git rev-parse --short HEAD`' -X 'miniflux.app/v2/internal/version.BuildDate=`date +%FT%T%z`'" \
    main.go

FROM gcr.io/distroless/base:nonroot

LABEL   org.opencontainers.image.title=Miniflux \
        org.opencontainers.image.description="Miniflux is a minimalist and opinionated feed reader" \
        org.opencontainers.image.vendor="Frédéric Guillot" \
        org.opencontainers.image.licenses=Apache-2.0 \
        org.opencontainers.image.url=https://miniflux.app \
        org.opencontainers.image.source=https://github.com/miniflux/v2 \
        org.opencontainers.image.documentation=https://miniflux.app/docs/ \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}"

EXPOSE 8080
ENV LISTEN_ADDR 0.0.0.0:8080
COPY --from=build /go/src/app/miniflux /usr/bin/miniflux
CMD ["/usr/bin/miniflux"]
