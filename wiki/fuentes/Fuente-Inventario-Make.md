---
titulo: Inventario de escenarios de Make
tipo: fuente
estado: activo
origen: Make API · organización 5357289 · equipo 1436402 · us2.make.com
fecha_ingesta: 2026-09-05
tags: [make, metricas, inventario]
actualizado: 2026-09-05
---

# Inventario de escenarios de Make

> La fuente de la que sale prácticamente todo el análisis cuantitativo de este wiki.

## Resumen

Listado completo de los 22 escenarios del equipo `My Team` (1436402), con sus módulos,
programación, ejecuciones acumuladas, operaciones, errores, créditos consumidos y fechas de
creación y última edición. Corte: **2026-09-05**.

## Cifras globales

| | Valor |
|---|---|
| Escenarios totales | 22 |
| Activos | 7 |
| Inactivos | 15 (14 con cero ejecuciones) |
| Ejecuciones acumuladas (activos) | 6 079 |
| Operaciones | 25 133 |
| Errores | 253 (4.2%) |
| Créditos | ~35 677 |

## Ideas clave

1. Solo **dos arquitecturas** explican los 7 escenarios vivos:
   [[Agente-Conversacional-de-WhatsApp]] (3) y [[Seguimiento-por-Sondeo]] (3), más el
   pipeline de contenido (1).
2. La correlación entre **presencia de IA y tasa de error** es nítida: 8.2% con IA frente a
   0.1% sin ella.
3. **Cinco escenarios creados el mismo día** (2026-05-12) y ninguno activado: fue una sesión
   de diseño que nunca se ejecutó.
4. El único escenario que sobrevivió del pipeline de contenido es el que cambió el disparador
   de "mensaje humano" a "cola programada".

## Qué páginas actualizó esta ingesta

Las 8 páginas de `wiki/automatizaciones/`, los 6 proyectos, los 6 conceptos y las 3 síntesis.
Es la ingesta fundacional del wiki.

## Preguntas que abre

- ¿Qué rama concreta falla en cada agente? El inventario da la tasa, no la causa: hace falta
  el detalle de ejecuciones (`executions_list`) de los tres escenarios señalados en
  [[Riesgos-y-Deuda-Tecnica]].
- ¿Los blueprints exportados confirmarían que los tres agentes son estructuralmente el mismo
  escenario? Hoy es una inferencia a partir de la lista de módulos.
