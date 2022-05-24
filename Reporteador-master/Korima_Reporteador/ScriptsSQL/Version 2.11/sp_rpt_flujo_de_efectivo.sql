
/****** Object:  StoredProcedure [dbo].[sp_rpt_flujo_def_efectivo]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_rpt_flujo_de_efectivo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo]
GO
CREATE PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo]
@ejercicio int, @periodo int, @miles Bit, @MostrarVacios bit
AS
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @Diferencia as decimal(15,2)
Declare @CalculoFinal as decimal(15,2)

DECLARE @Division int
if @miles=1 set @Division=1000
else set @Division = 1


/*DECLARE @ejercicio int
DECLARE @periodo int
SET @ejercicio = 2012
SET @periodo = 1*/

--Inserta en tabla de memoria todos los registros de la consulta para mas fácil manejo de la información
--Tabla del Ejercicio Actual 
DECLARE @eActual TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
--Tabla del Ejercicio Anterior
DECLARE @eAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
						
--Tabla del Acumulado Actual para secciones CDEF
DECLARE @eAcumuladoActual TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
--Tabla del Acumulado Anterior para secciones CDEF
DECLARE @eAcumuladoAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))												
--Tabla de resultado a regresar						
DECLARE @report TABLE (nombre varchar(255), SaldoActual decimal(15,2), SaldoAnterior decimal(15,2), negritas tinyint, secciongroup char(1), orden decimal(15,2))


Insert Into @eActual
Select NumeroCuenta, NombreCuenta, isnull(CargosSinFlujo,0) as CargosSinFlujo, isnull(AbonosSinFlujo,0)as AbonosSinFlujo, isnull(TotalCargos,0)as TotalCargos, isnull(TotalAbonos,0)as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'C' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'E' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'G' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'I' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
          When 'I' Then 0
          Else isnull(AbonosSinFlujo,0) - isnull(CargosSinFlujo,0) + isnull(TotalAbonos,0) - isnull(TotalCargos,0) 
      End as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = @periodo And [Year] = @ejercicio) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Order By NumeroCuenta

Insert Into @eAnterior
Select NumeroCuenta, NombreCuenta, isnull(CargosSinFlujo,0) as CargosSinFlujo, isnull(AbonosSinFlujo,0)as AbonosSinFlujo, isnull(TotalCargos,0)as TotalCargos, isnull(TotalAbonos,0)as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'C' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'E' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'G' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'I' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
          When 'I' Then 0
          Else isnull(AbonosSinFlujo,0) - isnull(CargosSinFlujo,0) + isnull(TotalAbonos,0) - isnull(TotalCargos,0) 
      End as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = @periodo And [Year] = @ejercicio - 1) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Order By NumeroCuenta

Insert Into @eAcumuladoActual
Select NumeroCuenta, 
NombreCuenta, 
SUM(isnull(CargosSinFlujo,0)) as CargosSinFlujo, 
SUM(isnull(AbonosSinFlujo,0)) as AbonosSinFlujo, 
SUM(isnull(TotalCargos,0)) as TotalCargos, 
SUM(isnull(TotalAbonos,0)) as TotalAbonos,
0 as SaldoDeudor,
0 as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select IdCuentaContable, Year,Mes,SUM(isnull(TotalCargos,0)) as TotalCargos,SUM(isnull(TotalAbonos,0))as TotalAbonos,SUM(isnull(CargosSinFlujo,0)) as CargosSinFlujo,SUM(isnull(AbonosSinFlujo,0)) as AbonosSinFlujo 
From T_SaldosInicialesCont Where ( Mes between 1 and @Periodo) And [Year] = @ejercicio group by IdCuentaContable,Year,Mes) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Group By NumeroCuenta,NombreCuenta
Order By NumeroCuenta

