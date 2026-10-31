# Alcance del MVP de FlowSync

## 1. El terreno que ya existe

Solo hay **autenticación de usuarios** construida de punta a punta: registro (nombre opcional, email único, contraseña), login con token, ver el propio perfil y logout. En el frontend hay tres pantallas: login, registro y perfil. El único concepto de negocio que existe es el **usuario**, más sus tokens de acceso. No hay tareas, equipos ni nada del dominio, y no hay tests. El MVP parte de aquí: usa estos usuarios y esta sesión, y todo lo de tareas es nuevo.

## 2. El interrogatorio

Una sola ronda de cinco preguntas, sin bajar a modelo de datos ni endpoints:

1. ¿Qué tiene que poder saber alguien en 10 segundos al abrir FlowSync?
2. ¿Cómo es el equipo típico y cómo se organiza el trabajo?
3. ¿Qué significa exactamente "tiempo real"? ¿Es imprescindible en la primera versión?
4. ¿Qué es el "rollo" de Jira que no queremos repetir, y qué hace bien?
5. ¿Qué alcance tiene esta entrega, qué queda fuera y cómo sabremos que funciona?

Las respuestas son la ficha de hechos del enunciado, pegada entera (ver `prompts.md`, prompt 3).

## 3. El alcance

### Problema

En un equipo remoto pequeño, nadie ve en qué está cada uno sin interrumpir a alguien. Hoy se resuelve con la ronda de "¿en qué estás?" de la daily, que se come la mitad de sus 15 minutos, y con preguntas sueltas por chat. Cuando falla, se paga caro: dos personas tocaron el mismo módulo la misma semana sin saberlo y se perdieron dos días.

### Usuarios

- **Quién:** los miembros de un equipo remoto de 3 a 10 personas, todos al mismo nivel. Quien saca el valor son los compañeros, no un lead ni un manager.
- **Caso de estudio:** un equipo de producto SaaS de 6 personas en 3 husos horarios, con un gestor de tareas pesado y una daily de 15 minutos por videollamada.
- **No es nuestro usuario:** un equipo que necesite sprints, estimaciones, épicas o informes hacia arriba.

### Propuesta de valor

Una lista de trabajo compartida que cada persona usa como su propia cola: la mira para decidir qué coge, y al cambiar el estado de una tarea con dos clics informa al resto sin hacer nada más. Gracias a eso, cualquiera ve **qué está cogido, qué está libre y qué se ha movido** sin preguntar.

- **Hipótesis a validar:** si actualizar cuesta dos clics, el estado se mantiene al día solo, y el equipo puede eliminar la ronda de "¿en qué estás?".
- **Riesgo #1:** que la información se quede vieja. Si pasa, el producto no tiene sentido.
- **Éxito:** tras una semana de uso real, el equipo cancela esa ronda de la daily y nadie pide que vuelva.

### Alcance (lo que entra)

1. **Un único espacio compartido.** Cualquier usuario registrado ve y edita todas las tareas, sin roles. Se reutiliza la autenticación que ya existe.
2. **Crear una tarea escribiendo solo el título.** Responsable y fecha de vencimiento son opcionales.
3. **Cambiar el estado en dos clics desde la lista.** Hay tres estados fijos: Pendiente, En curso y Hecha.
4. **Asignarse una tarea o cambiar su responsable desde la lista.** Una tarea sin responsable está **libre**.
5. **Fecha de vencimiento**, con las tareas vencidas destacadas a simple vista.
6. **Filtro por estado**, para centrarse en lo pendiente.
7. **Frescura de cada tarea:** se muestra cuándo cambió por última vez ("hace 2 h") y la lista se ordena por el último cambio. Así, al volver se ve arriba lo que se ha movido.
8. **Cambios de otros sin refrescar:** con la lista abierta, lo que cambian los demás aparece solo, sin avisos ni sonidos.

### NO-alcance (lo que se queda fuera, y por qué)

Cada recorte se justifica por la hipótesis: **si el estado está al día y se ve de un vistazo, la ronda de "¿en qué estás?" desaparece**. Lo que no ayuda a validarla, o lo que la pone en peligro, se queda fuera.

