#APPNEW apk

FROM alpine:latest as build

RUN apk add --no-cache \
		alpine-sdk \
		linux-headers \
		libjpeg-turbo-dev \
		libevent-dev \
		libbsd-dev \
		libgpiod-dev

WORKDIR /build/ustreamer/
COPY . .

FROM alpine:latest as run

RUN apk add --no-cache \
		libevent \
		libjpeg-turbo \
		libevent \
		libgpiod \
		libbsd \
		v4l-utils

WORKDIR /ustreamer
COPY --from=build /build/ustreamer/src/ustreamer.bin ustreamer

EXPOSE 8080
ENTRYPOINT ["./ustreamer", "--host=0.0.0.0"]