Insert Into @eAcumuladoAnterior
Select NumeroCuenta, 
NombreCuenta, 
SUM(isnull(CargosSinFlujo,0)) as CargosSinFlujo, 
SUM(isnull(AbonosSinFlujo,0)) as AbonosSinFlujo, 
SUM(isnull(TotalCargos,0)) as TotalCargos, 
SUM(isnull(TotalAbonos,0)) as TotalAbonos,
0 as SaldoDeudor,
0 as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select IdCuentaContable, Year,Mes,SUM(isnull(TotalCargos,0)) as TotalCargos,SUM(isnull(TotalAbonos,0))as TotalAbonos,SUM(isnull(CargosSinFlujo,0)) as CargosSinFlujo,SUM(isnull(AbonosSinFlujo,0)) as AbonosSinFlujo 
From T_SaldosInicialesCont Where ( Mes between 1 and @Periodo) And [Year] = @ejercicio-1 group by IdCuentaContable,Year,Mes) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Group By NumeroCuenta,NombreCuenta
Order By NumeroCuenta
--
if @Estructura1=6 begin
--CAMBIOS PARA 6-6 INICIO
--Se eliminan cuentas de ultimo nivel en @eActual
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'
--Se eliminan cuentas de ultimo nivel en @eAnterior
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'
--
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eAcumuladoActual where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'
--Se eliminan cuentas de ultimo nivel en @eAnterior
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'

--CAMBIOS PARA 6-6 FIN
END


Declare @SaldoAcreedorActual decimal(15,2)
Declare @SaldoAcreedorAnterior decimal(15,2)

