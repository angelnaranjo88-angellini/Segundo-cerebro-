---
titulo: Escenarios inactivos de Make
tipo: automatizacion
estado: archivado
plataforma: make
clientes: [Colegio-Maria-Chavarria-Vital, Lefranm-Quiropractico]
tags: [deuda-tecnica, prototipos, limpieza]
actualizado: 2026-09-05
---

# Escenarios inactivos de Make

> 15 de los 22 escenarios del entorno están apagados. **14 de ellos nunca ejecutaron ni una
> sola vez.** Este es el cementerio, y también el registro de cómo aprendiste.

Corte: 2026-09-05, equipo `My Team` (1436402), organización `My Organization` (5357289),
zona `us2.make.com`.

## Inventario

| Escenario | ID | Último edit | Ejec. | Por qué importa |
|---|---|---|---|---|
| Agendamiento | 3678657 | 2025-12-10 | 0 | Primer intento de citas: 29 módulos, todo a mano con `SetVariable`/`GetVariable` y `CreateCompletion`. Sustituido por [[Make-Lefranm-Citas]]. |
| air table | 3620443 | 2025-12-02 | 0 | Primer contacto con Airtable + asistente de OpenAI. Antecesor de [[Make-Lefranm-Cosmeticos-Ventas]]. |
| Asistente de llamadas | 4080491 | 2026-02-06 | 0 | Webhook → variable → respuesta. Esqueleto de voz que no prosperó. |
| Asistente de llamadas | 4087742 | 2026-02-08 | 0 | **Duplicado exacto de nombre** del anterior. Webhook → Google Sheets. |
| Automatización de redes sociales (instagram) | 4006601 | 2026-03-06 | 0 | Gen. 1 del pipeline de contenido: imagen generada por IA. |
| Creacion de contenido automatica | 4246376 | 2026-05-20 | 0 | Gen. 2: foto por WhatsApp → visión → Facebook. |
| Creacion de contenido automatica Calpitas | 5068399 | 2026-05-14 | 0 | Copia de la anterior para otro cliente. **Marcado inválido por Make.** |
| CREACION DE CONTENIDO POR FOTO | 5079824 | 2026-08-04 | 2 | Gen. 3: añade `editImage`. Único inactivo que llegó a correr. |
| CREACION DE CONTENIDO POR MENSAJE | 5056432 | 2026-08-04 | 0 | Variante por texto en vez de foto. |
| Integration WhatsApp Business Cloud | 4535198 | 2026-03-26 | 0 | Prueba del módulo `knowledge` (RAG nativo de Make). Vía no explorada. |
| Publicacion multi-canal (Instagram + Facebook) | 5037110 | 2026-05-12 | 0 | Ruteo a dos redes. Su idea sobrevive en [[Make-CUT-Creacion-de-Contenido-Sheets]]. |
| Recordatorios de citas (24h y 1h antes) | 5037096 | 2026-05-12 | 0 | Recordatorios desde Calendar. Reemplazado por el sondeo sobre Data Store. |
| Reporte semanal de citas | 5037104 | 2026-05-12 | 0 | Resumen semanal por WhatsApp. **Nunca se retomó y no tiene sustituto.** |
| Reutilizacion de contenido entre redes | 5037114 | 2026-05-12 | 0 | Duplicado casi exacto de "Publicacion multi-canal". |
| Seguimiento post-cita (pedir reseña) | 5037100 | 2026-05-12 | 0 | Pedir reseña tras la cita. **Sin sustituto.** |

## Lo que dice este inventario

1. **Cinco escenarios se crearon el mismo día (2026-05-12) y ninguno se activó.** Fue una
   sesión de diseño en bloque, no una implementación. Las ideas eran buenas; el paso de
   activarlas nunca ocurrió.
2. **Dos ideas valiosas quedaron huérfanas y sin reemplazo**: el reporte semanal de citas
   (5037104) y la petición de reseña post-cita (5037100). Ambas son de bajo costo —tres o
   cinco módulos— y atacan lo que hoy no mides ni cobras: retención y prueba social.
3. **Duplicados por copia**: dos "Asistente de llamadas" con el mismo nombre, dos variantes de
   publicación multi-canal, y un `(copy)` que quedó en producción
   ([[Make-Lefranm-Cosmeticos-Ventas]]). Nombrar por copia es la fuente de deuda más constante
   del entorno.

## Recomendación

No borrar: renombrar con prefijo `ZZ-ARCHIVO-` para que dejen de competir visualmente con los
7 escenarios vivos. Rescatar 5037104 y 5037100 como proyecto propio.

## Correlaciones

[[Pipeline-de-Contenido-Social]] reconstruye la genealogía de los seis escenarios de contenido.
[[Riesgos-y-Deuda-Tecnica]] cuantifica el costo de esta acumulación.
