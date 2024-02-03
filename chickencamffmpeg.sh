#!/bin/bash

while :
do

  while test -f "./pause"; do
    sleep 2
  done

  fname=`date "+%Y-%m-%d-%H:%M:%S"`

/usr/bin/php /video/api/rebuildrtmp.php ChickenCam >> /video/rebuild.log  2>&1
/usr/bin/php /video/api/create_endpoint.php ChickenCamRTMP >> /video/rebuild.log  2>&1

ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.251:554/h264Preview_01_main -use_wallclock_as_timestamps 1 -c:v copy -c:a copy -s 1280x720 -t 1800 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map 0:a -map_metadata 0 -metadata title= -f tee /video/ChickenCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/ChickenCamRTMP' 2> /video/logs/chickencamffmpeg.err

#  ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.121:1024/h264Preview_01_main -c:v copy -c:a copy -t 1800 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map_metadata 0 -metadata title= -f tee -filter_complex aevalsrc=0 /video/ChickenCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.204/LiveApp/ChickenCamRTMP'

#  ffmpeg -i rtsp://admin:b5a42lsh@192.168.1.121:1024/h264Preview_01_main -s 1152x648 -bufsize 5000k -loglevel error -t 1800 -c:v copy /video/ChickenCam/$fname.enc.mp4 2> /video/chickencam.err 1> /video/chickencam.out

  mv /video/ChickenCam/$fname.enc.mp4 /video/ChickenCam/$fname.large.mp4
  /usr/bin/php /video/api/rebuildrtmp.php ChickenCam >> /video/rebuild.log  2>&1
  /usr/bin/php /video/api/create_endpoint.php ChickenCamRTMP >> /video/rebuild.log  2>&1

  while test -f "./pause"; do
    sleep 2
  done

done

