FROM ubuntu:16.04

LABEL Author="Esron Silva esron.silva@sysvale.com"

ENV PATH ${PATH}:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y software-properties-common \
		unzip \
		apache2 \
		curl \
		language-pack-en-base

# Add PHP ondrej repository
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
	&& apt-get update && apt-get upgrade -y

# Install php and its libraries
RUN apt -y install php7.2 \
	php7.2-mbstring \
	php7.2-xml \
	php7.2-curl \
	php7.2-imagick \
	php7.2-zip \
  php7.2-mysql \
	libxrender1 \
	libfontconfig1 \
	libxtst6 \
	php-mongodb \
	php-mongo \
	&& update-alternatives --set php /usr/bin/php7.2

# Install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
	&& apt-get install -y nodejs \
	&& npm install -g npm@latest

# Apache config
RUN a2enmod rewrite
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');"

WORKDIR /app

COPY . /app

ENTRYPOINT ["/app/entrypoint.sh"]
