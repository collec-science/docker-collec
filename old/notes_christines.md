# Installer un package sur un PI3 (os rasbian) - Petit addenum des emmerdes possibles

Illustration avec l'installation de PostgresSQL >= 9.5 et postgis pour collec (https://github.com/collec-science/collec-science).

## Vous cherchez un paquet qui n'existe pas dans votre distribution

D'abord, comprendre debian et l'organisation des distributions :
https://wiki.debian.org/fr/DebianReleases
    - main
    - testing
    - sid
Les distributions dans l'ordre de publications (juillet 2017):
    - wheezy (7)
    - jessie (8)
    - stretch (9)

Connaitre votre distribution : debian jessie sur rasbian par exemple
`uname -a`
```
Linux raspberrypi 4.9.35-v7+ #1014 SMP Fri Jun 30 14:47:43 BST 2017 armv7l GNU/Linux
```


`lsb_release -a`
```
No LSB modules are available.
    Distributor ID: Raspbian
    Description:    Raspbian GNU/Linux 8.0 (jessie)
    Release:        8.0
    Codename:       jessie
```

Rappel : en raspberry, vous êtes sur une architecture **armhf**


### Backports repository
J'en parle car c'est dans backports qu'on trouve postgres 9.6 pour jessie par exemple

https://wiki.debian.org/fr/Backports

`sudo vi /etc/apt/sources.list`
```
deb http://httpredir.debian.org/debian jessie-backports main contrib non-free
```

`sudo apt-get update`

### Trouver un package : exemple avec postgresql-9.6

https://packages.debian.org/search?suite=jessie-backports&arch=armhf&searchon=names&keywords=postgresql

* Package postgresql-9.6
    jessie-backports (database): object-relational SQL database, version 9.6 server
    9.6.3-1~bpo8+1: armhf

http://ftp.debian.org/debian jessie-backports main

Suivre la procédure décrite sur https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=146108
* 1) Create a file named /etc/apt/sources.list.d/backports.list.
* 2) Add the line 'deb ftp://ftp.nl.debian.org/debian jessie-backports main contrib non-free'.
* 3) apt-get update
* 4) apt-get install  postgres

MAIS voilà l'erreur agaçante : 2 clés sont introuvables et empêchent la mise à jour des paquets installables sur votre OS.
```
W: GPG error: ftp://ftp.nl.debian.org jessie-backports InRelease: The following signatures couldn't be verified because the public key is not available:
NO_PUBKEY 8B48AD6246925553 NO_PUBKEY 7638D0442B90D010
```

Alors vous testez les 2 solutions qui peuvent marcher si c'est du au fait que le serveur est mal résolu au niveau du DNS (l'adresse Internet)
```
gpg --keyserver $(getent hosts keys.gnupg.net | awk '{ print $1 }' | head -1) --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
```

```
gpg --keyserver $(ping keys.gnupg.net) --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
```

Bon, ca ne marche pas. Il va falloir comprendre mieux ce qui se passe.

Votre objectif est que cela fonctionne : `sudo aptitude -t jessie-backports install postgresql-9.6`

## Vous n'arrivez pas à installer des packages avec apt-get

Souvent cela vient des clés d'authentification de paquets qui ne sont pas récupérées des serveurs de clés (mauvaise adresse de serveur, serveur en panne, ou clé inexistante) et vous vous croyez que vous avez un problème de réseau (mais non pas du tout, pas la peine de configurer tout de suite votre proxy d'université ni rien).

### Problème de KEY non récupérée sur le serveur de clé

#### Explications

https://wiki.debian-fr.xyz/Erreur_lors_d%27un_update:_NO_PUBKEYs

https://www.skyminds.net/linux-resoudre-lerreur-apt-there-is-no-public-key-available-for-the-following-key-ids/

https://raspberrypi.stackexchange.com/questions/12258/where-is-the-archive-key-for-backports-debian-org

