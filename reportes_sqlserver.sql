use BIBLIOGRAFICA;
--R.1. Reporte de libros m�s populares: Muestra una lista de los libros m�s prestados o solicitados por los usuarios en un per�odo de tiempo espec�fico.
SELECT TOP 10
    MB.titulo_material_bibliografico AS [T�tulo del Libro],
    COUNT(*) AS [Cantidad de Pr�stamos]
FROM
    Prestamo AS P
    INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
WHERE
    P.fecha_prestamo BETWEEN '2023-01-01' AND '2023-06-01' -- Per�odo de tiempo espec�fico
GROUP BY
    MB.titulo_material_bibliografico
ORDER BY
    COUNT(*) DESC;

--R.2. Reporte de pr�stamos vencidos: Muestra una lista de los pr�stamos que est�n vencidos y a�n no han sido devueltos por los usuarios, incluyendo detalles como el nombre del usuario y la fecha de vencimiento.
SELECT
    U.nombreU AS [Nombre del Usuario],
    P.fecha_devolucion AS [Fecha de Vencimiento],
    MB.titulo_material_bibliografico AS [Nombre del Libro]
FROM
    Prestamo AS P
    INNER JOIN Usuario AS U ON P.id_usuario = U.id_usuario
    INNER JOIN Material_bibliografico AS MB ON P.id_material_biblio = MB.id_material_biblio
WHERE
    P.fecha_devolucion < GETDATE() -- Pr�stamos vencidos
    AND P.estado_prestamo != 'devuelto' -- Pr�stamos no devueltos
ORDER BY
    P.fecha_devolucion ASC;

---R.3. Reporte de libros en reserva: Muestra una lista de los libros que han sido reservados por los usuarios y su estado actual (disponibles, en pr�stamo o vencidos).

SELECT
    MB.titulo_material_bibliografico AS [Nombre del Libro],
    CASE
        WHEN P.estado_prestamo = 'reservado' THEN 'En reserva'
        WHEN P.estado_prestamo = 'prestado' THEN 'En pr�stamo'
        WHEN P.fecha_devolucion < GETDATE() THEN 'Vencido'
        ELSE 'Disponible'
    END AS [Estado]
FROM
    Material_bibliografico AS MB
    INNER JOIN Prestamo AS P ON MB.id_material_biblio = P.id_material_biblio
WHERE
    P.estado_prestamo = 'reservado' -- Solo libros en reserva
    OR P.estado_prestamo = 'prestado' -- Tambi�n incluye libros en pr�stamo
    OR P.fecha_devolucion < GETDATE() -- Tambi�n incluye libros vencidos
ORDER BY
    MB.titulo_material_bibliografico ASC;

---R.4. Reporte de usuarios con multas pendientes: Muestra una lista de los usuarios que tienen multas pendientes por pr�stamos vencidos o incumplimientos de las pol�ticas de la biblioteca, junto con el monto total de las multas.
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


--- Reporte de estad�sticas de uso por categor�a: Muestra estad�sticas sobre el uso de libros por categor�a, como el n�mero de pr�stamos, la duraci�n promedio de los pr�stamos y los libros m�s populares en cada categor�a.

SELECT
    C.categoria AS [Categor�a],
    COUNT(P.id_prestamo) AS [N�mero de Pr�stamos],
    AVG(DATEDIFF(day, P.fecha_prestamo, P.fecha_devolucion)) AS [Duraci�n Promedio (D�as) prestamo],
    MB.titulo_material_bibliografico AS [Libro m�s Popular]
FROM
    Categoria AS C
    INNER JOIN tiene_categoria AS TC ON C.id_categoria = TC.id_categoria
    INNER JOIN Material_bibliografico AS MB ON TC.id_material_biblio = MB.id_material_biblio
    LEFT JOIN Prestamo AS P ON MB.id_material_biblio = P.id_material_biblio
GROUP BY
    C.categoria, MB.titulo_material_bibliografico
ORDER BY
    C.categoria ASC, COUNT(P.id_prestamo) DESC;

---Reporte de adquisiciones recientes: Muestra una lista de las adquisiciones m�s recientes realizadas por la biblioteca, incluyendo detalles como el t�tulo del libro, el autor, la fecha de adquisici�n y el costo.
SELECT
    MB.titulo_material_bibliografico AS [T�tulo del Libro],
    A.autores AS [Autores],
    AD.fecha_adquisicion AS [Fecha de Adquisici�n],
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

---R.7. Reporte de usuarios activos: Muestra una lista de los usuarios activos en la biblioteca, incluyendo detalles como su nombre, n�mero de identificaci�n, fecha de registro y estado de la membres�a.
SELECT
    U.nombreU AS [Nombre del Usuario],
    U.ci AS [N�mero de Identificaci�n],
    U.fecha_registro AS [Fecha de Registro],
    L.categoria_membresia AS [Estado de Membres�a]
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
    MB.titulo_material_bibliografico AS [T�tulo del Libro],
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


	---R.9. Reporte de libros por estanter�a virtual: Muestra una lista de los libros organizados en las estanter�as virtuales, categorizados por estanter�as privadas, p�blicas y libres, junto con la informaci�n del propietario de cada estanter�a.
SELECT
    E.nombre_estanteria_virtual AS [Estanter�a Virtual],
    CASE
        WHEN E.tipo_estanteria_virtual = 'privada' THEN 'Privada'
        WHEN E.tipo_estanteria_virtual = 'publica' THEN 'P�blica'
        ELSE 'Libre'
    END AS [Tipo de Estanter�a],
    U.nombreU AS [Propietario de la Estanter�a],
    MB.titulo_material_bibliografico AS [T�tulo del Libro]
FROM
    Estanteria_virtual AS E
    LEFT JOIN Usuario AS U ON E.id_usuario = U.id_usuario
    LEFT JOIN Adiciona_estanteria AS AE ON E.id_estanteria_virtual = AE.id_estanteria_virtual
    LEFT JOIN Material_bibliografico AS MB ON AE.id_material_biblio = MB.id_material_biblio
ORDER BY
    [Tipo de Estanter�a] ASC, E.nombre_estanteria_virtual ASC, MB.titulo_material_bibliografico ASC;

	---R.10. Reporte de pr�stamos por per�odo de tiempo: Muestra estad�sticas sobre los pr�stamos realizados en un per�odo de tiempo espec�fico, incluyendo el n�mero total de pr�stamos, la duraci�n promedio de los pr�stamos y la tasa de devoluci�n puntual.
DECLARE @FechaInicio date = '2023-01-01'; -- Fecha de inicio del per�odo
DECLARE @FechaFin date = '2023-12-31'; -- Fecha de fin del per�odo

SELECT
    COUNT(id_prestamo) AS [N�mero total de Pr�stamos],
    AVG(DATEDIFF(day, fecha_prestamo, fecha_devolucion)) AS [Duraci�n Promedio (D�as) de Pr�stamo]  
FROM
    Prestamo
WHERE
    fecha_prestamo >= @FechaInicio
    AND fecha_prestamo <= @FechaFin;
