--
-- ER/Studio Data Architect SQL Code Generation
-- Project :      BDBibliograficaDocumentalV3.DM1
--
-- Date Created : Sunday, June 18, 2023 12:20:20
-- Target DBMS : Oracle 10g
--

-- 
-- TABLE: Adiciona_estanteria 
--

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    CHAR(10)         NOT NULL,
    id_usuario               VARCHAR2(10)     NOT NULL,
    id_mat_biblio       VARCHAR2(10)     NOT NULL,
    id_editorial             VARCHAR2(20)     NOT NULL,
    id_Sede                  VARCHAR2(10)     NOT NULL,
    id_estanteria            VARCHAR2(10)     NOT NULL,
    id_seccion               VARCHAR2(10)     NOT NULL,
    id_tipo                  NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK23 PRIMARY KEY (id_estanteria_virtual, id_usuario, id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
;



-- 
-- TABLE: Adquisicion 
--

CREATE TABLE Adquisicion(
    id_usuario           VARCHAR2(10)     NOT NULL,
    id_adquisicion       VARCHAR2(25)     NOT NULL,
    id_proveedor         VARCHAR2(20)     NOT NULL,
    presupuesto          NUMBER(19, 0)    NOT NULL,
    tasacion             NUMBER(19, 0)    NOT NULL,
    fecha_adquisicion    TIMESTAMP(6)     NOT NULL,
    CONSTRAINT PK20 PRIMARY KEY (id_usuario, id_adquisicion, id_proveedor)
)
;



-- 
-- TABLE: Autor 
--

CREATE TABLE Autor(
    id_autor            VARCHAR2(20)    NOT NULL,
    "nombre(s)"         VARCHAR2(50)    NOT NULL,
    primer_apellido     VARCHAR2(26)    NOT NULL,
    segundo_apellido    VARCHAR2(26)    NOT NULL,
    nacionalidad        VARCHAR2(20)    NOT NULL,
    fecha_nacimiento    DATE            NOT NULL,
    sexo                VARCHAR2(1)     NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY (id_autor)
)
;



-- 
-- TABLE: Categoria 
--

CREATE TABLE Categoria(
    id_categoria    NUMBER(38, 0)    NOT NULL,
    descripcion     CLOB             NOT NULL,
    categoria       VARCHAR2(50)     NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY (id_categoria)
)
;



-- 
-- TABLE: Editorial 
--

CREATE TABLE Editorial(
    id_editorial        VARCHAR2(20)    NOT NULL,
    pais                VARCHAR2(15)    NOT NULL,
    ciudad              VARCHAR2(85)    NOT NULL,
    telefono            VARCHAR2(10)    NOT NULL,
    nombre_editorial    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY (id_editorial)
)
;



-- 
-- TABLE: Ejemplar 
--

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
    id_tipo               NUMBER(38, 0)    NOT NULL,
    numero_paginas        NUMBER(38, 0),
    id_idioma             VARCHAR2(2),
    CONSTRAINT PK13 PRIMARY KEY (id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
)
;



-- 
-- TABLE: Empleado 
--

CREATE TABLE Empleado(
    id_usuario            VARCHAR2(10)     NOT NULL,
    correo                VARCHAR2(255),
    fecha_inicio_cargo    DATE             NOT NULL,
    cargo                 VARCHAR2(30)     NOT NULL,
    horario_trabajo       DATE             NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY (id_usuario)
)
;



-- 
-- TABLE: escrito_por 
--

CREATE TABLE escrito_por(
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_autor              VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    id_tipo               NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY (id_mat_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion, id_tipo)
)
;



-- 
-- TABLE: Estanteria 
--

CREATE TABLE Estanteria(
    id_Sede                     VARCHAR2(10)     NOT NULL,
    id_estanteria               VARCHAR2(10)     NOT NULL,
    id_seccion                  VARCHAR2(10)     NOT NULL,
    capacidad                   NUMBER(38, 0),
    numero_estanteria           NUMBER(38, 0)    NOT NULL,
    numero_pasillo_ubicacion    NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY (id_Sede, id_estanteria, id_seccion)
)
;



-- 
-- TABLE: Estanteria_virtual 
--

CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        CHAR(10)        NOT NULL,
    id_usuario                   VARCHAR2(10)    NOT NULL,
    tipo_estanteria_virtual      VARCHAR2(10)    NOT NULL,
    nombre_estanteria_virtual    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK22 PRIMARY KEY (id_estanteria_virtual, id_usuario)
)
;



-- 
-- TABLE: Idioma 
--

CREATE TABLE Idioma(
    id_idioma        VARCHAR2(2)     NOT NULL,
    nombre_idioma    VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY (id_idioma)
)
;



