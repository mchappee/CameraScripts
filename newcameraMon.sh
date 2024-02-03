#!/bin/bash

cams=("PastureCam" "ChickenCam" "WorkshopCam" "PondCam", "GardenCam", "BackyardCam", "FronyardCam")

while :
do
  for i in "${cams[@]}"
  do
    now=`date +%s`
    now=$(( $now - 300 ))
    latest=`ls -t $i | head -1`
#    echo Testing $i / $latest
    sleep 1

#    fdate=`stat -f%c $i$latest`
     fdate=`stat --format %Y $i$latest`

    if [ $now -gt $fdate ]; then
      ffmpegPID=`ps -ax | grep $i | grep ffmpeg | grep -v grep | awk '{print $1}'`
      camname=`echo $i | sed 's/\///'`
      echo "Killing $i camera on $ffmpegPID fdate=$fdate now=$now" >> /video/cameraMon.log
      echo "Stopping stream: curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/stop" >> /video/cameraMon.log
      curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/stop
      sleep 5
      echo "Starting stream: curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/start" >> /video/cameraMon.log
      curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/start
      sleep 2
      kill -9 $ffmpegPID
      echo kill -9 $ffmpegPID
    fi

  done

  sleep 5
  /usr/bin/php /video/api/create_endpoint.php PastureCamRTMP
  /usr/bin/php /video/api/create_endpoint.php ChickenCamRTMP
  /usr/bin/php /video/api/create_endpoint.php PondCamRTMP
  /usr/bin/php /video/api/create_endpoint.php GardenCamRTMP

done

