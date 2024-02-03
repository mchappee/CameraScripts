#!/bin/bash

while :
do

  while test -f "./pause"; do
    sleep 2
  done

  fname=`date "+%Y-%m-%d-%H:%M:%S"`

  ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.53:554/h264Preview_01_main -c:v copy -c:a copy -t 1800 -s 1280x720 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map 0:a -map_metadata 0 -metadata title= -f tee /video/WorkshopCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/WorkshopCamRTMP' 2> /video/logs/workshopcamffmpeg.err


  mv /video/WorkshopCam/$fname.enc.mp4 /video/WorkshopCam/$fname.large.mp4
  /usr/bin/php /video/api/rebuildrtmp.php WorkshopCam >> /video/rebuild.log  2>&1

  while test -f "./pause"; do
    sleep 2
  done

done

