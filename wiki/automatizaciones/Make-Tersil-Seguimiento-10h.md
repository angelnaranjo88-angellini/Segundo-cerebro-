---
titulo: Make · Tersil — Seguimiento 10 h
tipo: automatizacion
estado: activo
clientes: [Tersil]
tags: [make, whatsapp, datastore, seguimiento]
actualizado: 2026-09-09
---

# Make · Tersil — Seguimiento 10 h

Un único recordatorio por WhatsApp a las **10 horas** de que el cliente dejó de responder.
Reescrito el 2026-09-09 tras [[Diagnostico-Seguimiento-Tersil]]: hasta esa fecha se llamaba
«Seguimiento 23 h», intentaba tres envíos y no mandó ni uno en 381 corridas.

- **ID de escenario**: 9738949
- **Programación**: `indefinitely`, cada 1800 s (48 corridas/día)
- **Data stores**: `TERSIL_Seguimiento` (182352), `TERSIL_Pausa_Bot` (174953)
- **Remitente**: WhatsApp Business Cloud, `604043842799894`

## Estructura

```
1  SearchRecord  TERSIL_Seguimiento   telefono existe
                                      ultimo_mensaje < now-10h   ← ya pasaron 10 h
                                      ultimo_mensaje > now-24h   ← guardarraíl de ventana
                                      seguimientos   < 1         ← candado antidoble
2  ExistRecord   TERSIL_Pausa_Bot     key = {{1.key}}
5  sendMessage   → {{1.data.telefono}}       filtro: {{2.exist}} ≠ true
                  onerror: Break (3 reintentos cada 15 min)
4  UpdateRecord  seguimientos = 1, ultimo_seguimiento = now
```

Sin router: una sola ruta, un solo mensaje.

## Las cuatro decisiones de diseño

**El prefijo `data`.** `SearchRecord` entrega los campos anidados: `{{1.data.telefono}}`,
`{{1.data.nombre}}`. Solo `{{1.key}}` vive en la raíz. Confundirlos fue el fallo original.

**El guardarraíl de las 24 h.** El filtro no solo exige que hayan pasado 10 horas, también que
**no hayan pasado 24**. Fuera de esa ventana WhatsApp rechaza el texto libre, así que un
registro que se pase de las 24 h nunca se intenta: no se quema reputación del número con
envíos que Meta va a rechazar. Efecto secundario útil: al reactivar el escenario, los 54
registros viejos represados desde el 1 de septiembre quedaron excluidos solos, sin purga
manual.

**Enviar antes de marcar.** El `sendMessage` corre antes del `UpdateRecord`. Si el envío falla,
el contador no sube y el registro sigue disponible para el reintento. El orden inverso —el que
tenía— daba por enviado lo que nunca salió.

**`Break` en vez de `Ignore`.** El manejador reintenta 3 veces cada 15 minutos y, si falla,
deja el bundle en **ejecuciones incompletas**: visible y reintentable. El `Ignore` anterior
descartaba los rechazos de Meta en silencio, que es la razón de que el escenario luciera sano.
Requiere `dlq: true` en el escenario, ya activado.

## Qué esperar

Un registro entra a la cola cuando el cliente escribe ([[Make-Tersil-Asistente-V2]], módulo 23)
y sale cuando cierra pedido (módulo 24). Si calla, recibe **un** mensaje entre las 10 y las 24
horas y queda marcado con `seguimientos: 1`. Si vuelve a escribir, el asistente sobrescribe su
registro con `seguimientos: 0` y el ciclo puede repetirse.

Los registros marcados se quedan en el data store como histórico de a quién se persiguió y
cuándo. No cuestan operaciones —el filtro los excluye en el servidor— pero conviene depurarlos
de vez en cuando: el límite del data store es 1 MB y 59 registros ocupan ~10 KB.

## Métricas

| Corte | Ejecuciones | Operaciones | Errores | Mensajes |
|---|---|---|---|---|
| 2026-09-09, antes del arreglo | 381 | 9 321 | 0 | **0** |
| 2026-09-09, tras el arreglo | — | — | — | pendiente de primera corrida |

> [!warning] Métrica sin verificar
> El arreglo se aplicó a las 17:28 UTC del 2026-09-09. La primera corrida posterior tenía 5
> registros dentro de la ventana de 10–24 h. **Falta confirmar el envío real** en el historial
> de ejecuciones y actualizar esta tabla.

## Correlaciones

Cuarta implementación de [[Seguimiento-por-Sondeo]] y la primera que documentó los fallos del
patrón. Comparte almacén con [[Make-Lefranm-Seguimiento-Citas]]. Ver [[Tersil-Agente-de-Ventas]]
y [[Riesgos-y-Deuda-Tecnica]].
