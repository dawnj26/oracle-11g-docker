#!/bin/bash
set -e

function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down database!"
   /etc/init.d/oracle-xe stop
}

function _kill() {
   echo "SIGKILL received, shutting down database!"
   /etc/init.d/oracle-xe stop
}

trap _term SIGTERM
trap _kill SIGKILL

output=$(/etc/init.d/oracle-xe start 2>&1)

if echo "$output" | grep -q "not configured"; then
  $STARTUP_DIR/init_db.sh
fi

$STARTUP_DIR/watch_logs.sh
