---
titulo: Índice
tipo: sintesis
estado: activo
actualizado: 2026-09-10
---

# Índice

> Catálogo de todas las páginas del wiki. Se actualiza en cada ingesta.
> Corte de datos del portafolio: **2026-09-05**. Última entrada: 2026-09-10.

## Empezar aquí

| Página | Qué responde |
|---|---|
| [[Correlacion-de-Proyectos]] | ¿Qué comparten de verdad mis proyectos? |
| [[Patrones-Reutilizables]] | ¿Qué ya construí dos veces y debería estandarizar o vender? |
| [[Riesgos-y-Deuda-Tecnica]] | ¿Dónde se va el dinero y qué se está rompiendo? |
| [[CLAUDE]] | Las reglas del wiki. Leer antes de escribir. |
| [[log]] | Cómo creció esto. |

## Clientes

| Página | Una línea | Estado |
|---|---|---|
| [[Colegio-Maria-Chavarria-Vital]] | Bachillerato y universidad en Tláhuac; único cliente con Meta Ads | activo |
| [[Lefranm-Cosmeticos]] | Cosmética profesional y estética en Iztapalapa; 90% del volumen | activo |
| [[Sonrisas-Para-Todos-Nosotros]] | Clínica dental; solo landing, sin automatización | prototipo |

## Proyectos

| Página | Una línea | Estado |
|---|---|---|
| [[Lefranm-Agendamiento-de-Citas]] | Agente de citas con CRUD completo de Calendar + MCP | activo |
| [[Lefranm-Agente-de-Ventas]] | Agente de catálogo por WhatsApp, 22 módulos | activo |
| [[Asistente-Chavarria]] | Agente de inscripciones; el más eficiente por ejecución | activo |
| [[CUT-Captacion-de-Prospectos]] | Embudo Meta Ads → WhatsApp → Airtable → seguimiento | activo |
| [[CUT-Contenido-Social]] | Publicación diaria automática en FB e IG | activo |
| [[Landing-Sonrisas-Dental]] | Landing estática sin desplegar ni conectar | prototipo |
| [[Sacapuntos-Lealtad-Papeleria]] | Puntos por ticket para papelería; solo la pantalla principal | prototipo |

## Automatizaciones

| Página | ID | Errores | Créditos |
|---|---|---|---|
| [[Make-Lefranm-Citas]] | 5645150 | 7.6% | ~20 624 |
| [[Make-Lefranm-Cosmeticos-Ventas]] | 5587862 | 10.1% | ~8 315 |
| [[Make-Asistente-Chavarria]] | 5982362 | 7.1% | ~2 662 |
| [[Make-Lefranm-Seguimiento-Cosmeticos]] | 5866647 | 0% | ~1 712 |
| [[Make-Lefranm-Seguimiento-Citas]] | 5747451 | 0% | ~1 695 |
| [[Make-CUT-Seguimiento-Prospectos]] | 6055110 | 0.65% | ~595 |
| [[Make-CUT-Creacion-de-Contenido-Sheets]] | 6077792 | **46.2%** | ~63 |
| [[Escenarios-Inactivos]] | — | — | los 15 apagados |

## Conceptos

| Página | Qué patrón describe |
|---|---|
| [[Agente-Conversacional-de-WhatsApp]] | El patrón central; 3 implementaciones vivas |
| [[Seguimiento-por-Sondeo]] | 3 módulos cada 30 min; lo más confiable que tienes |
| [[Pipeline-de-Contenido-Social]] | 6 generaciones en 10 meses; por qué sobrevivió la última |
| [[Agendamiento-con-Google-Calendar]] | Calendar como base de datos de citas |
| [[Persistencia-Airtable-vs-Data-Store]] | La contradicción arquitectónica sin resolver |
| [[Stack-Tecnologico]] | Todo el inventario de herramientas |

## Fuentes

| Página | Origen | Ingesta |
|---|---|---|
| [[LLM-Wiki-Karpathy]] | Gist de Andrej Karpathy | 2026-09-05 |
| [[Fuente-Inventario-Make]] | API de Make, 22 escenarios | 2026-09-05 |
| [[Fuente-Catalogo-Lefranm]] | PDF en Drive, ~52 SKUs | 2026-09-05 |
| [[Fuente-Hoja-CUT-Fotos]] | Hoja de Google, cola de publicación | 2026-09-05 |

## Consultas en vivo

Requieren el plugin **Dataview**. Si lo tienes activo, estas tablas se generan solas y no
envejecen como las de arriba.

```dataview
TABLE tipo, estado, actualizado
FROM "wiki"
SORT actualizado DESC
```

Páginas que llevan más de 60 días sin tocarse (candidatas a lint):

```dataview
TABLE estado, actualizado
FROM "wiki"
WHERE date(today) - date(actualizado) > dur(60 days)
SORT actualizado ASC
```

Todo lo de un cliente:

```dataview
TABLE tipo, estado
FROM "wiki"
WHERE contains(clientes, "Lefranm-Cosmeticos")
```
