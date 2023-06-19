---PA1. SP_BusquedaLibros:
---Este procedimiento acepta parámetros de búsqueda y devuelve una lista de libros que coinciden con los criterios de búsqueda configurados.
CREATE PROCEDURE SP_BusquedaLibros
    @Titulo VARCHAR(100) = NULL,
    @Autor VARCHAR(100) = NULL,
    @Editorial VARCHAR(100) = NULL
AS
BEGIN
    SELECT
        MB.titulo_material_bibliografico AS [Título del Libro],
        A.autores AS [Autores],
        E.nombre_editorial AS [Editorial]
    FROM
        Material_bibliografico AS MB
        LEFT JOIN (
            SELECT
                EP.id_material_biblio,
                STRING_AGG(A.[nombre(s)], ', ') AS autores
            FROM
                escrito_por AS EP
                INNER JOIN Autor AS A ON EP.id_autor = A.id_autor
            GROUP BY
                EP.id_material_biblio
        ) AS A ON MB.id_material_biblio = A.id_material_biblio
        LEFT JOIN Editorial AS E ON MB.id_editorial = E.id_editorial
    WHERE
        (@Titulo IS NULL OR MB.titulo_material_bibliografico LIKE '%' + @Titulo + '%')
        AND (@Autor IS NULL OR A.autores LIKE '%' + @Autor + '%')
        AND (@Editorial IS NULL OR E.nombre_editorial LIKE '%' + @Editorial + '%')
END


---PA2. SP_ListadosLectura:
---Este procedimiento recibe como entrada el identificador del usuario y devuelve un listado de los libros que el usuario ha marcado como lectura.
CREATE PROCEDURE SP_ListadosLectura
	@IdUsuario VARCHAR(10)
AS
BEGIN
	SELECT
		MB.titulo_material_bibliografico AS [Título del Libro],
		A.autores AS [Autores],
		E.nombre_editorial AS [Editorial]
	FROM
		Prestamo AS P
		INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
		LEFT JOIN (
			SELECT
				EP.id_material_biblio,
				STRING_AGG(A.[nombre(s)], ', ') AS autores
			FROM
				escrito_por AS EP
				INNER JOIN Autor AS A ON EP.id_autor = A.id_autor
			GROUP BY
				EP.id_material_biblio
		) AS A ON MB.id_material_biblio = A.id_material_biblio
		LEFT JOIN Editorial AS E ON MB.id_editorial = E.id_editorial
		WHERE
			P.id_usuario = @IdUsuario AND P.estado_prestamo = 'devuelto'
END


---PA3. SP_AgregarAdquisicion:
---Este procedimiento permite agregar una nueva adquisición a la base de datos, incluyendo información de presupuesto e información de tasación.




---PA4. SP_GestionSedes: Este procedimiento permite administrar las sedes de la biblioteca, incluyendo la capacidad de agregar, modificar o eliminar sedes.
CREATE PROCEDURE SP_GestionSedes
    @Accion VARCHAR(10), -- Valores posibles: 'Agregar', 'Modificar', 'Eliminar'
    @IdSede VARCHAR(10),
    @NombreSede VARCHAR(50),
    @PaisSede VARCHAR(15),
    @CiudadSede VARCHAR(85),
    @AvenidaCalle VARCHAR(85),
    @NumeroSede INT,
    @Capacidad INT
