#!/bin/bash

function grumpi::grumpiName() {
  GRUMPI_NAME=$(grumpi::readProperty 'name')
  if [ -z "$GRUMPI_NAME" ]; then
    GRUMPI_NAME="grumpi"
  fi
  echo "$GRUMPI_NAME"
}

function grumpi::readProperty() {
  echo `grep "^$1" "$PROP_FILE" | awk -F':' '{print $2}' | xargs`
}

function grumpi::die() {
  grumpi::cleanAndExit 1
}

function grumpi::cleanAndExit() {
  grumpi::io::echo 'Cleaning up...'
  grumpi::gen::cleanup
  EXIT_CODE=$1
  if [ -z "$EXIT_CODE" ]; then
    exit 0
  fi
  exit $EXIT_CODE
}

function grumpi::toAbsolutePath() {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

function grumpi::getProjectPath() {
  SOURCE=$(grumpi::readProperty 'source')

  if [ $SOURCE == 'kony' ]; then
    PROJECT_PATH="$GRUMPI_BUILD_PATH/$KONY_GENERATED_PROJECT_NAME"
  else
    PROJECT_PATH=$(grumpi::readProperty 'projectPath')
    PROJECT_PATH=$(grumpi::toAbsolutePath "$PROJECT_PATH")
  fi

  echo "$PROJECT_PATH"
}

function grumpi::getXCodeProjectId() {
  PROJECT_PATH=$(grumpi::getProjectPath)
  PROJECT_ID=$(find "$PROJECT_PATH" -name '*.xcodeproj')
  PROJECT_ID=$(basename -- "$PROJECT_ID")
  PROJECT_ID=$(echo "$PROJECT_ID" | sed -e 's/\.xcodeproj//g')
  echo "$PROJECT_ID"
}