-- 
-- TABLE: Lector 
--

CREATE TABLE Lector(
    id_usuario                     VARCHAR2(10)    NOT NULL,
    categoria_membresia            VARCHAR2(30)    NOT NULL,
    fecha_vencimiento_membresia    DATE            NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY (id_usuario)
)
;



-- 
-- TABLE: Material_bibliografico 
--

CREATE TABLE Material_bibliografico(
    id_mat_biblio                    VARCHAR2(10)     NOT NULL,
    id_editorial                          VARCHAR2(20)     NOT NULL,
    id_Sede                               VARCHAR2(10)     NOT NULL,
    id_estanteria                         VARCHAR2(10)     NOT NULL,
    id_seccion                            VARCHAR2(10)     NOT NULL,
    id_tipo                               NUMBER(38, 0)    NOT NULL,
    fecha_publicacion                     DATE             NOT NULL,
    desc_mat_biblio                       CLOB,
    titulo_mat_biblio                     VARCHAR2(251)    NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
;



-- 
-- TABLE: Multa 
--

CREATE TABLE Multa(
    id_usuario            VARCHAR2(10)     NOT NULL,
    id_multa              VARCHAR2(20)     NOT NULL,
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_adquisicion        VARCHAR2(25)     NOT NULL,
    id_proveedor          VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    id_prestamo           VARCHAR2(20)     NOT NULL,
    cod_serial            VARCHAR2(100)    NOT NULL,
    id_tipo               NUMBER(38, 0)    NOT NULL,
    monto_multa           NUMBER(19, 0)    NOT NULL,
    fecha_imposicion      TIMESTAMP(6)     NOT NULL,
    estado                VARCHAR2(10)     NOT NULL,
    fecha_pago            TIMESTAMP(6),
    CONSTRAINT PK19 PRIMARY KEY (id_usuario, id_multa, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial, id_tipo)
)
;



-- 
-- TABLE: Prestamo 
--

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
    id_tipo               NUMBER(38, 0)    NOT NULL,
    fecha_prestamo        TIMESTAMP(6)     NOT NULL,
    fecha_devolucion      TIMESTAMP(6)     NOT NULL,
    estado_prestamo       VARCHAR2(5)      NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY (id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
)
;



-- 
-- TABLE: Proveedor 
--

CREATE TABLE Proveedor(
    id_proveedor        VARCHAR2(20)     NOT NULL,
    telefono            VARCHAR2(10),
    pais                VARCHAR2(15)     NOT NULL,
    ciudad              VARCHAR2(85)     NOT NULL,
    avenida_calle       VARCHAR2(85)     NOT NULL,
    numero_direccion    NUMBER(38, 0)    NOT NULL,
    nombre              VARCHAR2(50)     NOT NULL,
    CONSTRAINT PK21 PRIMARY KEY (id_proveedor)
)
;



-- 
-- TABLE: Resenia 
--

CREATE TABLE Resenia(
    id_mat_biblio           VARCHAR2(10)     NOT NULL,
    id_resenia                   VARCHAR2(20)     NOT NULL,
    id_editorial                 VARCHAR2(20)     NOT NULL,
    id_Sede                      VARCHAR2(10)     NOT NULL,
    id_estanteria                VARCHAR2(10)     NOT NULL,
    id_seccion                   VARCHAR2(10)     NOT NULL,
    id_tipo                      NUMBER(38, 0)    NOT NULL,
    contenido                    CLOB,
    puntuacion                   NUMBER(38, 0)    NOT NULL,
    fecha_publicacion_resenia    DATE             NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY (id_mat_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
;



-- 
-- TABLE: Seccion 
--

CREATE TABLE Seccion(
    id_Sede           VARCHAR2(10)    NOT NULL,
    id_seccion        VARCHAR2(10)    NOT NULL,
    nombre_Seccion    VARCHAR2(30)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY (id_Sede, id_seccion)
)
;



-- 
-- TABLE: Sede 
--

CREATE TABLE Sede(
    id_Sede           VARCHAR2(10)     NOT NULL,
    nombre_sede       VARCHAR2(50),
    pais_Sede         VARCHAR2(15)     NOT NULL,
    ciudad_Sede       VARCHAR2(85)     NOT NULL,
    avenida_calle     VARCHAR2(85)     NOT NULL,
    numero_sede       NUMBER(38, 0),
    capacidad_sede    NUMBER(38, 0),
    CONSTRAINT PK1 PRIMARY KEY (id_Sede)
)
;



-- 
-- TABLE: tiene_categoria 
--

CREATE TABLE tiene_categoria(
    id_mat_biblio    VARCHAR2(10)     NOT NULL,
    id_editorial          VARCHAR2(20)     NOT NULL,
    id_Sede               VARCHAR2(10)     NOT NULL,
    id_estanteria         VARCHAR2(10)     NOT NULL,
    id_seccion            VARCHAR2(10)     NOT NULL,
    id_categoria          NUMBER(38, 0)    NOT NULL,
    id_tipo               NUMBER(38, 0)    NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria, id_tipo)
)
;



-- 
-- TABLE: Tipo 
--

CREATE TABLE Tipo(
    id_tipo    NUMBER(38, 0)    NOT NULL,
    tipo       CHAR(30)         NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY (id_tipo)
)
;



-- 
-- TABLE: Usuario 
--

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
)
;



-- 
-- TABLE: Adiciona_estanteria 
--

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefEstanteria_virtual24 
    FOREIGN KEY (id_estanteria_virtual, id_usuario)
    REFERENCES Estanteria_virtual(id_estanteria_virtual, id_usuario)
;

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefLector25 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
;

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefMaterial_bibliografico26 
    FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;


-- 
-- TABLE: Adquisicion 
--

ALTER TABLE Adquisicion ADD CONSTRAINT RefEmpleado21 
    FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
;

ALTER TABLE Adquisicion ADD CONSTRAINT RefProveedor22 
    FOREIGN KEY (id_proveedor)
    REFERENCES Proveedor(id_proveedor)
;


-- 
-- TABLE: Ejemplar 
--

ALTER TABLE Ejemplar ADD CONSTRAINT RefIdioma46 
    FOREIGN KEY (id_idioma)
    REFERENCES Idioma(id_idioma)
;

ALTER TABLE Ejemplar ADD CONSTRAINT RefMaterial_bibliografico14 
    FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE Ejemplar ADD CONSTRAINT RefAdquisicion20 
    FOREIGN KEY (id_usuario, id_adquisicion, id_proveedor)
    REFERENCES Adquisicion(id_usuario, id_adquisicion, id_proveedor)
;


-- 
-- TABLE: Empleado 
--

ALTER TABLE Empleado ADD CONSTRAINT RefUsuario35 
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
;


-- 
-- TABLE: escrito_por 
--

ALTER TABLE escrito_por ADD CONSTRAINT RefMaterial_bibliografico6 
    FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE escrito_por ADD CONSTRAINT RefAutor8 
    FOREIGN KEY (id_autor)
    REFERENCES Autor(id_autor)
;


-- 
-- TABLE: Estanteria 
--

ALTER TABLE Estanteria ADD CONSTRAINT RefSeccion2 
    FOREIGN KEY (id_Sede, id_seccion)
    REFERENCES Seccion(id_Sede, id_seccion)
;


-- 
-- TABLE: Estanteria_virtual 
--

ALTER TABLE Estanteria_virtual ADD CONSTRAINT RefLector23 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
;


-- 
-- TABLE: Lector 
--

ALTER TABLE Lector ADD CONSTRAINT RefUsuario34 
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
;


-- 
-- TABLE: Material_bibliografico 
--

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefEstanteria3 
    FOREIGN KEY (id_Sede, id_estanteria, id_seccion)
    REFERENCES Estanteria(id_Sede, id_estanteria, id_seccion)
;

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefEditorial37 
    FOREIGN KEY (id_editorial)
    REFERENCES Editorial(id_editorial)
;

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefTipo40 
    FOREIGN KEY (id_tipo)
    REFERENCES Tipo(id_tipo)
;


-- 
-- TABLE: Multa 
--

ALTER TABLE Multa ADD CONSTRAINT RefPrestamo18 
    FOREIGN KEY (id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
;

ALTER TABLE Multa ADD CONSTRAINT RefEmpleado19 
    FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
;


-- 
-- TABLE: Prestamo 
--

ALTER TABLE Prestamo ADD CONSTRAINT RefEjemplar16 
    FOREIGN KEY (id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_mat_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE Prestamo ADD CONSTRAINT RefLector17 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
;


-- 
-- TABLE: Resenia 
--

ALTER TABLE Resenia ADD CONSTRAINT RefMaterial_bibliografico15 
    FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;


-- 
-- TABLE: Seccion 
--

ALTER TABLE Seccion ADD CONSTRAINT RefSede1 
    FOREIGN KEY (id_Sede)
    REFERENCES Sede(id_Sede)
;


-- 
-- TABLE: tiene_categoria 
--

ALTER TABLE tiene_categoria ADD CONSTRAINT RefMaterial_bibliografico7 
    FOREIGN KEY (id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_mat_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE tiene_categoria ADD CONSTRAINT RefCategoria9 
    FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
;



