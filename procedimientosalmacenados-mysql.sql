---PA1. SP_BusquedaLibros:
---Este procedimiento acepta par�metros de b�squeda y devuelve una lista de libros que coinciden con los criterios de b�squeda configurados.
DELIMITER //

CREATE PROCEDURE SP_BusquedaLibros (
    IN Titulo VARCHAR(100),
    IN Autor VARCHAR(100),
    IN Editorial VARCHAR(100)
)
BEGIN
    SELECT
        MB.titulo_material_bibliografico AS `Título del Libro`,
        A.autores AS `Autores`,
        E.nombre_editorial AS `Editorial`
    FROM
        Material_bibliografico AS MB
        LEFT JOIN (
            SELECT
                EP.id_material_biblio,
                GROUP_CONCAT(A.`nombre(s)` SEPARATOR ', ') AS autores
            FROM
                escrito_por AS EP
                INNER JOIN Autor AS A ON EP.id_autor = A.id_autor
            GROUP BY
                EP.id_material_biblio
        ) AS A ON MB.id_material_biblio = A.id_material_biblio
        LEFT JOIN Editorial AS E ON MB.id_editorial = E.id_editorial
    WHERE
        (Titulo IS NULL OR MB.titulo_material_bibliografico LIKE CONCAT('%', Titulo, '%'))
        AND (Autor IS NULL OR A.autores LIKE CONCAT('%', Autor, '%'))
        AND (Editorial IS NULL OR E.nombre_editorial LIKE CONCAT('%', Editorial, '%'));
END //

DELIMITER ;



---PA2. SP_ListadosLectura:
---Este procedimiento recibe como entrada el identificador del usuario y devuelve un listado de los libros que el usuario ha marcado como lectura.
DELIMITER //

CREATE PROCEDURE SP_ListadosLectura (
    IN IdUsuario VARCHAR(10)
)
BEGIN
    SELECT
        MB.titulo_material_bibliografico AS `Título del Libro`,
        A.autores AS `Autores`,
        E.nombre_editorial AS `Editorial`
    FROM
        Prestamo AS P
        INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
        LEFT JOIN (
            SELECT
                EP.id_material_biblio,
                GROUP_CONCAT(A.`nombre(s)` SEPARATOR ', ') AS autores
            FROM
                escrito_por AS EP
                INNER JOIN Autor AS A ON EP.id_autor = A.id_autor
            GROUP BY
                EP.id_material_biblio
        ) AS A ON MB.id_material_biblio = A.id_material_biblio
        LEFT JOIN Editorial AS E ON MB.id_editorial = E.id_editorial
    WHERE
        P.id_usuario = IdUsuario AND P.estado_prestamo = 'devuelto';
END //

DELIMITER ;



---PA3. SP_AgregarAdquisicion:
---Este procedimiento permite agregar una nueva adquisici�n a la base de datos, incluyendo informaci�n de presupuesto e informaci�n de tasaci�n.




---PA4. SP_GestionSedes: Este procedimiento permite administrar las sedes de la biblioteca, incluyendo la capacidad de agregar, modificar o eliminar sedes.
DELIMITER //

CREATE PROCEDURE SP_GestionSedes (
    IN Accion VARCHAR(10), -- Valores posibles: 'Agregar', 'Modificar', 'Eliminar'
    IN IdSede VARCHAR(10),
    IN NombreSede VARCHAR(50),
    IN PaisSede VARCHAR(15),
    IN CiudadSede VARCHAR(85),
    IN AvenidaCalle VARCHAR(85),
    IN NumeroSede INT,
    IN Capacidad INT
)
BEGIN
    IF Accion = 'Agregar' THEN
        -- Verificar si la sede ya existe
        IF EXISTS (SELECT 1 FROM Sede WHERE id_Sede = IdSede) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sede ya existe.';
            RETURN;
        END IF;

        -- Insertar la nueva sede
        INSERT INTO Sede (id_Sede, nombre_sede, pais_Sede, ciudad_Sede, avenida_calle, numero_sede, capacidad_sede)
        VALUES (IdSede, NombreSede, PaisSede, CiudadSede, AvenidaCalle, NumeroSede, Capacidad);

        SELECT 'La sede se ha agregado correctamente.' AS Mensaje;
    ELSEIF Accion = 'Modificar' THEN
        -- Verificar si la sede existe
        IF NOT EXISTS (SELECT 1 FROM Sede WHERE id_Sede = IdSede) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sede no existe.';
            RETURN;
        END IF;

        -- Modificar la sede
        UPDATE Sede
        SET nombre_sede = NombreSede, pais_Sede = PaisSede, ciudad_Sede = CiudadSede, avenida_calle = AvenidaCalle, numero_sede = NumeroSede, capacidad_sede = Capacidad
        WHERE id_Sede = IdSede;

        SELECT 'La sede se ha modificado correctamente.' AS Mensaje;
    ELSEIF Accion = 'Eliminar' THEN
        -- Verificar si la sede existe
        IF NOT EXISTS (SELECT 1 FROM Sede WHERE id_Sede = IdSede) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sede no existe.';
            RETURN;
        END IF;

        -- Verificar si hay libros asociados a la sede
        IF EXISTS (SELECT 1 FROM Material_bibliografico WHERE id_Sede = IdSede) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la sede porque existen libros asociados.';
            RETURN;
        END IF;

        -- Eliminar la sede
        DELETE FROM Sede WHERE id_Sede = IdSede;

        SELECT 'La sede se ha eliminado correctamente.' AS Mensaje;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acción no válida.';
        RETURN;
    END IF;
