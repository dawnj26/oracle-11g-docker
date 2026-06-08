#!/bin/bash

LOG=$(find /u01/app/oracle/diag/rdbms -name "alert_*.log" | head -n 1)

exec tail -f "$LOG"
