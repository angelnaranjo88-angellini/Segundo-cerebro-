---
titulo: Riesgos y deuda técnica
tipo: sintesis
estado: activo
tags: [sintesis, riesgos, costos, errores]
actualizado: 2026-09-05
---

# Riesgos y deuda técnica

> **La pregunta**: ¿dónde se está yendo el dinero, qué se está rompiendo y qué pasa si algo
> falla?

Corte: 2026-09-05.

## Respuesta corta

Un solo escenario consume el 58% de tus créditos. La capa de IA concentra el 88.6% del gasto y
el 96% de los errores. Y los 7 escenarios que sostienen tu negocio existen en un solo lugar,
sin copia de seguridad ni control de versiones.

## 1. Concentración de costo

| Escenario | Créditos | % del total |
|---|---|---|
| [[Make-Lefranm-Citas]] | ~20 624 | **57.8%** |
| [[Make-Lefranm-Cosmeticos-Ventas]] | ~8 315 | 23.3% |
| [[Make-Asistente-Chavarria]] | ~2 662 | 7.5% |
| [[Make-Lefranm-Seguimiento-Cosmeticos]] | ~1 712 | 4.8% |
| [[Make-Lefranm-Seguimiento-Citas]] | ~1 695 | 4.8% |
| [[Make-CUT-Seguimiento-Prospectos]] | ~595 | 1.7% |
| [[Make-CUT-Creacion-de-Contenido-Sheets]] | ~63 | 0.2% |
| **Total** | **~35 677** | 100% |

Por cliente: **[[Lefranm-Quiropractico]] 90.7%**, [[Colegio-Maria-Chavarria-Vital]] 9.3%.

**El riesgo**: si Lefranm se va, el 90% del consumo se apaga de golpe — y con él, casi todo lo
que has aprendido en producción. Toda tu operación depende de un cliente.

## 2. Concentración de errores

| Familia | Ejecuciones | Errores | Tasa |
|---|---|---|---|
| Agentes con IA | 2 987 | 244 | 8.2% |
| Contenido con visión | 13 | 6 | **46.2%** |
| Sondeos sin IA | 3 079 | 3 | 0.1% |
| **Total activo** | **6 079** | **253** | **4.2%** |

**El hallazgo**: 250 de los 253 errores están en escenarios que llaman a un modelo. Los tres
escenarios sin IA suman 3 errores en 3 079 ejecuciones. No es Make, no es WhatsApp, no es
Airtable: es la capa de IA, y es la misma capa que se lleva el 88.6% del gasto.

**Prioridad de diagnóstico**:

1. [[Make-CUT-Creacion-de-Contenido-Sheets]] — 46% de fallo. La hipótesis más probable es que
   las URLs de Drive tipo `/view?usp=sharing` no son descargas directas y `ActionGetFile`
   recibe HTML en vez de imagen. Barato de comprobar.
2. [[Make-Lefranm-Cosmeticos-Ventas]] — 10.1% con 78 errores acumulados y cuatro extracciones
   estructuradas encadenadas.
3. [[Make-Lefranm-Citas]] — 141 errores, el mayor volumen absoluto y el escenario más caro.

## 3. Sin copia de seguridad del activo principal

Los 7 escenarios vivos existen **únicamente dentro de Make**. No hay blueprints exportados, no
hay control de versiones, no hay forma de responder "¿qué cambió el 4 de septiembre?" ni de
restaurar una versión anterior tras una edición equivocada.

Es la deuda más barata de pagar y la más cara de ignorar: exportar los JSON a
`fuentes-crudas/make/` cuesta una sesión.

## 4. Gasto que corre sin producir

- [[Make-CUT-Seguimiento-Prospectos]]: 48 ejecuciones diarias, indefinidamente. La campaña de
  inscripciones **cerró el 4 de septiembre de 2026**. Sin prospectos que perseguir, es gasto
  puro hasta la próxima campaña.
- Dos sondeos paralelos en Lefranm haciendo lo mismo sobre dos almacenes distintos
  (~3 407 créditos) por la divergencia de [[Persistencia-Airtable-vs-Data-Store]].

## 5. Deuda de higiene

- **15 escenarios apagados**, 14 con cero ejecuciones, compitiendo visualmente con los 7 vivos.
  Dos con el mismo nombre. Uno marcado inválido. Ver [[Escenarios-Inactivos]].
- **`(copy)` en producción** — [[Make-Lefranm-Cosmeticos-Ventas]].
- **Catálogo de Lefranm en un PDF**, no en una tabla: cada cambio de precio obliga a tocar el
  prompt en vez de una fila. Ver [[Fuente-Catalogo-Lefranm]].
- **Repositorio con nombre equivocado** — [[Sonrisas-Para-Todos-Nosotros]].

## 6. Lo que no estás midiendo

- **Costo por prospecto**: tienes gasto en Meta Ads y tienes prospectos en Airtable. Nadie
  cruza las dos cifras. Sin eso no sabes si la campaña del colegio fue rentable.
- **Conversión del agente**: 2 987 conversaciones atendidas, ningún dato de cuántas terminaron
  en cita o venta.

Ambas son consultas, no desarrollos. Son el siguiente contenido natural de este wiki.

## Orden recomendado

| # | Acción | Esfuerzo | Por qué |
|---|---|---|---|
| 1 | Exportar los 7 blueprints a `fuentes-crudas/make/` | Bajo | Sin esto, un error de edición es irreversible |
| 2 | Diagnosticar el 46% de error del pipeline de contenido | Bajo | La hipótesis ya está escrita |
| 3 | Pausar el seguimiento de prospectos del colegio | Mínimo | Gasto que ya no produce |
| 4 | `getFreeBusyInformation` en Chavarría | Mínimo | Evita empalmar citas |
| 5 | Decidir el criterio de persistencia | Medio | Desbloquea unificar los sondeos de Lefranm |
| 6 | Cruzar gasto de Meta Ads con prospectos | Medio | Es la cifra que justifica tu trabajo |
