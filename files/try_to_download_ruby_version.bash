#!/bin/bash

if [ -z "$SKIP_PRECOMPILED_RUBIES" ]; then
  VERSION_NAME="${DEFINITION##*/}"
  VERSIONS_DIR="${RBENV_ROOT}/versions"
  OSX_RELEASE=`sw_vers -productVersion | cut -f 1-2 -d '.'`
  DOWNLOAD_BUCKET=${BOXEN_S3_BUCKET-"boxen-downloads"}
  DOWNLOAD_HOST=${BOXEN_S3_HOST-"s3.amazonaws.com"}
  PREV_PWD=`pwd`

  cd $VERSIONS_DIR
  echo "Trying to download precompiled Ruby from Boxen..."
  curl -s -f http://$DOWNLOAD_HOST/$DOWNLOAD_BUCKET/rbenv/$OSX_RELEASE/$VERSION_NAME.tar.bz2 > /tmp/ruby-$VERSION_NAME.tar.bz2 && \
    tar xjf /tmp/ruby-$VERSION_NAME.tar.bz2 && rm -rf /tmp/ruby-$VERSION_NAME.tar.bz2
  cd $PREV_PWD

  if [ -d "$VERSIONS_DIR/$VERSION_NAME" ]; then
    # install from download was successful
    rbenv rehash
    exit 0
  fi
fi
