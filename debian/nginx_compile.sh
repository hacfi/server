#!/bin/bash

set -eu

NGINX_VERSION="1.7.10"
BUILD_DEPS="gcc make libpcre3-dev libssl-dev uuid-dev"

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -qy -t ">= 1.0.1" libssl1.0.0
DEBIAN_FRONTEND=noninteractive apt-get install -qy curl ca-certificates $BUILD_DEPS --no-install-recommends

mkdir -p /usr/local/src/nginx/nginx-x-rid-header
# mkdir -p /usr/local/src/nginx /usr/local/src/nginx_modules/nginx-x-rid-header

cd /usr/local/src/

curl http://nginx.org/keys/mdounin.key | gpg --import
curl -SL "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" -o nginx.tar.gz
curl -SL "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc" -o nginx.tar.gz.asc
gpg --verify nginx.tar.gz.asc
# tar xzvf nginx.tar.gz
tar xf nginx.tar.gz -C /usr/local/src/nginx --strip-components=1
rm nginx.tar.gz*

curl -SL "https://github.com/glowdigitalmedia/nginx-x-rid-header/archive/ubuntu.tar.gz" | tar xv -C /usr/local/src/nginx/nginx-x-rid-header --strip-components=1
# cd /usr/local/src/nginx_modules
# curl -SL "https://github.com/glowdigitalmedia/nginx-x-rid-header/archive/ubuntu.tar.gz" | tar xzv
#     mv nginx-x-rid-header-ubuntu nginx-x-rid-header

cd /usr/local/src/nginx

sed -i "s/static char ngx_http_server_string\[\] = \"Server: nginx\" CRLF;/static char ngx_http_server_string\[\] = \"Server: LINEAVI\" CRLF;/g" src/http/ngx_http_header_filter_module.c
sed -i "s/static char ngx_http_server_full_string\[\] = \"Server: \" NGINX_VER CRLF;/static char ngx_http_server_full_string\[\] = \"Server: LINEAVI\" CRLF;/g" src/http/ngx_http_header_filter_module.c


./configure \
    --prefix=/etc/nginx/ \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/nginx.lock \
    --user=www-data \
    --group=www-data \
    --with-file-aio \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_spdy_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --add-module=nginx-x-rid-header \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wno-unused-parameter -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-luuid -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
    --with-cpu-opt=amd64 \
    --with-pcre

make
make install


sed -i 's/application\/font-woff\s*woff;.*$/application\/font-woff woff;application\/x-font-ttf ttc ttf;/' /etc/nginx/mime.types
# RUN sed -i 's/root\s*html;.*$/root \/var\/www;autoindex on;/' /etc/nginx/nginx.con
# RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# rm -rf /etc/nginx/html /usr/local/src/nginx /usr/local/src/nginx_modules /var/lib/apt/lists/*

DEBIAN_FRONTEND=noninteractive apt-get purge -qy $BUILD_DEPS
apt-get -qy autoremove

# RUN ln -sf /dev/stdout /var/log/nginx/access.log
# RUN ln -sf /dev/stderr /var/log/nginx/error.log

# CMD ["/usr/sbin/nginx"]

# EXPOSE 80 443

# ADD config/conf.d/ /etc/nginx/conf.d/
# ADD config/sites-enabled/ /etc/nginx/sites-enabled/
# ADD config/nginx.conf /etc/nginx/

# ADD release.tgz /var/www/
# RUN chown -R www-data:www-data /var/www

# VOLUME ["/var/cache/nginx"]
