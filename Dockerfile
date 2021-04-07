FROM jrottenberg/ffmpeg:4.1-alpine 


RUN apk add --update \
    py-pip \
    perl \
    coreutils
RUN apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1

RUN pip install --upgrade pip; \
    pip install awscli

# VPN
# RUN mkdir -p /etc/vpn
# WORKDIR /etc/vpn
# RUN apk add openvpn
# RUN wget https://www.ipvanish.com/software/configs/configs.zip
# RUN unzip configs.zip 
# COPY ovpn.user.ignore.conf /etc/vpn/ovpn.user.conf

# sources
ENV WD /streams
WORKDIR ${WD}
RUN mkdir -p ${WD}/log ${WD}/scripts

# environment
ENV LOG_LEVEL "warning"
ENV RECORDS_PATH ${WD}/parts
ENV DIST ${WD}/dist
ENV FFMEPG ffmpeg 
ENV S3_BUCKET ""
ENV S3_STORAGE_TYPE "ONEZONE_IA"
ENV REC_KEY ""
ENV FFMPEG_PARAMS "-i rtsp://user:pass@host:port/live/ch00_0"
ENV CLEAN_AGO "15 day ago"
ENV EXPIRATION ""
ENV CHUNK_SECONDS "3600"
ENV VPN "no"
# sources
COPY scripts scripts

HEALTHCHECK --interval=60s --timeout=3s \
  CMD sh ${WD}/scripts/healthcheck.sh || exit 1

ENTRYPOINT ["sh", "scripts/entrypoint.sh"]