import random
import mysql.connector
import string
from datetime import date, timedelta, datetime, time
# Configuración de la conexión a la base de datos MySQL
config = {
  'user': 'root',
  'password': '',
  'host': 'localhost',
  'database': 'bibliografica',
  'raise_on_warnings': True,
  'auth_plugin': 'mysql_native_password' # Eliminar para Maria db, debe de estar en caso de usar Mysql
}

# Listas de nombres para generar registros aleatorios
nombres_sedes = ['Sede A', 'Sede B', 'Sede C', 'Sede D', 'Sede E']
nombres_secciones = ['Sección A', 'Sección B', 'Sección C', 'Sección D', 'Sección E']
nombres_editoriales = ['Editorial 1', 'Editorial 2', 'Editorial 3', 'Editorial 4', 'Editorial 5']

# Listas de nombres y descripciones para generar registros aleatorios
titulos = ['Libro A', 'Libro B', 'Libro C', 'Libro D', 'Libro E']
descripciones = ['Descripción del libro A', 'Descripción del libro B', 'Descripción del libro C', 'Descripción del libro D', 'Descripción del libro E']

# Listas de contenidos y puntuaciones para generar registros aleatorios
contenidos = ['Buena reseña', 'Excelente libro', 'Muy recomendado', 'Interesante lectura', 'No me gustó']
puntuaciones = [1, 2, 3, 4, 5]

# Listas de nombres y apellidos para generar registros aleatorios
nombres = ['Juan', 'María', 'Carlos', 'Laura', 'Pedro']
apellidos = ['Gómez', 'López', 'García', 'Rodríguez', 'Martínez']

# Lista de cargos para generar registros aleatorios
cargos = ['Gerente', 'Supervisor', 'Asistente', 'Analista']

# Lista de nombres de proveedores para generar registros aleatorios
nombres_proveedor = ['Proveedor A', 'Proveedor B', 'Proveedor C', 'Proveedor D', 'Proveedor E']

# Lista de idiomas:

idiomas = [
    ('es', 'Español'),
    ('en', 'Inglés'),
    ('fr', 'Francés'),
    ('de', 'Alemán'),
    ('it', 'Italiano'),
    ('pt', 'Portugués'),
    ('ja', 'Japonés'),
    ('zh', 'Chino'),
    ('ru', 'Ruso'),
    ('ar', 'Árabe')
]

# Lista de categorias

categorias = [
    ("Descripción 1", "Categoría 1"),
    ("Descripción 2", "Categoría 2"),
    ("Descripción 3", "Categoría 3"),
    # Agregar más categorías si es necesario
]

# Función para generar un registro aleatorio para la tabla "Sede"
def generar_registro_sede(i):
    #id_sede = str(random.randint(1000, 9999))  # Genera un ID de sede de 4 dígitos aleatorio
    id_sede = str(i + 1)
    nombre_sede = random.choice(nombres_sedes)
    pais_sede = random.choice(['España', 'Estados Unidos', 'México', 'Argentina', 'Francia'])
    ciudad_sede = random.choice(['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'])
    avenida_calle = random.choice(['Calle Principal', 'Avenida Central', 'Paseo de la Victoria', 'Avenida Juárez'])
    numero_sede = random.randint(1, 100)
    capacidad_sede = random.randint(50, 500)
    return (id_sede, nombre_sede, pais_sede, ciudad_sede, avenida_calle, numero_sede, capacidad_sede)

# Función para generar un registro aleatorio para la tabla "Seccion"
def generar_registro_seccion(i):
    id_sede = str(random.randint(1000, 9999))  # Genera un ID de sede de 4 dígitos aleatorio
    id_seccion = str(i + 1)  # Genera un ID de sección de 1 a 100 aleatorio
    nombre_seccion = random.choice(nombres_secciones)
    return (id_sede, id_seccion, nombre_seccion)

# Función para generar un registro aleatorio para la tabla "Estanteria"
def generar_registro_estanteria(i):
    id_sede = str(random.randint(1000, 9999))  # Genera un ID de sede de 4 dígitos aleatorio
    id_estanteria = str(i + 1)  # Genera un ID de estantería de 1 a 100 aleatorio
    id_seccion = str(random.randint(1, 100))  # Genera un ID de sección de 1 a 100 aleatorio
    capacidad = random.randint(1, 50)
    numero_estanteria = random.randint(1, 10)
    numero_pasillo_ubicacion = random.randint(1, 5)
    return (id_sede, id_estanteria, id_seccion, capacidad, numero_estanteria, numero_pasillo_ubicacion)

# Función para generar un registro aleatorio para la tabla "Editorial"
def generar_registro_editorial(i):
    id_editorial = str(i + 1)  # Genera un ID de editorial de 5 dígitos aleatorio
    pais = random.choice(['España', 'Estados Unidos', 'México', 'Argentina', 'Francia'])
    ciudad = random.choice(['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'])
    telefono = str(random.randint(1000000000, 9999999999))  # Genera un número de teléfono de 10 dígitos aleatorio
    nombre_editorial = random.choice(nombres_editoriales)
    return (id_editorial, pais, ciudad, telefono, nombre_editorial)

