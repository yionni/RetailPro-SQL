-- 4ª ENTREGA

USE Ventas_Tech_DB;
GO

SELECT *
FROM ventas;

SELECT
    COUNT(*) AS total_registros,
    SUM(cantidad * precio_unitario) AS facturacion_total
FROM ventas;

-- CONSULTA 1: Resumen ejecutivo mensual

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: Ranking de productos por facturación

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- CONSULTA 3: Clientes recurrentes

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- CONSULTA 4: Comparación con el promedio mensual

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    AVG(total_facturado) OVER () AS promedio_mensual,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        WHEN total_facturado < AVG(total_facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion
FROM facturacion_mensual
ORDER BY mes;

-- CONCLUSIONES DE NEGOCIO

-- 1. Durante marzo de 2024 se registraron 10 ventas,
-- con una facturación total de $6.444.

-- 2. El producto con ID 1 lideró la facturación,
-- generando $3.600.

-- 3. Los cinco clientes registrados realizaron dos compras cada uno,
-- por lo que todos califican como clientes recurrentes.