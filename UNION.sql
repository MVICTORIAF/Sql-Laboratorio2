
USE LIBRERIA

--UNION 

--Cuando quiero mostrar el resultado de dos o mas consultas en una tabla de resultado
--En mis palabras me junta los resultados de la tabla clientes junto con los resultados de la tabla vendedores en una sola tabla 
--Une los resultados de las dos tablas sin un orden 
--Las dos consultas deben tener la misma cantidad de columnas (nom_cliente, ape_cliente) en ambas tablas y deben ser del mismo tipo
--En la tercer columna de de TIPO, es una columna que me dice a que resultado pertenece cada columna 
--tenemos que poner alias genericos en el nombre de la columna 
--ordenamos el resultado del union, el order by va al final 

--ANEXO DE LA CLASE...


--Cuando vemos el encabezado de una factura.... es factura
--Cuando vemos el detalle de una factura... es detalle_factura

-- cuando queremos ver la facturacion TOTAL de un negocio es una sum(precio * cantidad)

select sum(d.pre_unitario*d.cantidad) as 'FACTURACION TOTAL DEL NEGOCIO'
from detalle_facturas d



--ACTIVIDADES - GUIA UNION 
--Listar ordenando alfabeticamente por apellido y nombre, primero los vendedores y luego los clientes
select ape_cliente as Apellido, nom_cliente as Nombre , 'CLIENTE' AS TIPO
from clientes
union 
select ape_vendedor, nom_vendedor, 'VENDEDOR' AS TIPO
from vendedores 


--2. Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en 
--que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el 
--código, nombre y si se trata de un cliente o de un vendedor. Ordene por la 
--columna tercera y segunda.select  cod_cliente as 'CODIGO', nom_cliente +' '+ape_cliente as 'NOMBRE Y APELLIDO', nro_tel as 'TELEFONO' ,  [e-mail] as 'CORREO ELECTRONICO',
'CLIENTE' as tipo 
from clientes where nro_tel is not null and  [e-mail] is not null unionselect cod_vendedor as 'CODIGO',  nom_vendedor +' '+ape_vendedor as 'NOMBRE Y APELLIDO', nro_tel as 'TELEFONO' , [e-mail] as 'CORREO ELECTRONICO','VENDEDOR' as tipo from vendedores where nro_tel is not null and  [e-mail] is not null order by 3, 2--3. Emitir un listado donde se muestren qué artículos, clientes y vendedores hay en
--la empresa. Determine los campos a mostrar y su ordenamiento.select cod_cliente as 'CODIGO', nom_cliente as 'NOMBRE' , 'CLIENTE' as 'TIPO'from clientes unionselect cod_vendedor , nom_vendedor , 'VENDEDOR' as 'TIPO'from vendedoresunion select cod_articulo , observaciones , 'ARTICULO' as 'TIPO'from articulos select * from clientes--4. Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
--vendedores. Para el caso de los vendedores, códigos entre 3 y 12. En ambos
--casos las direcciones deberán ser conocidas. Rotule como NOMBRE,
--DIRECCION, BARRIO, INTEGRANTE (en donde indicará si es cliente o vendedor).
--Ordenado por la primera y la última columna.Select cod_cliente as CODIGO, nom_cliente as NOMBRE, c.calle+', '+convert(varchar,c.altura) as DIRECCION,b.barrio as BARRIO , 'CLIENTE' AS 'TIPO'from clientes c join barrios b  on b.cod_barrio = c.cod_barrioUNION Select cod_vendedor as CODIGO, nom_vendedor as NOMBRE, v.calle+', '+convert(varchar,v.altura) as DIRECCION, b.barrio as BARRIO , 'VENDEDOR' AS 'TIPO'from vendedores v join barrios b  on b.cod_barrio = v.cod_barriowhere v.cod_vendedor between 3 and 12 and calle  IS NOT NULL and altura is not null --5. Ídem al ejercicio anterior, sólo que además del código, identifique de donde 
--obtiene la información (de qué tabla se obtienen los datos)

Select convert(varchar, c.cod_cliente) + ' - TABLA CLIENTES' as CODIGO,
 ape_cliente + ', ' + nom_cliente + ' - TABLA CLIENTES' as NOMBRE,
 calle + ' ' + convert(varchar, altura) + ' - TABLA CLIENTES' as 
DIRECCIÓN,
 barrio + ' - TABLA BARRIOS' as BARRIO,
 'CLIENTE' as INTEGRANTE
from clientes c join barrios b on b.cod_barrio = c.cod_barrio
where c.calle is not null and c.altura is not null
union
select convert(varchar, v.cod_vendedor) + ' - TABLA VENDEDORES',
 ape_vendedor + ', ' + nom_vendedor + ' - TABLA VENDEDORES',
 calle + ' ' + convert(varchar, altura) + ' - TABLA VENDEDORES',
 barrio + ' - TABLA BARRIOS',
 'VENDEDOR'
from vendedores v join barrios b on b.cod_barrio = v.cod_barrio
where v.cod_vendedor between 3 and 12 and v.calle is not null and v.altura is not
null
order by 1, 4--6. Listar todos los artículos que están a la venta cuyo precio unitario oscile entre 10
--y 50; también se quieren listar los artículos que fueron comprados por los
--clientes cuyos apellidos comiencen con “M” o con “P”.


select cod_articulo as 'CODIGO' , pre_unitario as 'MONTO', descripcion as 'NOMBRE' , 'ARTICULO' AS TIPO
from articulos 
where pre_unitario between 100 and 250 
union 
select c.cod_cliente as 'CODIGO' , 2, nom_cliente , 'CLIENTE' AS TIPO
from clientes c join facturas f on f.cod_cliente = c.cod_cliente
join detalle_facturas df on df.nro_factura = f.nro_factura
join articulos a on a.cod_articulo = df.cod_articulo
where nom_cliente like '[p,m%]'



----7 El encargado del negocio quiere saber cuánto fue la facturación del año pasado.
--Por otro lado, cuánto es la facturación del mes pasado, la de este mes y la de
--hoy (Cada pedido en una consulta distinta, y puede unirla en una sola tabla de
--resultado)

--cuanto fue la facturacion del negocio ?

select sum(df.cantidad * df.pre_unitario) as 'Facturacion total', 'Año pasado' as 'Fecha'
from facturas f join detalle_facturas df on df.nro_factura = f.nro_factura
where YEAR(fecha)=YEAR(GETDATE())-1
UNION
SELECT SUM(df.cantidad * df.pre_unitario) AS 'Facturacion total', 'Mes pasado' AS 'Fecha'
FROM facturas f
JOIN detalle_facturas df ON df.nro_factura = f.nro_factura
WHERE YEAR(f.fecha) = YEAR(DATEADD(MONTH, -1, GETDATE()))
  AND MONTH(f.fecha) = MONTH(DATEADD(MONTH, -1, GETDATE()))
UNION 
SELECT SUM(df.cantidad * df.pre_unitario) AS 'Facturacion total', 'Este mes' AS 'Fecha'
FROM facturas f
JOIN detalle_facturas df ON df.nro_factura = f.nro_factura
where month(fecha)=month(GETDATE()) and YEAR(fecha)=YEAR(GETDATE())UNION select sum(d.pre_unitario*d.cantidad) AS 'Facturacion total', 'Este dia' AS 'Fecha'
from detalle_facturas d join facturas f on d.nro_factura=f.nro_factura
where day(fecha)=day(GETDATE()) and month(fecha)=month(GETDATE()) and YEAR(fecha)
=YEAR(GETDATE())






