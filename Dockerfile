FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Cylo.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="cylo"

# environment variables
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

RUN \
  echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libffi-dev \
	openssl-dev \
	py2-pip \
	python2-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	ca-certificates \
	curl \
	libressl2.6-libssl \
	openssl \
	p7zip \
	unrar \
	libcap \
	unzip && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	deluge && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	incremental \
	pip && \
 pip install --no-cache-dir -U \
	crypto \
	mako \
	markupsafe \
	pyopenssl \
	service_identity \
	six \
	twisted \
	zope.interface && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf /root/.cache && \
 wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && \
 gunzip GeoIP.dat.gz && \
 mkdir -p /usr/share/GeoIP && \
 mv GeoIP.dat /usr/share/GeoIP/GeoIP.dat

# add local files
COPY root/ /
RUN mkdir /configs
COPY configs /configs
RUN chmod +x /Entrypoint.sh

RUN setcap cap_net_bind_service=+ep /usr/bin/python2.7

# ports
EXPOSE 80 58846 58946 58946/udp

ENTRYPOINT /Entrypoint.sh