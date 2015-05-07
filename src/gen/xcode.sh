#!/bin/bash

function grumpi::gen::xcode::readProvisioningProfileUuid() {
  FILE=$1
  uuid=`grep UUID -A1 -a "$FILE" | grep -io "[-A-Z0-9]\{36\}"`
  echo $uuid
}

function grumpi::gen::xcode::getProjectPath() {
  SOURCE=$(grumpi::readProperty 'source')
  if [ $SOURCE == 'kony' ]; then
    PROJECT_PATH=$GRUMPI_BUILD_PATH/VMAppWithKonylib
  else
    PROJECT_PATH=$(grumpi::readProperty 'projectPath')
    PROJECT_PATH=$(grumpi::toAbsolutePath "$PROJECT_PATH")
  fi
  echo "$PROJECT_PATH"
}

function grumpi::gen::xcode::archiveXcodeProjectAndGenerateFromArchive {
  grumpi::io::echo "Archiving xcode project..."

  GRUMPI_NAME=$(grumpi::grumpiName)

  SIGNING_ID=$(grumpi::readProperty 'signingId')
  PROFILE_PATH=$(grumpi::readProperty 'provisioningProfile')
  PROVISIONING_PROFILE=$(grumpi::gen::xcode::readProvisioningProfileUuid $PROFILE_PATH)

  INITIAL_PATH=`pwd`
  PROJECT_PATH=$(grumpi::gen::xcode::getProjectPath)
  PROJECT_ID=$(find "$PROJECT_PATH" -name '*.xcodeproj')
  ARCHIVE_PATH="$GRUMPI_BUILD_PATH/build/archive/"

  mkdir -p "$ARCHIVE_PATH"
  xcodebuild archive -project "$PROJECT_ID" -scheme KRelease -archivePath "$ARCHIVE_PATH/$GRUMPI_ID" CODE_SIGN_IDENTITY="$SIGNING_ID" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"

  if [ ! -d "$ARCHIVE_PATH/$GRUMPI_ID".xcarchive ]; then
    grumpi::io::error "Could not archive the project. Please check the logs."
    grumpi::cleanAndExit 1
  fi

  grumpi::io::echo "Generating IPA..."

  xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH/$GRUMPI_ID".xcarchive -exportPath "$ARCHIVE_PATH/$GRUMPI_NAME".ipa -exportFormat ipa -exportWithOriginalSigningIdentity

  if [ ! -f "$ARCHIVE_PATH/$GRUMPI_NAME".ipa ]; then
    grumpi::io::error "Oops, an error occurred during IPA generation. Please check the logs."
    grumpi::cleanAndExit
    exit 1
  fi

  cp "$ARCHIVE_PATH/$GRUMPI_NAME".ipa "$INITIAL_PATH/$GRUMPI_NAME".ipa
  grumpi::io::echo "$GRUMPI_NAME.ipa generated successfully!"

  cd $INITIAL_PATH
}
