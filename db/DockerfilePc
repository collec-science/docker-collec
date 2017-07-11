FROM kartoza/postgis:9.5-2.2

MAINTAINER  Julien Ancelin - Christine Plumejeaud \
            db test for IRSTEA/Collec 

ADD start-postgis.sh /start-postgis.sh
ADD collec.sql /collec.sql
RUN chmod 0755 /start-postgis.sh

CMD /start-postgis.sh
