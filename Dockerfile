FROM alpine:3.7

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.zip

ENV FOSWIKI_LATEST Foswiki-2.1.6

RUN apk add --update && \
    apk add nginx wget unzip make zip perl perl-cgi perl-fcgi perl-cgi-session perl-error perl-json perl-file-copy-recursive ca-certificates && \
    apk add perl-uri perl-digest-perl-md5 perl-lwp-protocol-https perl-html-tree perl-email-mime perl-algorithm-diff && \
    apk add perl-cache-cache  perl-file-which perl-module-pluggable perl-moo perl-json perl-dbi perl-dbd-sqlite && \
    apk add perl-archive-zip perl-time-modules mailcap && \
    apk add perl-json-xs --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk add gcc perl-dev musl-dev db-dev imagemagick6-dev && \
    apk add perl-authen-sasl && \
    apk add perl-db_file && \
    apk add perl-net-ldap  && \
    perl -MCPAN -e 'install Crypt::PasswdMD5, BerkeleyDB, Spreadsheet::XLSX ,XML::Easy, Time::ParseDate, Types::Standard, Algorithm::Diff::XS' && \
    wget http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz && \
    tar xvfz PerlMagick-6.89.tar.gz && \
    cd PerlMagick-6.89 && \
    perl Makefile.PL && \
    make install && \
    cd / && \
    rm -f PerlMagick-6.89.tar.gz && \
    rm -fr PerlMagick-6.89 && \
    apk del gcc perl-dev musl-dev db-dev imagemagick6-dev && \
    cd ~/ && \
    rm -fr .cpan


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
