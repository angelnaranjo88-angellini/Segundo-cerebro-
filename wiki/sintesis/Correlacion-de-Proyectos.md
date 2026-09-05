---
titulo: Correlación de proyectos
tipo: sintesis
estado: activo
tags: [sintesis, correlacion, portafolio]
actualizado: 2026-09-05
---

# Correlación de proyectos

> **La pregunta**: ¿qué comparten de verdad mis últimos proyectos, más allá de estar en la
> misma cuenta de Make?

Corte de datos: **2026-09-05**.

## Respuesta corta

No tienes seis proyectos. Tienes **dos patrones** —un agente conversacional y un sondeo de
seguimiento— aplicados a **tres negocios distintos**, más un pipeline de contenido que acaba
de encontrar su forma y una landing que todavía no se conecta a nada.

Todo lo que corre en producción responde a la misma frase: *un negocio local recibe mensajes
de WhatsApp que no alcanza a contestar, y hay una fecha o una cita de por medio.*

## El mapa

| Proyecto | Cliente | Patrón conversacional | Patrón de sondeo | Contenido | Web |
|---|---|---|---|---|---|
| [[Lefranm-Agendamiento-de-Citas]] | Lefranm | ✅ con memoria | ✅ Data Store | — | — |
| [[Lefranm-Agente-de-Ventas]] | Lefranm | ✅ con memoria | ✅ Airtable | — | — |
| [[Asistente-Chavarria]] | Colegio | ✅ sin memoria | (comparte) | — | — |
| [[CUT-Captacion-de-Prospectos]] | Colegio | (comparte) | ✅ Airtable | ✅ | — |
| [[CUT-Contenido-Social]] | Colegio | — | — | ✅ | — |
| [[Landing-Sonrisas-Dental]] | Sonrisas | ❌ | ❌ | ❌ | ✅ |

## Las cuatro correlaciones reales

### 1. El mismo esqueleto, tres veces

[[Make-Lefranm-Citas]], [[Make-Lefranm-Cosmeticos-Ventas]] y [[Make-Asistente-Chavarria]] no
se parecen: **son el mismo escenario** con distinta tabla destino y distinto prompt.
`watchEvents2` → `RunLocalAIAgent` → `transformTextToStructuredData` → acción → `BasicRouter`
→ `sendMessage` → `sendAnEmail`. Ver [[Agente-Conversacional-de-WhatsApp]].

Esto significa que una mejora hecha bien en uno **se puede portar a los otros dos en una
tarde**. Y que un error de diseño ya está triplicado.

### 2. El mismo sondeo, tres veces

[[Make-Lefranm-Seguimiento-Citas]], [[Make-Lefranm-Seguimiento-Cosmeticos]] y
[[Make-CUT-Seguimiento-Prospectos]] son literalmente tres módulos idénticos: buscar → enviar →
marcar, cada 30 minutos. Ver [[Seguimiento-por-Sondeo]].

### 3. Los agentes fallan 84 veces más que los sondeos

El dato más importante del wiki:

| Familia | Ejecuciones | Errores | Tasa | Créditos | % del gasto |
|---|---|---|---|---|---|
| Agentes con IA | 2 987 | 244 | **8.2%** | ~31 602 | **88.6%** |
| Sondeos sin IA | 3 079 | 3 | **0.1%** | ~4 002 | 11.2% |
| Contenido con visión | 13 | 6 | **46.2%** | ~63 | 0.2% |

Mismo Make, mismo WhatsApp, mismas cuentas. La única variable que cambia es si hay una llamada
a un modelo en el camino. **La fragilidad y el costo viven ambos en la capa de IA**, y son la
misma capa. Ver [[Riesgos-y-Deuda-Tecnica]].

### 4. Lo que funciona es lo que quitó al humano del camino

Los cinco pipelines de contenido que dependían de que alguien mandara una foto por WhatsApp
acumularon **cero ejecuciones**. El que lee de una hoja de cálculo a las 06:00 lleva 13 días
corriendo. El mismo principio explica que los sondeos —que leen una cola— sean lo más
confiable que tienes. Ver [[Pipeline-de-Contenido-Social]].

## Lo que NO comparten (y debería preocuparte)

- **La persistencia está partida sin criterio**: Airtable en un lado, Data Store en otro, las
  dos en un tercero. Ver [[Persistencia-Airtable-vs-Data-Store]].
- **Solo un cliente tiene inversión publicitaria conectada** (el colegio). Lefranm, que genera
  el 90% del volumen operativo, crece sin anuncios medidos.
- **[[Landing-Sonrisas-Dental]] está desconectada de todo**: promete "agenda tu cita en
  minutos" y no hay nada detrás, teniendo tú un sistema de citas en producción desde julio.

## Contradicciones detectadas

1. **Airtable vs. Data Store** sin criterio escrito → [[Persistencia-Airtable-vs-Data-Store]].
2. **Repositorio `Nuevo-Proyecto-Marista` con contenido de una clínica dental** →
   [[Sonrisas-Para-Todos-Nosotros]].
3. **`(copy)` en producción**: [[Make-Lefranm-Cosmeticos-Ventas]] es una copia cuyo original no
   aparece.
4. **[[Make-Asistente-Chavarria]] agenda sin consultar disponibilidad**, mientras
   [[Make-Lefranm-Citas]] sí lo hace. Mismo patrón, dos criterios.

## Qué hacer con esto

Ver [[Patrones-Reutilizables]] para las oportunidades y [[Riesgos-y-Deuda-Tecnica]] para lo que
está sangrando.
