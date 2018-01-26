FROM  debian:stretch
MAINTAINER  Julien Ancelin from Irstea/collec \
            Logiciel diffusé sous licence AGPL \
            https://github.com/Irstea/collec
#RUN gpg --keyserver keyserver.ubuntu.com --recv 010908312D230C5F
#RUN gpg --export --armor 010908312D230C5F | apt-key add -
RUN apt-get install -y software-properties-common dirmngr
RUN add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu yakkety main"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886
RUN apt-get -y update 
#RUN apt-get install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim acl
RUN apt-get install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl  oracle-java8-installer php-gd fop php-imagick unzip ssl-cert vim 

## Install of CUPS (listen on 631) for printers
RUN apt-get -t sid install cups

RUN apt-get clean && apt-get -y autoremove

# add pi as CUPS user (in group lpadmin)
sudo useradd pi -p raspberry -g lpadmin

RUN a2enmod ssl; a2enmod headers; a2enmod rewrite

# Generate certificate
RUN mkdir /etc/apache2/ssl
RUN /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem

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

# Param
ADD param.inc.php /var/www/html/$REP/param/param.inc.php

# Droits
WORKDIR /var/www/html/$REP
RUN mkdir -p display/templates_c 
RUN chown -R root:www-data . &&\
    chmod -R g+r,g-w . &&\
    chmod -R g+w /var/www/html/$REP/temp &&\
    chmod -R g+w /var/www/html/$REP/display/templates_c 

#Start apache2
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD /start.sh
# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/
RUN export JAVA_HOME
