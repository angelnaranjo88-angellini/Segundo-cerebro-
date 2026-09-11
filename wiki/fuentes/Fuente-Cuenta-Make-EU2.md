---
titulo: Cuenta de Make eu2 — organización 5601227
tipo: fuente
estado: activo
origen: Make API · organización 5601227 · equipo 2904200 · eu2.make.com
fecha_ingesta: 2026-09-11
tags: [make, inventario, tersil, blueprint]
actualizado: 2026-09-11
---

# Cuenta de Make eu2 — organización 5601227

> Una **segunda cuenta de Make** que el wiki no conocía. Ahí vive todo Tersil.

## Resumen

Consulta a la API de Make el 2026-09-11: entorno, lista de escenarios del equipo 2904200,
blueprints completos de los dos escenarios activos, registros del Data Store
`TERSIL_Pausa_Bot`, lista de ejecuciones de `Asistente Tersil V2`, y las definiciones de la app
`whatsapp-business-cloud` (módulos `sendMessage` y `watchEvents2`, más el RPC
`interfaceWebhook`).

## Cifras globales

| | Valor |
|---|---|
| Escenarios totales | 5 |
| Activos | 2 |
| Inactivos | 3 (todos con cero ejecuciones) |
| Ejecuciones acumuladas | 1 316 |
| Operaciones | 12 492 |
| Errores | 11 (0.84%) |
| Créditos | ~13 323 |

Corte: **2026-09-11**.

| Escenario | ID | Estado | Ejecuciones | Errores | Créditos |
|---|---|---|---|---|---|
| [[Make-Asistente-Tersil-V2]] | 9597789 | activo | 838 | 11 (1.3%) | ~3 812 |
| [[Make-Tersil-Seguimiento-10h]] | 9738949 | activo | 478 | 0 | ~9 511 |
| `Asistente Tersil` (v1) | 9405390 | apagado | 0 | — | 0 |
| `Asistente Tersil V2 - Catalogo PDF` | 9628524 | apagado | 0 | — | 0 |
| `Integration WhatsApp… json2video` | 9668182 | apagado | 0 | — | 0 |

## Ideas clave

1. **El inventario del wiki estaba incompleto.** [[Fuente-Inventario-Make]] documenta el equipo
   1436402 de `us2.make.com` y lo presenta como "el portafolio". Esta cuenta —otra
   organización, otra zona, otro correo de acceso— tiene un cliente activo con 838 ejecuciones
   que no aparecía en ninguna página. Todo porcentaje del wiki calculado "sobre el total" está
   mal: eran 22 escenarios, son al menos 27.
2. **Se repite el patrón de escenarios muertos el mismo día.** Tres apagados con cero
   ejecuciones, igual que los 14 del otro equipo. Ver [[Escenarios-Inactivos]].
3. **El intento del catálogo tiene rastro.** `Asistente Tersil V2 - Catalogo PDF` (creado
   2026-08-07, editado el mismo día, nunca ejecutado) es la prueba de que el problema del
   catálogo ya se intentó resolver una vez, por la vía de mandarlo como documento. Ver
   [[Catalogo-de-WhatsApp-en-Agentes-de-Make]].
4. **La API de Make no expone el detalle de ejecución de estos escenarios**:
   `executions_get-detail` devuelve solo `status`. El análisis por operación (1 op = filtro
   bloqueó, 5 = ruta feliz) es la única lectura disponible.

## Qué páginas creó esta ingesta

[[Tersil]], [[Tersil-Asistente-de-Ventas]], [[Make-Asistente-Tersil-V2]],
[[Make-Tersil-Seguimiento-10h]] y [[Catalogo-de-WhatsApp-en-Agentes-de-Make]]. Actualizó
[[Agente-Conversacional-de-WhatsApp]] y [[Seguimiento-por-Sondeo]], que pasan de tres a cuatro
implementaciones vivas cada uno.

## Preguntas que abre

- ¿Cuántas cuentas de Make hay en total? Con dos descubiertas y ningún inventario central, el
  supuesto de que "el portafolio son 7 escenarios activos" ya no se sostiene. Hace falta una
  página que enumere las cuentas, no los escenarios.
- ¿Los números de [[Riesgos-y-Deuda-Tecnica]] siguen valiendo? La concentración "Lefranm 90.7%"
  se calculó sin Tersil. Con los ~13 323 créditos de esta cuenta sumados, el reparto cambia.
- ¿El catálogo de Tersil es un catálogo de Meta Commerce conectado al WABA, con `catalog_id`?
  No se pudo verificar desde aquí: el conector de Meta disponible es el del colegio.
