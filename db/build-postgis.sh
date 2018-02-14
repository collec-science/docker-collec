#!/bin/bash
# SCRIPT WRITE BY TIM SUTTON and modify by julien ancelin, Christine Plumejeaud
#This script will run as the postgres user due to the Dockerfile USER directive

DATADIR="/var/lib/postgresql/9.6/main"
CONF="/etc/postgresql/9.6/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.6/bin/postgres"
INITDB="/usr/lib/postgresql/9.6/bin/initdb"
SQLDIR="/usr/share/postgresql/9.6/contrib/postgis-2.2/"
LOCALONLY="-c listen_addresses='127.0.0.1, ::1'"

#Christine : ajouter postgres au groupe ssl-cert qui a le droit de lire le repertoire des cles privees
command addgroup --system 'ssl-cert'
usermod postgres -a -G ssl-cert
ls -al /etc/ssl
chown root:ssl-cert /etc/ssl/private/*
chmod -R g+r /etc/ssl/private

## Générate the SSL certificate for postgres
openssl req -new -x509 -days 365 -nodes -text -out $DATADIR/server.crt -keyout $DATADIR/server.key -config /etc/ssl/collec.cnf
chmod og-rwx $DATADIR/server.key
chown postgres $DATADIR/server.key


# Needed under debian, wasnt needed under ubuntu
if [ ! -d /var/run/postgresql/9.6-main.pg_stat_tmp ]; then
	mkdir /var/run/postgresql/9.6-main.pg_stat_tmp
	chmod 0777 /var/run/postgresql/9.6-main.pg_stat_tmp
fi

# test if DATADIR is existent
if [ ! -d $DATADIR ]; then
  echo "Creating Postgres data at $DATADIR"
  mkdir -p $DATADIR
fi

id postgres

# needs to be done as root:
chown -R postgres:postgres $DATADIR

# Note that $POSTGRES_USER and $POSTGRES_PASS below are optional paramters that can be passed
# via docker run e.g.
#docker run --name="postgis" -e POSTGRES_USER=qgis -e POSTGRES_PASS=qgis -d -v
#/var/docker-data/postgres-dat:/var/lib/postgresql -t qgis/postgis:6

# If you dont specify a user/password in docker run, we will generate one
# here and create a user called 'docker' to go with it.


# test if DATADIR has content
if [ ! "$(ls -A $DATADIR)" ]; then

  # No content yet - first time pg is being run!
  # Initialise db
  echo "Initializing Postgres Database at $DATADIR"
  #chown -R postgres $DATADIR
  su - postgres -c "$INITDB $DATADIR"
fi

# Make sure we have a user set up
if [ -z "$POSTGRES_USER" ]; then
  POSTGRES_USER=collec
fi
if [ -z "$POSTGRES_PASS" ]; then
  POSTGRES_PASS=collec
fi
# Enable hstore and topology by default
if [ -z "$HSTORE" ]; then
  HSTORE=true
fi
if [ -z "$TOPOLOGY" ]; then
  TOPOLOGY=true
fi

# Custom IP range via docker run -e (https://docs.docker.com/engine/reference/run/#env-environment-variables)
# Usage is: docker run [...] -e ALLOW_IP_RANGE='192.168.0.0/16'
if [ "$ALLOW_IP_RANGE" ]
then
  echo "host    all             all             0.0.0.0/0              md5" >> /etc/postgresql/9.6/main/pg_hba.conf
fi

# redirect user/pass into a file so we can echo it into
# docker logs when container starts
# so that we can tell user their password
echo "postgresql user: $POSTGRES_USER" > /tmp/PGPASSWORD.txt
echo "postgresql password: $POSTGRES_PASS" >> /tmp/PGPASSWORD.txt
#COMMENTED by CHRISTINE
su - postgres -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF <<< \"CREATE USER $POSTGRES_USER WITH SUPERUSER ENCRYPTED PASSWORD '$POSTGRES_PASS';\""

#su - postgres -c "$POSTGRES --single -d $DATADIR -c config_file=$CONF" <<< \"DO $body$ BEGIN IF NOT EXISTS ( SELECT * FROM pg_catalog.pg_user WHERE usename = '$POSTGRES_USER') THEN CREATE USER $POSTGRES_USER WITH SUPERUSER ENCRYPTED PASSWORD '$POSTGRES_PASS'; END IF; END $body$; \""
#su - postgres -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF"

trap "echo \"Sending SIGTERM to postgres\"; killall -s SIGTERM postgres" SIGTERM

su - postgres -c "$POSTGRES -D $DATADIR -c config_file=$CONF $LOCALONLY" &

# wait for postgres to come up
until `nc -z 127.0.0.1 5432`; do
    echo "$(date) - waiting for postgres localhost-only..."
    sleep 1
done
echo "postgres ready"


RESULT=`su - postgres -c "psql -l | grep postgis | wc -l"`
if [[ ${RESULT} == '1' ]]
then
    echo 'Postgis Already There'

    if [[ ${HSTORE} == "true" ]]; then
        echo 'HSTORE is only useful when you create the postgis database.'
    fi
    if [[ ${TOPOLOGY} == "true" ]]; then
        echo 'TOPOLOGY is only useful when you create the postgis database.'
    fi
else
    echo "Postgis is missing, installing now"
    echo "Creating template postgis"
    su - postgres -c "createdb template_postgis -E UTF8 -T template0"
    echo "Enabling template_postgis as a template"
    CMD="UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';"
    su - postgres -c "psql -c \"$CMD\""
    echo "Loading postgis extension"
    su - postgres -c "psql template_postgis -c 'CREATE EXTENSION postgis;'"

    if [[ ${HSTORE} == "true" ]]
    then
        echo "Enabling hstore in the template"
        su - postgres -c "psql template_postgis -c 'CREATE EXTENSION hstore;'"
    fi
    #if [[ ${TOPOLOGY} == "true" ]]
    #then
    #    echo "Enabling topology in the template"
    #    su - postgres -c "psql template_postgis -c 'CREATE EXTENSION postgis_topology;'"
    #fi

    #initialisation de la base collec + lancement du script de fabrication de la base

    su - postgres -c " createdb -O collec -T template_postgis collec "
    #su - postgres -c " psql collec -c 'CREATE EXTENSION postgis_topology ;'"
    su - postgres -c " psql collec -f /collec.sql "
    echo "DB COLLEC & data created "

fi
# This should show up in docker logs afterwards
su - postgres -c "psql -l"

echo "Postgres initialisation process completed."




