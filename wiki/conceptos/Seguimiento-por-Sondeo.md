---
titulo: Seguimiento por sondeo
tipo: concepto
estado: activo
tags: [patron, make, whatsapp, seguimiento]
actualizado: 2026-09-05
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

**3 079 ejecuciones, 3 errores.** Fiabilidad del 99.9%.

## Variantes y cuándo elegir cada una

Las tres son el mismo escenario con distinta tabla. La única variante real es el almacén, y
esa elección la arrastra el agente que siembra los registros, no el sondeo mismo. Ver
[[Persistencia-Airtable-vs-Data-Store]].

## Fallos típicos

Ninguno observado. El riesgo real no es técnico sino económico: **el sondeo cobra aunque no
haya nada que hacer**. Los tres escenarios corren 48 veces al día cada uno, para siempre,
hayan o no registros pendientes. Con la campaña del colegio ya cerrada,
[[Make-CUT-Seguimiento-Prospectos]] es gasto puro.

## Correlaciones

Es la contraparte de [[Agente-Conversacional-de-WhatsApp]]. Juntos forman el ciclo completo:
el agente captura y siembra, el sondeo persigue. Ver [[Patrones-Reutilizables]].