Select @SaldoAcreedorActual=isnull(a.SaldoAcreedor,0), @SaldoAcreedorAnterior =Isnull(b.SaldoAcreedor,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4173'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)

UPDATE @eActual Set SaldoAcreedor=isnull(SaldoAcreedor,0)+@SaldoAcreedorActual
Where nocuenta IN ('4172'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)  
UPDATE @eAnterior Set SaldoAcreedor=isnull(SaldoAcreedor,0)+@SaldoAcreedorAnterior 
Where nocuenta IN ('41720'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)  
--


Insert Into @report
Select 'FLUJOS DE EFECTIVO DE LAS ACTIVIDADES DE GESTIÓN',NULL, NULL, 3, 'X', 0
Union All
Select 'ORIGEN',SUM(a.SaldoAcreedor), SUM(b.SaldoAcreedor), 1, 'A', 1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('411'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'413'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'414'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'415'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'416'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'4172'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'419'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'421'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'422'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura,'412'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',2
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta = '411'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura
--Agrgegado para la version 2.9
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',2.1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta = '412'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura
--Agregado Fin
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',3
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('413'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',4
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('414'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',5
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('415'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',6
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('416'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'INGRESOS POR VENTA DE BIENES Y SERVICIOS', a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',7
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4172'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Agregado para la version 2.9
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',7.1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('419'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Agregado Fin

--Comentado version 2.9
--Union All
--Select 'OTRAS CONTRIBUCIONES CAUSADAS EN EJERCICIOS ANTERIORES', a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',8
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('41900-00000','41900-000000')
-- A 1
--Union All
--Select '',null,null,3,'X',9
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',9
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('421'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',10
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4211'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',11
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4212'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',12
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4213'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
-- A 2
--Union All
--Select '',null,null,3,'X',13
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',13
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('422'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',14
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4221'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',15
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4222'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',16
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4223'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',17
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4224'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',18
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4225'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
-- A 3
--Union All
--Select '',null,null,3,'X',19
Union All
Select 'OTROS ORIGENES DE OPERACIÓN', a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',19
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)
-- A 4
Union All
Select '',null,null,3,'X',19
--Agregado Version 2.12 INICIO
UNION ALL
Select 'SERVICIOS PERSONALES',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
((SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('11', '12', '13','14','15','16','17'))
OR (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('011', '012', '013','014','015','016','017')))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('11', '12', '13','14','15','16','17')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('011', '012', '013','014','015','016','017'))), 
0, 'X', 21
UNION ALL
Select 'MATERIALES Y SUMINISTROS',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
((SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('21', '22', '23','24','25','26','27','28','29'))
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('021', '022', '023','024','025','026','027','028','029'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('21', '22', '23','24','25','26','27','28','29')
or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('021', '022', '023','024','025','026','027','028','029'))), 
0, 'X', 22
UNION ALL
Select 'SERVICIOS GENERALES',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('31', '32', '33','34','35','36','37','38','39')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('031', '032', '033','034','035','036','037','038','039'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
((SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('31', '32', '33','34','35','36','37','38','39'))
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('031', '032', '033','034','035','036','037','038','039'))), 
0, 'X', 23
UNION ALL
Select 'TRANSFERENCIAS INTERNAS Y ASIGNACIONES AL SECTOR PÚBLICO',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('41')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('041'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('41')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('041'))), 
0, 'X', 25
UNION ALL
Select 'TRANSFERENCIAS AL RESTO DEL SECTOR PÚBLICO',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('42')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('042'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('42')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('042'))), 
0, 'X', 26
UNION ALL
Select 'SUBSIDIOS Y SUBVENCIONES',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('43')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('043'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('43')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('043'))), 
0, 'X', 27
UNION ALL
Select 'AYUDAS SOCIALES',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('44')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('044'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('44')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('044'))), 
0, 'X', 28
UNION ALL
Select 'PENSIONES Y JUBILACIONES',
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('45')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('045'))),
(Select SUM(isnull(TotalCargos,0)) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('45')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('045'))), 
0, 'X', 29
UNION ALL
Select 'TRANSFERENCIAS A FIDEICOMISOS,MANDATOS Y CONTRATOS ANÁLOGOS',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('46')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('046'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('46')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('046'))), 
0, 'X', 30
UNION ALL
Select 'TRANSFERENCIAS A LA SEGURIDAD SOCIAL',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('471')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0471'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('471')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0471'))), 
0, 'X', 31
UNION ALL
Select 'DONATIVO',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('481','482','483','484','485')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0481','0482','0483','0484','0485'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('481','482','483','484','485')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0481','0482','0483','0484','0485'))), 
0, 'X', 32
UNION ALL
Select 'TRANSFERENCIAS AL EXTERIOR',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('491','492','493')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0491','0492','0493'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('491','492','493')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0491','0492','0493'))), 
0, 'X', 33
UNION ALL
Select 'PARTICIPACIONES',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('811','812','813')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0811','0812','0813'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('811','812','813')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0811','0812','0813'))), 
0, 'X', 35
UNION ALL
Select 'APORTACIONES',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('811','812','813')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0811','0812','0813'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('831','832','833')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0831','0832','0833'))), 
0, 'X', 36
UNION ALL
Select 'CONVENIOS',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('851','852','853')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0851','0852','0853'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('851','852','853')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0851','0852','0853'))), 
0, 'X', 37
UNION ALL
Select 'OTRAS APLICACIONES DE OPERACIÓN',
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,1) In ('9')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('09'))),
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
(SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,1) In ('9')
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) In ('09'))), 
0, 'X', 37.1
insert into @report 
Select 'APLICACIÓN', sum(a.SaldoActual), sum(a.SaldoAnterior), 1, 'B',20
FROM @Report a
Where a.orden IN (21,22,23,25,26,27,28,29,30,31,32,33,35,36,37,37.1)

insert into @report values('',0,0,3,'X',37.2)
--Agregado Version 2.12 FIN


