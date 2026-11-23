---
titulo: Make · LEFRANM SEGUIMIENTO CITAS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5747451
clientes: [Lefranm-Cosmeticos]
tags: [seguimiento, data-store, whatsapp]
actualizado: 2026-11-23
---

# Make · LEFRANM SEGUIMIENTO CITAS

> Reenganche de prospectos que platicaron y **no** agendaron, cada 30 minutos, leyendo del
> Data Store.

> [!warning] Corrección 2026-11-23
> Esta página decía "recordatorios de cita". El blueprint (revisado el 2026-11-23) muestra
> otra cosa: busca registros con `cita_agendada = false`, `seguimiento_enviado = false` y
> último mensaje hace más de 90 min. A esos les manda "vimos que se quedó platicando con
> nosotros pero no continuamos…". No hay recordatorios de cita en ningún escenario.

## Disparador

Programado: **indefinido, cada 1 800 s (30 min)**.

## Flujo

1. `datastore · SearchRecord` sobre el Data Store de conversaciones, límite 50. Filtro:
   `cita_agendada` falso, `seguimiento_enviado` falso, con teléfono, y `ultimo_mensaje` hace
   más de 90 min.
2. `whatsapp-business-cloud · sendMessage`: mensaje de reenganche.
3. `datastore · UpdateRecord`: `seguimiento_enviado = true`.

Desde el 2026-11-23, `cita_agendada` solo es verdadero si el bot devolvió un Event ID real
(ver [[Make-Lefranm-Citas#Cambios aplicados 2026-11-23]]). Si el bot confirmó una cita sin
crearla, el cliente sí recibirá este reenganche. Pero antes ya se avisó a la persona de
respaldo, que debe agendar a mano.

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
