use BIBLIOGRAFICA;
--R.1. Reporte de libros más populares: Muestra una lista de los libros más prestados o solicitados por los usuarios en un período de tiempo específico.
SELECT TOP 10
    MB.titulo_material_bibliografico AS [Título del Libro],
    COUNT(*) AS [Cantidad de Préstamos]
FROM
    Prestamo AS P
    INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
WHERE
    P.fecha_prestamo BETWEEN '2023-01-01' AND '2023-06-01' -- Período de tiempo específico
GROUP BY
    MB.titulo_material_bibliografico
ORDER BY
    COUNT(*) DESC;

--R.2. Reporte de préstamos vencidos: Muestra una lista de los préstamos que están vencidos y aún no han sido devueltos por los usuarios, incluyendo detalles como el nombre del usuario y la fecha de vencimiento.
SELECT
    U.nombreU AS [Nombre del Usuario],
    P.fecha_devolucion AS [Fecha de Vencimiento],
    MB.titulo_material_bibliografico AS [Nombre del Libro]
FROM
    Prestamo AS P
    INNER JOIN Usuario AS U ON P.id_usuario = U.id_usuario
    INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
WHERE
    P.fecha_devolucion < GETDATE() -- Préstamos vencidos
    AND P.estado_prestamo != 'devuelto' -- Préstamos no devueltos
ORDER BY
    P.fecha_devolucion ASC;

---R.3. Reporte de libros en reserva: Muestra una lista de los libros que han sido reservados por los usuarios y su estado actual (disponibles, en préstamo o vencidos).

SELECT
    MB.titulo_material_bibliografico AS [Nombre del Libro],
    CASE
        WHEN P.estado_prestamo = 'reservado' THEN 'En reserva'
        WHEN P.estado_prestamo = 'prestado' THEN 'En préstamo'
        WHEN P.fecha_devolucion < GETDATE() THEN 'Vencido'
        ELSE 'Disponible'
    END AS [Estado]
FROM
    Material_bibliografico AS MB
    INNER JOIN Prestamo AS P ON MB.id_material_biblio = P.id_material_biblio
WHERE
    P.estado_prestamo = 'reservado' -- Solo libros en reserva
    OR P.estado_prestamo = 'prestado' -- También incluye libros en préstamo
    OR P.fecha_devolucion < GETDATE() -- También incluye libros vencidos
ORDER BY
    MB.titulo_material_bibliografico ASC;

---R.4. Reporte de usuarios con multas pendientes: Muestra una lista de los usuarios que tienen multas pendientes por préstamos vencidos o incumplimientos de las políticas de la biblioteca, junto con el monto total de las multas.
SELECT
    U.nombreU AS [Nombre del Usuario],
    M.id_multa AS [ID de la Multa],
    M.fecha_imposicion AS [Fecha de la Multa],
    M.monto_multa AS [Monto de la Multa Bs.]
FROM
    Usuario AS U
    INNER JOIN Multa AS M ON U.id_usuario = M.id_usuario
WHERE
    M.estado = 'pendiente' -- Multas pendientes
ORDER BY
    U.nombreU ASC;


--- Reporte de estadísticas de uso por categoría: Muestra estadísticas sobre el uso de libros por categoría, como el número de préstamos, la duración promedio de los préstamos y los libros más populares en cada categoría.

SELECT
    C.categoria AS [Categoría],
    COUNT(P.id_prestamo) AS [Número de Préstamos],
    AVG(DATEDIFF(day, P.fecha_prestamo, P.fecha_devolucion)) AS [Duración Promedio (Días) prestamo],
    MB.titulo_material_bibliografico AS [Libro más Popular]
FROM
    Categoria AS C
    INNER JOIN tiene_categoria AS TC ON C.id_categoria = TC.id_categoria
    INNER JOIN Material_bibliografico AS MB ON TC.id_material_biblio = MB.id_material_biblio
    LEFT JOIN Prestamo AS P ON MB.id_material_biblio = P.id_material_biblio
GROUP BY
    C.categoria, MB.titulo_material_bibliografico
ORDER BY
    C.categoria ASC, COUNT(P.id_prestamo) DESC;

---Reporte de adquisiciones recientes: Muestra una lista de las adquisiciones más recientes realizadas por la biblioteca, incluyendo detalles como el título del libro, el autor, la fecha de adquisición y el costo.
SELECT
    MB.titulo_material_bibliografico AS [Título del Libro],
    A.autores AS [Autores],
    AD.fecha_adquisicion AS [Fecha de Adquisición],
    AD.presupuesto AS [Costo],
	AD.tasacion AS [tasacion]