# Función para generar un registro aleatorio para la tabla "Material_bibliografico"
def generar_registro_material(i):
    id_material_biblio = str(i + 1)  # Genera un ID de material bibliográfico de 3 dígitos aleatorio
    id_editorial = str(random.randint(1000, 9999))  # Genera un ID de editorial de 3 dígitos aleatorio
    id_sede = str(random.randint(1000, 9999))  # Genera un ID de sede de 3 dígitos aleatorio
    id_estanteria = str(random.randint(1000, 9999))  # Genera un ID de estantería de 3 dígitos aleatorio
    id_seccion = str(random.randint(1000, 9999))  # Genera un ID de sección de 3 dígitos aleatorio
    fecha_publicacion = random_date()
    descripcion_material_bibliografico = random.choice(descripciones)
    titulo_material_bibliografico = random.choice(titulos)
    return (id_material_biblio, id_editorial, id_sede, id_estanteria, id_seccion, fecha_publicacion, descripcion_material_bibliografico, titulo_material_bibliografico)

# Función para generar una fecha aleatoria
def random_date():
    start_date = date(2000, 1, 1)
    end_date = date(2023, 12, 31)
    days = (end_date - start_date).days
    random_days = random.randint(0, days)
    return start_date + timedelta(days=random_days)

# Función para generar un registro aleatorio para la tabla "Resenia"
def generar_registro_resenia(i):
    id_material_biblio = str(i + 1)  # Genera un ID de material bibliográfico de 3 dígitos aleatorio
    id_resenia = str(random.randint(1000, 9999))  # Genera un ID de reseña de 3 dígitos aleatorio
    id_editorial = str(random.randint(1000, 9999))  # Genera un ID de editorial de 3 dígitos aleatorio
    id_sede = str(random.randint(1000, 9999))  # Genera un ID de sede de 3 dígitos aleatorio
    id_estanteria = str(random.randint(1000, 9999))  # Genera un ID de estantería de 3 dígitos aleatorio
    id_seccion = str(random.randint(1000, 9999))  # Genera un ID de sección de 3 dígitos aleatorio
    contenido = random.choice(contenidos)
    puntuacion = random.choice(puntuaciones)
    fecha_publicacion_resenia = random_date()
    return (id_material_biblio, id_resenia, id_editorial, id_sede, id_estanteria, id_seccion, contenido, puntuacion, fecha_publicacion_resenia)

# Función para generar un registro aleatorio para la tabla "Usuario"
def generar_registro_usuario(i):
    id_usuario = str(i + 1)  # Genera un ID de usuario de 3 dígitos aleatorio
    celular = ''.join(random.choice('0123456789') for _ in range(10))  # Genera un número de celular aleatorio
    telefonoU = ''.join(random.choice('0123456789') for _ in range(10))  # Genera un número de teléfono aleatorio
    nombreU = random.choice(nombres)
    primer_apellido = random.choice(apellidos)
    segundo_apellido = random.choice(apellidos)
    ciudad = random.choice(['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'])
    pais = random.choice(['España', 'Estados Unidos', 'México', 'Argentina', 'Francia'])
    avenida_calle = random.choice(['Avenida A', 'Calle B', 'Avenida C', 'Calle D', 'Avenida E'])
    numero_hogar = random.randint(1, 100)
    ci = ''.join(random.choice('0123456789') for _ in range(10))  # Genera un número de CI aleatorio
    fecha_registro = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return (id_usuario, celular, telefonoU, nombreU, primer_apellido, segundo_apellido, ciudad, pais, avenida_calle, numero_hogar, ci, fecha_registro)

# Función para generar una fecha aleatoria en el rango de los últimos 5 años
def generar_fecha_inicio_cargo():
    fecha_actual = date.today()
    fecha_inicio_cargo = fecha_actual - timedelta(days=random.randint(365, 1825))
    return fecha_inicio_cargo

# Función para generar un horario de trabajo aleatorio
def generar_horario_trabajo():
    hora = random.randint(8, 18)  # Genera una hora aleatoria entre las 8:00 y las 18:00
    minutos = random.choice([0, 15, 30, 45])  # Genera los minutos aleatoriamente en intervalos de 15 minutos
    horario_trabajo = time(hora, minutos)
    return horario_trabajo

# Función para generar un número de teléfono aleatorio
def generar_telefono():
    telefono = ''.join(random.choice('0123456789') for _ in range(10))
    return telefono

# Función para generar un presupuesto aleatorio
def generar_presupuesto():
    presupuesto = random.randint(100, 100000)
    return presupuesto

# Función para generar una tasación aleatoria
def generar_tasacion():
    tasacion = random.randint(100, 100000)
    return tasacion

# Función para generar una categoría de membresía aleatoria
def generar_categoria_membresia():
    categorias = ['Básico', 'Premium', 'VIP']
    categoria_membresia = random.choice(categorias)
    return categoria_membresia

