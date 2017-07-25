
CREATE DATABASE AgendaCool;
USE AgendaCool;

CREATE TABLE Usuario(
	usuario_id INT AUTO_INCREMENT NOT NULL,
    usuario_nick VARCHAR(30) NOT NULL,
    usuario_pass VARCHAR(30) NOT NULL,
    PRIMARY KEY(usuario_id)
);

CREATE TABLE Tipo(
	tipo_id INT AUTO_INCREMENT NOT NULL,
    tipo_descripcion VARCHAR(50) NOT NULL,
    PRIMARY KEY(tipo_id)
);

CREATE TABLE Contacto(
	contacto_id INT AUTO_INCREMENT NOT NULL,
    contacto_nombre VARCHAR(50) NOT NULL,
    contacto_apellido VARCHAR(50) NOT NULL,
    contacto_direccion VARCHAR(50) NOT NULL,
    contacto_telefono VARCHAR(50) NOT NULL,
    contacto_correo VARCHAR(50) NOT NULL,
    contacto_tipo INT NOT NULL,
    PRIMARY KEY(contacto_id),
    FOREIGN KEY(contacto_tipo) REFERENCES Tipo(tipo_id) ON DELETE CASCADE
);

CREATE TABLE UsuarioDetalle(
	usuarioDetalle_id INT AUTO_INCREMENT NOT NULL,
    usuarioDetalle_usuario INT NOT NULL,
    usuarioDetalle_contacto INT NOT NULL,
    PRIMARY KEY(usuarioDetalle_id),
    FOREIGN KEY(usuarioDetalle_usuario) REFERENCES Usuario(usuario_id) ON DELETE CASCADE,
    FOREIGN KEY(usuarioDetalle_contacto) REFERENCES Contacto(contacto_id) ON DELETE CASCADE
);

