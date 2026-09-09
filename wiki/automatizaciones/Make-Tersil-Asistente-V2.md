---
titulo: Make · Asistente Tersil V2
tipo: automatizacion
estado: activo
clientes: [Tersil]
tags: [make, whatsapp, datastore, ai-agent, ventas]
actualizado: 2026-09-09
---

# Make · Asistente Tersil V2

Agente de ventas por WhatsApp que atiende el catálogo de [[Tersil]], arma la ficha de pedido,
entrega los datos de pago y luego **se apaga solo** para que un humano cierre.

- **ID de escenario**: 9597789
- **Disparador**: webhook de WhatsApp Business Cloud (4318709), inmediato
- **Modelo**: AI local agent, `gpt-5-mini` (perfil «large»), historial de 30 iteraciones
- **Data stores**: `TERSIL_Seguimiento` (182352), `TERSIL_Pausa_Bot` (174953)

## Métricas (corte 2026-09-09)

| Métrica | Valor |
|---|---|
| Ejecuciones | 866 |
| Operaciones | 3 081 |
| Créditos | ~3 947 |
| Errores | 11 (1.3%) |

Es el agente **más barato por conversación** del portafolio: ~3.6 operaciones por ejecución,
frente a las ~20 de los agentes de Lefranm.

## Estructura

```
1  watchEvents2   WhatsApp                    (webhook)
3  ExistRecord    TERSIL_Pausa_Bot            filtro: solo mensajes de texto
2  RunLocalAIAgent                            filtro: bot no pausado
13 sendMessage    → respuesta al cliente      (recorta el marcador interno)
23 AddRecord      TERSIL_Seguimiento          siembra la cola de seguimiento
21 AddRecord      TERSIL_Pausa_Bot            filtro: la respuesta contiene [FICHA_GENERADA]
22 sendAnEmail    → aviso de pedido al dueño
24 DeleteRecord   TERSIL_Seguimiento          saca al cliente de la cola
```

## Dos mecanismos que vale la pena robar

**El marcador interno.** El prompt pide al agente terminar con `[FICHA_GENERADA]` seguido de la
ficha completa. El escenario parte la respuesta por ese marcador: `first(split(...))` va al
cliente por WhatsApp, `last(split(...))` va al correo del dueño. Un solo campo de texto
transporta el mensaje visible y los datos estructurados, sin una segunda llamada al modelo.

**La autopausa.** Al detectar el marcador, el escenario escribe el número en
`TERSIL_Pausa_Bot`. Como el módulo 3 consulta ese data store en cada mensaje entrante, el bot
deja de responder a ese cliente para siempre. Se reactiva borrando el registro a mano — el
propio correo de aviso explica cómo. Al 2026-09-09 hay **7 conversaciones pausadas**, la más
antigua del 1 de agosto.

## Relación con el seguimiento

El módulo 23 siembra la cola que consume [[Make-Tersil-Seguimiento-23h]], con
`seguimientos: 0` y `ultimo_mensaje = ultimo_seguimiento = now`. El módulo 24 la limpia cuando
el pedido se cierra. Como el consumidor está roto, **la cola solo crece**: ver
[[Diagnostico-Seguimiento-Tersil]].

> [!note] El prompt ya cuenta con el seguimiento
> Las reglas generales del agente le prohíben mandar recordatorios por su cuenta, «porque el
> sistema envía automáticamente los mensajes de seguimiento cada 23 horas». Durante ocho días
> eso fue falso: ni el bot insistía ni el sondeo enviaba.

## Otras versiones

`Asistente Tersil` (9405390, 0 ejecuciones) y `Asistente Tersil V2 - Catalogo PDF` (9628524,
72 ejecuciones) están **inactivos**. La V1 usaba imgbb para subir fotos producto por producto;
la V2 lo sustituyó por un único link de catálogo. Ver [[Escenarios-Inactivos]].

## Correlaciones

Cuarta implementación viva de [[Agente-Conversacional-de-WhatsApp]] y la única que se autopausa
al cerrar la venta. Usa Data Store, no Airtable: ver
[[Persistencia-Airtable-vs-Data-Store]].
