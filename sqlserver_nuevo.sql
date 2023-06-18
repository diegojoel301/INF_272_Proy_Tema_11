DROP DATABASE bibliografica;
CREATE DATABASE bibliografica;

USE BIBLIOGRAFICA;

GO

/*
 * ER/Studio Data Architect SQL Code Generation
 * Project :      BDBibliograficaDocumentalV3.DM1
 *
 * Date Created : Sunday, June 18, 2023 12:11:27
 * Target DBMS : Microsoft SQL Server 2017
 */

USE Bibliografica
go
/* 
 * TABLE: Adiciona_estanteria 
 */

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    char(10)       NOT NULL,
    id_usuario               varchar(10)    NOT NULL,
    id_material_biblio       varchar(10)    NOT NULL,
    id_editorial             varchar(20)    NOT NULL,
    id_Sede                  varchar(10)    NOT NULL,
    id_estanteria            varchar(10)    NOT NULL,
    id_seccion               varchar(10)    NOT NULL,
    id_tipo                  int            NOT NULL,
    CONSTRAINT PK23 PRIMARY KEY NONCLUSTERED (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
go



IF OBJECT_ID('Adiciona_estanteria') IS NOT NULL
    PRINT '<<< CREATED TABLE Adiciona_estanteria >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Adiciona_estanteria >>>'
go

/* 
 * TABLE: Adquisicion 
 */

CREATE TABLE Adquisicion(
    id_usuario           varchar(10)    NOT NULL,
    id_adquisicion       varchar(25)    NOT NULL,
    id_proveedor         varchar(20)    NOT NULL,
    presupuesto          money          NOT NULL,
    tasacion             money          NOT NULL,
    fecha_adquisicion    datetime       NOT NULL,
    CONSTRAINT PK20 PRIMARY KEY NONCLUSTERED (id_usuario, id_adquisicion, id_proveedor)
)
go



IF OBJECT_ID('Adquisicion') IS NOT NULL
    PRINT '<<< CREATED TABLE Adquisicion >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Adquisicion >>>'
go

/* 
 * TABLE: Autor 
 */

CREATE TABLE Autor(
    id_autor            varchar(20)    NOT NULL,
    [nombre(s)]         varchar(50)    NOT NULL,
    primer_apellido     varchar(26)    NOT NULL,
    segundo_apellido    varchar(26)    NOT NULL,
    nacionalidad        varchar(20)    NOT NULL,
    fecha_nacimiento    date           NOT NULL,
    sexo                varchar(1)     NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY NONCLUSTERED (id_autor)
)
go



IF OBJECT_ID('Autor') IS NOT NULL
    PRINT '<<< CREATED TABLE Autor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Autor >>>'
go

/* 
 * TABLE: Categoria 
 */

CREATE TABLE Categoria(
    id_categoria    int            IDENTITY(1,1),
    descripcion     text           NOT NULL,
    categoria       varchar(50)    NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (id_categoria)
)
go



IF OBJECT_ID('Categoria') IS NOT NULL
    PRINT '<<< CREATED TABLE Categoria >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Categoria >>>'
go

/* 
 * TABLE: Editorial 
 */

CREATE TABLE Editorial(
    id_editorial        varchar(20)    NOT NULL,
    pais                varchar(15)    NOT NULL,
    ciudad              varchar(85)    NOT NULL,
    telefono            varchar(10)    NOT NULL,
    nombre_editorial    varchar(50)    NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY NONCLUSTERED (id_editorial)
)
go



IF OBJECT_ID('Editorial') IS NOT NULL
    PRINT '<<< CREATED TABLE Editorial >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Editorial >>>'
go

/* 
 * TABLE: Ejemplar 
 */

CREATE TABLE Ejemplar(
    id_usuario            varchar(10)     NOT NULL,
    cod_serial            varchar(100)    NOT NULL,
    id_material_biblio    varchar(10)     NOT NULL,
    id_editorial          varchar(20)     NOT NULL,
    id_adquisicion        varchar(25)     NOT NULL,
    id_proveedor          varchar(20)     NOT NULL,
    id_Sede               varchar(10)     NOT NULL,
    id_estanteria         varchar(10)     NOT NULL,
    id_seccion            varchar(10)     NOT NULL,
    id_tipo               int             NOT NULL,
    numero_paginas        int             NULL,
    id_idioma             varchar(2)      NULL,
    CONSTRAINT PK13 PRIMARY KEY NONCLUSTERED (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
)
go



IF OBJECT_ID('Ejemplar') IS NOT NULL
    PRINT '<<< CREATED TABLE Ejemplar >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Ejemplar >>>'
go

/* 
 * TABLE: Empleado 
 */

CREATE TABLE Empleado(
    id_usuario            varchar(10)     NOT NULL,
    correo                varchar(255)    NULL,
    fecha_inicio_cargo    date            NOT NULL,
    cargo                 varchar(30)     NOT NULL,
    horario_trabajo       time(7)         NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY NONCLUSTERED (id_usuario)
)
go



IF OBJECT_ID('Empleado') IS NOT NULL
    PRINT '<<< CREATED TABLE Empleado >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Empleado >>>'
go

/* 
 * TABLE: escrito_por 
 */

CREATE TABLE escrito_por(
    id_material_biblio    varchar(10)    NOT NULL,
    id_editorial          varchar(20)    NOT NULL,
    id_autor              varchar(20)    NOT NULL,
    id_Sede               varchar(10)    NOT NULL,
    id_estanteria         varchar(10)    NOT NULL,
    id_seccion            varchar(10)    NOT NULL,
    id_tipo               int            NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion, id_tipo)
)
go



IF OBJECT_ID('escrito_por') IS NOT NULL
    PRINT '<<< CREATED TABLE escrito_por >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE escrito_por >>>'
go

/* 
 * TABLE: Estanteria 
 */

CREATE TABLE Estanteria(
    id_Sede                     varchar(10)    NOT NULL,
    id_estanteria               varchar(10)    NOT NULL,
    id_seccion                  varchar(10)    NOT NULL,
    capacidad                   int            NULL,
    numero_estanteria           int            NOT NULL,
    numero_pasillo_ubicacion    int            NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (id_Sede, id_estanteria, id_seccion)
)
go



IF OBJECT_ID('Estanteria') IS NOT NULL
    PRINT '<<< CREATED TABLE Estanteria >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Estanteria >>>'
go

/* 
 * TABLE: Estanteria_virtual 
 */

CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        char(10)       NOT NULL,
    id_usuario                   varchar(10)    NOT NULL,
    tipo_estanteria_virtual      varchar(10)    NOT NULL,
    nombre_estanteria_virtual    varchar(50)    NOT NULL,
    CONSTRAINT PK22 PRIMARY KEY NONCLUSTERED (id_estanteria_virtual, id_usuario)
)
go



