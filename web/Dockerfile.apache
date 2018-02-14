FROM  debian:stretch
MAINTAINER  Julien Ancelin, Christine Plumejeaud from Irstea/collec \
            Logiciel diffusé sous licence AGPL \
            https://github.com/Irstea/collec


RUN apt-get -y update

RUN apt-get install -y software-properties-common dirmngr
RUN apt-get install debian-archive-keyring
RUN add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"

# Update apt source for postgres stuff
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get -y install wget ca-certificates
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get -y update

## Install of netstat, psql and nc for debug
RUN apt-get -y install net-tools postgresql-client-9.6 netcat

# acl
RUN apt-get install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim

## Install of CUPS (listen on 631) for printers
RUN apt-get -y install cups

RUN apt-get clean && apt-get -y autoremove

# add pi as CUPS user (in group lpadmin)
RUN useradd pi -p raspberry -g lpadmin

RUN a2enmod ssl; a2enmod headers; a2enmod rewrite

# Generate or copy  certificate (for CN : local-collec)
#RUN mkdir /etc/apache2/ssl
#RUN /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem
ADD collec_key.pem /etc/ssl/private/
ADD collec_crt.pem /etc/ssl/certs/
RUN chown root:ssl-cert /etc/ssl/private/collec_key.pem
RUN chown root:ssl-cert /etc/ssl/certs/collec_crt.pem

# Copy config site available
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Activ site
RUN a2ensite 000-default.conf; a2ensite default-ssl.conf

# Droits
#RUN command addgroup --system 'ssl-cert'
RUN chmod -R g+r /etc/ssl/private
RUN usermod www-data -a -G ssl-cert
RUN a2ensite default-ssl
RUN a2ensite 000-default

#Variable de dépot et de nom de dossier
ARG ZIP=master.zip
ARG REP=collec-master

# Install Collec
ADD https://github.com/Irstea/collec/archive/$ZIP /var/www/html

RUN unzip /var/www/html/$ZIP -d /var/www/html/ && \
    rm /var/www/html/$ZIP

# Param de collec
ADD param.inc.php /var/www/html/$REP/param/param.inc.php

# Droits apache dans collec
WORKDIR /var/www/html/$REP
RUN mkdir -p display/templates_c
RUN chown -R root:www-data . &&\
    chmod -R g+r,g-w . &&\
    chmod -R g+w /var/www/html/$REP/temp &&\
    chmod -R g+w /var/www/html/$REP/display/templates_c

# Setup JAVA_HOME, this is useful for docker commandline and FOP in collec
# Sur Windows ou Linux amd 64
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/
# Sur Raspberry, Rasbian, architecture ARM
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-armel/
RUN export JAVA_HOME

#Start apache2
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
# CMD is not run at build time. Only when the container is started (docker-compose up <SERVICE> or docker run <IMAGEID>)
CMD /start.sh