AS
BEGIN
    IF @Accion = 'Agregar'
    BEGIN
        -- Verificar si la sede ya existe
        IF EXISTS (SELECT 1 FROM Sede WHERE id_Sede = @IdSede) ---mas eiciente en rendimiento que select *
        BEGIN
            RAISERROR('La sede ya existe.', 16, 1);
            RETURN;
        END;

        -- Insertar la nueva sede
        INSERT INTO Sede (id_Sede, nombre_sede, pais_Sede, ciudad_Sede, avenida_calle, numero_sede, capacidad_sede)
        VALUES (@IdSede, @NombreSede, @PaisSede, @CiudadSede, @AvenidaCalle, @NumeroSede, @Capacidad);

        SELECT 'La sede se ha agregado correctamente.' AS Mensaje;
    END
    ELSE IF @Accion = 'Modificar'
    BEGIN
        -- Verificar si la sede existe
        IF NOT EXISTS (SELECT 1 FROM Sede WHERE id_Sede = @IdSede)
        BEGIN
            RAISERROR('La sede no existe.', 16, 1);
            RETURN;
        END;

        -- Modificar la sede
        UPDATE Sede
        SET nombre_sede = @NombreSede, pais_Sede = @PaisSede, ciudad_Sede = @CiudadSede, avenida_calle = @AvenidaCalle, numero_sede = @NumeroSede, capacidad_sede = @Capacidad
        WHERE id_Sede = @IdSede;

        SELECT 'La sede se ha modificado correctamente.' AS Mensaje;
    END
    ELSE IF @Accion = 'Eliminar'
    BEGIN
        -- Verificar si la sede existe
        IF NOT EXISTS (SELECT 1 FROM Sede WHERE id_Sede = @IdSede)
        BEGIN
            RAISERROR('La sede no existe.', 16, 1);
            RETURN;
        END;

        -- Verificar si hay libros asociados a la sede
        IF EXISTS (SELECT 1 FROM Material_bibliografico WHERE id_Sede = @IdSede)
        BEGIN
            RAISERROR('No se puede eliminar la sede porque existen libros asociados.', 16, 1);
            RETURN;
        END;

        -- Eliminar la sede
        DELETE FROM Sede WHERE id_Sede = @IdSede;

        SELECT 'La sede se ha eliminado correctamente.' AS Mensaje;
    END
    ELSE
    BEGIN
        RAISERROR('Acción no válida.', 16, 1);
        RETURN;
    END;
END


---PA5. SP_RegistrarSerial: Este procedimiento se utiliza para registrar nuevos seriales de diarios y revistas en la base de datos.
CREATE PROCEDURE SP_RegistrarSerial
    @TipoMaterial VARCHAR(10), -- 'Diario' o 'Revista'
    @TituloMaterial VARCHAR(251),
    @FechaPublicacion DATE,
    @CodigoSerial VARCHAR(100),
    @IdUsuario VARCHAR(10),
    @IdEditorial VARCHAR(20),
    @IdAdquisicion VARCHAR(25),
    @IdProveedor VARCHAR(20),
    @IdSede VARCHAR(10),
    @IdEstanteria VARCHAR(10),
    @IdSeccion VARCHAR(10),
    @NumeroPaginas INT
AS
BEGIN
    -- Verificar si el serial ya está registrado
    IF EXISTS (SELECT 1 FROM Ejemplar WHERE cod_serial = @CodigoSerial)
    BEGIN
        RAISERROR('El serial ya está registrado.', 16, 1);
        RETURN;
    END;

    -- Obtener el ID del material bibliográfico
    DECLARE @IdMaterialBiblio VARCHAR(10);
    SET @IdMaterialBiblio = (SELECT TOP 1 id_material_biblio FROM Material_bibliografico WHERE titulo_material_bibliografico = @TituloMaterial);

    -- Verificar si el material bibliográfico existe
    IF @IdMaterialBiblio IS NULL
    BEGIN
        RAISERROR('El material bibliográfico no existe.', 16, 1);
        RETURN;
    END;

    -- Insertar el serial en la tabla Ejemplar
    INSERT INTO Ejemplar (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, numero_paginas)
    VALUES (@IdUsuario, @CodigoSerial, @IdMaterialBiblio, @IdEditorial, @IdAdquisicion, @IdProveedor, @IdSede, @IdEstanteria, @IdSeccion, @NumeroPaginas);

    SELECT 'El serial se ha registrado correctamente.' AS Mensaje;
END

---PA6. SP_PrestamosActivos: Este procedimiento se utiliza para ver si existen préstamos activos de un determinado libro.
CREATE PROCEDURE SP_PrestamosActivos
    @IdMaterialBiblio VARCHAR(10) -- ID del material bibliográfico a verificar
