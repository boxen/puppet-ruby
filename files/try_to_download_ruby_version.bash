#!/bin/bash

VERSION_NAME="${DEFINITION##*/}"
VERSIONS_DIR="${RBENV_ROOT}/versions"
OSX_RELEASE=`sw_vers -productVersion | cut -f 1-2 -d '.'`

PREV_PWD=`pwd`

cd $VERSIONS_DIR
echo "Trying to download precompiled Ruby from Boxen..."
curl -s -f http://s3.amazonaws.com/boxen-downloads/rbenv/$OSX_RELEASE/$VERSION_NAME.tar.bz2 > /tmp/ruby-$VERSION_NAME.tar.bz2 && \
  tar xjf /tmp/ruby-$VERSION_NAME.tar.bz2 && rm -rf /tmp/ruby-$VERSION_NAME.tar.bz2
cd $PREV_PWD

if [ -d "$VERSIONS_DIR/$VERSION_NAME" ]; then
  # install from download was successful
  rbenv rehash
  exit 0
fi