Je cite l'explication et le mode d'emploi associé le plus simple :
```
    All I had to do is replace the key ID to match the one i was missing, in my case 7638D0442B90D010

    gpg --keyserver pgpkeys.mit.edu --recv-key [Insert here your missing key ID]

    then

    gpg -a --export [Insert here your missing key ID] | sudo apt-key add -

    Now as usual you can properly fetch your raspbian softwares updates with:

    sudo apt-get update

    -- alternative

    sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com 8B48AD6246925553
```

Ca ne marche pas : la cle n'y est pas
http://keyserver.ubuntu.com/pks/lookup?op=index&search=postgres&fingerprint=on


#### 4 solutions (qui n'ont pas marché du fait que la clé était inexistante)

Sources :
https://elkano.org/blog/debian-8-jessie-signatures-verified-public-key/
https://unix.stackexchange.com/questions/274053/whats-the-best-way-to-install-apt-packages-from-debian-stretch-on-raspbian-jess

1. Solution 1
`sudo aptitude install debian-keyring debian-archive-keyring`
`sudo apt-cache search debian keyring`
`sudo aptitude update`
    W: GPG error: http://ftp.debian.org jessie-backports InRelease: The following signatures couldn't be verified because the public key is not available:
    NO_PUBKEY 8B48AD6246925553 NO_PUBKEY 7638D0442B90D010
    W: GPG error: http://httpredir.debian.org jessie-backports InRelease: The following signatures couldn't be verified because the public key is not available:
    NO_PUBKEY 8B48AD6246925553 NO_PUBKEY 7638D0442B90D010
    W: Failed to fetch http://apt.postgresql.org/pub/repos/apt/dists/jessie-pgdg/InRelease: Unable to find expected entry 'main/binary-armhf/Packages' in Release file (Wrong sources.list entry or malformed file)




2. Solution 2
`sudo gpg –keyserver hkp://keyserver.ubuntu.com:80 –recv-keys 8B48AD6246925553`
    gpg: directory `/root/.gnupg' created
    gpg: new configuration file `/root/.gnupg/gpg.conf' created
    gpg: WARNING: options in `/root/.gnupg/gpg.conf' are not yet active during this run
    gpg: keyring `/root/.gnupg/secring.gpg' created
    gpg: keyring `/root/.gnupg/pubring.gpg' created
    usage: gpg [options] [filename]
`sudo gpg –keyserver hkp://keyserver.ubuntu.com:80 –recv-keys 7638D0442B90D010`

3. Solution 3
`wget -O - https://ftp-master.debian.org/keys/archive-key-8.asc | sudo apt-key add -`
`wget -O - https://ftp-master.debian.org/keys/archive-key-8-security.asc | sudo apt-key add -`
`sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553`
`sudo aptitude update`

4. Solution 4
`gpg --keyserver pgpkeys.mit.edu --recv-key  8B48AD6246925553`
`gpg -a --export 8B48AD6246925553 | sudo apt-key add -`

`sudo apt-get update`
-- Echec toujours sur cette clé 8B48AD6246925553


#### Régler le problème de cette clé de merde 8B48AD6246925553

L'explication était sur un forum, parmi tant d'autres : https://forum.proxmox.com/threads/gpg-error-on-apt-get-update-packages-from-jessie-main-missing.24041/
```
Changing the source from ftp.us.debian.org to ftp.debian.org fixed it, so there is clearly something messed up with one of the US mirrors.
Then I changed the jessie from ftp.us.debian.org to ftp.uk.debian.org
```

Ah OK, la clé n'existe pas. Il faut changer l'adresse du dépôt debian qui est corrompu en fait.
LE bon dépôt : **deb http://ftp.debian.org/debian jessie-backports main contrib**


`sudo vi /etc/apt/sources.list`
```
deb http://ftp.debian.org/debian jessie-backports main contrib
```
`sudo aptitude update`


`sudo apt-get install postgresql-9.6`
```
Reading package lists... Done
Building dependency tree
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 postgresql-9.6 : Depends: postgresql-client-9.6 but it is not going to be installed
                  Depends: postgresql-common (>= 171~) but 165+deb8u2 is to be installed
                  Recommends: postgresql-contrib-9.6 but it is not going to be installed
                  Recommends: sysstat but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```

