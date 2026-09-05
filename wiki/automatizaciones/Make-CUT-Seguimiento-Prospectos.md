---
titulo: Make · CUT - Seguimiento Prospectos
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 6055110
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [seguimiento, airtable, whatsapp]
actualizado: 2026-09-05
---

# Make · CUT - Seguimiento Prospectos

> Tres módulos, cada 30 minutos: busca prospectos pendientes en Airtable, les manda WhatsApp,
> marca la fila.

## Disparador

Programado: **indefinido, cada 1 800 s (30 min)**.

## Flujo

1. `airtable · ActionSearchRecords` — prospectos que tocan seguimiento.
2. `whatsapp-business-cloud · sendMessage` — mensaje.
3. `builtin · Ignore` — corta si no hay nada.
4. `airtable · ActionUpdateRecords` — marca el envío para no repetirlo.

## Persistencia

Airtable.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 460 | 2026-09-05 |
| Operaciones | 595 (1.3 por ejecución) | 2026-09-05 |
| Errores | 3 (0.65%) | 2026-09-05 |
| Créditos | ~595 | 2026-09-05 |

## Problemas conocidos

- Ninguno técnico. Cerrada la campaña 2026, sigue corriendo 48 veces al día sin prospectos que
  atender: candidato a pausar.

## Correlaciones

Proyecto: [[CUT-Captacion-de-Prospectos]]. Patrón: [[Seguimiento-por-Sondeo]].
Hermanos gemelos: [[Make-Lefranm-Seguimiento-Citas]],
[[Make-Lefranm-Seguimiento-Cosmeticos]].
