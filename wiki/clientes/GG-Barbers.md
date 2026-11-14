---
titulo: G&G Barber’s
tipo: cliente
estado: activo
tags: [barberia, narvarte, cdmx, marca, redes-sociales, meta-ads, whatsapp, supabase, make]
actualizado: 2026-11-14
---

# G&G Barber’s

> Barbería VIP de un amigo en Narvarte Poniente (Anaxágoras 905, a una cuadra del metro Eugenia).
> Inaugura el **sábado 28 de noviembre de 2026**. Marca madre **G&G** con dos submarcas:
> **G&G Barber’s** (la barbería) y **G&G Essentials** (la línea de productos).

> [!note] Página unificada (2026-11-14)
> El trabajo de G&G vivía en tres ramas sin unir, con dos fichas de cliente: `GG-Barbers` y
> `GyG-Barbers`. Esta es la ficha vigente; [[GyG-Barbers]] queda archivada y apunta aquí.

## Datos del negocio

| Dato | Valor |
|---|---|
| Domicilio | Anaxágoras 905, Narvarte Poniente, Benito Juárez, 03020, CDMX |
| Horario | L–V 9:00–19:00 · sábado 9:00–17:00 · domingo cerrado |
| Barberos | 2 al arranque (el cliente elige hora, no barbero) |
| Pagos | Efectivo, transferencia, todas las tarjetas; sin factura |
| WhatsApp del negocio | 55 4786 2032 (Cloud API, conexión Make 12162330). En el formulario de la página de Facebook se escribe con el 1: 1 55 4786 2032 |
| Facebook | Página `1451464018039847` |
| Instagram | @ggbarbers.mx (`17841473644530734`), ligado a la página y a la cuenta de anuncios |
| Meta Ads | `2028240577840135` "G&G Barber's – Ads" (MXN, portafolio "Gabriel Barber" `4736981739857405`). Ignorar la vieja en USD `1645960426970922` |

> [!warning] Contradicción sin resolver
> El nombre de la página de Facebook aparece como "G&G Barber's" en [[Make-GG-Publicacion-Automatica]]
> y como "Gabriel Barberia" en la ficha que venía de la rama del asistente. Confirmar en Meta cuál es
> el nombre visible hoy.

## Servicios (corte 2026-11-07)

| Servicio | Precio | Duración |
|---|---|---|
| Corte de cabello | $350 | 45 min |
| Arreglo express de barba | $150 | 15 min |
| Arreglo de barba tradicional | $350 | 30 min |
| Arreglo de barba premium | $500 | 45 min |
| Arreglo de ceja | $100 | 15 min |
| Depilación oídos y nariz | $150 | 15 min |
| Depilación nariz / oídos | $100 c/u | 15 min |

La fuente de verdad de precios y duraciones es la tabla `services` de la app, no esta página.
Origen de la lista: [[Fuente-Logos-y-Precios-GG]].

**Reglas de citas:** tolerancia 10 min · cambios o cancelaciones hasta 2 h antes · agenda hasta
30 días · clientes sin cita si hay barbero libre · corte de niño al mismo precio.

## Posicionamiento

Definido por el dueño (2026-10-31): **barbería VIP**. Servicio premium, de confort y alta calidad.
Voz de marca: "exclusividad con oficio", segura y sobria. Sin promoción de inauguración ni beneficio
por flyer (2026-11-03): el gancho es la exclusividad.

Frases del dueño (2026-11-03): "El arte de verte bien, el lujo de sentirte único", "La elegancia
comienza con una experiencia", "Redefinimos el arte del cuidado masculino", "La excelencia no se
improvisa, se trabaja con precisión", "No seguimos tendencias, creamos identidad". Claude agregó 15
más; viven en el calendario v2 de [[GG-Barbers-Lanzamiento-Redes]].

Identidad: negro, plata y blanco; Cinzel + Libre Franklin. **Cada submarca conserva su plata**:
Barber’s cálida `#A9A199`, Essentials cromo frío `#BDBAB6`. Essentials comparte redes con la barbería.

## Proyectos

| Proyecto | Qué entrega |
|---|---|
| [[GG-Barbers-Lanzamiento-Redes]] | Kit de marca, perfiles de FB e IG, calendario de 56 publicaciones |
| [[GG-Campanas-Inauguracion]] | Campañas de Meta Ads a WhatsApp para la apertura |
| [[GyG-Barbers-App-y-Asistente]] | App de gestión (Bolt + Supabase) y asistente Dante |

## Automatizaciones activas

| Escenario | Qué hace |
|---|---|
| [[Make-GG-Publicacion-Automatica]] (6885366) | Publica en FB e IG desde la hoja "G&G Barbers" |
| [[Make-GyG-Asistente-Dante]] (6914875) | Agente de WhatsApp que agenda en la app |
| Recordatorios (7033720) | Diario 10:00, plantilla `recordatorio_cita` a las citas de mañana; sin página propia todavía |

## Comercial

Cotización vigente **GG-2026-002** (2026-11-14), en Claude Docs y en versión de presentación con la
marca Chaos Ctrl. Sustituye a la GG-2026-001 ($12,800, 2026-10-28).

| Concepto | MXN |
|---|---|
| Pago único: marca y redes $5,100 · contenido $4,500 · app e integración $8,500 · asistente $4,000 · campañas $4,000 | $26,100 |
| Pagado por el cliente | $20,000 |
| **Saldo pendiente** (trabajo agregado después del primer acuerdo) | **$6,100** |
| Mensualidad: asistente $1,500 + app $1,500 | $3,000 al mes |
| Opcional: calendario de 30 publicaciones al mes (publicación automática de cortesía) | $2,500 al mes |

- Cortesías mostradas con su valor tachado: vectores, 10 propuestas, íconos, papelería y toldo ($6,700).
- Las mensualidades corren desde el 2026-11-01 y se pagan mes vencido; la primera, el **2026-12-01**.
- La gestión de campañas es pago único; la inversión en anuncios la paga el cliente aparte.
- El cliente es un amigo: la versión "ligera" de precios fue decisión del humano.

## Correlaciones

- Mismo embudo que [[CUT-Captacion-de-Prospectos]] (anuncio → WhatsApp → agente), con cuentas
  nuevas. Benchmarks de partida en [[Fuente-Reporte-Cierre-Campana-CUT]].
- El asistente reutiliza el patrón de [[Lefranm-Agendamiento-de-Citas]], pero con base propia en
  Supabase en lugar de [[Agendamiento-con-Google-Calendar]].
- La publicación orgánica repite el [[Pipeline-de-Contenido-Social]] de [[CUT-Contenido-Social]],
  sin la capa de IA que concentraba los errores.
