FROM php:5.6-apache
MAINTAINER Volker Wiegand <volker.wiegand@cvw.de>

# Inspired by the official ownCloud Dockerfile

RUN apt-get update && apt-get install -y \
	unzip \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng12-dev \
	libpq-dev \
	imagemagick \
	vim-tiny \
	&& rm -rf /var/lib/apt/lists/* /var/www/html/index.html

# http://www.s9y.org/36.html#A3
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd intl mbstring mcrypt mysqli opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PECL extensions
RUN pecl install APCu-beta redis memcached \
	&& docker-php-ext-enable apcu redis memcached

RUN a2enmod rewrite

ENV SERENDIPITY_VERSION 2.0.2

VOLUME /var/www/html

RUN echo "497661f4897fb23919b24a6e512c2d86  serendipity-${SERENDIPITY_VERSION}.zip" >/tmp/md5sums

RUN curl -fsSL -o serendipity-${SERENDIPITY_VERSION}.zip \
		"https://github.com/s9y/Serendipity/releases/download/${SERENDIPITY_VERSION}/serendipity-${SERENDIPITY_VERSION}.zip" \
	&& md5sum --quiet --check /tmp/md5sums \
	&& unzip -d /usr/src serendipity-${SERENDIPITY_VERSION}.zip \
	&& rm serendipity-${SERENDIPITY_VERSION}.zip /tmp/md5sums

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