--COMENTADO VERSION 2.12 INICIO
--Union All
--Select 'APLICACIÓN', sum(a.SaldoDeudor), sum(b.SaldoDeudor), 1, 'B',20
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('51100-00000','51200-00000','51300-00000','52000-00000','53000-00000','55000-00000','51100-000000','51200-000000','51300-000000','52000-000000','53000-000000','55000-00000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',21
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('51100-00000','51100-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',22
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('51200-00000','51200-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',23
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('51300-00000','51300-000000')
---- B 1
----Comentado para la version 2.9
----Union All
----Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 2, 'X',24
----FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
----Where a.nocuenta IN ('52000-00000','52000-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',25
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52100-00000','52100-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',26
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52200-00000','52200-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',27
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52300-00000','52300-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',28
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52400-00000','52400-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',29
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52500-00000','52500-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',30
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52600-00000','52600-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',31
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52700-00000','52700-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',32
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52800-00000','52800-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',33
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('52900-00000','52900-000000')
---- B 2
----Comentado para la version 2.9
----Union All
----Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 2, 'X',34
----FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
----Where a.nocuenta IN ('53000-00000','53000-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',35
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('53100-00000','53100-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',36
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('53200-00000','53200-000000')
--Union All
--Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',37
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('53300-00000','53300-000000')
----Agregado para la version 2.9
--Union All
--Select 'OTRAS APLICACIONES DE OPERACIÓN', a.SaldoDeudor, b.SaldoDeudor, 0, 'X',37.1
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('55000-00000','55000-000000')
----Agregado fin version 2.9

--COMENTADO VERSION 2.12 FIN


-- B 3
Insert Into @report
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE OPERACIÓN' , 
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'A') -
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'B'),
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'A') -
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'B'), 1, 'X', 38
Union All
Select '',null,null,3,'X',38
Union All
Select 'FLUJOS DE EFECTIVO DE LAS ACTIVIDADES DE INVERSIÓN',null,null,3,'X',38
--C
--Comentado version 2.9
--Union All
--Select 'CONTRIBUCIONES DE CAPITAL',
----Codigo anterior, provocaba un error ya que obtenia mas de un resultado  
----(Select TotalAbonos from @eActual Where SUBSTRING(nocuenta ,1,4) = '3110'),
----(Select TotalAbonos from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '3110'), 0, 'X',40

----Cambio a acumulado
--(Select TotalAbonos from @eAcumuladoActual  Where nocuenta = '31100-00000'or nocuenta = '31100-000000'),
--(Select TotalAbonos from @eAcumuladoAnterior  Where nocuenta = '31100-00000' or nocuenta = '31100-00000')
--, 0, 'X',40

--Descomentado para la version 2.10 INICIO
Union All
Select 'BIENES INMUEBLES, INFRAESTRUCTURA Y CONSTRUCCIONES EN PROCESO',
--Cambio a acumulado 
--Se manda a Cero, codigo original comentado
(Select 0 as TotalAbonos from @eAcumuladoActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ( '523')OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))),
(Select 0 as TotalAbonos from @eAcumuladoAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ( '523') OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))), 0, 'X',39.1

--(Select TotalAbonos from @eAcumuladoActual Where SUBSTRING(nocuenta ,1,4) = '8150'
--And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524', '523')OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))),
--(Select SUM(TotalAbonos) from @eAcumuladoAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
--And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524', '523') OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))), 0, 'X',41

--Agregado Version 2.10 INICIO
Union ALL
Select 'BIENES MUEBLES',
(Select 0 as TotalAbonos from @eAcumuladoActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524')OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))),
(Select 0 as TotalAbonos from @eAcumuladoAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524') OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('0524', '0523'))), 0, 'X',39.2
--Agregado version 2.10 FIN

Union All
Select 'OTROS ORIGENES DE INVERSION', 
--Cambio a acumulado
(Select TotalAbonos from @eAcumuladoActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '525'
or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) = '0525')),
(Select TotalAbonos from @eAcumuladoAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '525'
OR SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) = '0525')), 0, 'X',39.3
--Descomentado para la version 2.10 FIN

----Agregado para la version 2.9
--Union All
--Select A.nombre, a.TotalAbonos, b.TotalAbonos, 0, 'X',39.1
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('12300-00000','12300-000000')

--Union All
--Select A.nombre, a.TotalAbonos, b.TotalAbonos, 0, 'X',39.2
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('12400-00000','12400-000000')

--Union All
--Select 'OTROS ORIGENES DE INVERSION', a.TotalAbonos, b.TotalAbonos, 0, 'X',39.3
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('12500-00000','12500-000000')

----Agregado Fin

