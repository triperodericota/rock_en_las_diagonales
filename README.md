# README

Esta aplicación web fue escrita utilizando el framework Ruby on Rails(v 6.0.3.4).
A partir d su uso, artistas y productores de rock podrán registrarse
y utilizar la aplicación para publicar sus eventos, ofrecer y vender productos
y  mostrarse ante la audencia. Se utiliza el SDK de MercadoPago para el proceso de 
compra-venta de productos.
Además, los usarios podrán seguir a sus artistas preferidos y agendar los eventos que más
les interesen.

**Dependencias del proyecto:**

· Intérprete de Ruby(2.7.1p)

· Ruby on Rails(6.0.3.4)

· SQLite3 (en desarrollo)

· PostgreSQL (en producción)


Otras dependencias:

· Bootstrap(4.1.3), como librería de estilos

· Simple-form(5.0.3), para la construcción sencilla de formularios

· Devise(4.7.3), como mecanismo de autenticación

· CarrierWave(2.1.0), para la subida de archivos

**Preparación del ambiente para la ejecución de la app:**

Es posible inicializar y ejecutar la app en un entorno local o utilizando un contenedor Docker.


1 - Clonar el repositorio

`$ git clone https://github.com/triperodericota/rock_en_las_diagonales.git`


**De manera local**


2 - Instalación de las dependencias con Bundler

`$ cd rock_en_las_diagonales/`

`$ bundle`

Se utiliza SQLite3 como motor de base de datos (en ambientes de desarrollo y test), en caso de no disponer de dicho DBMS en sistemas linux se debe ejecutar:

`$ sudo apt-get install sqlite3`

3 - Creación de la DB y carga de datos:

`$ bin/rake db:migrate`

`$ bin/rake db:seed`

o directamente:

`$ bin/rails db:setup`

4 - Instalar dependencias JS y compilar los assets:

`$ bin/rake yarn:install `

`$ bin/rake assets:precompile `

4 - Para levantar y correr el servidor:

`$ bin/rails s`


**Utilizando Docker**

Es necesario tener instalado [Docker](https://www.docker.com/get-started) en el host. Una vez descargado el repositorio y situado en el directorio de descarga:

2 - Construir el contenedor para la ejecución de la app:

`$ docker-compose up --build`

Se puede comprobar la correcta creación del contenedor ejecutando: `docker ps` . 

3 - Creación de la DB y carga de datos iniciales:

`$ docker-compose run web rails db:setup`

4 - Instalación de yarn en el contenedor:

`$ docker-compose run web yarn install`


Acceder a la aplicación desde el browser. Por default en: [localhost:3000/](localhost:3000/) en caso de que se haya realizado un setup local, ó [localhost:3100/](localhost:3100/) en caso que se haya opado por usar Docker.
Puedes usar algún usario generado en los seed para iniciar sesión, la contraseña default de cualquiera de estos es _12345678_.

Para simular la compra de un producto a través de mercado pago se pueden utilizar los números de tarjetas indicados en https://www.mercadopago.com.ar/developers/es/solutions/payments/basic-checkout/test/test-payments/

**Tests**

Para la ejecución de los test sobre los modelos ejecutar `$ rails test:models ` si se instanció la app localmente, ó `$ docker-compose run web rails test:models` si se usa Docker.