# Función para generar una fecha de vencimiento de membresía aleatoria
def generar_fecha_vencimiento():
    anio = random.randint(2023, 2025)  # Genera un año entre 2023 y 2025
    mes = random.randint(1, 12)  # Genera un mes entre 1 y 12
    dia = random.randint(1, 28)  # Genera un día entre 1 y 28 (asumiendo meses con 28 días)
    fecha_vencimiento = f"{anio}-{mes:02d}-{dia:02d}"
    return fecha_vencimiento

# Función para generar una fecha aleatoria dentro de un rango específico
def generar_fecha(rango_inicio, rango_fin):
    tiempo_inicio = datetime.strptime(rango_inicio, "%Y-%m-%d %H:%M:%S")
    tiempo_fin = datetime.strptime(rango_fin, "%Y-%m-%d %H:%M:%S")
    diferencia = tiempo_fin - tiempo_inicio
    tiempo_prestamo = tiempo_inicio + timedelta(seconds=random.randint(0, int(diferencia.total_seconds())))
    return tiempo_prestamo

def generar_nombre_estanteria_virtual():
    longitud = random.randint(5, 10)  # Longitud del nombre de estantería virtual
    caracteres = string.ascii_letters + string.digits  # Caracteres permitidos en el nombre
    nombre = ''.join(random.choice(caracteres) for _ in range(longitud))
    return nombre

def generar_nombre_autor():
    nombres = ['Juan', 'María', 'Carlos', 'Laura', 'Pedro', 'Ana', 'Luis', 'Mónica', 'Javier', 'Sofía']
    apellidos = ['García', 'Martínez', 'López', 'Hernández', 'Gómez', 'Pérez', 'Rodríguez', 'González', 'Sánchez', 'Fernández']

    nombre = random.choice(nombres)
    apellido1 = random.choice(apellidos)
    apellido2 = random.choice(apellidos)

    return f"{nombre} {apellido1} {apellido2}"

def generar_apellido():
    apellidos = ['García', 'Martínez', 'López', 'Hernández', 'Gómez', 'Pérez', 'Rodríguez', 'González', 'Sánchez', 'Fernández']
    return random.choice(apellidos)

def generar_nacionalidad():
    nacionalidades = ['Española', 'Mexicana', 'Argentina', 'Colombiana', 'Chilena', 'Peruana', 'Brasileña', 'Venezolana', 'Uruguaya', 'Ecuatoriana']
    return random.choice(nacionalidades)

def generar_fecha_nacimiento():
    # Generar una fecha de nacimiento aleatoria en un rango de 18 a 60 años atrás
    today = date.today()
    min_age = 18
    max_age = 60
    min_date = today - timedelta(days=max_age*365)
    max_date = today - timedelta(days=min_age*365)
    random_date = min_date + random.random() * (max_date - min_date)
    
    return random_date.strftime('%Y-%m-%d')

def generar_sexo():
    opciones = ['M', 'F']
    return random.choice(opciones)

def generar_tipo():
    tipos = ['Libro', 'Revista', 'Periódico', 'Artículo', 'Tesis', 'Documento', 'Otro']
    return random.choice(tipos)

# Leer el archivo que contiene el código DDL
#ddl_file = 'mysql_nuevo.sql'
#with open(ddl_file, 'r') as file:
#    ddl_script = file.read()

# Conexión a la base de datos
conexion = mysql.connector.connect(**config)
cursor = conexion.cursor()

# Ejecutar el script DDL
#cursor.execute(ddl_script, multi=True)

# Confirmar los cambios
#conexion.commit()

f_mysql = open("datos_mysql", "a")
f_oracle = open("datos_oracle", "a")
f_sqlserver = open("datos_sqlserver", "a")

# Generar y insertar 500 registros de prueba para la tabla "Sede"
for i in range(500):
    registro_sede = generar_registro_sede(i)
    query_sede = "INSERT INTO Sede (id_Sede, nombre_sede, pais_Sede, ciudad_Sede, avenida_calle, numero_sede, capacidad_sede) VALUES ('%s', '%s', '%s', '%s', '%s', %s, %s)" % registro_sede

    f_mysql.write(query_sede + ";\n")
    f_sqlserver.write(query_sede + ";\n")
    f_oracle.write(query_sede + ";\n")

    try:
        cursor.execute(query_sede)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Sede"
cursor.execute("SELECT id_Sede FROM Sede")
sedes = cursor.fetchall()

# Generar y insertar 10 registros de prueba para la tabla "Seccion"
for i in range(100):
    registro_seccion = generar_registro_seccion(i)

    # Seleccionar un ID de Sede existente de forma aleatoria
    id_sede = random.choice(sedes)[0]
    registro_seccion = (id_sede,) + registro_seccion[1:]

    # Insertar el registro en la tabla "Seccion"
    query_seccion = "INSERT INTO Seccion (id_Sede, id_seccion, nombre_Seccion) VALUES ('%s', '%s', '%s')" % registro_seccion

    f_mysql.write(query_seccion + ";\n")
    f_sqlserver.write(query_seccion + ";\n")
    f_oracle.write(query_seccion + ";\n")

    try:
        cursor.execute(query_seccion)
        conexion.commit()
    except:
        pass


