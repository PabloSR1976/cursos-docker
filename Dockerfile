# Imagen base con PHP 8.4 y Nginx
FROM php:8.4-fpm

# Instalar Nginx y dependencias
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    curl \
    wget \
    unzip \
    nano \
    cron \
    supervisor \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    ghostscript \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Extensiones PHP
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

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorios
RUN mkdir -p /var/www/html /var/moodledata /var/log/nginx
RUN chown -R www-data:www-data /var/www/html /var/moodledata

# Configurar Nginx
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /var/www/html; \
    index index.php index.html; \
    \
    location / { \
        try_files \$uri \$uri/ /index.php?\$query_string; \
    } \
    \
    location ~ \.php\$ { \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_index index.php; \
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; \
        include fastcgi_params; \
    } \
}' > /etc/nginx/sites-available/default

RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/ \
    && rm -f /etc/nginx/sites-enabled/default

# Script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

# Usar Supervisor para manejar ambos procesos
CMD ["/start.sh"]
