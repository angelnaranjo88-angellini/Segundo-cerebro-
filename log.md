---
titulo: Bitácora
tipo: sintesis
estado: activo
actualizado: 2026-09-05
---

# Bitácora

> Registro cronológico, lo más nuevo arriba. Append-only: no se edita el pasado.
> Prefijos: `ingesta` · `sintesis` · `lint` · `decision`.

## [2026-09-08] decision | CV 2026: fuera la preparatoria, entran el diplomado, Chaos Ctrl y cinco clientes

Revisión del CV vigente (PDF de Canva, una hoja). Resultado en
`cv/CV-Luis-Angel-Sanchez-Naranjo-2026.md`.

**Cambios acordados**

- **Fuera la preparatoria**: con licenciatura terminada no aporta.
- **Entra el diplomado** "Inteligencia Artificial Aplicada en la Creación y Administración de
  Negocios Nacionales e Internacionales", **UNAM — FES Aragón**, mayo 2025 – enero 2026.
  Misma institución que la licenciatura: verificable de inmediato.
- **Entra Chaos Ctrl como experiencia laboral.** El CV anterior terminaba en junio de 2024:
  un hueco de más de dos años. Las afirmaciones ("herramientas a medida", "IA avanzada")
  quedan respaldadas con datos del wiki: 7 escenarios en producción y más de 6 000 ejecuciones
  al corte 2026-09-05. Ver [[Correlacion-de-Proyectos]] y [[Stack-Tecnologico]].
- El perfil pasa de lista de adjetivos a una frase con resultados; habilidades técnicas
  separadas de blandas; hobbies fuera.

**Datos nuevos que el wiki no tenía**

Nombre comercial del negocio: **Chaos Ctrl**. Cartera declarada de **cinco clientes**:

| Cliente | ¿Documentado en el wiki? |
|---|---|
| Centro Universitario Trilingüe | Sí, bajo [[Colegio-Maria-Chavarria-Vital]] |
| Lefranm Quiropráctico | Sí, pero como **Lefranm Cosméticos** — contradicción |
| Universidad Marista | **No** |
| Apcon — Escuela de Mecánica Automotriz | **No** |
| Salones de Belleza Manuel | **No** |

Y a la inversa: [[Sonrisas-Para-Todos-Nosotros]], que sí tiene página, no aparece en la lista.

**Contradicciones marcadas, no resueltas**

1. *Lefranm Quiropráctico* vs. *Lefranm Cosméticos* → advertencia en [[Lefranm-Cosmeticos]].
2. El repositorio `Nuevo-Proyecto-Marista` no era un error de nombre: falta el proyecto
   Marista → advertencia actualizada en [[Sonrisas-Para-Todos-Nosotros]].

**Pendiente de ingesta**: Marista, Apcon y Salones de Belleza Manuel. Hasta entonces, las
cifras duras del CV solo respaldan a tres clientes; los otros dos suman a la cartera, no a los
números. El teléfono queda como marcador: no entran datos de contacto directo al repo.

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
