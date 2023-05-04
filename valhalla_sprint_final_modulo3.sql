-- creación del usuario
CREATE USER 'admin_sprint'@'localhost' IDENTIFIED BY '1234';

-- creación de la base de datos
CREATE DATABASE te_lo_vendo;

-- otorgar permisos a usuario
GRANT SELECT, UPDATE, CREATE, DROP, ALTER, REFERENCES, INSERT ON te_lo_vendo.* TO 'admin_sprint'@'localhost';
FLUSH PRIVILEGES;

-- posicionamiento en base de datos
USE te_lo_vendo;

-- creacion tabla proveedor
CREATE TABLE proveedor(
	id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_corporativo VARCHAR(50) NOT NULL UNIQUE,
    representante_legal VARCHAR(50) NOT NULL,
    telefono_1 VARCHAR(12) NOT NULL,
	telefono_2 VARCHAR(12),
    recepcionista VARCHAR(20),
    categoria VARCHAR(50) NOT NULL,
    correo_electronico VARCHAR(50) NOT NULL
);

-- creacion tabla producto
CREATE TABLE producto(
	sku CHAR(5) PRIMARY KEY,
    nombre_producto VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    id_proveedor INT NOT NULL,
    color VARCHAR(20),
    stock INT NOT NULL,
    CONSTRAINT fk_id_proveedor FOREIGN KEY(id_proveedor) REFERENCES proveedor(id_proveedor)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

	
-- creacion tabla cliente
CREATE TABLE cliente(
	id_cliente VARCHAR(10) PRIMARY KEY,
    nombre_cliente VARCHAR(20) NOT NULL,
    apellido_cliente VARCHAR(20) NOT NULL,
	correo_electronico VARCHAR(50) NOT NULL
);

-- inserción de proveedores
INSERT INTO proveedor(nombre_corporativo, representante_legal, telefono_1, telefono_2, recepcionista, categoria, correo_electronico)VALUES
	('Hites Tecnología', 'María González', '+56223838200', '+56977897777', 'Nicolás', 'smartphones', 'mgonzalez@hites.cl'),
	('Paris Tecnología', 'Alejandra Soto', '+56227176000', '+56988854888', 'Javier', 'gaming', 'asoto@paris.cl'),
	('Ripley Tecnología', 'Fernando Rodríguez', '+56223905000', '+56955432555', 'Marcela', 'notebooks', 'frodriguez@ripley.cl'),
	('ABC Hogar Tecnología', 'Carlos Pérez', '+56227529000', '+56924622222', 'Gabriela', 'televisores', 'cperez@abchogar.cl'),
	('Easy Tecnología', 'Paula Torres', '+56223910000', '+56223915897','Pedro', 'electrodomesticos', 'ptorres@easy.cl');

-- inserción de clientes
INSERT INTO cliente (id_cliente, nombre_cliente, apellido_cliente, correo_electronico)VALUES 
	('18267677-9', 'María', 'González', 'maria.gonzalez@gmail.com'),
	('18398445-2', 'Pedro', 'Rodríguez', 'pedro.rodriguez@hotmail.com'),
	('16827671-6', 'Carolina', 'Ramírez', 'carolina.ramirez@yahoo.com'),
	('16889211-4', 'Javier', 'Soto', 'javier.soto@gmail.com'),
	('19411709-3', 'Fernanda', 'López', 'fernanda.lopez@hotmail.com');

-- inserción de productos
INSERT INTO producto(sku, nombre_producto, precio, categoria, id_proveedor, color, stock)VALUES
	('eh456', 'secadora rj50', 350000, (SELECT categoria FROM proveedor WHERE id_proveedor = 5), 5, 'blanco', 10),
    ('ss556', 'celular samsung S25', 750000, (SELECT categoria FROM proveedor WHERE id_proveedor = 1), 1, 'gris', 20),
    ('gl345', 'mouse logitech', 50000, (SELECT categoria FROM proveedor WHERE id_proveedor = 2), 2, 'negro', 15),
    ('na566', 'notebook asus450', 850000, (SELECT categoria FROM proveedor WHERE id_proveedor = 3), 3, 'gris', 5),
    ('tl578', 'tv lg 50 pulg', 350000, (SELECT categoria FROM proveedor WHERE id_proveedor = 4), 4, 'negro', 12),
    ('sx444', 'celular xiaomi redmi 9', 250000, (SELECT categoria FROM proveedor WHERE id_proveedor = 1), 1, 'blanco', 8),
    ('em316', 'lavadora mademsa t60', 800000, (SELECT categoria FROM proveedor WHERE id_proveedor = 5), 5, 'blanco', 2),
    ('en788', 'tostadora next', 20000, (SELECT categoria FROM proveedor WHERE id_proveedor = 5), 5, 'rosado', 3),
    ('na676', 'notebook acer f89', 700000, (SELECT categoria FROM proveedor WHERE id_proveedor = 3), 3, 'negro', 6),
    ('nh992', 'notebook hp fg9', 350000, (SELECT categoria FROM proveedor WHERE id_proveedor = 3), 3, 'blanco', 4);

-- Cuál es la categoría de productos que más se repite
SELECT categoria, COUNT(*) AS repeticiones 
	FROM producto 
    GROUP BY categoria 
    ORDER BY repeticiones DESC LIMIT 1;
    
-- Cuáles son los productos con mayor stock
-- puede realizarse mostrando los 3 productos con más stock
SELECT nombre_producto, categoria, stock 
	FROM producto 
    ORDER BY STOCK DESC LIMIT 3; 
-- o mostrando productos con stock mayor al promedio
SELECT nombre_producto, categoria, stock 
	FROM producto 
    WHERE stock > (SELECT AVG(stock) FROM producto) 
    ORDER BY stock DESC; 
	
-- Qué color de producto es más común en nuestra tienda. 
SELECT color, COUNT(*) AS repeticiones 
	FROM producto 
    GROUP BY color
    ORDER BY repeticiones DESC LIMIT 1;
    
-- Cual o cuales son los proveedores con menor stock de productos.
-- puede realizarse mostrando los 3 productos con menos stock
SELECT nombre_producto, categoria, stock 
	FROM producto 
    ORDER BY STOCK ASC LIMIT 3; 
-- o mostrando productos con stock menor al promedio
SELECT nombre_producto, categoria, stock 
	FROM producto 
    WHERE stock < (SELECT AVG(stock) FROM producto) 
    ORDER BY stock ASC; 
    
-- Cambien la categoría de productos más popular por ‘Electrónica y computación’. 
-- se utiliza una variable para guardar el valor de la categoria mas popular, para establecerlo como condición  
SET @categoria_popular = (SELECT categoria 
    FROM producto 
    GROUP BY categoria 
    ORDER BY COUNT(*) DESC LIMIT 1);
UPDATE producto SET categoria = 'Electrónica y computación' 
	WHERE categoria = @categoria_popular;
      