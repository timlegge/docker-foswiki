#!/bin/bash

echo "...pointing SolrPlugin at the solr container"
# Solr 9 creates its own core from /var/www/foswiki/solr_9 (see the solr service in docker-compose)
sed -i '/SolrPlugin..Url/s/localhost/solr/' /var/www/foswiki/lib/LocalSite.cfg

echo "...enabling NatSkin"
grep -q "Set SKIN = nat" /var/www/foswiki/data/Main/SitePreferences.txt || sed -i '/---++ Appearance/a\ \ \ * Set SKIN = nat' /var/www/foswiki/data/Main/SitePreferences.txt

echo "...starting iwatch"
iwatch -d

echo "...starting nginx+foswiki"
cd /var/www/foswiki/bin

./foswiki.fcgi -l 127.0.0.1:9000 -n 5 -d

nginx -g "daemon off;"
