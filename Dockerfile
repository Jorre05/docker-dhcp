FROM alpine:latest

MAINTAINER github.com/jorre05
LABEL Description="DHCP (kea) Docker image."

RUN apk --no-cache add kea-dhcp4 kea-dhcp-ddns bash tzdata git

COPY dhcp.sh /tmp/dhcp.sh
CMD ["/bin/bash", "/tmp/dhcp.sh"]