IF OBJECT_ID('Estanteria_virtual') IS NOT NULL
    PRINT '<<< CREATED TABLE Estanteria_virtual >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Estanteria_virtual >>>'
go

/* 
 * TABLE: Idioma 
 */

CREATE TABLE Idioma(
    id_idioma        varchar(2)     NOT NULL,
    nombre_idioma    varchar(50)    NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY NONCLUSTERED (id_idioma)
)
go



IF OBJECT_ID('Idioma') IS NOT NULL
    PRINT '<<< CREATED TABLE Idioma >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Idioma >>>'
go

/* 
 * TABLE: Lector 
 */

CREATE TABLE Lector(
    id_usuario                     varchar(10)    NOT NULL,
    categoria_membresia            varchar(30)    NOT NULL,
    fecha_vencimiento_membresia    date           NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY NONCLUSTERED (id_usuario)
)
go



IF OBJECT_ID('Lector') IS NOT NULL
    PRINT '<<< CREATED TABLE Lector >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Lector >>>'
go

/* 
 * TABLE: Material_bibliografico 
 */

CREATE TABLE Material_bibliografico(
    id_material_biblio                    varchar(10)     NOT NULL,
    id_editorial                          varchar(20)     NOT NULL,
    id_Sede                               varchar(10)     NOT NULL,
    id_estanteria                         varchar(10)     NOT NULL,
    id_seccion                            varchar(10)     NOT NULL,
    id_tipo                               int             NOT NULL,
    fecha_publicacion                     date            NOT NULL,
    descripcion_material_bibliografico    text            NULL,
    titulo_material_bibliografico         varchar(251)    NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
go



IF OBJECT_ID('Material_bibliografico') IS NOT NULL
    PRINT '<<< CREATED TABLE Material_bibliografico >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Material_bibliografico >>>'
go

/* 
 * TABLE: Multa 
 */

CREATE TABLE Multa(
    id_usuario            varchar(10)     NOT NULL,
    id_multa              varchar(20)     NOT NULL,
    id_material_biblio    varchar(10)     NOT NULL,
    id_editorial          varchar(20)     NOT NULL,
    id_adquisicion        varchar(25)     NOT NULL,
    id_proveedor          varchar(20)     NOT NULL,
    id_Sede               varchar(10)     NOT NULL,
    id_estanteria         varchar(10)     NOT NULL,
    id_seccion            varchar(10)     NOT NULL,
    id_prestamo           varchar(20)     NOT NULL,
    cod_serial            varchar(100)    NOT NULL,
    id_tipo               int             NOT NULL,
    monto_multa           money           NOT NULL,
    fecha_imposicion      datetime        NOT NULL,
    estado                varchar(10)     NOT NULL,
    fecha_pago            datetime        NULL,
    CONSTRAINT PK19 PRIMARY KEY NONCLUSTERED (id_usuario, id_multa, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial, id_tipo)
)
go



IF OBJECT_ID('Multa') IS NOT NULL
    PRINT '<<< CREATED TABLE Multa >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Multa >>>'
go

/* 
 * TABLE: Prestamo 
 */

CREATE TABLE Prestamo(
    id_usuario            varchar(10)     NOT NULL,
    id_prestamo           varchar(20)     NOT NULL,
    id_material_biblio    varchar(10)     NOT NULL,
    id_editorial          varchar(20)     NOT NULL,
    id_adquisicion        varchar(25)     NOT NULL,
    id_proveedor          varchar(20)     NOT NULL,
    id_Sede               varchar(10)     NOT NULL,
    id_estanteria         varchar(10)     NOT NULL,
    id_seccion            varchar(10)     NOT NULL,
    cod_serial            varchar(100)    NOT NULL,
    id_tipo               int             NOT NULL,
    fecha_prestamo        datetime        NOT NULL,
    fecha_devolucion      datetime        NOT NULL,
    estado_prestamo       varchar(5)      NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY NONCLUSTERED (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
)
go



IF OBJECT_ID('Prestamo') IS NOT NULL
    PRINT '<<< CREATED TABLE Prestamo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Prestamo >>>'
go

/* 
 * TABLE: Proveedor 
 */

CREATE TABLE Proveedor(
    id_proveedor        varchar(20)    NOT NULL,
    telefono            varchar(10)    NULL,
    pais                varchar(15)    NOT NULL,
    ciudad              varchar(85)    NOT NULL,
    avenida_calle       varchar(85)    NOT NULL,
    numero_direccion    int            NOT NULL,
    nombre              varchar(50)    NOT NULL,
    CONSTRAINT PK21 PRIMARY KEY NONCLUSTERED (id_proveedor)
)
go



IF OBJECT_ID('Proveedor') IS NOT NULL
    PRINT '<<< CREATED TABLE Proveedor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Proveedor >>>'
go

/* 
 * TABLE: Resenia 
 */

CREATE TABLE Resenia(
    id_material_biblio           varchar(10)    NOT NULL,
    id_resenia                   varchar(20)    NOT NULL,
    id_editorial                 varchar(20)    NOT NULL,
    id_Sede                      varchar(10)    NOT NULL,
    id_estanteria                varchar(10)    NOT NULL,
    id_seccion                   varchar(10)    NOT NULL,
    id_tipo                      int            NOT NULL,
    contenido                    text           NULL,
    puntuacion                   int            NOT NULL,
    fecha_publicacion_resenia    date           NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
)
go



IF OBJECT_ID('Resenia') IS NOT NULL
    PRINT '<<< CREATED TABLE Resenia >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Resenia >>>'
go

/* 
 * TABLE: Seccion 
 */

CREATE TABLE Seccion(
    id_Sede           varchar(10)    NOT NULL,
    id_seccion        varchar(10)    NOT NULL,
    nombre_Seccion    varchar(30)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (id_Sede, id_seccion)
)
go



IF OBJECT_ID('Seccion') IS NOT NULL
    PRINT '<<< CREATED TABLE Seccion >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Seccion >>>'
go

/* 
 * TABLE: Sede 
 */

CREATE TABLE Sede(
    id_Sede           varchar(10)    NOT NULL,
    nombre_sede       varchar(50)    NULL,
    pais_Sede         varchar(15)    NOT NULL,
    ciudad_Sede       varchar(85)    NOT NULL,
    avenida_calle     varchar(85)    NOT NULL,
    numero_sede       int            NULL,
    capacidad_sede    int            NULL,
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (id_Sede)
)
go



IF OBJECT_ID('Sede') IS NOT NULL
    PRINT '<<< CREATED TABLE Sede >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Sede >>>'
go

/* 
 * TABLE: tiene_categoria 
 */

CREATE TABLE tiene_categoria(
    id_material_biblio    varchar(10)    NOT NULL,
    id_editorial          varchar(20)    NOT NULL,
    id_Sede               varchar(10)    NOT NULL,
    id_estanteria         varchar(10)    NOT NULL,
    id_seccion            varchar(10)    NOT NULL,
    id_categoria          int            NOT NULL,
    id_tipo               int            NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria, id_tipo)
)
go



IF OBJECT_ID('tiene_categoria') IS NOT NULL
    PRINT '<<< CREATED TABLE tiene_categoria >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE tiene_categoria >>>'
go

/* 
 * TABLE: Tipo 
 */

CREATE TABLE Tipo(
    id_tipo    int         IDENTITY(1,1),
    tipo       char(30)    NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (id_tipo)
)
go



IF OBJECT_ID('Tipo') IS NOT NULL
    PRINT '<<< CREATED TABLE Tipo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Tipo >>>'
go

/* 
 * TABLE: Usuario 
 */

CREATE TABLE Usuario(
    id_usuario          varchar(10)    NOT NULL,
    celular             varchar(10)    NOT NULL,
    telefonoU           varchar(10)    NULL,
    nombreU             varchar(50)    NOT NULL,
    primer_apellido     varchar(26)    NOT NULL,
    segundo_apellido    varchar(26)    NOT NULL,
    ciudad              varchar(85)    NOT NULL,
    pais                varchar(15)    NOT NULL,
    avenida_calle       varchar(85)    NOT NULL,
    numero_hogar        int            NOT NULL,
    ci                  varchar(10)    NOT NULL,
    fecha_registro      datetime       NOT NULL,
    CONSTRAINT PK16 PRIMARY KEY NONCLUSTERED (id_usuario)
)
go



IF OBJECT_ID('Usuario') IS NOT NULL
    PRINT '<<< CREATED TABLE Usuario >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Usuario >>>'
go

/* 
 * TABLE: Adiciona_estanteria 
 */

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefEstanteria_virtual24 
    FOREIGN KEY (id_estanteria_virtual, id_usuario)
    REFERENCES Estanteria_virtual(id_estanteria_virtual, id_usuario)
go

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefLector25 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
go

ALTER TABLE Adiciona_estanteria ADD CONSTRAINT RefMaterial_bibliografico26 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
go


/* 
 * TABLE: Adquisicion 
 */

ALTER TABLE Adquisicion ADD CONSTRAINT RefEmpleado21 
    FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
go

ALTER TABLE Adquisicion ADD CONSTRAINT RefProveedor22 
    FOREIGN KEY (id_proveedor)
    REFERENCES Proveedor(id_proveedor)
go


/* 
 * TABLE: Ejemplar 
 */

ALTER TABLE Ejemplar ADD CONSTRAINT RefIdioma46 
    FOREIGN KEY (id_idioma)
    REFERENCES Idioma(id_idioma)
go

ALTER TABLE Ejemplar ADD CONSTRAINT RefMaterial_bibliografico14 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
go

ALTER TABLE Ejemplar ADD CONSTRAINT RefAdquisicion20 
    FOREIGN KEY (id_usuario, id_adquisicion, id_proveedor)
    REFERENCES Adquisicion(id_usuario, id_adquisicion, id_proveedor)
go


/* 
 * TABLE: Empleado 
 */

ALTER TABLE Empleado ADD CONSTRAINT RefUsuario35 
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
go


/* 
 * TABLE: escrito_por 
 */

ALTER TABLE escrito_por ADD CONSTRAINT RefMaterial_bibliografico6 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
go

ALTER TABLE escrito_por ADD CONSTRAINT RefAutor8 
    FOREIGN KEY (id_autor)
    REFERENCES Autor(id_autor)
go


/* 
 * TABLE: Estanteria 
 */

ALTER TABLE Estanteria ADD CONSTRAINT RefSeccion2 
    FOREIGN KEY (id_Sede, id_seccion)
    REFERENCES Seccion(id_Sede, id_seccion)
go


/* 
 * TABLE: Estanteria_virtual 
 */

ALTER TABLE Estanteria_virtual ADD CONSTRAINT RefLector23 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
go


/* 
 * TABLE: Lector 
 */

ALTER TABLE Lector ADD CONSTRAINT RefUsuario34 
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
go


/* 
 * TABLE: Material_bibliografico 
 */

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefEstanteria3 
    FOREIGN KEY (id_Sede, id_estanteria, id_seccion)
    REFERENCES Estanteria(id_Sede, id_estanteria, id_seccion)
go

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefEditorial37 
    FOREIGN KEY (id_editorial)
    REFERENCES Editorial(id_editorial)
go

ALTER TABLE Material_bibliografico ADD CONSTRAINT RefTipo40 
    FOREIGN KEY (id_tipo)
    REFERENCES Tipo(id_tipo)
go


/* 
 * TABLE: Multa 
 */

ALTER TABLE Multa ADD CONSTRAINT RefPrestamo18 
    FOREIGN KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial, id_tipo)
go

ALTER TABLE Multa ADD CONSTRAINT RefEmpleado19 
    FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
go


/* 
 * TABLE: Prestamo 
 */

ALTER TABLE Prestamo ADD CONSTRAINT RefEjemplar16 
    FOREIGN KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_tipo)
go

ALTER TABLE Prestamo ADD CONSTRAINT RefLector17 
    FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
go


/* 
 * TABLE: Resenia 
 */

ALTER TABLE Resenia ADD CONSTRAINT RefMaterial_bibliografico15 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
go


/* 
 * TABLE: Seccion 
 */

ALTER TABLE Seccion ADD CONSTRAINT RefSede1 
    FOREIGN KEY (id_Sede)
    REFERENCES Sede(id_Sede)
go


/* 
 * TABLE: tiene_categoria 
 */

ALTER TABLE tiene_categoria ADD CONSTRAINT RefMaterial_bibliografico7 
    FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_tipo)
go

ALTER TABLE tiene_categoria ADD CONSTRAINT RefCategoria9 
    FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
go
