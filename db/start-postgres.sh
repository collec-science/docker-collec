#!/bin/bash
# SCRIPT WRITE BY TIM SUTTON and modify by julien ancelin, Christine Plumejeaud
#This script will run as the postgres user due to the Dockerfile USER directive

DATADIR="/var/lib/postgresql/11/main"
CONF="/etc/postgresql/11/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/11/bin/postgres"
INITDB="/usr/lib/postgresql/11/bin/initdb"
LOCALONLY="-c listen_addresses='127.0.0.1, ::1'"
PGLOG="$DATADIR/serverlog"



PID=`cat /var/run/postgresql/11-main.pid`
kill -9 ${PID}
echo "Postgres  restarting in foreground"
SETVARS="POSTGIS_ENABLE_OUTDB_RASTERS=1 POSTGIS_GDAL_ENABLED_DRIVERS=ENABLE_ALL"

chown -R postgres:postgres /var/lib/postgresql
ls -l /var/lib/postgresql

ls -al /etc/postgresql/11/main/postgresql.conf
#ls -al /var/lib/postgresql/11/main/postgresql.conf

echo "Postgres will be started"

#su - postgres -c "id"

#su - postgres -c "$SETVARS $POSTGRES -D $DATADIR -c config_file=$CONF"
#service postgresql start
#su - postgres -c "$SETVARS $POSTGRES -D '$DATADIR' -c config_file=$CONF >>$PGLOG 2>&1 &"

su - postgres -c "/usr/lib/postgresql/11/bin/pg_ctl start -D /var/lib/postgresql/11/main -l /var/log/postgresql/postgresql-11-main.log -s -o '--config_file=/etc/postgresql/11/main/postgresql.conf'"
#su - postgres -c "/usr/lib/postgresql/11/bin/pg_ctl start -D /var/lib/postgresql/11/main -l /var/log/postgresql/postgresql-11-main.log"


#su - postgres -c "/usr/lib/postgresql/11/bin/pg_ctl start -D /var/lib/postgresql/11/main -l /var/log/postgresql/postgresql-11-main.log -s -o -c config_file=/etc/postgresql/11/main/postgresql.conf"
#su - postgres -c "/usr/lib/postgresql/11/bin/pg_ctl start -D /var/lib/postgresql/11/main -l /var/log/postgresql/postgresql-11-main.log -s"
#su - postgres -c "/usr/bin/pg_ctlcluster 11 main restart"
#exec /usr/bin/pg_c/usr/bin/pg_ctlcluster 11 main restarttlcluster 11 main restart
#su - postgres -c "POSTGIS_ENABLE_OUTDB_RASTERS=1 POSTGIS_GDAL_ENABLED_DRIVERS=ENABLE_ALL /usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main -c config_file=/etc/postgresql/11/main/postgresql.conf"

#chown -R postgres:postgres /var/lib/postgresql/11/main
#usermod root -a -G postgres
#su - postgres -c "exec /usr/bin/pg_ctlcluster 11 main restart"
#su - postgres -c "POSTGIS_ENABLE_OUTDB_RASTERS=1 POSTGIS_GDAL_ENABLED_DRIVERS=ENABLE_ALL /usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main -c config_file=/etc/postgresql/11/main/postgresql.conf"
#su - postgres -c "POSTGIS_ENABLE_OUTDB_RASTERS=1 POSTGIS_GDAL_ENABLED_DRIVERS=ENABLE_ALL /usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main -c config_file=/etc/postgresql/11/main/postgresql.conf &"


# wait for postgres to come up on port 5432
until `nc -z 127.0.0.1 5432`; do
    echo "$(date) - waiting for postgres."
    sleep 1
done
echo "postgres ready"