# Obtener los registros existentes de la tabla "Sede"
cursor.execute("SELECT id_Sede FROM Sede")
sedes = cursor.fetchall()

# Obtener los registros existentes de la tabla "Seccion"
cursor.execute("SELECT id_seccion FROM Seccion")
secciones = cursor.fetchall()

# Generar y insertar 50 registros de prueba para la tabla "Estanteria"
for i in range(50):
    registro_estanteria = generar_registro_estanteria(i)

    # Seleccionar un ID de Sede existente de forma aleatoria
    id_sede = random.choice(sedes)[0]

    # Seleccionar un ID de Seccion existente de forma aleatoria
    id_seccion = random.choice(secciones)[0]

    registro_estanteria = (id_sede, registro_estanteria[1], id_seccion, registro_estanteria[3], registro_estanteria[4], registro_estanteria[5])
    # Insertar el registro en la tabla "Estanteria"
    query_estanteria = "INSERT INTO Estanteria (id_Sede, id_estanteria, id_seccion, capacidad, numero_estanteria, numero_pasillo_ubicacion) VALUES ('%s', '%s', '%s', %s, %s, %s)" % registro_estanteria

    f_mysql.write(query_estanteria + ";\n")
    f_sqlserver.write(query_estanteria + ";\n")
    f_oracle.write(query_estanteria + ";\n")

    try:
        cursor.execute(query_estanteria)
        conexion.commit()
    except:
        pass


# Generar y insertar 10 registros de prueba para la tabla "Editorial"
for i in range(10):
    registro_editorial = generar_registro_editorial(i)
    query_editorial = "INSERT INTO Editorial (id_editorial, pais, ciudad, telefono, nombre_editorial) VALUES ('%s', '%s', '%s', '%s', '%s')" % registro_editorial

    f_mysql.write(query_editorial + ";\n")
    f_sqlserver.write(query_editorial + ";\n")
    f_oracle.write(query_editorial + ";\n")

    try:
        cursor.execute(query_editorial)
        conexion.commit()
    except:
        pass

# Generar 10 registros de prueba para la tabla "Tipo"
for i in range(10):    
    tipo = generar_tipo()
    id_tipo = str(i + 1)

    valores = (tipo, id_tipo)
    # Insertar el registro en la tabla Tipo
    query_tipo = "INSERT INTO Tipo (tipo, id_tipo) VALUES ('%s', %s)" % valores

    f_mysql.write(query_tipo + ";\n")
    f_sqlserver.write(query_tipo + ";\n")
    f_oracle.write(query_tipo + ";\n")

    try:
        cursor.execute(query_tipo)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Editorial"
cursor.execute("SELECT id_editorial FROM Editorial")
editoriales = cursor.fetchall()

# Obtener los registros existentes de la tabla "Sede"
cursor.execute("SELECT id_Sede FROM Sede")
sedes = cursor.fetchall()

# Obtener los registros existentes de la tabla "Estanteria"
cursor.execute("SELECT id_Sede, id_estanteria, id_seccion FROM Estanteria")
estanterias = cursor.fetchall()

# Obtener los registros existentes de la tabla "Tipo"
cursor.execute("SELECT id_tipo FROM Tipo")
tipos = cursor.fetchall()

# Generar y insertar 40 registros de prueba para la tabla "Material_bibliografico"
for i in range(40):
    registro_material = generar_registro_material(i)

    # Seleccionar un ID de Editorial, un ID de Sede, un ID de Estanteria y un ID de Seccion existentes de forma aleatoria
    id_editorial = random.choice(editoriales)[0]
    id_sede, id_estanteria, id_seccion = random.choice(estanterias)

    id_tipo = random.choice(tipos)[0]

    # Concatenar los ID de Editorial, Sede, Estanteria y Seccion al registro_material
    registro_material = (str(i + 1), id_editorial, id_sede, id_estanteria, id_seccion, id_tipo) + registro_material[5:]

    # Insertar el registro en la tabla "Material_bibliografico"
    query_material = "INSERT INTO Material_bibliografico (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo, fecha_publicacion, descripcion_material_bibliografico, titulo_material_bibliografico) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" % registro_material
    #print(query_material)

    f_mysql.write(query_material + ";\n")
    f_sqlserver.write(query_material + ";\n")
    f_oracle.write(query_material + ";\n")

    try:
        cursor.execute(query_material)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Material_bibliografico"
cursor.execute("select id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion from Material_bibliografico")
material_bibliograficos = cursor.fetchall()

# Obtener los registros existentes de la tabla "Tipo"
cursor.execute("SELECT id_tipo FROM Tipo")
tipos = cursor.fetchall()

