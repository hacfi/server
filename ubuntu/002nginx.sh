#!/bin/bash

# apt-get install -y zlib1g-dev
apt-get install -y build-essential
apt-get install -y libpcre3 zlib1g lsb-base adduser
apt-get install -t ">=2.14" -y libc6
apt-get install -t ">= 1.0.1" -y libssl1.0.0

mkdir -p /opt/nginx_modules

cd /opt
wget http://nginx.org/download/nginx-1.7.7.tar.gz
tar xzvf nginx-1.7.7.tar.gz


# https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz
cd /opt/nginx_modules
wget https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/ngx_devel_kit-0.2.19


# https://github.com/openresty/headers-more-nginx-module/
cd /opt/nginx_modules
wget https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/headers-more-nginx-module-0.25

# https://github.com/openresty/echo-nginx-module/
cd /opt/nginx_modules
wget https://github.com/openresty/echo-nginx-module/archive/v0.57.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/echo-nginx-module-0.57

# UPDATE MASTER?
# USE FOR UUID? - set_secure_random_alphanum
# https://github.com/openresty/set-misc-nginx-module/
cd /opt/nginx_modules
wget https://github.com/openresty/set-misc-nginx-module/archive/v0.26.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/set-misc-nginx-module-0.26


# https://github.com/glowdigitalmedia/nginx-x-rid-header/
cd /opt/nginx_modules
apt-get install -y libpcre3-dev uuid-dev
wget https://github.com/glowdigitalmedia/nginx-x-rid-header/archive/ubuntu.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/nginx-x-rid-header-ubuntu


# https://github.com/anomalizer/ngx_aws_auth/
cd /opt/nginx_modules
wget https://github.com/anomalizer/ngx_aws_auth/archive/1.1.1.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/ngx_aws_auth-1.1.1

# https://github.com/yaoweibin/nginx_upstream_check_module
cd /opt/nginx_modules
wget https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/nginx_upstream_check_module-master
cd /opt/nginx-1.7.7
patch -p1 < /opt/nginx_modules/nginx_upstream_check_module-master/check_1.7.5+.patch

# https://github.com/nginx-modules/ngx_http_var_request_speed/
cd /opt/nginx_modules
wget https://github.com/nginx-modules/ngx_http_var_request_speed/archive/v1.0.tar.gz -O - | tar xzv
# --add-module=/opt/nginx_modules/ngx_http_var_request_speed-1.0


# not yet
# https://github.com/cep21/healthcheck_nginx_upstreams/archive/master.tar.gz
# ADD SRC

# replace uuid?
# https://github.com/streadway/ngx_txid


cd /opt/nginx-1.7.7

# ./auto/configure \
./configure \
        --prefix=/etc/nginx/ \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
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
        --add-module=/opt/nginx_modules/ngx_devel_kit-0.2.19 \
        --add-module=/opt/nginx_modules/headers-more-nginx-module-0.25 \
        --add-module=/opt/nginx_modules/echo-nginx-module-0.57 \
        --add-module=/opt/nginx_modules/set-misc-nginx-module-0.26 \
        --add-module=/opt/nginx_modules/nginx-x-rid-header-ubuntu \
        --add-module=/opt/nginx_modules/ngx_aws_auth-1.1.1 \
        --add-module=/opt/nginx_modules/nginx_upstream_check_module-master \
        --add-module=/opt/nginx_modules/ngx_http_var_request_speed-1.0 \
        --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wno-unused-parameter -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
        --with-ld-opt='-luuid -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
        --with-cpu-opt=amd64 \
        --with-pcre

mkdir -p /var/cache/nginx
chown www-data: /var/cache/nginx

make
make install



