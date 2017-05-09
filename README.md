# docker-collec
A Docker Container with IRSTEA/COLLEC

* Install Docker

```
  sudo apt-get update
  sudo apt-get install curl 
  curl -fsSL https://get.docker.com/ | sh
  sudo systemctl enable docker
  sudo service docker start
  sudo groupadd docker
  sudo usermod -aG docker $USER
```

* Run Collec

```
docker run --restart="always" --name "collec" -p 80:80 -p 443:443 -d -t jancelin/docker-collec
```
> if you already use 80 and 443 on your pc or server, do -p 81:80 -p 444:443 for exemple


* Edit /var/www/html/collec-master/param/param.inc.php with your database config

> use your IP not localhost, you are in a container...

```
docker exec -it collec bash
vim /var/www/html/collec-master/param/param.inc.php
:wq
exit
```