# Generar y insertar 10 registros de prueba para la tabla "Resenia"
for i in range(30):
    fila_material_bibliografico = random.choice(material_bibliograficos)
    
    id_material_biblio = str(fila_material_bibliografico[0])
    id_resenia = str(i + 1)  # Genera un ID de reseña de 3 dígitos aleatorio
    id_editorial = str(fila_material_bibliografico[1])
    id_sede = str(fila_material_bibliografico[2])
    id_estanteria = str(fila_material_bibliografico[3])
    id_seccion = str(fila_material_bibliografico[4])
    contenido = random.choice(contenidos)
    puntuacion = random.choice(puntuaciones)
    fecha_publicacion_resenia = random_date()
    
    id_tipo = random.choice(tipos)[0]

    registro_resenia = (id_material_biblio, id_resenia, id_editorial, id_sede, id_estanteria, id_seccion, id_tipo,contenido, puntuacion, fecha_publicacion_resenia)
    query_resenia = "INSERT INTO Resenia (id_material_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo, contenido, puntuacion, fecha_publicacion_resenia) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', %s, '%s', %s, '%s')" % registro_resenia
    #print(query_resenia)

    f_mysql.write(query_resenia + ";\n")
    f_sqlserver.write(query_resenia + ";\n")
    f_oracle.write(query_resenia + ";\n")

    try:
        cursor.execute(query_resenia)
        conexion.commit()
    except:
        pass

# Generar y insertar 10 registros de prueba para la tabla "Usuario"
for i in range(100):
    registro_usuario = generar_registro_usuario(i)
    query_usuario = "INSERT INTO Usuario (id_usuario, celular, telefonoU, nombreU, primer_apellido, segundo_apellido, ciudad, pais, avenida_calle, numero_hogar, ci, fecha_registro) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %s, '%s', '%s')" % registro_usuario

    f_mysql.write(query_usuario + ";\n")
    f_sqlserver.write(query_usuario + ";\n")
    f_oracle.write(query_usuario + ";\n")

    try:
        cursor.execute(query_usuario)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Usuario"
cursor.execute("SELECT id_usuario FROM Usuario")
usuarios = cursor.fetchall()
# Generar y insertar 10 registros de prueba para la tabla "Empleado"
for _ in range(40):
    id_usuario = str(random.choice(usuarios)[0])  # Genera un ID de usuario de 3 dígitos aleatorio
    correo = f'usuario{id_usuario}@empresa.com'
    fecha_inicio_cargo = generar_fecha_inicio_cargo()
    cargo = random.choice(cargos)
    horario_trabajo = generar_horario_trabajo()
    query_empleado = "INSERT INTO Empleado (id_usuario, correo, fecha_inicio_cargo, cargo, horario_trabajo) VALUES ('%s', '%s', '%s', '%s', '%s')" % (id_usuario, correo, fecha_inicio_cargo, cargo, horario_trabajo)

    f_mysql.write(query_empleado + ";\n")
    f_sqlserver.write(query_empleado + ";\n")
    f_oracle.write(query_empleado + ";\n")

    try:
        cursor.execute(query_empleado)
        conexion.commit()
    except:
        pass

# Generar y insertar 10 registros de prueba para la tabla "Proveedor"
for i in range(30):
    id_proveedor = str(i + 1)  # Genera un ID de proveedor de 3 dígitos aleatorio
    telefono = generar_telefono()
    pais = random.choice(['España', 'Estados Unidos', 'México', 'Argentina', 'Francia'])
    ciudad = random.choice(['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'])
    avenida_calle = random.choice(['Avenida A', 'Calle B', 'Avenida C', 'Calle D', 'Avenida E'])
    numero_direccion = random.randint(1, 100)
    nombre = random.choice(nombres_proveedor)
    query_proveedor = "INSERT INTO Proveedor (id_proveedor, telefono, pais, ciudad, avenida_calle, numero_direccion, nombre) VALUES ('%s', '%s', '%s', '%s', '%s', %s, '%s')" % (id_proveedor, telefono, pais, ciudad, avenida_calle, numero_direccion, nombre)

    f_mysql.write(query_proveedor + ";\n")
    f_sqlserver.write(query_proveedor + ";\n")
    f_oracle.write(query_proveedor + ";\n")

    try:
        cursor.execute(query_proveedor)
        conexion.commit()
    except:
        pass

cursor.execute("SELECT id_usuario FROM Usuario")
usuarios = cursor.fetchall()

cursor.execute("SELECT id_proveedor FROM Proveedor")
proveedores = cursor.fetchall()


