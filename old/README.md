
[![Try in PWD](https://cdn.rawgit.com/play-with-docker/stacks/cff22438/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/jancelin/docker-collec/master/docker-compose.yml)

COLLEC RPI
============

FROM Irstea/collec pour une utilisation sur le terrain en mode déconnecté 

**https://github.com/Irstea/collec**


INSTALLATION sur RASPBERRY PI 3 from scratch
------------

* Télécharger RASPBIAN jessie Lite : https://downloads.raspberrypi.org/raspbian_lite_latest

* Flasher raspbian jessie sur une Micro SD avec ETCHER: https://etcher.io/

* Insérer la micro SD dans le raspberry pi3, connecter un cable ethernet, allumer.

* Activer SSH sur le pi3

* Se connecter en ssh au raspberry

```
ssh pi@raspberry.local
```

> MDP: raspberry

* Installer docker engine: https://docs.docker.com/engine/installation/

```
  sudo apt-get update
  sudo apt-get install curl
  curl -fsSL https://get.docker.com/ | sh
  sudo systemctl enable docker
  sudo service docker start
  sudo groupadd docker
  sudo usermod -aG docker $USER
```

* Installer docker compose: https://docs.docker.com/compose/install/

```
sudo apt-get install python-pip
sudo pip install docker-compose
```

* Lire docker-things : 

- il n'est plus nécessaire de créer de répertoire de stockage des données mais il faut créer un volume pour Docker
- il vaut mieux télécharger le contenu du GIT sur votre device (raspberry ou windows 10 pro)
- il faut personnaliser votre base de données collec12b.sql avec votre propre export de votre base server collec. 
- modifier en particulier danq collec12b.sql les paramètre de l'application APPLI_code pour donner un nom unique de BDD à votre base collec (Administration --> paramètres de l'application)
- il faut veiller aux conflits réseau (si une base postgres tourne déja en 5432 ou un apache en 80/443 sur votre machine hors docker, éditer le fichier Docker-compose.yml)
- il faut éditer Dockerfile.apache pour la variable JAVA_HOME et vérifier qu'elle pointe sur le bon environnement (ARM ou AMD64)

```
docker volume create --name pgdata -d local
```

- compiler votre image UNE fois 
```
docker-compose up --build -d collec-web
```

- exécuter/relancer un container correspondant à cette image
```
docker-compose up -d collec-web
```

- ne pas oublier sur votre device de déclarer le mapping entre son IP et votre nom de domaine bidon dans /etc/hosts : local-collec
(lire docker-things)

- Attendre 2 minutes que la base soit générée et se rendre sur https://raspberry.local/collec-master pour accéder à la démo.

https://IP/collec-master

Accepter l'exception de sécurité sur votre certificat bidon. 

> Login: admin

> MDP: password

- ne pas oublier de mettre à jour APPLI_code (soit directement dans l'interface, soit en ligne de commande psql (lire docker_things)


--------------------------------------------------------------------------------

VERIFICATION ET RELANCE sur RASPBERRY PI 3 (avant le terrain)
------------


0. Brancher le raspberry sur sa batterie. Se connecter en wifi sur le réseau wifi de votre raspberry (exemple : Pi3_zapvs01)
Normalement le réseau Wifi se lance automatiquement. Depuis votre PC, vous choisissez de vous connecter exclusivement sur ce réseau.
Les Wifi des raspberry sont protégés par un mot de passe : oliver07 par exemple

1. Vérifier depuis votre ordinateur de bureau que tout fonctionne sous Chrone
https://172.24.1.1/collec-master/
Accepter l'exception de sécurité.
Si tout va bien, passer au point 7 directement. 
Sinon allez au point 2.  

2. Lancer Putty et se connecter sur 172.24.1.1
login : pi
mot de passe : celui de votre raspberry (oliver_79 par exemple)

3. Se placer dans le repertoire synchronisé avec GIT contenant les instructions de compilation de vos images
```
cd GIT/docker_collec
```

4. Vérifier l'état de vos images : 
```
docker ps
```
Normalement, collec-db (port 5432) et collec-web (port 80 et 443) fonctionnent

5. Si problème, arrêter et relancer les containers
```
docker-compose down --remove-orphans
docker-compose up -d collec-web
```

6. Re-Vérifier depuis votre ordinateur de bureau que tout fonctionne sous Chrone
https://172.24.1.1/collec-master/
Accepter l'exception de sécurité
login (par exemple) : terrain
Si tout va bien, passer au point 7 directement. 
Si cela ne fonctionne pas, appeler votre informaticien référent.

7. Si tout va bien, mettre le raspberry et sa batterie dans un sac à dos (ou un tupperware) à porter avec vous au terrain. 

COLLEC
============
Collec est un logiciel destiné à gérer les collections d'échantillons prélevés sur le terrain.

Écrit en PHP, il fonctionne avec une base de données Postgresql. Il est bâti autour de la notion d'objets, qui sont identifiés par un numéro unique. Un objet peut être de deux types : soit un container (aussi bien un site, un bâtiment, une pièce, un congélateur, une caisse...) qu'un échantillon. 
Un type d'échantillon peut être rattaché à un type de container, quand les deux notions se superposent (le flacon contenant le résultat d'une pêche est à la fois un container et l'échantillon lui-même).
Un objet peut se voir attacher plusieurs identifiants métiers différents, des événements, ou des réservations.
Un échantillon peut être subdivisé en d'autres échantillons (du même type ou non). Il peut contenir plusieurs éléments identiques (notion de sous-échantillonnage), comme des écailles de poisson indifférenciées.
Un échantillon est obligatoirement rattaché à un projet. Les droits de modification sont attribués au niveau du projet.

Fonctionnalités principales
---------------------------
- Entrée/sortie du stock de tout objet (un container peut être placé dans un autre container, comme une boite dans une armoire, une armoire dans une pièce, etc)
- possibilité de générer des étiquettes avec ou sans QRCODE
- gestion d'événements pour tout objet
- réservation de tout objet
- lecture par scanner (douchette) des QRCODE, soit objet par objet, soit en mode batch (lecture multiple, puis intégration des mouvements en une seule opération)
- lecture individuelle des QRCODES par tablette ou smartphone (testé, mais pas très pratique pour des raisons de performance)
- ajout de photos ou de pièces jointes à tout objet

Sécurité
--------
- logiciel homologué à Irstea, résistance à des attaques opportunistes selon la nomenclature de l'OWASP (projet ASVS), mais probablement capable de répondre aux besoins du niveau standard
- identification possible selon plusieurs modalités : base de comptes interne, annuaire ldap, ldap - base de données (identification mixte), via serveur CAS, ou par délégation à un serveur proxy d'identification, comme LemonLDAP, par exemple
- gestion des droits pouvant s'appuyer sur les groupes d'un annuaire LDAP

Licence
-------
Logiciel diffusé sous licence AGPL

Copyright
---------
La version 1.0 a été déposée auprès de l'Agence de Protection des Programmes sous le numéro IDDN.FR.001.470013.000.S.C.2016.000.31500
 
