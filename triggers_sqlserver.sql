
---T1. Trigger_EjemplarPrestamo: Este TRIGGER se dispara antes de insertar un nuevo préstamo verifica que un libro no puede tener una cantidad de ejemplares en préstamo mayor que la cantidad total de ejemplares disponibles.
CREATE TRIGGER Trigger_EjemplarPrestamo
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    -- Almacenar el valor de id_material_biblio de la tabla inserted en una variable
    DECLARE @IdMaterialBiblio VARCHAR(10);

    SELECT @IdMaterialBiblio = id_material_biblio
    FROM inserted;

    -- Verificar si la cantidad de ejemplares en préstamo del libro es mayor que la cantidad de ejemplares disponibles
    IF (
        SELECT COUNT(*)
        FROM Prestamo AS P
        WHERE P.id_material_biblio = @IdMaterialBiblio
          AND P.fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
      ) >= (
        SELECT COUNT(*)
        FROM Ejemplar
        WHERE id_material_biblio = @IdMaterialBiblio
          AND cod_serial NOT IN (
              SELECT cod_serial
              FROM Prestamo
              WHERE id_material_biblio = @IdMaterialBiblio
                AND fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
          )
      )
    BEGIN
        -- Si no hay ejemplares disponibles, se genera un error y se realiza un rollback de la transacción
        RAISERROR('No se puede realizar el préstamo. Todos los ejemplares del libro están en préstamo.', 16, 1); ---NIvel y tipo de error
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Si hay ejemplares disponibles, se realiza la inserción del nuevo registro en la tabla Prestamo
        INSERT INTO Prestamo (id_material_biblio, fecha_prestamo, fecha_devolucion, estado_prestamo)
        SELECT id_material_biblio, fecha_prestamo, fecha_devolucion, 'prestado'
        FROM inserted;
    END
END

