#!/bin/bash

if [ -z $DB_USER ]; then
  echo 'entrypoint.sh needs a valid username $DB_USER to login to the mysql db master to restore'
  exit 1
fi
if [ -z $DB_PASSWORD ]; then
  echo 'entrypoint.sh needs a valid password $DB_PASSWORD to login to the mysql db master to restore'
  exit 1
fi
if [ -z $MASTER_DB_HOSTNAME ]; then
  echo 'entrypoint.sh needs the hostname $MASTER_DB_HOSTNAME of mysql db master to restore'
  exit 1
fi

RESTORE_DIR="/tmp"
RESTORE_FILE="cmangos-classic-backup.sql"
CUSTOM_SCRIPTS_DIR="/custom-scripts.d"

if [ ! -d $CUSTOM_SCRIPTS_DIR ]; then
  echo "Creating $CUSTOM_SCRIPTS_DIR"
  mkdir -p $CUSTOM_SCRIPTS_DIR
fi

cd $CUSTOM_SCRIPTS_DIR
for script in $(ls -A $CUSTOM_SCRIPTS_DIR); do
  case "$script" in
    *.sh)  echo "$0: running $script"; . "$script" "$RESTORE_DIR" "$RESTORE_FILE";;
       *)  echo "$0: ignoring $script";;
  esac
done

echo "restoring databases..."
/usr/bin/mysql -h $MASTER_DB_HOSTNAME --user=$DB_USER -p$DB_PASSWORD < $RESTORE_DIR/$RESTORE_FILE
echo "restoring databases complete"

exec $@
