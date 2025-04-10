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
