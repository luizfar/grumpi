#!/bin/bash

function grumpi::gen::kony::extractKarIntoXCodeProject() {
  grumpi::io::echo "Extracting Kony iOS plugin..."

  INITIAL_PATH=`pwd`

  cd $GRUMPI_BUILD_PATH

  if [ -e VMAppWithKonylib ]; then
    rm -rf VMAppWithKonylib
  fi

  KONY_PATH=$( grumpi::readProperty 'konyPath' )
  if [ -z "$KONY_PATH" ] || [ ! -e "$KONY_PATH" ]; then
    grumpi::io::error "Path to Kony Studio installation not found, or konyPath property not set."
    grumpi::io::error "Please ensure Kony Studio is installed, and its path is set in your properties file."
    grumpi::cleanAndExit
  fi

  KONY_IOS_PLUGIN_PATH=$KONY_PATH/Kony_Studio/plugins/com.kony.ios*
  cp $KONY_IOS_PLUGIN_PATH .
  unzip -oq com.kony.ios*
  unzip -oq iOS-GA*

  grumpi::io::echo "Converting KAR into xcode project..."
  cd VMAppWithKonylib/gen
  perl extract.pl $KAR_PATH

  cd $INITIAL_PATH
}
