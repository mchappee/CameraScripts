<?php

  $streamid = "PastureCamRTMP";
  //$streamid = $argv[1];

  print "External: creating endpoint for $streamid \n";

  $url = "http://localhost:5080/LiveApp/rest/v2/broadcasts/$streamid/rtmp-endpoint";
  $rtmpurl = "rtmp://appmonster.org/LiveApp/$streamid";
  $ch = curl_init();

  $postarray = array ("rtmpUrl" => $rtmpurl);
  $postdata = json_encode ($postarray);

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee@me.com:b5a42lsh");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, trim($postdata));
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);
  print_r ($arr);


?>

