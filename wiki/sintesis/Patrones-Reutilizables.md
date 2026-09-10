---
titulo: Patrones reutilizables
tipo: sintesis
estado: activo
tags: [sintesis, patrones, oportunidades]
actualizado: 2026-09-10
---

# Patrones reutilizables

> **La pregunta**: ¿qué ya construí dos o más veces, y por tanto debería estandarizar o
> vender otra vez?

Corte: 2026-09-05.

## Respuesta corta

Tienes dos plantillas de producto probadas en producción —**agente de WhatsApp** y
**seguimiento automático**— y una tercera recién estabilizada —**publicación diaria de
contenido**. Las tres están implementadas por copia, no por plantilla. Convertirlas en
plantillas explícitas es la mayor palanca disponible: reduce el tiempo del próximo cliente y
arregla tres escenarios cada vez que arreglas uno.

## Los tres productos que ya tienes

### Producto 1 — Agente de WhatsApp

Implementado 3 veces ([[Agente-Conversacional-de-WhatsApp]]). Vende: atención 24/7, captura de
datos, agendado. Evidencia: 2 987 conversaciones atendidas.

**Versión canónica recomendada**: la de [[Make-Lefranm-Citas]] (memoria de conversación +
consulta de disponibilidad), con la eficiencia de módulos de
[[Make-Asistente-Chavarria]] (una sola extracción, ruteo temprano).

### Producto 2 — Seguimiento automático

Implementado 3 veces ([[Seguimiento-por-Sondeo]]). Vende: que ningún prospecto se enfríe.
Evidencia: 3 079 ejecuciones con 3 errores. Es el módulo más fácil de vender porque es el más
fácil de sostener.

### Producto 3 — Publicación diaria de contenido

Implementado 6 veces, vivo 1 ([[Pipeline-de-Contenido-Social]]). Vende: presencia diaria en
redes sin community manager. **Aún no es vendible**: 46% de error. Estabilizarlo lo convierte
en el tercer producto del catálogo.

## Las cinco oportunidades concretas

### 1. Conectar la landing dental al sistema de citas que ya existe

[[Landing-Sonrisas-Dental]] dice "agenda tu cita en minutos" y no agenda nada.
[[Lefranm-Agendamiento-de-Citas]] agenda desde julio, con CRUD completo de Calendar y cinco
herramientas MCP ya publicadas. Es el mismo negocio: cita de servicio, recordatorio,
reprogramación. **Esfuerzo bajo, es copiar un escenario y cambiar el calendario y el prompt.**

### 2. Portar `getFreeBusyInformation` a Chavarría

[[Make-Asistente-Chavarria]] crea eventos sin consultar disponibilidad. Un módulo, tomado de
[[Make-Lefranm-Citas]]. Evita empalmar visitas.

### 3. Dar memoria a Chavarría

Añadir `GetRecord` + `Resume` como en los dos agentes de Lefranm: el prospecto podría
contestar en dos mensajes en vez de uno. Ver [[Agente-Conversacional-de-WhatsApp]].

### 4. Rescatar las dos ideas huérfanas de mayo

De [[Escenarios-Inactivos]], dos escenarios diseñados y nunca activados, ambos de 2 a 5
módulos:

- **Seguimiento post-cita pidiendo reseña** (5037100) — prueba social, que hoy no generas.
- **Reporte semanal de citas** (5037104) — es el entregable que justifica tu factura frente al
  cliente cada semana.

Son las dos piezas de mayor retorno por módulo de todo el inventario.

### 5. Exportar los blueprints a este repositorio

Los 7 escenarios vivos existen en un solo lugar. Exportarlos como JSON a
`fuentes-crudas/make/` te da control de versiones, diff entre implementaciones y —lo más
útil— la posibilidad de que el wiki compare los tres agentes módulo a módulo en vez de por
nombre. Ver [[Riesgos-y-Deuda-Tecnica]].

## La plantilla de cliente nuevo

Con lo que ya tienes, un negocio local con citas se atiende con cuatro piezas:

```
1. Agente de WhatsApp        (Producto 1, versión Lefranm)
2. Seguimiento cada 30 min   (Producto 2, 3 módulos)
3. Recordatorio + reseña     (rescate de 5037096 y 5037100)
4. Landing estática          (patrón de Sonrisas, sin framework)
```

Ese paquete describe exactamente lo que ya corre para Lefranm y lo que le falta a Sonrisas.

Un comercio con mostrador —sin citas que agendar— necesita otra quinta pieza en lugar de la
1: un programa de puntos operado en caja. El prototipo está en
[[Sacapuntos-Lealtad-Papeleria]] y todavía no tiene cliente. Es la única variante del paquete
que no depende de un modelo de lenguaje, y por tanto la única que no hereda el 8.2% de error
de la capa de IA.

## Qué hacer con esto

Prioridad por relación esfuerzo/retorno: **2 y 3** (una tarde, arreglan un riesgo real),
luego **4** (dos escenarios cortos que se pueden facturar), luego **1** (cliente nuevo),
luego **5** (higiene que habilita todo lo demás).
