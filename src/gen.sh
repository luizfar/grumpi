#!/bin/bash

source src/gen/keychain.sh
source src/gen/kony.sh
source src/gen/profile.sh
source src/gen/schemes.sh
source src/gen/xcode.sh

function grumpi::gen::cleanup() {
  if [ -e $GRUMPI_BUILD_PATH ]; then
    rm -rf $GRUMPI_BUILD_PATH
  fi
}

function grumpi::gen::checkForProperty() {
  PROP_NAME="$1"
  VALUE=$(grumpi::readProperty "$PROP_NAME")
  if [ -z "$VALUE" ] || [ ! -e "$VALUE" ]; then
    grumpi::io::error "$PROP_NAME not provided or not valid. Please check your properties file."
    grumpi::die
  fi
}

function grumpi::gen::validateData() {
  SOURCE=$(grumpi::readProperty 'source')
  if [ -z "$SOURCE" ]; then
    SOURCE='xcode'
  fi
  if [ $SOURCE != 'xcode' ] && [ $SOURCE != 'kony' ]; then
    grumpi::io::error "Invalid property 'source' in your properties file."
    grumpi::io::error "Please ensure it is set to either 'kony' or 'xcode'."
    grumpi::die
  fi

  if [ $SOURCE == 'kony' ]; then
    KONY_PATH=$(grumpi::readProperty 'konyPath')
    KONY_PATH=$(grumpi::toAbsolutePath "$KONY_PATH")

    if [ -z "$KONY_PATH" ] || [ ! -e "$KONY_PATH" ]; then
      grumpi::io::error "konyPath property not provided or not valid."
      grumpi::die
    fi

    if [ -z "$KAR_PATH" ] || [ ! -e "$KAR_PATH" ]; then
      grumpi::io::error "Generating an IPA from a Kony project, but a valid .KAR file was not provided."
      grumpi::io::error "Please use the -k option when running Grumpi providing the path to your Kony generated .KAR file."
      grumpi::die
    fi
  fi

  grumpi::gen::checkForProperty 'provisioningProfile'
  grumpi::gen::checkForProperty 'schemesPath'
  grumpi::gen::checkForProperty 'certPath'
  grumpi::gen::checkForProperty 'p12Path'
}

function grumpi::gen::generate() {
  grumpi::io::echo "Checking the data provided..."
  grumpi::gen::validateData

  grumpi::io::echo "Generating iOS IPA..."

  mkdir -p $GRUMPI_BUILD_PATH

  grumpi::gen::profiles::installProvisioningProfile

  SOURCE=$(grumpi::readProperty 'source')
  if [ $SOURCE == 'kony' ]; then
    grumpi::gen::kony::extractKarIntoXCodeProject
  fi

  grumpi::gen::schemes::prepareXcodeProjectSchemes
  grumpi::gen::keychain::createKeychain
  grumpi::gen::xcode::archiveXcodeProject
  grumpi::gen::xcode::generateIpaFromArchive
}
