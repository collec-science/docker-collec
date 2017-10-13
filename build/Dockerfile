FROM debian:jessie
MAINTAINER  Julien Ancelin from Irstea/collec \
            Logiciel diffusé sous licence AGPL \
            https://github.com/Irstea/collec
RUN    gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
RUN    gpg -a --export 8B48AD6246925553 | sudo apt-key add -
RUN    gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
RUN    gpg -a --export 7638D0442B90D010| sudo apt-key add -
RUN apt-get -y update 
#RUN apt-get install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim acl
RUN apt-get -t sid install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim 
RUN apt-get clean && apt-get -y autoremove
RUN a2enmod ssl; a2enmod headers; a2enmod rewrite

# Generate certificate
RUN mkdir /etc/apache2/ssl
RUN /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem

# Copy config site available
ADD 000-default.conf /etc/apache2/sites-available/collec.conf
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Activ site
RUN a2ensite 000-default.conf; a2ensite default-ssl.conf

# Droits
#RUN command addgroup --system 'ssl-cert'
RUN chmod -R g+r /etc/ssl/private
RUN usermod www-data -a -G ssl-cert
RUN a2ensite default-ssl
RUN a2ensite collec
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
