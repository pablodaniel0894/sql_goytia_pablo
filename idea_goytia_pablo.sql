-- Introducción: La implementación de un nuevo sistema para mejorar las ventas de un local comercial de barrio, en el cual sus principales ventas son las comidas y bebidas.
-- Situacion Problemática: Un comercio barrial quiere empezar a incursionar en el mundo de los pedidos online. Para ello, necesita establecer ciertas bases de datos para llevarlo a cabo lo mas eficiente posible. Esta mejora permitiria establecer un control mas certero sobre los productos, ventas y clientes.
-- Descripcion de la base de datos: La base de datos contendra informacion vinculada a diversas variables referidas a usuarios y productos, ademas de una tabla de ventas que centralizara la información.
-- Diagrama Entidad-Relación: Se envia adjunto.
-- Listado de tablas: Se crearán tablas vinculadas con la siguiente descripción (las mismas se encontrarán detalladas a la hora de ejecutar la creacion de las tablas):
	-- Clientes
    -- Ventas realizadas
    -- Productos
    -- Categoria de productos
    -- Empleados

-- Creación de la base de datos de "Pedidos Online"
CREATE DATABASE IF NOT EXISTS pedidos_online;

-- Selección de la base de datos para trabajar.
USE pedidos_online;

-- Creación de la tabla "clientes"
CREATE TABLE clientes(
id_cliente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_cliente VARCHAR(50) NOT NULL,
apellido_cliente VARCHAR(50) NOT NULL,
email_cliente VARCHAR(50) NOT NULL,
telefono_cliente VARCHAR(50) NOT NULL
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


-- Creación de la tabla ventas realizadas
CREATE TABLE ventas_realizadas(
id_venta INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_cliente INT NOT NULL,
id_producto INT NOT NULL,
id_empleado INT NOT NULL,
fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);


SELECT * FROM ventas_realizadas;
-- Se crea una vista para poder visualizar las ventas detalladas
CREATE VIEW vista_ventas_detalladas AS
SELECT 
    v.id_venta,
    CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) AS cliente,
    p.nombre_producto,
    cp.nombre_categoria,
    CONCAT(e.nombre_empleado, ' ', e.apellido_empleado) AS empleado,
    v.fecha_venta
FROM ventas_realizadas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
LEFT JOIN categoria_producto cp ON p.id_categoria = cp.id_categoria
JOIN empleados e ON v.id_empleado = e.id_empleado;

-- Se crea una vista para poder visualizar cuando existe un stock bajo
CREATE VIEW stock_bajo AS
SELECT nombre_producto, stock
FROM productos
WHERE stock < 10;

-- Se crea un stored procedure para registrar ventas realizadas
DELIMITER //
CREATE PROCEDURE registros_ventas(
	IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_id_empleado INT
)
BEGIN
	DECLARE stock_actual INT;
    SELECT stock INTO stock_actual
    FROM productos
    WHERE id_producto = p_id_producto;
    
    -- Verificar el stock e insertar la venta
    IF stock_actual > 0 THEN
    INSERT INTO ventas_realizadas(id_cliente, id_producto, id_empleado)
    VALUES (p_id_cliente, p_id_producto, p_id_empleado);
    
    -- se descuenta el stock
    UPDATE productos
    SET stock = stock - 1
    WHERE id_producto = p_id_producto;
	ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Stock Insuficiente para ejecutar la venta';
    END IF;
END //
DELIMITER ;

-- Insertar Clientes -test-
INSERT INTO clientes (nombre_cliente, apellido_cliente, email_cliente, telefono_cliente)
VALUES 
('Ana', 'Pérez', 'ana.perez@email.com', '123456789'),
('Juan', 'García', 'juan.garcia@email.com', '987654321'),
('Lucía', 'Martínez', 'lucia.martinez@email.com', '111222333');

INSERT INTO categoria_producto (nombre_categoria, descripcion_categoria)
VALUES 
('Electrónica', 'Productos electrónicos'),
('Ropa', 'Prendas de vestir'),
('Hogar', 'Artículos para el hogar');

INSERT INTO productos (nombre_producto, id_categoria, stock)
VALUES 
('Auriculares Bluetooth', 1, 10),
('Remera Algodón', 2, 5),
('Lámpara LED', 3, 2);

INSERT INTO empleados (nombre_empleado, apellido_empleado, email_empleado, telefono_empleado)
VALUES 
('Carlos', 'Ramírez', 'carlos.ramirez@email.com', '444555666'),
('Marta', 'López', 'marta.lopez@email.com', '777888999');

CALL registros_ventas(1,1,1);

SELECT * FROM ventas_realizadas;
SELECT * FROM productos WHERE id_producto = 1;