FROM opencoconut/ffmpeg

RUN apk add --update \
    python \
    py-pip 
RUN pip install --upgrade pip; \
    pip install awscli

RUN mkdir -p ${HOME}/.aws

#workdir
ENV WD /IPCamRec
WORKDIR ${WD}

#environment
ENV LOG "-loglevel panic"
ENV RECORDS_PATH ${WD}/parts
ENV DIST ${WD}/dist
ENV URL rtsp://user:pass@host:port/live/ch00_0
ENV FFMEPG ffmpeg 
ENV S3_BUCKET ""

# cron jobs
RUN crontab -l > mycron
RUN echo "*/15 * * * * sh ${WD}/scripts/sync.sh >> ${WD}/log/sync.log 2>> ${WD}/log/sync.error.log" >> mycron
RUN echo "*/30 * * * * sh ${WD}/scripts/concat.sh >> ${WD}/log/concat.log 2>> ${WD}/log/concat.error.log" >> mycron
RUN echo "*/5 * * * * sh ${WD}/scripts/keepLatest.sh ${RECORDS_PATH} 400 >> ${WD}/log/keepLatest.log 2>> ${WD}/log/keepLatest.error.log" >> mycron
RUN crontab mycron
RUN rm mycron

#timezone
#??

RUN echo "[default]\n\
aws_access_key_id = ${AWS_ACCESS_KEY_ID}\n\
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ${HOME}/.aws/credentials

RUN echo "[default]\n\
region = eu-west-1" > ${HOME}/.aws/config

#sources
RUN mkdir -p ${WD}/log ${WD}/scripts
COPY scripts scripts

ENTRYPOINT ["sh", "scripts/entrypoint.sh"]