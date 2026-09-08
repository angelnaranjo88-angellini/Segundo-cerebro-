---
titulo: Lefranm — Agente de ventas
tipo: proyecto
estado: activo
clientes: [Lefranm-Quiropractico]
tags: [whatsapp, agente-ia, airtable, ventas]
inicio: 2026-07-06
actualizado: 2026-09-05
---

# Lefranm — Agente de ventas

> Agente de WhatsApp que atiende consultas sobre el catálogo de ~52 productos, califica al
> cliente, registra el pedido en Airtable y notifica por correo.

## Qué resuelve

Contestar preguntas de precio y producto de cosmetólogas y estéticas sin que alguien tenga que
buscar en el PDF de lista de precios cada vez.

## Estado actual

Activo. Creado el 2026-07-06, editado el 2026-09-02. El nombre del escenario
—`LEFRANM COSMETICOS CORECTA (copy)`— delata su historia: es una copia de una copia que se
quedó en producción.

## Piezas

- [[Make-Lefranm-Cosmeticos-Ventas]] — el escenario (22 módulos, el más largo).
- [[Make-Lefranm-Seguimiento-Cosmeticos]] — sondeo cada 30 min sobre Airtable.
- Airtable — búsqueda, `upsert`, alta y dos actualizaciones.
- [[Fuente-Catalogo-Lefranm]] — la lista de precios que sustenta las respuestas.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 769 | 2026-09-05 |
| Operaciones | 6 494 | 2026-09-05 |
| Errores | 78 (10.1%) | 2026-09-05 |
| Créditos | ~8 315 | 2026-09-05 |

**La tasa de error más alta entre los agentes conversacionales.**

## Decisiones tomadas

- **Cuatro llamadas separadas a `transformTextToStructuredData`** en un mismo flujo. Es el
  escenario con más extracción estructurada del portafolio y probablemente la causa tanto del
  costo (8.4 operaciones por ejecución) como de la fragilidad.
- **`upsertRecord` de Airtable** para no duplicar clientes recurrentes — buena decisión que no
  se replicó en los demás escenarios.

## Pendientes y riesgos

- 10.1% de error. Con 22 módulos y cuatro extracciones encadenadas, cualquier respuesta del
  cliente fuera de formato rompe el flujo.
- El sufijo `(copy)` en producción es deuda: no se sabe cuál era el original ni si difiere.
- El catálogo vive en un PDF de Drive, no en una tabla. Cada cambio de precio obliga a
  reeditar el prompt en vez de una fila. Ver [[Riesgos-y-Deuda-Tecnica]].

## Correlaciones

Mismo esqueleto que [[Asistente-Chavarria]], distinto dominio: uno vende inscripciones, otro
vende crema. Ver [[Correlacion-de-Proyectos]].
