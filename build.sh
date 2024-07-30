#!/bin/sh
make clean
./configure --with-http_ssl_module --with-http_v2_module --with-http_v3_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --prefix=/opt/nginx --sbin-path=/sbin/nginx --http-client-body-temp-path=/tmp/body_temp --http-log-path=/logs
make -j $(nproc)
