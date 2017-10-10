FROM debian:jessie
MAINTAINER  Julien Ancelin from Irstea/collec \
            Logiciel diffusé sous licence AGPL \
            https://github.com/Irstea/collec
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 010908312D230C5F
RUN gpg --export 010908312D230C5F | apt-key add -
RUN apt-get -y update
RUN apt-get -t sid install -y apache2 php7.0 php-mbstring php7.0-pgsql php7.0-xml php-xdebug php-curl default-jre php-gd fop php-imagick unzip ssl-cert vim
RUN apt-get clean && apt-get -y autoremove
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
RUN chmod -R g+r /etc/ssl/private
RUN command addgroup --system 'ssl-cert'
RUN usermod -a -G ssl-cert www-data

#Variable de dépot et de nom de dossier

ENV ZIP master.zip 
ENV REP collec-master

# Install Collec
ADD https://github.com/Irstea/collec/archive/$ZIP /var/www/html

RUN unzip /var/www/html/$ZIP -d /var/www/html/ && \
    rm /var/www/html/$ZIP
    
#modif chemin relatif


# tempates-c
RUN mkdir /var/www/html/$REP/display/templates_c
RUN chmod 777 /var/www/html/$REP/display/templates_c && chmod 777 /var/www/html/$REP/temp

# Param
#ADD param.inc.php /var/www/html/$REP/param/param.inc.php
ADD param.ini /var/www/html/$REP/param.ini

# Droits
RUN chown -hR www-data:users /var/www/html/$REP && \
    chmod -R 755 /var/www/html/$REP && \
    chmod -R 777 /var/www/html/$REP/temp && \
    chmod -R 777 /var/www/html/$REP/display/templates_c

#Start apache2
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD /start.sh
# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/
RUN export JAVA_HOME
