#!/bin/bash

function grumpi::gen::xcode::readProvisioningProfileUuid() {
  FILE=$1
  uuid=`grep UUID -A1 -a "$FILE" | grep -io "[-A-Z0-9]\{36\}"`
  echo $uuid
}

function grumpi::gen::xcode::archiveXcodeProject() {
  grumpi::io::echo "Archiving xcode project..."

  SIGNING_ID=$( grumpi::readProperty 'signingId' )
  PROFILE_PATH=$( grumpi::readProperty 'provisioningProfile' )
  PROVISIONING_PROFILE=$( grumpi::gen::xcode::readProvisioningProfileUuid $PROFILE_PATH )

  INITIAL_PATH=`pwd`
  cd $GRUMPI_BUILD_PATH/VMAppWithKonylib

  xcodebuild archive -project VMAppWithKonylib.xcodeproj -scheme KRelease -archivePath build/archive/"$GRUMPI_ID" CODE_SIGN_IDENTITY="$SIGNING_ID" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"

  if [ ! -d build/archive/"$GRUMPI_ID".xcarchive ]; then
    grumpi::io::error "Could not archive the project. Please check the logs."
    grumpi::cleanAndExit
  fi

  cd $INITIAL_PATH
}

function grumpi::gen::xcode::generateIpaFromArchive() {
  grumpi::io::echo "Generating IPA..."

  INITIAL_PATH=`pwd`
  cd $GRUMPI_BUILD_PATH/VMAppWithKonylib

  xcodebuild -exportArchive -archivePath build/archive/$GRUMPI_ID.xcarchive -exportPath build/grumpi.ipa -exportFormat ipa -exportWithOriginalSigningIdentity

  if [ ! -f build/grumpi.ipa ]; then
    grumpi::io::error "Oops, an error occurred during IPA generation. Please check the logs."
    grumpi::cleanAndExit
    exit 1
  fi

  cp build/grumpi.ipa $INITIAL_PATH/grumpi.ipa

  cd $INITIAL_PATH
}
