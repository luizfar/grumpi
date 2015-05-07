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
  EXIT_CODE=$1
  if [ -z "$EXIT_CODE" ]; then
    exit 0
  fi
  exit $EXIT_CODE
}

function grumpi::toAbsolutePath() {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}
