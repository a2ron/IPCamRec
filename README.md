# IPCamRec
Docker image to save a video stream in a S3 Bucket.


# Container Environment
- URL: the stream source to record
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- S3_BUCKET
- RECORDS_PATH: `optional` the path where record the video parts during the record
- DIST: `optional` the path where to save the final video outputs when parts joined


# Run example
```bash
docker run -d \
  -e URL="http://user:pass@host:port/video_path" \
  -e AWS_ACCESS_KEY_ID="********************" \
  -e AWS_SECRET_ACCESS_KEY="****************************************" \
  -e RECORDS_PATH="/video/parts" \
  -e DIST="/video/dist" \
  -e S3_BUCKET="ip-cam-rec" \
  -v $PWD/parts:/video/parts \
  a2ron/ip-cam-rec
```