FROM
    Material_bibliografico AS MB
	INNER JOIN Ejemplar AS E ON MB.id_material_biblio=E.id_material_biblio
    INNER JOIN Adquisicion AS AD ON E.id_adquisicion = AD.id_adquisicion
    INNER JOIN (
        SELECT
            EP.id_material_biblio,
            STRING_AGG(A.[nombre(s)], ', ') AS autores
        FROM
            escrito_por AS EP
            INNER JOIN Autor AS A ON EP.id_autor = A.id_autor
        GROUP BY
            EP.id_material_biblio
    ) AS A ON MB.id_material_biblio = A.id_material_biblio
ORDER BY
    AD.fecha_adquisicion DESC;

---R.7. Reporte de usuarios activos: Muestra una lista de los usuarios activos en la biblioteca, incluyendo detalles como su nombre, número de identificación, fecha de registro y estado de la membresía.
SELECT
    U.nombreU AS [Nombre del Usuario],
    U.ci AS [Número de Identificación],
    U.fecha_registro AS [Fecha de Registro],
    L.categoria_membresia AS [Estado de Membresía]
FROM
    Usuario AS U
    INNER JOIN Lector AS L ON U.id_usuario = L.id_usuario
WHERE
    L.fecha_vencimiento_membresia >= GETDATE() -- Usuarios activos (con fecha de vencimiento mayor o igual a la fecha actual)
ORDER BY
    U.nombreU ASC;

	---R.8. Reporte de libros por sede: Muestra una lista de los libros disponibles en cada sede de la biblioteca, junto con la cantidad de ejemplares disponibles en cada sede.

SELECT
    S.nombre_sede AS [Sede],
    MB.titulo_material_bibliografico AS [Título del Libro],
    COUNT(E.cod_serial) AS [Cantidad de Ejemplares]
FROM
    Sede AS S
    INNER JOIN Ejemplar AS E ON S.id_sede = E.id_sede
    INNER JOIN Material_bibliografico AS MB ON E.id_material_biblio = MB.id_material_biblio
WHERE
    E.cod_serial NOT IN (
        SELECT P.cod_serial FROM Prestamo AS P WHERE P.estado_prestamo = 'prestado'
    )
GROUP BY
    S.nombre_sede, MB.titulo_material_bibliografico
ORDER BY
    S.nombre_sede ASC, MB.titulo_material_bibliografico ASC;


	---R.9. Reporte de libros por estantería virtual: Muestra una lista de los libros organizados en las estanterías virtuales, categorizados por estanterías privadas, públicas y libres, junto con la información del propietario de cada estantería.
SELECT
    E.nombre_estanteria_virtual AS [Estantería Virtual],
    CASE
        WHEN E.tipo_estanteria_virtual = 'privada' THEN 'Privada'
        WHEN E.tipo_estanteria_virtual = 'publica' THEN 'Pública'
        ELSE 'Libre'
    END AS [Tipo de Estantería],
    U.nombreU AS [Propietario de la Estantería],
    MB.titulo_material_bibliografico AS [Título del Libro]
FROM
    Estanteria_virtual AS E
    LEFT JOIN Usuario AS U ON E.id_usuario = U.id_usuario
    LEFT JOIN Adiciona_estanteria AS AE ON E.id_estanteria_virtual = AE.id_estanteria_virtual
    LEFT JOIN Material_bibliografico AS MB ON AE.id_material_biblio = MB.id_material_biblio
ORDER BY
    [Tipo de Estantería] ASC, E.nombre_estanteria_virtual ASC, MB.titulo_material_bibliografico ASC;

	---R.10. Reporte de préstamos por período de tiempo: Muestra estadísticas sobre los préstamos realizados en un período de tiempo específico, incluyendo el número total de préstamos, la duración promedio de los préstamos y la tasa de devolución puntual.
DECLARE @FechaInicio date = '2023-01-01'; -- Fecha de inicio del período
DECLARE @FechaFin date = '2023-12-31'; -- Fecha de fin del período

SELECT
    COUNT(id_prestamo) AS [Número total de Préstamos],
    AVG(DATEDIFF(day, fecha_prestamo, fecha_devolucion)) AS [Duración Promedio (Días) de Préstamo]  
FROM
    Prestamo
WHERE
    fecha_prestamo >= @FechaInicio
    AND fecha_prestamo <= @FechaFin;
