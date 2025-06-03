-- Introducción: La implementación de un nuevo sistema para mejorar las ventas de un local comercial de barrio, en el cual sus principales ventas son las comidas y bebidas.
-- Situacion Problemática: Un comercio barrial quiere empezar a incursionar en el mundo de los pedidos online. Para ello, necesita establecer ciertas bases de datos para llevarlo a cabo lo mas eficiente posible. Esta mejora permitiria establecer un control mas certero sobre los productos, ventas y clientes, además de tener un control interno del stockeo
-- Descripcion de la base de datos: La base de datos contendra informacion vinculada a diversas variables referidas a usuarios y productos, ademas de una tabla de ventas que centralizara la información.
-- Diagrama Entidad-Relación: Se envia adjunto.

-- Listado de tablas: Se crearán tablas vinculadas con la siguiente descripción (las mismas se encontrarán detalladas a la hora de ejecutar la creacion de las tablas):
	-- Clientes
    -- Direccion Clientes
    -- Categoria Producto
    -- Productos
    -- Categoria de productos
    -- Empleados
    -- Medios de Pago
    -- Ventas realizadas
    -- Detalle Venta
    -- Proveedores
    -- Productos Proveedores
    -- Auditoria Stock
    -- Log de Errores
    
    
-- Vistas creadas: 
	-- Vista ventas detalladas -  detalla las ventas realizadas y otra vista llamada 'stock_bajo' donde pueda enmarcar aquellos prodcutos que pueden faltar.
    -- Stock Bajo - Muestra cuales son los productos que se encuentran debajo de un valor definido (10)
    -- Ventas por categoria - Enmarcando cuales son las ventas realizadas segun la categoría.
    -- Ventas por cliente - Cantidad de clientes que realizan las compras.
    -- Productos mas vendidos - Visualiza cuáles son los productos más vendidos

-- Stored procedures creados: 'registros_ventas' : este proceso almacenado inserta las ventas que se lleguen a realizar y, a su vez, segun el producto elegido, descuenta el stock que vaya a realizar. En caso que no haya stock, arrojara el resultado de no hay stock suficien
-- Triggers creados: Se creo un trigger en el cual cada vez que haya una venta o modificación del stock, este actualizado en un registro.


-- Creación de la base de datos de "Pedidos Online"
CREATE DATABASE IF NOT EXISTS pedidos_online;

-- Selección de la base de datos para trabajar.
USE pedidos_online;

#------ Apartado de Tablas ------#

-- Creación de la tabla "clientes"
CREATE TABLE clientes(
id_cliente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_cliente VARCHAR(50) NOT NULL,
apellido_cliente VARCHAR(50) NOT NULL,
email_cliente VARCHAR(50) NOT NULL,
telefono_cliente VARCHAR(50) NOT NULL
);

-- Tabla de direcciones de clientes
CREATE TABLE direccion_clientes(
id_direccion INT AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
direccion VARCHAR(50),
ciudad VARCHAR(50),
provincia VARCHAR(50),
codigo_postal VARCHAR(10),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Creación de la tabla categoria de productos
CREATE TABLE categoria_producto(
id_categoria INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_categoria VARCHAR(50),
descripcion_categoria VARCHAR(100)
);

-- Creación de la tabla productos
CREATE TABLE productos(
id_producto INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_producto VARCHAR(50) NOT NULL,
id_categoria INT,
stock INT DEFAULT 0,
FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id_categoria)
);



-- Creación de la tabla empleados
CREATE TABLE empleados(
id_empleado INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_empleado VARCHAR(50) NOT NULL,
apellido_empleado VARCHAR(50) NOT NULL,
email_empleado VARCHAR(50) NOT NULL,
telefono_empleado VARCHAR(50) NOT NULL
);


-- Tabla de medios de pago
CREATE TABLE medios_de_pago(
id_medio_pago INT AUTO_INCREMENT PRIMARY KEY,
metodo_pago VARCHAR(50) 
);


-- Creación de la tabla ventas realizadas
CREATE TABLE ventas_realizadas(
id_venta INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_cliente INT NOT NULL,
id_empleado INT NOT NULL,
id_medio_pago INT,
fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
FOREIGN KEY (id_medio_pago) REFERENCES medios_de_pago(id_medio_pago)
);

-- Tabla detalle de ventas
CREATE TABLE detalle_venta (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venta) REFERENCES ventas_realizadas(id_venta),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla de Proveedores
CREATE TABLE proveedores(
id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
nombre_proveedor VARCHAR(50),
telefono_proveedor VARCHAR(50),
email_proveedor VARCHAR(50)
);

