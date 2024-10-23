#!/bin/bash

# Habilitar los sitios
a2ensite javi.conf

# Recargar la configuración de Apache
service apache2 reload

# Iniciar Apache en primer plano
apache2ctl -D FOREGROUND
