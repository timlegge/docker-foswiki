# docker-foswiki, with Solr and NatSkin, multi-instances and Traefik ready

## Table of Contents

   * [docker-foswiki, with Solr and NatSkin, multi-instances and Traefik ready](#docker-foswiki-with-solr-and-natskin-multi-instances-and-traefik-ready)
      * [Support](#support)
      * [Why I created this dockerfile?](#why-i-created-this-dockerfile)
      * [First run](#first-run)
         * [Resetting the Admin Password](#resetting-the-admin-password)
      * [Foswiki and Solr run](#foswiki--solr-run)
      * [Foswiki and Solr with https](#foswiki--solr-with-https)
         * [Replacing the certificate and key files distributed here](#replacing-the-certificate-and-key-files-distributed-here)
         * [Using the docker-foswiki.local server name](#using-the-docker-foswikilocal-server-name)
      * [Solr Configuration](#solr-configuration)
      * [Running multiple instances](#running-multiple-instances)
      * [Running multiple instances with Traefik](#running-multiple-instances-with-traefik)
      * [Volumes](#volumes)
      * [Image content](#image-content)
         * [Included Foswiki Contribs](#included-foswiki-contribs)
         * [Included Foswiki Plugins](#included-foswiki-plugins)
         * [Included Foswiki Skins](#included-foswiki-skins)
         * [Included Alpine Packages](#included-alpine-packages)
      * [Use the image](#use-the-image)
         * [How to Build](#how-to-build)
         * [How to run the Build](#how-to-run-the-build)
         * [How to access the running container as root](#how-to-access-the-running-container-as-root)
         * [How to stop the container](#how-to-stop-the-container)
         * [How to remove the container](#how-to-remove-the-container)
         * [How to publish image to Docker Hub](#how-to-publish-image-to-docker-hub)
      * [About Caprover](#about-caprover)
      * [License](#license)

## Support

Log an issue or drop by the #timlegge-docker-foswiki irc channel on Freenode

## Why I created this dockerfile?

I finally got tired of the dependancy issues of Foswiki on RedHat so I modified michael34435/docker-foswiki. The goal of this release is to have a stable version that runs foswiki with all the perl modules required for foswiki to run almost any Plugin. It is served by nginx. Alpinelinux minimizes the size of the container, the total size for this image is `400MB`.

Three variations of the `docker-compose` file are available in order to have a complete Foswiki + Solr faceted search application : a simple one, a pre-configured one for multiple instances and a [Traefik](https://containo.us/traefik/) ready one.

## First run

To start the image :

```bash
docker run -idt -p 80:80 timlegge/docker-foswiki

```

Once started, open `http://localhost` in your browser. The user running the command is in the docker group otherwise sudo is required.

### Resetting the Admin Password

   1. `cd [where the project has been cloned]`
   2. `docker exec -it docker-foswiki /bin/bash`
   3. `cd /var/www/foswiki/`
   4. `tools/configure -save -set {Password}='MyPassword'`

## Foswiki and Solr run

The first compose file provides a Foswiki + Solr multi-container application. Start it with :

```bash
cp docker-compose.1-simple.yml docker-compose.yml
docker-compose up -d
```

Once started, open `http://localhost:8765` in your browser.

The Solr container is set up on an private Docker network.

## Foswiki and Solr with https

The second compose file provides a Foswiki + Solr multi-container application that enables HTTPS. Start it with :

```bash
cp docker-compose.2-simple-https.yml docker-compose.yml
docker-compose up -d
```
Once started, open `https://localhost:8443` in your browser.

### Replacing the certificate and key files distributed here

DO NOT use the certificates included here in a production environment (or really any environment).  They are here to simply allow the start up of a fully functional https configuration.  Simply run the following commands to replace the certificates with your own self-signed certificaes:

Note that this produces an unencrypted key file.  This is needed to start the nginx web server without providing the password to decrypt the file.  Take appropriate measure to secure the file as needed for the security of your installation.

```bash
openssl req -x509 -newkey rsa:4096 -nodes -keyout https/docker-foswiki.key -out https/docker-foswiki.crt -days 365

Generating a RSA private key
........................................................................................................................................................................++++
.................................................++++
writing new private key to 'https/docker-foswiki.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]: US
State or Province Name (full name) [Some-State]: NY
Locality Name (eg, city) []: New York
Organization Name (eg, company) [Internet Widgits Pty Ltd]: Docker Foswiki
Organizational Unit Name (eg, section) []: Security
Common Name (e.g. server FQDN or YOUR name) []:docker-foswiki.local
Email Address []:
```

### Using the docker-foswiki.local server name

You can define docker-foswiki.local in your host file to match the certificate name and nginx configuration. Change the server name in `https/nginx.default.conf` to the server name you wish to use.


The Solr container is set up on an private Docker network.

## Solr Configuration

### Solr WebSearch, WebChanges and WikiUsers

See: https://foswiki.org/Extensions/SolrPlugin#Using_Solr_for_WebSearch_44_WebChanges_and_Main.WikiUsers

### Automatic Indexing

The Docker container includes iwatch which automatically indexes files that have changed.  Everything is set up but you can review https://foswiki.org/Extensions/SolrPlugin#Realtime_indexing

## Running multiple instances

If multiple instances of Foswiki are needed, each one has to have its own folder, at same level as this repo :
- `somepath/docker-foswiki/` : this repo
- `somepath/instance1/` : folder for first Foswiki instance
- `somepath/instance2/` : folder for second Foswiki instance
- and so on

Use the second compose file :

```bash
cd somepath/docker-foswiki/
cp docker-compose.3-multipleInstances.yml docker-compose.yml
```

Under each instance folder, simply copy the `.env` file :

```bash
cd somepath/instance1
cp ../docker-foswiki/.env .
```

And edit it :
- do not change `COMPOSE_FILE` 
- change `COMPOSE_PROJECT_NAME` to this instance name, Docker will use it to prefix the containers name of this instance
- change `EXTERNAL_PORT` so that each instance uses a different port number, for instance 8761, 8762 and so on
- change `TZ` to your time zone
- `ACME` is only used with Traefik, see below

Start each instance under its own folder with :

```bash
cd somepath/instance1
docker-compose up -d
```

## Running multiple instances with Traefik

If you use Traefik as a reverse proxy for multiple instances, use the third compose file :

```bash
cd somepath/docker-foswiki/
cp docker-compose.4-Traefik.yml docker-compose.yml
```

This compose file has all the labels required to work with your running Traefik container.

In the `.env` file, change the `ACME` variable to the `certResolver` name you have declared within Traefik.

After each instance starts, check the Traefik dashboard to verify it has been registered correctly.

## Volumes

See the volume declaration in the `docker-compose.yml` file :
   * 4 volumes are created, for Foswiki data and Solr
   * the `:z` after the volume declaration is necessary with selinux on RedHat to set the permissions correctly
   * the volumes are located by default under `/var/lib/docker/volumes/` 

The third compose file is configured so that the actual volumes data is located under its instance folder. To activate this run the following before starting your instance :

```bash
cd somepath/instance1
mkdir volumes
mkdir volumes/foswiki_www
mkdir volumes/solr_configsets
mkdir volumes/solr_foswiki
mkdir volumes/solr_logs
```

## Image content

### Included Foswiki Contribs

   * CopyContrib
   * DBCacheContrib
   * FarscrollContrib
   * InfiniteScrollContrib
   * JQAutoColorContrib
   * JQMomentContrib
   * JQPhotoSwipeContrib
   * JQSelect2Contrib
   * JQSerialPagerContrib
   * JQTwistyContrib
   * JSTreeContrib
   * LdapContrib
   * OpenIDLoginContrib
   * SamlLoginContrib
   * StringifierContrib
   * WebFontsContrib
   * XSendFileContrib

### Included Foswiki Plugins

   * AttachContentPlugin
   * AutoRedirectPlugin
   * AutoTemplatePlugin
   * BreadCrumbsPlugin
   * CaptchaPlugin
   * ClassificationPlugin
   * DBCachePlugin
   * DiffPlugin
   * DigestPlugin
   * DocumentViewerPlugin
   * EditChapterPlugin
   * FilterPlugin
   * FlexFormPlugin
   * FlexWebListPlugin
   * GraphvizPlugin
   * GridLayoutPlugin
   * ImageGalleryPlugin
   * ImagePlugin
   * JQDataTablesPlugin
   * LdapNgPlugin
   * LikePlugin
   * ListyPlugin
   * MediaElementPlugin
   * MetaCommentPlugin
   * MetaDataPlugin
   * MimeIconPlugin
   * MoreFormfieldsPlugin
   * MultiLingualPlugin
   * NatSkinPlugin
   * NewUserPlugin
   * PageOptimizerPlugin
   * PubLinkFixupPlugin
   * RedDotPlugin
   * RenderPlugin
   * SecurityHeadersPlugin
   * SolrPlugin
   * TagCloudPlugin
   * TopicInteractionPlugin
   * TopicTitlePlugin
   * WebLinkPlugin
   * WorkflowPlugin

### Included Foswiki Skins

   * NatSkin

### Included Alpine Packages

The following base modules are installed to support Foswiki or the required Perl modules below.

Repo | Application | Alpine Package
-----|-------------|---------------
main | Bash | bash
main | Common-CA-certificates | ca-certificates
main | GraphVis | graphviz
main | Grep | grep
main | mailcap | mailcap
main | GNU-make | make
main | Lynx Texte Browser | lynx 
main | musl-LibC | musl
main | nginx-Web-Server | nginx
main | openSSL | openssl
main | Perl5 | perl
main | poppler-utils | poppler-utils
main | Timezone-Data | tzdata
main | unzip | unzip
main | wget | wget
main | zip | zip
community | ImageMagick | imagemagick
community | PerlMagick | imagemagick-perlmagick
testing | odt2txt | odt2txt

A lot of perl modules required by Foswiki and many of its expensions are included in this Docker file as native alpine packages:

Repo | Perl Module | Alpine Package
-----|-------------|---------------
main | Apache-LogFormat-Compiler | perl-apache-logformat-compiler
main | Archive-Zip | perl-archive-zip
main | Authen-SASL | perl-authen-sasl
main | CGI | perl-cgi
main | Cache-Cache | perl-cache-cache
main | Crypt-Eksblowfish | perl-crypt-eksblowfish
main | Crypt-OpenSSL-RSA | perl-crypt-openssl-rsa
main | Crypt-OpenSSL-Random | perl-crypt-openssl-random
main | Crypt-X509 | perl-crypt-x509
main | DBD-Pg | perl-dbd-pg
main | DBD-SQLite | perl-dbd-sqlite
main | DBD-mysql | perl-dbd-mysql
main | DBI | perl-dbi
main | DB_File | perl-db_file
main | DateTime | perl-datetime
main | Digest-SHA1 | perl-digest-sha1
main | Encode | perl-encode
main | Error | perl-error
main | FCGI | perl-fcgi
main | FCGI-ProcManager | perl-fcgi-procmanager
main | File-Copy-Recursive-$pkgver | perl-file-copy-recursive
main | File-Remove | perl-file-remove
main | File-Slurp | perl-file-slurp
main | File-Which | perl-file-which
main | GD | perl-gd
main | HTML-Tree | perl-html-tree
main | IO-Socket-INET6 | perl-io-socket-inet6
main | JSON | perl-json
main | MIME-Base64 | perl-mime-base64
main | Module-Install | perl-module-install
main | Module-Pluggable | perl-module-pluggable
main | Path-Tiny | perl-path-tiny
main | Stream-Buffered | perl-stream-buffered
main | Test-LeakTrace | perl-test-leaktrace
main | Text-Soundex | perl-text-soundex
main | Type-Tiny | perl-type-tiny
main | XML-Parser | perl-xml-parser
main | YAML-Tiny | perl-yaml-tiny
main | libwww-perl | perl-libwww
main | Filesys-Notify-Simple | perl-filesys-notify-simple
main | Hash-MultiValue | perl-hash-multivalue
main | Locale-Maketext-Lexicon | perl-locale-maketext-lexicon
main | URI | perl-uri
main | perl-ldap | perl-ldap
main | CGI-Session | perl-cgi-session
main | Class-Accessor | perl-class-accessor
community | Algorithm-Diff | perl-algorithm-diff
community | Algorithm-Diff-XS | perl-algorithm-diff-xs
community | AuthCAS | perl-authcas
community | BerkeleyDB | perl-db
community | CHI | perl-chi
community | Crypt-PasswdMD5 | perl-crypt-passwdmd5
community | Crypt-SMIME | perl-crypt-smime
community | Convert-PEM | perl-convert-pem
community | Crypt-OpenSSL-Bignum | perl-crypt-openssl-bignum
community | Crypt-OpenSSL-DSA | perl-crypt-openssl-dsa
community | Crypt-OpenSSL-VerifyX509 | perl-crypt-openssl-verifyx509
community | Crypt-OpenSSL-X509 | perl-crypt-openssl-x509
community | Dancer | perl-dancer
community | DB_File-Lock | perl-db_file-lock
community | DateTime-Format-XSD | perl-datetime-format-xsd
community | Devel-OverloadInfo | perl-devel-overloadinfo
community | Digest-Perl-MD5 | perl-digest-perl-md5
communtiy | Email-Address-XS | perl-email-address-xs
community | Email-MIME | perl-email-mime
community | Hash-Merge-Simple | perl-hash-merge-simple
community | Image-Info | perl-image-info 
community | JSON-XS | perl-json-xs
community | GSSAPI | perl-gssapi
community | Locale-Codes | perl-locale-codes
community | Locale-Msgfmt | perl-locale-msgfmt
community | LWP-Protocol-https | perl-lwp-protocol-https
community | Moo | perl-moo
community | MooX-Types-MooseLike | perl-moox-types-mooselike
community | Moose | perl-moose
community | MooseX | perl-moosex
community | MooseX-Types | perl-moosex-types
community | MooseX-Types-Common | perl-moosex-types-common
community | MooseX-Types-DateTime | perl-moosex-types-datetime
community | MooseX-Types-URI | perl-moosex-types-uri
community | Spreadsheet-ParseExcel | perl-spreadsheet-parseexcel
community | Spreadsheet-XLSX | perl-spreadsheet-xlsx
community | Sub-Exporter-ForMethods | perl-sub-exporter-formethods
community | WWW-Mechanize | perl-www-mechanize
community | XML-CanonicalizeXML | perl-xml-canonicalizexml
community | XML-Easy | perl-xml-easy
community | XML-Generator | perl-xml-generator
community | XML-Tidy | perl-xml-tidy
community | XML-Writer | perl-xml-writer
community | XML-XPath | perl-xml-xpath
community | YAML | perl-yaml
testing | Crypt-JWT | perl-crypt-jwt
testing | Crypt-Random | perl-crypt-random
testing | libapreq2 | perl-libapreq2
testing | Sereal | perl-sereal
timlegge | Net-SAML2 | perl-net-saml2

## Use the image

### How to Build

You can build the docker image yourself from the git clone.  Simply do the following in the git directory:
```bash
docker build --no-cache -t docker-foswiki .
```
Building the docker image requires parts of the build process to get access to the internet so if you have a proxy server you will need to follow the directions below to pass the proxy settings to the bulid prodess
```bash
docker build --no-cache  --build-arg https_proxy=http://proxy.example.com:8080 --build-arg http_proxy=http://proxy.example.com:8080 --build-arg HTTPS_PROXY=http://proxy.example.com:8080 --build-arg HTTP_PROXY=http://proxy.example.com:8080 -t docker-foswiki .
```
Unfortunately as the build use's wget, perl LWP and apk from AlpineLinux all four environment variables are necessary as each uses a different case or protocol to download the proper files.

### How to run the Build

```bash
docker run --name docker-foswiki -d  -p 80:80 docker-foswiki
```
### How to access the running container as root

```bash
docker exec -it docker-foswiki /bin/sh
``` 
### How to stop the container

```bash
docker stop docker-foswiki
``` 
### How to remove the container

```bash
docker rm docker-foswiki
``` 
### How to publish image to Docker Hub

```bash
docker login
docker tag docker-foswiki $DOCKER_ID_USER/docker-foswiki
docker push  $DOCKER_ID_USER/docker-foswiki
``` 

## About Caprover

This docker image is used by [CapRover](https://caprover.com/) for their one-click app integration, see README-CAPROVER.md file.

## License

MIT
