--R.1. Reporte de libros m�s populares: Muestra una lista de los libros m�s prestados o solicitados por los usuarios en un per�odo de tiempo espec�fico.
SELECT
    MB.titulo_mat_biblio AS "Título del Libro",
    COUNT(*) AS "Cantidad de Préstamos"
FROM
    Prestamo P
    INNER JOIN Material_bibliografico MB ON P.id_mat_biblio = MB.id_mat_biblio
WHERE
    P.fecha_prestamo BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-06-01', 'YYYY-MM-DD') -- Período de tiempo específico
GROUP BY
    MB.titulo_mat_biblio
ORDER BY
    COUNT(*) DESC;

--R.2. Reporte de pr�stamos vencidos: Muestra una lista de los pr�stamos que est�n vencidos y a�n no han sido devueltos por los usuarios, incluyendo detalles como el nombre del usuario y la fecha de vencimiento.
SELECT
    U.nombreU AS "Nombre del Usuario",
    P.fecha_devolucion AS "Fecha de Vencimiento",
    MB.titulo_mat_biblio AS "Nombre del Libro"
FROM
    Prestamo P
    INNER JOIN Usuario U ON P.id_usuario = U.id_usuario
    INNER JOIN Material_bibliografico MB ON P.id_mat_biblio = MB.id_mat_biblio
WHERE
    P.fecha_devolucion < SYSDATE -- Préstamos vencidos
    AND P.estado_prestamo != 'devuelto' -- Préstamos no devueltos
ORDER BY
    P.fecha_devolucion ASC;
---R.3. Reporte de libros en reserva: Muestra una lista de los libros que han sido reservados por los usuarios y su estado actual (disponibles, en pr�stamo o vencidos).
SELECT
    MB.titulo_mat_biblio AS "Nombre del Libro",
    CASE
        WHEN P.estado_prestamo = 'reservado' THEN 'En reserva'
        WHEN P.estado_prestamo = 'prestado' THEN 'En préstamo'
        WHEN P.fecha_devolucion < SYSDATE THEN 'Vencido'
        ELSE 'Disponible'
    END AS "Estado"
FROM
    Material_bibliografico MB
    INNER JOIN Prestamo P ON MB.id_mat_biblio = P.id_mat_biblio
WHERE
    P.estado_prestamo = 'reservado' -- Solo libros en reserva
    OR P.estado_prestamo = 'prestado' -- También incluye libros en préstamo
    OR P.fecha_devolucion < SYSDATE -- También incluye libros vencidos
ORDER BY
    MB.titulo_mat_biblio ASC;
---R.4. Reporte de usuarios con multas pendientes: Muestra una lista de los usuarios que tienen multas pendientes por pr�stamos vencidos o incumplimientos de las pol�ticas de la biblioteca, junto con el monto total de las multas.
SELECT
    U.nombreU AS "Nombre del Usuario",
    M.id_multa AS "ID de la Multa",
    M.fecha_imposicion AS "Fecha de la Multa",
    M.monto_multa AS "Monto de la Multa Bs."
FROM
    Usuario U
    INNER JOIN Multa M ON U.id_usuario = M.id_usuario
WHERE
    M.estado = 'pendiente' -- Multas pendientes
ORDER BY
    U.nombreU ASC;
--- Reporte de estad�sticas de uso por categor�a: Muestra estad�sticas sobre el uso de libros por categor�a, como el n�mero de pr�stamos, la duraci�n promedio de los pr�stamos y los libros m�s populares en cada categor�a.
SELECT
    C.categoria AS "Categoría",
    COUNT(P.id_prestamo) AS "Núm. Préstamos",
    AVG(EXTRACT(DAY FROM (P.fecha_devolucion - P.fecha_prestamo))) AS "Duración Prom. (Días)",
    MB.titulo_mat_biblio AS "Libro más Popular"
FROM
    Categoria C
    INNER JOIN tiene_categoria TC ON C.id_categoria = TC.id_categoria
    INNER JOIN Material_bibliografico MB ON TC.id_mat_biblio = MB.id_mat_biblio
    LEFT JOIN Prestamo P ON MB.id_mat_biblio = P.id_mat_biblio
GROUP BY
    C.categoria, MB.titulo_mat_biblio
ORDER BY
    C.categoria ASC, COUNT(P.id_prestamo) DESC;
