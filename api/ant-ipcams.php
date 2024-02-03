<?php

  $url = "http://localhost:5080/WebRTCApp/rest/v2/broadcasts/create?autoStart=true";
  
  $camarray = array (
    array ("name" => "ChickenCam", 
           "url" => "http://localhost:5080/WebRTCApp/streams/ChickenCam.m3u8"),
    array ("name" => "WorkshopCam",
           "url" => "http://localhost:5080/WebRTCApp/streams/WorkshopCam.m3u8"), 
    array ("name" => "PastureCam",
           "url" => "http://localhost:5080/WebRTCApp/streams/PastureCam.m3u8"),
    array ("name" => "Backyard",
           "url" => "http://localhost:5080/WebRTCApp/streams/Backyard.m3u8"),
    array ("name" => "DrivewayLow",
           "url" => "http://localhost:5080/WebRTCApp/streams/DrivewayLow.m3u8"),
    array ("name" => "DrivewayHigh",
           "url" => "http://localhost:5080/WebRTCApp/streams/DrivewayHigh.m3u8"));

  foreach ($camarray as $cam) {

    $postarray = array (
      "streamId" => $cam["name"],
      "name" => $cam["name"],
      "type" => "streamSource",
      "description" => $cam["name"],
      "streamUrl" => $cam["url"]);

    $postdata = json_encode ($postarray);

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
    curl_setopt($ch, CURLOPT_POSTFIELDS, trim($postdata));
    //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    //curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,  2);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

    $result = curl_exec ($ch);
    $arr = json_decode ($result);

    print_r ($arr);
  }

?>

