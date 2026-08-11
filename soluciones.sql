-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Mariano Laville
-- Fecha: 11/08/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostrá todos los productos y sus ventas asociadas.
-- Los productos sin ventas aparecerán con NULL en las columnas de ventas.

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Los registros huérfanos aparecerán con NULL en las columnas de productos.

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos AS p
RIGHT JOIN ventas AS v
    ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.producto_id = v.producto_id

UNION

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos AS p
RIGHT JOIN ventas AS v
    ON p.producto_id = v.producto_id;
