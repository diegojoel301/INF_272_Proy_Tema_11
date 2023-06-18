DROP DATABASE bibliografica;
CREATE DATABASE bibliografica;
use bibliografica;

--
-- ER/Studio Data Architect SQL Code Generation
-- Project :      BDBibliograficaDocumentalV3.DM1
--
-- Date Created : Sunday, June 18, 2023 12:09:14
-- Target DBMS : MySQL 5.x
--

-- 
-- TABLE: Adiciona_estanteria 
--

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    CHAR(10)       NOT NULL,
    id_usuario               VARCHAR(10)    NOT NULL,
    id_material_biblio       VARCHAR(10)    NOT NULL,
    id_editorial             VARCHAR(20)    NOT NULL,
    id_Sede                  VARCHAR(10)    NOT NULL,
    id_estanteria            VARCHAR(10)    NOT NULL,
    id_seccion               VARCHAR(10)    NOT NULL,
    id_tipo                  INT            NOT NULL,
    PRIMARY KEY (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Adquisicion 
--

CREATE TABLE Adquisicion(
    id_usuario           VARCHAR(10)       NOT NULL,
    id_adquisicion       VARCHAR(25)       NOT NULL,
    id_proveedor         VARCHAR(20)       NOT NULL,
    presupuesto          DECIMAL(10, 0)    NOT NULL,
    tasacion             DECIMAL(10, 0)    NOT NULL,
    fecha_adquisicion    DATETIME          NOT NULL,
    PRIMARY KEY (id_usuario, id_adquisicion, id_proveedor)
)ENGINE=MYISAM
;



-- 
-- TABLE: Autor 
--

CREATE TABLE Autor(
    id_autor            VARCHAR(20)    NOT NULL,
    `nombre(s)`         VARCHAR(50)    NOT NULL,
    primer_apellido     VARCHAR(26)    NOT NULL,
    segundo_apellido    VARCHAR(26)    NOT NULL,
    nacionalidad        VARCHAR(20)    NOT NULL,
    fecha_nacimiento    DATE           NOT NULL,
    sexo                VARCHAR(1)     NOT NULL,
    PRIMARY KEY (id_autor)
)ENGINE=MYISAM
;



-- 
-- TABLE: Categoria 
--

CREATE TABLE Categoria(
    id_categoria    INT            AUTO_INCREMENT,
    descripcion     TEXT           NOT NULL,
    categoria       VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_categoria)
)ENGINE=MYISAM
;



-- 
-- TABLE: Editorial 
--

CREATE TABLE Editorial(
    id_editorial        VARCHAR(20)    NOT NULL,
    pais                VARCHAR(15)    NOT NULL,
    ciudad              VARCHAR(85)    NOT NULL,
    telefono            VARCHAR(10)    NOT NULL,
    nombre_editorial    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_editorial)
)ENGINE=MYISAM
;



-- 
-- TABLE: Ejemplar 
--

CREATE TABLE Ejemplar(
    id_usuario            VARCHAR(10)     NOT NULL,
    cod_serial            VARCHAR(100)    NOT NULL,
    id_material_biblio    VARCHAR(10)     NOT NULL,
    id_editorial          VARCHAR(20)     NOT NULL,
    id_adquisicion        VARCHAR(25)     NOT NULL,
    id_proveedor          VARCHAR(20)     NOT NULL,
    id_Sede               VARCHAR(10)     NOT NULL,
    id_estanteria         VARCHAR(10)     NOT NULL,
    id_seccion            VARCHAR(10)     NOT NULL,
    id_tipo               INT             NOT NULL,
    numero_paginas        INT,
    id_idioma             VARCHAR(2),
    PRIMARY KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Empleado 
--

CREATE TABLE Empleado(
    id_usuario            VARCHAR(10)     NOT NULL,
    correo                VARCHAR(255),
    fecha_inicio_cargo    DATE            NOT NULL,
    cargo                 VARCHAR(30)     NOT NULL,
    horario_trabajo       TIME            NOT NULL,
    PRIMARY KEY (id_usuario)
)ENGINE=MYISAM
;



-- 
-- TABLE: escrito_por 
--

CREATE TABLE escrito_por(
    id_material_biblio    VARCHAR(10)    NOT NULL,
    id_editorial          VARCHAR(20)    NOT NULL,
    id_autor              VARCHAR(20)    NOT NULL,
    id_Sede               VARCHAR(10)    NOT NULL,
    id_estanteria         VARCHAR(10)    NOT NULL,
    id_seccion            VARCHAR(10)    NOT NULL,
    id_tipo               INT            NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Estanteria 
--

CREATE TABLE Estanteria(
    id_Sede                     VARCHAR(10)    NOT NULL,
    id_estanteria               VARCHAR(10)    NOT NULL,
    id_seccion                  VARCHAR(10)    NOT NULL,
    capacidad                   INT,
    numero_estanteria           INT            NOT NULL,
    numero_pasillo_ubicacion    INT            NOT NULL,
    PRIMARY KEY (id_Sede, id_estanteria, id_seccion)
)ENGINE=MYISAM
;



-- 
-- TABLE: Estanteria_virtual 
--

CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        CHAR(10)       NOT NULL,
    id_usuario                   VARCHAR(10)    NOT NULL,
    tipo_estanteria_virtual      VARCHAR(10)    NOT NULL,
    nombre_estanteria_virtual    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_estanteria_virtual, id_usuario)
)ENGINE=MYISAM
;



