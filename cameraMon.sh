#!/bin/bash

cams=("PastureCam" "ChickenCam" "WorkshopCam" "PondCam" "FrontyardCam" "GardenCam")

while :
do
  for i in "${cams[@]}"
  do 
    now=`date +%s`
    now=$(( $now - 10 ))
    latest=`ls -t $i/ | head -1`
    echo Testing $i / $latest
    sleep 1

#    fdate=`stat -f%c $i$latest`
     fdate=`stat --format %Y $i/$latest`

    if [ $now -gt $fdate ]; then
      echo "ps -ax | grep $i | grep RTMP | grep -v grep | awk '{print $1}'"
      ffmpegPID=`ps -ax | grep $i | grep RTMP | grep -v grep | awk '{print $1}'`
      camname=`echo $i/ | sed 's/\///'`
      echo "Killing $i/ camera on $ffmpegPID fdate=$fdate now=$now" >> /video/cameraMon.log
      #echo "Stopping stream: curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/stop" >> /video/cameraMon.log
      #curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/stop
      #sleep 5
      #echo "Starting stream: curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/start" >> /video/cameraMon.log
      #curl -u mchappee:b5a42lsh -X POST http://localhost:5080/WebRTCApp/rest/v2/broadcasts/$camname/start
      #sleep 2
      kill -s INT $ffmpegPID
      echo kill -s INT $ffmpegPID
    fi

  done

#  sh archiver.sh
  sleep 10

done

