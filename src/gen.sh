#!/bin/bash

source "$ROOT_DIR/src/gen/keychain.sh"
source "$ROOT_DIR/src/gen/kony.sh"
source "$ROOT_DIR/src/gen/profile.sh"
source "$ROOT_DIR/src/gen/schemes.sh"
source "$ROOT_DIR/src/gen/xcode.sh"

function grumpi::gen::cleanup() {
  if [ -e $GRUMPI_BUILD_PATH ]; then
    rm -rf $GRUMPI_BUILD_PATH
  fi
}

function grumpi::gen::checkForPathProperty() {
  PROP_NAME="$1"
  VALUE=$(grumpi::readPropertyAsPath "$PROP_NAME")
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

  if [ $SOURCE == 'xcode' ]; then
    grumpi::gen::checkForPathProperty 'projectPath'
  fi

  if [ $SOURCE == 'kony' ]; then
    grumpi::gen::checkForPathProperty 'konyPath'

    if [ -z "$KAR_PATH" ] || [ ! -e "$KAR_PATH" ]; then
      grumpi::io::error "Generating an IPA from a Kony project, but a valid .KAR file was not provided."
      grumpi::io::error "Please use the -k option when running Grumpi providing the path to your Kony generated .KAR file."
      grumpi::die
    fi
  fi

  grumpi::gen::checkForPathProperty 'provisioningProfile'
  grumpi::gen::checkForPathProperty 'certPath'
  grumpi::gen::checkForPathProperty 'p12Path'

  grumpi::io::echoln "All data provided OK!"
}

function grumpi::gen::generate() {
  grumpi::io::echo "Checking the data provided..."
  grumpi::gen::validateData

  grumpi::io::echoln "Generating iOS IPA..."

  mkdir -p $GRUMPI_BUILD_PATH

  grumpi::gen::profiles::installProvisioningProfile

  SOURCE=$(grumpi::readProperty 'source')
  if [ $SOURCE == 'kony' ]; then
    grumpi::gen::kony::extractKarIntoXCodeProject
    grumpi::gen::schemes::prepareXcodeProjectSchemes
  fi

  grumpi::gen::keychain::createKeychain
  grumpi::gen::xcode::archiveXcodeProjectAndGenerateFromArchive
}
