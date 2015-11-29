#!/bin/bash
set -o errexit
if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  CONTEXT_PATH="/$CONTEXT_PATH"
fi

xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" conf/server-backup.xml > conf/server.xml

if [ -n "$SSL_PROXY" ]; then
  mv conf/server.xml conf/serverpreproxy.xml
  xmlstarlet ed -i "//Connector" -t attr -n scheme -v https conf/serverpreproxy.xml \
   | xmlstarlet ed -i "//Connector" -t attr -n proxyName -v $SSL_PROXY \
   | xmlstarlet ed -i "//Connector" -t attr -n proxyPort -v 443 > conf/server.xml
  rm conf/serverpreproxy.xml
fi

