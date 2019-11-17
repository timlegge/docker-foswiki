FROM alpine:edge

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.tgz

ENV FOSWIKI_LATEST_MD5 706fc6bf1fa6df6bfbe8a079c5007aa3

ENV FOSWIKI_LATEST Foswiki-2.1.6

RUN sed -n 's/main/testing/p' /etc/apk/repositories >> /etc/apk/repositories && \
    apk add --update && \
    apk add ca-certificates imagemagick mailcap musl nginx openssl tzdata \
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
        perl-email-mime perl-error perl-fcgi perl-fcgi-procmanager \
        perl-file-copy-recursive perl-file-remove perl-file-slurp \
        perl-filesys-notify-simple perl-file-which perl-gd perl-gssapi \
        perl-hash-merge-simple perl-hash-multivalue perl-html-tree \
        perl-image-info perl-io-socket-inet6 perl-json perl-json-xs \
        perl-ldap perl-libwww perl-locale-maketext-lexicon perl-locale-msgfmt \
        perl-lwp-protocol-https perl-mime-base64 perl-module-install \
        perl-module-pluggable perl-moo perl-moose perl-moosex \
        perl-moosex-types perl-moosex-types-common perl-locale-codes \
        perl-moosex-types-datetime perl-moosex-types-uri \
        perl-moox-types-mooselike perl-path-tiny perl-spreadsheet-xlsx \
        perl-stream-buffered perl-sub-exporter-formethods perl-sereal \
        perl-test-leaktrace perl-text-unidecode perl-text-soundex perl-time-parsedate \
        perl-type-tiny perl-uri perl-www-mechanize perl-xml-canonicalizexml \
        perl-xml-easy perl-xml-generator perl-xml-parser perl-xml-tidy \
        perl-xml-writer perl-xml-xpath perl-yaml perl-yaml-tiny \
        imagemagick-perlmagick git graphviz perl-dev make ssmtp --update-cache && \
        # perl-libapreq2 -- Apache2::Request - Here for completeness but we use nginx \
        rm -fr /var/cache/apk/APKINDEX.*

COPY perl-net-saml2-0.19.05-r0.apk perl-net-saml2-0.19.05-r0.apk

RUN apk add --allow-untrusted perl-net-saml2-0.19.05-r0.apk && \
    rm perl-net-saml2-0.19.05-r0.apk

RUN wget ${FOSWIKI_LATEST_URL} && \
    echo "${FOSWIKI_LATEST_MD5}  ${FOSWIKI_LATEST}.tgz" > ${FOSWIKI_LATEST}.tgz.md5 && \
    md5sum -cs ${FOSWIKI_LATEST}.tgz.md5 && \
    mkdir -p /var/www && \
    mv ${FOSWIKI_LATEST}.tgz /var/www && \
    cd /var/www && \
    tar xvfz ${FOSWIKI_LATEST}.tgz && \
    rm -rf ${FOSWIKI_LATEST}.tgz && \
    mv ${FOSWIKI_LATEST} foswiki && \
    cd foswiki && \
    sh tools/fix_file_permissions.sh

RUN cd /var/www/foswiki && \
    tools/configure -save -noprompt && \
    tools/configure -save -set {DefaultUrlHost}='http://localhost' && \
    tools/configure -save -set {ScriptUrlPath}='/bin' && \
    tools/configure -save -set {ScriptUrlPaths}{view}='' && \
    tools/configure -save -set {PubUrlPath}='/pub' && \
    tools/configure -save -set {DefaultUrlHost}='http://localhost' && \
    tools/configure -save -set {SafeEnvPath}='/bin:/usr/bin' && \
    tools/extension_installer ActionTrackerPlugin -r -enable install && \
    tools/extension_installer AutoTemplatePlugin -r -enable install && \
    tools/extension_installer BreadCrumbsPlugin -r -enable install && \
    tools/extension_installer NatSkin -r -enable install && \
    tools/extension_installer JQPhotoSwipeContrib -r -enable install && \
    tools/extension_installer ClassificationPlugin -r -enable install && \
    tools/extension_installer DBCachePlugin -r -enable install && \
    tools/extension_installer DiffPlugin -r -enable install && \
    tools/extension_installer DocumentViewerPlugin -r -enable install && \
    tools/extension_installer EditChapterPlugin -r -enable install && \
    tools/extension_installer FlexFormPlugin -r -enable install && \
    tools/extension_installer FlexWebListPlugin -r -enable install && \
    tools/extension_installer FilterPlugin -r -enable install && \
    tools/extension_installer GluePlugin -r -enable install && \
    tools/extension_installer GraphvizPlugin -r -enable install && \
    tools/extension_installer GridLayoutPlugin -r -enable install && \
    tools/extension_installer ImageGalleryPlugin -r -enable install && \
    tools/extension_installer ImagePlugin -r -enable install && \
    tools/extension_installer JQDataTablesPlugin -r -enable install && \
    tools/extension_installer JQMomentContrib -r -enable install && \
    tools/extension_installer JQSelect2Contrib -r -enable install && \
    tools/extension_installer JQSerialPagerContrib -r -enable install && \
    tools/extension_installer JQTwistyContrib -r -enable install && \
    tools/extension_installer JSTreeContrib -r -enable install && \
    tools/extension_installer LdapNgPlugin -r -enable install && \
    tools/extension_installer LikePlugin -r -enable install && \
    tools/extension_installer ListyPlugin -r -enable install && \
    tools/extension_installer MediaElementPlugin -r -enable install && \
    tools/extension_installer NatSkinPlugin -r -enable install && \
    tools/extension_installer MetaCommentPlugin -r -enable install && \
    tools/extension_installer MetaDataPlugin -r -enable install && \
    tools/extension_installer MimeIconPlugin -r -enable install && \
    tools/extension_installer MoreFormfieldsPlugin -r -enable install && \
    tools/extension_installer MultiLingualPlugin -r -enable install && \
    tools/extension_installer PubLinkFixupPlugin -r -enable install && \
    tools/extension_installer NewUserPlugin -r -enable install && \
    tools/extension_installer RedDotPlugin -r -enable install && \
    tools/extension_installer RenderPlugin -r -enable install && \
    tools/extension_installer SolrPlugin -r -enable install && \
    tools/extension_installer TagCloudPlugin -r -enable install && \
    tools/extension_installer TopicInteractionPlugin -r -enable install && \
    tools/extension_installer TopicTitlePlugin -r -enable install && \
    tools/extension_installer WebLinkPlugin -r -enable install && \
    tools/extension_installer WorkflowPlugin -r -enable install && \
    rm -fr /var/www/foswiki/working/configure/download/* && \
    rm -fr /var/www/foswiki/working/configure/backup/*

RUN git clone https://github.com/timlegge/SamlLoginContrib.git && \
    cd SamlLoginContrib && \
    tar cvf SamlLoginContrib.tar * && \
    cd /var/www/foswiki && \
    tar xvf /SamlLoginContrib/SamlLoginContrib.tar && \
    rm -fr /SamlLoginContrib && \
    apk update && \
    apk del --purge make musl-dev db-dev expat-dev openssl-dev \
        imagemagick6-dev krb5-dev libxml2-dev gcc git perl-dev

RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
