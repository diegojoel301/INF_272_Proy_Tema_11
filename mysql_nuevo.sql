DROP DATABASE bibliografica;
CREATE DATABASE bibliografica;
use bibliografica;
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

CREATE TABLE Seccion(
    id_Sede           VARCHAR(10)    NOT NULL,
    id_seccion        VARCHAR(10)    NOT NULL,
    nombre_Seccion    VARCHAR(30)    NOT NULL,
    PRIMARY KEY (id_Sede, id_seccion), 
    CONSTRAINT RefSede11 FOREIGN KEY (id_Sede)
    REFERENCES Sede(id_Sede)
)ENGINE=MYISAM
;

CREATE TABLE Estanteria(
    id_Sede                     VARCHAR(10)    NOT NULL,
    id_estanteria               VARCHAR(10)    NOT NULL,
    id_seccion                  VARCHAR(10)    NOT NULL,
    capacidad                   INT,
    numero_estanteria           INT            NOT NULL,
    numero_pasillo_ubicacion    INT            NOT NULL,
    PRIMARY KEY (id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefSeccion21 FOREIGN KEY (id_Sede, id_seccion)
    REFERENCES Seccion(id_Sede, id_seccion)
)ENGINE=MYISAM
;

CREATE TABLE Editorial(
    id_editorial        VARCHAR(20)    NOT NULL,
    pais                VARCHAR(15)    NOT NULL,
    ciudad              VARCHAR(85)    NOT NULL,
    telefono            VARCHAR(10)    NOT NULL,
    nombre_editorial    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_editorial)
)ENGINE=MYISAM
;

CREATE TABLE Material_bibliografico(
    id_material_biblio                    VARCHAR(10)     NOT NULL,
    id_editorial                          VARCHAR(20)     NOT NULL,
    id_Sede                               VARCHAR(10)     NOT NULL,
    id_estanteria                         VARCHAR(10)     NOT NULL,
    id_seccion                            VARCHAR(10)     NOT NULL,
    fecha_publicacion                     DATE            NOT NULL,
    descripcion_material_bibliografico    TEXT,
    titulo_material_bibliografico         VARCHAR(251)    NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefEstanteria31 FOREIGN KEY (id_Sede, id_estanteria, id_seccion)
    REFERENCES Estanteria(id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefEditorial371 FOREIGN KEY (id_editorial)
    REFERENCES Editorial(id_editorial)
)ENGINE=MYISAM
;

CREATE TABLE Resenia(
    id_material_biblio           VARCHAR(10)    NOT NULL,
    id_resenia                   VARCHAR(20)    NOT NULL,
    id_editorial                 VARCHAR(20)    NOT NULL,
    id_Sede                      VARCHAR(10)    NOT NULL,
    id_estanteria                VARCHAR(10)    NOT NULL,
    id_seccion                   VARCHAR(10)    NOT NULL,
    contenido                    TEXT,
    puntuacion                   INT            NOT NULL,
    fecha_publicacion_resenia    DATE           NOT NULL,
    PRIMARY KEY (id_material_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico151 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)ENGINE=MYISAM
;

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

CREATE TABLE Empleado(
    id_usuario            VARCHAR(10)     NOT NULL,
    correo                VARCHAR(255),
    fecha_inicio_cargo    DATE            NOT NULL,
    cargo                 VARCHAR(30)     NOT NULL,
    horario_trabajo       TIME            NOT NULL,
    PRIMARY KEY (id_usuario), 
    CONSTRAINT RefUsuario351 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)ENGINE=MYISAM
;

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

CREATE TABLE Adquisicion(
    id_usuario        VARCHAR(10)       NOT NULL,
    id_adquisicion    VARCHAR(25)       NOT NULL,
    id_proveedor      VARCHAR(20)       NOT NULL,
    presupuesto       DECIMAL(10, 0)    NOT NULL,
    tasacion          DECIMAL(10, 0)    NOT NULL,
    PRIMARY KEY (id_usuario, id_adquisicion, id_proveedor), 
    CONSTRAINT RefEmpleado211 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario),
    CONSTRAINT RefProveedor221 FOREIGN KEY (id_proveedor)
    REFERENCES Proveedor(id_proveedor)
)ENGINE=MYISAM
;

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
    numero_paginas        INT,
    PRIMARY KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico141 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAdquisicion201 FOREIGN KEY (id_usuario, id_adquisicion, id_proveedor)
    REFERENCES Adquisicion(id_usuario, id_adquisicion, id_proveedor)
)ENGINE=MYISAM
;

CREATE TABLE Lector(
    id_usuario                     VARCHAR(10)    NOT NULL,
    categoria_membresia            VARCHAR(30)    NOT NULL,
    fecha_vencimiento_membresia    DATE           NOT NULL,
    PRIMARY KEY (id_usuario), 
    CONSTRAINT RefUsuario341 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)ENGINE=MYISAM
;

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
    fecha_prestamo        DATETIME        NOT NULL,
    fecha_devolucion      DATETIME        NOT NULL,
    estado_prestamo       VARCHAR(5)      NOT NULL,
    PRIMARY KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial), 
    CONSTRAINT RefEjemplar161 FOREIGN KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefLector171 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)ENGINE=MYISAM
