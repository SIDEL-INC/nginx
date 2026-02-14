#!/bin/sh

. /etc/os-release

# for openssl source-build support at RedHat variants
PERL_MODULES="perl-FindBin perl-IPC-Cmd perl-Time-Piece"

#install dependencies
case $ID in
	debian|ubuntu) sudo apt-get install -y libpcre3 libpcre3-dev libssl-dev
  ;;

	redhat|rocky|ol) sudo dnf install -y pcre pcre-devel $PERL_MODULES
  ;;

	*) echo "Unknown distribution; skipping"
  ;;
esac

DEPENDENCIES="--with-openssl=deps/openssl"

MODULES="--with-http_realip_module --with-http_ssl_module --with-http_v2_module --with-http_v3_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --with-threads"

CFLAGS="-std=gnu11 -O3 -march=native -Wformat-security -DFORTIFY_SOURCE=2 -fPIE -pie -fstack-protector-strong -flto -fomit-frame-pointer"

LDFLAGS="-Wl,-z,relro,-z,now"

PREFIX=/opt/nginx
SBIN=/sbin/nginx
CONFPATH=/etc/nginx/nginx.conf
LOGPATH=/var/log
TMPPATH=/tmp
PIDPATH=/run

make clean
./configure $DEPENDENCIES $MODULES --prefix=$PREFIX --conf-path=$CONFPATH --sbin-path=$SBIN --http-client-body-temp-path=$TMPPATH/body_temp --http-log-path=$LOGPATH/server.log --error-log-path=$LOGPATH/error.log --http-proxy-temp-path=$TMPPATH/proxy_temp --pid-path=$PIDPATH/ws.pid --lock-path=$PIDPATH/ws.lock --with-cc-opt="$CFLAGS" --with-ld-opt="$LDFLAGS"

make -j $(nproc)
