#!/bin/bash

cd /video
mkdir GardenCam

while :
do
  fname=`date "+%Y-%m-%d-%H:%M:%S"`

#ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.165:554/cam/realmonitor\?channel=1\&subtype=0 -c:v copy -c:a aac -t 1800 /video/GardenCam/$fname.enc.mp4

ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.166:554/cam/realmonitor\?channel=1\&subtype=0 -c:v copy -c:a aac -t 1800 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map_metadata 0 -metadata title= -f tee -filter_complex aevalsrc=0 /video/GardenCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/GardenCamRTMP'

mv /video/GardenCam/$fname.enc.mp4 /video/GardenCam/$fname.large.mp4
/usr/bin/php /video/api/rebuildrtmp.php GardenCam >> /video/rebuild.log  2>&1
/usr/bin/php /video/api/create_endpoint.php GardenCamRTMP >> /video/rebuild.log  2>&1

done

