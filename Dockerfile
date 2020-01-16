FROM alpine:latest
LABEL maintainer="Winston Astrachan"
LABEL description="ISC DHCP Server on Alpine Linux"

RUN apk --no-cache add dhcp
RUN mkdir /config

COPY overlay/ /
VOLUME /config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/dhcpd", "-4", \
                        "-f", \
                        "-cf", "/config/dhcpd.conf", \
                        "-lf", "/config/dhcpd.leases", \
                        "-user", "dhcp", \
                        "-group", "dhcp"]
