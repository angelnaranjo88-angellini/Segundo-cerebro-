---
titulo: Tersil
tipo: cliente
estado: activo
clientes: [Tersil]
tags: [whatsapp, ecommerce, ropa-bebe, make]
actualizado: 2026-09-09
---

# Tersil

Tienda de **ropa de bebé** (talla única 0–3 meses) que vende exclusivamente en línea por
WhatsApp, con envío gratis a toda la República Mexicana. Representante legal: Javier Silva
Sánchez. Operación en CDMX, sin tienda física.

- WhatsApp de negocio: **55 3135 7396** (público)
- Instagram: `@tersil.mx`
- Catálogo digital: `https://tersil-baby-catalog-gl2r.bolt.host/`

## Modelo de negocio

Precio base **$299 MXN por pieza**, envío incluido. Descuentos por volumen: 10% (3–4 piezas),
15% (5–7), 20% (8 o más). **Pago 100% anticipado** por SPEI o depósito en OXXO; no hay pago
contra entrega. Los datos bancarios viven en el prompt del agente, no en este repo.

## Qué está automatizado

| Pieza | Estado |
|---|---|
| [[Make-Tersil-Asistente-V2]] | activo — agente de ventas por WhatsApp |
| [[Make-Tersil-Seguimiento-23h]] | activo pero **roto**, ver [[Diagnostico-Seguimiento-Tersil]] |

## Diferencia con los demás clientes

Es el primer cliente del portafolio con **e-commerce puro**: no agenda citas
([[Lefranm-Cosmeticos]]) ni capta inscripciones ([[Colegio-Maria-Chavarria-Vital]]), sino que
cierra una venta completa dentro de WhatsApp, incluyendo ficha de pedido y datos de pago. Eso
lo hace el único caso donde el bot se **autopausa** al cerrar, para que un humano tome la
conversación.

## Correlaciones

Comparte el patrón [[Agente-Conversacional-de-WhatsApp]] con los otros tres agentes vivos, y
[[Seguimiento-por-Sondeo]] con los tres escenarios de seguimiento. Ver
[[Correlacion-de-Proyectos]].
