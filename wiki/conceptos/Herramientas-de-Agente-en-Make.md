---
titulo: Herramientas de agente en Make (lecciones)
tipo: concepto
estado: activo
tags: [make, agente-ia, patron, depuracion]
actualizado: 2026-11-07
---

# Herramientas de agente en Make (lecciones)

> Lo que costó una noche descubrir al armar [[Make-GyG-Asistente-Dante]] por API.

## Reglas

1. **Una herramienta = un solo módulo.** Para varios pasos, usar `scenario-service:CallSubscenario`
   con un subescenario (`StartSubscenario` → … → `ReturnData`).
2. **Make solo le pasa datos al agente si el módulo declara sus campos** (`metadata.expect`).
   Los módulos creados desde la UI lo traen; los creados por API no. Sin eso, los `{{3.campo}}`
   llegan **vacíos** aunque la ejecución diga "SUCCESS".
3. **Los datos van en campos exactos** (`{{3.fecha}}`), no dentro de un JSON armado a mano ni
   envueltos en funciones.
4. **`ReturnData` debe usar la salida `tool_output` (dynamicCollection)**, como en Lefranm; con
   una salida de texto propia el agente recibe vacío.
5. **El módulo HTTP valida el cuerpo JSON antes de ejecutar**: un campo que sea solo
   `{{3.x}}` rompe la inicialización del escenario y lo apaga.
6. **La memoria del agente "aprende" las fallas**: tras arreglar, cambiar el `threadId` para
   empezar limpio.

## Cómo depurar

`executions_get-detail` no muestra el interior del agente. Lo que funcionó: un data store de
registro dentro del subescenario y un escenario de prueba con el agente en modo *on-demand*,
que permite iterar sin WhatsApp.

## Correlaciones

Aplica a todo [[Agente-Conversacional-de-WhatsApp]]. [[Make-Lefranm-Citas]] funciona porque sus
herramientas se armaron en la UI.
