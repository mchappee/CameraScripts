<?php

  $baseurl = "http://localhost:5080/LiveApp/rest/v2/vods/create";

  $files = scandir ("/video/.vod");
  
  foreach ($files as $file) {
    if (strstr ($file, "._") == false && $file != "." && $file != "..") {
      $filepath = "/video/.vod/" . $file;
      $url = $baseurl . "?name=" . urlencode ($file);

      $cfile = curl_file_create($filepath,"video/mp4", $file);

      $postdata = array ("file" => $cfile);

      $ch = curl_init();

      curl_setopt($ch, CURLOPT_URL, $url);
      curl_setopt($ch, CURLOPT_USERPWD, "mchappee:b5a42lsh");
      curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata);
      //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      //curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,  2);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
      curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: multipart/form-data"));

      $result = curl_exec ($ch);
      print $result . "\n\n";
    }
  }

?>

