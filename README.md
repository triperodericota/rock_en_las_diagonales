# README

Esta aplicación web fue escrita utilizando el framework Ruby on Rails(v 5.2.0).
Básicamente a partir del uso de ella, artistas y productores de rock podrán registrarse
y utilizar la aplicación para publicar sus eventos, ofrecer y vender productos
y  mostrarse ante la audencia.

**Dependencias del proyecto:**

· Intérprete de Ruby(2.3.1)

· Ruby on Rails(5.2.0)

· SQLite3 (en desarrollo)

· PostgreSQL (en producción)


Otras dependencias:

· Bootstrap(4.1.1), como librería de estilos

· Simple-form(4.0.1), para la construcción sencilla de formularios

· Devise(4.4.3), como mecanismo de autenticación

· CarrierWave(1.2.3), para la subida de archivos

**Preparación del ambiente para la ejecución de la app:**

1 - Clonar el repositorio

`git clone https://github.com/triperodericota/rock_en_las_diagonales.git`

2 - Instalación de las dependencias con Bundler

`cd rock_en_las_diagonales/`

`bundle`

Se utiliza SQLite3 como motor de base de datos (en ambientes de desarrollo y test), en caso de no disponer de dicho DBMS en sistemas linux se debe ejecutar:

`sudo apt-get install sqlite3`

3 - Creación de la DB y carga de datos:

`rails db:migrate`

`rails db:seeds`

o directamente:

`rails db:setup`

4 - Para levantar y correr el servidor:

`rails s`

Acceder a la aplicación desde el browser. Por default en: localhost:3000/. Puedes usar el email a_luisa_mar@yahoo.com para acceder como fan y van_halen@dicki.io para acceder como artista, ambos con password 12345678.

Para simular la compra de un producto a través de mercado pago se pueden utilizar los números de tarjetas indicados en https://www.mercadopago.com.ar/developers/es/solutions/payments/basic-checkout/test/test-payments/

**Tests**

Para la ejecución de todos los test usar el comando rails test. También es posible ejecutar cada uno de los tests en forma separada,
para esto indicar el path del test que se desea ejecutar (por ejemplo: rails test test/models/event_test.rb). En caso de querer ejecutar
 n método en particular usar el argumento -n junto con el nombre del método deseado.
