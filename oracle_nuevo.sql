CREATE TABLE Sede(
    id_Sede           VARCHAR2(10)     NOT NULL,
    nombre_sede       VARCHAR2(50),
    pais_Sede         VARCHAR2(15)     NOT NULL,
    ciudad_Sede       VARCHAR2(85)     NOT NULL,
    avenida_calle     VARCHAR2(85)     NOT NULL,
    numero_sede       NUMBER(38, 0),
    capacidad_sede    NUMBER(38, 0),
    CONSTRAINT PK1 PRIMARY KEY (id_Sede)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Seccion(
    id_Sede           VARCHAR2(10)    NOT NULL,
    id_seccion        VARCHAR2(10)    NOT NULL,
    nombre_Seccion    VARCHAR2(30)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY (id_Sede, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefSede11 FOREIGN KEY (id_Sede)
    REFERENCES Sede(id_Sede)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Estanteria(
    id_Sede                     VARCHAR2(10)     NOT NULL,
    id_estanteria               VARCHAR2(10)     NOT NULL,
    id_seccion                  VARCHAR2(10)     NOT NULL,
    capacidad                   NUMBER(38, 0),
    numero_estanteria           NUMBER(38, 0)    NOT NULL,
    numero_pasillo_ubicacion    NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY (id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefSeccion21 FOREIGN KEY (id_Sede, id_seccion)
    REFERENCES Seccion(id_Sede, id_seccion)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Editorial(
    id_editorial        VARCHAR2(20)    NOT NULL,
    pais                VARCHAR2(15)    NOT NULL,
    ciudad              VARCHAR2(85)    NOT NULL,
    telefono            VARCHAR2(10)    NOT NULL,
    nombre_editorial    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY (id_editorial)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Material_bibliografico(
    id_mat_biblio                    VARCHAR2(10)     NOT NULL,
    id_editorial                     VARCHAR2(20)     NOT NULL,
    id_Sede                          VARCHAR2(10)     NOT NULL,
    id_estanteria                    VARCHAR2(10)     NOT NULL,
    id_seccion                       VARCHAR2(10)     NOT NULL,
    fecha_publicacion                DATE             NOT NULL,
    descripcion_mb    CLOB,
    titulo_mb    VARCHAR2(251)    NOT NULL,
    CONSTRAINT PK4_MB PRIMARY KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefEstanteria31 FOREIGN KEY (id_Sede, id_estanteria, id_seccion)
    REFERENCES Estanteria(id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefEditorial371 FOREIGN KEY (id_editorial)
    REFERENCES Editorial(id_editorial)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;


CREATE TABLE Resenia(
    id_mat_biblio           VARCHAR2(10)     NOT NULL,
    id_resenia                   VARCHAR2(20)     NOT NULL,
    id_editorial                 VARCHAR2(20)     NOT NULL,
    id_Sede                      VARCHAR2(10)     NOT NULL,
    id_estanteria                VARCHAR2(10)     NOT NULL,
    id_seccion                   VARCHAR2(10)     NOT NULL,
    contenido                    CLOB,
    puntuacion                   NUMBER(38, 0)    NOT NULL,
    fecha_publicacion	         DATE             NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY (id_mat_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico151 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Usuario(
    id_usuario          VARCHAR2(10)     NOT NULL,
    celular             VARCHAR2(10)     NOT NULL,
    telefonoU           VARCHAR2(10),
    nombreU             VARCHAR2(50)     NOT NULL,
    primer_apellido     VARCHAR2(26)     NOT NULL,
    segundo_apellido    VARCHAR2(26)     NOT NULL,
    ciudad              VARCHAR2(85)     NOT NULL,
    pais                VARCHAR2(15)     NOT NULL,
    avenida_calle       VARCHAR2(85)     NOT NULL,
    numero_hogar        NUMBER(38, 0)    NOT NULL,
    ci                  VARCHAR2(10)     NOT NULL,
    fecha_registro      TIMESTAMP(6)     NOT NULL,
    CONSTRAINT PK16 PRIMARY KEY (id_usuario)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Empleado(
    id_usuario            VARCHAR2(10)     NOT NULL,
    correo                VARCHAR2(255),
    fecha_inicio_cargo    DATE             NOT NULL,
    cargo                 VARCHAR2(30)     NOT NULL,
    horario_trabajo       DATE             NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY (id_usuario)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefUsuario351 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Proveedor(
    id_proveedor        VARCHAR2(20)     NOT NULL,
    telefono            VARCHAR2(10),
    pais                VARCHAR2(15)     NOT NULL,
    ciudad              VARCHAR2(85)     NOT NULL,
    avenida_calle       VARCHAR2(85)     NOT NULL,
    numero_direccion    NUMBER(38, 0)    NOT NULL,
    nombre              VARCHAR2(50)     NOT NULL,
    CONSTRAINT PK21 PRIMARY KEY (id_proveedor)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Adquisicion(
    id_usuario        VARCHAR2(10)     NOT NULL,
    id_adquisicion    VARCHAR2(25)     NOT NULL,
    id_proveedor      VARCHAR2(20)     NOT NULL,
    presupuesto       NUMBER(10, 0)    NOT NULL,
    tasacion          NUMBER(10, 0)    NOT NULL,
    CONSTRAINT PK20 PRIMARY KEY (id_usuario, id_adquisicion, id_proveedor)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefEmpleado211 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario),
    CONSTRAINT RefProveedor221 FOREIGN KEY (id_proveedor)
    REFERENCES Proveedor(id_proveedor)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Ejemplar(
    id_usuario            VARCHAR2(10)     NOT NULL,
    cod_serial            VARCHAR2(100)    NOT NULL,
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_adquisicion        VARCHAR2(25)     NOT NULL,
    id_proveedor          VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    numero_paginas        NUMBER(38, 0),
    CONSTRAINT PK13 PRIMARY KEY (id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico141 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAdquisicion201 FOREIGN KEY (id_usuario, id_adquisicion, id_proveedor)
    REFERENCES Adquisicion(id_usuario, id_adquisicion, id_proveedor)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;


CREATE TABLE Lector(
    id_usuario                     VARCHAR2(10)    NOT NULL,
    categoria_membresia            VARCHAR2(30)    NOT NULL,
    fecha_vencimiento_membresia    DATE            NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY (id_usuario)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefUsuario341 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Prestamo(
    id_usuario            VARCHAR2(10)     NOT NULL,
    id_prestamo           VARCHAR2(20)     NOT NULL,
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_adquisicion        VARCHAR2(25)     NOT NULL,
    id_proveedor          VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    cod_serial            VARCHAR2(100)    NOT NULL,
    fecha_prestamo        TIMESTAMP(6)     NOT NULL,
    fecha_devolucion      TIMESTAMP(6)     NOT NULL,
    estado_prestamo       VARCHAR2(5)      NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY (id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefEjemplar161 FOREIGN KEY (id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefLector171 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Multa(
    id_usuario            VARCHAR2(10)      NOT NULL,
    id_multa              VARCHAR2(20)      NOT NULL,
    id_mat_biblio    VARCHAR2(10)      NOT NULL,
    id_editorial          VARCHAR2(20)      NOT NULL,
    id_adquisicion        VARCHAR2(25)      NOT NULL,
    id_proveedor          VARCHAR2(20)      NOT NULL,
    id_Sede               VARCHAR2(10)      NOT NULL,
    id_estanteria         VARCHAR2(10)      NOT NULL,
    id_seccion            VARCHAR2(10)      NOT NULL,
    id_prestamo           VARCHAR2(20)      NOT NULL,
    cod_serial            VARCHAR2(100)     NOT NULL,
    monto_multa           NUMBER(10, 2)    NOT NULL,
    fecha_imposicion      TIMESTAMP(6)      NOT NULL,
    estado                VARCHAR2(10)      NOT NULL,
    fecha_pago            TIMESTAMP(6),
    CONSTRAINT PK19 PRIMARY KEY (id_usuario, id_multa, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefPrestamo181 FOREIGN KEY (id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial),
    CONSTRAINT RefEmpleado191 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        CHAR(10)        NOT NULL,
    id_usuario                   VARCHAR2(10)    NOT NULL,
    tipo_estanteria_virtual      VARCHAR2(10)    NOT NULL,
    nombre_estanteria_virtual    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK22 PRIMARY KEY (id_estanteria_virtual, id_usuario)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefLector231 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    CHAR(10)        NOT NULL,
    id_usuario               VARCHAR2(10)    NOT NULL,
    id_mat_biblio       VARCHAR2(10)    NOT NULL,
    id_editorial             VARCHAR2(20)    NOT NULL,
    id_Sede                  VARCHAR2(10)    NOT NULL,
    id_estanteria            VARCHAR2(10)    NOT NULL,
    id_seccion               VARCHAR2(10)    NOT NULL,
    CONSTRAINT PK23 PRIMARY KEY (id_estanteria_virtual, id_usuario, id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefEstanteria_virtual241 FOREIGN KEY (id_estanteria_virtual, id_usuario)
    REFERENCES Estanteria_virtual(id_estanteria_virtual, id_usuario),
    CONSTRAINT RefLector251 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario),
    CONSTRAINT RefMaterial_bibliografico261 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Idioma(
    id_idioma        VARCHAR2(2)     NOT NULL,
    nombre_idioma    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY (id_idioma)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE disponible_idioma(
    id_mat_biblio    VARCHAR2(10)    NOT NULL,
    id_idioma             VARCHAR2(2)     NOT NULL,
    id_editorial          VARCHAR2(20)    NOT NULL,
    id_Sede               VARCHAR2(10)    NOT NULL,
    id_estanteria         VARCHAR2(10)    NOT NULL,
    id_seccion            VARCHAR2(10)    NOT NULL,
    CONSTRAINT PK12 PRIMARY KEY (id_mat_biblio, id_idioma, id_editorial, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico121 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefIdioma361 FOREIGN KEY (id_idioma)
    REFERENCES Idioma(id_idioma)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Categoria(
    id_categoria    NUMBER(38, 0)    NOT NULL,
    descripcion     CLOB             NOT NULL,
    categoria       VARCHAR2(50)     NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY (id_categoria)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE tiene_categoria(
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    id_categoria          NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico71 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefCategoria91 FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Autor(
    id_autor            VARCHAR2(20)    NOT NULL,
    "nombre(s)"         VARCHAR2(50)    NOT NULL,
    primer_apellido     VARCHAR2(26)    NOT NULL,
    segundo_apellido    VARCHAR2(26)    NOT NULL,
    nacionalidad        VARCHAR2(20)    NOT NULL,
    fecha_nacimiento    DATE            NOT NULL,
    sexo                VARCHAR2(1)     NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY (id_autor)
    USING INDEX
        LOGGING
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE escrito_por(
    id_mat_biblio    VARCHAR2(10)    NOT NULL,
    id_editorial          VARCHAR2(20)    NOT NULL,
    id_autor              VARCHAR2(20)    NOT NULL,
    id_Sede               VARCHAR2(10)    NOT NULL,
    id_estanteria         VARCHAR2(10)    NOT NULL,
    id_seccion            VARCHAR2(10)    NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY (id_mat_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico61 FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAutor81 FOREIGN KEY (id_autor)
    REFERENCES Autor(id_autor)
)
LOGGING
NOPARALLEL
NOCACHE
NOCOMPRESS
;

CREATE TABLE Tipo(
    id_tipo               NUMBER(38, 0)    NOT NULL,
    tipo                  CHAR(30)         NOT NULL,
    id_mat_biblio    VARCHAR2(10),
    id_editorial          VARCHAR2(20),
    id_Sede               VARCHAR2(10),
    id_estanteria         VARCHAR2(10),
    id_seccion            VARCHAR2(10),
    CONSTRAINT PK5 PRIMARY KEY (id_tipo)
    USING INDEX
        LOGGING, 
    CONSTRAINT RefMaterial_bibliografico41 FOR
