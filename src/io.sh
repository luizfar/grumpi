#!/bin/bash

GRUMPI_PREFIX="grumpi:"

GRUMPI_COLOR_CYAN="\033[0;36m"
GRUMPI_COLOR_PURPLE="\033[0;35m"
GRUMPI_COLOR_RED="\033[0;31m"
GRUMPI_COLOR_NO_COLOR="\033[0m"

function grumpi::io::echo() {
  echo -e "${GRUMPI_COLOR_CYAN}$GRUMPI_PREFIX ${GRUMPI_COLOR_PURPLE}$@${GRUMPI_COLOR_NO_COLOR}"
}

function grumpi::io::echoln() {
  grumpi::io::echo $@
  echo ""
}

function grumpi::io::error() {
  echo -e "${GRUMPI_COLOR_CYAN}$GRUMPI_PREFIX ${GRUMPI_COLOR_RED}$@${GRUMPI_COLOR_NO_COLOR}"
}
