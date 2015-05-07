#!/bin/bash

TMP_PATH='/tmp'
GRUMPI_ID="grumpi-$(date "+%s")"
GRUMPI_BUILD_PATH=$TMP_PATH/$GRUMPI_ID

source src/gen.sh
source src/io.sh
source src/usage.sh
source src/utils.sh

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

grumpi::io::echoln 'Using properties file' $PROP_FILE
grumpi::gen::generate
