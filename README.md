# clone
```PowerShell
git clone https://github.com/toastmasters-d67/tmd67-data
git clone https://github.com/toastmasters-d67/tmd67-be
git clone https://github.com/toastmasters-d67/tmd67-be-sdk
```

# start
```PowerShell
docker-compose up -d
```

# down 
```PowerShell
docker-compose down -v --remove-orphans
```
# 環境變數
| 名稱                  | 值                                                    | 模組 | 註            |
|---------------------|------------------------------------------------------| --- |--------------|
| LOGOUT_REDIRECT_URL | http://gw.tmd67.com                                  | 系統 | 支付後，追加 `/me` |
| LOGIN_REDIRECT_URL  | http://gw.tmd67.com/me                               | 系統 | 登入後的頁面       |
| API_BASE_URL        | http://api.tmd67.com/                                | 系統 | API 根路勁      |
| MerchantID          | MS12345678                                           | Payment | 藍新           |
| HashKey             | AAAvw3YlqoEk6G4HqRKDAYpHKZWxBBB                      | Payment | 藍新           |
| HashIV              | AAAC1FplieBBB                                        | Payment | 藍新           |
| Version             | 2.0                                                  | Payment | 藍新           |
| MPG_GW              | https://ccore.newebpay.com/MPG/mpg_gateway           | Payment | 藍新           |
| ItemDesc            | 2023 Annual Conference Ticket                        | Payment | 藍新           |
| RETURN_URL          | http://api.tmd67.com/payment-records/neweb-pay-return/ | Payment | 藍新           |
| NOTIFY_URL          | http://api.tmd67.com/payment-records/neweb-pay-return/ | Payment | 藍新           |
| GG_CLIENT_ID        | fmoirt.apps.googleusercontent.com                    | Google | Google       |
| GG_CLIENT_SECRET    | U18cIQr0Nb5EEE                                       | Google | Google       |
| GG_REDIRECT_URI     | https://api.tmd67.com/google/callback/               | Google | Google       |

# Network
Edit file `C:\Windows\System32\drivers\etc\hosts` and add content like:
```text
127.0.0.1 api.tmd67.com
127.0.0.1 api.tmd67.com
```

# Test web site
http://gw.tmd67.com

# build & run individual image
## tmd67 gateway
### build
```PowerShell
cd tmd67-gw/
docker build -t gw-tmd67 .
```
### run
```PowerShell
docker network create --subnet=172.19.0.0/16 tmd-net
docker run -d -p 80:80 -p 222:22 -v C:\Users:/data --name gw-tmd67 --net tmd67 --ip 172.19.0.4 gw-tmd67
```

## tmd67 api
### CMD run
```PowerShell
python manage.py migrate
python manage.py loaddata tmd67_be/ac/data/ticket_product.json
python manage.py loaddata ../tmd67-data/data.json
```

### build
```PowerShell
docker build -t api-tmd67 .
```
### docker run
```PowerShell
docker network create --subnet=172.19.0.0/16 tmd-net
docker run -d --name api-tmd67 --net tmd67 --ip 172.18.0.3 api-tmd67
```

## tmd67 db
### run
```PowerShell
docker network create --subnet=172.19.0.0/16 tmd-net
docker run -d -p 5432:5432 `
    -e POSTGRES_PASSWORD=tmd+123 `
    -e POSTGRES_USER=tmdadm `
    -e POSTGRES_DB=tmd67 `
    -e POSTGRES_HOST_AUTH_METHOD=trust `
    -e PGDATA=/var/lib/postgresql/data/pgdata `
    -v D:\postgres11:/var/lib/postgresql/data:Z `
    --name postgres `
    --net tmd-net `
    --ip 172.19.0.10 `
    postgres:11-alpine```
```

# gateway intro
```yaml

server {
        server_name example.com;

        location = /favicon.ico {
                access_log off;
                log_not_found off;
        }

        location /static/ {
                alias /home/example/data/static/;
        }

        location /media/ {
                alias /home/example/data/media/;
        }

        location / {
                proxy_pass http://127.0.0.1:8000;
        }

        listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

```
# app intro
# db intro
