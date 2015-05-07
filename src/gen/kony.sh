#!/bin/bash

function grumpi::gen::kony::extractKarIntoXCodeProject() {
  grumpi::io::echo "Extracting Kony iOS plugin..."

  INITIAL_PATH=`pwd`

  cd $GRUMPI_BUILD_PATH

  if [ -e VMAppWithKonylib ]; then
    rm -rf VMAppWithKonylib
  fi

  KONY_PATH=$(grumpi::readProperty 'konyPath')
  KONY_IOS_PLUGIN_PATH=$KONY_PATH/Kony_Studio/plugins/com.kony.ios*
  cp $KONY_IOS_PLUGIN_PATH .
  unzip -oq com.kony.ios*
  unzip -oq iOS-GA*

  grumpi::io::echo "Converting KAR into xcode project..."
  cd VMAppWithKonylib/gen
  perl extract.pl $KAR_PATH

  cd $INITIAL_PATH
}
