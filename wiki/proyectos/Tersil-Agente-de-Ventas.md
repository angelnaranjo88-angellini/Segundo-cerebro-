---
titulo: Tersil — Agente de ventas por WhatsApp
tipo: proyecto
estado: activo
clientes: [Tersil]
tags: [make, whatsapp, ecommerce, ai-agent, seguimiento]
actualizado: 2026-09-09
---

# Tersil — Agente de ventas por WhatsApp

Embudo completo de venta de ropa de bebé dentro de WhatsApp: el agente atiende, muestra
catálogo, arma la ficha de pedido, entrega datos de pago, avisa al dueño por correo y se apaga
para que un humano cobre. Un sondeo paralelo persigue a quien deja de responder.

```
Cliente escribe → [[Make-Tersil-Asistente-V2]] → ficha + datos de pago
                            ↓                            ↓
                  TERSIL_Seguimiento          correo al dueño + autopausa
                            ↓
                  [[Make-Tersil-Seguimiento-23h]]  ← roto desde el día uno
```

## Estado al 2026-09-09

| Pieza | Estado |
|---|---|
| Agente de ventas | Funcionando. 866 ejecuciones, 1.3% de error |
| Catálogo digital | Publicado en bolt.host, fuera de Make |
| Autopausa al cerrar | Funcionando. 7 conversaciones pausadas |
| Aviso de pedido por correo | Funcionando |
| Seguimiento a 23/46/69 h | **Roto**. Cero mensajes en 381 corridas |

## El problema abierto

El seguimiento nunca ha funcionado. Diagnóstico completo en
[[Diagnostico-Seguimiento-Tersil]]: los filtros del router leen `{{1.seguimientos}}` cuando el
módulo de búsqueda entrega los campos bajo `{{1.data.seguimientos}}`, así que ninguna ruta se
cumple y el escenario reporta éxito sin enviar nada.

Hay 59 conversaciones acumuladas en la cola que nunca recibieron su recordatorio. **No se
puede saber cuántas de esas ventas se perdieron por falta de seguimiento**, pero el agente
tiene prohibido insistir por su cuenta precisamente porque el sondeo debía hacerlo.

## Decisiones pendientes

1. Si los seguimientos 2 y 3 se convierten en plantillas aprobadas por Meta, o se elimina el
   flujo y queda un único recordatorio a las 23 h.
2. Qué hacer con la cola acumulada antes de reactivar (ver la advertencia del diagnóstico).
3. Si la autopausa debe expirar sola: hoy es permanente y ya hay registros de hace cinco
   semanas que quizá deberían volver al bot.

## Correlaciones

Mismo patrón que [[Lefranm-Agente-de-Ventas]] —agente de catálogo por WhatsApp— pero con
cierre de venta y datos de pago dentro del chat, cosa que ningún otro proyecto hace. Comparte
el sondeo de [[Seguimiento-por-Sondeo]] con [[CUT-Captacion-de-Prospectos]]. Ver
[[Correlacion-de-Proyectos]].
