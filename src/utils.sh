#!/bin/bash

function grumpi::readProperty() {
  echo `grep "$1" "$PROP_FILE" | awk -F':' '{print $2}' | xargs`
}

function grumpi::readPropertyOrDie() {
  VALUE=`grumpi::readProperty "$1"`
  if [ -z "$VALUE" ]; then
    grumpi::io::error "Property '$1' not set or invalid."
    gurmpi::cleanAndExit 1
  fi
  echo "$VALUE"
}

function grumpi::die() {
  grumpi::cleanAndExit 1
}

function grumpi::cleanAndExit() {
  grumpi::io::echo 'Cleaning up...'
  EXIT_CODE=$1
  if [ -z "$EXIT_CODE" ]; then
    exit 0
  fi
  exit $EXIT_CODE
}

function grumpi::toAbsolutePath() {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}
