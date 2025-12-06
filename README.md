# cursos-docker
# Moodle 5.1 con PHP 8.4 y MariaDB

Instalación Dockerizada de Moodle 5.1 para plataforma de cursos.

## Configuración

### Variables de entorno requeridas:
```env
MOODLE_DB_HOST=cursos-db-zazuw8
MOODLE_DB_PORT=3306
MOODLE_DB_NAME=moodle_cursos
MOODLE_DB_USER=moodle_user
MOODLE_DB_PASSWORD=tu_password
MOODLE_WWWROOT=https://cursos.diginovapro.com
