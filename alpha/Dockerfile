# Run tor browser in a container
#
# docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
#	-v /dev/snd:/dev/snd \
#	-v /dev/shm:/dev/shm \
#	-v /etc/machine-id:/etc/machine-id:ro \
#	-e DISPLAY=unix$DISPLAY \
#	westonsteimel/tor-browser:alpha
#

ARG VERSION="12.5a2"
ARG TOR_BROWSER_LANGUAGE="ALL"

FROM debian:stable-slim

ARG VERSION
ARG TOR_BROWSER_LANGUAGE

RUN apt-get update && apt-get install -y \
	ca-certificates \
	curl \
	dirmngr \
    ffmpeg \
	gnupg \
	libasound2 \
	libdbus-glib-1-2 \
	libgtk-3-0 \
	libxrender1 \
	libx11-xcb-dev \
	libx11-xcb1 \
	libxt6 \
    libpci-dev \
    libegl-dev \
	xz-utils \
	file \
    --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/tor
RUN useradd --create-home --home-dir $HOME tor \
	&& chown -R tor:tor $HOME

ENV LANG C.UTF-8

# https://www.torproject.org/projects/torbrowser.html.en
ENV TOR_BROWSER_VERSION="${VERSION}"
ENV TOR_FINGERPRINT="0x4E2C6E8793298290"
ENV TOR_BROWSER_LANGUAGE="${TOR_BROWSER_LANGUAGE}"

# download tor and check signature
RUN cd /tmp \
	&& curl -sSOL "https://dist.torproject.org/torbrowser/${TOR_BROWSER_VERSION}/tor-browser-linux64-${TOR_BROWSER_VERSION}_${TOR_BROWSER_LANGUAGE}.tar.xz" \
	&& curl -sSOL "https://dist.torproject.org/torbrowser/${TOR_BROWSER_VERSION}/tor-browser-linux64-${TOR_BROWSER_VERSION}_${TOR_BROWSER_LANGUAGE}.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& for server in $(shuf -e \
			ha.pool.sks-keyservers.net \
			hkp://p80.pool.sks-keyservers.net:80 \
			keyserver.ubuntu.com \
			hkp://keyserver.ubuntu.com:80 \
			pgp.mit.edu) ; do \
		gpg --no-tty --keyserver "${server}" --recv-keys ${TOR_FINGERPRINT} && break || : ; \
	done \
	&& gpg --fingerprint --keyid-format LONG ${TOR_FINGERPRINT} | grep "Key fingerprint = EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290" \
	&& gpg --verify tor-browser-linux64-${TOR_BROWSER_VERSION}_${TOR_BROWSER_LANGUAGE}.tar.xz.asc \
	&& tar -vxJ --strip-components 1 -C /usr/local/bin -f tor-browser-linux64-${TOR_BROWSER_VERSION}_${TOR_BROWSER_LANGUAGE}.tar.xz \
	&& rm -rf tor-browser* "$GNUPGHOME" \
	&& chmod -R 777 /usr/local/bin/Browser/ \
    && chown -R tor:tor /usr/local/bin/Browser/

# good fonts
COPY local.conf /etc/fonts/local.conf

WORKDIR $HOME
USER tor

ENTRYPOINT ["/bin/bash"]
CMD [ "/usr/local/bin/Browser/start-tor-browser", "--log", "/dev/stdout" ]

LABEL org.opencontainers.image.title="Tor Browser Alpha" \
    org.opencontainers.image.description="Tor Browser Alpha in Docker" \
    org.opencontainers.image.version="${VERSION}"

