# FlowSync — Especificación viva

## Purpose

Permitir que una persona cree una cuenta en FlowSync, inicie y cierre sesión, y consulte el resumen de su cuenta. El acceso a la información de la cuenta queda restringido a usuarios autenticados mediante un token.

## Requirements

### Requirement: Pantalla de inicio de sesión

La aplicación SHALL mostrar en `/login` un formulario "Inicia sesión" con los campos email y contraseña, un botón "Entrar" y un enlace "Crea una" que lleva a `/register`.

#### Scenario: Acceso a la pantalla de login

- **WHEN** un usuario sin sesión abre `/login`
- **THEN** ve los campos email y contraseña, el botón "Entrar" y el enlace "Crea una"

#### Scenario: Navegación al registro

- **WHEN** el usuario está en `/login` y pulsa "Crea una"
- **THEN** la aplicación navega a `/register`

### Requirement: Errores de validación en el formulario de login

Al pulsar "Entrar", la aplicación SHALL enviar la petición de login a la API sin validar antes los campos en el navegador, y SHALL mostrar bajo cada campo el error de validación que devuelva la API para ese campo. La API SHALL exigir que ambos campos estén rellenos y que el email tenga un formato válido, y SHALL NOT exigir una longitud mínima ni máxima a la contraseña en el login.

#### Scenario: Envío con el formulario vacío

- **WHEN** el usuario está en `/login`, deja ambos campos vacíos y pulsa "Entrar"
- **THEN** se envía la petición de login, la API la rechaza y ambos campos muestran un mensaje de error

#### Scenario: Email con formato inválido

- **WHEN** el usuario está en `/login`, introduce un email con formato inválido y pulsa "Entrar"
- **THEN** el campo email muestra el mensaje "Introduce una dirección de email válida."

#### Scenario: Contraseña fuera del rango de 8 a 32 caracteres

- **WHEN** el usuario está en `/login`, introduce un email válido y una contraseña de menos de 8 caracteres y pulsa "Entrar"
- **THEN** no aparece ningún error de longitud de contraseña; la API solo comprueba si las credenciales son correctas

#### Scenario: Credenciales incorrectas

- **WHEN** el usuario está en `/login`, introduce un email y una contraseña que no corresponden a ninguna cuenta y pulsa "Entrar"
- **THEN** se muestra un aviso con el mensaje "El email o la contraseña no son correctos."

### Requirement: Inicio de sesión correcto en la aplicación

La aplicación SHALL llevar al usuario a `/profile` cuando el inicio de sesión tiene éxito.

#### Scenario: Credenciales válidas

- **WHEN** el usuario está en `/login`, introduce el email y la contraseña de una cuenta existente y pulsa "Entrar"
- **THEN** la aplicación navega a `/profile` y muestra el resumen de su cuenta

### Requirement: Pantalla de registro

La aplicación SHALL mostrar en `/register` un formulario "Crea tu cuenta" con los campos nombre completo (opcional), email, contraseña y "Repite la contraseña", un botón "Crear cuenta" y un enlace "Inicia sesión" para volver al inicio de sesión.

#### Scenario: Acceso a la pantalla de registro

- **WHEN** un usuario sin sesión abre `/register`
- **THEN** ve los campos nombre completo, email, contraseña y "Repite la contraseña", el botón "Crear cuenta" y el enlace "Inicia sesión"

#### Scenario: Volver al inicio de sesión

- **WHEN** el usuario está en `/register` y pulsa "Inicia sesión"
- **THEN** la aplicación navega a `/login`

### Requirement: Errores de validación en el formulario de registro

Al enviar el formulario de registro, la aplicación SHALL comprobar primero en el navegador que ambas contraseñas coinciden y, si no coinciden, SHALL mostrar el error únicamente en "Repite la contraseña" sin llamar a la API. Si coinciden, SHALL enviar la petición de registro y mostrar bajo cada campo el error de validación que devuelva la API. El nombre SHALL ser opcional.

#### Scenario: Envío con campos obligatorios vacíos

- **WHEN** el usuario está en `/register`, deja vacíos email, contraseña y "Repite la contraseña" y envía el formulario
- **THEN** cada uno de esos campos muestra un mensaje de error

#### Scenario: Nombre sin rellenar

- **WHEN** el usuario está en `/register`, deja vacío el nombre y rellena correctamente el resto de campos
- **THEN** el campo nombre no muestra ningún error y la cuenta se crea

#### Scenario: Contraseña corta con la confirmación vacía

- **WHEN** el usuario está en `/register`, introduce una contraseña de 4 caracteres, deja vacío "Repite la contraseña" y envía el formulario
- **THEN** solo "Repite la contraseña" muestra el error "Las contraseñas no coinciden." y el campo contraseña no muestra un error de longitud

#### Scenario: Contraseña corta con ambos campos rellenos

- **WHEN** el usuario está en `/register`, introduce la misma contraseña de 4 caracteres en ambos campos y envía el formulario
- **THEN** se muestra un error de longitud mínima de contraseña

#### Scenario: Contraseñas distintas