Insert Into @report
Select 'ORIGEN', 
SUM(SaldoActual), SUM(SaldoAnterior), 1, 'C', 39 
from @report Where orden in (39.1,39.2,39.3)
-- D
Union All
Select '',null,null,3,'X',42
Union All
Select 'BIENES INMUEBLES, INFRAESTRUCTURA Y CONTRUCCIONES EN PROCESO',
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And(
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('581', '582', '583', '625', --'6231','6232', '6233', '6234',
'511', '512', '515', '521', '522', '523', '529', '519', '531', '532', '541', '542', '543', '544', '545', '549', '551', 
'561', '562', '563', '564', '565', '566', '567', '569', '513', '514', '571', '572', '573', '574', '575', '576', '577', 
'578', '579', '591', '592', '593', '594', '595', '596', '597', '598', '599')Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('6231','6232', '6233', '6234', --Movidas
'0581', '0582', '0583', '0625', --'06231','06232', '06233', '06234',
'0511', '0512', '0515', '0521', '0522', '0523', '0529', '0519', '0531', '0532', '0541', '0542', '0543', '0544', '0545', '0549', '0551', 
'0561', '0562', '0563', '0564', '0565', '0566', '0567', '0569', '0513', '0514', '0571', '0572', '0573', '0574', '0575', '0576', '0577', 
'0578', '0579', '0591', '0592', '0593', '0594', '0595', '0596', '0597', '0598', '0599') Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,5) In ('06231','06232', '06233', '06234') --Movidas
)),
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And(
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('581', '582', '583', '625', --'6231','6232', '6233', '6234',
'511', '512', '515', '521', '522', '523', '529', '519', '531', '532', '541', '542', '543', '544', '545', '549', '551', 
'561', '562', '563', '564', '565', '566', '567', '569', '513', '514', '571', '572', '573', '574', '575', '576', '577', 
'578', '579', '591', '592', '593', '594', '595', '596', '597', '598', '599') 
Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('6231','6232', '6233', '6234', --Movidas
'0581', '0582', '0583', '0625', --'06231','06232', '06233', '06234',
'0511', '0512', '0515', '0521', '0522', '0523', '0529', '0519', '0531', '0532', '0541', '0542', '0543', '0544', '0545', '0549', '0551', 
'0561', '0562', '0563', '0564', '0565', '0566', '0567', '0569', '0513', '0514', '0571', '0572', '0573', '0574', '0575', '0576', '0577', 
'0578', '0579', '0591', '0592', '0593', '0594', '0595', '0596', '0597', '0598', '0599')Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,5) In ('06231','06232', '06233', '06234')--Movidas
)), 0, 'X', 44
Union All
Select 'BIENES MUEBLES',
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('621', '622', '624')),
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('621', '622', '624')), 0, 'X', 45
Union All
Select 'OTRAS APLICACIONES DE INVERSION',
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoActual 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '589'),
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '589'), 0, 'X', 46
Insert Into @report
Select 'APLICACIÓN', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 1, 'D', 43 
From @report Where orden In (44,45,46)

Union All
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE INVERSIÓN',
((Select SUM(isnull(SaldoActual,0)) from @report Where orden in (39.1,39.2,39.3))-
(select SUM(isnull(SaldoActual,0)) From @report Where orden In (44,45,46))), 
((select SUM(isnull(SaldoAnterior,0)) from @report Where orden in (39.1,39.2,39.3) )-
(select SUM(isnull(SaldoAnterior,0)) from @report Where orden In (44,45,46))), 1, 'X', 47
--(Select SaldoActual From @report Where secciongroup = 'C') - 
--(Select SaldoActual From @report Where secciongroup = 'D'),
--(Select SaldoAnterior From @report Where secciongroup = 'C') - 
--(Select SaldoAnterior From @report Where secciongroup = 'D'), 1, 'X', 47

