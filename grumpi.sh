#!/bin/bash
source src/io.sh
source src/gen.sh

function grumpi::readProperty() {
  echo `grep "$1" "$PROP_FILE" | awk -F':' '{print $2}' | xargs`
}

function grumpi::cleanAndExit() {
  grumpi::io::echo 'Cleaning up...'
  #grumpi::gen::cleanup
}

function grumpi::toAbsolutePath() {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

function grumpi::run() {
  grumpi::gen::generate
}

PROP_FILE=$(grumpi::toAbsolutePath "$1")
CERT_PASSWD="$2"
KAR_PATH=$(grumpi::toAbsolutePath "$3")

TMP_PATH='/tmp'
GRUMPI_ID=grumpi-$( date "+%s" )
GRUMPI_BUILD_PATH=$TMP_PATH/$GRUMPI_ID

grumpi::io::echo 'Using properties file' $PROP_FILE
grumpi::run
