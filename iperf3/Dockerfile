#
#APPNEW apk
#
# Alpine image
FROM alpine:latest
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
# Install application
#
RUN apk add --no-cache \
    iperf3 \
&&  adduser -S iperf \
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
USER iperf
EXPOSE 5201/tcp 5201/udp
ENTRYPOINT [ "iperf3" ]
CMD [ "-s" ]
