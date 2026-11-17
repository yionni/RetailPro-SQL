
-- ENTREGA N° 5
-- Consultas con JOINs y UNION ALL
-- Base de datos: Ventas_Tech_DB

-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Objetivo: integrar ventas con información descriptiva
-- de clientes, productos y categorías.

USE Ventas_Tech_DB;

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo:
-- Se obtuvieron 10 registros de ventas enriquecidos con
-- información de clientes, ciudades, productos y categorías.
-- Estas dimensiones permiten analizar las ventas por ubicación
-- y tipo de producto.


-- =====================================================

-- CONSULTA 2: Clientes sin compras (LEFT JOIN)
-- Objetivo: identificar clientes registrados que no
-- realizaron ninguna compra.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo:
-- No se encontraron clientes sin compras (0 registros).
-- Todos los clientes registrados realizaron al menos
-- una compra en la muestra analizada.

-- =====================================================

-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Objetivo: identificar productos del catálogo que
-- nunca fueron vendidos.

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- Hallazgo:
-- No se encontraron productos sin ventas (0 registros).
-- Todos los productos del catálogo registraron al menos
-- una venta en la muestra analizada.

-- =====================================================

-- CONSULTA 4: Consolidado de facturación por canal
-- Objetivo: combinar ventas de dos grupos mediante UNION ALL.
-- Nota: los canales son una clasificación ilustrativa,
-- ya que no existe una columna de canal en la base original.


SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE id_venta <= 5

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE id_venta > 5
) AS consolidado
GROUP BY canal;

-- Hallazgo:
-- El canal Online concentra $3.620 y el canal Presencial
-- $2.824. La facturación total es de $6.444.
-- Esta división es ilustrativa y no representa canales reales.