Pas de souci, on installe d'abord les dépendances bien sûr :

```
sudo apt install postgresql-common/jessie-backports
sudo apt install postgresql-client-9.6/jessie-backports
sudo apt install postgresql-9.6/jessie-backports
sudo apt install postgis-2.4/jessie-backports
```

Après tout çà, j'ai aussi modifié Postgres pour supprimer la version 9.4 existant par défaut, et j'ai changé le mot de passe de postgres. Voir les explications sur COLLEC (https://github.com/collec-science/collec-science/blob/develop/install/Installation%20de%20COLLEC.md). Donc j'ai bien un serveur 9.6 qui écoute sur 5432.

Puis j'ai voulu tester "create extension postgis" sur une base de test.
Et là évidemment, pas d'extension. Donc...

## Trouver et installer un package : exemple avec Postgis

### Version postgis

https://packages.debian.org/fr/jessie/postgis
--> https://packages.debian.org/fr/jessie/armhf/postgis/download

Rajout dans /etc/apt/sources.list
`sudo vi /etc/apt/source.list`
```
deb http://ftp.de.debian.org/debian jessie main
```
`sudo apt-get update`
`sudo apt-get install postgresql-9.6-postgis-2.3 `
-- non

Note : en cas de clé de merde qui fait chier, récupérer l'extension à la main.
    wget http://ftp.de.debian.org/debian/pool/main/p/postgis/postgis_2.1.4+dfsg-3_armhf.deb

### Version postgresql-9.6-postgis-2.3

https://packages.debian.org/search?keywords=postgresql-9.6-postgis-2.3
--> https://packages.debian.org/stretch/postgresql-9.6-postgis-2.3
Architecture armhf :
https://packages.debian.org/stretch/armhf/postgresql-9.6-postgis-2.3/filelist

Rajout dans /etc/apt/sources.list
`sudo vi /etc/apt/source.list`
```
deb http://ftp.de.debian.org/debian stretch main
```
`sudo apt-get update`

Note : en cas de clé de merde qui fait chier, récupérer l'extension à la main
    wget http://ftp.de.debian.org/debian/pool/main/p/postgis/postgresql-9.6-postgis-2.3_2.3.1+dfsg-2_armhf.deb

`sudo apt-get install postgresql-9.6-postgis-2.3 `
-- des dépendances : merde !!
```
postgresql-9.6-postgis-2.3 : Depends: libgdal20 (>= 2.0.1) but it is not going to be installed
                              Depends: libgeos-c1v5 (>= 3.5.0) but it is not going to be installed
                              Depends: liblwgeom-2.3-0 (>= 2.3.0) but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```

`sudo apt-get install postgis`
(dans l'espoir que ca rajoute les dépendances)
```
OK (dire YES)
Setting up apt-utils (1.4.7) ...
Setting up postgis (2.3.1+dfsg-2) ...
Setting up postgis-doc (2.3.1+dfsg-2) ...
Setting up postgresql-9.6-postgis-2.3 (2.3.1+dfsg-2) ...
Setting up postgresql-9.6-postgis-2.3-scripts (2.3.1+dfsg-2) ...
Processing triggers for libc-bin (2.24-11+deb9u1) ...
```

Tout s'est bien passé.

Et après, ok, `create extension postgis` a marché ! Ouf !

## Episode à suivre : pourquoi Docker ne veut-il pas installer le package PHP 7 ? Résolu...

La dernière version de debian: STRECTCH, dispose de php7. Pour l'utiliser avec docker sur un raspberry il faut completer le dockerfile comme ceci:

```
FROM resin/rpi-raspbian:stretch
RUN apt-get -y update
RUN apt-get install -y apache2 php7.4 php-mbstring php7.4-pgsql php7.4-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim
RUN apt-get clean && apt-get -y autoremove
```
