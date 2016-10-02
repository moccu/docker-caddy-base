FROM alpine:3.4

LABEL caddy-version=0.9.3

RUN mkdir -p /caddy /web \
	&& addgroup -g 1000 -S caddy \
	&& adduser -S -D -G caddy -u 1000 -h /caddy caddy \
	&& chown -R caddy:caddy /caddy /web \
	&& apk add --update --no-cache --virtual .deps tar curl \
	&& apk add --update --no-cache tini \
	&& curl --silent --show-error --fail --location \
		--header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
		-o caddy.tar.gz \
        "https://github.com/mholt/caddy/releases/download/v0.9.3/caddy_linux_amd64.tar.gz" \
	&& echo "221c95ea39176d78c2be116fa8e1760e3ab10353b7fe11ad91d764f4af49ca62  caddy.tar.gz" > checksum \
	&& sha256sum -c checksum \
	&& tar --no-same-owner -C /usr/bin/ -xzf caddy.tar.gz caddy_linux_amd64 \
	&& rm caddy.tar.gz checksum \
	&& mv /usr/bin/caddy_linux_amd64 /usr/bin/caddy \
	&& apk del .deps

ENTRYPOINT ["/sbin/tini"]
