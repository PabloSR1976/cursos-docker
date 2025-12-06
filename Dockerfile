# Imagen base con PHP 8.4
FROM php:8.4-fpm

# Instalar todo lo necesario
RUN apt-get update && apt-get install -y \
    # Servidor web
    nginx \
    # Herramientas del sistema
    git \
    curl \
    wget \
    unzip \
    nano \
    cron \
    supervisor \
    # Dependencias de PHP
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    # Moodle específico
    ghostscript \
    graphviz \
    aspell \
    aspell-es \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP para Moodle
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    gd \
    mbstring \
    mysqli \
    pdo_mysql \
    zip \
    intl \
    xmlrpc \
    soap \
    opcache \
    sockets \
    exif

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorios necesarios
RUN mkdir -p /var/www/html \
    /var/moodledata \
    /var/log/supervisor \
    /var/log/nginx \
    /var/log/php

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html /var/moodledata \
    && chmod -R 755 /var/www/html

# Puerto
EXPOSE 80

# Comando de inicio optimizado para Dokploy
CMD ["sh", "-c", "mkdir -p /var/moodledata && chmod 777 /var/moodledata && echo 'Moodle 5.1 listo' && sleep infinity"]
