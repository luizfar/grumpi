#!/bin/bash

function grumpi::gen::kony::extractKarIntoXCodeProject() {
  grumpi::io::echo "Extracting Kony iOS plugin..."

  INITIAL_PATH=`pwd`

  cd $GRUMPI_BUILD_PATH

  if [ -e "$KONY_GENERATED_PROJECT_NAME" ]; then
    rm -rf "$KONY_GENERATED_PROJECT_NAME"
  fi

  KONY_PATH=$(grumpi::readPropertyAsPath 'konyPath')
  KONY_IOS_PLUGIN_PATH=$KONY_PATH/Kony_Studio/plugins/com.kony.ios*
  cp $KONY_IOS_PLUGIN_PATH .
  unzip -oq com.kony.ios*
  unzip -oq iOS-GA*

  grumpi::io::echo "Converting KAR into xcode project..."
  cd "$KONY_GENERATED_PROJECT_NAME"/gen
  perl extract.pl $KAR_PATH

  cd $INITIAL_PATH
}
