#!/bin/bash

# Habilitar los sitios
a2ensite javiruiz.conf

# Habilitamos ssl
a2enmod ssl

# Recargar la configuración de Apache
service apache2 reload

# service apache2 restart

# Iniciar Apache en primer plano
apache2ctl -D FOREGROUND
