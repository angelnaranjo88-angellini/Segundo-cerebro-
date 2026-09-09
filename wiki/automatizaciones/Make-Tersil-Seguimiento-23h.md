---
titulo: Make · Tersil — Seguimiento 23 h
tipo: automatizacion
estado: activo
clientes: [Tersil]
tags: [make, whatsapp, datastore, seguimiento, roto]
actualizado: 2026-09-09
---

# Make · Tersil — Seguimiento 23 h

> [!bug] Activo pero sin efecto
> Corre cada 30 minutos desde el 2026-09-01, reporta **éxito en las 381 ejecuciones** y
> **nunca ha enviado un solo mensaje**. Causa raíz en [[Diagnostico-Seguimiento-Tersil]].

- **ID de escenario**: 9738949
- **Programación**: `indefinitely`, cada 1800 s (48 corridas/día)
- **Data stores**: `TERSIL_Seguimiento` (182352), `TERSIL_Pausa_Bot` (174953)
- **Conexión de envío**: WhatsApp Business Cloud, remitente `604043842799894`

## Métricas (corte 2026-09-09)

| Métrica | Valor |
|---|---|
| Ejecuciones | 381 |
| Operaciones | 9 321 |
| Créditos | ~9 321 |
| Errores reportados | 0 |
| Mensajes enviados | **0** |

Las operaciones por corrida crecen de forma monótona (42 → 51 entre el 8 y el 9 de septiembre)
porque el data store solo acumula: ningún registro se actualiza ni se borra jamás.

## Estructura

```
1  SearchRecord  TERSIL_Seguimiento   filtro: telefono existe
                                              ultimo_mensaje     < now-23h
                                              ultimo_seguimiento < now-23h
                                              seguimientos       < 3
2  ExistRecord   TERSIL_Pausa_Bot     key = {{1.key}}
3  Router
   ├── Ruta 1  "Seguimiento 1 (23 h)"   → UpdateRecord (seguimientos=1) → sendMessage
   ├── Ruta 2  "Seguimiento 2 (46 h)"   → UpdateRecord (seguimientos=2) → sendMessage
   └── Ruta 3  "Seguimiento 3 (69 h)"   → DeleteRecord                  → sendMessage
```

Los tres `sendMessage` llevan `Ignore` como manejador de error.

## Cómo se siembra la cola

[[Make-Tersil-Asistente-V2]] escribe un registro por cada conversación entrante con
`seguimientos: 0` y `ultimo_mensaje = ultimo_seguimiento = now`, y lo **borra** cuando el
cliente cierra el pedido. Este escenario es el consumidor de esa cola.

## Fallos

Ver el diagnóstico completo y los cuatro defectos encontrados en
[[Diagnostico-Seguimiento-Tersil]]. En resumen:

1. **Bloqueante**: los filtros del router leen `{{1.seguimientos}}`, que siempre está vacío.
2. La ventana de 24 h de WhatsApp invalida los seguimientos 2 y 3 aunque se arregle el 1.
3. Los `Ignore` ocultan cualquier rechazo de Meta; el «0 errores» no significa nada.
4. Se marca el contador **antes** de enviar, así que un envío fallido se pierde sin rastro.

## Correlaciones

Es la cuarta implementación de [[Seguimiento-por-Sondeo]] y la primera que falla — el concepto
decía «ningún fallo observado» y hay que corregirlo. Comparte almacén (Data Store) con
[[Make-Lefranm-Seguimiento-Citas]], que sí funciona. Ver [[Riesgos-y-Deuda-Tecnica]].
