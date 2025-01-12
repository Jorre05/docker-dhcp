FROM alpine:latest

MAINTAINER github.com/jorre05
LABEL Description="kea-dhcp Docker image."

ENV DHCP4_SERVER=true
ENV DHCP6_SERVER=false
ENV GITHUB_REPO=

RUN apk --no-cache add kea-dhcp4 kea-dhcp-ddns bash tzdata git

COPY kea.sh /etc/kea/

CMD ["/bin/bash", "/etc/kea/kea.sh"]
