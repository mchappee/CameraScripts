#!/bin/bash

while :
do
  fname=`date "+%Y-%m-%d-%H:%M:%S"`

ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.172:554/cam/realmonitor\?channel=1\&subtype=0 -c:v copy -c:a copy -t 1800 /video/BackyardCam/$fname.enc.mp4

#  ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.171:554/cam/realmonitor\?channel=1\&subtype=0 -c:v h264 -c:a aac -t 1800 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map_metadata 0 -metadata title= -f tee -filter_complex aevalsrc=0 /video/BackyardCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.204/LiveApp/BackyardCamRTMP'

mv /video/BackyardCam/$fname.enc.mp4 /video/BackyardCam/$fname.large.mp4

#  /usr/bin/php /video/api/rebuildrtmp.php BackyardCamRTMP


done

