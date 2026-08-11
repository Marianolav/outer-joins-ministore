# outer-joins-ministore

¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?

Se utiliza LEFT JOIN porque necesitamos conservar todos los productos del catálogo, incluso aquellos que nunca tuvieron una venta.
En esta consulta, productos es la tabla ubicada a la izquierda:

FROM productos AS p
LEFT JOIN ventas AS v
    ON p.producto_id = v.producto_id

El LEFT JOIN garantiza que todos los registros de productos aparezcan en el resultado.
Luego se utiliza:
WHERE v.venta_id IS NULL
para quedarnos únicamente con los productos que no tienen ninguna venta asociada.
En los datos de MiniStore, los productos 108 (Hub USB-C 7p) y 109 (Parlante Bluetooth) nunca fueron vendidos, por lo que aparecen con NULL en las columnas provenientes de ventas.

Un INNER JOIN solamente devuelve las filas que tienen coincidencia en ambas tablas.
Por lo tanto, si utilizáramos INNER JOIN, los productos 108 y 109 desaparecerían del resultado porque no tienen ninguna venta asociada.
Esto impediría detectar justamente los productos que nunca fueron vendidos.


¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?

Se utiliza RIGHT JOIN porque en esta consulta queremos conservar todas las ventas, incluso aquellas cuyo producto no existe en el catálogo.
La consulta tiene la siguiente estructura:

FROM productos AS p
RIGHT JOIN ventas AS v
    ON p.producto_id = v.producto_id

En este caso:
productos está a la izquierda.
ventas está a la derecha.

RIGHT JOIN garantiza que todas las filas de ventas sean conservadas.

Después utilizamos:

WHERE p.producto_id IS NULL

para identificar las ventas que no encontraron un producto correspondiente en el catálogo.
En MiniStore existe una venta con:

venta_id = 10
producto_id = 999

Como el producto 999 no existe en la tabla productos, las columnas provenientes de productos aparecen como NULL.
Este registro representa un posible error de carga o un problema de integridad de los datos.


¿Qué representan los valores NULL en cada resultado? Explicá con un ejemplo concreto de los datos qué significa que venta_id sea NULL en la Consulta 1 y que producto_id de productos sea NULL en la Consulta 2.
Los NULL tienen un significado diferente dependiendo de la consulta.

Consulta 1

En la Consulta 1:

WHERE v.venta_id IS NULL

un venta_id igual a NULL significa que el producto del catálogo no tiene ninguna venta asociada.

Por ejemplo:

producto_id = 108
nombre = Hub USB-C 7p
venta_id = NULL

El producto existe, pero no existe ninguna fila en ventas que tenga producto_id = 108.

Consulta 2

En la Consulta 2:

WHERE p.producto_id IS NULL

un producto_id de la tabla productos igual a NULL significa que la venta existe, pero no existe un producto correspondiente en el catálogo.

Por ejemplo:

venta_id = 10
producto_id_venta = 999
producto_id = NULL

La venta fue registrada, pero el producto 999 no existe en productos.

Por lo tanto, los NULL en estos casos no representan necesariamente un error de SQL. Son una señal que permite detectar registros sin correspondencia entre las tablas.

¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?

Un FULL OUTER JOIN es útil cuando necesitamos realizar una auditoría completa entre dos conjuntos de datos y queremos conservar tanto las coincidencias como los registros que existen solamente en una de las tablas.

En este ejercicio queremos obtener:

Productos que tienen ventas.
Productos que no tienen ventas.
Ventas cuyo producto existe.
Ventas cuyo producto no existe.

SQL Server y otros motores soportan FULL OUTER JOIN directamente, pero MySQL no lo soporta de forma nativa.

Por ese motivo, en MySQL se puede simular combinando un LEFT JOIN y un RIGHT JOIN mediante UNION.

SELECT ...
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.producto_id = v.producto_id

UNION

SELECT ...
FROM productos AS p
RIGHT JOIN ventas AS v
    ON p.producto_id = v.producto_id;

El resultado permite obtener una visión completa de la relación entre catálogo y ventas sin perder registros de ninguna de las dos tablas.
