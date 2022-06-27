------------------------------------------------------------------------------
# HOWTO collec in Docker
# Christine Plumejeaud, 04 fevrier 2018 / mise à jour le 12/02/2018
------------------------------------------------------------------------------

Lire le readme https://github.com/collec-science/docker-collec
- Il explique comment installer Docker et Docker-compose
- On utilise Docker-compose.yml ainsi que les builds d'Apache (./web) et Postgres (./bd)
- En particulier, la dépendance à kartoza/postgis:9.5-2.2 a été supprimée
- L'application collec-web utilise collec-db, en postgres 9.6 et postgis 2.3

-----------------------------------------------------
# Préalable
-----------------------------------------------------

## Créer un répertoire d'accueil pour les données de la BDD

### Maintenant, on utilise les volumes virtuels

https://forums.docker.com/t/trying-to-get-postgres-to-work-on-persistent-windows-mount-two-issues/12456/5
https://forums.docker.com/t/data-directory-var-lib-postgresql-data-pgdata-has-wrong-ownership/17963/25

```
docker volume create --name pgdata -d local
```

```
docker volume ls
DRIVER              VOLUME NAME
local               pgdata
```

```
docker volume inspect pgdata
[
    {
        "CreatedAt": "2018-02-10T16:32:27Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/pgdata/_data",
        "Name": "pgdata",
        "Options": {},
        "Scope": "local"
    }
]
```

## Récupérer les sources Docker sur le github (par wget ou SCP ou GIT)

cd docker-collec


### Pour changer la version cible de collec, éditer /web/Dockerfile.apache pour remplacer ZIP et REP par les valeurs cibles
REP définit l'adresse Web qui sera servie par le pi.

Par exemple : https://raspberry.local/collec-master
Si
```
ENV ZIP master.zip
ENV REP collec-master
```

Par exemple : https://raspberry.local/collec-feature_metadata
Si
```
ENV ZIP feature_metadata.zip
ENV REP collec-feature_metadata
```

Par exemple : https://raspberry.local/collec-develop
Si
```
ENV ZIP develop.zip
ENV REP collec-develop
```

### Pour java, le home du jre diffère suivant qu'on compile sous Intel (server Linux ou tablette Windows) ou une puce ARM (Raspberry)
Modifier /web/Dockerfile.apache et commenter la bonne ligne

* Sur Windows ou Linux amd 64
```
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/
```

* Sur Raspberry, Rasbian, architecture ARM
```
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-armel/
```

-----------------------------------------------------
# Compiler l'image collec-web
-----------------------------------------------------

Elle dépend de collec-db (image à faire aussi).

## Tout nettoyer (images et containers)
```
docker system prune -a
```

## Forcer la recompilation (attention, risque d'écraser la base de données : avoir exporter les données avant)
- sur Ubuntu xenial : on compile avec Dockerfile
- sur Windows : on compile avec Dockerfile.postgres et Dockerfile.apache

```
docker-compose up --build
```

ou pour n'en faire qu'un partie (la BDD par exemple). On a 2 cibles : collec-db et collec-web
```
docker-compose up --build -d collec-db
```

## Voir les images
```
docker images
```


-----------------------------------------------------
# Exécuter le container
-----------------------------------------------------

Il instancie une image de collec-web, et écoute sur 4 ports
80 et 443 pour apache, 632 pour CUPS, et 5432 pour postgres

## Lancer le container (collec )
```
docker-compose up -d collec-web
```

## Tester en localhost (sur la tablette Windows, le navigateur cible l'application en local)
https://127.0.0.1/collec-master

## Tester sur le wifi de votre raspberry
https://172.24.1.1/collec-master

Attention, l'accès SSL avec un certificat auto-signé est configuré pour un nom de domaine bidon (local-collec)
implique de déclarer un mapping entre ce nom de domaine bidon et votre IP (wifi ou DNS réseau) de votre raspberry
Donc il faut éditer /etc/hosts et rajouter comme dans mon exemple (mon DNS à la maison est 192.168.1.21) : <IP> local-collec
Les PI, je les configure pour avoir l'IP suivant en Wifi :  172.24.1.1

```bash
sudo vi /etc/hosts

127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
192.168.1.21    local-collec
172.24.1.1      local-collec
127.0.1.1       raspberrypi
```

Accepter le certificat non valide de collec comme une exception.

## Vérifier l'état des containers (on build une image, qui peut s'exécuter dans plein de containers)

```
docker ps

CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                            NAMES
ea67f3c305ec        dockerwindows_collec-web   "/bin/sh -c /start.sh"   About an hour ago   Up About an hour    0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:632->631/tcp   dockerwindows_collec-web_1
e189b9491c97        dockerwindows_collec-db    "su - postgres -c ..."   2 hours ago         Up 2 hours          0.0.0.0:5432->5432/tcp                                           dockerwindows_collec-db_1
```

Normalement, on peut connecter pgadmin sur le port 5433 ou 5432 du localhost (127.0.0.1) et voir la BDD de collec

-----------------------------------------------------
# Mettre à jour le parametre APPLI_code
-----------------------------------------------------

## Option 1: Dans le container
```
psql -U collec -d collec -h collec-db -p 5432 -c "UPDATE  col.dbparam SET dbparam_value='DB_TERRAIN_XX' where dbparam_name='APPLI_code';"
```

## Option 2: à l'extérieur du container

port 5433 ou 5432 en fonction de la configuration du service collec-db dans docker-compose.yml)

