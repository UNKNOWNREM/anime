# karikari

## Requirements

- Linux (e.g. Fedora)
- nginx 1.20+
- Node.js 16+
- [pm2](https://www.npmjs.com/package/pm2)
- MariaDB 10.2+
- elasticsearch 5.0+
- rutorrent
- ffmpeg
- [anilist-crawler](https://github.com/soruly/anilist-crawler)
- [anilist-chinese](https://github.com/soruly/anilist-chinese)

## Setup

1. copy `.env.example` and rename to `.env`
2. Modify `.env` to update settings as your need
3. restore database sql
4. import database dump of anilist-chinese
5. create index "anilist" in elasticsearch
5. use anilist-crawler to fill in the anilist table and "anilist" index in elasticsearch
6. `npm run build-mobile` and `npm run build-desktop`
7. `npm run start` (Read package.json for all available command)
8. start rutorrent docker
9. visit the /admin/ page, setup download rules

rutorrent
```
docker run --name=bt \
  -v /home/you/bt:/config \
  -v /mnt/data/download:/download \
  -v /mnt/data/add:/add \
  -e PGID=1000 -e PUID=1000 \
  -e TZ=Etc/UTC \
  -p 10008:80 \
  -p 10001:10001 -p 10001:10001/udp \
  --restart always \
  linuxserver/rutorrent:v3.10-ls122
```

nginx config
```
server {
  listen       443 ssl http2;
  server_name  your.host;

  # include ssl.conf;
  ssl_certificate /etc/nginx/cert/your.host/cert.pem;
  ssl_certificate_key /etc/nginx/cert/your.host/key.pem;
  ssl_trusted_certificate /etc/nginx/cert/your.host/ca.pem;

  location / {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header Host      $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  location ~ \.(mp4|ass|txt)$ {
    send_timeout 30m;
    keepalive_timeout 30m;
    limit_rate_after 4m;
    limit_rate       1000k;
    add_header Access-Control-Allow-Origin '*';
    root "/mnt/data/anime";
  }

  location ^~ /admin/ {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header Host      $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location /admin/anilist/ {
      proxy_pass http://127.0.0.1:9200/anilist/;
    }
  }
}
```
