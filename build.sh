#!/bin/sh

. /etc/os-release

#install dependencies
case $ID in
	debian|ubuntu) sudo apt-get install -y libpcre3 libpcre3-dev libssl-dev
  ;;

	redhat|rocky|ol) sudo dnf install -y pcre pcre-devel openssl-devel
  ;;

	*) echo "Unknown distribution; skipping"
  ;;
esac

MODULES="--with-http_realip_module --with-http_ssl_module --with-http_v2_module --with-http_v3_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --with-threads"

CFLAGS="--std=c11 -O3 -march=native -Wformat=2 -Wformat-security -DFORTIFY-SOURCE=2 -Wall -Wextra -Wpedantic -Wconversion -Wimplicit-fallthrough -fPIE -pie -fstack-protector-strong -flto -fomit-frame-pointer -Wl,-z,relro,z,now"

PREFIX=/opt/nginx
SBIN=/sbin/nginx
CONFPATH=/etc/nginx
LOGPATH=/var/log
TMPPATH=/tmp
PIDPATH=/run

make clean
./configure $MODULES --prefix=$PREFIX --conf-path=$CONFPATH --sbin-path=$SBIN --http-client-body-temp-path=$TMPPATH/body_temp --http-log-path=$LOGPATH/server.log --error-log-path=$LOGPATH/error.log --http-proxy-temp-path=$TMPPATH/proxy_temp --pid-path=$PIDPATH/ws.pid --lock-path=$PIDPATH/ws.lock --with-cc-opt="$CFLAGS"

make -j $(nproc)
