#!/bin/bash

function grumpi::gen::schemes::prepareXcodeProjectSchemes() {
  grumpi::io::echo "Preparing xcode project schemes..."

  SCHEMES_PATH=$(grumpi::readProperty 'schemesPath')
  SCHEMES_PATH=$(grumpi::toAbsolutePath "$SCHEMES_PATH")

  if [ -z "$SCHEMES_PATH" ]; then
    echo "ZZZZZZZZZZZZZZZZZZ"
  fi
  if [ ! -e "$SCHEMES_PATH" ]; then
    echo "EEEEEEEEEEEEEEEEEEEEE"
  fi

  INITIAL_PATH=`pwd`
  cd $GRUMPI_BUILD_PATH

  mkdir VMAppWithKonylib/VMAppWithKonylib.xcodeproj/xcuserdata

  if [ -z "$SCHEMES_PATH" ] || [ ! -e "$SCHEMES_PATH" ]; then
    grumpi::io::error "Could not find the path to schemes files, or the schemesPath property is not set."
    grumpi::io::error "Please copy user.xcuserdatad from your XCode project and place it in a folder"
    grumpi::io::error "then ensure your properties file has a schemesPath property that points to such folder."
    grumpi::cleanAndExit
  fi

  cp -r $SCHEMES_PATH/user.xcuserdatad VMAppWithKonylib/VMAppWithKonylib.xcodeproj/xcuserdata/`whoami`.xcuserdatad

  cd $INITIAL_PATH
}
