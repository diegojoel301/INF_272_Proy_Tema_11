---T1. Trigger_EjemplarPrestamo: Este TRIGGER se dispara antes de insertar un nuevo pr�stamo verifica que un libro no puede tener una cantidad de ejemplares en pr�stamo mayor que la cantidad total de ejemplares disponibles.
CREATE OR REPLACE TRIGGER Trigger_EjemplarPrestamo
AFTER INSERT ON Prestamo
FOR EACH ROW
DECLARE
  IdMatBiblio VARCHAR2(10);
  AvailableCount NUMBER;
  BorrowedCount NUMBER;
BEGIN
  IdMatBiblio := :NEW.id_mat_biblio;
  SELECT COUNT(*) INTO BorrowedCount
  FROM Prestamo P
  WHERE P.id_mat_biblio = IdMatBiblio
    AND P.fecha_devolucion >= SYSDATE AND estado_prestamo = 'prestado';
  SELECT COUNT(*) INTO AvailableCount
  FROM Ejemplar
  WHERE id_mat_biblio = IdMatBiblio
    AND cod_serial NOT IN (
        SELECT cod_serial
        FROM Prestamo
        WHERE id_mat_biblio = IdMatBiblio
          AND fecha_devolucion >= SYSDATE AND estado_prestamo = 'prestado'
    );

  IF BorrowedCount >= AvailableCount THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se puede realizar el préstamo. Todos los ejemplares del libro están en préstamo.');
  ELSE
    NULL;
  END IF;
END;
---T2. Trigger_PrestamoValidacion: Este trigger se dispara antes de insertar un nuevo pr�stamo en la tabla de pr�stamos. Verifica si el usuario tiene una membres�a activa en la biblioteca antes de permitir el pr�stamo.
CREATE OR REPLACE TRIGGER Trigger_PrestamoValidacion
BEFORE INSERT ON Prestamo
FOR EACH ROW
DECLARE
    MembresiaCount NUMBER;
BEGIN
    -- Verificar si el usuario tiene una membresía activa
    SELECT COUNT(*) INTO MembresiaCount
    FROM Usuario U
    INNER JOIN Lector L ON U.id_usuario = L.id_usuario
    WHERE U.id_usuario = :NEW.id_usuario
        AND L.fecha_vencimiento_membresia >= SYSDATE;
        
    IF MembresiaCount > 0 THEN
        -- Si el usuario tiene una membresía activa, permitir la inserción del nuevo préstamo
        :NEW.estado_prestamo := 'prestado';
    ELSE
        -- Si el usuario no tiene una membresía activa, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20001, 'El usuario no tiene una membresía activa. No se puede realizar el préstamo.');
    END IF;
END;
---T3. Trigger_EjemplarBiblioteca: Este TRIGGER se dispara antes de realizar un pr�stamo. Verifica que un material bibliogr�fico s�lo puede ser prestado si tiene al menos un ejemplar disponible en la biblioteca.
CREATE OR REPLACE TRIGGER Trigger_EjemplarBiblioteca
BEFORE INSERT ON Prestamo
FOR EACH ROW
DECLARE
    EjemplarCount NUMBER;
BEGIN
    -- Verificar si el material bibliográfico tiene al menos un ejemplar disponible en la biblioteca
    SELECT COUNT(*) INTO EjemplarCount
    FROM Ejemplar E
    INNER JOIN Material_bibliografico MB ON E.id_mat_biblio = MB.id_mat_biblio
    WHERE MB.id_mat_biblio = :NEW.id_mat_biblio
        AND E.cod_serial NOT IN (
            SELECT cod_serial
            FROM Prestamo
            WHERE fecha_devolucion >= SYSDATE AND estado_prestamo = 'prestado'
        );
        
    IF EjemplarCount > 0 THEN
        -- Si hay al menos un ejemplar disponible, permitir la inserción del nuevo préstamo
        :NEW.estado_prestamo := 'prestado';
    ELSE
        -- Si no hay ejemplares disponibles, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20001, 'No se puede realizar el préstamo. No hay ejemplares disponibles en la biblioteca.');
    END IF;
