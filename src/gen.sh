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

function grumpi::gen::generate() {
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
