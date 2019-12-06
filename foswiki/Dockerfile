FROM timlegge/docker-foswiki-base

ENV PERL_MM_USE_DEFAULT 1

ENV FOSWIKI_LATEST_URL https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.tgz

ENV FOSWIKI_LATEST_MD5 706fc6bf1fa6df6bfbe8a079c5007aa3

ENV FOSWIKI_LATEST Foswiki-2.1.6

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
    tools/extension_installer AttachContentPlugin -r -enable install && \
    tools/extension_installer AutoRedirectPlugin -r -enable install && \
    tools/extension_installer AutoTemplatePlugin -r -enable install && \
    tools/extension_installer BreadCrumbsPlugin -r -enable install && \
    tools/extension_installer NatSkin -r -enable install && \
    tools/extension_installer JQPhotoSwipeContrib -r -enable install && \
    tools/extension_installer CaptchaPlugin -r -enable install && \
    tools/extension_installer ClassificationPlugin -r -enable install && \
    tools/extension_installer CopyContrib -r -enable install && \
    tools/extension_installer DBCacheContrib -r -enable install && \
    tools/extension_installer DBCachePlugin -r -enable install && \
    tools/extension_installer DiffPlugin -r -enable install && \
    tools/extension_installer DigestPlugin -r -enable install && \
    tools/extension_installer DocumentViewerPlugin -r -enable install && \
    tools/extension_installer EditChapterPlugin -r -enable install && \
    tools/extension_installer FarscrollContrib -r -enable install && \
    tools/extension_installer FlexFormPlugin -r -enable install && \
    tools/extension_installer FlexWebListPlugin -r -enable install && \
    tools/extension_installer FilterPlugin -r -enable install && \
    tools/extension_installer GraphvizPlugin -r -enable install && \
    tools/extension_installer GridLayoutPlugin -r -enable install && \
    tools/extension_installer ImageGalleryPlugin -r -enable install && \
    tools/extension_installer ImagePlugin -r -enable install && \
    tools/extension_installer InfiniteScrollContrib -r -enable install && \
    tools/extension_installer JQAutoColorContrib -r -enable install && \
    tools/extension_installer JQDataTablesPlugin -r -enable install && \
    tools/extension_installer JQMomentContrib -r -enable install && \
    tools/extension_installer JQSelect2Contrib -r -enable install && \
    tools/extension_installer JQSerialPagerContrib -r -enable install && \
    tools/extension_installer JQTwistyContrib -r -enable install && \
    tools/extension_installer JSTreeContrib -r -enable install && \
    tools/extension_installer LdapContrib -r install && \
    tools/extension_installer LdapNgPlugin -r install && \
    tools/extension_installer LikePlugin -r -enable install && \
    tools/extension_installer ListyPlugin -r -enable install && \
    tools/extension_installer MediaElementPlugin -r -enable install && \
    tools/extension_installer NatSkinPlugin -r -enable install && \
    tools/extension_installer MetaCommentPlugin -r -enable install && \
    tools/extension_installer MetaDataPlugin -r -enable install && \
    tools/extension_installer MimeIconPlugin -r -enable install && \
    tools/extension_installer MoreFormfieldsPlugin -r -enable install && \
    tools/extension_installer MultiLingualPlugin -r -enable install && \
    tools/extension_installer PageOptimizerPlugin -r -enable install && \
    tools/extension_installer PubLinkFixupPlugin -r -enable install && \
    tools/extension_installer NewUserPlugin -r -enable install && \
    tools/extension_installer RedDotPlugin -r -enable install && \
    tools/extension_installer RenderPlugin -r -enable install && \
    tools/extension_installer SecurityHeadersPlugin -r -enable install && \
    tools/extension_installer StringifierContrib -r -enable install && \
    tools/extension_installer SolrPlugin -r -enable install && \
    tools/extension_installer TagCloudPlugin -r -enable install && \
    tools/extension_installer TopicInteractionPlugin -r -enable install && \
    tools/extension_installer TopicTitlePlugin -r -enable install && \
    tools/extension_installer WebLinkPlugin -r -enable install && \
    tools/extension_installer WebFontsContrib -r -enable install && \
    tools/extension_installer WorkflowPlugin -r -enable install && \
    tools/extension_installer XSendFileContrib -r -enable install && \
    rm -fr /var/www/foswiki/working/configure/download/* && \
    rm -fr /var/www/foswiki/working/configure/backup/*

RUN apk add git 

RUN git clone https://github.com/timlegge/SamlLoginContrib.git && \
    cd SamlLoginContrib && \
    tar cvf SamlLoginContrib.tar * && \
    cd /var/www/foswiki && \
    tar xvf /SamlLoginContrib/SamlLoginContrib.tar && \
    rm -fr /SamlLoginContrib && \
    apk update && \
    apk del --purge make git perl-dev

RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/conf.d

COPY nginx.default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh docker-entrypoint.sh

EXPOSE 80

CMD ["sh", "docker-entrypoint.sh"]
