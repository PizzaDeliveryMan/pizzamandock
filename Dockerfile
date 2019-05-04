FROM php:7-fpm
RUN apt-get update \
    && apt-get install apt-utils git nginx -y \
    &&  curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer global require hirak/prestissimo --no-plugins --no-scripts \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
	#sudo curl -o- -L https://yarnpkg.com/install.sh | bash   
    && apt-get install -y nodejs yarn \
    && apt-get install --reinstall zlibc zlib1g zlib1g-dev \
	&& apt-get install -y zip libzip-dev \
    && apt-get install -y libxml2-dev \
	&& docker-php-ext-configure zip --with-libzip \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install exif \
	&& docker-php-ext-install fileinfo \
	&& docker-php-ext-install json \
	&& docker-php-ext-install simplexml \
    && apt-get clean \
    && docker-php-ext-install mbstring zip pdo pdo_mysql\
    && npm install -g gulp \
	#yarn: 1.15.2
	#npm: 6.7.0
	#node: 11.10.0
	&& npm install yarn@0.25.4 -g \
    && rm *.* && git clone -q --recursive https://github.com/phanan/koel . \
    && adduser --gecos '' --disabled-password koel \
    #&& chown -R koel /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	#chown -R www-data:www-data /var/www \
	&& chmod 755 /var/www/html \
	&& chmod -R 777 ./storage ./bootstrap \
    && su koel -c 'git config --global url."https://".insteadOf git:// \
    && cd /var/www/html/ && composer install' \
    # && npm audit fix --force \
	&& cd /var/www/html/database/migrations/ \
	&& rm 2016_04_15_125237_add_contributing_artist_id_into_songs.php && rm 2017_04_21_092159_copy_artist_to_contributing_artist.php \
	&& rm 2017_04_29_025836_rename_contributing_artist_id.php \
	&& cd /var/www/html/ \
	#yarn: 1.15.2
	#npm: 6.7.0
	#node: 11.10.0
	# && yarn ./node_modules/.bin/gulp --production
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/koel/.npm /root/.npm
ADD https://gist.githubusercontent.com/NamPNQ/719f40c58995e76a4388/raw /etc/nginx/sites-available/default
RUN chown -R www-data:www-data /var/www/html
RUN npm install && npm audit fix --force
CMD service nginx start && php-fpm