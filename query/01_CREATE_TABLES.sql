-- mysql script generated by mysql workbench
-- wed oct 21 16:56:44 2020
-- model: new model    version: 1.0
-- mysql workbench forward engineering

set @old_unique_checks=@@unique_checks, unique_checks=0;
set @old_foreign_key_checks=@@foreign_key_checks, foreign_key_checks=0;
set @old_sql_mode=@@sql_mode, sql_mode='only_full_group_by,strict_trans_tables,no_zero_in_date,no_zero_date,error_for_division_by_zero,no_engine_substitution';

-- -----------------------------------------------------
-- schema salesdb
-- -----------------------------------------------------
drop schema if exists `salesdb` ;

-- -----------------------------------------------------
-- schema salesdb
-- -----------------------------------------------------
create schema if not exists `salesdb` default character set utf8 ;
use `salesdb` ;

-- -----------------------------------------------------
-- table `salesdb`.`persona`
-- -----------------------------------------------------
drop table if exists `salesdb`.`persona` ;

create table if not exists `salesdb`.`persona` (
  `idpersona` int not null auto_increment,
  `nombres` varchar(100) not null,
  `apepat` varchar(100) null,
  `apemat` varchar(100) null,
  `email` varchar(45) not null,
  `numdoc` varchar(45) null,
  `tipodoc` varchar(45) null,
  `estado` char(1) null,
  `departamento` varchar(45) null,
  `provincia` varchar(45) null,
  `distrito` varchar(45) null,
  `ubigueo` varchar(45) null,
  primary key (`idpersona`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`autor`
-- -----------------------------------------------------
drop table if exists `salesdb`.`autor` ;

create table if not exists `salesdb`.`autor` (
  `idautor` int not null,
  `publicaciones` varchar(45) null,
  `fecharegistro` datetime null,
  `estado` char(1) null,
  `codautor` varchar(45) null,
  primary key (`idautor`),
  unique index `codautor_unique` (`codautor` asc) visible,
  constraint `pk_persona_autor`
    foreign key (`idautor`)
    references `salesdb`.`persona` (`idpersona`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`categoria`
-- -----------------------------------------------------
drop table if exists `salesdb`.`categoria` ;

create table if not exists `salesdb`.`categoria` (
  `idcategoria` int not null,
  `descripcion` varchar(45) null,
  `estado` varchar(45) null,
  primary key (`idcategoria`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`libro`
-- -----------------------------------------------------
drop table if exists `salesdb`.`libro` ;

create table if not exists `salesdb`.`libro` (
  `idlibro` int not null auto_increment,
  `nombre` varchar(45) null,
  `descripcion` varchar(200),
  `idcategoria` int not null,
  `stockventa` int null,
  `stockalquiler` int null,
  `tipo` char(1) null comment 'f=fisico/v=virtual',
  `idautor` int null,
  `estado` char(1) null,
  `costoalquiler` decimal(10,2) null,
  `costoventa` decimal(10,2) null,
  primary key (`idlibro`),
  index `fk_autor_libro_idx` (`idautor` asc) visible,
  index `fk_categoria_libro_idx` (`idcategoria` asc) visible,
  constraint `fk_autor_libro`
    foreign key (`idautor`)
    references `salesdb`.`autor` (`idautor`)
    on delete no action
    on update no action,
  constraint `fk_categoria_libro`
    foreign key (`idcategoria`)
    references `salesdb`.`categoria` (`idcategoria`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`sede`
-- -----------------------------------------------------
drop table if exists `salesdb`.`sede` ;

create table if not exists `salesdb`.`sede` (
  `idsede` int not null auto_increment,
  `nombre` varchar(45) null,
  `departamento` varchar(45) null,
  `distrito` varchar(45) null,
  `estado` varchar(45) null,
  primary key (`idsede`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`cliente`
-- -----------------------------------------------------
drop table if exists `salesdb`.`cliente` ;

create table if not exists `salesdb`.`cliente` (
  `idcliente` int not null,
  `estado` char(1) null,
  `fecharegistro` datetime null,
  `codcliente` varchar(45) null,
  primary key (`idcliente`),
  unique index `codcliente_unique` (`codcliente` asc) visible,
  constraint `pk_persona`
    foreign key (`idcliente`)
    references `salesdb`.`persona` (`idpersona`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`libro_fisico`
-- -----------------------------------------------------
drop table if exists `salesdb`.`libro_fisico` ;

create table if not exists `salesdb`.`libro_fisico` (
  `idlibro` int not null auto_increment,
  `codlibfis` varchar(45) not null,
  `tipo` char(1) null comment 'v=venta / a=alquiler',
  `estado` char(1) null,
  `fechaingreso` datetime null,
  index `fk_fisico_libro_idx` (`idlibro` asc) visible,
  primary key (`codlibfis`),
  constraint `fk_fisico_libro`
    foreign key (`idlibro`)
    references `salesdb`.`libro` (`idlibro`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`planes`
-- -----------------------------------------------------
drop table if exists `salesdb`.`planes` ;

create table if not exists `salesdb`.`planes` (
  `idplan` int not null auto_increment,
  `descripcion` varchar(45) null,
  `tipo` varchar(45) null comment '0=prueba/1=bronce/2=plata/3=primiun',
  `costo` decimal(10,2) null,
  `estado` char(1) null,
  `promoalquiler` int null comment 'porcentaje de descuento alquiler',
  `promoventa` int null comment 'porcentaje de descuento venta',
  `deliverygratis` char(1) null,
  primary key (`idplan`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`suscripcion`
-- -----------------------------------------------------
drop table if exists `salesdb`.`suscripcion` ;

create table if not exists `salesdb`.`suscripcion` (
  `idsuscripcion` int not null auto_increment,
  `idcliente` int not null,
  `fechainicio` datetime null,
  `estado` char(1) null,
  `fechafin` datetime null,
  `idplan` int not null,
  primary key (`idsuscripcion`),
  index `fk_susc_cliente_idx` (`idcliente` asc) visible,
  index `fk_susc_plan_idx` (`idplan` asc) visible,
  constraint `fk_susc_cliente`
    foreign key (`idcliente`)
    references `salesdb`.`cliente` (`idcliente`)
    on delete no action
    on update no action,
  constraint `fk_susc_plan`
    foreign key (`idplan`)
    references `salesdb`.`planes` (`idplan`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`delivery`
-- -----------------------------------------------------
drop table if exists `salesdb`.`delivery` ;

create table if not exists `salesdb`.`delivery` (
  `iddelivery` int not null auto_increment,
  `costo` decimal(10,2) null,
  `departamento` varchar(45) null,
  `provincia` varchar(45) null,
  `distrito` varchar(45) null,
  primary key (`iddelivery`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`alquiler`
-- -----------------------------------------------------
drop table if exists `salesdb`.`alquiler` ;

create table if not exists `salesdb`.`alquiler` (
  `idalquiler` int not null auto_increment,
  `codalquiler` varchar(45) not null,
  `codlibfis` varchar(45) null,
  `idcliente` int null,
  `idsuscripcion` int null,
  `fecha_emision` datetime null,
  `total` decimal(10,2) null,
  `fecha_entrega` datetime null,
  `estado` char(1) null,
  `iddelivery` int null,
  `direccion_entrega` varchar(45) null,
  `referencia` varchar(45) null,
  primary key (`idalquiler`),
  index `fk_alq_libfis_idx` (`codlibfis` asc) visible,
  index `fk_alq_cliente_idx` (`idcliente` asc) visible,
  index `fk_suscripcion_idx` (`idsuscripcion` asc) visible,
  constraint `fk_alq_libfis`
    foreign key (`codlibfis`)
    references `salesdb`.`libro_fisico` (`codlibfis`)
    on delete no action
    on update no action,
  constraint `fk_alq_cliente`
    foreign key (`idcliente`)
    references `salesdb`.`cliente` (`idcliente`)
    on delete no action
    on update no action,
  constraint `fk_suscripcion`
    foreign key (`idsuscripcion`)
    references `salesdb`.`suscripcion` (`idsuscripcion`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`det_sede_libro`
-- -----------------------------------------------------
drop table if exists `salesdb`.`det_sede_libro` ;

create table if not exists `salesdb`.`det_sede_libro` (
  `idsede` int not null,
  `codlibfis` varchar(45) not null,
  `estado` varchar(45) null comment 'r=reservado/d=disponible',
  index `fk_det_sede_idx` (`idsede` asc) visible,
  index `fk_det_libfis_idx` (`codlibfis` asc) visible,
  constraint `fk_det_sede`
    foreign key (`idsede`)
    references `salesdb`.`sede` (`idsede`)
    on delete no action
    on update no action,
  constraint `fk_det_libfis`
    foreign key (`codlibfis`)
    references `salesdb`.`libro_fisico` (`codlibfis`)
    on delete no action
    on update no action)
engine = innodb;



-- -----------------------------------------------------
-- table `salesdb`.`usuario`
-- -----------------------------------------------------
drop table if exists `salesdb`.`usuario` ;

create table if not exists `salesdb`.`usuario` (
  `idusuario` int not null auto_increment,
  `usuario` varchar(45) not null,
  `password` varchar(70) not null,
  `idpersona` int not null,
  `estado` char(1) not null,
  primary key (`idusuario`),
  unique index `idusuario_unique` (`idusuario` asc) visible,
  index `fk_usuario_persona_idx` (`idpersona` asc) visible,
  constraint `fk_usuario_persona`
    foreign key (`idpersona`)
    references `salesdb`.`persona` (`idpersona`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`valoracion`
-- -----------------------------------------------------
drop table if exists `salesdb`.`valoracion` ;

create table if not exists `salesdb`.`valoracion` (
  `idvaloracion` int not null auto_increment,
  `descripcion` varchar(45) null,
  `cantestrellas` varchar(45) null,
  primary key (`idvaloracion`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`det_val_libro`
-- -----------------------------------------------------
drop table if exists `salesdb`.`det_val_libro` ;

create table if not exists `salesdb`.`det_val_libro` (
  `idvaloracion` int null,
  `idlibro` int null,
  `idcliente` int null,
  `comentario` varchar(45) null,
  `estado` char(1) null,
  index `fk_det_val_idx` (`idvaloracion` asc) visible,
  index `fk_detv_libro_idx` (`idlibro` asc) visible,
  index `fk_detv_cliente_idx` (`idcliente` asc) visible,
  constraint `fk_detv_val`
    foreign key (`idvaloracion`)
    references `salesdb`.`valoracion` (`idvaloracion`)
    on delete no action
    on update no action,
  constraint `fk_detv_libro`
    foreign key (`idlibro`)
    references `salesdb`.`libro` (`idlibro`)
    on delete no action
    on update no action,
  constraint `fk_detv_cliente`
    foreign key (`idcliente`)
    references `salesdb`.`cliente` (`idcliente`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`venta`
-- -----------------------------------------------------
drop table if exists `salesdb`.`venta` ;

create table if not exists `salesdb`.`venta` (
  `idcarrito` int not null,
  `codventa` varchar(50) not null,
  `codlibfis` varchar(45) not null,
  `estado` char(1) null,
  `subtotal` decimal(10,2) null,
   primary key (`idcarrito`,`codlibfis`,`codventa`),
  index `fk_detv_venta_idx` (`idcarrito` asc) visible,
  constraint `fk_venta_carrito`
    foreign key (`idcarrito`)
    references `salesdb`.`carrito_tmp` (`idcarrito`)
    on delete no action
    on update no action,
  constraint `fk_venta_libfis`
    foreign key (`codlibfis`)
    references `salesdb`.`libro_fisico` (`codlibfis`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`perfil`
-- -----------------------------------------------------
drop table if exists `salesdb`.`perfil` ;

create table if not exists `salesdb`.`perfil` (
  `idperfil` int not null auto_increment,
  `descripcion` varchar(45) null,
  `estado` char(1) null,
  primary key (`idperfil`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`detalle_usuario_perfil`
-- -----------------------------------------------------
drop table if exists `salesdb`.`detalle_usuario_perfil` ;

create table if not exists `salesdb`.`detalle_usuario_perfil` (
  `idusuario` int not null,
  `idperfil` int not null,
  `estado` char(1) null,
  index `fk_detu_usuario_idx` (`idusuario` asc) visible,
  index `fk_detu_perfil_idx` (`idperfil` asc) visible,
  constraint `fk_detu_usuario`
    foreign key (`idusuario`)
    references `salesdb`.`usuario` (`idusuario`)
    on delete no action
    on update no action,
  constraint `fk_detu_perfil`
    foreign key (`idperfil`)
    references `salesdb`.`perfil` (`idperfil`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`empleado`
-- -----------------------------------------------------
drop table if exists `salesdb`.`empleado` ;

create table if not exists `salesdb`.`empleado` (
  `idempleado` int not null,
  `idsede` int null,
  `estado` char(1) null,
  `codempleado` varchar(45) null,
  index `fk_emp_sede_idx` (`idsede` asc) visible,
  primary key (`idempleado`),
  constraint `fk_emp_sede`
    foreign key (`idsede`)
    references `salesdb`.`sede` (`idsede`)
    on delete no action
    on update no action,
  constraint `pk_persona_emp`
    foreign key (`idempleado`)
    references `salesdb`.`persona` (`idpersona`)
    on delete no action
    on update no action)
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`condicion_entrega`
-- -----------------------------------------------------
drop table if exists `salesdb`.`condicion_entrega` ;

create table if not exists `salesdb`.`condicion_entrega` (
  `idtipo` int not null,
  `descripcion` varchar(45) null,
  `estado` char(1) null,
  primary key (`idtipo`))
engine = innodb;


-- -----------------------------------------------------
-- table `salesdb`.`recepcion_alquiler`
-- -----------------------------------------------------
drop table if exists `salesdb`.`recepcion_alquiler` ;

create table if not exists `salesdb`.`recepcion_alquiler` (
  `idalquiler` int not null,
  `idempleado` int null,
  `idcliente` int null,
  `idcondicionrecep` int null,
  `fecharecepcion` datetime null,
  `observacion` varchar(45) null,
  primary key (`idalquiler`),
  index `fk_dev_cli_idx` (`idcliente` asc) visible,
  index `fk_dev_emp_idx` (`idempleado` asc) visible,
  index `fk_dev_con_idx` (`idcondicionrecep` asc) visible,
  constraint `fk_dev_alq`
    foreign key (`idalquiler`)
    references `salesdb`.`alquiler` (`idalquiler`)
    on delete no action
    on update no action,
  constraint `fk_dev_cli`
    foreign key (`idcliente`)
    references `salesdb`.`cliente` (`idcliente`)
    on delete no action
    on update no action,
  constraint `fk_dev_emp`
    foreign key (`idempleado`)
    references `salesdb`.`empleado` (`idempleado`)
    on delete no action
    on update no action,
  constraint `fk_dev_con`
    foreign key (`idcondicionrecep`)
    references `salesdb`.`condicion_entrega` (`idtipo`)
    on delete no action
    on update no action)
engine = innodb;


set sql_mode=@old_sql_mode;
set foreign_key_checks=@old_foreign_key_checks;
set unique_checks=@old_unique_checks;
