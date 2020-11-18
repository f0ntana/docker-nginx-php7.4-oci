## PHP FPM Oracle

### Image Contents:

1. PHP-FPM
1. nginx
1. php-oci8 plugin
1. git
1. composer
1. phpunit
1. supervisord

### Usage instructions:

This image was pre-set to be used on laravel/lumen
Nginx root is set to /app/public

#### Running

docker run example:

```bash
docker run -p 80:80 --name php-oci8 \
           -v /path/to/your/repo:/app \
           -w /app \
           -d tecnobit/docker-nginx-php7.4-oci
```

docker-compose example:

```yml
version: '3.5'

services:
  php:
    image: tecnobit/docker-nginx-php7.4-oci:latest
    container_name: php
    ports:
      - '80:80'
    volumes:
      - /path/to/your/repo/:/app
```

then:

```bash
docker-compose up -d
```