Union All
Select '',null,null,3,'X',47.1
Union All
Select 'FLUJO DE EFECTIVO DE LAS ACTIVIDADES DE FINANCIAMIENTO',null,null,3,'X',47.2
Union All
--E
Select 'INTERNO',
--Cambio a acumulado
(Select SUM(TotalAbonos) from @eAcumuladoActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '01' or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '001')),
--Cambio a acumulado
(Select SUM(TotalAbonos) from @eAcumuladoAnterior  Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '01' or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '001')), 0, 'X' ,50
Union All
Select 'EXTERNO',
--Cambio a acumulado
(Select SUM(TotalAbonos) from @eAcumuladoActual  Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '02'or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '001')),
--Cambio a acumulado
(Select SUM(TotalAbonos) from @eAcumuladoAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '02'or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '001')), 0, 'X' ,51
---
union ALL
Select 'OTROS ORIGENES DE FINANCIAMIENTO',
--Cambio a acumulado
(Select SUM(TotalAbonos) From @eAcumuladoActual  
Where SUBSTRING(nocuenta ,1,5) In ( '21500','21590', '22500', '22600')),
--Cambio a acumulado
(Select SUM(TotalAbonos) From @eAcumuladoAnterior  
Where SUBSTRING(nocuenta ,1,5) In ('21500','21590', '22500', '22600')), 0, 'X', 52
----
Insert Into @report
Select 'ENDEUDAMIENTO NETO', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 2, 'X', 49
From @report Where orden In (50,51,52)
--Comentado para la version 2.9
--Union All
--Select 'INCREMENTO DE OTROS PASIVOS',
----Cambio a acumulado
--(Select SUM(TotalAbonos) From @eAcumuladoActual  
--Where SUBSTRING(nocuenta ,1,5) In ('21100', '21200', '21500','21600', '21700', 
--'21900', '22100', '22100', '22400', '22500', '22600')),
----Cambio a acumulado
--(Select SUM(TotalAbonos) From @eAcumuladoAnterior  
--Where SUBSTRING(nocuenta ,1,5) In ('21100', '21200', '21500','21600', '21700', 
--'21900', '22100', '22100', '22400', '22500', '22600')), 0, 'X', 52
--Union All
--Select 'DISMINUCIÓN DE ACTIVOS FINANCIEROS',
----Cambio a acumulado
--(Select SUM(TotalAbonos) From @eAcumuladoActual  
----Where SUBSTRING(nocuenta ,1,5) In ('11220', '11230', '11240','11290', '11300', 
----'11400', '11500', '12100', '12200')),
--Where nocuenta In ('11220-00000', '11230-00000', '11240-00000','11290-00000', '11300-00000', 
--'11400-00000', '11500-00000', '12100-00000', '12200-00000','11250-00000',
----5-6
--'11220-000000', '11230-000000', '11240-000000','11290-000000', '11300-000000', 
--'11400-000000', '11500-000000', '12100-000000', '12200-000000','11250-000000'
--)),
----Cambio a acumulado
--(Select SUM(TotalAbonos) From @eAcumuladoAnterior 
--Where nocuenta In ('11220-00000', '11230-00000', '11240-00000','11290-00000', '11300-00000', 
--'11400-00000', '11500-00000', '12100-00000', '12200-00000','11250-00000',
----5-6
--'11220-000000', '11230-000000', '11240-000000','11290-000000', '11300-000000', 
--'11400-000000', '11500-000000', '12100-000000', '12200-000000','11250-000000'
--)), 0, 'X', 53

Insert Into @report
Select 'ORIGEN',
SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 1, 'E', 48
From @report Where orden In(49,52,53)

