
--Este trigger muestra el precio anterior de un tipo de guitarra y el actualizado con el 15% de descuento.


drop table Guitarras;
drop table Nuevo_Precio_Guitarra;
drop trigger TR_Cambio_Precio_Guitarra;

 create table Guitarras(
  codigo number,
  Nombre varchar2(20),
  precio number
 );
 
 create table Nuevo_Precio_Guitarra(
  usuario_Act varchar2(25),
  fecha date,
  codigo number,
  precioanterior number,
  precionuevo number
 );
INSERT INTO Guitarras ( codigo,  Nombre, precio) VALUES (1,'Valencia c 16',390000);
INSERT INTO Guitarras ( codigo,  Nombre, precio) VALUES (2,'Fender 60c',1700000);
INSERT INTO Guitarras ( codigo,  Nombre, precio) VALUES (3,'Alhambra 28',1579000);
INSERT INTO Guitarras ( codigo,  Nombre, precio) VALUES (4,'ibañes 21a',980000);


create or replace trigger TR_Cambio_Precio_Guitarra
 after update of precio 
 on Guitarras
 for each row
 begin
  insert into Nuevo_Precio_Guitarra values(user,sysdate,:new.codigo,:old.precio,:new.precio);

 end TR_Cambio_Precio_Guitarra;
 /
select*from Guitarras;
update Guitarras set precio=precio*0.85  where codigo=2; 
select*from Guitarras,Nuevo_Precio_Guitarra;