# Generar y insertar 10 registros de prueba para la tabla "Adquisicion"
for i in range(40):
    id_usuario = str(random.choice(usuarios)[0])  # Genera un ID de usuario de 3 dígitos aleatorio
    id_adquisicion = str(i + 1)  # Genera un ID de adquisición de 4 dígitos aleatorio
    id_proveedor = str(random.choice(proveedores)[0])  # Genera un ID de proveedor de 3 dígitos aleatorio
    presupuesto = generar_presupuesto()
    tasacion = generar_tasacion()
    fecha_adquisicion = generar_fecha_inicio_cargo()
    query_adquisicion = "INSERT INTO Adquisicion (id_usuario, id_adquisicion, id_proveedor, presupuesto, tasacion, fecha_adquisicion) VALUES ('%s', '%s', '%s', %s, %s, '%s')" % (id_usuario, id_adquisicion, id_proveedor, presupuesto, tasacion, fecha_adquisicion)

    f_mysql.write(query_adquisicion + ";\n")
    f_sqlserver.write(query_adquisicion + ";\n")
    f_oracle.write(query_adquisicion + ";\n")

    try:
        cursor.execute(query_adquisicion)
        conexion.commit()
    except:
        pass

for idioma in idiomas:
    id_idioma = idioma[0]
    nombre_idioma = idioma[1]

    valores = (id_idioma, nombre_idioma)
    query_idioma = "INSERT INTO Idioma (id_idioma, nombre_idioma) VALUES ('%s', '%s')" % valores

    f_mysql.write(query_idioma + ";\n")
    f_sqlserver.write(query_idioma + ";\n")
    f_oracle.write(query_idioma + ";\n")

    try:
        cursor.execute(query_idioma)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Material_bibliografico"
cursor.execute("select id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion from Material_bibliografico")
material_bibliograficos = cursor.fetchall()

# Obtener los registros existentes de la tabla "Adquisicion"
cursor.execute("select id_usuario, id_adquisicion, id_proveedor from Adquisicion")
adquisiciones = cursor.fetchall()

cursor.execute("SELECT id_idioma FROM Idioma")
idiomas = cursor.fetchall()

# Generar 10 registros de prueba para la tabla "Ejemplar"
for _ in range(20):

    fila_adquisiciones = random.choice(adquisiciones)
    fila_material_bibliografico = random.choice(material_bibliograficos)

    id_usuario = str(fila_adquisiciones[0])
    cod_serial = str(random.randint(100, 999))
    id_material_biblio = str(fila_material_bibliografico[0])
    id_editorial = str(fila_material_bibliografico[1])
    id_adquisicion = str(fila_adquisiciones[1])
    id_proveedor = str(fila_adquisiciones[2])
    id_Sede = str(fila_material_bibliografico[2])
    id_estanteria = str(fila_material_bibliografico[3])
    id_seccion = str(fila_material_bibliografico[4])
    numero_paginas = random.randint(1, 500)
    id_tipo = random.choice(tipos)[0]
    id_idioma = random.choice(idiomas)[0]
    valores = (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo, numero_paginas, id_idioma)

    # Insertar el registro en la tabla Ejemplar
    query_ejemplar = "INSERT INTO Ejemplar (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo, numero_paginas, id_idioma) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %s, %s, '%s')" % valores   

    f_mysql.write(query_ejemplar + ";\n")
    f_sqlserver.write(query_ejemplar + ";\n")
    f_oracle.write(query_ejemplar + ";\n")

    #print(query_ejemplar)
    try:

        cursor.execute(query_ejemplar)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Usuario"
cursor.execute("SELECT id_usuario FROM Usuario")
usuarios = cursor.fetchall()

# Generar 10 registros de prueba para la tabla "Lector"
for _ in range(10):
    # Seleccionar un ID de usuario existente de forma aleatoria
    id_usuario = random.choice(usuarios)[0]
    categoria_membresia = generar_categoria_membresia()
    fecha_vencimiento_membresia = generar_fecha_vencimiento()

    valores = (id_usuario, categoria_membresia, fecha_vencimiento_membresia)
    # Insertar el registro en la tabla "Lector"
    query_lector = "INSERT INTO Lector (id_usuario, categoria_membresia, fecha_vencimiento_membresia) VALUES ('%s', '%s', '%s')" % valores

    f_mysql.write(query_lector + ";\n")
    f_sqlserver.write(query_lector + ";\n")
    f_oracle.write(query_lector + ";\n")

    try:
        cursor.execute(query_lector)
        conexion.commit()
    except:
        pass

# Obtener todos los ejemplares existentes en la base de datos
query_ejemplares = "SELECT id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion FROM Ejemplar"
cursor.execute(query_ejemplares)
ejemplares = cursor.fetchall()

# Generar y insertar múltiples registros de préstamo