END //

DELIMITER ;



---PA5. SP_RegistrarSerial: Este procedimiento se utiliza para registrar nuevos seriales de diarios y revistas en la base de datos.
DELIMITER //

CREATE PROCEDURE SP_RegistrarSerial (
    IN TipoMaterial VARCHAR(10), -- 'Diario' o 'Revista'
    IN TituloMaterial VARCHAR(251),
    IN FechaPublicacion DATE,
    IN CodigoSerial VARCHAR(100),
    IN IdUsuario VARCHAR(10),
    IN IdEditorial VARCHAR(20),
    IN IdAdquisicion VARCHAR(25),
    IN IdProveedor VARCHAR(20),
    IN IdSede VARCHAR(10),
    IN IdEstanteria VARCHAR(10),
    IN IdSeccion VARCHAR(10),
    IN NumeroPaginas INT
)
BEGIN
    -- Verificar si el serial ya está registrado
    IF EXISTS (SELECT 1 FROM Ejemplar WHERE cod_serial = CodigoSerial) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El serial ya está registrado.';
        RETURN;
    END IF;

    -- Obtener el ID del material bibliográfico
    DECLARE IdMaterialBiblio VARCHAR(10);
    SET IdMaterialBiblio = (SELECT id_material_biblio FROM Material_bibliografico WHERE titulo_material_bibliografico = TituloMaterial LIMIT 1);

    -- Verificar si el material bibliográfico existe
    IF IdMaterialBiblio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El material bibliográfico no existe.';
        RETURN;
    END IF;

    -- Insertar el serial en la tabla Ejemplar
    INSERT INTO Ejemplar (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_sede, id_estanteria, id_seccion, numero_paginas)
    VALUES (IdUsuario, CodigoSerial, IdMaterialBiblio, IdEditorial, IdAdquisicion, IdProveedor, IdSede, IdEstanteria, IdSeccion, NumeroPaginas);

    SELECT 'El serial se ha registrado correctamente.' AS Mensaje;
END //

DELIMITER ;


---PA6. SP_PrestamosActivos: Este procedimiento se utiliza para ver si existen pr�stamos activos de un determinado libro.
DELIMITER //

CREATE PROCEDURE SP_PrestamosActivos (
    IN IdMaterialBiblio VARCHAR(10) -- ID del material bibliográfico a verificar
)
BEGIN
    -- Verificar si existen préstamos activos del libro
    IF EXISTS (
        SELECT 1
        FROM Prestamo
        WHERE id_material_biblio = IdMaterialBiblio
          AND estado_prestamo = 'prestado'
    ) THEN
        SELECT 'Existen préstamos activos del libro.' AS Mensaje;
    ELSE
        SELECT 'No existen préstamos activos del libro.' AS Mensaje;
    END IF;
END //

DELIMITER ;

---SP_PrestamoVencido: Este TRIGGER se dispara regularmente para verificar regularmente si hay pr�stamos vencidos de la tabla PRESTAMO e insertarlos en la tabla MULTAS.

DELIMITER //

CREATE PROCEDURE VerificarPrestamosVencidos()
BEGIN
    -- Verificar y generar multas para los préstamos vencidos
    INSERT INTO Multa (id_prestamo, id_usuario, fecha_imposicion, estado)
    SELECT P.id_prestamo, P.id_usuario, CURDATE(), 'sin pagar'
    FROM Prestamo AS P
    WHERE P.fecha_devolucion < CURDATE()
      AND NOT EXISTS (
          SELECT 1
          FROM Multa AS M
          WHERE M.id_prestamo = P.id_prestamo
      );
END //

DELIMITER ;
