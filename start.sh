#!/bin/bash

echo "🚀 Iniciando Moodle..."

# Clonar Moodle si no existe
if [ ! -f "/var/www/html/version.php" ]; then
    echo "📥 Clonando Moodle 5.1..."
    git clone -b MOODLE_501_STABLE --depth 1 https://github.com/moodle/moodle.git /tmp/moodle
    cp -rf /tmp/moodle/. /var/www/html/
    rm -rf /tmp/moodle
    echo "✅ Moodle clonado"
    
    # Permisos
    chown -R www-data:www-data /var/www/html /var/moodledata
    chmod -R 755 /var/www/html
    chmod -R 777 /var/moodledata
fi

# Configurar PHP para Moodle
echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/moodle.ini
echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/moodle.ini
echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/moodle.ini

# Iniciar PHP-FPM en segundo plano
php-fpm -D

# Iniciar Nginx en primer plano
echo "🌐 Iniciando Nginx..."
nginx -g 'daemon off;'
