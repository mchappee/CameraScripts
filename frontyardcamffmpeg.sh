#!/bin/bash

if [ -d /video/FrontyardCam ]; then
  echo
else
  mkdir /video/FrontyardCam
fi

while :
do
  fname=`date "+%Y-%m-%d-%H:%M:%S"`

#/usr/bin/php /video/api/rebuildrtmp.php FrontyardCam >> /video/rebuild.log  2>&1
#  /usr/bin/php /video/api/create_endpoint.php FrontyardCamRTMP >> /video/rebuild.log  2>&1

  ffmpeg -y -i rtsp://admin:b5a42lsh@192.168.1.190:554/cam/realmonitor\?channel=1\&subtype=0 -c:v copy -c:a aac -t 1800 -map 0:v -bsf:v dump_extra -fflags +genpts -flags +global_header -movflags +faststart -map_metadata 0 -metadata title= -f tee -filter_complex aevalsrc=0 /video/FrontyardCam/$fname'.enc.mp4|[f=flv]rtmp://192.168.1.226/LiveApp/FrontyardCamRTMP'

mv /video/FrontyardCam/$fname.enc.mp4 /video/FrontyardCam/$fname.large.mp4
/usr/bin/php /video/api/rebuildrtmp.php FrontyardCam >> /mnt/video/rebuild.log  2>&1
/usr/bin/php /video/api/create_endpoint.php FrontyardCamRTMP >> /mnt/video/rebuild.log  2>&1

done

