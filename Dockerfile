FROM alpine:3.7

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.zip

ENV FOSWIKI_LATEST Foswiki-2.1.6

RUN apk add --update && \
    apk add nginx wget unzip make zip perl perl-cgi perl-fcgi perl-cgi-session perl-error perl-json perl-file-copy-recursive ca-certificates

RUN perl -MCPAN -e 'install Crypt::PasswdMD5'

RUN wget ${FOSWIKI_LATEST_URL}

RUN mkdir -p /var/www && \
    mv ${FOSWIKI_LATEST}.zip /var/www && \
    cd /var/www && \
    unzip ${FOSWIKI_LATEST}.zip -d /var/www/ && \
    rm -rf ${FOSWIKI_LATEST}.zip && \
    mv ${FOSWIKI_LATEST} foswiki && \
    cd foswiki && \
    sh tools/fix_file_permissions.sh && \
    mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
