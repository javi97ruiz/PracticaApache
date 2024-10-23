# Creacion de paginas web personalizadas con apache desplegado en docker

## Índice

- [Creacion de paginas web personalizadas con apache desplegado en docker](#creacion-de-paginas-web-personalizadas-con-apache-desplegado-en-docker)
  - [Índice](#índice)
  - [Introducción](#introducción)
  - [Requisitos](#requisitos)
  - [Javi\_website](#javi_website)
  - [Ruiz\_website](#ruiz_website)
  - [Javiruiz\_website](#javiruiz_website)

---

## Introducción

Este pequeño manual nos ayudara a la hora de crear nuestras paginas web personalizadas en local, basandonos en apache desplegado en contenedores docker.

## Requisitos

Antes de comenzar, asegúrate de tener lo siguiente:

- Docker instalado.
- Un editor de texto, en este caso he usado VS Code.
- Open SSL para windows.

## Javi_website

Vamos a comenzar con la creacion de la primera pagina que sera la que nos sirva de base para crear las dos siguientes:

1. Lo primero que tendremos que hacer sera crearnos nuestro arbol de directorios correctamente estructurado.
   La estructura debe quedar de la siguiente manera (por el momento):
    /PracticaApache2/(Aqui le podemos poner el nombre que queramos al directorio raiz)
        |-- javi_website
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- docker-compose.yml

Una vez tengamos los directorios scripts, sites-available y websites creados vacios a la vez que tengamos el archivo docker-compose creado y vacio tambien tendremos que rellenarlos.

Dentro de la carpeta script crearemos un archivo que en mi caso he llamado 'apachejavi-init.sh' y añadiremos el siguiente contenido.

`![Script para javi_web](./Imgs/ScriptJaviWeb.png)`

```bash
#!/bin/bash

# Habilitar los sitios

a2ensite javi.conf

# Recargar la configuración de Apache
service apache2 reload

# Iniciar Apache en primer plano
apache2ctl -D FOREGROUND

```

Una vez tengamos el script realizado pasaremos a nuestro archivo .conf, en este caso lo he llamado javi.conf acorde al nombre del dominio, debe quedar de la siguiente manera:

`![conf para javi_web](./Imgs/JaviConf.png)`

<VirtualHost *:80>
    DocumentRoot /var/www/html
    serverName javi.es
    ErrorDocument 404 /error404.html
</virtualHost>

Una vez hemos escrito la conf unicamente nos quedara crearnos un html en nuestra carpeta webites que sera nuestra pagina principal.

Ya con todo preparado para la creacion de la pagina web en apache unicamente nos quedara configurar el docker-compose.yml

Empezaremos creando un contenedor para esta pagina especifica pero lo iremos modificando segun vayamos creando el resto de paginas.

`![docker-compose javi_web](./Imgs/DockerComposeJaviWeb.png)`

El docker-compose debe tener el siguiente formato:

```yaml
javi_web:
    image: ubuntu/apache2 # imagen de Apache
    container_name: apacheJavi_server # nombre del contenedor
    ports:
      - "80:80" # mapeo de puertos
    volumes:
      - ./javi_website/websites:/var/www/html/ # directorio de los sitios web
      - ./javi_website/sites-available:/etc/apache2/sites-available      
      - ./javi_website/scripts:/scripts
    restart: always # reinicio automático
    entrypoint: /scripts/apachejavi-init.sh # comando para activar los hosts virtuales y arrancar Apache
```

La linea superior llamada `services` unicamente la incluiremos al principio del docker-compose.

Ahora que tenemos todo montado nos tendremos que dirigir a: C:\Windows\System32\drivers\etc y ahi seleccionaremos el archivo llamado hosts (es recomendable duplicarnos el archivo por si tuvieramos cualquier error poder volver a la configuracion por defecto), en este archivo deberemos añadir la siguiente linea: 127.0.0.1 javi.es (aqui sustituiremos javi.es por el dominio que vayamos a usar) y guardaremos los cambios.

Con todo esto realizado inicializaremos el docker para poder arrancarlo, una vez arrancado el docker en la terminal nos posicionaremos en la carpeta raiz donde tengamos el proyecto y ejecutaremos el comando `docker-compose up-d` para levantar el contenedor, una vez levantado el contenedor unicamente deberemos ir al dominio que hemos establecido, en este caso solo deberemos escribir en el buscador javi.es para que nos lleve a nuestra pagina web personalizada.

## Ruiz_website

Para crear este nuevo dominio nos basaremos en el dominio creado anteriormente.

Lo primero sera darle forma a los directorios, basandonos en el dominio anterior ahora deberemos duplicar la info, es decir conseguir esta estructura:
/PracticaApache2/(Aqui le podemos poner el nombre que queramos al directorio raiz)
        |-- javi_website
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- ruiz_website
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- docker-compose.yml

En los archivos .conf, y script unicamente modificaremos todos los nombres del dominio anterior al nuevo dominio para que quede de la siguiente manera:

`![Script para ruiz_web](./Imgs/ScriptRuizWeb.png)`

```bash
#!/bin/bash

# Habilitar los sitios

a2ensite ruiz.conf

# Recargar la configuración de Apache
service apache2 reload

# Iniciar Apache en primer plano
apache2ctl -D FOREGROUND

```

`![conf para ruiz_web](./Imgs/RuizConf.png)`
<VirtualHost *:80>
    DocumentRoot /var/www/html
    serverName `www.ruiz.es`
    ErrorDocument 404 /error404.html
</virtualHost>

Deberemos modificar el docker-compose para añadir este nuevo dominio, volveremos a realizar un duplicado de javi_website cambiando la especificacion del dominio anterior para este nuevo dominio, debe quedar de la siguiente manera:

`![docker-compose ruiz_web](./Imgs/DockerComposeRuizWeb.png)`

```yaml
ruiz_web:
    image: ubuntu/apache2 # imagen de Apache
    container_name: apacheRuiz_server # nombre del contenedor
    ports:
      - "8080:80" # mapeo de puertos
    volumes:
      - ./ruiz_website/websites:/var/www/html/ # directorio de los sitios web
      - ./ruiz_website/sites-available:/etc/apache2/sites-available      
      - ./ruiz_website/scripts:/scripts
    restart: always # reinicio automático
    entrypoint: /scripts/apacheruiz-init.sh # comando para activar los hosts virtuales y arrancar Apache 
```

Una vez tengamos los archivos modificados y tengamos nuestro html en websites, nos iremos a host de nuevo y añadiremos igual: 127.0.0.1 `www.ruiz.es` para poder acceder al sitio web.

Si no hemos hecho `docker-compose down` deberemos realizarlos antes de volver a hacer `docker-compose up -d` para asi poder buscar en el explorador nuestro nuevo dominio que en este caso deberemos introducir `www.javi.es:8080` ya que este nuevo dominio esta mapeado al puerto 8080 y no al 80 como el dominio anterior el cual es el puerto por defecto y por eso no hemos necesitado anteriormente indicar el puerto en la URL.

## Javiruiz_website

Una vez que nos hemos asegurado de que nuestros dominios anteriores funcionan correctamente nos vamos a tirar a la piscina con el dominio mas complicado que realizaremos en esta guia, un dominio con proteccion SSL y login necesario para su acceso.

Nos volveremos a basar en los dominios anteriores para este nuevo dominio, volveremos a realizar los pasos de ruiz_website y comenzaremos con las modificaciones.

La nueva estructura debe quedar de la siguiente manera:
/PracticaApache2/(Aqui le podemos poner el nombre que queramos al directorio raiz)
        |-- javi_website
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- ruiz_website
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- javiruiz_website
        |   -- certs
        |   -- htpasswd
        |   -- scripts
        |   -- sites-available
        |   -- websites
        |-- docker-compose.yml
Una vez tenemos esta estructura empezamos las modificaciones y los nuevos añadidos.

Deberemos modificar el archivo .conf de la siguiente manera:
`![conf para javiruiz_web](./Imgs/JaviRuizConf.png)`

<VirtualHost *:80>
    serverName `www.javiruizseguro.net`
    Redirect / `https://www.javiruizseguro.net/`
</virtualHost>

<VirtualHost *:443>
    DocumentRoot /var/www/html
    ServerName `www.javiruizseguro.net`
    #Mapeo de errores personalizados
    ErrorDocument 404 /error404.html
    ErrorDocument 401 /error401.html
    ErrorDocument 403 /error403.html
    ErrorDocument 500 /error500.html
    # Configuración SSL
    SSLEngine On
    SSLCertificateFile /etc/apache2/certs/javiruizseguro.crt
    SSLCertificateKeyFile /etc/apache2/certs/javiruizseguro.key
    # Habilitar protocolos seguros
    SSLProtocol All -SSLv3
    # Protección de directorio
    <Directory "/var/www/html">
        AuthType Basic
        AuthName "Acceso Restringido a Usuarios"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
        Options -Indexes
    </Directory>
</VirtualHost>

En este .conf lo que hemos añadido es el redirect en el puerto 80 para que la pagina nos redireccione automaticamente cuando accedamos a ella y añadir todo lo nuevo para el puerto 443 que sera el que nos lleve a la proteccion de certificados.

Una vez tengamos el .conf pasamos al script:
`![Script para javiruiz_web](./Imgs/ScriptJaviRuizWeb.png)`

```bash
#!/bin/bash

# Habilitar los sitios
a2ensite javiruiz.conf

# Habilitamos ssl
a2enmod ssl

# Recargar la configuración de Apache
service apache2 reload

# Iniciar Apache en primer plano
apache2ctl -D FOREGROUND

```

Aqui añadiremos la linea de a2enmod para habilitar la proteccion de ssl.

Los directorios certs y htpasswd los crearemos a mano, el directorio certs lo dejaremos vacio ya que le daremos uso en un paso posterior pero en el htpasswd crearemos un archivo con nombre .htpasswd para que sea un archivo oculto, en este archivo incluiremos la siguiente linea "usuario:bcrypt" donde, usuario sera el nombre de usuario con el que nos queramos loguear y bcrypt sera un string generado, por ejemplo, con bcrypt generator que nos lo generara online y sin coste.

Debe quedarnos una linea con el siguiente formato:
`![htpasswd](./Imgs/htpasswd.png)`

Una vez tenemos los archivos modificados y los directorios creados pasaremos al docker-compose, el cual añadiremos las siguientes lineas:
`![docker-compose javiruiz_web](./Imgs/DockerComposeJaviRuizWeb.png)`

```yaml
javiruiz_web:
    image: ubuntu/apache2 # imagen de Apache
    container_name: apacheJaviRuiz_server # nombre del contenedor
    ports:
      - "6969:80" # mapeo de puertos
      - "443:443"
    volumes:
      - ./javiruiz_website/websites:/var/www/html/ # directorio de los sitios web
      - ./javiruiz_website/sites-available:/etc/apache2/sites-available      
      - ./javiruiz_website/scripts:/scripts
      - ./javiruiz_website/htpasswd/.htpasswd:/etc/apache2/.htpasswd # archivo de contraseñas
      - ./javiruiz_website/certs:/etc/apache2/certs # directorio de certificados (hechos con openssl)
    restart: always # reinicio automático
    entrypoint: /scripts/apachejaviruiz-init.sh # comando para activar los hosts virtuales y arrancar Apache 
```

Las nuevas lineas que hemos añadido sera para copiar los nuevos directorios al docker.

Ahora con todo preparado solo nos quedara abrir la consola de OpenSSL que hemos instalado anteriormente, dirigirnos al directorio certs de nuestro proyecto y una vez que nos hayamos posicionado en el directorio incluiremos el siguiente comando:
`![comando openssl](./Imgs/OpenSSLCommand.png)`
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout (introduce el nombre del dominio sin extension).key -out (introduce el nombre del dominio sin extension).crt

Este comando nos creara el archivo .key y el archivo .crt despues de hacernos unas preguntas para la informacion del certificado, el campo mas importante es el ultimo que nos preguntaran que es el email al que habria que dirigirse en caso de tener un problema con el ssl, que seria el email del admin del dominio en nuestro caso podremos poner cualquier string ya que es un dummy.

Una vez nos aseguremos de que tenemos los archivos .key y .crt con el mismo nombre que hemos puesto en el archivo .conf lo unico que nos quedara sera, tirar el docker abajo si no lo hemos hecho anteriormente y, levantar el docker otra vez.
Una vez que lo hayamos levantado y nos aseguremos de que no nos da ningun error abriremos una pestaña en incognito para no guardar el cache y accederemos a nuestro dominio (recuerda incluir el puerto, en este caso el 6969), una vez que hayamos accedido nos pedira que introduzcamos el usuario y contraseña que hemos pasado a traves del archivo .htpasswd y con eso tendriamos acceso a nuestro propio dominio web.
