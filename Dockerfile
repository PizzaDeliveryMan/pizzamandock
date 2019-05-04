FROM php:7.1-fpm-alpine
MAINTAINER Etopian Inc. <contact@etopian.com>


#FROM php:7-fpm-alpine
#RUN docker-php-ext-install mysqli


LABEL   devoply.type="site" \
        devoply.cms="koel" \
        devoply.framework="laravel" \
        devoply.language="php" \
        devoply.require="mariadb etopian/nginx-proxy" \
        devoply.description="Koel music player." \
        devoply.name="Koel" \
        devoply.params="docker run -d --name {container_name} -e VIRTUAL_HOST={virtual_hosts} -v /data/sites/{domain_name}:/DATA etopian/docker-koel"


RUN apk update \
    && apk add bash less vim git nginx ca-certificates nodejs make gcc g++ \
    libxml2-dev libmcrypt-dev \
    && docker-php-ext-install exif iconv json pdo pdo_mysql mbstring zip tokenizer xml mcrypt \
    && apk add -u musl mysql-client


RUN rm -rf /var/cache/apk/*

ENV TERM="xterm" \
    DB_HOST="172.17.0.1" \
    DB_DATABASE="" \
    DB_USERNAME=""\
    DB_PASSWORD=""\
    ADMIN_EMAIL=""\
    ADMIN_NAME=""\
    ADMIN_PASSWORD=""\
    APP_DEBUG=false\
    AP_ENV=production


VOLUME ["/DATA/music"]

ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php/
ADD files/run.sh /
RUN chmod +x /run.sh && chown -R nginx:nginx /DATA

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 


RUN su nginx -c "git clone -q https://github.com/phanan/koel /DATA/htdocs &&\
    cd /DATA/htdocs &&\
    adduser --gecos '' --disabled-password koel \
    && chown -R koel /DATA/htdocs \
    && su koel -c 'git config --global url."https://".insteadOf git://' &&\
    npm install &&\
	composer global require hirak/prestissimo --no-plugins --no-scripts &&\
    composer install"

#clean up
RUN apk del --purge git build-base python nodejs && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/koel/.npm /root/.npm

ADD https://gist.githubusercontent.com/NamPNQ/719f40c58995e76a4388/raw /etc/nginx/sites-available/default
ADD https://gist.githubusercontent.com/NamPNQ/719f40c58995e76a4388/raw /etc/nginx/sites-available/koel

COPY files/.env /DATA/htdocs/.env

RUN chown nginx:nginx /DATA/htdocs/.env

#RUN su nginx -c "cd /DATA/htdocs && php artisan init"
RUN chown -R www-data:www-data /DATA/htdocs/
EXPOSE 80
#CMD ["/run.sh"]