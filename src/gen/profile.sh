#!/bin/bash

function grumpi::gen::profiles::installProvisioningProfile() {
  grumpi::io::echo "Installing mobile provisioning profile..."

  PROFILES_INSTALL_PATH=~/Library/MobileDevice/Provisioning\ Profiles
  PROFILE_PATH=$( grumpi::readProperty 'provisioningProfile' )

  if [ -z "$PROFILE_PATH" ] || [ ! -e "$PROFILE_PATH" ]; then
    grumpi::io::error "Could not find path to provisioning profile."
    grumpi::io::error "Please ensure 'provisioningProfile' is set in your properties file."
    grumpi::cleanAndExit
  fi

  if [ ! -e "$PROFILES_INSTALL_PATH" ]; then
    mkdir -p "$PROFILES_INSTALL_PATH"
  fi

  uuid=`grep UUID -A1 -a "$PROFILE_PATH" | grep -io "[-A-Z0-9]\{36\}"`
  extension="${PROFILE_PATH##*.}"
  grumpi::io::echo "Installing provisioning profile to $PROFILES_INSTALL_PATH/$uuid.$extension"
  cp -f "$PROFILE_PATH" "$PROFILES_INSTALL_PATH"/"$uuid.$extension"
}
