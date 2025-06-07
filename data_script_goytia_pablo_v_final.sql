-- INSERTAR DATOS A LA TABLA
USE pedidos_online;

-- Insertar Clientes -test-
INSERT INTO clientes (nombre_cliente, apellido_cliente, email_cliente, telefono_cliente)
VALUES 
('Ana', 'Pérez', 'ana.perez@email.com', '123456789'),
('Juan', 'García', 'juan.garcia@email.com', '987654321'),
('Lucía', 'Martínez', 'lucia.martinez@email.com', '111222333');

INSERT INTO direccion_clientes(id_cliente, direccion, ciudad, provincia, codigo_postal)
VALUES
(1, 'Avenida Juan B Justo 6100','Ciudad de Buenos Aires', 'CABA', '1416'),
(2, 'Avenida 9 de Julio 100', 'Ciudad de Buenos Aires', 'CABA', '1450'),
(3, 'Avenida San Martin 2030', 'San Martín', 'Provincia de Buenos Aires', '2340');

INSERT INTO categoria_producto (nombre_categoria, descripcion_categoria)
VALUES 
('Bebidas', 'Bebidas alcohólicas y sin alcohol'),
('Comidas', 'Alimentos preparados o envasados');

INSERT INTO productos (nombre_producto, id_categoria, stock)
VALUES 
('Coca-Cola 1.5L', 1, 20),
('Empanada de Carne', 2, 5),
('Cerveza Quilmes 1L', 1, 8),
('Pizza Muzzarella', 2, 12);

INSERT INTO empleados (nombre_empleado, apellido_empleado, email_empleado, telefono_empleado)
VALUES 
('Carlos', 'Ramírez', 'carlos.ramirez@email.com', '444555666'),
('Marta', 'López', 'marta.lopez@email.com', '777888999'),
('Juan', 'Pérez', 'juan.perez@email.com', '123456789');

INSERT INTO medios_de_pago(metodo_pago)
VALUES 
('Efectivo'),
('Tarjeta de Crédito'),
('Mercado Pago');

INSERT INTO proveedores(nombre_proveedor, telefono_proveedor, email_proveedor)
VALUES 
('Bebidas Sahur.', '1133557799', 'Bebidas@Sahur.com'),
('Comidas Bombardino Crocodrilo', '1144226688', 'Bombardino@Crocodrilo.com');

INSERT INTO productos_proveedores(id_producto, id_proveedor, precio_compra)
VALUES 
(1, 1, 120.50),
(3, 1, 150.00),
(2, 2, 80.00),
(4, 2, 100.00);

CALL registros_ventas(1, 3, 2, 4, 150.00, 1);
CALL registros_ventas(2, 4, 2, 1, 850.00, 3);

CALL actualizar_stock_producto(1, 10);

SELECT * FROM stock_bajo;

SELECT * FROM productos;
SELECT * FROM vista_ventas_detalladas;
SELECT * FROM auditoria_stock;
SELECT * FROM productos WHERE id_producto = 1;
SELECT * FROM empleados;
SELECT * FROM proveedores;
SELECT * FROM productos_mas_vendidos;
SELECT * FROM ventas_por_cliente;
SELECT * FROM ventas_por_categoria;
SELECT * FROM vista_ventas_detalladas;
SELECT * FROM log_errores;
SELECT * FROM ventas_realizadas;
SELECT * FROM clientes;
