
---T1. Trigger_EjemplarPrestamo: Este TRIGGER se dispara antes de insertar un nuevo pr�stamo verifica que un libro no puede tener una cantidad de ejemplares en pr�stamo mayor que la cantidad total de ejemplares disponibles.
DELIMITER $$
CREATE TRIGGER Trigger_EjemplarPrestamo BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Almacenar el valor de id_material_biblio de la fila a insertar en una variable
    DECLARE IdMaterialBiblio VARCHAR(10);

    SET IdMaterialBiblio = NEW.id_material_biblio;

    -- Verificar si la cantidad de ejemplares en préstamo del libro es mayor que la cantidad de ejemplares disponibles
    IF (
        SELECT COUNT(*)
        FROM Prestamo AS P
        WHERE P.id_material_biblio = IdMaterialBiblio
          AND P.fecha_devolucion >= CURDATE() AND estado_prestamo LIKE 'prestado'
      ) >= (
        SELECT COUNT(*)
        FROM Ejemplar
        WHERE id_material_biblio = IdMaterialBiblio
          AND cod_serial NOT IN (
              SELECT cod_serial
              FROM Prestamo
              WHERE id_material_biblio = IdMaterialBiblio
                AND fecha_devolucion >= CURDATE() AND estado_prestamo LIKE 'prestado'
          )
      )
    THEN
        -- Si no hay ejemplares disponibles, se genera un error y se realiza un rollback de la transacción
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede realizar el préstamo. Todos los ejemplares del libro están en préstamo.';
    ELSE
        -- Si hay ejemplares disponibles, se realiza la inserción del nuevo registro en la tabla Prestamo
        INSERT INTO Prestamo (id_material_biblio, fecha_prestamo, fecha_devolucion, estado_prestamo)
        VALUES (NEW.id_material_biblio, NEW.fecha_prestamo, NEW.fecha_devolucion, 'prestado');
    END IF;
END$$
DELIMITER ;


---T2. Trigger_PrestamoValidacion: Este trigger se dispara antes de insertar un nuevo pr�stamo en la tabla de pr�stamos. Verifica si el usuario tiene una membres�a activa en la biblioteca antes de permitir el pr�stamo.
DELIMITER $$
CREATE TRIGGER Trigger_PrestamoValidacion BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Verificar si el usuario tiene una membresía activa
    IF EXISTS (
        SELECT 1  --más eficiente que SELECT *
        FROM Usuario AS U
        INNER JOIN Lector AS L ON U.id_usuario = L.id_usuario
        WHERE U.id_usuario = NEW.id_usuario
          AND L.fecha_vencimiento_membresia >= CURDATE()
    )
    THEN
        -- Si el usuario tiene una membresía activa, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        VALUES (NEW.id_material_biblio, NEW.id_usuario, NEW.fecha_prestamo, NEW.fecha_devolucion, 'prestado');
    ELSE
        -- Si el usuario no tiene una membresía activa, generar un error y realizar un rollback de la transacción
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no tiene una membresía activa. No se puede realizar el préstamo.';
    END IF;
END$$
DELIMITER ;


---T3. Trigger_EjemplarBiblioteca: Este TRIGGER se dispara antes de realizar un pr�stamo. Verifica que un material bibliogr�fico s�lo puede ser prestado si tiene al menos un ejemplar disponible en la biblioteca.
DELIMITER $$
CREATE TRIGGER Trigger_EjemplarBiblioteca BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Verificar si el material bibliográfico tiene al menos un ejemplar disponible en la biblioteca
    IF EXISTS (
        SELECT 1 ---Mas eficiente que SELECT *
        FROM Ejemplar AS E
        INNER JOIN Material_bibliografico AS MB ON E.id_material_biblio = MB.id_material_biblio
        WHERE MB.id_material_biblio = NEW.id_material_biblio
          AND E.cod_serial NOT IN (
              SELECT cod_serial
              FROM Prestamo
              WHERE fecha_devolucion >= CURDATE() AND estado_prestamo LIKE 'prestado'
          )
    )
    THEN
        -- Si hay al menos un ejemplar disponible, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        VALUES (NEW.id_material_biblio, NEW.id_usuario, NEW.fecha_prestamo, NEW.fecha_devolucion, 'prestado');
    ELSE
        -- Si no hay ejemplares disponibles, generar un error y realizar un rollback de la transacción
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede realizar el préstamo. No hay ejemplares disponibles en la biblioteca.';
    END IF;
