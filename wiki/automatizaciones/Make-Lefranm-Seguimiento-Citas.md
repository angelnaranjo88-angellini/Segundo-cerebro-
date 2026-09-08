---
titulo: Make · LEFRANM SEGUIMIENTO CITAS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5747451
clientes: [Lefranm-Quiropractico]
tags: [seguimiento, data-store, whatsapp]
actualizado: 2026-09-05
---

# Make · LEFRANM SEGUIMIENTO CITAS

> Recordatorios de cita cada 30 minutos, leyendo del Data Store.

## Disparador

Programado: **indefinido, cada 1 800 s (30 min)**.

## Flujo

1. `datastore · SearchRecord` — citas que tocan recordatorio.
2. `whatsapp-business-cloud · sendMessage` — recordatorio.
3. `datastore · UpdateRecord` — marca el envío.

## Persistencia

Data Store de Make (coherente con [[Make-Lefranm-Citas]]).

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 1 311 | 2026-09-05 |
| Operaciones | 1 695 (1.3 por ejecución) | 2026-09-05 |
| Errores | **0** | 2026-09-05 |
| Créditos | ~1 695 | 2026-09-05 |

## Problemas conocidos

Ninguno. **Cero errores en 1 311 ejecuciones.**

## Correlaciones

Proyecto: [[Lefranm-Agendamiento-de-Citas]]. Patrón: [[Seguimiento-por-Sondeo]].
Es la prueba empírica de que la fragilidad del portafolio no está en Make ni en WhatsApp:
está en las capas de IA. Ver [[Riesgos-y-Deuda-Tecnica]].
