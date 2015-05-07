#!/bin/bash

function grumpi::gen::schemes::prepareXcodeProjectSchemes() {
  grumpi::io::echo "Preparing xcode project schemes..."

  SCHEMES_PATH=$(grumpi::readProperty 'schemesPath')
  SCHEMES_PATH=$(grumpi::toAbsolutePath "$SCHEMES_PATH")

  INITIAL_PATH=`pwd`
  cd $GRUMPI_BUILD_PATH

  mkdir "$KONY_GENERATED_PROJECT_NAME/$KONY_GENERATED_PROJECT_NAME.xcodeproj/xcuserdata"
  cp -r "$SCHEMES_PATH/user.xcuserdatad" "$KONY_GENERATED_PROJECT_NAME/$KONY_GENERATED_PROJECT_NAME.xcodeproj/xcuserdata/`whoami`.xcuserdatad"

  cd $INITIAL_PATH
}
