#!/bin/sh
certbot --manual certonly -d wiki.machs.org --config-dir ./certconfig --work-dir ./certwork --logs ./certlogs
# ouput files in  certconfg/live/wiki.machs.org
