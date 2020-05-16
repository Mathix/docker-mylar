FROM lsiobase/python:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MYLAR_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install system packages ****" && \
 apk add --no-cache \
	git \
	nodejs && \
 echo "**** install pip packages ****" && \
 echo "**** install app ****" && \
 if [ -z ${MYLAR_COMMIT+x} ]; then \
	MYLAR_COMMIT=$(curl -sX GET https://api.github.com/repos/mylar3/mylar3/commits/python3-dev \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 git clone https://github.com/mylar3/mylar3.git /app/mylar && \
 cd /app/mylar && \
 git checkout ${MYLAR_COMMIT} && \
 python -m ensurepip && \
 pip install --no-cache-dir -r requirements.txt && \
echo "**** cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090