-- F
--Union All
--Select '',null,null,3,'X',53
--Comentado para a version 2.9
--Union All
--Select 'INCREMENTO DE ACTIVOS FINANCIEROS',
----Cambio a acumulado
--(Select SUM(TotalCargos) From @eAcumuladoActual 
--Where nocuenta In ('11220-00000', '11230-00000', '11240-00000','11290-00000', '11300-00000', 
--'11400-00000', '11500-00000', '12100-00000', '12200-00000','11250-00000',
----5-6
--'11220-000000', '11230-000000', '11240-000000','11290-000000', '11300-000000', 
--'11400-000000', '11500-000000', '12100-000000', '12200-000000','11250-000000'
--)),
----Cambio a acumulado
--(Select SUM(TotalCargos) From @eAcumuladoAnterior 
--Where nocuenta In ('11220-00000', '11230-00000', '11240-00000','11290-00000', '11300-00000', 
--'11400-00000', '11500-00000', '12100-00000', '12200-00000','11250-00000',
----5-6
--'11220-000000', '11230-000000', '11240-000000','11290-000000', '11300-000000', 
--'11400-000000', '11500-000000', '12100-000000', '12200-000000','11250-000000'
--)), 0, 'X', 55
Union All
Select 'INTERNO',
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoActual  Where SUBSTRING(nocuenta ,1,4) = '8270'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('911', '912', '913')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0911', '0912', '0913'))),
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoAnterior  Where SUBSTRING(nocuenta ,1,4) = '8270'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('911', '912', '913')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0911', '0912', '0913'))), 0, 'X' ,57
Union All
Select 'EXTERNO',
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoActual  Where SUBSTRING(nocuenta ,1,4) = '8270'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('914', '915', '916', '917', '918')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0914', '0915', '0916', '0917', '0918'))),
--Cambio a acumulado
(Select SUM(TotalCargos) from @eAcumuladoAnterior  Where SUBSTRING(nocuenta ,1,4) = '8270'
And (SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('914', '915', '916', '917', '918')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0914', '0915', '0916', '0917', '0918'))), 0, 'X' ,58
----
Union All
Select 'OTRAS APLICACIONES DE FINANCIAMIENTO',
--Cambio a acumulado
(Select SUM(TotalCargos) From @eAcumuladoActual  
Where SUBSTRING(nocuenta ,1,5) In ('21500','21590', '22500', '22600')),
--Cambio a acumulado
(Select SUM(TotalCargos) From @eAcumuladoAnterior 
Where SUBSTRING(nocuenta ,1,5) In ('21500','21590', '22500', '22600')), 0, 'X', 59

Insert Into @report
Select 'SERVICIOS DE LA DEUDA', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 2, 'X', 56
From @report Where orden In (57, 58,59)
--Comentado para la version 2.9
--Union All
--Select 'DISMUNICIÓN DE OTROS PASIVOS',
----Cambio a acumulado
--(Select SUM(TotalCargos) From @eAcumuladoActual  
--Where SUBSTRING(nocuenta ,1,5) In ('21100', '21200', '21500','21600', '21700', 
--'21900', '22100', '22100', '22400', '22500', '22600')),
----Cambio a acumulado
--(Select SUM(TotalCargos) From @eAcumuladoAnterior 
--Where SUBSTRING(nocuenta ,1,5) In ('21100', '21200', '21500','21600', '21700', 
--'21900', '22100', '22100', '22400', '22500', '22600')), 0, 'X', 59
Insert Into @report
Select 'APLICACIÓN', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 1, 'F', 54
From @report Where orden In (55, 56, 59)
-- F
Insert Into @report
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE FINANCIAMIENTO',
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'E') - 
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'F'),
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'E') - 
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'F'), 1, 'X', 60
Union All
Select '',null,null,3,'X',60
Union All
Select '',null,null,3,'X',60
insert into @Report
--
Select 'INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO',
((Select isnull(SaldoActual,0) From @report Where secciongroup = 'A') - 
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'B')) +
(((Select isnull(SaldoActual,0) From @report Where secciongroup = 'C') - 
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'D')) +
((Select isnull(SaldoActual,0) From @report Where secciongroup = 'E') -
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'F'))),