for i in range(10):
    # Seleccionar un ejemplar aleatorio
    ejemplar = random.choice(ejemplares)
    id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion = ejemplar

    # Generar fechas de préstamo y devolución aleatorias
    fecha_actual = datetime.now()
    fecha_prestamo = generar_fecha("2023-01-01 00:00:00", fecha_actual.strftime("%Y-%m-%d %H:%M:%S"))
    fecha_devolucion = generar_fecha(fecha_prestamo.strftime("%Y-%m-%d %H:%M:%S"), fecha_actual.strftime("%Y-%m-%d %H:%M:%S"))

    # Generar estado de préstamo aleatorio
    estados_prestamo = ['Activo', 'Vencido', 'Devuelto']
    estado_prestamo = random.choice(estados_prestamo)[:5]  # Truncar el valor a una longitud máxima de 5 caracteres

    id_prestamo = str(i + 1)  # Genera un ID de préstamo de 3 dígitos aleatorio
    valores = (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo, fecha_prestamo, fecha_devolucion, estado_prestamo)

    # Insertar el registro de préstamo
    query_prestamo = "INSERT INTO Prestamo (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo, fecha_prestamo, fecha_devolucion, estado_prestamo) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %s, '%s', '%s', '%s')" % valores
    
    #print(query_prestamo)

    f_mysql.write(query_prestamo + ";\n")
    f_sqlserver.write(query_prestamo + ";\n")
    f_oracle.write(query_prestamo + ";\n")

    try:
        cursor.execute(query_prestamo)
        conexion.commit()
    except:
        pass

# Obtener todos los préstamos existentes en la base de datos
query_prestamos = "SELECT id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial FROM Prestamo"
cursor.execute(query_prestamos)
prestamos = cursor.fetchall()

# Generar y insertar 10 registros de prueba para la tabla "Multa"
for i in range(10):
    # Seleccionar un préstamo aleatorio
    prestamo = random.choice(prestamos)
    id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial = prestamo
    
    # Generar monto de multa aleatorio
    monto_multa = round(random.uniform(0.0, 100.0), 2)
    
    # Generar fecha de imposición aleatoria
    fecha_actual = datetime.now()
    fecha_imposicion = generar_fecha("2023-01-01 00:00:00", fecha_actual.strftime("%Y-%m-%d %H:%M:%S"))
    
    # Generar estado de multa aleatorio
    estados_multa = ['Pendiente', 'Pagada']
    estado_multa = random.choice(estados_multa)
    
    # Generar fecha de pago aleatoria (opcional)
    fecha_pago = None
    if estado_multa == 'Pagada':
        fecha_pago = generar_fecha(fecha_imposicion.strftime("%Y-%m-%d %H:%M:%S"), fecha_actual.strftime("%Y-%m-%d %H:%M:%S"))
    
    id_multa = str(i + 1)
    id_tipo = str(random.choice(tipos)[0])

    valores = (id_usuario, id_multa, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial, id_tipo, monto_multa, fecha_imposicion, estado_multa, fecha_pago)
    
    # Insertar el registro de multa
    query_multa = "INSERT INTO Multa (id_usuario, id_multa, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial, id_tipo, monto_multa, fecha_imposicion, estado, fecha_pago) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %s, %s, '%s', '%s', '%s')" % valores
    
    #print(query_multa)

    f_mysql.write(query_multa + ";\n")
    f_sqlserver.write(query_multa + ";\n")
    f_oracle.write(query_multa + ";\n")

    try:
        cursor.execute(query_multa)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Lector"
cursor.execute("SELECT id_usuario FROM Lector")
lectores = cursor.fetchall()

# Generar y insertar 10 registros de prueba para la tabla "Estanteria_virtual"
for i in range(10):
    id_estanteria_virtual = str(i + 1)
    id_usuario = random.choice(lectores)[0]
    tipos_estanteria = ['Favoritos', 'Por Leer', 'Leídos', 'Recomendados']
    tipo_estanteria_virtual = random.choice(tipos_estanteria)
    nombre_estanteria_virtual = generar_nombre_estanteria_virtual()

    valores = (id_estanteria_virtual, id_usuario, tipo_estanteria_virtual, nombre_estanteria_virtual)
    # Insertar el registro en la tabla "Estanteria_virtual"
    query_estanteria_virtual = "INSERT INTO Estanteria_virtual (id_estanteria_virtual, id_usuario, tipo_estanteria_virtual, nombre_estanteria_virtual) VALUES ('%s', '%s', '%s', '%s')" % valores
    
    f_mysql.write(query_estanteria_virtual + ";\n")
    f_sqlserver.write(query_estanteria_virtual + ";\n")
    f_oracle.write(query_estanteria_virtual + ";\n")

    try:
        cursor.execute(query_estanteria_virtual)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Estanteria_virtual"
cursor.execute("select id_estanteria_virtual, id_usuario from Estanteria_virtual")
estanterias_virtuales = cursor.fetchall()

# Obtener los registros existentes de la tabla "Material_bibliografico"
cursor.execute("select id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion from Material_bibliografico")
materiales_bibliograficos = cursor.fetchall()

# Generar y insertar 10 registros de prueba para la tabla "Adiciona_estanteria"

