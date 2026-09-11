---
titulo: Tersil
tipo: cliente
estado: activo
tags: [whatsapp, ecommerce, ropa-bebe, cdmx]
actualizado: 2026-09-11
---

# Tersil

> Tienda en línea de ropa para bebé recién nacido (talla única 0-3 meses), con sede en CDMX y
> envíos a toda la República. Vende **solo por WhatsApp**.

## Contexto del negocio

Modelo de una sola talla y un solo precio de lista: **$299 MXN por conjunto**, envío gratis
incluido, con descuentos por volumen (10% desde 3 piezas, 15% desde 5, 20% desde 8). Pago
**siempre anticipado** por SPEI o depósito en OXXO; no hay pago contra entrega. Entrega en 2-5
días hábiles después de confirmar el pago.

Sin tienda física y sin carrito web propio: el cierre de la venta ocurre entero dentro de la
conversación de WhatsApp. Eso hace que el agente conversacional **no sea un apoyo al canal de
venta, sea el canal de venta**. Es el único cliente del portafolio donde eso es cierto.

## Canales

- **WhatsApp Business Cloud** — `+52 55 3135 7396`, número público del negocio. Es el canal
  principal y prácticamente el único.
- **Catálogo web** — `https://tersil-baby-catalog-gl2r.bolt.host/` (hecho con bolt.host). Es a
  donde el agente manda a todo el mundo.
- **Catálogo nativo de WhatsApp** — el negocio subió sus productos al catálogo de WhatsApp,
  pero el agente **no lo lee ni lo usa**. Ver
  [[Catalogo-de-WhatsApp-en-Agentes-de-Make]].
- **Instagram** — `@tersil.mx`, usado como prueba social cuando el cliente desconfía.

## Proyectos

- [[Tersil-Asistente-de-Ventas]] — el agente de WhatsApp que atiende, cotiza y cierra.

## Automatizaciones activas

| Escenario | Qué hace | Estado |
|---|---|---|
| [[Make-Asistente-Tersil-V2]] | el agente conversacional | activo |
| [[Make-Tersil-Seguimiento-10h]] | un recordatorio a las 10 h de silencio | activo |

Apagados: `Asistente Tersil` (9405390, la v1 que mandaba fotos con imgbb) y
`Asistente Tersil V2 - Catalogo PDF` (9628524, intento de mandar el catálogo como PDF, nunca
ejecutado).

## Notas operativas

- **Viven en otra cuenta de Make.** Tersil está en la organización 5601227 / equipo 2904200
  de `eu2.make.com`, no en el equipo 1436402 que documenta [[Fuente-Inventario-Make]]. Ver
  [[Fuente-Cuenta-Make-EU2]].
- **Datos bancarios dentro del prompt.** El `systemPrompt` del agente contiene la CLABE y el
  número de tarjeta de depósito del dueño en texto plano. No se transcriben aquí (regla 5 de
  [[CLAUDE]]). Vale la pena señalarle al cliente que cualquiera con acceso al escenario de Make
  los ve, y que un cambio de cuenta obliga a editar el prompt.
- **Aviso de privacidad implementado en el prompt** (PASO 5), con nombre del responsable y
  correo de contacto, antes de recabar cualquier dato. Es el único agente del portafolio que lo
  hace — patrón a copiar en los demás.
- El bot **se pausa solo** al cerrar la venta y la conversación pasa a humano. La despausa es
  manual y hoy nadie la hace: ver [[Make-Asistente-Tersil-V2#Problemas conocidos]].

## Correlaciones

Comparte patrón con [[Lefranm-Agente-de-Ventas]] y [[Asistente-Chavarria]]
([[Agente-Conversacional-de-WhatsApp]]), pero es la implementación **más simple y más
confiable** de las cuatro: 1.3% de error frente a 7-10% de las otras tres, porque no usa ni una
sola llamada a `transformTextToStructuredData`. Ver
[[Correlacion-de-Proyectos]].
