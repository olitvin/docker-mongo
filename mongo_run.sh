#!/bin/bash

rm -rf /mongo_backup.sh
cat <<EOF >> /mongo_backup.sh
#!/bin/bash
NAME=\$1
CMD="mongodump --out /data/backup/\$NAME --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS"
echo "=> Backup started"
if \${CMD} ;then
  echo "Backup succeeded"
else
  echo "Backup failed"
  rm -rf /backup/\$NAME
fi
echo "=> Backup done"
EOF
chmod a+x /mongo_backup.sh

rm -rf /mongo_restore.sh
cat <<EOF >> /mongo_restore.sh
#!/bin/bash
NAME=\$1
CMD="mongorestore --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS /data/backup/\$NAME"
echo "=> Restore database from \$NAME"
if \${CMD} ;then
  echo "Restore succeeded"
else
  echo "Restore failed"
fi
echo "=> Done"
EOF
chmod a+x /mongo_restore.sh

set -m

rs=""
[[ -n ${MONGO_REPLICA} ]] && rs="--replSet \"${MONGO_REPLICA}\""
cmd="mongod --port $MONGO_PORT --storageEngine wiredTiger --oplogSize 1 ${rs}"
numa='numactl --interleave=all'
if $numa true &> /dev/null; then
	cmd="$numa $cmd"
fi

${cmd} &

if [ ! -f '/data/db/mongo_pwd.txt' ]; then
  RET=1
  while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo --port $MONGO_PORT admin --eval "help" >/dev/null 2>&1
    RET=$?
  done
  mongo --port $MONGO_PORT admin --eval "db.createUser({user:'$MONGO_USER',pwd:'$MONGO_PASS',roles:['root']});" \
    && echo "=> Created user/password for admin" || exit 0
  mongo --port $MONGO_PORT $MONGO_DB --eval "db.createUser({user:'$MONGO_USER',pwd:'$MONGO_PASS',roles:[{role:'readWrite',db:'$MONGO_DB'}]});" \
    && echo "=> Created user/password for $MONGO_DB" || exit 0
  touch /data/db/mongo_pwd.txt  
fi

fg
