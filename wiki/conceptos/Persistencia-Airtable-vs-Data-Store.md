---
titulo: Persistencia — Airtable vs. Data Store
tipo: concepto
estado: activo
tags: [patron, airtable, data-store, decision, contradiccion]
actualizado: 2026-09-05
---

# Persistencia — Airtable vs. Data Store

> Dos almacenes para el mismo tipo de dato, sin un criterio escrito que diga cuándo usar cuál.
> Es la contradicción arquitectónica más clara del portafolio.

> [!warning] Contradicción detectada
> Los escenarios de [[Colegio-Maria-Chavarria-Vital]] guardan estado en **Airtable**.
> [[Make-Lefranm-Citas]] lo guarda en el **Data Store de Make**.
> [[Make-Lefranm-Cosmeticos-Ventas]], del mismo cliente, usa **las dos a la vez**: Airtable
> para contactos y pedidos, Data Store para el hilo de conversación.
> No hay decisión documentada. Corte: 2026-09-05.

## El costo real de la divergencia

Lefranm corre **dos escenarios de seguimiento idénticos en paralelo**
([[Make-Lefranm-Seguimiento-Citas]] sobre Data Store y
[[Make-Lefranm-Seguimiento-Cosmeticos]] sobre Airtable) porque el estado del mismo cliente
está partido en dos sistemas. Son 2 619 ejecuciones y ~3 407 créditos al corte, haciendo lo
mismo sobre dos tablas distintas.

Además: la misma persona puede existir como dos registros sin relación —contacto en Airtable
y cita en el Data Store— y nada los une.

## Cuándo conviene cada uno

| | Airtable | Data Store de Make |
|---|---|---|
| Lo ve un humano sin entrar a Make | Sí | No |
| Consultable desde fuera | Sí (API) | Solo dentro de Make |
| Costo por operación | Cuenta como operación de Make + cuota de Airtable | Operación de Make |
| Bueno para | Datos de negocio: contactos, pedidos, prospectos | Estado efímero: hilo de conversación, banderas |
| Latencia | Depende de la API externa | Menor |

## Criterio propuesto

> **Estado efímero de conversación → Data Store. Datos de negocio que alguien va a mirar,
> exportar o cobrar → Airtable.**

Bajo ese criterio, [[Make-Lefranm-Citas]] está del lado equivocado: una cita es un dato de
negocio, no estado efímero, y hoy nadie la ve fuera de Make salvo por el evento de Calendar.

Esto es una **propuesta, no una decisión tomada**. Requiere tu visto bueno antes de migrar
nada.

## Correlaciones

[[Agente-Conversacional-de-WhatsApp]], [[Seguimiento-por-Sondeo]],
[[Riesgos-y-Deuda-Tecnica]].