((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'A') - 
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'B')) +
(((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'C') -
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'D')) +
((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'E') -
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'F'))) 
--((Select SaldoDeudor From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110')
--(Select cSinFlujo From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110')),
--((Select SaldoDeudor From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')
--(Select cSinFlujo From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110'))
,1, 'X', 61

Union All
--CONSULTA DE ENERO
Select 'EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL EJERCICIO*',
(Select isnull(CargosSinFlujo,0) as CargosSinFlujo
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = 1 And [Year] = @ejercicio ) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X'  and NumeroCuenta in ('111'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)),
(Select isnull(CargosSinFlujo,0) as CargosSinFlujo
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = 1 And [Year] = @ejercicio-1 ) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X'  and NumeroCuenta in ('111'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
--(Select isnull(cSinFlujo,0) From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110'),
--(Select isnull(cSinFlujo,0) From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')
, 1, 'X', 62
insert into @report 
--Union All
Select 'EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL FINAL DEL EJERCICIO',
--(Select isnull(SaldoActual,0) from @report where nombre='INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO')+
--(Select isnull(SaldoActual,0) from @report where nombre='EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL EJERCICIO*'),
--(Select isnull(SaldoAnterior,0)  from @report where nombre='INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO')+
--(Select isnull(SaldoAnterior,0) from @report where nombre='EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL EJERCICIO*')
(Select SaldoDeudor From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110'),
(Select SaldoDeudor From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')
, 1, 'X', 63

--insert into @Report  --Comentado DM
--Select 'INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO',
--((Select isnull(SaldoActual,0) From @report where orden = 63)- (Select isnull(SaldoActual,0) From @report where orden = 62)),
--((Select isnull(SaldoAnterior,0) From @report where orden = 63)-(Select isnull(SaldoAnterior,0) From @report where orden = 62)) 
--,1, 'X', 61

SET @CalculoFinal = (Select isnull(SaldoActual,0) From @report where orden = 63) - (Select isnull(SaldoActual,0) From @report where orden = 62)
SET @Diferencia = @CalculoFinal - (Select isnull(SaldoActual,0) From @report where orden = 61)

Update @report Set SaldoActual = @CalculoFinal where orden = 61

IF @Diferencia > 0 Begin
	Update @report Set SaldoActual =  
	( (Select isnull(SaldoActual,0) From @report where orden = 21) - @Diferencia ) where orden = 21
	
	Update @report Set SaldoActual = 
	( (Select isnull(SaldoActual,0) From @report where orden = 20) - @Diferencia ) where orden = 20
	 
    Update @report Set SaldoActual = 
	( (Select isnull(SaldoActual,0) From @report where orden = 1) - (Select isnull(SaldoActual,0) From @report where orden = 20) ) 
	where orden = 38 AND nombre = 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE OPERACIÓN'
End


--((Select isnull(SaldoActual,0) From @report where orden = 63)- (Select isnull(SaldoActual,0) From @report where orden = 62)),
--((Select isnull(SaldoAnterior,0) From @report where orden = 63)-(Select isnull(SaldoAnterior,0) From @report where orden = 62)) 
--,1, 'X', 61

--Agregado para la version 2.9

--Insert Into @report values ('',null,null,3,'X',23.1)
--Insert Into @report SELECT '', SUM(SaldoActual) ,SUM(SaldoAnterior),1,'X',23.2 From @Report Where orden In (25,26,27,28,29,30,31,32,33)

--Insert Into @report values ('',null,null,3,'X',33.1)
--Insert Into @report SELECT '',SUM(SaldoActual),SUM(SaldoAnterior),1,'X',33.2 From @Report Where Orden In (35,36,37,37.1)
--Agregado Fin
--Agregado mayo 2015
--Delete @report where orden in (2.1,39.1,39.2,39.3,44,45,46,10,11,12,14,15,16,17,18)
Delete @report where orden in (10,11,12,14,15,16,17,18)


if @MostrarVacios =1 begin
Select nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
negritas, secciongroup, orden from @report Order by orden
end
Else begin
Select nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
negritas, secciongroup, orden from @report  Where (SaldoActual<>0 or SaldoAnterior <>0) or negritas in(1,3)  Order by orden
End

--select * from @eActual Where nocuenta IN ('43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)
--select * from @eAnterior Where nocuenta IN ('43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)

GO

EXEC SP_FirmasReporte 'Estado de Flujos de Efectivo'
GO


EXEC sp_rpt_flujo_de_efectivo
2015,1,0,1

