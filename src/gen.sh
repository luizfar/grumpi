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

  if [ $SOURCE == 'xcode' ]; then
    PROJECT_PATH=$(grumpi::readProperty 'projectPath')
    if [ -z "$PROJECT_PATH" ]; then
      grumpi::io::error "projectPath not provided. Please check your properties file."
      grumpi::die
    fi

    PROJECT_PATH=$(grumpi::toAbsolutePath "$PROJECT_PATH")
    if [ ! -e "$PROJECT_PATH" ]; then
      grumpi::io::error "projectPath not valid. Please check your properties file."
      grumpi::die
    fi
  fi

  if [ $SOURCE == 'kony' ]; then
    KONY_PATH=$(grumpi::readProperty 'konyPath')
    if [ -z "$KONY_PATH" ]; then
      grumpi::io::error "konyPath property not provided. Please check your properties file."
      grumpi::die
    fi

    KONY_PATH=$(grumpi::toAbsolutePath "$KONY_PATH")
    if [ ! -e "$KONY_PATH" ]; then
      grumpi::io::error "konyPath not valid. Please check your properties file."
      grumpi::die
    fi

    if [ -z "$KAR_PATH" ] || [ ! -e "$KAR_PATH" ]; then
      grumpi::io::error "Generating an IPA from a Kony project, but a valid .KAR file was not provided."
      grumpi::io::error "Please use the -k option when running Grumpi providing the path to your Kony generated .KAR file."
      grumpi::die
    fi
  fi

  grumpi::gen::checkForProperty 'provisioningProfile'
  grumpi::gen::checkForProperty 'certPath'
  grumpi::gen::checkForProperty 'p12Path'

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
