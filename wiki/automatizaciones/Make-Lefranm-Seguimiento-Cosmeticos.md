---
titulo: Make · LEFRANM COSMETICOS SEGUIMIENTO
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5866647
clientes: [Lefranm-Cosmeticos]
tags: [seguimiento, airtable, whatsapp]
actualizado: 2026-09-05
---

# Make · LEFRANM COSMETICOS SEGUIMIENTO

> Seguimiento de clientes de catálogo cada 30 minutos, leyendo de Airtable.

## Disparador

Programado: **indefinido, cada 1 800 s (30 min)**.

## Flujo

1. `airtable · ActionSearchRecords` — clientes pendientes de seguimiento.
2. `whatsapp-business-cloud · sendMessage` — mensaje.
3. `airtable · ActionUpdateRecords` — marca el envío.

## Persistencia

Airtable (coherente con [[Make-Lefranm-Cosmeticos-Ventas]]).

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 1 308 | 2026-09-05 |
| Operaciones | 1 712 (1.3 por ejecución) | 2026-09-05 |
| Errores | **0** | 2026-09-05 |
| Créditos | ~1 712 | 2026-09-05 |

## Problemas conocidos

Ninguno. Cero errores en 1 308 ejecuciones.

## Correlaciones

Proyecto: [[Lefranm-Agente-de-Ventas]]. Patrón: [[Seguimiento-por-Sondeo]].
Nótese la simetría: este cliente corre **dos** sondeos idénticos en paralelo, uno sobre
Airtable y otro sobre Data Store ([[Make-Lefranm-Seguimiento-Citas]]), porque su estado está
partido en dos sistemas. Ver [[Persistencia-Airtable-vs-Data-Store]].
