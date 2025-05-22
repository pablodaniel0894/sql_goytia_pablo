-- INSERTAR DATOS A LA TABLA
USE pedidos_online;

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

CALL registros_ventas(1,4,1);
CALL registros_ventas(2,4,1);

SELECT * FROM stock_bajo;
SELECT * FROM vista_ventas_detalladas;
SELECT * FROM auditoria_stock;
SELECT * FROM productos WHERE id_producto = 1;