for _ in range(20):

    estanteria_virtual = random.choice(estanterias_virtuales)
    material_bibliografico = random.choice(materiales_bibliograficos)

    id_estanteria_virtual = estanteria_virtual[0]
    id_usuario = estanteria_virtual[1]
    id_material_biblio = material_bibliografico[0]
    id_editorial = material_bibliografico[1]
    id_Sede = material_bibliografico[2]
    id_estanteria = material_bibliografico[3]
    id_seccion = material_bibliografico[4]
    id_tipo = random.choice(tipos)[0]
    valores = (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)

    query_adiciona_estanteria = "INSERT INTO Adiciona_estanteria (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', %s)" % valores
    
    #print(query_adiciona_estanteria)

    f_mysql.write(query_adiciona_estanteria + ";\n")
    f_sqlserver.write(query_adiciona_estanteria + ";\n")
    f_oracle.write(query_adiciona_estanteria + ";\n")

    try:
        cursor.execute(query_adiciona_estanteria)
        conexion.commit()
    except:
        pass


# Generar 10 registros de prueba para la tabla "Categoria"
for categoria in categorias:
    descripcion = categoria[0]
    categoria = categoria[1]

    valores = (descripcion, categoria)

    query_categoria = "INSERT INTO Categoria (descripcion, categoria) VALUES ('%s', '%s')" % valores
    
    f_mysql.write(query_categoria + ";\n")
    f_sqlserver.write(query_categoria + ";\n")
    f_oracle.write(query_categoria + ";\n")

    try:
        cursor.execute(query_categoria)
        conexion.commit()
    except:
        pass

cursor.execute("SELECT id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion FROM Material_bibliografico")
materiales_bibliograficos = cursor.fetchall()

# Generar 10 registros de prueba para la tabla "tiene_categoria"
for i in range(10):

    material_bibliografico = random.choice(materiales_bibliograficos)

    id_material_biblio = str(material_bibliografico[0])
    id_editorial = str(material_bibliografico[1])
    id_Sede = str(material_bibliografico[2])
    id_estanteria = str(material_bibliografico[3])
    id_seccion = str(material_bibliografico[4])
    id_categoria = str(i + 1)  # ID de categoría aleatorio
    id_tipo = random.choice(tipos)[0]

    valores = (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria, id_tipo)
    # Insertar el registro en la tabla tiene_categoria
    query_tiene_categoria = "INSERT INTO tiene_categoria (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria, id_tipo) VALUES ('%s', '%s', '%s', '%s', '%s', %s, %s)" % valores

    f_mysql.write(query_tiene_categoria + ";\n")
    f_sqlserver.write(query_tiene_categoria + ";\n")
    f_oracle.write(query_tiene_categoria + ";\n")

    try:
        cursor.execute(query_tiene_categoria)
        conexion.commit()
    except:
        pass

# Generar 10 registros de prueba para la tabla "Autor"
for _ in range(10):
    id_autor = str(random.randint(1000, 9999))  # ID de autor de 4 dígitos aleatorio
    nombres = generar_nombre_autor()
    primer_apellido = generar_apellido()
    segundo_apellido = generar_apellido()
    nacionalidad = generar_nacionalidad()
    fecha_nacimiento = generar_fecha_nacimiento()
    sexo = generar_sexo()

    valores = (id_autor, nombres, primer_apellido, segundo_apellido, nacionalidad, fecha_nacimiento, sexo)

    # Insertar el registro en la tabla Autor
    query_autor = "INSERT INTO Autor (id_autor, `nombre(s)`, primer_apellido, segundo_apellido, nacionalidad, fecha_nacimiento, sexo) VALUES (%s, '%s', '%s', '%s', '%s', '%s', '%s')" % valores

    f_mysql.write(query_autor + ";\n")
    f_sqlserver.write(query_autor + ";\n")
    f_oracle.write(query_autor + ";\n")

    try:
        cursor.execute(query_autor)
        conexion.commit()
    except:
        pass

# Obtener los registros existentes de la tabla "Autor"
cursor.execute("SELECT id_autor FROM Autor")
autores = cursor.fetchall()
cursor.execute("SELECT id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion FROM Material_bibliografico")
materiales_bibliograficos = cursor.fetchall()

# Generar 10 registros de prueba para la tabla "escrito_por"
for _ in range(10):

    material_bibliografico = random.choice(materiales_bibliograficos)

    id_material_biblio = str(material_bibliografico[0])
    id_editorial = str(material_bibliografico[1])
    id_autor = str(random.choice(autores)[0])
    id_Sede = str(material_bibliografico[2])
    id_estanteria = str(material_bibliografico[3])
    id_seccion = str(material_bibliografico[4])

    valores = (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion)

    # Insertar el registro en la tabla escrito_por
    query_escrito_por = "INSERT INTO escrito_por (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')" % valores
    

    f_mysql.write(query_escrito_por + ";\n")
    f_sqlserver.write(query_escrito_por + ";\n")
    f_oracle.write(query_escrito_por + ";\n")

    try:
        cursor.execute(query_escrito_por, valores)
        conexion.commit()
    except:
        pass


f_mysql.close()
f_sqlserver.close()
f_oracle.close()
# Cerrar la conexión a la base de datos
cursor.close()
conexion.close()
