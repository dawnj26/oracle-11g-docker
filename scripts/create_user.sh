#!/bin/bash
set -e

read -rp "Enter Oracle username: " USER_TO_CREATE
read -rsp "Enter password: " USER_PASS
echo

if [[ ! "$USER_TO_CREATE" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
  echo "Invalid username format"
  exit 1
fi

# Basic validation (important, not optional in real usage)
if [[ -z "$USER_TO_CREATE" || -z "$USER_PASS" ]]; then
  echo "Username and password cannot be empty."
  exit 1
fi

sqlplus -s / as sysdba <<EOF

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dba_users
    WHERE username = UPPER('${USER_TO_CREATE}');

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE USER ${USER_TO_CREATE}
            IDENTIFIED BY ${USER_PASS}
            DEFAULT TABLESPACE users
            TEMPORARY TABLESPACE temp
        ';

        EXECUTE IMMEDIATE '
            GRANT CONNECT, RESOURCE TO ${USER_TO_CREATE}
        ';

        DBMS_OUTPUT.PUT_LINE('User created: ${USER_TO_CREATE}');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User already exists: ${USER_TO_CREATE}');
    END IF;
END;
/
EXIT;
EOF
