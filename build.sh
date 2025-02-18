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

MODULES="--with-http_ssl_module --with-http_v2_module --with-http_v3_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module"
PREFIX=/opt/webserver
SBIN=/sbin/webserver
LOGPATH=/var/log/webserver
TMPPATH=/tmp
PIDPATH=/run/webserver

make clean
./configure $MODULES --prefix=$PREFIX --sbin-path=$SBIN --http-client-body-temp-path=$TMPPATH/body_temp --http-log-path=$LOGPATH/server.log --error-log-path=$LOGPATH/error.log --http-proxy-temp-path=$TMPPATH/proxy_temp --pid-path=$PIDPATH/.pid --lock-path=$PIDPATH/.lock
make -j $(nproc)
