#!/bin/bash

function grumpi::gen::schemes::prepareXcodeProjectSchemes() {
  grumpi::io::echo "Preparing xcode project schemes..."

  SCHEMES_PATH=$(grumpi::readProperty 'schemesPath')
  SCHEMES_PATH=$(grumpi::toAbsolutePath "$SCHEMES_PATH")

  INITIAL_PATH=`pwd`
  cd $GRUMPI_BUILD_PATH

  mkdir VMAppWithKonylib/VMAppWithKonylib.xcodeproj/xcuserdata
  cp -r $SCHEMES_PATH/user.xcuserdatad VMAppWithKonylib/VMAppWithKonylib.xcodeproj/xcuserdata/`whoami`.xcuserdatad

  cd $INITIAL_PATH
}
