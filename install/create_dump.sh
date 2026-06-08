#!/bin/bash

echo "Creating DUMP_DIR directory..."
su -p oracle -c "$ORACLE_HOME/bin/sqlplus / as sysdba <<EOF
    CREATE OR REPLACE DIRECTORY DUMP_DIR AS '/u01/app/oracle/scripts/imports';
    GRANT READ, WRITE ON DIRECTORY DUMP_DIR TO SYSTEM;
    GRANT READ, WRITE ON DIRECTORY DUMP_DIR TO SYS;
EOF" > /dev/null 2>&1