-- Tabla de Productos que envia un proveedor
CREATE TABLE productos_proveedores(
id_producto INT,
id_proveedor INT,
precio_compra DECIMAL(10,2),
PRIMARY KEY (id_producto, id_proveedor),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

-- Tabla Auditoria de stock
CREATE TABLE auditoria_stock(
id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
id_producto INT,
stock_anterior INT,
stock_nuevo INT,
fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de LOG de errores
CREATE TABLE log_errores(
id_log INT AUTO_INCREMENT PRIMARY KEY,
descripcion TEXT,
fecha_error DATETIME DEFAULT CURRENT_TIMESTAMP
);

#------ Apartado de Vistas ------#

SELECT * FROM ventas_realizadas;
-- Se crea una vista para poder visualizar las ventas detalladas
CREATE OR REPLACE VIEW vista_ventas_detalladas AS
SELECT 
  v.id_venta,
  CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) AS cliente,
  p.nombre_producto,
  cp.nombre_categoria,
  CONCAT(e.nombre_empleado, ' ', e.apellido_empleado) AS empleado,
  m.metodo_pago,
  v.fecha_venta
FROM ventas_realizadas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto
LEFT JOIN categoria_producto cp ON p.id_categoria = cp.id_categoria
JOIN empleados e ON v.id_empleado = e.id_empleado
LEFT JOIN medios_de_pago m ON v.id_medio_pago = m.id_medio_pago;

-- Se crea una vista para poder visualizar cuando existe un stock bajo
CREATE OR REPLACE VIEW stock_bajo AS
SELECT nombre_producto, stock
FROM productos
WHERE stock < 10;

-- Se crea una vista para visualizar las ventas por categorias
CREATE OR REPLACE VIEW ventas_por_categoria AS
SELECT 
    cp.nombre_categoria,
    COUNT(v.id_venta) AS cantidad_ventas
FROM ventas_realizadas v
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto
JOIN categoria_producto cp ON p.id_categoria = cp.id_categoria
GROUP BY cp.nombre_categoria;

-- Se crea una vista para ver las ventas realizadas por cliente
CREATE OR REPLACE VIEW ventas_por_cliente AS
SELECT 
    c.id_cliente,
    CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) AS nombre,
    COUNT(v.id_venta) AS total_ventas
FROM ventas_realizadas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente;

-- Se crea una vista para ver los productos más vendidos
CREATE VIEW productos_mas_vendidos AS
SELECT 
    p.nombre_producto,
    SUM(dv.cantidad) AS cantidad_total
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
GROUP BY p.nombre_producto
ORDER BY cantidad_total DESC
LIMIT 10;

#------ Apartado de Stored Procedured ------#

-- Se crea un stored procedure para registro de ventas
DELIMITER //
CREATE PROCEDURE registros_ventas(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_id_empleado INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_id_medio_pago INT
)
BEGIN
    DECLARE stock_actual INT;
    DECLARE nueva_venta_id INT;

    SELECT stock INTO stock_actual
    FROM productos
    WHERE id_producto = p_id_producto;

    IF stock_actual >= p_cantidad THEN

        INSERT INTO ventas_realizadas (id_cliente, id_empleado, id_medio_pago)
        VALUES (p_id_cliente, p_id_empleado, p_id_medio_pago);

        SET nueva_venta_id = LAST_INSERT_ID();

        INSERT INTO detalle_venta(id_venta, id_producto, cantidad, precio_unitario)
        VALUES (nueva_venta_id, p_id_producto, p_cantidad, p_precio_unitario);

        UPDATE productos
        SET stock = stock - p_cantidad
        WHERE id_producto = p_id_producto;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para ejecutar la venta';
    END IF;
END //
DELIMITER ;



-- Stored procedured para actualizar el stock
DELIMITER //
CREATE PROCEDURE actualizar_stock_producto(
	IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
	UPDATE productos
    SET stock = stock + p_cantidad
    WHERE id_producto = p_id_producto;
END //
DELIMITER ;

#------ Apartado de funciones ------#

-- Función para ver si el producto esta en stock
CREATE FUNCTION esta_en_stock(p_id INT)
RETURNS BOOLEAN
DETERMINISTIC
RETURN (
	SELECT stock > 0 FROM productos WHERE id_producto = p_id
);

-- Función para calcular el precio de una venta
DELIMITER //
CREATE FUNCTION precio_total_venta(p_id_venta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad * precio_unitario)
    INTO total
    FROM detalle_venta
    WHERE id_venta = p_id_venta;
    RETURN total;
END //
DELIMITER ;

#------ Apartado de Triggers ------#

-- Trigger para la Auditoria del Stock
DELIMITER //
CREATE TRIGGER auditar_stock
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
	IF OLD.stock <> NEW.stock THEN
	INSERT INTO auditoria_stock(
id_producto, stock_anterior, stock_nuevo
	) VALUES (
	OLD.id_producto, OLD.stock, NEW.stock
);
END IF;
END //

DELIMITER ;

-- Trigger para que un stock quede en negativo, se guarde en el log de errores
DELIMITER //
CREATE TRIGGER log_errores_stock
AFTER INSERT ON auditoria_stock
FOR EACH ROW
BEGIN
    IF NEW.stock_nuevo < 0 THEN
        INSERT INTO log_errores(descripcion)
        VALUES (CONCAT('Error: Stock negativo para producto ID ', NEW.id_producto));
    END IF;
END //
DELIMITER ;

