---
titulo: Make · Tersil - Seguimiento 10 h
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 9738949
clientes: [Tersil]
tags: [whatsapp, datastore, seguimiento, sondeo]
actualizado: 2026-09-11
---

# Make · Tersil - Seguimiento 10 h

> Cada 30 minutos busca a quien dejó de contestar hace más de 10 horas y le manda **un solo**
> recordatorio con el link del catálogo.

Equipo 2904200 (`eu2.make.com`). Creado 2026-09-01, última edición 2026-09-09.

## Disparador

Programado, `indefinitely`, intervalo **1800 s** (48 corridas al día).

## Flujo

1. `datastore · SearchRecord` sobre `TERSIL_Seguimiento` (182352), límite 100. Filtro:
   `telefono` existe **y** `ultimo_mensaje < now-10h` **y** `ultimo_mensaje > now-24h` **y**
   `seguimientos < 1`.
2. `datastore · ExistRecord` sobre `TERSIL_Pausa_Bot` (174953) — ¿el bot está pausado?
3. `whatsapp-business-cloud · sendMessage` — filtro `Bot activo (no pausado)`. Texto fijo:
   saludo con el nombre + "¿Pudiste ver los modelitos?" + link del catálogo web. Con
   `builtin · Break` en error: 3 reintentos cada 15 min.
4. `datastore · UpdateRecord` — `seguimientos = 1`, `ultimo_seguimiento = now`. Es el candado
   que garantiza un único recordatorio.

La ventana `-10h a -24h` es lo que evita perseguir a alguien para siempre: pasadas 24 horas el
registro deja de calificar. Y coincide con la ventana de 24 h de WhatsApp para mensajes de
respuesta libre, así que el recordatorio nunca cae fuera de ella.

## Persistencia

Data Store `TERSIL_Seguimiento` como cola y `seguimientos` como bandera anti-doble-envío.
Mismo mecanismo que [[Seguimiento-por-Sondeo]].

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 478 | 2026-09-11 |
| Operaciones | 9 511 (**19.9 por ejecución**) | 2026-09-11 |
| Errores | 0 | 2026-09-11 |
| Créditos | ~9 511 | 2026-09-11 |
| Transferencia | ~1.8 MB | 2026-09-11 |

Cero errores en 478 corridas, coherente con el 99.9% de fiabilidad del patrón.

## Problemas conocidos

- **Cuesta 2.5 veces más que el agente al que acompaña**: ~9 511 créditos contra ~3 812 de
  [[Make-Asistente-Tersil-V2]], y en menos de la mitad de tiempo de vida (11 días contra 43).
  Es el escenario más caro de la cuenta. La causa son las ~20 operaciones por corrida: el
  `SearchRecord` devuelve varios registros y cada uno arrastra los módulos de abajo.
  Un filtro más estrecho o un intervalo de 1 h en vez de 30 min lo bajaría a la mitad sin
  cambiar la experiencia del cliente.

~~Contradicción 10 h / 23 h~~ — **resuelta el 2026-09-11.** El `systemPrompt` de
[[Make-Asistente-Tersil-V2]] decía que "el sistema envía automáticamente los mensajes de
seguimiento **cada 23 horas**", cuando el escenario manda **uno solo, a las 10 h**. Ya dice lo
que el escenario hace de verdad.

- El registro no se borra al enviar el recordatorio, solo se marca. Se borra cuando el agente
  cierra la venta (módulo 8 de [[Make-Asistente-Tersil-V2]]). Un contacto que nunca compra se
  queda en la tabla para siempre.

## Correlaciones

Cuarta implementación de [[Seguimiento-por-Sondeo]] y la primera que añade dos cosas que las
otras tres no tienen: **ventana superior** (no persigue después de 24 h) y **reintentos con
`Break`**. Patrón a retro-aplicar en [[Make-Lefranm-Seguimiento-Citas]] y
[[Make-CUT-Seguimiento-Prospectos]].

Cliente: [[Tersil]]. Proyecto: [[Tersil-Asistente-de-Ventas]]. Fuente:
[[Fuente-Cuenta-Make-EU2]].