| Se queda fuera | Por qué |
|---|---|
| Resumen "qué ha cambiado desde tu última visita" | Ordenar la lista por último cambio y mostrar "hace X" (puntos 7 y 8) ya responde a "llego y veo qué se ha movido". Un resumen aparte exige registrar las visitas de cada persona y montar otra vista. Hay que añadir eso solo si la lista ordenada se queda corta. |
| Borrar o archivar tareas | Marcar como "Hecha" cubre el caso normal. Además, una tarea que desaparece sin dejar rastro es justo la información que falta cuando alguien pregunta "¿qué pasó con aquello?". |
| Descripción, etiquetas, prioridad, subtareas | Cada campo nuevo hace más lento crear una tarea y la acerca al "rollo de Jira". Para saber quién está en qué basta con título, responsable, estado y fecha. |
| Comentarios en tareas | Convierten la tarea en un hilo de conversación, y eso es chat, que se ha descartado de forma explícita. No ayudan a ver el estado. |
| Estado "Bloqueada" y gestión de bloqueos | La ficha dice que la parte de bloqueos de la daily se mantiene y que el MVP no la resuelve. Meterlo a medias ensancharía la hipótesis sin poder validarla. |
| Estados o flujos configurables | Configurar es precisamente el rollo del que huimos. Con tres estados fijos, todo el equipo lee el tablero igual. |
| Varios equipos o espacios, invitaciones, una persona en varios equipos | El caso de estudio es un solo equipo. Tener varios espacios no cambia la hipótesis y obliga a decidir pertenencia y visibilidad. Queda como supuesto. |
| Roles y permisos | El equipo es plano: todos ven y editan lo mismo. Los permisos protegen contra un problema que este usuario no tiene. |
| Presencia ("quién está conectado"), indicadores de actividad | Se rechaza por principio, no por plazo: el estado es de la tarea, no de la persona, y mostrar presencia es vigilancia. |
| Notificaciones push, email o Slack | La señal debe ser un resumen que espera a que lo mires, no un aviso que interrumpe. Una notificación reintroduce la interrupción que queremos quitar. |
| Integraciones (Git/PRs, CI, calendario) para deducir el estado | Es otro producto, con OAuth de terceros. La hipótesis es que la persona escribe el estado en segundos, no que se deduzca. |
| Importar o sincronizar con otro gestor de tareas | FlowSync sustituye al gestor, no convive con él. Si convive, hay que actualizar dos sitios, y así es como muere esta categoría. |
| Sprints, estimaciones, épicas, backlog priorizado | Es una renuncia explícita: un equipo que necesite esto no es nuestro usuario. |
| Analítica, informes, métricas para managers | El valor es de los compañeros. No hay nadie arriba que lo lea y a un manager le da igual. |
| Historial de cambios de cada tarea | Para decidir qué cojo no necesito saber quién cambió qué hace tres días, solo el estado actual y cuándo cambió. |
| Filtrar por responsable, buscar por texto | Con 3 a 10 personas la lista es corta, y la ficha pide filtrar solo por estado. Hay que añadirlo solo si la lista crece hasta no verse de un vistazo. |
| Editar el perfil, recuperar la contraseña | Lo que ya existe basta para el caso de estudio y no toca la hipótesis. |
| App móvil, modo sin conexión | El trabajo se hace en el escritorio. La web con la lista abierta cubre el caso. |

### Supuestos

- **Registro abierto:** quien se registra entra en el único espacio y lo ve todo. Para un caso de estudio sirve, pero un equipo real necesitaría cerrar el acceso.
- **El duplicado solo se evita si la tarea existe antes de empezar el trabajo.** FlowSync no detecta que dos personas tocan el mismo módulo, solo muestra lo que alguien ha declarado.
- Los tiempos se muestran en relativo ("hace 2 h"), así que la diferencia de husos horarios no obliga a nada más.

---

## Parte B: las tres líneas

1. **Los dos números:** la IA propuso 8 cosas dentro del alcance y, después de mi recorte, siguen dentro las 8.
2. **Tres cosas que dejé fuera, y por qué:**
   - **Notificaciones push, por email o por Slack.** No sirven para comprobar si el estado se mantiene al día solo. Además vuelven a meter la interrupción que el producto quiere quitar, así que contaminarían la señal: no sabríamos si la ronda desaparece porque el estado se ve de un vistazo o porque los avisos empujan a la gente.
   - **Integraciones para deducir el estado (Git/PRs, CI, calendario).** Pondrían a prueba otra idea: que el estado se puede deducir sin que nadie lo escriba. La hipótesis de este MVP es la contraria, que escribirlo cuesta dos clics y que quien lo escribe sale ganando en el momento.
   - **Comentarios en las tareas.** No ayudan a ver de un vistazo quién está en qué. Convierten la tarea en una conversación, que es justo el chat de "¿en qué estás?" que queremos eliminar.
3. **La exclusión de la que menos seguro estoy: el resumen "qué ha cambiado desde tu última visita".** Choca lo que pide la ficha con lo que es barato. La ficha describe la señal como "un resumen que espera" y pone como ejemplo "llego por la mañana y veo qué se ha movido". Yo lo sustituyo por la lista ordenada por último cambio, que no distingue entre lo que ya vi y lo que no, y en la que mis propios cambios se mezclan con los del resto. Entraría si en la primera semana alguien del equipo sigue preguntando "¿qué ha cambiado?" al llegar, o si la ronda de la daily sobrevive solo para contar eso.

> **Incoherencia que señaló la IA:** la ficha pone como ejemplo dos personas que tocaron el mismo módulo, pero FlowSync solo evita ese caso si la tarea se crea **antes** de empezar a trabajar. No detecta solapes. El producto promete algo que su propio alcance solo cumple si cambia un hábito, y por eso aparece como supuesto y no como algo garantizado.
