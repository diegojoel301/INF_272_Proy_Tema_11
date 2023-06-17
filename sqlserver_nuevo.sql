DROP DATABASE bibliografica;
CREATE DATABASE bibliografica;

USE BIBLIOGRAFICA;

GO

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

CREATE TABLE Seccion(
    id_Sede           varchar(10)    NOT NULL,
    id_seccion        varchar(10)    NOT NULL,
    nombre_Seccion    varchar(30)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (id_Sede, id_seccion), 
    CONSTRAINT RefSede1 FOREIGN KEY (id_Sede)
    REFERENCES Sede(id_Sede)
)
go

CREATE TABLE Estanteria(
    id_Sede                     varchar(10)    NOT NULL,
    id_estanteria               varchar(10)    NOT NULL,
    id_seccion                  varchar(10)    NOT NULL,
    capacidad                   int            NULL,
    numero_estanteria           int            NOT NULL,
    numero_pasillo_ubicacion    int            NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefSeccion2 FOREIGN KEY (id_Sede, id_seccion)
    REFERENCES Seccion(id_Sede, id_seccion)
)
go

CREATE TABLE Editorial(
    id_editorial        varchar(20)    NOT NULL,
    pais                varchar(15)    NOT NULL,
    ciudad              varchar(85)    NOT NULL,
    telefono            varchar(10)    NOT NULL,
    nombre_editorial    varchar(50)    NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY NONCLUSTERED (id_editorial)
)
go

CREATE TABLE Material_bibliografico(
    id_material_biblio                    varchar(10)     NOT NULL,
    id_editorial                          varchar(20)     NOT NULL,
    id_Sede                               varchar(10)     NOT NULL,
    id_estanteria                         varchar(10)     NOT NULL,
    id_seccion                            varchar(10)     NOT NULL,
    fecha_publicacion                     date            NOT NULL,
    descripcion_material_bibliografico    text            NULL,
    titulo_material_bibliografico         varchar(251)    NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefEstanteria3 FOREIGN KEY (id_Sede, id_estanteria, id_seccion)
    REFERENCES Estanteria(id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefEditorial37 FOREIGN KEY (id_editorial)
    REFERENCES Editorial(id_editorial)
)
go

CREATE TABLE Resenia(
    id_material_biblio           varchar(10)    NOT NULL,
    id_resenia                   varchar(20)    NOT NULL,
    id_editorial                 varchar(20)    NOT NULL,
    id_Sede                      varchar(10)    NOT NULL,
    id_estanteria                varchar(10)    NOT NULL,
    id_seccion                   varchar(10)    NOT NULL,
    contenido                    text           NULL,
    puntuacion                   int            NOT NULL,
    fecha_publicacion_resenia    date           NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_resenia, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico15 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)
go

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

CREATE TABLE Empleado(
    id_usuario            varchar(10)     NOT NULL,
    correo                varchar(255)    NULL,
    fecha_inicio_cargo    date            NOT NULL,
    cargo                 varchar(30)     NOT NULL,
    horario_trabajo       time(7)         NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY NONCLUSTERED (id_usuario), 
    CONSTRAINT RefUsuario35 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)
go

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

CREATE TABLE Adquisicion(
    id_usuario        varchar(10)    NOT NULL,
    id_adquisicion    varchar(25)    NOT NULL,
    id_proveedor      varchar(20)    NOT NULL,
    presupuesto       money          NOT NULL,
    tasacion          money          NOT NULL,
    CONSTRAINT PK20 PRIMARY KEY NONCLUSTERED (id_usuario, id_adquisicion, id_proveedor), 
    CONSTRAINT RefEmpleado21 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario),
    CONSTRAINT RefProveedor22 FOREIGN KEY (id_proveedor)
    REFERENCES Proveedor(id_proveedor)
)
go

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
    numero_paginas        int             NULL,
    CONSTRAINT PK13 PRIMARY KEY NONCLUSTERED (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico14 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAdquisicion20 FOREIGN KEY (id_usuario, id_adquisicion, id_proveedor)
    REFERENCES Adquisicion(id_usuario, id_adquisicion, id_proveedor)
)
go

CREATE TABLE Lector(
    id_usuario                     varchar(10)    NOT NULL,
    categoria_membresia            varchar(30)    NOT NULL,
    fecha_vencimiento_membresia    date           NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY NONCLUSTERED (id_usuario), 
    CONSTRAINT RefUsuario34 FOREIGN KEY (id_usuario)
    REFERENCES Usuario(id_usuario)
)
go

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
    fecha_prestamo        datetime        NOT NULL,
    fecha_devolucion      datetime        NOT NULL,
    estado_prestamo       varchar(5)      NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY NONCLUSTERED (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial), 
    CONSTRAINT RefEjemplar16 FOREIGN KEY (id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion)
    REFERENCES Ejemplar(id_usuario, cod_serial, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefLector17 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)
