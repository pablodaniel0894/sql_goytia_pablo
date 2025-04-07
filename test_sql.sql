-- Introducción: La implementación de un nuevo sistema para mejorar las ventas de un local comercial de barrio, en el cual sus principales ventas son las comidas y bebidas.
-- Situacion Problemática: Un comercio barrial quiere empezar a incursionar en el mundo de los pedidos online. Para ello, necesita establecer ciertas bases de datos para llevarlo a cabo lo mas eficiente posible. Esta mejora permitiria establecer un control mas eficientes sobre los productos, ventas y clientes.
-- Descripcion de la base de datos: 
-- Diagrama Entidad-Relación: Se envia adjunto.
-- Listado de tablas: Se crearán tablas vinculadas con la siguiente descripción (las mismas se encontrarán detalladas a la hora de ejecutar la creacion de las tablas):
	-- Clientes
    -- Ventas realizadas
    -- Productos
    -- Stock de Productos
    -- Categoria de productos
    -- Empleados
-- Creación de la base de datos de "Pedidos Online"
CREATE DATABASE pedidos_online;

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

CREATE TABLE productos(
id_producto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_producto VARCHAR(50) NOT NULL,
id_categoria INT NOT NULL,
stock_producto INT NOT NULL
);

-- Pendiente de Ver stocks
CREATE_TABLE stock

CREATE TABLE ventas_realizadas(
id_venta INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_cliente INT NOT NULL,
id_producto INT NOT NULL,
fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
);

SELECT * FROM clientes;