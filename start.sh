#!/bin/bash

echo "========================================"
echo "🚀 INICIANDO MOODLE 5.1"
echo "========================================"

# Esperar a que la BD esté lista (solo para desarrollo)
sleep 10

# Clonar Moodle si no existe
if [ ! -f "/var/www/html/version.php" ]; then
    echo "📥 Clonando Moodle 5.1..."
    git clone -b MOODLE_501_STABLE --depth 1 https://github.com/moodle/moodle.git /tmp/moodle
    cp -rf /tmp/moodle/. /var/www/html/
    rm -rf /tmp/moodle
    echo "✅ Moodle clonado"
fi

# Configurar permisos
chown -R www-data:www-data /var/www/html /var/moodledata
chmod -R 755 /var/www/html
chmod -R 777 /var/moodledata

# Iniciar PHP-FPM
php-fpm -D

# Iniciar Nginx
nginx -g 'daemon off;'