go

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
    monto_multa           money           NOT NULL,
    fecha_imposicion      datetime        NOT NULL,
    estado                varchar(10)     NOT NULL,
    fecha_pago            datetime        NULL,
    CONSTRAINT PK19 PRIMARY KEY NONCLUSTERED (id_usuario, id_multa, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, id_prestamo, cod_serial), 
    CONSTRAINT RefPrestamo18 FOREIGN KEY (id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial)
    REFERENCES Prestamo(id_usuario, id_prestamo, id_material_biblio, id_editorial, id_adquisicion, id_proveedor, id_Sede, id_estanteria, id_seccion, cod_serial),
    CONSTRAINT RefEmpleado19 FOREIGN KEY (id_usuario)
    REFERENCES Empleado(id_usuario)
)
go

CREATE TABLE Estanteria_virtual(
    id_estanteria_virtual        char(10)       NOT NULL,
    id_usuario                   varchar(10)    NOT NULL,
    tipo_estanteria_virtual      varchar(10)    NOT NULL,
    nombre_estanteria_virtual    varchar(50)    NOT NULL,
    CONSTRAINT PK22 PRIMARY KEY NONCLUSTERED (id_estanteria_virtual, id_usuario), 
    CONSTRAINT RefLector23 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario)
)
go

CREATE TABLE Adiciona_estanteria(
    id_estanteria_virtual    char(10)       NOT NULL,
    id_usuario               varchar(10)    NOT NULL,
    id_material_biblio       varchar(10)    NOT NULL,
    id_editorial             varchar(20)    NOT NULL,
    id_Sede                  varchar(10)    NOT NULL,
    id_estanteria            varchar(10)    NOT NULL,
    id_seccion               varchar(10)    NOT NULL,
    CONSTRAINT PK23 PRIMARY KEY NONCLUSTERED (id_estanteria_virtual, id_usuario, id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefEstanteria_virtual24 FOREIGN KEY (id_estanteria_virtual, id_usuario)
    REFERENCES Estanteria_virtual(id_estanteria_virtual, id_usuario),
    CONSTRAINT RefLector25 FOREIGN KEY (id_usuario)
    REFERENCES Lector(id_usuario),
    CONSTRAINT RefMaterial_bibliografico26 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)
go

CREATE TABLE Idioma(
    id_idioma        varchar(2)     NOT NULL,
    nombre_idioma    varchar(50)    NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY NONCLUSTERED (id_idioma)
)
go

CREATE TABLE disponible_idioma(
    id_material_biblio    varchar(10)    NOT NULL,
    id_idioma             varchar(2)     NOT NULL,
    id_editorial          varchar(20)    NOT NULL,
    id_Sede               varchar(10)    NOT NULL,
    id_estanteria         varchar(10)    NOT NULL,
    id_seccion            varchar(10)    NOT NULL,
    CONSTRAINT PK12 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_idioma, id_editorial, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico12 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefIdioma36 FOREIGN KEY (id_idioma)
    REFERENCES Idioma(id_idioma)
)
go

CREATE TABLE Categoria(
    id_categoria    int            IDENTITY(1,1),
    descripcion     text           NOT NULL,
    categoria       varchar(50)    NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (id_categoria)
)
go

CREATE TABLE tiene_categoria(
    id_material_biblio    varchar(10)    NOT NULL,
    id_editorial          varchar(20)    NOT NULL,
    id_Sede               varchar(10)    NOT NULL,
    id_estanteria         varchar(10)    NOT NULL,
    id_seccion            varchar(10)    NOT NULL,
    id_categoria          int            NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion, id_categoria), 
    CONSTRAINT RefMaterial_bibliografico7 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefCategoria9 FOREIGN KEY (id_categoria)
    REFERENCES Categoria(id_categoria)
)
go

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

CREATE TABLE escrito_por(
    id_material_biblio    varchar(10)    NOT NULL,
    id_editorial          varchar(20)    NOT NULL,
    id_autor              varchar(20)    NOT NULL,
    id_Sede               varchar(10)    NOT NULL,
    id_estanteria         varchar(10)    NOT NULL,
    id_seccion            varchar(10)    NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY NONCLUSTERED (id_material_biblio, id_editorial, id_autor, id_Sede, id_estanteria, id_seccion), 
    CONSTRAINT RefMaterial_bibliografico6 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion),
    CONSTRAINT RefAutor8 FOREIGN KEY (id_autor)
    REFERENCES Autor(id_autor)
)
go

CREATE TABLE Tipo(
    id_tipo               int            IDENTITY(1,1),
    tipo                  char(30)       NOT NULL,
    id_material_biblio    varchar(10)    NULL,
    id_editorial          varchar(20)    NULL,
    id_Sede               varchar(10)    NULL,
    id_estanteria         varchar(10)    NULL,
    id_seccion            varchar(10)    NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (id_tipo), 
    CONSTRAINT RefMaterial_bibliografico4 FOREIGN KEY (id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
    REFERENCES Material_bibliografico(id_material_biblio, id_editorial, id_Sede, id_estanteria, id_seccion)
)
go