- **WHEN** el usuario está en `/register`, introduce valores distintos en contraseña y "Repite la contraseña" y envía el formulario
- **THEN** solo el campo "Repite la contraseña" muestra un error, el campo contraseña no muestra ninguno y no se llama a la API

#### Scenario: Email ya registrado

- **WHEN** el usuario está en `/register` e introduce un email que ya pertenece a otra cuenta
- **THEN** el campo email muestra "Ese email ya está registrado. Inicia sesión en su lugar."

### Requirement: Registro correcto en la aplicación

La aplicación SHALL dejar al usuario con la sesión iniciada y llevarlo a `/profile` cuando la cuenta se crea con éxito.

#### Scenario: Cuenta creada

- **WHEN** el usuario está en `/register`, rellena el formulario con datos válidos y un email no registrado y lo envía
- **THEN** la aplicación navega a `/profile` y muestra el resumen de la nueva cuenta

### Requirement: Pantalla de perfil

La aplicación SHALL mostrar en `/profile` un panel con el resumen de la cuenta del usuario autenticado (iniciales, nombre o "Sin nombre", email y la fecha de creación como "Miembro desde") y un botón "Cerrar sesión".

#### Scenario: Usuario autenticado abre el perfil

- **WHEN** un usuario con sesión iniciada abre `/profile`
- **THEN** ve sus iniciales, su nombre, su email, la fecha "Miembro desde" y el botón "Cerrar sesión"

#### Scenario: Usuario sin nombre

- **WHEN** un usuario que se registró sin nombre abre `/profile`
- **THEN** en lugar del nombre ve "Sin nombre"

### Requirement: Protección del perfil

La aplicación SHALL redirigir a `/login` a cualquier usuario sin sesión que intente abrir `/profile`.

#### Scenario: Acceso sin sesión

- **WHEN** un usuario sin sesión abre `/profile`
- **THEN** la aplicación lo redirige a `/login`

### Requirement: Cierre de sesión en la aplicación

La aplicación SHALL cerrar la sesión local y llevar al usuario a `/login` cuando pulsa "Cerrar sesión", tanto si la petición de logout a la API tiene éxito como si falla.

#### Scenario: Cerrar sesión

- **WHEN** el usuario está en `/profile` con sesión iniciada y pulsa "Cerrar sesión"
- **THEN** la aplicación navega a `/login` y el usuario deja de tener sesión

#### Scenario: Fallo de la petición de logout

- **WHEN** el usuario pulsa "Cerrar sesión" y la petición de logout a la API falla
- **THEN** la sesión local se cierra igualmente y la aplicación navega a `/login`

### Requirement: API de registro

La API SHALL aceptar `POST /api/v1/auth/signup` con `fullName` (opcional, admite nulo), `email`, `password` y `passwordConfirmation`. SHALL rechazar la petición cuando el email no tenga formato válido, supere los 254 caracteres o ya esté registrado; cuando la contraseña o su confirmación no tengan entre 8 y 32 caracteres; o cuando ambas no coincidan. Si la petición es válida, SHALL crear la cuenta y responder con los datos del usuario y un token de acceso dentro de `data`.

#### Scenario: Registro válido

- **WHEN** se envía `POST /api/v1/auth/signup` con un email no registrado y contraseñas iguales de entre 8 y 32 caracteres
- **THEN** la respuesta es correcta y contiene `data.user` (id, fullName, email, createdAt, updatedAt, initials) y `data.token`

#### Scenario: Email ya registrado

- **WHEN** se envía `POST /api/v1/auth/signup` con un email que ya pertenece a otra cuenta
- **THEN** la petición se rechaza con un error de validación sobre el campo email y no se crea ninguna cuenta

#### Scenario: Contraseñas distintas

- **WHEN** se envía `POST /api/v1/auth/signup` con `password` y `passwordConfirmation` distintos
- **THEN** la petición se rechaza con un error de validación y no se crea ninguna cuenta

#### Scenario: Contraseña fuera de rango

- **WHEN** se envía `POST /api/v1/auth/signup` con una contraseña de menos de 8 o más de 32 caracteres
- **THEN** la petición se rechaza con un error de validación y no se crea ninguna cuenta

#### Scenario: Email demasiado largo

- **WHEN** se envía `POST /api/v1/auth/signup` con un email de más de 254 caracteres
- **THEN** la petición se rechaza con un error de validación sobre el campo email

### Requirement: API de login

La API SHALL aceptar `POST /api/v1/auth/login` con `email` y `password`. SHALL comprobar que existe una cuenta con ese email y esa contraseña y, si es así, SHALL emitir un nuevo token de acceso válido y responder con los datos del usuario y el token dentro de `data`. El cliente SHALL enviar ese token en las peticiones posteriores que requieren autenticación. La API SHALL NOT exigir una longitud concreta a la contraseña en el login.

#### Scenario: Credenciales correctas

- **WHEN** se envía `POST /api/v1/auth/login` con el email y la contraseña de una cuenta existente
- **THEN** la respuesta contiene `data.user` y `data.token`, y ese token permite acceder a los endpoints autenticados

#### Scenario: Credenciales incorrectas

