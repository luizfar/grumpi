#!/bin/bash
source src/gen.sh
source src/io.sh
source src/usage.sh

function grumpi::readProperty() {
  echo `grep "$1" "$PROP_FILE" | awk -F':' '{print $2}' | xargs`
}

function grumpi::readPropertyOrDie() {
  VALUE=`grumpi::readProperty "$1"`
  if [ -z "$VALUE" ]; then
    grumpi::io::error "Property '$1' not set or invalid."
    gurmpi::cleanAndExit 1
  fi
  echo "$VALUE"
}

function grumpi::cleanAndExit() {
  grumpi::io::echo 'Cleaning up...'
  EXIT_CODE=$1
  if [ -z "$EXIT_CODE" ]; then
    exit 0
  fi
  exit $EXIT_CODE
}

function grumpi::toAbsolutePath() {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

function grumpi::run() {
  grumpi::gen::generate
}

while [ "$1" != "" ]; do
  case $1 in
    -f | --file )           shift
                            PROP_FILE=$(grumpi::toAbsolutePath "$1")
                            ;;
    -p | --password )       shift
                            CERT_PASSWD="$1"
                            ;;
    -k | --kar )            shift
                            KAR_PATH=$(grumpi::toAbsolutePath "$1")
                            ;;
    -h | --help )           if [ "$2" == "properties" ]; then
                              shift
                              grumpi::usage::printPropertiesHelp
                            else
                              grumpi::usage::printHelp
                            fi
                            exit
                            ;;
    * )                     grumpi::usage
                            exit 1
  esac
  shift
done

TMP_PATH='/tmp'
GRUMPI_ID=grumpi-$( date "+%s" )
GRUMPI_BUILD_PATH=$TMP_PATH/$GRUMPI_ID

grumpi::io::echo 'Using properties file' $PROP_FILE
grumpi::run
