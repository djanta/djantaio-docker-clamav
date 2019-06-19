#!/bin/bash

# ---------------------------------------------------------------------------
# clamav-entrypoint.sh - This script will be use to provide our platform deployment client.sh architecture

# Copyright 2015, Stanislas KOFFI ASSOUTOVI <team.docker@djanta.io>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: ./entrypoint.sh [-h|--help]

# Revision history:
# ---------------------------------------------------------------------------

# bootstrap clam av service and clam av database updater shell script

set -m

# start clam service itself and the updater in background as daemon
freshclam -d &
clamd &

# recognize PIDs
pidlist=`jobs -p`

# initialize latest result var
latest_exit=0

# define shutdown helper
function shutdown () {
  trap "" SIGINT

  for single in $pidlist; do
    if ! kill -0 $pidlist 2>/dev/null; then
      wait $pidlist
      exitcode=$?
    fi
  done
  kill $pidlist 2>/dev/null
}

# run shutdown
trap shutdown SIGINT
wait

# return received result
exit $latest_exit
