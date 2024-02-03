#!/bin/bash

while :
do

  while test -f "./pause"; do
    sleep 2
  done

  fname=`date "+%Y-%m-%d-%H:%M:%S"`

ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.134:1024/11 -use_wallclock_as_timestamps 1 -loglevel error -stats -c:v copy -c:a aac -t 1800 -s 1280x720 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map 0:a -map_metadata 0 -metadata title= -f tee /video/PondCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/PondCamRTMP' 2> /video/logs/pondcamffmpeg.err

  mv /video/PondCam/$fname.enc.mp4 /video/PondCam/$fname.large.mp4
  /usr/bin/php /video/api/rebuildrtmp.php PondCam >> /video/rebuild.log  2>&1
  /usr/bin/php /video/api/create_endpoint.php PondCamRTMP >> /video/rebuild.log  2>&1
 
  while test -f "./pause"; do
    sleep 2
  done

done

