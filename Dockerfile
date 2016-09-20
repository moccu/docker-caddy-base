FROM alpine:3.4

RUN mkdir -p /caddy/hosts /web \
	&& apk add --update --no-cache --virtual .deps tar curl \
	&& apk add --update --no-cache tini \
	&& curl --silent --show-error --fail --location \
		--header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
		-o - "https://github.com/mholt/caddy/releases/download/v0.9.1/caddy_linux_amd64.tar.gz" \
		| tar --no-same-owner -C /usr/bin/ -xz caddy_linux_amd64 \
	&& mv /usr/bin/caddy_linux_amd64 /usr/bin/caddy \
	&& apk del .deps

ENTRYPOINT ["/sbin/tini"]