- **WHEN** se envía `POST /api/v1/auth/login` con un email inexistente o una contraseña que no corresponde
- **THEN** la petición se rechaza con un error de credenciales y no se emite ningún token

#### Scenario: Email con formato inválido

- **WHEN** se envía `POST /api/v1/auth/login` con un email sin formato válido
- **THEN** la petición se rechaza con un error de validación

### Requirement: API de logout

La API SHALL aceptar `POST /api/v1/account/logout` solo con un token de acceso válido. Al recibirla, SHALL invalidar el token con el que se hizo la petición y responder con un mensaje de confirmación.

#### Scenario: Logout con token válido

- **WHEN** se envía `POST /api/v1/account/logout` con un token válido
- **THEN** la respuesta contiene el mensaje `Logged out successfully` y ese token deja de ser aceptado por los endpoints autenticados

#### Scenario: Logout sin token

- **WHEN** se envía `POST /api/v1/account/logout` sin token o con un token no válido
- **THEN** la petición se rechaza por falta de autenticación

### Requirement: API de perfil

La API SHALL aceptar `GET /api/v1/account/profile` solo con un token de acceso válido y SHALL responder con los datos del usuario propietario del token dentro de `data`.

#### Scenario: Perfil con token válido

- **WHEN** se envía `GET /api/v1/account/profile` con un token válido
- **THEN** la respuesta contiene en `data` el id, fullName, email, createdAt, updatedAt e initials del usuario

#### Scenario: Perfil sin token válido

- **WHEN** se envía `GET /api/v1/account/profile` sin token, con un token inexistente o con un token ya invalidado por logout
- **THEN** la petición se rechaza por falta de autenticación

---

## Parte B

### 1. Requisitos generados y comprobados

- Requisitos escritos por el agente: 15
- Requisitos comprobados consultando el código: 15

### 2. Incoherencias detectadas

- La respuesta de logout es `{ message: ... }` sin el envoltorio `data` que llevan el resto de respuestas correctas de la API — API, logout.
- `GET /` responde `{ hello: 'world' }` sin envoltorio `data` y fuera del prefijo `/api/v1` — API, raíz.
- Los tokens de acceso se emiten sin caducidad, pero ante un 401 el frontend muestra "Tu sesión ha caducado. Vuelve a iniciar sesión." — frontend (traducción de errores) frente a la API (emisión de tokens).
- Los formularios declaran `required` y `minLength` en los campos, pero desactivan la validación del navegador, así que esos atributos no tienen efecto y el login se envía a la API aunque esté vacío — frontend, pantallas de login y registro.
- El campo contraseña del registro anuncia "Entre 8 y 32 caracteres." pero el error de longitud solo aparece cuando ambas contraseñas coinciden, porque la comprobación de coincidencia en el navegador se ejecuta antes y no llega a la API — frontend, registro.
- El registro exige contraseñas de 8 a 32 caracteres y el login acepta contraseñas de cualquier longitud — API, registro frente a login.
- La longitud de la contraseña se valida también en `passwordConfirmation`, de modo que una contraseña corta produce el mismo error duplicado en ambos campos — API, registro.
- Cualquier respuesta 400 se muestra en el frontend como "El email o la contraseña no son correctos.", aunque el 400 venga de otra causa — frontend, traducción de errores.
- Cada login emite un token nuevo sin invalidar los anteriores, y el logout solo invalida el token de la petición, así que pueden quedar sesiones abiertas indefinidamente en otros dispositivos — API, login y logout.

### 3. Comportamientos sin clasificar (¿bug o contrato?)

- **Iniciales calculadas a partir del email.** Si el usuario no tiene nombre, `initials` se calcula con la primera letra de la parte local del email y la primera del dominio (`ada@example.com` → `AE`). Si el nombre tiene una sola palabra, se toman sus dos primeras letras (`Ada` → `AD`); con dos espacios entre palabras también toma solo la primera, y si el nombre empieza por un espacio las iniciales salen vacías. *Bug:* lo esperable sería algo como `AD` para `ada@…`, y usar el dominio parece un efecto de reutilizar el mismo `split` para nombre y email. *Contrato:* puede ser una decisión deliberada para obtener siempre dos letras distintas y diferenciar usuarios del mismo dominio local. El código no tiene comentarios, tests ni especificación que digan qué resultado se busca.
- **Emails que solo difieren en mayúsculas.** La unicidad del email y la búsqueda en el login comparan el texto exacto, así que `Ada@x.com` y `ada@x.com` pueden ser dos cuentas distintas y el login distingue mayúsculas. *Bug:* los emails no suelen distinguir mayúsculas, y esto permite cuentas duplicadas en la práctica. *Contrato:* puede asumirse que el email se guarda tal como lo escribe el usuario y que normalizarlo queda fuera del alcance. No hay normalización ni regla explícita en ningún sitio que indique la intención.
- **Login sin validación de longitud de contraseña.** *Bug:* incoherente con la regla de 8 a 32 del registro. *Contrato:* es una práctica habitual no revelar las reglas de la contraseña en el login y responder solo "credenciales incorrectas", además de permitir entrar a cuentas con contraseñas antiguas si la regla cambia. El código no deja constancia de cuál de las dos es la intención.