# # Package
#
# # Pre-Built Packages for Stable version
# # echo "deb http://nginx.org/packages/ubuntu/ trusty nginx\ndeb-src http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list
#
# # OR
#
# # Pre-Built Packages for Mainline version
# # echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx\ndeb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list
#
# # wget http://nginx.org/keys/nginx_signing.key -O - | apt-key add -
# # apt-get update
# # apt-get install -y nginx
#
#
# # http://nginx.org/en/docs/configure.html
# # ./configure --help
#
#
# # ubuntu nginx 1.7.7
# # nginx version: nginx/1.7.7
# # built by gcc 4.8.2 (Ubuntu 4.8.2-19ubuntu1)
# # TLS SNI support enabled
# # configure arguments:
# # --prefix=/etc/nginx
# # --sbin-path=/usr/sbin/nginx
# # --conf-path=/etc/nginx/nginx.conf
# # --error-log-path=/var/log/nginx/error.log
# # --http-log-path=/var/log/nginx/access.log
# # --pid-path=/var/run/nginx.pid
# # --lock-path=/var/run/nginx.lock
# # --http-client-body-temp-path=/var/cache/nginx/client_temp
# # --http-proxy-temp-path=/var/cache/nginx/proxy_temp
# # --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp
# # --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp
# # --http-scgi-temp-path=/var/cache/nginx/scgi_temp
# # --user=nginx
# # --group=nginx
# # --with-http_ssl_module
# # --with-http_realip_module
# # --with-http_addition_module
# # --with-http_sub_module
# # --with-http_dav_module
# # --with-http_flv_module
# # --with-http_mp4_module
# # --with-http_gunzip_module
# # --with-http_gzip_static_module
# # --with-http_random_index_module
# # --with-http_secure_link_module
# # --with-http_stub_status_module
# # --with-http_auth_request_module
# # --with-mail
# # --with-mail_ssl_module
# # --with-file-aio
# # --with-http_spdy_module
# # --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'
# # --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed'
# # --with-ipv6
#
# # ubuntu nginx 1.6.2
# # nginx version: nginx/1.6.2
# # built by gcc 4.8.2 (Ubuntu 4.8.2-19ubuntu1)
# # TLS SNI support enabled
# # configure arguments:
# # --prefix=/etc/nginx
# # --sbin-path=/usr/sbin/nginx
# # --conf-path=/etc/nginx/nginx.conf
# # --error-log-path=/var/log/nginx/error.log
# # --http-log-path=/var/log/nginx/access.log
# # --pid-path=/var/run/nginx.pid
# # --lock-path=/var/run/nginx.lock
# # --http-client-body-temp-path=/var/cache/nginx/client_temp
# # --http-proxy-temp-path=/var/cache/nginx/proxy_temp
# # --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp
# # --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp
# # --http-scgi-temp-path=/var/cache/nginx/scgi_temp
# # --user=nginx
# # --group=nginx
# # --with-http_ssl_module
# # --with-http_realip_module
# # --with-http_addition_module
# # --with-http_sub_module
# # --with-http_dav_module
# # --with-http_flv_module
# # --with-http_mp4_module
# # --with-http_gunzip_module
# # --with-http_gzip_static_module
# # --with-http_random_index_module
# # --with-http_secure_link_module
# # --with-http_stub_status_module
# # --with-http_auth_request_module
# # --with-mail
# # --with-mail_ssl_module
# # --with-file-aio
# # --with-http_spdy_module
# # --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'
# # --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed'
# # --with-ipv6
#
# # debian nginx-full 1.4.2
# # --prefix=/usr/share/nginx
# # --conf-path=/etc/nginx/nginx.conf
# # --error-log-path=/var/log/nginx/error.log
# # --http-client-body-temp-path=/var/lib/nginx/body
# # --http-fastcgi-temp-path=/var/lib/nginx/fastcgi
# # --http-log-path=/var/log/nginx/access.log
# # --http-proxy-temp-path=/var/lib/nginx/proxy
# # --http-scgi-temp-path=/var/lib/nginx/scgi
# # --http-uwsgi-temp-path=/var/lib/nginx/uwsgi
# # --lock-path=/var/lock/nginx.lock
# # --pid-path=/run/nginx.pid
# # --with-pcre-jit
# # --with-debug
# # --with-file-aio
# # --with-http_addition_module
# # --with-http_dav_module
# # --with-http_geoip_module
# # --with-http_gzip_static_module
# # --with-http_image_filter_module
# # --with-http_realip_module
# # --with-http_secure_link_module
# # --with-http_spdy_module
# # --with-http_stub_status_module
# # --with-http_ssl_module
# # --with-http_sub_module
# # --with-http_xslt_module
# # --with-ipv6
# # --with-mail
# # --with-mail_ssl_module
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-auth-pam
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-dav-ext-module
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-echo
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-upstream-fair
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-syslog
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-cache-purge
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/ngx_http_pinba_module
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/ngx_http_substitutions_filter_module
# # --add-module=/usr/src/nginx/source/nginx-1.4.2/debian/modules/nginx-x-rid-header
# # --with-ld-opt=-lossp-uuid
# # --with-ld-opt=-lossp-uuid
#
#
# # os x 10.9.4 homebrew nginx 1.6.0
#
# # --prefix=/usr/local/Cellar/nginx/1.6.0_1
# # --with-http_ssl_module
# # --with-pcre
# # --with-ipv6
# # --sbin-path=/usr/local/Cellar/nginx/1.6.0_1/bin/nginx
# # --with-cc-opt='-I/usr/local/Cellar/pcre/8.35/include
# # -I/usr/local/Cellar/openssl/1.0.1h/include'
# # --with-ld-opt='-L/usr/local/Cellar/pcre/8.35/lib
# # -L/usr/local/Cellar/openssl/1.0.1h/lib'
# # --conf-path=/usr/local/etc/nginx/nginx.conf
# # --pid-path=/usr/local/var/run/nginx.pid
# # --lock-path=/usr/local/var/run/nginx.lock
# # --http-client-body-temp-path=/usr/local/var/run/nginx/client_body_temp
# # --http-proxy-temp-path=/usr/local/var/run/nginx/proxy_temp
# # --http-fastcgi-temp-path=/usr/local/var/run/nginx/fastcgi_temp
# # --http-uwsgi-temp-path=/usr/local/var/run/nginx/uwsgi_temp
# # --http-scgi-temp-path=/usr/local/var/run/nginx/scgi_temp
# # --http-log-path=/usr/local/var/log/nginx/access.log
# # --error-log-path=/usr/local/var/log/nginx/error.log
# # --with-http_gzip_static_module
# # --add-module=/usr/local/src/nginx-x-rid-header
#
# # http://mailman.nginx.org/pipermail/nginx-ru/2006-July/006876.html
#
#  ./auto/configure \
# ./configure \
#         --prefix=/etc/nginx/ \
#         --sbin-path=/usr/sbin/nginx \
#         --conf-path=/etc/nginx/nginx.conf \
#         --error-log-path=/var/log/nginx/error.log \
#         --pid-path=/var/run/nginx.pid \
#         --lock-path=/var/run/nginx.lock \
# #        --lock-path=/run/lock/nginx.lock \
#
#         --user=www-data \
# #        --user=nginx \
#         --group=www-data \
# #        --group=nginx \
#
#         --with-file-aio \
#         --with-ipv6 \
#
#         --with-http_ssl_module \
#         --with-http_spdy_module \
#         --with-http_realip_module \
#         --with-http_addition_module \
# #        --with-http_xslt_module \
# #        --with-http_image_filter_module \
# #+       --with-http_geoip_module \
#         --with-http_sub_module \
# #        --with-http_dav_module \
# #        --with-http_flv_module \
# #+       --with-http_mp4_module \
# #        --with-http_gunzip_module \
#         --with-http_gzip_static_module \
#         --with-http_auth_request_module \
# #        --with-http_random_index_module \
#         --with-http_secure_link_module \
# #        --with-http_degradation_module \
#         --with-http_stub_status_module \
#
# #        --without-http_charset_module \
# #        --without-http_gzip_module \
# #        --without-http_ssi_module \
# #        --without-http_userid_module \
# #        --without-http_access_module \
# #        --without-http_auth_basic_module \
# #        --without-http_autoindex_module \
# #        --without-http_geo_module \
# #        --without-http_map_module \
# #        --without-http_split_clients_module \
# #        --without-http_referer_module \
# #        --without-http_rewrite_module \
# #        --without-http_proxy_module \
# #        --without-http_fastcgi_module \
# #        --without-http_uwsgi_module \
# #        --without-http_scgi_module \
# #        --without-http_memcached_module \
# #        --without-http_limit_conn_module \
# #        --without-http_limit_req_module \
# #        --without-http_empty_gif_module \
# #        --without-http_browser_module \
# #        --without-http_upstream_hash_module \
# #        --without-http_upstream_ip_hash_module \
# #        --without-http_upstream_least_conn_module \
# #        --without-http_upstream_keepalive_module \
#
# #        --with-http_perl_module \
# #        --with-perl_modules_path=PATH \
# #        --with-perl=PATH \
#
#         --http-log-path=/var/log/nginx/access.log \
#         --http-client-body-temp-path=/var/cache/nginx/client_temp \
#         --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
#         --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
#         --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
#         --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
#
# #        --without-http \
# #        --without-http-cache \
#
# #        --with-mail \
# #        --with-mail_ssl_module \
# #        --without-mail_pop3_module \
# #        --without-mail_imap_module \
# #        --without-mail_smtp_module \
#
# #+dev        --with-google_perftools_module \
# #        --with-cpp_test_module \
#
# #        --add-module=PATH \
#
# #        --add-module=
#         --add-module=/opt/nginx_modules/ngx_devel_kit-0.2.19 \
#         --add-module=/opt/nginx_modules/headers-more-nginx-module-0.25 \
#         --add-module=/opt/nginx_modules/echo-nginx-module-0.56 \
#         --add-module=/opt/nginx_modules/set-misc-nginx-module-0.26 \
#         --add-module=/opt/nginx_modules/nginx-x-rid-header-ubuntu \
#         --add-module=/opt/nginx_modules/ngx_aws_auth-1.1.1 \
#         --add-module=/opt/nginx_modules/nginx_upstream_check_module-master \
#         --add-module=/opt/nginx_modules/ngx_http_var_request_speed-1.0 \
# # --with-echo-module
# # --with-google-perftools
# # --with-headers-more-module
# # --with-redis2-module
# # --with-set-misc-module
# # --with-status
# # --with-sub
# # --with-tcp-proxy-module
#
# # https://github.com/openresty/redis2-nginx-module
#
# # nginx-auth-pam
# # nginx-echo
# # nginx-upstream-fair
# # nginx-dav-ext-module
# # nginx-cache-purge
#
#
# #        --add-module=/usr/src/OpenHttpStreamer/mod_nginx \
# #        --add-module=/usr/src/nginx_h264_streaming \
#
# #        --with-cc=PATH \
# #        --with-cpp=PATH \
# #        --with-cc-opt=OPTIONS \
# # from official nginx ubuntu 1.7.7
#         --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wno-unused-parameter -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
# #        --with-ld-opt=OPTIONS \
# # from official nginx ubuntu 1.7.7
# #        --with-ld-opt='-luuid,-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
# # from hacfi os x
# #        --with-ld-opt=-lossp-uuid \
# #        --with-cpu-opt=CPU \
# #        --with-cpu-opt=amd64 \
#
# #        --without-pcre \
#         --with-pcre
# #        --with-pcre=DIR \
# #        --with-pcre-opt=OPTIONS \
# #        --with-pcre-jit \
#
# #        --with-md5=DIR \
# #        --with-md5-opt=OPTIONS \
# #        --with-md5-asm \
# #        --with-sha1=DIR \
# #        --with-sha1-opt=OPTIONS \
# #        --with-sha1-asm \
# #        --with-zlib=DIR \
# #        --with-zlib-opt=OPTIONS \
# #        --with-zlib-asm=CPU \
#
# #        --with-libatomic \
# #        --with-libatomic=DIR \
#
# #        --with-openssl=DIR \
# #        --with-openssl-opt=OPTIONS \
# #
# #        --with-debug \
#
#
# # --with-echo-module
# # --with-google-perftools
# # --with-headers-more-module
# # --with-redis2-module
# # --with-set-misc-module
# # --with-status
# # --with-sub
# # --with-tcp-proxy-module
# # nginx-full
#
# # nginx-rtmp-module https://github.com/arut/nginx-rtmp-module