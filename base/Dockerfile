FROM alpine:edge

ENV PERL_MM_USE_DEFAULT 1

RUN sed -n 's/main/testing/p' /etc/apk/repositories >> /etc/apk/repositories && \
    apk add --update && \
    apk add ca-certificates imagemagick mailcap musl nginx openssl tzdata bash \
        grep unzip wget zip perl perl-algorithm-diff perl-algorithm-diff-xs \
        perl-apache-logformat-compiler perl-archive-zip perl-authen-sasl \
        perl-authcas perl-berkeleydb perl-cache-cache perl-cgi perl-cgi-session \
        perl-class-accessor perl-convert-pem perl-crypt-eksblowfish \
        perl-crypt-openssl-bignum perl-crypt-openssl-dsa \
        perl-crypt-openssl-random perl-crypt-openssl-rsa \
        perl-crypt-openssl-verifyx509 perl-crypt-openssl-x509 \
        perl-crypt-passwdmd5 perl-crypt-smime perl-crypt-x509 perl-dancer \
        perl-datetime perl-datetime-format-xsd perl-dbd-mysql perl-dbd-pg \
        perl-dbd-sqlite perl-db_file perl-db_file-lock perl-dbi \
        perl-devel-overloadinfo perl-digest-perl-md5 perl-digest-sha1 \
        perl-email-mime perl-encode perl-error perl-fcgi perl-fcgi-procmanager \
        perl-file-copy-recursive perl-file-remove perl-file-slurp perl-file-which \
        perl-filesys-notify-simple perl-file-which perl-gd perl-gssapi \
        perl-hash-merge-simple perl-hash-multivalue perl-html-tree \
        perl-image-info perl-io-socket-inet6 perl-json perl-json-xs \
        perl-ldap perl-libwww perl-locale-maketext-lexicon perl-locale-msgfmt \
        perl-lwp-protocol-https perl-mime-base64 perl-module-install \
        perl-module-pluggable perl-moo perl-moose perl-moosex \
        perl-moosex-types perl-moosex-types-common perl-locale-codes \
        perl-moosex-types-datetime perl-moosex-types-uri \
        perl-moox-types-mooselike perl-path-tiny perl-spreadsheet-parseexcel \
        perl-spreadsheet-xlsx perl-stream-buffered perl-sub-exporter-formethods \
        perl-sereal perl-test-leaktrace perl-text-unidecode perl-text-soundex \
        perl-time-parsedate perl-type-tiny perl-uri perl-www-mechanize \
        perl-xml-canonicalizexml perl-xml-easy perl-xml-generator perl-xml-parser \
        perl-xml-tidy perl-xml-writer perl-xml-xpath perl-yaml perl-yaml-tiny \
        imagemagick-perlmagick git graphviz perl-dev make ssmtp \
        odt2txt antiword lynx poppler-utils --update-cache 
        # perl-libapreq2 -- Apache2::Request - Here for completeness but we use nginx \

RUN touch /root/.bashrc

COPY perl-net-saml2-0.19.05-r0.apk perl-net-saml2-0.19.05-r0.apk

RUN apk add --allow-untrusted perl-net-saml2-0.19.05-r0.apk && \
    rm perl-net-saml2-0.19.05-r0.apk && \
    rm -fr /var/cache/apk/APKINDEX.* && \
    apk del --purge make git perl-dev

RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

#COPY nginx.default.conf /etc/nginx/conf.d/default.conf
#COPY docker-entrypoint.sh docker-entrypoint.sh

#EXPOSE 80

#CMD ["sh", "docker-entrypoint.sh"]
