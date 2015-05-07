#!/bin/bash

function grumpi::gen::schemes::getSchemeDir() {
  PROJECT_PATH=$(grumpi::getProjectPath)
  PROJECT_PATH=$(grumpi::toAbsolutePath "$PROJECT_PATH")
  PROJECT_ID=$(grumpi::getXCodeProjectId)
  SCHEME_DIR="$PROJECT_PATH/$PROJECT_ID.xcodeproj/xcuserdata/`whoami`.xcuserdatad/xcschemes"
  echo "$SCHEME_DIR"
}

function grumpi::gen::schemes::getSchemePath() {
  SCHEME_DIR=$(grumpi::gen::schemes::getSchemeDir)
  echo "$SCHEME_DIR/KRelease.xcscheme"
}

function grumpi::gen::schemes::prepareXcodeProjectSchemes() {
  grumpi::io::echo "Preparing xcode project schemes..."

  PROJECT_ID=$(grumpi::getXCodeProjectId)
  SCHEME_DIR=$(grumpi::gen::schemes::getSchemeDir)
  SCHEME_PATH=$(grumpi::gen::schemes::getSchemePath)

  if [ -f "$SCHEME_PATH" ]; then
    cp "$SCHEME_PATH" "$SCHEME_PATH.bak"
  else
    mkdir -p "$SCHEME_DIR"
  fi

  SAMPLE_PATH="$ROOT_DIR/src/samples/KRelease.xcscheme"
  cp "$SAMPLE_PATH" "$SCHEME_PATH"
  sed -i.bak "s/%APP_NAME%/$GRUMPI_NAME/g" "$SCHEME_PATH"
  sed -i.bak "s/%PROJECT_NAME%/$PROJECT_ID/g" "$SCHEME_PATH"
  rm "$SCHEME_PATH.bak"
}

function grumpi::gen::schemes::cleanup() {
  SCHEME_PATH=$(grumpi::gen::schemes::getSchemePath)
  if [ -f "$SCHEME_PATH.bak" ]; then
    mv "$SCHEME_PATH.bak" "$SCHEME_PATH"
  fi
}
