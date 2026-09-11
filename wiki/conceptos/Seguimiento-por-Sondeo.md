---
titulo: Seguimiento por sondeo
tipo: concepto
estado: activo
tags: [patron, make, whatsapp, seguimiento]
actualizado: 2026-09-11
---

# Seguimiento por sondeo

> Tres módulos, cada 30 minutos, cero IA. El patrón más aburrido del portafolio y, con
> diferencia, **el más confiable**.

## El patrón

```
[cada 1800 s]
  buscar registros pendientes  (Airtable ActionSearchRecords | Data Store SearchRecord)
     → sendMessage (WhatsApp)
     → marcar como enviado     (ActionUpdateRecords | UpdateRecord)
```

Sin webhook, sin agente, sin extracción. La base de datos es la cola y el campo de estado es
el candado que evita el doble envío.

## Dónde lo uso

| Implementación | Almacén | Ejecuciones | Errores |
|---|---|---|---|
| [[Make-Lefranm-Seguimiento-Citas]] | Data Store | 1 311 | **0** |
| [[Make-Lefranm-Seguimiento-Cosmeticos]] | Airtable | 1 308 | **0** |
| [[Make-CUT-Seguimiento-Prospectos]] | Airtable | 460 | 3 (0.65%) |
| [[Make-Tersil-Seguimiento-10h]] | Data Store | 478 | **0** |

**3 557 ejecuciones, 3 errores.** Fiabilidad del 99.9%. Corte: 2026-09-05 los tres primeros,
2026-09-11 Tersil.

## Variantes y cuándo elegir cada una

Las tres primeras son el mismo escenario con distinta tabla. La única variante real entre ellas
es el almacén, y esa elección la arrastra el agente que siembra los registros, no el sondeo
mismo. Ver [[Persistencia-Airtable-vs-Data-Store]].

[[Make-Tersil-Seguimiento-10h]] es la única que añade dos cosas, y las dos deberían volverse
estándar:

- **Ventana superior.** Su filtro no es "hace más de X" sino "entre 10 y 24 horas". Pasadas 24
  horas el registro deja de calificar, así que nadie queda perseguido para siempre — y el
  mensaje nunca cae fuera de la ventana de 24 h de WhatsApp.
- **Reintentos.** `builtin · Break` en el `sendMessage`: 3 intentos cada 15 minutos, con DLQ
  activo. Las otras tres pierden el mensaje si WhatsApp falla en ese instante.

## Fallos típicos

Ninguno observado. El riesgo real no es técnico sino económico: **el sondeo cobra aunque no
haya nada que hacer**. Los cuatro escenarios corren 48 veces al día cada uno, para siempre,
hayan o no registros pendientes. Con la campaña del colegio ya cerrada,
[[Make-CUT-Seguimiento-Prospectos]] es gasto puro.

Y el caso extremo es Tersil: [[Make-Tersil-Seguimiento-10h]] consumió **~9 511 créditos en 11
días**, dos veces y media lo que su propio agente en 43. Un sondeo cuyo `SearchRecord` devuelve
varios registros por corrida multiplica los módulos de abajo — ~20 operaciones por ejecución
frente a las 3 o 4 del caso ideal. **Antes de optimizar un agente, mira su sondeo.**

## Correlaciones

Es la contraparte de [[Agente-Conversacional-de-WhatsApp]]. Juntos forman el ciclo completo:
el agente captura y siembra, el sondeo persigue. Ver [[Patrones-Reutilizables]].
