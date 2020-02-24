**DOCKER-collec-SCIENCE**

- [Présentation](#Pr%C3%A9sentation)
- [Installation de Docker](#Installation-de-Docker)
  - [Debian, Ubuntu ou Raspbian](#Debian-Ubuntu-ou-Raspbian)
  - [Windows](#Windows)
- [Installation des containers](#Installation-des-containers)
  - [lancer l'application web](#lancer-lapplication-web)
    - [Docker est installé dans l'ordinateur qui sert à accéder à l'application](#Docker-est-install%C3%A9-dans-lordinateur-qui-sert-%C3%A0-acc%C3%A9der-%C3%A0-lapplication)
    - [Docker est installé dans un Raspberry](#Docker-est-install%C3%A9-dans-un-Raspberry)
  - [Quelques commandes utiles de docker](#Quelques-commandes-utiles-de-docker)
  - [Sauvegarde de la base de données](#Sauvegarde-de-la-base-de-donn%C3%A9es)
  - [Mettre à jour l'application](#Mettre-%C3%A0-jour-lapplication)
    - [Réaliser une sauvegarde de la base de données](#R%C3%A9aliser-une-sauvegarde-de-la-base-de-donn%C3%A9es)
    - [Mettre à jour la base de données](#Mettre-%C3%A0-jour-la-base-de-donn%C3%A9es)
    - [Mettre à jour l'application](#Mettre-%C3%A0-jour-lapplication-1)
- [Utilisation d'un Raspberry Pi](#Utilisation-dun-Raspberry-Pi)
  - [Installation de Raspbian](#Installation-de-Raspbian)
  - [Connexion en ssh](#Connexion-en-ssh)
  - [Installation de Docker et de l'application](#Installation-de-Docker-et-de-lapplication)
  - [Modifier les droits pour la sauvegarde de la base de données](#Modifier-les-droits-pour-la-sauvegarde-de-la-base-de-donn%C3%A9es)
  - [Créer un réseau wifi pour connecter directement les terminaux](#Cr%C3%A9er-un-r%C3%A9seau-wifi-pour-connecter-directement-les-terminaux)
- [Remerciements](#Remerciements)
- [Licence](#Licence)

# Présentation

Le logiciel [Collec-Science](https://github.com/Irstea/collec) permet de gérer les échantillons collectés sur le terrain. Il est possible d'en créer une instance pour réaliser des saisies directes.

Pour cela, le logiciel doit pouvoir être embarqué à bord d'un ordinateur de terrain (portable ou tablette Windows ou Linux, ou Raspberry Pi). La technologie choisie est celle basée sur les containers Docker, pour pouvoir installer une base de données Postgresql et un serveur Web Apache2 pour héberger le code PHP.

Les scripts fournis permettent d'installer deux containers Docker, l'un pour héberger la base de données, l'autre pour le serveur Web.

Cette solution est également utilisable pour exécuter collec-Science sur tout OS autre (CentOS, Windows, etc.), tout en garantissant le fonctionnement dans l'environnement Debian.

# Installation de Docker
## Debian, Ubuntu ou Raspbian

```
    sudo -s
    apt-get update
    apt-get install curl
    curl -fsSL https://get.docker.com/ | sh
    apt-get install docker-compose
    systemctl enable docker
    service docker start
    groupadd docker
    usermod -aG docker $USER
```
## Windows
Suivez les instructions décrites ici : [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).

Installez également le programme *PowerShell* de Windows, qui vous permettra d'ouvrir un terminal et de lancer les commandes manuelles.

# Installation des containers
Les commandes sont données pour Linux. Pensez à adapter la démarche à Windows (téléchargement manuel depuis un navigateur, décompression avec Windows, etc.).

Téléchargez le code de ce dépôt dans un dossier de votre ordinateur :
```
sudo apt-get install wget unzip
wget https://github.com/Irstea/collec-docker/archive/master.zip
unzip master.zip
cd collec-docker-master
```
Créez un volume Docker pour héberger la base de données Postgresql :
```
docker volume create --name collecpgdata -d local
```
Créez les deux images et les containers associés :
```
docker-compose up --build
```
Si tout se passe bien, vous retrouverez les images suivantes :
```
docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
collec-docker_collec-web       latest              834d8fd9f504        18 hours ago        782MB
collec-docker_collec-db        latest              78d95ff5fea4        19 hours ago        888MB
```

Et les containers :
```
docker container ls
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                      NAMES
125eafce92ac        collec-docker_collec-web   "/bin/sh -c /start.sh"   56 seconds ago      Up 54 seconds       0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   collec-docker_collec-web_1
4f6b43a1261a        collec-docker_collec-db    "su - postgres -c 'P…"   17 hours ago        Up 10 minutes       0.0.0.0:5433->5432/tcp                     collec-docker_collec-db_1
```

**Attention :** le serveur web expose les ports 80 et 443. Si vous avez déjà un serveur web qui fonctionne dans votre ordinateur, vous devrez arrêter votre serveur web local avant de lancer le démarrage des containers.

Si vous avez installé le client Postgresql dans votre ordinateur, le serveur postgresql sera accessible depuis le port 5433, en localhost :
```
psql -U collec -h localhost -p 5433
Mot de passe pour l'utilisateur collec : collecPassword
psql (11.5 (Ubuntu 11.5-3.pgdg18.04+1))
Connexion SSL (protocole : TLSv1.3, chiffrement : TLS_AES_256_GCM_SHA384, bits : 256, compression : désactivé)
Saisissez « help » pour l'aide.

collec=#
```
## lancer l'application web
### Docker est installé dans l'ordinateur qui sert à accéder à l'application
C'est le cas d'un ordinateur portable Windows ou Linux. Dans un premier temps, récupérez l'adresse IP du serveur Web :
```
docker exec collec-docker_collec-web_1 ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.19.0.3  netmask 255.255.0.0  broadcast 172.19.255.255
```
Ici, le container s'est vu attribué l'adresse IP *172.19.0.3*.

Ajoutez une ligne dans votre fichiers /etc/hosts (Linux) ou  c:\Windows\System32\drivers\etc\hosts  (Windows) :
```
172.19.0.3 collec-docker collec-docker.local
```
Dans votre navigateur, allez sur le site : [https://collec-docker.local](https://collec-docker.local). Acceptez l'exception de sécurité : vous devriez accéder à l'application.

Vous pouvez vous connecter avec le login *admin*, mot de passe *password* : il s'agit d'une installation par défaut. Pensez ensuite à supprimer le compte admin ou à en changer le mot de passe, quand vous travaillerez en production (sauf accès uniquement local).

### Docker est installé dans un Raspberry

Consultez la documentation correspondante  dans le chapitre [Utilisation d'un Raspberry Pi](#Utilisation-dun-Raspberry-Pi).

## Quelques commandes utiles de docker

Les commandes *docker-compose* doivent être exécutées depuis le dossier collec-docker-master.

* docker images : affiche la liste des images disponibles
* docker container ls : affiche la liste des containers
* docker stop collec-docker-master_collec-web_1 : arrête le container contenant l'image collec-web
* docker start collec-docker-master_collec-web_1 &! : démarre le container précédemment arrêté
* docker-compose up -d : démarre les collec-web et collec-db dans leurs containers respectifs, en les recréant
* docker exec -ti collec-docker_collec-web_1 /bin/bash : se connecte au container et permet d'exécuter des commandes
* docker rmi collec-docker_collec-web --force : supprime brutalement l'image collec-web
* docker-compose up --build : recrée les deux images. Attention : la base de données va être recréée !
* docker update --restart=no collec-docker_collec-web_1 : désactive le démarrage automatique du container
* docker inspect collec-docker_collec-web_1 : affiche le paramétrage courant du container
* docker system prune -a : supprime toutes les images, pour réinitialiser docker

## Sauvegarde de la base de données
L'image *collec-db* intègre une sauvegarde automatique de la base de données, qui se déclenche tous les jours à 13:00. Vous la retrouverez dans votre ordinateur, dans le dossier *Dossier personnel/collecpgbackup*. Pensez à la déplacer vers un autre emplacement sur le réseau, pour éviter de tout perdre en cas de crash ou de vol de l'ordinateur.

## Mettre à jour l'application

La mise à jour de l'application va être réalisée en deux étapes :
* d'une part, en mettant à jour la base de données, si c'est nécessaire ;
* d'autre part, en recréant l'image *collec-web*.

Pour pouvoir télécharger le code de l'application, votre ordinateur doit être connecté à Internet. Utilisez un câble Ethernet si vous travaillez avec un Raspberry-pi.

### Réaliser une sauvegarde de la base de données
```
docker exec -ti collec-docker-master_collec-db_1 bash
su - postgres -c /var/lib/postgresql/backup.sh
```
Vous devriez retrouver vos fichiers de sauvegarde dans le dossier ~/collecpgbackup de votre ordinateur (~ correspond à votre dossier par défaut).

### Mettre à jour la base de données

Récupérez le numéro de la version de la base de données actuelle :
```
docker exec -ti collec-docker-master_collec-db_1 bash
su postgres -c 'psql collec -c "select dbversion_number from col.dbversion order by dbversion_date desc limit 1"'
```
Recherchez dans le dépôt Github s'il existe un script de modification de la base de données (dans [https://github.com/Irstea/collec/tree/master/install/pgsql](https://github.com/Irstea/collec-science/tree/master/install/pgsql)). Le script est sous la forme :
```
alter-1.1-1.2.sql
```
où 1.1 correspond à la version courante de votre base de données, et 1.2 à la version à atteindre.

Dans votre container Docker, téléchargez le script :
```
su - postgres
wget https://github.com/Irstea/collec-science/raw/master/install/pgsql/alter-1.1-1.2.sql
```
et exécutez ce script :
```
psql -U collec collec -h localhost -f alter-1.2-1.3.sql
```
Le mot de passe par défaut est : collecPassword

Si vous avez quelques versions de retard, vous devrez exécuter les scripts successivement pour arriver au niveau de la version courante.

Quittez le container par appui sur ctrl-D (au besoin, plusieurs fois).

### Mettre à jour l'application

Sauvegardez les fichiers de paramétrage :
```
mkdir param
docker cp collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/param.inc.php param/
docker cp collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/id_collec-science param/
docker cp collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/id_collec-science.pub param/
```

Arrêtez le container, puis recréez l'image :
```
docker stop collec-docker-master_collec-web_1
cd collec-docker-master
docker compose up --build collec-web &!
```
Docker va recréer l'image en chargeant la nouvelle version de l'application. Une fois le container démarré, réintégrez les fichiers de paramétrage sauvegardés précédemment :
```
cd ..
docker cp param/param.inc.php collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/
docker cp param/id_collec-science collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/
docker cp param/id_collec-science.pub collec-docker-master_collec-web_1:/var/www/collec-science/collec-science/param/
```
*Attention :* si vous recréez le container, vous devrez relancer la copie des fichiers de paramétrage.

# Utilisation d'un Raspberry Pi
## Installation de Raspbian

Pour l'installation de Raspbian, consultez la [documentation d'installation de Raspberry](https://www.raspberrypi.org/documentation/).

Pensez à activer l'accès via ssh, et désactivez l'interface graphique au démarrage, qui consomme des ressources et est sans intérêt dans le contexte de collec-Science.

## Connexion en ssh
Pour vous connecter à votre Raspberry, utilisez la commande :
```
ssh pi@adresse_ip
```
Une fois connecté, tapez la commande :
```
sudo -s
```
si vous avez besoin de travailler en mode *root*.

## Installation de Docker et de l'application

Reprenez les instructions détaillées en début de document.

## Modifier les droits pour la sauvegarde de la base de données

En étant connecté avec le compte *pi* :
```
cd /home/pi
sudo chown pi:pi collecpgbackup
chmod 777 collecpgbackup
```

## Créer un réseau wifi pour connecter directement les terminaux

Suivez les instructions définies dans le premier chapitre de ce document : [https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) (*Setting up a Raspberry Pi as an access point in a standalone network (NAT)*).

Adpatez le contenu du fichier */etc/hostapd/hostapd.conf*, et notamment :
* ssid=collec-docker
* wpa_passphrase=votre_mot_de_passe

Editez ensuite le fichier */etc/dnsmasq.conf*, et rajoutez ces lignes :
```
server=8.8.8.8
address=/collec-docker.local/192.168.4.1
```
La ligne *server* correspond au serveur d'adresses web (DNS) de Google. Si vous souhaitez utiliser un autre DNS, par exemple celui de votre organisme, modifiez cette ligne.

Redémarrez le Raspberry, et connectez-vous au réseau wifi *collec-docker*. Testez la communication avec l'application, en entrant l'adresse suivante dans un navigateur : https://collec-docker.local. Vous devez accéder à la page d'accueil. En cas de problème d'accès (adresse non reconnue), vous pouvez également vous connecter directement à l'adresse IP : https://192.168.4.1.

<!--- Cette configuration vous permet de charger les dalles Openstreetmap avant de partir sur le terrain :
* au bureau, connectez le Raspberry au réseau local avec un câble Ethernet
* connectez votre tablette au Raspberry en wifi
* lancez l'application, à l'adresse https://192.168.4.1.
* ouvrez le module *Paramètres>Mise en cache de la cartographie*, et téléchargez les dalles dont vous aurez besoin sur le terrain
* arrêtez le Raspberry, déconnectez le câble Ethernet, fermez le navigateur de votre tablette
* redémarrez le Raspberry, reconnectez la tablette au wifi, et rouvrez l'application : les dalles sont accessibles sans que vous soyez connectés à Internet.
-->

# Licence

Les scripts sont diffusés sous licence MIT.