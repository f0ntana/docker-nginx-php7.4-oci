FROM php:7.4.13-fpm

ENV CAROOT=/app/.mkcert \
   SSL_DOMAIN="comercial.codeinapp.com.br"

RUN apt-get update && apt-get -y install wget bsdtar libaio1 && \
   wget -qO- https://raw.githubusercontent.com/caffeinalab/php-fpm-oci8/master/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip | bsdtar -xvf- -C /usr/local && \
   wget -qO- https://raw.githubusercontent.com/caffeinalab/php-fpm-oci8/master/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip | bsdtar -xvf-  -C /usr/local && \
   wget -qO- https://raw.githubusercontent.com/caffeinalab/php-fpm-oci8/master/oracle/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip | bsdtar -xvf- -C /usr/local && \
   ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
   ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
   ln -s /usr/local/instantclient/lib* /usr/lib && \
   ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
   docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
   docker-php-ext-install oci8

RUN apt-get update && apt-get install -y \
   build-essential \
   libpng-dev \
   libjpeg62-turbo-dev \
   libfreetype6-dev \
   locales \
   zip \
   jpegoptim optipng pngquant gifsicle \
   vim \
   unzip \
   git \
   curl \
   libzip-dev \
   libpq-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install -o -f redis \
   &&  rm -rf /tmp/pear

# Install extensions
RUN docker-php-ext-install pdo_mysql && \
   docker-php-ext-install mysqli && \
   docker-php-ext-install pdo_pgsql && \
   docker-php-ext-install zip && \
   docker-php-ext-install exif && \
   docker-php-ext-install pcntl && \
   docker-php-ext-install gd && \
   docker-php-ext-enable redis

RUN apt-get update && apt-get -qqy install \
   nginx \
   supervisor \
   git \
   zip

RUN rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
   chmod +x /usr/local/bin/composer;

RUN rm /etc/nginx/nginx.conf

COPY ./conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /app
WORKDIR /app

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
