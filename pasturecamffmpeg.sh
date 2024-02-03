#!/bin/bash

while :
do

  while test -f "./pause"; do
    sleep 2
  done

  fname=`date "+%Y-%m-%d-%H:%M:%S"`

  ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.192:554/h264Preview_01_main -c:v copy -c:a copy -t 1800 -s 1280x720 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map 0:a -map_metadata 0 -metadata title= -f tee /video/PastureCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/PastureCamRTMP' 2> /video/logs/pasturecamffmpeg.err

  mv /video/PastureCam/$fname.enc.mp4 /video/PastureCam/$fname.large.mp4
  /usr/bin/php /video/api/rebuildrtmp.php PastureCam >> /video/rebuild.log  2>&1
  /usr/bin/php /video/api/create_endpoint.php PastureCamRTMP >> /video/rebuild.log  2>&1

done