;

CREATE TABLE Multa (
    id_multa              INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario            VARCHAR(10)        NOT NULL,
    id_material_biblio    VARCHAR(10)        NOT NULL,
    id_editorial          VARCHAR(20)        NOT NULL,
    id_adquisicion        VARCHAR(25)        NOT NULL,
    id_proveedor          VARCHAR(20)        NOT NULL,
    id_Sede               VARCHAR(10)        NOT NULL,
    id_estanteria         VARCHAR(10)        NOT NULL,
    id_seccion            VARCHAR(10)        NOT NULL,
    id_prestamo           VARCHAR(20)        NOT NULL,
    cod_serial            VARCHAR(100)       NOT NULL,
    monto_multa           DECIMAL(10, 2)     NOT NULL,
    fecha_imposicion      DATETIME           NOT NULL,
    estado                VARCHAR(10)        NOT NULL,
    fecha_pago            DATETIME,
    CONSTRAINT RefPrestamo181 FOREIGN KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial),
    CONSTRAINT RefEmpleado191 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
) ENGINE=MYISAM;



CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        CHAR(10)       NOT NULL,
    id_usuario                   VARCHAR(10)    NOT NULL,
    tipo_estanteria_virtual      VARCHAR(10)    NOT NULL,
    nombre_estanteria_virtual    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_estanteria_virtual, id_usuario), 
    CONSTRAINT RefLector231 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)ENGINE=MYISAM
;

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    CHAR(10)       NOT NULL,
    id_usuario               VARCHAR(10)    NOT NULL,
    id_material_biblio       VARCHAR(10)    NOT NULL,
    id_editorial             VARCHAR(20)    NOT NULL,
    id_Sede                  VARCHAR(10)    NOT NULL,
    id_estanteria            VARCHAR(10)    NOT NULL,
    id_seccion               VARCHAR(10)    NOT NULL,
    PRIMARY KEY (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefEstanteria_virtual241 FOREIGN KEY (id_estanteria_virtual, id_usuario)
    REFERENCES Estanteria_virtual(id_estanteria_virtual, id_usuario),
    CONSTRAINT RefLector251 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario),
    CONSTRAINT RefMaterial_bibliografico261 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)ENGINE=MYISAM
;

CREATE TABLE Idioma(
    id_idioma        VARCHAR(2)     NOT NULL,
    nombre_idioma    VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_idioma)
)ENGINE=MYISAM
;

CREATE TABLE disponible_idioma(
    id_material_biblio    VARCHAR(10)    NOT NULL,
    id_idioma             VARCHAR(2)     NOT NULL,
    id_editorial          VARCHAR(20)    NOT NULL,
    id_Sede               VARCHAR(10)    NOT NULL,
    id_estanteria         VARCHAR(10)    NOT NULL,
    id_seccion            VARCHAR(10)    NOT NULL,
    PRIMARY KEY (id_material_biblio, id_idioma, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico121 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefIdioma361 FOREIGN KEY (id_idioma)
    REFERENCES Idioma(id_idioma)
)ENGINE=MYISAM
;

CREATE TABLE Categoria(
    id_categoria    INT            AUTO_INCREMENT,
    descripcion     TEXT           NOT NULL,
    categoria       VARCHAR(50)    NOT NULL,
    PRIMARY KEY (id_categoria)
)ENGINE=MYISAM
;

CREATE TABLE tiene_categoria(
    id_material_biblio    VARCHAR(10)    NOT NULL,
    id_editorial          VARCHAR(20)    NOT NULL,
    id_Sede               VARCHAR(10)    NOT NULL,
    id_estanteria         VARCHAR(10)    NOT NULL,
    id_seccion            VARCHAR(10)    NOT NULL,
    id_categoria          INT            NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria), 
    CONSTRAINT RefMaterial_bibliografico71 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefCategoria91 FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
)ENGINE=MYISAM
;

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

CREATE TABLE escrito_por(
    id_material_biblio    VARCHAR(10)    NOT NULL,
    id_editorial          VARCHAR(20)    NOT NULL,
    id_autor              VARCHAR(20)    NOT NULL,
    id_Sede               VARCHAR(10)    NOT NULL,
    id_estanteria         VARCHAR(10)    NOT NULL,
    id_seccion            VARCHAR(10)    NOT NULL,
    PRIMARY KEY (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico61 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAutor81 FOREIGN KEY (id_autor)
    REFERENCES Autor(id_autor)
)ENGINE=MYISAM
;

CREATE TABLE Tipo(
    id_tipo               INT            AUTO_INCREMENT,
    tipo                  CHAR(30)       NOT NULL,
    id_material_biblio    VARCHAR(10),
    id_editorial          VARCHAR(20),
    id_Sede               VARCHAR(10),
    id_estanteria         VARCHAR(10),
    id_seccion            VARCHAR(10),
    PRIMARY KEY (id_tipo), 
    CONSTRAINT RefMaterial_bibliografico41 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)ENGINE=MYISAM
;


















