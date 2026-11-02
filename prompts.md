# Prompts del ejercicio spec-viva

## 1. Preparar el fichero y el formato

```
Vamos a crear un fichero en docs/spec-viva/jgp.md donde vamos a especificar el alcance del sistema. El formato sera:

## Purpose: una o dos frases que expliquen para qué existe esta capability.

## Requirements: sección que contiene los requisitos, cada uno encabezado por ### Requirement: y redactado con SHALL para indicar lo que debe hacer el sistema.

#### Scenario:: al menos uno por requisito, con dos viñetas: **WHEN***. Incluye las precondiciones dentro de WHEN, sin utilizar GIVEN.

Idioma: español, excepto las palabras clave de la RFC.

Las reglas son:

No utilices ADDED, MODIFIED ni REMOVED. Son secciones propias de una especificación de cambios (delta). En este ejercicio nos centramos en documentar el comportamiento actual del sistema.

Describe solo comportamientos observables desde fuera. No incluyas nombres de clases, archivos ni rutas del código. En la API, describe peticiones y respuestas; en el frontend, lo que el usuario ve y puede hacer.

No modifiques el código. Aunque encuentres errores o inconsistencias, déjalos tal como están. Esos hallazgos forman parte del análisis de la parte B.

Yo te ire escribiendo lo que hace el sistema y tu lo iras anotando en ese formato. Tener en cuenta que voy a analizar el backend y el frontend viendo la UI y la interaccion con la API
```

## 2. Parte A: comportamiento observado

```
El endpoint /login muestra un inicio de sesion con dos acciones: Entrar para hacer login y "crear una"
- Si no se rellena nada, ambos textfield muestran error
- Si el email no es valido, el textfield muestra error
- Si los dos campos no estan completos, entonces no se llama a la api de login
- Se hace login incluso si la contrasena no tiene 8 y 32 caracters

"Crear una" accede a /register donde se puede introducir un nombre, email y contrasena, donde el nombre es opcional y la password necesita entre 8 y 32 caracteres. Se permite volver a iniciar sesion
- Muestra errores en los textfield requeridos si no son rellenados
- Una pass de 4 caracteres no lanza error por si sola, antes hay que rellenar las dos para mostrar el error
- Si las contrasenas no coinciden entonces solo se muestra el error en "Repite la contrasena"

Al crear una cuenta se muestra un panel con el resumen de la cuenta junto con el dia de creacion y permite cerrar session. Esto se encuentra en una url /profile

Cerrar session vuelve a la pantalla de /login

Si accedes a /profile sin estar logueado eres redirigido a /login

Si el login es correcto entonces se accede al resumen del usuario en /profile

Al crear una cuenta se comprueba que el email no existe dentro de la base de datos, que ambas contrasenas son iguales y que las longitudes de las contrasenas estan entre 8 y 32. En caso de email, la longitud maxima es 254

Al hacer login, comprobamos que el email y password existen en base de datos y generamos un token en base a los datos del usuario. Una vez obtenido el token y el usuario lo serializamos y se almacena en tokens validos. Devuelve informacion del usuario y el token. Este token sera enviado posteriormente

Al hacer logout, obtenemos el usuario authe y obtenemos el access token y lo borramos de la lista de tokens. Independientemente del resultado, el token es eliminado.

Al entrar en profile, comprobamos que el usuario esta authenticado comprobando si el token existe
```

## 3. Parte B: las tres listas

```
Completa la parte B

🅱 Parte B: las tres listas
Añade estas tres listas debajo de la spec, en el mismo archivo. Esta parte es obligatoria, aunque no hayas terminado la parte A.

1. Requisitos generados y comprobados. Indica cuántos requisitos escribió el agente y cuántos verificaste tú consultando el código. Escribe ambos números, sin redondearlos ni justificarlos. Comprobar significa revisar el código para confirmar el comportamiento, no limitarse a leer un requisito que parece correcto.

2. Incoherencias detectadas. Anota cada inconsistencia en una línea e indica dónde aparece. No necesitas buscarlas expresamente: pueden surgir al intentar describir como regla general un comportamiento que no se cumple en todas las partes del sistema.

3. Comportamientos que no supiste clasificar como bug o contrato. Incluye al menos un caso en el que hayas encontrado un comportamiento y no tengas claro si es un error o si el sistema está diseñado para funcionar así. Explica brevemente las dos posibilidades y por qué el código no permite saber cuál es la correcta.
```

## 4. Correcciones de proceso

```
anade los prompts de este ejercicio en prompts.md
```
