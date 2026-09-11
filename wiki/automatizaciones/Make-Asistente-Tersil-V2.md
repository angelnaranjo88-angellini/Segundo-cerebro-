---
titulo: Make · Asistente Tersil V2
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 9597789
clientes: [Tersil]
tags: [whatsapp, agente-ia, datastore, ventas]
actualizado: 2026-09-11
---

# Make · Asistente Tersil V2

> Ocho módulos: recibe el mensaje, contesta con un agente, registra al contacto para
> seguimiento y —si cerró la venta— avisa al dueño y se apaga para ese número.

Equipo 2904200 (`eu2.make.com`). Creado 2026-07-30, última edición 2026-09-01.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato, hook 4318709. Conexión
`TERSIL (Tersil)`, número emisor `+52 1 55 3135 7396`.

## Flujo

1. `whatsapp-business-cloud · watchEvents2` — entra el mensaje.
2. `datastore · ExistRecord` sobre `TERSIL_Pausa_Bot` (174953) — ¿el bot está pausado para este
   número? **Aquí vive el filtro `Solo mensajes de texto`:
   `{{1.messages[].text.body}}` debe existir.**
3. `ai-local-agent · RunLocalAIAgent` — el agente. Filtro `Bot activo (no pausado)`
   (`{{3.exist}} ≠ true`). Modelo `large` (gpt-5-mini, reasoning low), memoria por
   `threadId = wa_id`, 30 turnos de historial, conexión de IA `tersil`.
4. `whatsapp-business-cloud · sendMessage` — manda al cliente
   `first(split(2.response; "[FICHA_GENERADA]"))`, o sea todo lo anterior al marcador.
5. `datastore · AddRecord` sobre `TERSIL_Seguimiento` (182352), `overwrite: true` — reinicia el
   reloj de seguimiento en cada mensaje.
6. `datastore · AddRecord` sobre `TERSIL_Pausa_Bot` — **pausa el bot**. Filtro
   `Fin del PASO 8`: `{{2.response}}` contiene `[FICHA_GENERADA]`.
7. `google-email · sendAnEmail` — correo al dueño con la ficha de compra
   (`last(split(...))`), el último mensaje enviado y las instrucciones para despausar.
8. `datastore · DeleteRecord` sobre `TERSIL_Seguimiento` — lo saca de la cola de seguimiento.

Sin routers. Una sola rama, con tres filtros que la cortan en distintos puntos.

## Persistencia

Solo Data Store, dos tablas: `TERSIL_Seguimiento` (cola, con `nombre`, `telefono`,
`ultimo_mensaje`, `ultimo_seguimiento`, `seguimientos`) y `TERSIL_Pausa_Bot` (candado por
número). **Sin Airtable.** Es el único agente del portafolio que no lo usa — ver
[[Persistencia-Airtable-vs-Data-Store]].

Nota: no hay base de datos de pedidos. El pedido existe únicamente como texto dentro de un
correo. Si se borra el correo, se borró el pedido.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 838 | 2026-09-11 |
| Operaciones | 2 981 (3.6 por ejecución) | 2026-09-11 |
| Errores | 11 (1.3%) | 2026-09-11 |
| Créditos | ~3 812 | 2026-09-11 |
| Transferencia | ~14.0 MB | 2026-09-11 |

La ruta feliz consume **5 operaciones**. Las corridas de **1 operación** son mensajes
bloqueados por el filtro de texto; las de más de 5, ventas cerradas.

## Problemas conocidos

- **El filtro `Solo mensajes de texto` es un agujero de silencio.** Todo lo que no sea texto
  plano —carritos del catálogo de WhatsApp (`type: order`), fotos de comprobante, audios,
  stickers, ubicaciones— muere en el módulo 2 sin respuesta y **sin registrarse para
  seguimiento**. Diagnóstico completo:
  [[Catalogo-de-WhatsApp-en-Agentes-de-Make]].
- **Efecto secundario cruel**: como el módulo 5 tampoco corre, un cliente que solo manda un
  carrito no actualiza su `ultimo_mensaje`. Si su último texto fue hace 11 horas, lo que recibe
  a cambio es el recordatorio automático de [[Make-Tersil-Seguimiento-10h]] preguntándole si ya
  vio los modelitos. Es decir: manda su pedido y el sistema le contesta como si no hubiera
  escrito nada.
- **Pausas permanentes.** `TERSIL_Pausa_Bot` tiene 7 números pausados entre el 2026-08-01 y el
  2026-08-21, ninguno reactivado. No hay proceso ni escenario de despausa: hay que borrar el
  registro a mano. Cualquier prueba hecha con uno de esos números parece un bot roto.
- **Un solo `maxErrors: 3`** y sin DLQ (`dlq: false`), a diferencia del seguimiento.
- **Datos bancarios en el `systemPrompt`** — ver [[Tersil#Notas operativas]].
- El nombre del emisor está cableado por id (`604043842799894`) en dos módulos.

## Correlaciones

Proyecto: [[Tersil-Asistente-de-Ventas]]. Cliente: [[Tersil]]. Patrón:
[[Agente-Conversacional-de-WhatsApp]]. Complemento:
[[Make-Tersil-Seguimiento-10h]]. Fuente: [[Fuente-Cuenta-Make-EU2]].

Es el primo simplificado de [[Make-Lefranm-Cosmeticos-Ventas]]: mismo negocio (vender catálogo
por WhatsApp), 8 módulos contra 22, y una octava parte de la tasa de error.