END$$
DELIMITER ;

---T4. Trigger_MaximosPrestamos: Este TRIGGER se dispara antes de realizar un pr�stamo para verificar que un determinado usuario de la tabla LECTOR no exceda el n�mero m�ximo de libros prestados.
DELIMITER $$
CREATE TRIGGER Trigger_MaximosPrestamos BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Almacenar el valor del id_usuario de la tabla inserted en una variable
    DECLARE IdUsuario INT;
    DECLARE Max_libros_prestados INT DEFAULT 5;
    
    SET IdUsuario = NEW.id_usuario;
    
    -- Verificar el número máximo de libros prestados del usuario
    IF (
        SELECT COUNT(*)
        FROM Prestamo
        WHERE id_usuario = IdUsuario
          AND fecha_devolucion >= CURDATE() AND estado_prestamo LIKE 'prestado'
    ) >= Max_libros_prestados
    THEN
        -- Si el usuario ha excedido el número máximo de libros prestados, generar un error y realizar un rollback de la transacción
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario ha excedido el número máximo de libros prestados.';
    ELSE
        -- Si el usuario no ha excedido el número máximo de libros prestados, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        VALUES (NEW.id_material_biblio, NEW.id_usuario, NEW.fecha_prestamo, NEW.fecha_devolucion, 'prestado');
    END IF;
END$$
DELIMITER ;

---T5. Trigger_MultaPendiente: Este TRIGGER se dispara antes de realizar un pr�stamo para verificar en la tabla MULTA que el usuario no tiene multas pendientes.
DELIMITER $$
CREATE TRIGGER Trigger_MultaPendiente BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Almacenar el valor del id_usuario de la tabla inserted en una variable
    DECLARE IdUsuario INT;
    
    SET IdUsuario = NEW.id_usuario;
    
    -- Verificar si el usuario tiene multas pendientes
    IF EXISTS (
        SELECT 1
        FROM Multa
        WHERE id_usuario = IdUsuario
          AND fecha_pago IS NULL AND estado = 'sin pagar'
    ) THEN
        -- Si el usuario tiene multas pendientes, generar un error y realizar un rollback de la transacción
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario tiene multas pendientes. No se puede realizar el préstamo.';
    ELSE
        -- Si el usuario no tiene multas pendientes, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        VALUES (NEW.id_material_biblio, NEW.id_usuario, NEW.fecha_prestamo, NEW.fecha_devolucion, 'prestado');
    END IF;
END$$
DELIMITER ;

---T6. Trigger_FechaDevolucion: Este trigger se activa antes de insertar un nuevo pr�stamo en la tabla de pr�stamos. Verifica que la fecha de devoluci�n sea posterior a la fecha de pr�stamo y realiza ajustes si es necesario.
DELIMITER $$
CREATE TRIGGER Trigger_FechaDevolucion BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    -- Verificar y realizar ajustes en la fecha de devolución si es necesario
    IF NEW.fecha_devolucion <= NEW.fecha_prestamo THEN
        SET NEW.fecha_devolucion = DATE_ADD(NEW.fecha_prestamo, INTERVAL 5 DAY); -- Se agregan 5 días a la fecha de préstamo
    END IF;
END$$
DELIMITER ;


--COMBINACION de los 6 anteriores
DELIMITER //

DELIMITER //

CREATE TRIGGER Trigger_Prestamo
BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    DECLARE IdUsuario INT;
    DECLARE IdMaterialBiblio VARCHAR(10);
    DECLARE MaxLibrosPrestados INT DEFAULT 5;

    SELECT id_usuario, id_material_biblio INTO IdUsuario, IdMaterialBiblio
    FROM inserted;

    -- Resto del código del trigger...

    -- Insertar el nuevo préstamo en la tabla Prestamo
    INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
    SELECT id_material_biblio, id_usuario, fecha_prestamo, FechaDevolucion, 'prestado'
    FROM inserted;
END //

DELIMITER ;