AS
BEGIN
    -- Verificar si existen préstamos activos del libro
    IF EXISTS (
        SELECT 1
        FROM Prestamo
        WHERE id_material_biblio = @IdMaterialBiblio
          AND estado_prestamo = 'prestado'
    )
    BEGIN
        SELECT 'Existen préstamos activos del libro.' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'No existen préstamos activos del libro.' AS Mensaje;
    END
END
---SP_PrestamoVencido: Este TRIGGER se dispara regularmente para verificar regularmente si hay préstamos vencidos de la tabla PRESTAMO e insertarlos en la tabla MULTAS.

CREATE PROCEDURE VerificarPrestamosVencidos
AS
BEGIN
    -- Verificar y generar multas para los préstamos vencidos
    INSERT INTO Multa (id_prestamo, id_usuario, fecha_imposicion, estado)
    SELECT P.id_prestamo, P.id_usuario, GETDATE(), 'sin pagar'
    FROM Prestamo AS P
    WHERE P.fecha_devolucion < GETDATE()
      AND NOT EXISTS (
          SELECT 1
          FROM Multa AS M
          WHERE M.id_prestamo = P.id_prestamo
      );
END

---PA3. SP_AgregarAdquisicion: Este procedimiento permite agregar una nueva adquisición a la base de datos, incluyendo información de presupuesto e información de tasación.
CREATE PROCEDURE SP_AgregarAdquisicion
(
    @id_usuario           varchar(10),
    @id_adquisicion       varchar(25),
    @id_proveedor         varchar(20),
    @presupuesto          money,
    @tasacion             money,
    @fecha_adquisicion    datetime,
    @cod_serial           varchar(100),
    @id_material_biblio   varchar(10),
    @id_editorial         varchar(20),
    @id_Sede              varchar(10),
    @id_estanteria        varchar(10),
    @id_seccion           varchar(10),
    @id_tipo              int,
    @numero_paginas       int,
    @id_idioma            varchar(2)
)
AS
BEGIN
    SET NOCOUNT ON; ---no se envían mensajes al cliente que indiquen el número de filas afectadas por una instrucción T-SQL. Esto puede ser útil para reducir la cantidad de tráfico de red entre el servidor y el cliente

    -- Verifica si adquisicion existe
    IF EXISTS (
        SELECT 1
        FROM Adquisicion
        WHERE id_adquisicion = @id_adquisicion
    )
    BEGIN
        -- Adquisicion ya existe retorna mensaje
        SELECT 'La adquisición ya existe' AS Mensaje;
        RETURN;
    END;

    -- Insertamos adquisicion
    INSERT INTO Adquisicion (id_usuario, id_adquisicion, id_proveedor, presupuesto, tasacion, fecha_adquisicion)
    VALUES (@id_usuario, @id_adquisicion, @id_proveedor, @presupuesto, @tasacion, @fecha_adquisicion);

     -- Insertamos ejemplares
    INSERT INTO Ejemplar (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo, numero_paginas, id_idioma)
    VALUES (@id_usuario, @cod_serial, @id_material_biblio, @id_editorial, @id_adquisicion, @id_proveedor, @id_Sede, @id_estanteria, @id_seccion, @id_tipo, @numero_paginas, @id_idioma);

    -- Insertamos material bibliografico si no existe
    IF NOT EXISTS (
        SELECT 1
        FROM Material_bibliografico
        WHERE id_material_biblio = @id_material_biblio
    )
    BEGIN
        INSERT INTO Material_bibliografico (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo, fecha_publicacion, descripcion_material_bibliografico, titulo_material_bibliografico)
        VALUES (@id_material_biblio, @id_editorial, @id_Sede, @id_estanteria, @id_seccion, @id_tipo, GETDATE(), NULL, NULL);
    END;

    -- Mensaje de exito
    SELECT 'La adquisición se agregó correctamente' AS Mensaje;
END
