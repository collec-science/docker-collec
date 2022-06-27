**DOCKER-COLLEC-SCIENCE**

- [Presentation](#presentation)
- [Docker installation](#docker-installation)
  - [Debian, Ubuntu or Raspbian](#debian-ubuntu-or-raspbian)
  - [Windows](#windows)
- [Installation of containers](#installation-of-containers)
  - [launch the web application](#launch-the-web-application)
    - [Docker is installed in the computer that is used to access the application](#docker-is-installed-in-the-computer-that-is-used-to-access-the-application)
    - [Docker is installed in a Raspberry](#docker-is-installed-in-a-raspberry)
  - [Some useful docker commands](#some-useful-docker-commands)
  - [Database backup](#database-backup)
  - [Update the application](#update-the-application)
    - [Make a backup of the database](#make-a-backup-of-the-database)
    - [Update the database](#update-the-database)
    - [Update the application](#update-the-application-1)
- [Using a Raspberry Pi](#using-a-raspberry-pi)
  - [Installation of Raspbian](#installation-of-raspbian)
  - [ssh connection](#ssh-connection)
  - [Install Docker and the software](#install-docker-and-the-software)
  - [Change the rights for the database backup](#change-the-rights-for-the-database-backup)
  - [Create a wifi network to connect terminals directly](#create-a-wifi-network-to-connect-terminals-directly)
- [Acknowledgements](#acknowledgements)
- [License](#license)

# Presentation

The software[Collec-Science](https://github.com/collec-science/collec-science) is used to manage samples collected in the field. It is possible to create an instance of it to make direct entries.

To do this, the software must be able to be embedded on a field computer (Windows or Linux laptop or tablet, or Raspberry Pi). The technology chosen is the one based on Docker containers, to be able to install a Postgresql database and an Apache2 Web server to host the PHP code.

The scripts provided allow you to install two Docker containers, one to host the database and the other for the web server.

This solution can also be used to run collec-Science on any other OS (CentOS, Windows, etc.), while ensuring that it runs in the Debian environment.

# Docker installation
## Debian, Ubuntu or Raspbian

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
Follow the instructions described here: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).

Also install the Windows *PowerShell* program, which will allow you to open a terminal and launch manual commands.

# Installation of containers
The commands are given for Linux. Remember to adapt the approach to Windows (manual download from a browser, decompression with Windows, etc.).

Download the code of this deposit in a folder on your computer:
```
sudo apt-get install wget unzip
wget https://github.com/collec-science/docker-collec/archive/master.zip
unzip master.zip
cd docker-collec-master
```
Create a Docker volume to host the Postgresql database:
```
docker volume create --name collecpgdata -d local
```
Create the two images and the associated containers:
```
docker-compose up --build
```
If all goes well, you will find the following images:
```
docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
docker-collec-master_collec-web       latest              834d8fd9f504        18 hours ago        782MB
docker-collec-master_collec-db        latest              78d95ff5fea4        19 hours ago        888MB
```

And the containers:
```
docker container ls
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                      NAMES
125eafce92ac        docker-collec-master_collec-web   "/bin/sh -c /start.sh"   56 seconds ago      Up 54 seconds       0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   docker-collec-master_collec-web_1
4f6b43a1261a        docker-collec-master_collec-db    "su - postgres -c 'P…"   17 hours ago        Up 10 minutes       0.0.0.0:5433->5432/tcp                     docker-collec-master_collec-db_1
```

**Caution: **the web server exposes ports 80 and 443. If you already have a web server running on your computer, you will need to shut down your local web server before starting the containers.

If you have installed the Postgresql client on your computer, the postgresql server will be accessible from port 5433, at localhost :
```
psql -U collec -h localhost -p 5433
collec user password: collecPassword
```
## launch the web application
### Docker is installed in the computer that is used to access the application
This is the case with a Windows or Linux laptop. First, retrieve the IP address of the web server:
```
docker exec docker-collec-master_collec-web_1 ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
        inet 172.19.0.3 netmask 255.255.0.0.0 broadcast 172.19.255.255.255
```
Here, the container has been assigned the IP address *172.19.0.3*.

Add a line in your /etc/hosts (Linux) or c:\Windows\System32\drivers\etc\hosts (Windows) file:
```
172.19.0.3 docker-collec docker-collec.local
```
In your browser, go to the site: [https://docker-collec.local](https://docker-collec.local). Accept the security exception: you should access the application.

You can connect with the login *admin*, password *password*: this is a default installation. Then remember to delete the admin account or change the password when you are working in production (except for local access only).

### Docker is installed in a Raspberry

Refer to the corresponding documentation in the chapter[Using a Raspberry Pi](#Using-a-Raspberry-Pi).

## Some useful docker commands

The *docker-compose* commands must be executed from the docker-collec folder.

* docker images: displays the list of available images
* docker container ls: displays the list of containers
* docker stop docker-collec-master_collec-web_1 : stops the container containing the collec-web image
* docker start docker-collec-master_collec-web_1 &! starts the previously stopped container
* docker-compose up &!: starts the containers in the background
* docker-compose up -d: starts the collec-web and collec-db in their respective containers, recreating them
* docker exec -ti docker-collec-master_collec-web_1 /bin/bash: connects to the container and allows to execute commands
* docker rmi docker-collec-master_collec-web --force: suddenly deletes the collec-web image
* docker-compose up --build: recreates both images. Warning: the database will be recreated!
* docker update --restart=no docker-collec-master_collec-web_1 : disables the automatic start of the container
* docker inspect docker-collec-master_collec-web_1: displays the current container settings
* docker system prune -a : deletes all images, to reset docker

## Database backup
The *collec-db* image includes an automatic database backup, which is triggered every day at 13:00. You will find it in your computer, in the folder *Personal folder/collecpgbackup*. Remember to move it to another location on the network, to avoid losing everything in the event of a computer crash or theft.

## Update the application

The update of the application will be done in two steps:
* on the one hand, by updating the database, if necessary;
* on the other hand, by recreating the image *collec-web*.

For download the code, you must connected to Internet: use a Ethernet cable if your software is installed in a Raspberry-Pi.

### Make a backup of the database
```
docker exec -ti docker-collec-master_collec-db_1 bash
su - postgres -c /var/lib/postgresql/backup.sh
```
You should find your backup files in the ~/collecpgbackup folder on your computer (~ corresponds to your default folder).

### Update the database

Verify the name of yours containers:
~~~
docker container ls
~~~

Retrieve the version number of the current database version:
```
docker exec -ti docker-collec-master_collec-db_1 bash
su postgres -c 'psql collec -c "select dbversion_number from col.dbversion order by dbversion_date desc limit 1"'
```
Check the Github repository for a database modification script (in[https://github.com/Irstea/collec/tree/master/install/pgsql](https://github.com/Irstea/collec/tree/master/install/pgsql)). The script is in the form:
```
alter-1.1-1.2.sql
(or col_alter_2.3-2.4.sql for the last version)
```
where 1.1 is the current version of your database, and 1.2 is the version to be reached.

In your Docker container, download the script:
```
su - postgres
wget https://github.com/collec-science/collec-science/raw/master/install/pgsql/alter-1.1-1.2.sql
```
Warning: to upgrade to 2.4 version, you must execute before these commands:
~~~
psql collec
CREATE EXTENSION postgis WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA pg_catalog;
CREATE EXTENSION pgcrypto WITH SCHEMA public;
~~~
The default password is: collecPassword

Verify if you have these tables:
~~~
select count(*) from gacl.passwordloss;
select count(*) from col.sampling_place;
~~~
If one of these is missing, you must generate it with:
~~~
wget https://github.com/collec-science/collec-science/raw/master/install/pgsql/passwordloss_missing_v2.3.1.sql
wget https://github.com/collec-science/collec-science/raw/master/install/pgsql/sampling_place_missing_v2.3.1.sql
psql -U collec collec -h localhost -f passwordloss_missing_v2.3.1.sql
psql -U collec collec -h localhost -f sampling_place_missing_v2.3.1.sql
~~~

After these controls, you can execute tue update script:
```
psql -U collec collec -h localhost -f col_alter_2.3-2.4.sql
```
(for the last version).

If you are a few versions late, you will have to run the scripts successively to get to the current version level.

Quit the container with ctrl-D ctrl-D.

### Update the application

Save the configuration files:
```
mkdir param
docker cp docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/param.inc.php param/
docker cp docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/id_collec-science param/
docker cp docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/id_collec-science.pub param/
```

Stop the container, and recreate the image:
```
docker stop docker-collec-master_collec-web_1
docker-compose up --build collec-web &!
```
Docker will recreate the image by loading the new version of the application. Once the container is started, reintegrate the previously saved configuration files:
```
docker cp param/param.inc.php docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/
docker cp param/id_collec docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/
docker cp param/id_collec.pub docker-collec-master_collec-web_1:/var/www/collec-science/collec-science/param/
docker exec -ti docker-collec-master_collec-web_1 bash
cd /var/www/collec-science/collec-science/param
chgrp www-data id_collec-science*
chmod g+r id_collec-science*
```
Quit the container with Ctrl+D

*Warning:* if you recreate the container, you will have to restart the copy of the configuration files.

# Using a Raspberry Pi
## Installation of Raspbian

For the installation of Raspbian, refer to the[Raspberry installation documentation](https://www.raspberrypi.org/documentation/).

Remember to enable access via ssh, and disable the graphical user interface at startup, which consumes resources and is irrelevant in the context of collec-Science.

## ssh connection
To connect to your Raspberry, use the command :
```
ssh pi@ip_address
```
Once connected, type the command:
```
sudo -s
```
If you have to work with the *root* login.

## Install Docker and the software

Review the detailed instructions at the beginning of the document.

## Change the rights for the database backup

By being connected with the *pi* account:
```
cd /home/pi
sudo chown pi:pi collecpgbackup
chmod 777 collecpgbackup
```

## Create a wifi network to connect terminals directly

Follow the instructions defined in the first chapter of this document: [https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) (*Setting up a Raspberry Pi as an access point in a standalone network (NAT)*).

Adapt the content of the file */etc/hostapd/hostapd.conf*, and in particular :
* ssid=docker-collec
* wpa_passphrase=your_password

Then edit the file */etc/dnsmasq.conf*, and add these lines:
```
server=8.8.8.8
address=/docker-collec.local/192.168.4.1
```
The *server* line corresponds to Google's web address server (DNS). If you want to use another DNS, for example your organization's, change this line.

Restart the Raspberry, and connect to the wifi network *docker-collec*. Test the communication with the application, by entering the following address in a browser: https://docker-collec.local. You must access the home page. In case of access problems (address not recognized), you can also connect directly to the IP address: https://192.168.4.1.

<!--- This configuration allows you to load the Openstreetmap tiles before leaving for the field:
* at the office, connect the Raspberry to the local network with an Ethernet cable
* connect your tablet to the Raspberry via wifi
* Launch the application at https://192.168.4.1.
* Open the module *Parameters>Map Caching*, and download the tiles you will need in the field
* stop the Raspberry, disconnect the Ethernet cable, close the browser from your tablet
* Restart the Raspberry, reconnect the tablet to the wifi, and reopen the application: the tiles are accessible without you being connected to the Internet.
-->

# Acknowledgements

Thanks to #odjs to the remarks on the names of the containers

# License

The scripts are released under MIT license.