---T2. Trigger_PrestamoValidacion: Este trigger se dispara antes de insertar un nuevo préstamo en la tabla de préstamos. Verifica si el usuario tiene una membresía activa en la biblioteca antes de permitir el préstamo.
CREATE TRIGGER Trigger_PrestamoValidacion
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si el usuario tiene una membresía activa
    IF EXISTS (
        SELECT 1  --mas eficiente que SELECT *
        FROM Usuario AS U
        INNER JOIN Lector AS L ON U.id_usuario = L.id_usuario
        WHERE U.id_usuario = (SELECT id_usuario FROM inserted)
          AND L.fecha_vencimiento_membresia >= GETDATE()
    )
    BEGIN
        -- Si el usuario tiene una membresía activa, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, 'prestado'
        FROM inserted;
    END
    ELSE
    BEGIN
        -- Si el usuario no tiene una membresía activa, generar un error y realizar un rollback de la transacción
        RAISERROR('El usuario no tiene una membresía activa. No se puede realizar el préstamo.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

---T3. Trigger_EjemplarBiblioteca: Este TRIGGER se dispara antes de realizar un préstamo. Verifica que un material bibliográfico sólo puede ser prestado si tiene al menos un ejemplar disponible en la biblioteca.
CREATE TRIGGER Trigger_EjemplarBiblioteca
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si el material bibliográfico tiene al menos un ejemplar disponible en la biblioteca
    IF EXISTS (
        SELECT 1 ---Mas eficiente que SELECT *
        FROM Ejemplar AS E
        INNER JOIN Material_bibliografico AS MB ON E.id_material_biblio = MB.id_material_biblio
        WHERE MB.id_material_biblio = (SELECT id_material_biblio FROM inserted)
          AND E.cod_serial NOT IN (
              SELECT cod_serial
              FROM Prestamo
              WHERE fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
          )
    )
    BEGIN
        -- Si hay al menos un ejemplar disponible, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, 'prestado'
        FROM inserted;
    END
    ELSE
    BEGIN
        -- Si no hay ejemplares disponibles, generar un error y realizar un rollback de la transacción
        RAISERROR('No se puede realizar el préstamo. No hay ejemplares disponibles en la biblioteca.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
---T4. Trigger_MaximosPrestamos: Este TRIGGER se dispara antes de realizar un préstamo para verificar que un determinado usuario de la tabla LECTOR no exceda el número máximo de libros prestados.
CREATE TRIGGER Trigger_MaximosPrestamos
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    -- Almacenar el valor del id_usuario de la tabla inserted en una variable
    DECLARE @IdUsuario INT;
	DECLARE @Max_libros_prestados INT = 5;

    SELECT @IdUsuario = id_usuario
    FROM inserted;

    -- Verificar el número máximo de libros prestados del usuario
    IF (
        SELECT COUNT(*)
        FROM Prestamo
        WHERE id_usuario = @IdUsuario
          AND fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
    ) >= (
         @Max_libros_prestados
    )
    BEGIN
        -- Si el usuario ha excedido el número máximo de libros prestados, generar un error y realizar un rollback de la transacción
        RAISERROR('El usuario ha excedido el número máximo de libros prestados.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Si el usuario no ha excedido el número máximo de libros prestados, permitir la inserción del nuevo préstamo
        INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
        SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, 'prestado'
        FROM inserted;
    END
END
---T5. Trigger_MultaPendiente: Este TRIGGER se dispara antes de realizar un préstamo para verificar en la tabla MULTA que el usuario no tiene multas pendientes.
CREATE TRIGGER Trigger_MultaPendiente
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @IdUsuario INT;
	SELECT @IdUsuario = id_usuario
	FROM inserted;

	-- Verificar si el usuario tiene multas pendientes
	IF EXISTS (
		SELECT 1
		FROM Multa
		WHERE id_usuario = @IdUsuario
		  AND fecha_pago IS NULL AND estado = 'sin pagar'
	)
	BEGIN
		-- Si el usuario tiene multas pendientes, generar un error y realizar un rollback de la transacción
		RAISERROR('El usuario tiene multas pendientes. No se puede realizar el préstamo.', 16, 1);
		ROLLBACK TRANSACTION;
	END
	ELSE
	BEGIN
		-- Si el usuario no tiene multas pendientes, permitir la inserción del nuevo préstamo
		INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
		SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, 'prestado'
		FROM inserted;
	END
END
---T6. Trigger_FechaDevolucion: Este trigger se activa antes de insertar un nuevo préstamo en la tabla de préstamos. Verifica que la fecha de devolución sea posterior a la fecha de préstamo y realiza ajustes si es necesario.
CREATE TRIGGER Trigger_FechaDevolucion
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    -- Crear una tabla temporal para almacenar las filas de inserted
    DECLARE @TempTable TABLE (
        id_material_biblio INT,
        id_usuario INT,
        fecha_prestamo DATE,
        fecha_devolucion DATE,
        estado_prestamo VARCHAR(20)
    );

    -- Insertar las filas de inserted en la tabla temporal
    INSERT INTO @TempTable (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
    SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, 'prestado'
    FROM inserted;

    -- Verificar y realizar ajustes en la fecha de devolución si es necesario
    UPDATE @TempTable
    SET fecha_devolucion = CASE
        WHEN fecha_devolucion <= fecha_prestamo THEN DATEADD(DAY, 5, fecha_prestamo) -- Se agregan 5 días a la fecha de préstamo
        ELSE fecha_devolucion
    END;

    -- Insertar el nuevo préstamo en la tabla Prestamo
    INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
    SELECT id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo
    FROM @TempTable;
END

--COMBINACION de los 6 anteriores
CREATE TRIGGER Trigger_Prestamo
ON Prestamo
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @IdUsuario INT;
    DECLARE @IdMaterialBiblio VARCHAR(10);
    DECLARE @MaxLibrosPrestados INT = 5;

    SELECT @IdUsuario = id_usuario, @IdMaterialBiblio = id_material_biblio
    FROM inserted;

    -- T4 Verificar el número máximo de libros prestados del usuario
    IF (
        SELECT COUNT(*)
        FROM Prestamo
        WHERE id_usuario = @IdUsuario
          AND fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
    ) >= @MaxLibrosPrestados
    BEGIN
        -- Si el usuario ha excedido el número máximo de libros prestados, generar un error y realizar un rollback de la transacción
        RAISERROR('El usuario ha excedido el número máximo de libros prestados.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- T2 Verificar si el usuario tiene una membresía activa
    IF NOT EXISTS (
        SELECT 1
        FROM Usuario AS U
        INNER JOIN Lector AS L ON U.id_usuario = L.id_usuario
        WHERE U.id_usuario = @IdUsuario
          AND L.fecha_vencimiento_membresia >= GETDATE()
    )
    BEGIN
        -- Si el usuario no tiene una membresía activa, generar un error y realizar un rollback de la transacción
        RAISERROR('El usuario no tiene una membresía activa. No se puede realizar el préstamo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- T3 y T1 Verificar si el material bibliográfico tiene al menos un ejemplar disponible en la biblioteca
    IF NOT EXISTS (
        SELECT 1
        FROM Ejemplar AS E
        INNER JOIN Material_bibliografico AS MB ON E.id_material_biblio = MB.id_material_biblio
        WHERE MB.id_material_biblio = @IdMaterialBiblio
          AND E.cod_serial NOT IN (
              SELECT cod_serial
              FROM Prestamo
              WHERE fecha_devolucion >= GETDATE() AND estado_prestamo LIKE 'prestado'
          )
    )
    BEGIN
        -- Si no hay ejemplares disponibles, generar un error y realizar un rollback de la transacción
        RAISERROR('No se puede realizar el préstamo. No hay ejemplares disponibles en la biblioteca.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- T5 Verificar si el usuario tiene multas pendientes
    IF EXISTS (
        SELECT 1
        FROM Multa
        WHERE id_usuario = @IdUsuario
          AND fecha_pago IS NULL AND estado = 'sin pagar'
    )
    BEGIN
        -- Si el usuario tiene multas pendientes, generar un error y realizar un rollback de la transacción
        RAISERROR('El usuario tiene multas pendientes. No se puede realizar el préstamo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Almacenar el valor de la fecha de préstamo de la tabla inserted en una variable
    DECLARE @FechaPrestamo DATE;
    SELECT @FechaPrestamo = fecha_prestamo
    FROM inserted;

    -- T6 Verificar y realizar ajustes en la fecha de devolución si es necesario
    DECLARE @FechaDevolucion DATE;
    SET @FechaDevolucion = (
        SELECT CASE
            WHEN fecha_devolucion <= @FechaPrestamo THEN DATEADD(DAY, 5, @FechaPrestamo) -- Se agregan 5 días a la fecha de préstamo
            ELSE fecha_devolucion
        END
        FROM inserted
    );

    -- Insertar el nuevo préstamo en la tabla Prestamo
    INSERT INTO Prestamo (id_material_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
    SELECT id_material_biblio, id_usuario, fecha_prestamo, @FechaDevolucion, 'prestado'
    FROM inserted;
END

--- T7. Trigger_PrestamoVencido: Este TRIGGER se dispara regularmente para verificar regularmente si hay préstamos vencidos de la tabla PRESTAMO e insertarlos en la tabla MULTAS.