---
titulo: Bitácora
tipo: sintesis
estado: activo
actualizado: 2026-09-11
---

# Bitácora

> Registro cronológico, lo más nuevo arriba. Append-only: no se edita el pasado.
> Prefijos: `ingesta` · `sintesis` · `lint` · `decision`.

## [2026-09-11] lint | Prueba real del pedido por catálogo: un acierto y un bug

Carrito de prueba de **3 artículos ($897)** contra [[Make-Asistente-Tersil-V2]].

**Confirmado**: Make **sí** entrega `order.product_items` aunque el disparador no lo mapee en su
panel. Se cierra la incógnita que abrió [[Fuente-Cuenta-Make-EU2]].

**Bug encontrado**: Make **aplana mal las rutas de array anidadas**. Con dos niveles de `[]`
(`messages[]` → `product_items[]`) se queda con el primer elemento: de 3 artículos llegó 1, y el
agente cobró $299 en vez de $807 sin aplicar el 10%. Arreglado indexando el mensaje
(`1.messages[1]`) para dejar un solo nivel, mandando ambas rutas en paralelo —lista A y lista
B— para que una sola prueba diga cuál sirve. Anotado como caveat del patrón en
[[Agente-Conversacional-de-WhatsApp#Patrón nuevo: ficha técnica como Input del agente]].

**Tercer hallazgo**: las claves del catálogo de WhatsApp de [[Tersil]] son IDs automáticos de
Meta (`36hao5euls`), no las claves `PRM-`/`INV-` del prompt — y el agente se las enseñó al
cliente. El PASO 2.5 se partió en dos casos: si reconoce todas las claves confirma con nombre de
modelo; si no, **nunca muestra la clave** y confirma por piezas y total. Falta la tabla de
equivalencias `código de Meta → modelo`, que necesita los 8 ID de contenido de Commerce Manager.

Lección transferible, y barata de olvidar: **en Make, un nivel de `[]` se aplana a lista; dos no.**

## [2026-09-11] decision | El asistente de Tersil ya recibe pedidos del catálogo de WhatsApp

Cambio aplicado **en producción** sobre [[Make-Asistente-Tersil-V2]] (838 ejecuciones, activo).
Tres ediciones quirúrgicas, **cero módulos nuevos y cero operaciones extra**:

1. El filtro de entrada pasó de `text.body` existe a `messages[].id` existe. Entra el carrito
   del catálogo (`type: order`), la foto del comprobante, la nota de voz, el botón y la
   ubicación; solo se descartan los acuses de entrega.
2. El Input del agente pasó del texto pelón a una **ficha técnica** con tipo de mensaje, claves
   y cantidades del carrito, producto referido, botón tocado y pie de foto.
3. El `systemPrompt` ganó PASO 2.5 (pedido del catálogo), 2.6 (consulta de producto referido) y
   2.7 (mensajes no-texto), más la corrección de la mentira del seguimiento (decía 23 h, el
   escenario hace 10 h una sola vez).

**Decisión de diseño: no meter un router.** El ruteo por tipo de mensaje lo hace el modelo a
partir de la ficha, no el escenario. Así el escenario sigue en 8 módulos y 5 operaciones por
ejecución y el costo no sube. Nace de ahí un patrón reutilizable en los otros tres agentes:
[[Agente-Conversacional-de-WhatsApp#Patrón nuevo: ficha técnica como Input del agente]].

**Decisión técnica: rutas de array, nunca funciones IML.** `{{1.messages[].order.product_items[].product_retailer_id}}`
se resuelve a vacío si el campo no viene; un `map()` o un `if()` sobre `undefined` reventaría la
ejecución. El prompt cubre las dos salidas, así que el cliente queda atendido tanto si Make
entrega el detalle del carrito como si no.

Lo que **no** se tocó, a propósito: las 7 pausas de agosto en `TERSIL_Pausa_Bot`. Cuándo
devuelve el humano la conversación al bot es una decisión de negocio, no un arreglo de
escenario.

Pendiente del lado de Meta, no de Make: confirmar con un pedido de prueba que el bundle traiga
`order.product_items[]`, y que las claves del catálogo de WhatsApp sean las mismas del prompt
(`PRM-016`…`INV-084`). Detalle en [[Catalogo-de-WhatsApp-en-Agentes-de-Make]].

Actualizó: [[Make-Asistente-Tersil-V2]], [[Tersil-Asistente-de-Ventas]],
[[Make-Tersil-Seguimiento-10h]], [[Agente-Conversacional-de-WhatsApp]] y la síntesis.

## [2026-09-11] sintesis | El catálogo de WhatsApp en agentes de Make

→ [[Catalogo-de-WhatsApp-en-Agentes-de-Make]]. Pregunta del dueño: ¿puede el asistente de
Tersil darse cuenta de que alguien pidió el catálogo y contestarle sobre el catálogo de
WhatsApp?

Respuesta: sí se puede, pero hoy lo bloquean **cuatro candados y ninguno está en WhatsApp**.

1. El filtro `Solo mensajes de texto` del módulo 2 de [[Make-Asistente-Tersil-V2]] descarta
   todo lo que no traiga `text.body` — y un carrito del catálogo llega como `type: order`, sin
   `text.body`. El escenario termina "con éxito" en 1 operación y el cliente no recibe nada.
2. El disparador `watchEvents2` de Make **no mapea** `order.product_items[]` ni
   `context.referred_product` (verificado contra el RPC `interfaceWebhook` de la app). De ahí
   viene el síntoma exacto: cuando alguien consulta un producto desde el catálogo, el agente
   recibe la pregunta sin saber de qué producto habla.
3. El módulo `sendMessage` de Make solo soporta `list` y `button` como interactivos: **no puede
   enviar** `catalog_message`, `product` ni `product_list`. Y la app no tiene módulo
   "Make an API Call", así que el catálogo nativo solo sale por el módulo HTTP.
4. El `systemPrompt` nunca menciona el catálogo de WhatsApp: manda siempre al catálogo web de
   bolt.host.

Plan en tres niveles en la página. El Nivel 1 —router por `{{1.messages[].type}}` y pasarle el
tipo de mensaje al agente— rinde casi todo el valor en media hora y sin token de Meta.

Hallazgo lateral: como el registro de seguimiento tampoco se escribe cuando el filtro bloquea,
un cliente que manda su carrito recibe a las 10 horas el recordatorio automático preguntándole
si ya vio los modelitos. Manda su pedido y el sistema le contesta como si no hubiera escrito.

## [2026-09-11] ingesta | Cuenta de Make eu2 — todo Tersil

→ [[Fuente-Cuenta-Make-EU2]]. **El inventario del wiki estaba incompleto.** Existe una segunda
cuenta de Make (organización 5601227, equipo 2904200, `eu2.make.com`) que
[[Fuente-Inventario-Make]] no cubría, con un cliente activo y 838 ejecuciones que no aparecía
en ninguna página: [[Tersil]], tienda de ropa de bebé que vende entera por WhatsApp.

Creadas [[Tersil]], [[Tersil-Asistente-de-Ventas]], [[Make-Asistente-Tersil-V2]] y
[[Make-Tersil-Seguimiento-10h]] con blueprints completos, no solo con la lista de módulos.

Corrección de un hallazgo del wiki: [[Agente-Conversacional-de-WhatsApp]] afirmaba que
**"la fragilidad está en la capa de IA"**. Tersil lo desmiente — usa un modelo en cada
ejecución y falla **1.3%**, frente al 7.1%-10.1% de los otros tres. La variable real es
`transformTextToStructuredData`: los frágiles encadenan entre una y cuatro extracciones, el
confiable no usa ninguna. Enunciado nuevo: **la fragilidad está en la extracción estructurada,
no en la IA.** [[Riesgos-y-Deuda-Tecnica]] sigue calculando con el enunciado viejo.

Segundo hallazgo de costo: [[Make-Tersil-Seguimiento-10h]] gastó ~9 511 créditos en 11 días,
**2.5 veces lo que su propio agente en 43**, por ~20 operaciones por corrida. Antes de
optimizar un agente, mira su sondeo. Actualizó [[Seguimiento-por-Sondeo]], que además gana dos
variantes que deberían volverse estándar: ventana superior de 24 h y reintentos con `Break`.

Pendiente abierto: no hay inventario de **cuentas** de Make. Con dos descubiertas, el supuesto
de "7 escenarios activos en el portafolio" ya no se sostiene, y los porcentajes de
[[Riesgos-y-Deuda-Tecnica]] se calcularon sin Tersil.

## [2026-09-05] lint | Primer chequeo de salud del wiki

40 páginas, 37 destinos de enlace distintos. **Cero enlaces rotos** y cero páginas huérfanas
dentro de `wiki/`.

Huérfanas fuera de `wiki/` y aceptadas por diseño: las seis de `plantillas/` (se copian, no se
enlazan) y `README.md` (es la portada de GitHub, no un nodo del grafo).

Los destinos `[[...]]`, `[[Nombre-Del-Archivo]]` y `[[Pagina]]` que aparecen en [[CLAUDE]] y en
las plantillas son ejemplos de sintaxis, no enlaces reales.

Pendiente para el próximo lint: verificar que las métricas con corte 2026-09-05 sigan vigentes;
todas envejecen a diario.

## [2026-09-05] sintesis | Tres páginas de correlación del portafolio

Escritas [[Correlacion-de-Proyectos]], [[Patrones-Reutilizables]] y
[[Riesgos-y-Deuda-Tecnica]] cruzando las cuatro fuentes ingeridas hoy.

Hallazgo principal: **no hay seis proyectos, hay dos patrones aplicados a tres negocios.**
Los tres agentes conversacionales son el mismo escenario de Make con distinta tabla y distinto
prompt; los tres seguimientos son literalmente los mismos tres módulos.

Hallazgo cuantitativo: los escenarios que llaman a un modelo fallan el **8.2%** de las veces y
consumen el **88.6%** de los créditos; los que no lo hacen fallan el **0.1%**. 250 de los 253
errores del entorno están en la capa de IA.

Contradicciones abiertas: persistencia partida entre Airtable y Data Store sin criterio; repo
`Nuevo-Proyecto-Marista` con contenido dental; `(copy)` en producción; Chavarría agenda sin
consultar disponibilidad.

## [2026-09-05] ingesta | Hoja "CUT - FOTOS PARA PUBLICAR"

→ [[Fuente-Hoja-CUT-Fotos]]. La cola de publicación del colegio: seis columnas que son a la vez
backlog, texto generado y bitácora de ids de post.

Detectado que las `URL_IMAGEN` usan el formato `/view?usp=sharing`, que no es descarga
directa — hipótesis principal del 46% de error de
[[Make-CUT-Creacion-de-Contenido-Sheets]].

Actualizó: [[CUT-Contenido-Social]], [[Make-CUT-Creacion-de-Contenido-Sheets]],
[[Colegio-Maria-Chavarria-Vital]], [[Pipeline-de-Contenido-Social]].

## [2026-09-05] ingesta | Catálogo de precios Lefranm

→ [[Fuente-Catalogo-Lefranm]]. ~52 SKUs (`Lf-001`–`Lf-052`), $65–$589 MXN, registro COFEPRIS
`2409165018X00154`. El catálogo ya está organizado por problema de piel, que es como pregunta
el cliente por WhatsApp.

Deuda señalada: vive en un PDF, no en la tabla de Airtable que el agente ya consulta.

Actualizó: [[Lefranm-Cosmeticos]], [[Lefranm-Agente-de-Ventas]].

## [2026-09-05] ingesta | Inventario de escenarios de Make

→ [[Fuente-Inventario-Make]]. 22 escenarios del equipo 1436402: 7 activos, 15 apagados (14 con
cero ejecuciones). 6 079 ejecuciones acumuladas, 25 133 operaciones, 253 errores, ~35 677
créditos.

Creadas las 8 páginas de `wiki/automatizaciones/`, los 6 conceptos, los 6 proyectos y los 3
clientes. Es la ingesta fundacional del wiki.

Descubrimiento lateral: cinco escenarios creados el mismo día (2026-05-12) y ninguno activado.
Dos de ellos —reporte semanal de citas y petición de reseña post-cita— siguen sin sustituto y
son las ideas de mejor retorno por módulo del inventario. Ver [[Escenarios-Inactivos]].

## [2026-09-05] ingesta | LLM Wiki de Andrej Karpathy

→ [[LLM-Wiki-Karpathy]]. Fuente fundacional. Define las tres capas (fuentes crudas · wiki ·
esquema), las tres operaciones (ingesta · consulta · lint) y el papel de `index.md` y `log.md`.

## [2026-09-05] decision | Estructura del vault

Instanciado el patrón para este dominio. Decisiones tomadas:

- **Español en todo el contenido**, nombres de archivo sin acentos para que los enlaces
  `[[...]]` no se rompan entre sistemas de archivos.
- **Frontmatter obligatorio** con `tipo`, `estado` y `actualizado`, para que Dataview pueda
  consultar el wiki en vez de depender de tablas escritas a mano.
- **Cinco carpetas** en `wiki/`: proyectos, clientes, automatizaciones, conceptos, síntesis,
  fuentes. Las automatizaciones tienen carpeta propia porque en este dominio un escenario de
  Make **es** una entidad de primera clase, no un detalle de implementación.
- **Toda métrica lleva fecha de corte.** Los números de este portafolio cambian cada día.
- **Sin secretos en el repo.** Tokens, API keys y datos personales de clientes finales quedan
  fuera; se referencia dónde viven, no su valor.

Ver [[CLAUDE]].