END;
---T4. Trigger_MaximosPrestamos: Este TRIGGER se dispara antes de realizar un pr�stamo para verificar que un determinado usuario de la tabla LECTOR no exceda el n�mero m�ximo de libros prestados.
CREATE OR REPLACE TRIGGER Trigger_MaximosPrestamos
BEFORE INSERT ON Prestamo
FOR EACH ROW
DECLARE
    IdUsuario NUMBER;
    Max_libros_prestados NUMBER := 5;
    PrestamosCount NUMBER;
BEGIN
    -- Almacenar el valor del id_usuario del nuevo registro en una variable
    IdUsuario := :NEW.id_usuario;

    -- Verificar el número máximo de libros prestados del usuario
    SELECT COUNT(*) INTO PrestamosCount
    FROM Prestamo
    WHERE id_usuario = IdUsuario
        AND fecha_devolucion >= SYSDATE AND estado_prestamo = 'prestado';

    IF PrestamosCount >= Max_libros_prestados THEN
        -- Si el usuario ha excedido el número máximo de libros prestados, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20001, 'El usuario ha excedido el número máximo de libros prestados.');
    ELSE
        -- Si el usuario no ha excedido el número máximo de libros prestados, permitir la inserción del nuevo préstamo
        :NEW.estado_prestamo := 'prestado';
    END IF;
END;
---T5. Trigger_MultaPendiente: Este TRIGGER se dispara antes de realizar un pr�stamo para verificar en la tabla MULTA que el usuario no tiene multas pendientes.
CREATE OR REPLACE TRIGGER Trigger_MultaPendiente
BEFORE INSERT ON Prestamo
FOR EACH ROW
DECLARE
    IdUsuario NUMBER;
    MultasCount NUMBER;
BEGIN
    -- Almacenar el valor del id_usuario del nuevo registro en una variable
    IdUsuario := :NEW.id_usuario;

    -- Verificar si el usuario tiene multas pendientes
    SELECT COUNT(*) INTO MultasCount
    FROM Multa
    WHERE id_usuario = IdUsuario
        AND fecha_pago IS NULL AND estado = 'sin pagar';

    IF MultasCount > 0 THEN
        -- Si el usuario tiene multas pendientes, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20001, 'El usuario tiene multas pendientes. No se puede realizar el préstamo.');
    ELSE
        -- Si el usuario no tiene multas pendientes, permitir la inserción del nuevo préstamo
        :NEW.estado_prestamo := 'prestado';
    END IF;
END;
---T6. Trigger_FechaDevolucion: Este trigger se activa antes de insertar un nuevo pr�stamo en la tabla de pr�stamos. Verifica que la fecha de devoluci�n sea posterior a la fecha de pr�stamo y realiza ajustes si es necesario.
CREATE OR REPLACE TRIGGER Trigger_FechaDevolucion
BEFORE INSERT ON Prestamo
FOR EACH ROW
DECLARE
    -- Variables locales para almacenar los valores de inserted
    v_id_mat_biblio Prestamo.id_mat_biblio%TYPE;
    v_id_usuario Prestamo.id_usuario%TYPE;
    v_fecha_prestamo Prestamo.fecha_prestamo%TYPE;
    v_fecha_devolucion Prestamo.fecha_devolucion%TYPE;
    v_estado_prestamo Prestamo.estado_prestamo%TYPE;