CREATE TABLE Tarea(
	tarea_id INT AUTO_INCREMENT NOT NULL,
    tarea_descripcion VARCHAR(255) NOT NULL,
    tarea_fecha DATETIME NOT NULL,
    tarea_inicio DATETIME NOT NULL,
    tarea_fin DATETIME NOT NULL,
    tarea_estado VARCHAR(25) NOT NULL,
    tarea_usuario INT NOT NULL,
    PRIMARY KEY(tarea_id),
    FOREIGN KEY(tarea_usuario) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Historial(
	historial_id INT AUTO_INCREMENT NOT NULL,
    historial_usuario INT NOT NULL,
    historial_fecha DATETIME NOT NULL,
    historial_detalle VARCHAR(255) NOT NULL,
    PRIMARY KEY(historial_id),
    FOREIGN KEY(historial_usuario) REFERENCES Usuario(usuario_id) ON DELETE CASCADE
);

CREATE TABLE Cita(
	cita_id INT AUTO_INCREMENT NOT NULL,
    cita_fecha DATETIME NOT NULL,
    cita_lugar VARCHAR(255) NOT NULL,
    cita_asunto VARCHAR(255) NOT NULL,
    cita_contacto INT NOT NULL,
    cita_usuario INT NOT NULL,
    PRIMARY KEY(cita_id),
    FOREIGN KEY(cita_usuario) REFERENCES Usuario(usuario_id) ON DELETE CASCADE,
    FOREIGN KEY(cita_contacto) REFERENCES Contacto(contacto_id) ON DELETE CASCADE
);

DROP PROCEDURE IF EXISTS `SP_AgregarCita`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarCita`(
	IN fecha datetime,
    IN lugar VARCHAR(255),
    IN asunto VARCHAR(255),
    IN contacto INT,
    IN usuario INT)
BEGIN
	INSERT INTO Cita(cita_fecha, cita_lugar, 
		cita_asunto, cita_contacto, cita_usuario)
        VALUES (fecha, lugar, asunto, contacto, usuario);
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS `SP_AgregarTipo`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarTipo`(
	IN descripcion VARCHAR(50))
BEGIN
	INSERT INTO Tipo(tipo_descripcion) VALUES(descripcion);
END$$
DELIMITER ;

-- //////////////////////////////////////////////////
-- PROCEDIMIENTOS
-- AGREGAR USUARIO
DROP PROCEDURE IF EXISTS `SP_AgregarUsuario`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarUsuario`(
	IN nick VARCHAR(30),
    IN pass VARCHAR(30))
BEGIN
	INSERT INTO Usuario(usuario_nick, usuario_pass) VALUES(nick, pass);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `SP_AgregarEstado`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarEstado`(
	IN descripcion VARCHAR(50))
BEGIN
	INSERT INTO Estado(estado_descripcion) VALUES(descripcion);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `SP_AgregarTarea`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarTarea`(
	IN descripcion VARCHAR(255),
    IN inicio DATETIME,
    IN final DATETIME,
    IN estado varchar(25),
    IN usuario INT)
BEGIN
    INSERT INTO Tarea(tarea_descripcion, tarea_fecha, tarea_inicio, tarea_fin, tarea_estado, tarea_usuario) VALUES(descripcion, inicio, now(), final, estado, usuario);
END$$
DELIMITER ;

-- MODIFICAR USUARIO
DROP PROCEDURE IF EXISTS `SP_ModificarUsuario`;
DELIMITER $$
CREATE PROCEDURE `SP_ModificarUsuario`(
	IN nick VARCHAR(30),
    IN pass VARCHAR(30),
    in id INT)
BEGIN
	UPDATE Usuario SET usuario_nick = nick, usuario_pass = pass WHERE usuario_id = id;
END $$
DELIMITER ;

-- ELIMINAR USUARIO
DROP PROCEDURE IF EXISTS `SP_EliminarUsuario`;
DELIMITER $$
CREATE PROCEDURE `SP_EliminarUsuario`(
	IN id INT)
BEGIN
	DELETE FROM Usuario WHERE usuario_id = id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `SP_AgregarContacto`;
DELIMITER $$
CREATE PROCEDURE `SP_AgregarContacto`(
	IN nombre VARCHAR(30),
    IN apellido VARCHAR(30),
    IN direccion VARCHAR(30),
    IN telefono VARCHAR(12),
    IN correo VARCHAR(40),
    IN tipo INT,
    IN usuario_id INT)
BEGIN
	INSERT INTO Contacto(contacto_nombre, contacto_apellido, 
		contacto_direccion, contacto_telefono, contacto_correo, contacto_tipo)
        VALUES (nombre, apellido, direccion, telefono, correo, tipo);
	INSERT INTO UsuarioDetalle(usuarioDetalle_usuario, usuarioDetalle_contacto)
		VALUES (usuario_id, Last_Insert_id());
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `SP_ModificarContacto`;
DELIMITER $$ 
CREATE PROCEDURE `SP_ModificarContacto`(
	IN id INT,
	IN nombre VARCHAR(30),
    IN apellido VARCHAR(30),
    IN direccion VARCHAR(30),
    IN telefono VARCHAR(12),
    IN correo VARCHAR(40),
    IN tipo INT)
BEGIN
	UPDATE Contacto SET contacto_nombre = nombre, contacto_apellido = apellido, 
		contacto_direccion = direccion, contacto_telefono = telefono, contacto_correo = correo, 
		contacto_tipo = tipo WHERE contacto_id = id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `SP_EliminarContacto`;
DELIMITER $$
CREATE PROCEDURE `SP_EliminarContacto` (
    IN contacto INT)
BEGIN

	DELETE FROM Contacto WHERE contacto_id = contacto;
END $$

DROP PROCEDURE IF EXISTS `SP_MostrarContactos`;
DELIMITER $$
CREATE PROCEDURE `SP_MostrarContactos` (
    IN usuario INT)
BEGIN
	SELECT Contacto.contacto_id, contacto_nombre, contacto_apellido, contacto_direccion, contacto_telefono, contacto_correo, contacto_tipo
	FROM UsuarioDetalle INNER JOIN Contacto on UsuarioDetalle.usuarioDetalle_contacto = Contacto.contacto_id 
	INNER JOIN Tipo on contacto.contacto_tipo = Tipo.tipo_id WHERE UsuarioDetalle.usuarioDetalle_usuario = usuario;
END $$


-- //////////////////////////////////////////////////
-- TRIGGERS
-- AGREGAR CONTACTO
DROP TRIGGER IF EXISTS TG_AgregarContacto;
DELIMITER $$
CREATE TRIGGER TG_AgregarContacto 
	AFTER INSERT ON UsuarioDetalle
	FOR EACH ROW   
BEGIN
    SET @Datos = (SELECT CONCAT(contacto_nombre, ' ', contacto_apellido) 
		FROM Contacto WHERE contacto_id = NEW.usuarioDetalle_contacto);
    INSERT INTO historial(historial_usuario, historial_fecha, historial_detalle)
		VALUES (NEW.usuarioDetalle_usuario, now(), CONCAT('Se agrego el contacto: ',  @Datos));
END$$
DELIMITER ;

	

-- MODIFICAR USUARIO
DROP TRIGGER IF EXISTS TG_ModificarUsuario;
DELIMITER $$
CREATE TRIGGER TG_ModificarUsuario 
	BEFORE UPDATE ON Usuario
    FOR EACH ROW   
BEGIN
    INSERT INTO Historial(historial_usuario, historial_fecha, historial_detalle)
		VALUES (OLD.usuario_id, now(), 'Se ha modifico el nombre de usuario y/o contraseña');
END$$
DELIMITER ;


CALL SP_AgregarTipo("Trabajo");
CALL SP_AgregarTipo("Amigos");
CALL SP_AgregarTipo("Familia");
CALL SP_AgregarTipo("Universidad");
SELECT * FROM Tipo;

CALL SP_AgregarUsuario("soy.david", "1234");
CALL SP_AgregarUsuario("david15", "1234");
CALL SP_AgregarUsuario("so.wavey", "1234");
CALL SP_AgregarUsuario("maradona", "1234");
SELECT * FROM Usuario;

CALL SP_AgregarContacto("Luis", "Garcia", "Guatemala, zona 14", "5883-46321", "luis@email.com", 3, 1);
CALL SP_AgregarContacto("Mario", "Subuyuj", "Guatemala, zona 12", "6234-6543", "mario@email.com", 2, 1);
CALL SP_AgregarContacto("David", "Galindo", "Antigua Guatemala", "5356-3997", "david@email.com", 1, 1);
CALL SP_AgregarContacto("Pat", "Morrisey", "London", "4565-3422", "pat@email.com", 1, 1);

CALL SP_AgregarContacto("Jorge", "Guerra", "Guatemala, zona 15", "9873-6753", "jorge@email.com", 2, 2);
CALL SP_AgregarContacto("Didier", "Dominguez", "Guatemala, zona 11", "9754-3257", "didier@email.com", 4, 2);
CALL SP_AgregarContacto("Juan", "Campos", "Guatemala, zona 3", "3457-4562", "juan@email.com", 1, 2);

CALL SP_AgregarContacto("Roberto", "Solorzano", "Guatemala, zona 9", "8874-26754", "roberto@email.com", 4, 3);
CALL SP_AgregarContacto("Daniel", "Lucas", "Guatemala, zona 12", "3853-5783", "daniel@email.com", 2, 3);
CALL SP_AgregarContacto("Josh", "Antoin", "California, China Town #1", "4522-4234", "josh@email.com", 1, 3);

CALL SP_AgregarTarea("Terminar", now(), now(), "Pendiente", 1);
CALL SP_AgregarTarea("Tarea de Arreaza",  now(), now(), "Iniciado", 1);
CALL SP_AgregarTarea("Proyecto de Huertas", now(), now(), "Pendiente", 1);
CALL SP_AgregarTarea("Hacer mi cama", now(),now(), "Finalizado", 2);
CALL SP_AgregarTarea("Convertirme en un dj gacho famoso", now(), now(), "Iniciado", 2);
CALL SP_AgregarTarea("Llamarle y pedirle salir conmigo", now(), now(), "Pendiente", 3);
CALL SP_AgregarTarea("Hacer los ejercicios de mate", now(), now(), "Iniciado", 3);
CALL SP_AgregarTarea("Copiar la tarea en clase", now(), now(), "Pendiente", 4);


CALL SP_AgregarCita(now(), "Mi Casa", "Reunion Amorosa", 2, 1);
CALL SP_AgregarCita(now(), "La Calle", "Partido", 1, 1);
CALL SP_AgregarCita(now(), "La Escuela", "Clases", 2, 2);
CALL SP_AgregarCita(now(), "Mi Casa", "Final del mundial", 2, 2);
