<?php

  if (isset ($argv[1]))
    $camarray = Array ($argv[1]);
  else
    $camarray = Array ("ChickenCam", "PastureCam", "WorkshopCam", "PondCam");

  $url = "http://localhost:5080/LiveApp/rest/v2/broadcasts/list/0/50";
  $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERPWD, "mchappee@me.com:b5a42lsh");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

    $result = curl_exec ($ch);
    $arr = json_decode ($result);
print_r ($arr);
    foreach ($camarray as $cam) {
      rebuildrtmp ($arr, $cam . "RTMP");
    }

function rebuildrtmp ($streamarray, $streamid) {
  foreach ($streamarray as $stream) {
    if ($stream->streamId == $streamid) {
      stop_remotestream ($streamid);
      delete_remotestream ($streamid);
      create_remotestream ($streamid);
      if (is_array ($stream->endPointList)) {
        foreach ($stream->endPointList as $endpoint) {
          delete_endpoint ($endpoint->endpointServiceId, $streamid);
        }
      }
        create_endpoint ($streamid);
    }
  }
}

function create_remotestream ($streamid) {
  print "creating $streamid on appmonster.org\n";

  $url = "https://appmonster.org:5443/LiveApp/rest/v2/broadcasts/create";
  $ch = curl_init();

  $postarray = array (
      "streamId" => $streamid,
      "name" => $streamid,
      "type" => "liveStream",
      "description" => $streamid);

  $postdata = json_encode ($postarray);

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_POST, TRUE);
  curl_setopt($ch, CURLOPT_POSTFIELDS, trim($postdata));
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);

  print_r ($arr);
  sleep (2);
}

function stop_remotestream ($streamid) {
  print "stopping $streamid on appmonster.org\n";

  $url = "https://appmonster.org:5443/LiveApp/rest/v2/broadcasts/$streamid/stop";
  $ch = curl_init();

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_POST, TRUE);
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);

  print_r ($arr);
  sleep (5);
}

function delete_remotestream ($streamid) {
  print "deleting $streamid on appmonster.org\n";

  $url = "https://appmonster.org:5443/LiveApp/rest/v2/broadcasts/$streamid";
  $ch = curl_init();

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);

  print_r ($arr);
  sleep (2);
}

function create_endpoint ($streamid) {

  print "creating endpoint for $streamid \n";

  $url = "http://localhost:5080/LiveApp/rest/v2/broadcasts/$streamid/rtmp-endpoint";
  $rtmpurl = "rtmp://appmonster.org/LiveApp/$streamid";
  $ch = curl_init();

  $postarray = array ("rtmpUrl" => $rtmpurl);
  $postdata = json_encode ($postarray);

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, trim($postdata));  
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);
  print_r ($arr);

}

function delete_endpoint ($endpointServiceId, $streamid) {
  print "deleting $endpointServiceId\n";

  $url = "http://localhost:5080/LiveApp/rest/v2/broadcasts/$streamid/rtmp-endpoint?endpointServiceId=$endpointServiceId";
  $ch = curl_init();

  $postarray = array ("endpointServiceId" => $endpointServiceId);
  $postdata = json_encode ($postarray);

  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));

  $result = curl_exec ($ch);
  $arr = json_decode ($result);

}


/*
    [endPointList] => Array
        (
            [0] => stdClass Object
                (
                    [status] => error
                    [type] => generic
                    [broadcastId] => 
                    [streamId] => 
                    [rtmpUrl] => rtmp://appmonster.org/LiveApp/ChickenCamRTMP
                    [name] => 
                    [endpointServiceId] => customGiWXer
                    [serverStreamId] => 
                )
*/
?>

