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
                  [[Make-Tersil-Seguimiento-10h]]  ← reparado el 2026-09-09
```

## Estado al 2026-09-09

| Pieza | Estado |
|---|---|
| Agente de ventas | Funcionando. 866 ejecuciones, 1.3% de error |
| Catálogo digital | Publicado en bolt.host, fuera de Make |
| Autopausa al cerrar | Funcionando. 7 conversaciones pausadas |
| Aviso de pedido por correo | Funcionando |
| Seguimiento único a 10 h | Reparado el 2026-09-09. 5 mensajes en la primera corrida |

## El problema que estuvo abierto ocho días

El seguimiento nunca funcionó desde su creación. Diagnóstico completo en
[[Diagnostico-Seguimiento-Tersil]]. Reparado el 2026-09-09: **un solo recordatorio a las 10
horas**, con guardarraíl de ventana, orden de envío corregido y errores visibles.

Se perdieron los recordatorios de **54 conversaciones** entre el 1 y el 8 de septiembre. No se
puede saber cuántas ventas costó, pero el agente tiene prohibido insistir por su cuenta
precisamente porque el sondeo debía hacerlo, así que esos clientes no recibieron nada de nadie.

## Decisiones pendientes

1. Actualizar la línea del prompt de [[Make-Tersil-Asistente-V2]] que aún dice «cada 23 horas».
2. Depurar los 54 registros viejos que quedaron represados y ya no recibirán nada.
3. Si la autopausa debe expirar sola: hoy es permanente y ya hay registros de hace cinco
   semanas que quizá deberían volver al bot.

## Correlaciones

Mismo patrón que [[Lefranm-Agente-de-Ventas]] —agente de catálogo por WhatsApp— pero con
cierre de venta y datos de pago dentro del chat, cosa que ningún otro proyecto hace. Comparte
el sondeo de [[Seguimiento-por-Sondeo]] con [[CUT-Captacion-de-Prospectos]]. Ver
[[Correlacion-de-Proyectos]].