-- 
-- TABLE: Idioma 
--

CREATE TABLE Idioma(
    id_idioma        VARCHAR(2)     NOT NULL,
    nombre_idioma    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_idioma)
)ENGINE=MYISAM
;



-- 
-- TABLE: Lector 
--

CREATE TABLE Lector(
    id_usuario                     VARCHAR(10)    NOT NULL,
    categoria_membresia            VARCHAR(30)    NOT NULL,
    fecha_vencimiento_membresia    DATE           NOT NULL,
    PRIMARY KEY (id_usuario)
)ENGINE=MYISAM
;



-- 
-- TABLE: Material_bibliografico 
--

CREATE TABLE Material_bibliografico(
    id_material_biblio                    VARCHAR(10)     NOT NULL,
    id_editorial                          VARCHAR(20)     NOT NULL,
    id_Sede                               VARCHAR(10)     NOT NULL,
    id_estanteria                         VARCHAR(10)     NOT NULL,
    id_seccion                            VARCHAR(10)     NOT NULL,
    id_tipo                               INT             NOT NULL,
    fecha_publicacion                     DATE            NOT NULL,
    descripcion_material_bibliografico    TEXT,
    titulo_material_bibliografico         VARCHAR(251)    NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Multa 
--

CREATE TABLE Multa (
    id_usuario            VARCHAR(10)        NOT NULL,
    id_multa              VARCHAR(20)        NOT NULL,
    id_material_biblio    VARCHAR(10)        NOT NULL,
    id_editorial          VARCHAR(20)        NOT NULL,
    id_adquisicion        VARCHAR(25)        NOT NULL,
    id_proveedor          VARCHAR(20)        NOT NULL,
    id_Sede               VARCHAR(10)        NOT NULL,
    id_estanteria         VARCHAR(10)        NOT NULL,
    id_seccion            VARCHAR(10)        NOT NULL,
    id_prestamo           VARCHAR(20)        NOT NULL,
    cod_serial            VARCHAR(50)        NOT NULL, -- Reducida a VARCHAR(50)
    id_tipo               INT                NOT NULL,
    monto_multa           DECIMAL(65, 0)    NOT NULL,
    fecha_imposicion      DATETIME           NOT NULL,
    estado                VARCHAR(10)        NOT NULL,
    fecha_pago            DATETIME,
    PRIMARY KEY (id_usuario, id_multa, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial, id_tipo)
) ENGINE=MYISAM;


-- 
-- TABLE: Prestamo 
--

CREATE TABLE Prestamo(
    id_usuario            VARCHAR(10)     NOT NULL,
    id_prestamo           VARCHAR(20)     NOT NULL,
    id_material_biblio    VARCHAR(10)     NOT NULL,
    id_editorial          VARCHAR(20)     NOT NULL,
    id_adquisicion        VARCHAR(25)     NOT NULL,
    id_proveedor          VARCHAR(20)     NOT NULL,
    id_Sede               VARCHAR(10)     NOT NULL,
    id_estanteria         VARCHAR(10)     NOT NULL,
    id_seccion            VARCHAR(10)     NOT NULL,
    cod_serial            VARCHAR(100)    NOT NULL,
    id_tipo               INT             NOT NULL,
    fecha_prestamo        DATETIME        NOT NULL,
    fecha_devolucion      DATETIME        NOT NULL,
    estado_prestamo       VARCHAR(5)      NOT NULL,
    PRIMARY KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Proveedor 
--

CREATE TABLE Proveedor(
    id_proveedor        VARCHAR(20)    NOT NULL,
    telefono            VARCHAR(10),
    pais                VARCHAR(15)    NOT NULL,
    ciudad              VARCHAR(85)    NOT NULL,
    avenida_calle       VARCHAR(85)    NOT NULL,
    numero_direccion    INT            NOT NULL,
    nombre              VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_proveedor)
)ENGINE=MYISAM
;



-- 
-- TABLE: Resenia 
--

CREATE TABLE Resenia(
    id_material_biblio           VARCHAR(10)    NOT NULL,
    id_resenia                   VARCHAR(20)    NOT NULL,
    id_editorial                 VARCHAR(20)    NOT NULL,
    id_Sede                      VARCHAR(10)    NOT NULL,
    id_estanteria                VARCHAR(10)    NOT NULL,
    id_seccion                   VARCHAR(10)    NOT NULL,
    id_tipo                      INT            NOT NULL,
    contenido                    TEXT,
    puntuacion                   INT            NOT NULL,
    fecha_publicacion_resenia    DATE           NOT NULL,
    PRIMARY KEY (id_material_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Seccion 
--

CREATE TABLE Seccion(
    id_Sede           VARCHAR(10)    NOT NULL,
    id_seccion        VARCHAR(10)    NOT NULL,
    nombre_Seccion    VARCHAR(30)    NOT NULL,
    PRIMARY KEY (id_Sede, id_seccion)
)ENGINE=MYISAM
;



-- 
-- TABLE: Sede 
--

CREATE TABLE Sede(
    id_Sede           VARCHAR(10)    NOT NULL,
    nombre_sede       VARCHAR(50),
    pais_Sede         VARCHAR(15)    NOT NULL,
    ciudad_Sede       VARCHAR(85)    NOT NULL,
    avenida_calle     VARCHAR(85)    NOT NULL,
    numero_sede       INT,
    capacidad_sede    INT,
    PRIMARY KEY (id_Sede)
)ENGINE=MYISAM
;



-- 
-- TABLE: tiene_categoria 
--

CREATE TABLE tiene_categoria(
    id_material_biblio    VARCHAR(10)    NOT NULL,
    id_editorial          VARCHAR(20)    NOT NULL,
    id_Sede               VARCHAR(10)    NOT NULL,
    id_estanteria         VARCHAR(10)    NOT NULL,
    id_seccion            VARCHAR(10)    NOT NULL,
    id_categoria          INT            NOT NULL,
    id_tipo               INT            NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria, id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Tipo 
--

CREATE TABLE Tipo(
    id_tipo    INT         AUTO_INCREMENT,
    tipo       CHAR(30)    NOT NULL,
    PRIMARY KEY (id_tipo)
)ENGINE=MYISAM
;



-- 
-- TABLE: Usuario 
--

CREATE TABLE Usuario(
    id_usuario          VARCHAR(10)    NOT NULL,
    celular             VARCHAR(10)    NOT NULL,
    telefonoU           VARCHAR(10),
    nombreU             VARCHAR(50)    NOT NULL,
    primer_apellido     VARCHAR(26)    NOT NULL,
    segundo_apellido    VARCHAR(26)    NOT NULL,
    ciudad              VARCHAR(85)    NOT NULL,
    pais                VARCHAR(15)    NOT NULL,
    avenida_calle       VARCHAR(85)    NOT NULL,
    numero_hogar        INT            NOT NULL,
    ci                  VARCHAR(10)    NOT NULL,
    fecha_registro      DATETIME       NOT NULL,
    PRIMARY KEY (id_usuario)
)ENGINE=MYISAM
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
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
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
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
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
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
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
    FOREIGN KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
;

ALTER TABLE Multa ADD CONSTRAINT RefEmpleado19 
    FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
;


-- 
-- TABLE: Prestamo 
--

ALTER TABLE Prestamo ADD CONSTRAINT RefEjemplar16 
    FOREIGN KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE Prestamo ADD CONSTRAINT RefLector17 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
;


-- 
-- TABLE: Resenia 
--

ALTER TABLE Resenia ADD CONSTRAINT RefMaterial_bibliografico15 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
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
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
;

ALTER TABLE tiene_categoria ADD CONSTRAINT RefCategoria9 
    FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
;


