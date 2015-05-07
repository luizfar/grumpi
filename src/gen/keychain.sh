#!/bin/bash

GRUMPI_KEYCHAIN_NAME="$GRUMPI_ID.keychain"
GRUMPI_KEYCHAIN_PATH=~/Library/Keychains/$GRUMPI_KEYCHAIN_NAME

function grumpi::gen::keychain::storeDefaultKeychain() {
  GRUMPI_DEFAULT_KEYCHAIN_PATH=`security default-keychain`
  GRUMPI_DEFAULT_KEYCHAIN_NAME=`basename -- $(echo $GRUMPI_DEFAULT_KEYCHAIN_PATH) $(echo \")`
}

function grumpi::gen::keychain::resetDefaultKeychain() {
  grumpi::io::echo "Resetting the default keychain..."

  LOGIN_KEYCHAIN_NAME="login.keychain"

  if [ -z "$GRUMPI_DEFAULT_KEYCHAIN_PATH" ]; then
    grumpi::io::echo "A default keychain was not found. Falling back to login keychain."
    security default-keychain -s $LOGIN_KEYCHAIN_NAME
    return
  fi

  if [ $GRUMPI_DEFAULT_KEYCHAIN_NAME == $GRUMPI_KEYCHAIN_NAME ]; then
    grumpi::io::echo "$GRUMPI_KEYCHAIN_NAME is the default keychain... Falling back to login keychain."
    security default-keychain -s $LOGIN_KEYCHAIN_NAME
  else
    grumpi::io::echo "Resetting default keychain to $GRUMPI_DEFAULT_KEYCHAIN_NAME"
    security default-keychain -s $GRUMPI_DEFAULT_KEYCHAIN_NAME
  fi
}

function grumpi::gen::keychain::deleteKeychainIfItExists() {
  if [ -f "$GRUMPI_KEYCHAIN_PATH" ]; then
    grumpi::io::echo "$GRUMPI_KEYCHAIN_PATH exists. Deleting $KEYCHAIN_NAME."
    security delete-keychain $GRUMPI_KEYCHAIN_NAME
  fi
}

function grumpi::gen::keychain::createKeychain() {
  grumpi::gen::keychain::storeDefaultKeychain
  grumpi::gen::keychain::deleteKeychainIfItExists

  P12_PATH=$( grumpi::readProperty 'p12Path' )
  CERT_PATH=$( grumpi::readProperty 'certPath' )

  grumpi::io::echo "Creating $KEYCHAIN_NAME..."
  security create-keychain -p $CERT_PASSWD $GRUMPI_KEYCHAIN_NAME

  security import $P12_PATH -P $CERT_PASSWD -k $GRUMPI_KEYCHAIN_NAME -A
  security add-certificates -k $GRUMPI_KEYCHAIN_NAME $CERT_PATH

  security list-keychains -s $GRUMPI_KEYCHAIN_NAME login.keychain
  security unlock-keychain -p $CERT_PASSWD $GRUMPI_KEYCHAIN_NAME
  security default-keychain -s $GRUMPI_KEYCHAIN_NAME
}