```
psql -U collec -d collec -h 127.0.0.1 -p 5432 -c "UPDATE  col.dbparam SET dbparam_value='DB_TERRAIN_XX' where dbparam_name='APPLI_code';"
```

----------------------------------------------------
# Pour le debug
----------------------------------------------------

## séquence d'arret - rebuild - relance

```
docker stop 28d02c06b9c7
docker-compose build collec-web
docker-compose up -d collec-web
```

```
docker ps

CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                                                            NAMES
28d02c06b9c7        dockercollec_collec-web          "/bin/sh -c /start.sh"   21 hours ago        Up 2 hours          0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:632->631/tcp   dockercollec_collec-web_1
```


## Stopper le container (stop), puis supprimer l'image (rmi)

```
docker rmi -f dockercollec_collec
```

ou : 7d8464109972 : ID de l'image (par docker images)
```
docker rmi --force 7d8464109972
```

```
docker-compose down
```


## Tagger l'image après build de l'image

```
docker tag b9bb3203d25f cplume/collec_db:v1.12b
```

## Entrer dans un container pour editer le contener

Si 28d02c06b9c7 est le CONTAINER ID
```
docker exec -it 28d02c06b9c7 bash
```

## Récuperer une copie d'un fichier dans un container

docker cp <containerId>:/file/path/within/container /host/path/target

```
docker cp 28d02c06b9c7:/etc/ssl/certs/collec_crt.pem /home/plumegeo/GIT/docker-collec/build/collec_crt.pem
docker cp 28d02c06b9c7:/etc/ssl/private/collec_key.pem /home/plumegeo/GIT/docker-collec/build/collec_key.pem
```


-----------------------------------------------------
# Accès à la base de données COLLEC
-----------------------------------------------------

## A l'extérieur du container (5432 ou 5433 dépend de la configuration du Docker-compose.yml)
```
psql -U collec -d collec -p 5433 -h 127.0.0.1
password for collec : collec
\dt col.*
30 lignes
```

## Dans le container collec :
```
docker exec -it 28d02c06b9c7 bash # 28d02c06b9c7 est l'ID du container (voir docker ps)
psql -U collec -d collec -p 5432 -h 127.0.0.1
password for collec : collec
\dt col.*
30 lignes
```

### Installer plsql dans le container collec SI BESOIN

```
vi /etc/apt/sources.list
deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg-testing main
```

```
apt-get install wget
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
apt-get update
sudo apt-get -y install postgresql-client-9.5 --allow-unauthenticated
psql -U collec -d collec
```

```
apt-get install net-tools
```

```
netstat -na | grep 54*

tcp        0      0 0.0.0.0:5432            0.0.0.0:*               LISTEN
tcp6       0      0 :::5432                 :::*                    LISTEN
tcp6       0      0 :::5433                 :::*                    LISTEN
```

### Lancer postgres à la main SI BESOIN
```
/bin/sh /start-postgis.sh
Ctrl D
Ca continue
```

-------------------------------------------------------------------------------------------
# Configurer apache2 et SSL avec un certificat auto-signe pour le nom de domaine "local-collec"
-------------------------------------------------------------------------------------------

```
vi /etc/apache2/sites-enabled/default-ssl.conf

<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost
                ServerName local-collec
                DocumentRoot /var/www/html
				<Directory /var/www/html>
						Options Indexes FollowSymLinks Multiviews
						AllowOverride all
						RewriteEngine on
						Order allow,deny
						allow from all
				</directory>
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on
				# HSTS (mod_headers is required) (15768000 seconds = 6 months)
				Header always set Strict-Transport-Security "max-age=15768000"

                SSLCertificateFile      /etc/ssl/certs/collec_crt.pem
                SSLCertificateKeyFile /etc/ssl/private/collec_key.pem

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

        </VirtualHost>
</IfModule>
```

## Générer un certificat valide
https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/ex-series-ssl-certificates-generating.html
https://www.ibm.com/support/knowledgecenter/en/SSWHYP_4.0.0/com.ibm.apimgmt.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html
https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7

```
openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/collec_key.pem -x509 -days 365 -out /etc/ssl/certs/collec_crt.pem
```

```
 #CN : local-collec

	Country Name (2 letter code) [AU]:FR
	State or Province Name (full name) [Some-State]:
	Locality Name (eg, city) []:
	Organization Name (eg, company) [Internet Widgits Pty Ltd]:CNRS
	Organizational Unit Name (eg, section) []:Zones Ateliers
	Common Name (e.g. server FQDN or YOUR name) []:local-collec
	Email Address []:noreply@cnrs.fr
```


```
vi /etc/ssl/collec.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
C = FR
ST =
L = SomeCity
O = CNRS
OU = Zones Ateliers
CN = local-collec
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = www.company.com
DNS.2 = company.com
DNS.3 = www.company.net
DNS.4 = company.net
```

```
openssl req -new -nodes -newkey rsa:2048 -sha256 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -config /etc/ssl/collec.cnf
```


Donner les droits à apache2 (www-data user) de lire les certificats placés dans /etc/ssl/private
```
cd /etc/ssl
chmod -R g+r  /etc/ssl/private
```

L'utilisateur apache (www-data) est rajouté au groupe ssl-cert
```
usermod www-data -a -G ssl-cert
chown root:ssl-cert /etc/ssl/private/collec_key.pem
chmod g+r /etc/ssl/private/collec_key.pem
```

Activer les 2 sites (HTTP et HTTPS)
```
a2ensite 000-default.conf
a2ensite default-ssl.conf
```

```
service apache2 reload
```
