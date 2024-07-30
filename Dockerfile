FROM alpine:3.20 AS build 
LABEL title="nginx modification for SIDEL Incorporated."
LABEL maintainer="Kangjun Heo <kheo@sidelcorp.com>"

RUN apk --update add git alpine-sdk
RUN apk add pcre2-dev pcre-dev openssl-dev gzip zlib-dev

RUN git clone https://github.com/SIDEL-INC/nginx
WORKDIR /nginx
RUN chmod +x build.sh
RUN ./build.sh

RUN make install

FROM alpine:3.20 AS prod
COPY --from=build /opt/nginx /opt/nginx

RUN apk add pcre2-dev pcre-dev openssl-dev gzip zlib-dev

ENTRYPOINT /opt/nginx/sbin/nginx -g "daemon off;"