---Reporte de adquisiciones recientes: Muestra una lista de las adquisiciones m�s recientes realizadas por la biblioteca, incluyendo detalles como el t�tulo del libro, el autor, la fecha de adquisici�n y el costo.
ojoooooo
SELECT
    MB.titulo_mat_biblio AS "Título del Libro",
    A.autores AS "Autores",
    AD.fecha_adquisicion AS "Fecha de Adquisición",
    AD.presupuesto AS "Costo",
	AD.tasacion AS "tasacion"
FROM
    Material_bibliografico MB
	INNER JOIN Ejemplar E ON MB.id_mat_biblio = E.id_mat_biblio
    INNER JOIN adquisicion AD ON E.id_adquisicion = AD.id_adquisicion
    INNER JOIN (
        SELECT
            EP.id_mat_biblio,
            LISTAGG(A.nombre, ', ') WITHIN GROUP (ORDER BY A.nombre) AS autores
        FROM
            escrito_por EP
            INNER JOIN Autor A ON EP.id_autor = A.id_autor
        GROUP BY
            EP.id_mat_biblio
    ) A ON MB.id_mat_biblio = A.id_mat_biblio
ORDER BY
    AD.fecha_adquisicion DESC;
---R.7. Reporte de usuarios activos: Muestra una lista de los usuarios activos en la biblioteca, incluyendo detalles como su nombre, n�mero de identificaci�n, fecha de registro y estado de la membres�a.
SELECT
    U.nombreU AS "Nombre del Usuario",
    U.ci AS "Número de Identificación",
    U.fecha_registro AS "Fecha de Registro",
    L.categoria_membresia AS "Estado de Membresía"
FROM
    Usuario U
    INNER JOIN Lector L ON U.id_usuario = L.id_usuario
WHERE
    L.fecha_vencimiento_membresia >= SYSDATE
ORDER BY
    U.nombreU ASC;
	---R.8. Reporte de libros por sede: Muestra una lista de los libros disponibles en cada sede de la biblioteca, junto con la cantidad de ejemplares disponibles en cada sede.
SELECT
    S.nombre_sede AS "Sede",
    MB.titulo_mat_biblio AS "Título del Libro",
    COUNT(E.cod_serial) AS "Cantidad de Ejemplares"
FROM
    Sede S
    INNER JOIN Ejemplar E ON S.id_sede = E.id_sede
    INNER JOIN Material_bibliografico MB ON E.id_mat_biblio = MB.id_mat_biblio
WHERE
    E.cod_serial NOT IN (
        SELECT P.cod_serial FROM Prestamo P WHERE P.estado_prestamo = 'prestado'
    )
GROUP BY
    S.nombre_sede, MB.titulo_mat_biblio
ORDER BY
    S.nombre_sede ASC, MB.titulo_mat_biblio ASC;

	---R.9. Reporte de libros por estanter�a virtual: Muestra una lista de los libros organizados en las estanter�as virtuales, categorizados por estanter�as privadas, p�blicas y libres, junto con la informaci�n del propietario de cada estanter�a.
SELECT
    E.nombre_estanteria_virtual AS "Estantería Virtual",
    CASE
        WHEN E.tipo_estanteria_virtual = 'privada' THEN 'Privada'
        WHEN E.tipo_estanteria_virtual = 'publica' THEN 'Pública'
        ELSE 'Libre'
    END AS "Tipo de Estantería",
    U.nombreU AS "Propietario de la Estantería",
    MB.titulo_mat_biblio AS "Título del Libro"
FROM
    Estanteria_virtual E
    LEFT JOIN Usuario U ON E.id_usuario = U.id_usuario
    LEFT JOIN Adiciona_estanteria AE ON E.id_estanteria_virtual = AE.id_estanteria_virtual
    LEFT JOIN Material_bibliografico MB ON AE.id_mat_biblio = MB.id_mat_biblio
ORDER BY
    "Tipo de Estantería" ASC, E.nombre_estanteria_virtual ASC, MB.titulo_mat_biblio ASC;
	---R.10. Reporte de pr�stamos por per�odo de tiempo: Muestra estad�sticas sobre los pr�stamos realizados en un per�odo de tiempo espec�fico, incluyendo el n�mero total de pr�stamos, la duraci�n promedio de los pr�stamos y la tasa de devoluci�n puntual.
SELECT
    COUNT(id_prestamo) AS "Número total de Préstamos",
    AVG(EXTRACT(DAY FROM fecha_devolucion - fecha_prestamo)) AS "Duración (Días) de Préstamo"
FROM
    Prestamo
WHERE
    fecha_prestamo >= TO_DATE('2023-01-01', 'YYYY-MM-DD')
    AND fecha_prestamo <= TO_DATE('2023-12-31', 'YYYY-MM-DD');