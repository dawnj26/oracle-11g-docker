#!/bin/bash

# Run initial configuration ONLY if the database files do not exist yet in the volume
echo "Initializing Oracle Database 11g Express Edition..."
/etc/init.d/oracle-xe configure responseFile=$ORACLE_PATH/oracle-xe.rsp >> /dev/null
