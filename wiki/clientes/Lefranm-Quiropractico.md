---
titulo: Lefranm Quiropráctico
tipo: cliente
estado: activo
tags: [quiropractica, cosmetica, estetica, iztapalapa, cdmx]
actualizado: 2026-09-08
---

# Lefranm Quiropráctico

> Negocio de salud y bienestar en Iztapalapa, CDMX. Vende cosmética profesional a
> cosmetólogas y estéticas, **y** presta servicios con cita.
>
> Hasta el 2026-09-08 esta página se llamaba *Lefranm Cosméticos*: el nombre salió del
> catálogo, que fue la primera fuente ingerida. El dueño confirma que el nombre comercial
> real es **Lefranm Quiropráctico**. La página anterior queda como
> [[Lefranm-Cosmeticos]] (archivada, solo redirige).

## Contexto del negocio

Dos líneas de ingreso en el mismo canal de WhatsApp, y esa es la razón de que existan dos
agentes separados:

1. **Venta de producto** — catálogo de ~52 SKUs (`Lf-001` a `Lf-052`) en líneas de limpieza,
   anti-edad, hidratación, protección solar, exfoliantes, corporales y producto de cabina.
   Rango de precio observado: $65 – $589 MXN. Productos registrados ante COFEPRIS
   (registro `2409165018X00154`).
2. **Servicios con cita** — reductivo, microdermoabrasión, presoterapia, spa de manos.

## Canales

| Canal | Dato |
|---|---|
| WhatsApp / teléfono | +52 55 74 99 40 10 |
| Correo | lefranm.ok@gmail.com |
| Domicilio | Av. Tláhuac #4746, local 13, Col. Granjas Estrella, C.P. 09880, Iztapalapa, CDMX |

Fuente del catálogo: `Lista-de-Precios-Cosmetologas-y-Esteticas.pdf` en Drive
(carpeta `Lefran`) — ver [[Fuente-Catalogo-Lefranm]].

## Proyectos

- [[Lefranm-Agente-de-Ventas]] — atención y venta de catálogo por WhatsApp.
- [[Lefranm-Agendamiento-de-Citas]] — reserva, consulta, cancelación y reprogramación de citas.

## Automatizaciones activas

- [[Make-Lefranm-Citas]]
- [[Make-Lefranm-Cosmeticos-Ventas]]
- [[Make-Lefranm-Seguimiento-Citas]]
- [[Make-Lefranm-Seguimiento-Cosmeticos]]

## Notas operativas

> [!warning] La línea de quiropráctica no tiene fuente ingerida
> El nombre del negocio está confirmado por el dueño (2026-09-08), pero **todo lo documentado
> aquí sigue siendo cosmética y estética**: el catálogo de ~52 SKUs, el registro COFEPRIS y
> los servicios de cabina (reductivo, microdermoabrasión, presoterapia, spa de manos).
> Ninguna fuente describe todavía el servicio de quiropráctica ni si los agentes de WhatsApp
> lo atienden. Falta ingerirlo: si la quiropráctica es la línea principal del negocio, el
> [[Lefranm-Agendamiento-de-Citas]] probablemente esté agendando algo que el wiki no sabe
> nombrar.

- Es el cliente **más caro con diferencia**: ~90% del consumo de créditos de Make del entorno
  completo (corte 2026-09-05). Ver [[Riesgos-y-Deuda-Tecnica]].
- Existen además cinco herramientas MCP publicadas desde Make para este cliente
  (`revisar_disponibilidad`, `agendar_cita`, `buscar_cita`, `cancelar_cita`,
  `reprogramar_cita`), lo que convierte el agendamiento en un servicio consultable desde fuera
  de Make. Es el proyecto más maduro del portafolio.

## Correlaciones

Ver [[Correlacion-de-Proyectos]]. El agendamiento de Lefranm es la versión **evolucionada** de
lo que en [[Colegio-Maria-Chavarria-Vital]] todavía es un módulo `createAnEvent` simple.
