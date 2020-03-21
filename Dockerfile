FROM php:7-apache
MAINTAINER sebin.sbtn@gmail.com

RUN apt-get update

ADD index.php /var/www/html/

WORKDIR /var/www/html/

ENTRYPOINT ["/bin/bash"]

EXPOSE 80