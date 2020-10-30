CREATE TABLE IF NOT EXISTS `salesdb`.`carrito_tmp`
(
`idcarrito` int NOT NULL AUTO_INCREMENT, 
`idcliente` int,
`estado` char(1),
`fecha` date,
`total` decimal(10,2),
PRIMARY KEY (`idcarrito`),
INDEX `FK_CAR_CLIENTE_idx` (`idcliente` ASC) VISIBLE,
CONSTRAINT `FK_CAR_CLIENTE`
    FOREIGN KEY (`idcliente`)
    REFERENCES `salesdb`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS `salesdb`.`det_carrito_tmp`
(
`idcarrito` int, 
`idlibro` int,
`cantidad` int,
`tipo` char(1),
`subtotal` decimal(10,2),
INDEX `FK_DCAR_LIBRO_idx` (`idlibro` ASC) VISIBLE,
INDEX `FK_DCAR_CARRITO_idx` (`idcarrito` ASC) VISIBLE,
CONSTRAINT `FK_DCAR_LIBRO`
    FOREIGN KEY (`idlibro`)
    REFERENCES `salesdb`.`libro` (`idlibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `FK_DCAR_CARRITO`
    FOREIGN KEY (`idcarrito`)
    REFERENCES `salesdb`.`carrito_tmp` (`idcarrito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION) ENGINE = InnoDB;
    
    
