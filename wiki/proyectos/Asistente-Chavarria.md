---
titulo: Asistente Chavarría
tipo: proyecto
estado: activo
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [whatsapp, agente-ia, airtable, calendar]
inicio: 2026-08-18
actualizado: 2026-09-05
---

# Asistente Chavarría

> Agente de WhatsApp que atiende a los interesados en el bachillerato, agenda visitas en
> Google Calendar y deja el registro en Airtable.

## Qué resuelve

El colegio recibe mensajes de WhatsApp durante toda la ventana de inscripciones y nadie puede
contestarlos a la velocidad a la que llegan. El agente responde, extrae los datos del
interesado, agenda si procede y avisa por correo.

## Estado actual

Activo desde el 2026-08-18, editado por última vez el 2026-09-03. Es la implementación **más
reciente** del patrón [[Agente-Conversacional-de-WhatsApp]] y por eso la más limpia: usa
`RunLocalAIAgent` de Make en lugar de encadenar llamadas sueltas a OpenAI como hacían los
prototipos de finales de 2025.

## Piezas

- [[Make-Asistente-Chavarria]] — el escenario completo.
- Airtable — tabla de prospectos (búsqueda, alta y dos actualizaciones distintas).
- Google Calendar — creación de la cita.
- Gmail — aviso interno al colegio.
- [[Make-CUT-Seguimiento-Prospectos]] — recoge lo que este agente deja sembrado en Airtable.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 353 | 2026-09-05 |
| Operaciones | 1 777 | 2026-09-05 |
| Errores | 25 (7.1%) | 2026-09-05 |
| Créditos | ~2 662 | 2026-09-05 |

## Decisiones tomadas

- **Airtable, no Data Store.** Coherente con el resto del cliente, pero divergente respecto a
  [[Lefranm-Agendamiento-de-Citas]]. Ver [[Persistencia-Airtable-vs-Data-Store]].
- **Agente local de Make** en vez de asistente de OpenAI: menos módulos, más control del ruteo.

## Pendientes y riesgos

- 7.1% de error sostenido. No está diagnosticado qué rama falla.
- El agente crea eventos en Calendar pero **no consulta disponibilidad** antes
  (`getFreeBusyInformation` no aparece en el flujo, a diferencia de Lefranm). Puede empalmar
  citas. Ver [[Riesgos-y-Deuda-Tecnica]].

## Correlaciones

Es el mismo esqueleto que [[Lefranm-Agente-de-Ventas]] — mismo disparador, mismo agente, misma
extracción estructurada, mismo destino Airtable — con distinto dominio. Ver
[[Correlacion-de-Proyectos]].
