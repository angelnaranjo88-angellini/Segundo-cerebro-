---
titulo: Agente conversacional de WhatsApp
tipo: concepto
estado: activo
tags: [patron, whatsapp, agente-ia, make]
actualizado: 2026-09-05
---

# Agente conversacional de WhatsApp

> El patrón central del portafolio. Lo has implementado **tres veces en producción** y otras
> cuatro en prototipos abandonados.

## El patrón

```
watchEvents2 (WhatsApp)
   → [recuperar estado: GetRecord + Resume]
   → RunLocalAIAgent  (decide la intención)
   → transformTextToStructuredData  (normaliza los datos)
   → [acción de negocio: Calendar / Airtable / Data Store]
   → BasicRouter  (bifurca por resultado)
   → sendMessage (WhatsApp)  +  sendAnEmail (aviso interno)
   → persistir
```

La pieza que lo hace funcionar es `RunLocalAIAgent`: en las tres implementaciones vivas
sustituyó a las cadenas de `messageAssistantAdvanced` y `CreateCompletion` de los prototipos
de 2025-2026. Menos módulos, menos puntos de fallo, decisión centralizada.

## Dónde lo uso

| Implementación | Módulos | Ops/ejec. | Error | Estado |
|---|---|---|---|---|
| [[Make-Lefranm-Citas]] | 20 | 6.9 | 7.6% | El más completo |
| [[Make-Lefranm-Cosmeticos-Ventas]] | 22 | 8.4 | 10.1% | El más largo y frágil |
| [[Make-Asistente-Chavarria]] | 15 | 5.0 | 7.1% | El más eficiente |

Prototipos apagados que lo intentaron: `Agendamiento` (3678657), `air table` (3620443),
`Integration WhatsApp Business Cloud` (4535198). Ver [[Escenarios-Inactivos]].

## Variantes y cuándo elegir cada una

- **Con memoria de conversación** (`GetRecord` + `Resume`): Lefranm ×2. Necesaria cuando el
  flujo pide varios datos en turnos distintos (fecha, hora, servicio).
- **Sin memoria**: [[Make-Asistente-Chavarria]]. Válido si cada mensaje se resuelve solo, pero
  hoy es una limitación, no una decisión.
- **Una extracción vs. cuatro**: Chavarría usa una; Lefranm-Ventas usa cuatro y tiene 40% más
  error relativo. La correlación es sugerente, no probada.

## Fallos típicos

Los tres agentes fallan entre 7% y 10% de las veces, mientras que los tres sondeos sin IA del
mismo entorno fallan entre 0% y 0.65%. **La fragilidad está en la capa de IA, no en Make ni en
WhatsApp.** Ese es el hallazgo más accionable del wiki. Ver [[Riesgos-y-Deuda-Tecnica]].

## Correlaciones

[[Seguimiento-por-Sondeo]] es su complemento obligatorio: el agente siembra, el sondeo cosecha.
[[Correlacion-de-Proyectos]].
