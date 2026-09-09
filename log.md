---
titulo: Bitácora
tipo: sintesis
estado: activo
actualizado: 2026-09-09
---

# Bitácora

> Registro cronológico, lo más nuevo arriba. Append-only: no se edita el pasado.
> Prefijos: `ingesta` · `sintesis` · `lint` · `decision`.

## [2026-09-09] decision | El seguimiento de Tersil queda en un solo mensaje a las 10 horas

Decisión del dueño: un único recordatorio a las **10 horas**, sin los de 46 y 69 h. Eso disuelve
el problema de la ventana de 24 h de WhatsApp en vez de gestionarlo — a las 10 h siempre se está
dentro y no hacen falta plantillas aprobadas por Meta.

`Tersil - Seguimiento 10 h` (9738949) reescrito de 12 módulos a 4, sin router:

- Referencias corregidas a `{{1.data.telefono}}` y `{{1.data.nombre}}`.
- Filtro `seguimientos < 1` como candado antidoble.
- **Guardarraíl nuevo**: `ultimo_mensaje > now-24h`, para no intentar nunca un envío fuera de
  ventana. De paso excluyó solos los 54 registros represados desde el 1 de septiembre, así que
  no hizo falta purgar el data store ni hubo envío masivo al reactivar.
- `sendMessage` antes de `UpdateRecord`: ya no se marca como enviado lo que falló.
- `Ignore` → `Break` con 3 reintentos y `dlq: true`: los rechazos de Meta ahora son visibles.

**Verificado a las 17:45 UTC**: la corrida de las 17:44 consumió 16 operaciones en 4 774 ms
—contra 52 en 746 ms de la última corrida rota— y los cinco registros de la ventana pasaron a
`seguimientos: 1`, con marca de tiempo de segundo en segundo. Como el `UpdateRecord` va después
del `sendMessage`, esa marca prueba el envío. `dlqCount: 0`. **Cinco mensajes, los primeros en
nueve días.** Ver [[Make-Tersil-Seguimiento-10h]].

Pendiente: el prompt de [[Make-Tersil-Asistente-V2]] sigue diciendo «cada 23 horas».

## [2026-09-09] sintesis | El seguimiento de Tersil lleva ocho días en verde sin enviar nada

El dueño reportó que no encontraba ninguna operación exitosa de envío en el escenario de
seguimiento de Tersil. Confirmado: **no existe ninguna**. 381 ejecuciones, todas `SUCCESS`,
cero errores, cero mensajes.

Causa raíz: `datastore:SearchRecord` entrega los campos bajo `data`, y los filtros del router
leen `{{1.seguimientos}}` en vez de `{{1.data.seguimientos}}`. Con el operando vacío ninguna de
las tres rutas se cumple. Como `{{1.key}}` sí existe, el módulo siguiente no falla y Make
reporta éxito. Escrito [[Diagnostico-Seguimiento-Tersil]] con los otros tres defectos:
la ventana de 24 h de WhatsApp invalida los seguimientos 2 y 3, los `Ignore` ocultan los
rechazos de Meta, y el contador se marca antes de enviar.

Ingesta de Tersil como cliente nuevo: [[Tersil]], [[Tersil-Agente-de-Ventas]],
[[Make-Tersil-Asistente-V2]], [[Make-Tersil-Seguimiento-10h]]. Nada tocado todavía en Make;
el arreglo queda pendiente de decisión.

## [2026-09-09] decision | El contador de errores de Make no mide si un escenario funciona

Corregido [[Seguimiento-por-Sondeo]], que afirmaba «fallos típicos: ninguno observado» con
99.9% de fiabilidad. Ese número medía **excepciones**, no efecto. Un escenario cuyos filtros
descartan todo corre en verde para siempre.

La señal que sí delata el fallo es el **consumo por corrida creciendo de forma monótona**: si
la cola se drenara, bajaría. En Tersil pasó de 42 a 51 operaciones en 38 horas. Añadir esa
comprobación al lint: escenario de sondeo cuyas operaciones por ejecución solo suben.

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
