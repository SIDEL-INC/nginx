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

COPY --from=build /sbin/nginx /sbin/nginx
COPY --from=build /opt/nginx /opt/nginx
RUN  mkdir /logs
RUN  mkdir /run/ws

RUN apk add pcre2-dev pcre-dev openssl-dev gzip zlib-dev

RUN adduser user --disabled-password
RUN chown -R user:user /logs
RUN chmod o+w /run/ws

USER user
ENTRYPOINT nginx -g "daemon off;"