BEGIN
    -- Almacenar los valores de inserted en las variables locales
    v_id_mat_biblio := :NEW.id_mat_biblio;
    v_id_usuario := :NEW.id_usuario;
    v_fecha_prestamo := :NEW.fecha_prestamo;
    v_fecha_devolucion := :NEW.fecha_devolucion;
    v_estado_prestamo := :NEW.estado_prestamo;

    -- Verificar y realizar ajustes en la fecha de devolución si es necesario
    IF v_fecha_devolucion <= v_fecha_prestamo THEN
        v_fecha_devolucion := v_fecha_prestamo + INTERVAL '5' DAY; -- Se agregan 5 días a la fecha de préstamo
    END IF;

    -- Insertar el nuevo préstamo en la tabla Prestamo
    INSERT INTO Prestamo (id_mat_biblio, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
    VALUES (v_id_mat_biblio, v_id_usuario, v_fecha_prestamo, v_fecha_devolucion, v_estado_prestamo);
END;
--COMBINACION de los 6 anteriores
CREATE OR REPLACE TRIGGER Trigger_Prestamo
AFTER INSERT ON Prestamo
FOR EACH ROW
DECLARE
    IdUsuario INT;
    IdMaterialBiblio VARCHAR(10);
    MaxLibrosPrestados INT := 5;
    FechaPrestamo DATE;
    FechaDevolucion DATE;
    PrestamosPendientes INT; -- Variable para almacenar el resultado de la consulta
BEGIN
    IdUsuario := :new.id_usuario;
    IdMaterialBiblio := :new.id_mat_biblio;
    FechaPrestamo := :new.fecha_prestamo;

    -- T4 Verificar el número máximo de libros prestados del usuario
    SELECT COUNT(*)
    INTO PrestamosPendientes
    FROM Prestamo
    WHERE id_usuario = IdUsuario
      AND fecha_devolucion >= SYSDATE

      AND estado_prestamo = 'prestado';

    IF PrestamosPendientes >= MaxLibrosPrestados THEN
        -- Si el usuario ha excedido el número máximo de libros prestados, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20001, 'El usuario ha excedido el número máximo de libros prestados.');
    END IF;

    -- T2 Verificar si el usuario tiene una membresía activa
    SELECT COUNT(*)
    INTO PrestamosPendientes
    FROM Usuario U
    INNER JOIN Lector L ON U.id_usuario = L.id_usuario
    WHERE U.id_usuario = IdUsuario
      AND L.fecha_vencimiento_membresia >= SYSDATE;

    IF PrestamosPendientes = 0 THEN
        -- Si el usuario no tiene una membresía activa, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20002, 'El usuario no tiene una membresía activa. No se puede realizar el préstamo.');
    END IF;

    -- T3 y T1 Verificar si el material bibliográfico tiene al menos un ejemplar disponible en la biblioteca
    SELECT COUNT(*)
    INTO PrestamosPendientes
    FROM Ejemplar E
    INNER JOIN Material_bibliografico MB ON E.id_mat_biblio = MB.id_mat_biblio
    WHERE MB.id_mat_biblio = IdMaterialBiblio
      AND E.cod_serial NOT IN (
          SELECT cod_serial
          FROM Prestamo
          WHERE fecha_devolucion >= SYSDATE
            AND estado_prestamo = 'prestado'
      );

    IF PrestamosPendientes = 0 THEN
        -- Si no hay ejemplares disponibles, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20003, 'No se puede realizar el préstamo. No hay ejemplares disponibles en la biblioteca.');
    END IF;

    -- T5 Verificar si el usuario tiene multas pendientes
    SELECT COUNT(*)
    INTO PrestamosPendientes
    FROM Multa
    WHERE id_usuario = IdUsuario
      AND fecha_pago IS NULL
      AND estado = 'sin pagar';

    IF PrestamosPendientes > 0 THEN
        -- Si el usuario tiene multas pendientes, generar un error y realizar un rollback de la transacción
        RAISE_APPLICATION_ERROR(-20004, 'El usuario tiene multas pendientes. No se puede realizar el préstamo.');
    END IF;

    -- T6 Verificar y realizar ajustes en la fecha de devolución si es necesario
    FechaDevolucion := CASE
        WHEN :new.fecha_devolucion <= FechaPrestamo THEN FechaPrestamo + 5 -- Se agregan 5 días a la fecha de préstamo
        ELSE :new.fecha_devolucion
    END;

    -- Actualizar la fecha de devolución en la tabla Prestamo
    UPDATE Prestamo
    SET fecha_devolucion = FechaDevolucion
    WHERE id_usuario = IdUsuario
      AND id_mat_biblio = IdMaterialBiblio;
      
    COMMIT;
END;