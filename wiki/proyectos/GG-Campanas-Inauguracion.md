---
titulo: G&G — Campañas de inauguración en Meta Ads
tipo: proyecto
estado: activo
clientes: [GG-Barbers]
tags: [meta-ads, whatsapp, inauguracion]
inicio: 2026-11-05
actualizado: 2026-11-17
---

# G&G — Campañas de inauguración en Meta Ads

> Dar a conocer la barbería y llenar la agenda del 28-nov y las semanas siguientes con
> anuncios cuyo botón abre WhatsApp directo.

## Decisiones tomadas (2026-11-05)

- **Presupuesto aprobado: $300 MXN/día** (+ IVA), recarga prepago desde la app y método de pago.
- Reparto 80/20: **Mensajes a WhatsApp $240/día** + **Alcance $60/día**.
- Radio **5 km** en ambas campañas desde Anaxágoras 905 (ampliado de 3/4 km el 2026-11-05, aún en borrador). Instagram encendido.
- 3 creativos en un solo conjunto: "No es una barbería más", "No es un corte. Es una
  experiencia.", "Tu lugar te espera".
- Mensaje pre-llenado corto (lección de [[Fuente-Reporte-Cierre-Campana-CUT]]: 83% abandona
  si es largo).
- No tocar segmentación a media campaña; el cambio post-apertura se hace con anuncios nuevos.

## Estructura en Meta Ads (publicada 2026-11-05)

Cuenta `2028240577840135`. **Publicadas el 2026-11-05**: campañas ACTIVE, anuncios en revisión de Meta;
entrega desde el **2026-11-05 16:00** (adelantado a petición del cliente; antes 2026-11-06 07:00).

> El anuncio de alcance se rechazó al primer intento por `link_title` obsoleto en el CTA
> (objetivo Reconocimiento); se rehízo el creativo inline sin ese campo y pasó.

| Campaña | ID | Objetivo | Presupuesto | Conjunto |
|---|---|---|---|---|
| G&G \| Inauguración \| Mensajes WhatsApp | `120260302413610112` | Interacción → conversaciones WhatsApp | $240/día (CBO) | `120260302418590112`: 5 km, hombres 20–50 como sugerencia, Advantage+ audiencia y ubicaciones |
| G&G \| Inauguración \| Alcance Narvarte | `120260302525840112` | Reconocimiento → alcance | $60/día (CBO) | `120260302527970112`: 5 km, 18+, máx. 2 impresiones/7 días |

Inicio: 2026-11-05 16:00 (CDMX). Sin fecha de fin.

Anuncios (todos con botón **Enviar mensaje de WhatsApp**):
- "No es una barbería más" — creativo `1585602343374761` (en ambas campañas)
- "No es un corte, es una experiencia" — creativo `2376991489762806`
- "Tu lugar te espera" — creativo `1673905231199435` (v2, sin "solo hay dos sillones"; reemplazó a `28947812128213075` el 2026-11-05)

> [!warning] Pendiente de verificar
> Los 7 objetos del borrador están VALIDATED sin errores (revisado 2026-11-05, ya con el
> WhatsApp vinculado). La validación final ocurre al publicar. El mensaje pre-llenado no se pudo configurar desde la API; se ajusta en
> Ads Manager.

> [!warning] Cuenta con saldo pendiente (2026-11-17)
> La cuenta quedó en estado UNSETTLED (saldo sin pagar) y Meta dejó de entregar anuncios el 16 de
> noviembre. Gasto acumulado del 5 al 16 de noviembre: **$3,224.19**, contra **$2,500** que dio el
> cliente para anuncios (+$724.19). Se cobraba a la tarjeta del humano. El humano pidió pausar y
> limitar a $2,500; por API no se pudo (la cuenta no admite cambios mientras tenga deuda). Al pagar
> el saldo, los anuncios se reactivan solos si no se pausan antes en el Administrador de anuncios.

## Resultados (corte 2026-11-13)

Primeros 9 días, del 5 de noviembre a las 16:00 al 13 de noviembre. Fuente: Meta Ads Manager,
atribución 7 días clic / 1 día vista. Reporte para el cliente: artifact "Campañas G&G Barber's".

| Campaña | Inversión | Alcance | CTR | Costo x mil | Resultado |
|---|---|---|---|---|---|
| Mensajes WhatsApp | $2,002.73 | 8,213 | 4.24% | $106.97 | **93 conversaciones a $21.53** |
| Alcance Narvarte | $491.51 | 70,772 | 0.16% | $5.28 | $6.94 por mil personas |
| Total | $2,494.24 (99.8% de $300/día) | | | | |

- Embudo de mensajes: 8,213 personas → 793 clics → 261 abrieron WhatsApp → 93 escribieron (36%)
  → 41 con 2+ mensajes (44%). En CUT solo escribía el 17% de quienes abrían el chat.
- Por anuncio: "No es una barbería más" 71 conv. a $19.14 (76%); "Tu lugar te espera" 21 a $25.27;
  "No es un corte, es una experiencia" 1 a $112.96 (Meta casi no lo entrega).
- Público: 90 de 93 conversaciones son de hombres; el mejor grupo es hombres 35–44 (34 conv. a $17.67).
- Mejor día: 7 nov, 15 conv. a $15.06. Peores: 5 nov (arranque, $34.71) y 12 nov ($36.57).
- El CPM es 3.5 veces el de CUT ($106.97 contra $30.25), pero el CTR más alto compensa: el costo por
  conversación quedó casi igual ($21.53 contra $20.82).

> [!warning] Inferencia sin verificar
> A ~10 conversaciones diarias, la campaña llegaría a la inauguración con ~240 conversaciones.
> Falta medir cuántas terminan en cita: el dato vive en la tabla `appointments` de la app.

## Capacidad estimada

> [!warning] Inferencia sin verificar
> 2 barberos × ~45 min por servicio ≈ 26 citas en día hábil y ≈ 21 en sábado. A $15–25 por
> conversación, $240/día darían 10–16 conversaciones diarias: la agenda se llena antes por el
> lado de los anuncios que por el de las sillas. El cuello de botella es responder y agendar.

## Pendientes

- ~~Crear cuenta de WhatsApp Business~~ — hecha, estado Conectado (2026-11-05).
- ~~Vincular WhatsApp a la página~~ — hecho 2026-11-05; el formulario de la página solo lo aceptó escrito como **1 55 4786 2032** (con el 1).
- ~~Cuenta de anuncios en MXN dentro del portafolio~~ — `2028240577840135`, con pago e Instagram (2026-11-05).
- ~~Confirmar que el bot esté listo~~ — Dante agenda en la app desde el 2026-11-07; mensaje prellenado actualizado el 2026-11-14.
- Sumar un anuncio con las 6 fotos reales de cortes, sin tocar la segmentación.

## Correlaciones

[[GG-Barbers]] · [[CUT-Captacion-de-Prospectos]] · [[Agente-Conversacional-de-WhatsApp]]
