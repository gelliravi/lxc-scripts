## Start CONTAINERURL ##
upstream containerCONTAINERIDSUBID  {
      server CONTAINERIP:CONTAINERPORTSUBDIR;
}

server {
    listen    443 default_server;
    server_name  CONTAINERURL;
 
    ssl on;
    ssl_certificate /var/lib/certs/CONTAINERURL.crt;  
    ssl_certificate_key /var/lib/certs/CONTAINERURL.key;
    ssl_session_cache shared:SSL:10m;

    access_log  /var/log/nginx/log/CONTAINERURL.access.log;
    error_log  /var/log/nginx/log/CONTAINERURL.error.log;
    root   /usr/share/nginx/html;
    index  index.html index.htm;

    client_max_body_size 30M;
 
    ## send request back to lbs ##
    location / {
     proxy_pass  http://containerCONTAINERIDSUBID;
     proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
     proxy_redirect off;
     proxy_buffering off;
     proxy_set_header        Host            $host;
     proxy_set_header        X-Real-IP       $remote_addr;
     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
   }
}
## End CONTAINERURL ##