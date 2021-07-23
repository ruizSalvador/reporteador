
/****** Object:  StoredProcedure [dbo].[SP_RPT_Flujo_de_Efectivo_EF]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Flujo_de_Efectivo_EF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Flujo_de_Efectivo_EF]
GO

-- EXEC SP_RPT_Flujo_de_Efectivo_EF 2020,12,0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_Flujo_de_Efectivo_EF]
@ejercicio int, @periodo int, @miles Bit, @MostrarVacios bit,@Redondeo bit
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
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2), Afectable int, Financiero int,CuentaNumero bigint)
--Tabla del Ejercicio Anterior
DECLARE @eAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2), Afectable int, Financiero int,CuentaNumero bigint)

						--Tabla del Ejercicio AnteAnterior
DECLARE @eAnteAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2), Afectable int, Financiero int,CuentaNumero bigint)
						
--Tabla del Acumulado Actual para secciones CDEF
DECLARE @eAcumuladoActual TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
--Tabla del Acumulado Anterior para secciones CDEF
DECLARE @eAcumuladoAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))												
--Tabla de resultado a regresar						
DECLARE @report TABLE (nombre varchar(255), SaldoActual decimal(15,2), SaldoAnterior decimal(15,2), negritas tinyint, secciongroup char(1), orden decimal(15,2))
declare @ejAnt int = @ejercicio-1
declare @ejAnteAnt int = @ejercicio-2

Insert Into @eActual
EXEC SP_RPT_K2_BalanzaAcumulada 1,@periodo,@ejercicio,0,0,0,0,0,0,'','',0,0

Insert Into @eAnterior
EXEC SP_RPT_K2_BalanzaAcumulada 1,@periodo,@ejAnt,0,0,0,0,0,0,'','',0,0


Insert Into @eAnteAnterior
EXEC SP_RPT_K2_BalanzaAcumulada 1,@periodo,@ejAnteAnt,0,0,0,0,0,0,'','',0,0


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
From T_SaldosInicialesCont Where Mes =@Periodo  And [Year] = @ejercicio group by IdCuentaContable,Year,Mes) Saldos 
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
From T_SaldosInicialesCont Where Mes = @Periodo And [Year] = @ejercicio-1 group by IdCuentaContable,Year,Mes) Saldos
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
----Se eliminan cuentas de ultimo nivel en @eAnterior
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
----Se eliminan cuentas de ultimo nivel en @eAnterior
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eAcumuladoAnterior where SUBSTRING(nocuenta,1,6) like '____98788_' and SUBSTRING(nocuenta,1,6) not like '____55657690'

--CAMBIOS PARA 6-6 FIN
END


Declare @SaldoAcreedorActual decimal(15,2)
Declare @SaldoAcreedorAnterior decimal(15,2)

Select @SaldoAcreedorActual=isnull(a.totalabonos,0), @SaldoAcreedorAnterior =Isnull(b.totalabonos,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('4173'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)

UPDATE @eActual Set SaldoAcreedor=isnull(SaldoAcreedor,0)+@SaldoAcreedorActual
Where nocuenta IN ('4172'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)  
UPDATE @eAnterior Set SaldoAcreedor=isnull(SaldoAcreedor,0)+@SaldoAcreedorAnterior 
Where nocuenta IN ('41720'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)  


Declare @ActividadesInversion as Table (nocuenta varchar(50), Actual decimal(18,2), Anterior decimal(18,2), AnteAnterior decimal(18,2))
Declare @ActividadesFinanciamiento as Table (nocuenta varchar(50), Actual decimal(18,2), Anterior decimal(18,2), AnteAnterior decimal(18,2))
Declare @AplicacionesOperacion as Table (nocuenta varchar(50), Actual decimal(18,2), Anterior decimal(18,2), AnteAnterior decimal(18,2))


Insert into @ActividadesInversion
Select a.nocuenta, isnull(a.SaldoDeudor,0), isnull(b.SaldoDeudor,0), isnull(c.SaldoDeudor,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
left join @eAnteAnterior c on a.nocuenta = c.nocuenta
Where a.nocuenta IN ('114'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '115'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '121'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '123'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '124'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '125'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '129'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)

Insert into @ActividadesInversion
Select a.nocuenta, isnull(a.SaldoAcreedor,0), isnull(b.SaldoAcreedor,0), isnull(c.SaldoAcreedor,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
left join @eAnteAnterior c on a.nocuenta = c.nocuenta
Where a.nocuenta IN ('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)


Insert into @ActividadesFinanciamiento
Select a.nocuenta, isnull(a.SaldoDeudor,0), isnull(b.SaldoDeudor,0), isnull(c.SaldoDeudor,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
left join @eAnteAnterior c on a.nocuenta = c.nocuenta
Where a.nocuenta IN ('112'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'113'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'119'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'122'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'127'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)


Insert into @ActividadesFinanciamiento
Select a.nocuenta, isnull(a.SaldoAcreedor,0), isnull(b.SaldoAcreedor,0), isnull(c.SaldoAcreedor,0)
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
left join @eAnteAnterior c on a.nocuenta = c.nocuenta
Where a.nocuenta IN ('2131'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2133'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2141'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2231'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2233'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura, '2235'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,
'2132'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2142'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2232'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2234'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,
'211'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '212'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '215'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'216'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '217'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '219'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '221'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '222'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '224'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '225'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '226'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)

Insert into @AplicacionesOperacion (nocuenta, Actual, Anterior, AnteAnterior)
VALUES
('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,0,0,0),
('128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,0,0,0),
('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,0,0,0)

--UPDATE @AplicacionesOperacion 
--set T.Actual = isnull(i.Actual,0), T.Anterior = isnull(i.Anterior,0), T.AnteAnterior = isnull(i.AnteAnterior,0)
--FROM @AplicacionesOperacion T
--INNER JOIN (
-- Select a.nocuenta, isnull(a.SaldoDeudor,0) as Actual, isnull(b.SaldoDeudor,0) as Anterior, isnull(c.SaldoDeudor,0) as AnteAnterior
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--left join @eAnteAnterior c on a.nocuenta = c.nocuenta
--Where a.nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) i
--ON i.nocuenta = T.nocuenta
--WHERE i.nocuenta = T.nocuenta

UPDATE @AplicacionesOperacion 
set T.Actual = isnull(i.Actual,0), T.Anterior = isnull(i.Anterior,0), T.AnteAnterior = isnull(i.AnteAnterior,0)
FROM @AplicacionesOperacion T
INNER JOIN (
 Select a.nocuenta, isnull(a.SaldoAcreedor,0) as Actual, isnull(b.SaldoAcreedor,0) as Anterior, isnull(c.SaldoAcreedor,0) as AnteAnterior
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
left join @eAnteAnterior c on a.nocuenta = c.nocuenta
Where a.nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) i
ON i.nocuenta = T.nocuenta
WHERE i.nocuenta = T.nocuenta
--Insert into @AplicacionesOperacion
--Select a.nocuenta, isnull(a.SaldoDeudor,0), isnull(b.SaldoDeudor,0), isnull(c.SaldoDeudor,0)
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--left join @eAnteAnterior c on a.nocuenta = c.nocuenta
--Where a.nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)

--Select * from @AplicacionesOperacion

--Insert into @AplicacionesOperacion
--Select a.nocuenta, isnull(a.SaldoAcreedor,0), isnull(b.SaldoAcreedor,0), isnull(c.SaldoAcreedor,0)
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--left join @eAnteAnterior c on a.nocuenta = c.nocuenta
--Where a.nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)


Declare @ConsideracionesD4 decimal(18,2) = 
(Select SUM(SaldoAcreedor) FROM @eActual 
Where nocuenta IN ('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(Select SUM(SaldoAcreedor) FROM @eAnterior 
Where nocuenta IN ('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(
(Select SUM(SaldoAcreedor) FROM @eAnterior 
Where nocuenta IN ('410'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'420'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'430'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(Select SUM(SaldoDeudor) FROM @eAnterior 
Where nocuenta IN ('510'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'520'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'530'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'540'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'550'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'560'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
)

Declare @ConsideracionesAnteriorD4 decimal(18,2) = 
(Select SUM(SaldoAcreedor) FROM @eAnterior 
Where nocuenta IN ('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(Select SUM(SaldoAcreedor) FROM @eAnteAnterior 
Where nocuenta IN ('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(
(Select SUM(SaldoAcreedor) FROM @eAnteAnterior 
Where nocuenta IN ('410'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'420'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'430'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
-
(Select SUM(SaldoDeudor) FROM @eAnteAnterior 
Where nocuenta IN ('510'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'520'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'530'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'540'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'550'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'560'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
)


--@AplicacionesOperacion
Declare @CambiosAplicacionesOperacion decimal(18,2) = 
(Select (Actual - Anterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
(Select (Actual - Anterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
(Select (Actual - Anterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))

Declare @CambiosAplicacionesOperacionAnterior decimal(18,2) = 
(Select (Anterior - AnteAnterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
(Select (Anterior - AnteAnterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
(Select (Anterior - AnteAnterior) FROM @AplicacionesOperacion 
Where nocuenta IN ('128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
--(a.nocuenta = '' OR  substring(a.nocuenta,1,LEN(@aux)) = @aux)    
--Group by a.nocuenta


Insert Into @report
Select 'Flujos de Efectivo de las Actividades de Operación',NULL, NULL, 3, 'X', 0
Union All
Select 'Origen',SUM(a.TotalAbonos-a.TotalCargos), SUM(b.TotalAbonos-b.TotalCargos), 1, 'A', 1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('411'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'412'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'413'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'414'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'415'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'416'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'417'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'421'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'422'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'431'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'432'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'433'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'434'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'419'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Impuestos', (a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',2
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta = '411'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura
--Agrgegado para la version 2.9
Union All
Select 'Cuotas y Aportaciones de Seguridad Social', (a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',2.1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta = '412'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura
--Agregado Fin
Union All
Select 'Contribuciones de Mejoras', (a.TotalAbonos-a.TotalCargos),(b.TotalAbonos-b.TotalCargos), 0, 'X',3
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('413'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Derechos', (a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',4
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('414'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Productos', (a.TotalAbonos-a.TotalCargos),(b.TotalAbonos-b.TotalCargos), 0, 'X',5
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('415'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Aprovechamientos', (a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',6
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('416'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Ingresos por Venta de Bienes y Prestación de Servicios', (a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',7
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('417'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Agregado para la version 2.9(Derogado)
--Union All
--Select a.nombre, a.totalabonos, b.totalabonos, 0, 'X',7.1
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('419'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
----------------------------------------------------------------------------------------------------------------------
--Agregado Fin ---------------------------------------------------------------------------------------------------------

--Comentado version 2.9
--Union All
--Select 'OTRAS CONTRIBUCIONES CAUSADAS EN EJERCICIOS ANTERIORES', a.totalabonos, b.totalabonos, 0, 'X',8
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('41900-00000','41900-000000')
-- A 1
--Union All
--Select '',null,null,3,'X',9
Union All
Select 'Participaciones, Aportaciones, Convenios, Incentivos Derivados de la Colaboración Fiscal y Fondos Distintos de Aportaciones', 
(a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',9
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('421'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',10
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4211'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',11
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4212'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',12
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4213'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
-- A 2
--Union All
--Select '',null,null,3,'X',13
Union All
Select 'Transferencias, Asignaciones, Subsidios y Subvenciones, y Pensiones y Jubilaciones', 
(a.TotalAbonos-a.TotalCargos), (b.TotalAbonos-b.TotalCargos), 0, 'X',13
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('422'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',14
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4221'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',15
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4222'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',16
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4223'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',17
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4224'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)
--Union All
--Select '    ' + a.nombre, a.totalabonos, b.totalabonos, 0, 'X',18
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('4225'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)

-- A 3
--Union All
--Select '',null,null,3,'X',19
Union All                                --(Sumar la 419)
Select 'Otros Orígenes de Operación', 
SUM(a.TotalAbonos-a.TotalCargos), SUM(b.TotalAbonos-b.TotalCargos), 0, 'X', 19
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('431'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'432'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'433'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'434'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '439'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '419'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)



--+ (select sum(totalcargos) from t_Polizas where idtipomovimiento in (151))
-- A 4
Union All
Select '',null,null,3,'X',19
--Agregado Version 2.12 INICIO
UNION ALL
Select 'Servicios Personales',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',21
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('511'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Materiales y Suministros',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',22
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('512'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Servicios Generales',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',23
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('513'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Transferencias Internas y Asignaciones al Sector Público',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',25
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('521'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Transferencias al resto del Sector Público',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',26
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('522'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Subsidios y Subvenciones',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',27
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('523'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Ayudas Sociales',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',28
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('524'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Pensiones y Jubilaciones',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',29
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('525'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Transferencias a Fideicomisos, Mandatos y Contratos Análogos',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',30
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('526'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Transferencias a la Seguridad Social',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',31
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('527'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Donativos',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',32
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('528'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Transferencias al Exterior',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',33
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('529'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Participaciones',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',35
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('531'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Aportaciones',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',36
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('532'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Convenios',
(a.TotalCargos-a.TotalAbonos), (b.TotalCargos-b.TotalAbonos), 0, 'X',37
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('533'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--UNION ALL
--Select 'Otras Aplicaciones de Operación',
--SUM(a.TotalCargos-a.TotalAbonos), SUM(b.TotalCargos-b.TotalAbonos), 0, 'X', 37.1
--FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
--Where a.nocuenta IN ('541'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'542'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'543'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'544'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'545'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '561'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
--'552'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '553'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '554'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '555'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '559'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
UNION ALL
Select 'Otras Aplicaciones de Operación',
SUM(a.TotalCargos-a.TotalAbonos)+
(Select Case When (Actual > Anterior) THEN -(Actual-Anterior)
ELSE ABS(Actual-Anterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))+
(Select Case When (Actual > Anterior) THEN -(Actual-Anterior)
ELSE ABS(Actual-Anterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))+
(Select Case When (Actual > Anterior) THEN -(Actual-Anterior)
ELSE ABS(Actual-Anterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 

SUM(b.TotalCargos-b.TotalAbonos)+
(Select Case When (Anterior > AnteAnterior) THEN -(Anterior-AnteAnterior)
ELSE ABS(Anterior-AnteAnterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('116'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))+
(Select Case When (Anterior > AnteAnterior) THEN -(Anterior-AnteAnterior)
ELSE ABS(Anterior-AnteAnterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('126'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))+
(Select Case When (Anterior > AnteAnterior) THEN -(Anterior-AnteAnterior)
ELSE ABS(Anterior-AnteAnterior) END FROM @AplicacionesOperacion 
Where nocuenta IN ('128'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 
0, 'X', 37.1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where a.nocuenta IN ('541'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'542'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'543'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'544'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'545'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '561'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'551'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'552'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '553'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '554'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '555'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '559'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)


insert into @report 
Select 'Aplicación', sum(a.SaldoActual), sum(a.SaldoAnterior), 1, 'B',20
FROM @Report a
Where a.orden IN (21,22,23,25,26,27,28,29,30,31,32,33,35,36,37,37.1)


insert into @report values('',0,0,3,'X',37.2)
--Agregado Version 2.12 FIN

-- B 3
Insert Into @report
Select 'Flujos Netos de Efectivo por Actividades de Operación' , 
null,
null, 1, 'X', 38
Union All
Select '',null,null,3,'X',38
Union All
Select 'Flujos de Efectivo de las Actividades de Inversión',null,null,3,'X',39
--Comentado


--Descomentado para la version 2.10 INICIO
Union All
Select 'Bienes Inmuebles, Infraestructura y Construcciones en Proceso',
--Cambio a acumulado 
--Se manda a Cero, codigo original comentado
case when (isnull(Actual,0)< isnull(Anterior,0)) then ABS(isnull(Actual,0)/@division-isnull(Anterior,0)/@division) 
	  else 0 
end, 
case when (isnull(Anterior,0)< isnull(AnteAnterior,0)) then ABS(isnull(Anterior,0)/@division-isnull(AnteAnterior,0)/@division) 
	  else 0 
end,
	  0,'X',39.1
FROM @ActividadesInversion
Where nocuenta IN ('123'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Agregado Version 2.10 INICIO
Union ALL
Select 'Bienes Muebles',
case when (isnull(Actual,0)< isnull(Anterior,0)) then ABS(isnull(Actual,0)/@division-isnull(Anterior,0)/@division) 
	  else 0 
end, 
case when (isnull(Anterior,0)< isnull(AnteAnterior,0)) then ABS(isnull(Anterior,0)/@division-isnull(AnteAnterior,0)/@division) 
	  else 0 
end,
	  0,'X',39.2
FROM @ActividadesInversion
Where nocuenta IN ('124'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
--Agregado version 2.10 FIN

Union All
Select 'Otros Orígenes de Inversión', 
--Cambio a acumulado
-(Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesInversion Where Actual < Anterior AND
nocuenta IN ('114'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '115'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '121'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '125'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '129'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
(Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesInversion Where Actual > Anterior AND
nocuenta IN ('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
case when @ConsideracionesD4 > 0 then ABS(@ConsideracionesD4)/@division else 0 end,  
-(Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesInversion Where Anterior < AnteAnterior AND
nocuenta IN ('114'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '115'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '121'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '125'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '129'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
(Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesInversion Where Anterior > AnteAnterior AND
nocuenta IN ('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
case when @ConsideracionesAnteriorD4 > 0 then ABS(@ConsideracionesAnteriorD4)/@division else 0 end, 
0, 'X', 39.3

Insert Into @report
Select 'Origen', 
SUM(SaldoActual), SUM(SaldoAnterior), 1, 'C', 39 
from @report Where orden in (39.1,39.2,39.3)
-- D
Union All
Select '',null,null,3,'X',42
Union All
Select 'Bienes Muebles',
--Cambio a acumulado
case when (isnull(Actual,0) > isnull(Anterior,0)) then ABS(isnull(Actual,0)/@division-isnull(Anterior,0)/@division) 
	  else 0 
end, 
case when (isnull(Anterior,0) > isnull(AnteAnterior,0)) then ABS(isnull(Anterior,0)/@division-isnull(AnteAnterior,0)/@division) 
	  else 0 
end,
0,'X',45
FROM @ActividadesInversion
Where nocuenta IN ('124'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Union All
Select 'Bienes Inmuebles, Infraestructura y Construcciones en Proceso',
--Cambio a acumulado
case when (isnull(Actual,0) > isnull(Anterior,0)) then ABS(isnull(Actual,0)/@division-isnull(Anterior,0)/@division) 
	  else 0 
end, 
case when (isnull(Anterior,0) > isnull(AnteAnterior,0)) then ABS(isnull(Anterior,0)/@division-isnull(AnteAnterior,0)/@division) 
	  else 0 
end,
	  0,'X',44
FROM @ActividadesInversion
Where nocuenta IN ('123'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)

Union All
Select 'Otras Aplicaciones de Inversión',
--Cambio a acumulado
(Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesInversion Where Actual > Anterior AND
nocuenta IN ('114'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '115'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '121'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '125'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '129'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
ABS((Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesInversion Where Actual < Anterior AND
nocuenta IN ('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))) +
case when @ConsideracionesD4 < 0 then ABS(@ConsideracionesD4)/@division else 0 end,   
(Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesInversion Where Anterior > AnteAnterior AND
nocuenta IN ('114'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '115'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '121'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '125'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '129'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) +
ABS((Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesInversion Where Anterior < AnteAnterior AND
nocuenta IN ('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))) +
case when @ConsideracionesAnteriorD4 < 0 then ABS(@ConsideracionesAnteriorD4)/@division else 0 end,  
0, 'X', 46

--Select @ConsideracionesD4
--Select @ConsideracionesAnteriorD4
insert into @report values('',0,0,3,'X',46.1)
--insert into @report values('',0,0,3,'X',46.2)

Insert Into @report
Select 'Aplicación', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 1, 'D', 43 
From @report Where orden In (44,45,46)

Union All
Select 'Flujos Netos de Efectivo por Actividades de Inversión',
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
Select '',null,null,3,'X',47.2
Union All
Select 'Flujo de Efectivo de las Actividades de Financiamiento',null,null,3,'X',47.3
Union All
--E
Select 'Interno',
--Cambio a acumulado
(Select Isnull(ABS(SUM(Actual-Anterior)),0)
From @ActividadesFinanciamiento Where Actual > Anterior AND
nocuenta IN ('2131'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2133'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2141'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2231'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2233'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura, '2235'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)),
(Select Isnull(ABS(SUM(Anterior-AnteAnterior)),0)
From @ActividadesFinanciamiento Where Anterior > AnteAnterior AND
nocuenta IN ('2131'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2133'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2141'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2231'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2233'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura, '2235'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)), 
0, 'X', 50

Union All
Select 'Externo',
--Cambio a acumulado
(Select Isnull(ABS(SUM(Actual-Anterior)),0)
From @ActividadesFinanciamiento Where Actual > Anterior AND
nocuenta IN ('2132'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2142'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2232'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2234'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)),
(Select Isnull(ABS(SUM(Anterior-AnteAnterior)),0)
From @ActividadesFinanciamiento Where Anterior > AnteAnterior AND
nocuenta IN ('2132'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2142'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2232'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2234'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)),
0, 'X', 51


---
union ALL
Select 'Otros Orígenes de Financiamiento',
ABS((Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesFinanciamiento Where Actual < Anterior AND
nocuenta IN ('112'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'113'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'119'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'122'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'127'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)))
+
(Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesFinanciamiento Where Actual > Anterior AND
nocuenta IN ('211'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '212'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '215'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'216'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '217'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '219'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '221'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '222'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '224'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '225'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '226'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)), 

ABS((Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesFinanciamiento Where Anterior < AnteAnterior AND
nocuenta IN ('112'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'113'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'119'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'122'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'127'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)))
+
(Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesFinanciamiento Where Anterior > AnteAnterior AND
nocuenta IN ('211'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '212'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '215'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'216'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '217'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '219'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '221'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '222'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '224'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '225'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '226'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)),  
0, 'X', 52


----
Insert Into @report
Select 'Endeudamiento Neto', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 2, 'X', 49
From @report Where orden In (50,51)


Insert Into @report
Select 'Origen',
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
Select 'Interno',
--Cambio a acumulado
(Select Isnull(ABS(SUM(Actual-Anterior)),0)
From @ActividadesFinanciamiento Where Actual < Anterior AND
nocuenta IN ('2131'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2133'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2141'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2231'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2233'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura, '2235'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)),
(Select Isnull(ABS(SUM(Anterior-AnteAnterior)),0)
From @ActividadesFinanciamiento Where Anterior < AnteAnterior AND
nocuenta IN ('2131'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2133'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2141'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2231'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2233'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura, '2235'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)), 
0, 'X', 57
Union All
Select 'Externo',
--Cambio a acumulado
(Select Isnull(ABS(SUM(Actual-Anterior)),0)
From @ActividadesFinanciamiento Where Actual < Anterior AND
nocuenta IN ('2132'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2142'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2232'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2234'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)),
(Select Isnull(ABS(SUM(Anterior-AnteAnterior)),0)
From @ActividadesFinanciamiento Where Anterior < AnteAnterior AND
nocuenta IN ('2132'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2142'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2232'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura,'2234'+Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)), 
0, 'X', 58

----
Union All
Select 'Otras Aplicaciones de Financiamiento',
(Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesFinanciamiento Where Actual > Anterior AND
nocuenta IN ('112'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'113'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'119'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'122'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'127'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
ABS((Select Isnull(SUM(Actual-Anterior),0)
From @ActividadesFinanciamiento Where Actual < Anterior AND
nocuenta IN ('211'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '212'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '215'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'216'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '217'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '219'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '221'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '222'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '224'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '225'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '226'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))), 
(Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesFinanciamiento Where Anterior > AnteAnterior AND
nocuenta IN ('112'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'113'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'119'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'122'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,'127'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
+
ABS((Select Isnull(SUM(Anterior-AnteAnterior),0)
From @ActividadesFinanciamiento Where Anterior < AnteAnterior AND
nocuenta IN ('211'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '212'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '215'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura,
'216'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '217'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '219'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '221'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '222'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '224'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '225'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura, '226'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))),
0, 'X', 59

insert into @report values('',0,0,3,'X',59.1)

Insert Into @report
Select 'Servicios de la Deuda', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 2, 'X', 56
From @report Where orden In (57, 58)
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
Select 'Aplicación', SUM(isnull(SaldoActual,0)), SUM(isnull(SaldoAnterior,0)), 1, 'F', 54
From @report Where orden In (55, 56, 59)
-- F
Insert Into @report
Select 'Flujos Netos de Efectivo por Actividades de Financiamiento',
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'E') - 
(Select isnull(SaldoActual,0) From @report Where secciongroup = 'F'),
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'E') - 
(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'F'), 1, 'X', 60
Union All
Select '',null,null,3,'X',60
Union All
Select '',null,null,3,'X',60
insert into @Report
-----------------

Select 'Incremento/Disminución Neta en el Efectivo y Equivalentes al Efectivo',
--(((Select isnull(SaldoActual,0) From @report Where secciongroup = 'A') - 
--(Select isnull(SaldoActual,0) From @report Where secciongroup = 'B')) +
--((Select isnull(SaldoActual,0) From @report Where secciongroup = 'C') - 
--(Select isnull(SaldoActual,0) From @report Where secciongroup = 'D')) +
--((Select isnull(SaldoActual,0) From @report Where secciongroup = 'E') -
--(Select isnull(SaldoActual,0) From @report Where secciongroup = 'F'))),

--(((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'A') - 
--(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'B')) +
--((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'C') -
--(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'D')) +
--((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'E') -
--(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'F'))) 
0,0,1, 'X', 61

Union All
--CONSULTA DE ENERO
Select 'Efectivo y Equivalentes al Efectivo al Inicio del Ejercicio*',

(Select ISnull(SaldoDeudor,0) From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110'),
(Select isnull(SaldoDeudor,0) From @eAnteAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')
, 1, 'X', 62
insert into @report 
--Union All
Select 'Efectivo y Equivalentes al Efectivo al Final del Ejercicio',
--(Select isnull(SaldoActual,0) from @report where nombre='INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO')+
--(Select isnull(SaldoActual,0) from @report where nombre='EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL EJERCICIO*'),
--(Select isnull(SaldoAnterior,0)  from @report where nombre='INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO')+
--(Select isnull(SaldoAnterior,0) from @report where nombre='EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL EJERCICIO*')

--(Select SaldoDeudor From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110'),
--(Select SaldoDeudor From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')

0,0, 1, 'X', 63


SET @CalculoFinal = (Select isnull(SaldoActual,0) From @report where orden = 63) - (Select isnull(SaldoActual,0) From @report where orden = 62)
SET @Diferencia = @CalculoFinal - (Select isnull(SaldoActual,0) From @report where orden = 61)

--Update @report Set SaldoActual = @CalculoFinal where orden = 61
--jorge 14/04/2016
--IF @Diferencia > 0 Begin
	--Update @report Set SaldoActual =  
	--( (Select isnull(SaldoActual,0) From @report where orden = 21) - @Diferencia ) where orden = 21
	
	--Update @report Set SaldoActual = 
	--( (Select isnull(SaldoActual,0) From @report where orden = 20) - @Diferencia ) where orden = 20
	 
   -- Update @report Set SaldoActual = 
	--( (Select isnull(SaldoActual,0) From @report where orden = 1) - (Select isnull(SaldoActual,0) From @report where orden = 20) ) 
	--where orden = 38 AND nombre = 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE OPERACIÓN'
--End


---- BR
UPDATE @report set SaldoActual = (Select SUM(SaldoActual) from @report Where orden in (2,2.1,3,4,5,6,7,7.1,9,13,19)) where nombre ='ORIGEN' and orden=1 and secciongroup = 'A'
UPDATE @report set SaldoAnterior = (Select SUM(SaldoAnterior) from @report Where orden in (2,2.1,3,4,5,6,7,7.1,9,13,19)) where nombre ='ORIGEN' and orden=1 and secciongroup = 'A'

---- BR

-----------Se agregó para actualizar la resta correctamente-----------------------
UPDATE @report set SaldoActual = ((Select isnull(SaldoActual,0) From @report Where secciongroup = 'A') - (Select isnull(SaldoActual,0) From @report Where secciongroup = 'B')) Where nombre = 'Flujos Netos de Efectivo por Actividades de Operación'
UPDATE @report set SaldoAnterior = ((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'A') - (Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'B')) Where nombre = 'Flujos Netos de Efectivo por Actividades de Operación'


UPDATE @report set SaldoActual =((Select isnull(SaldoActual,0) From @report Where secciongroup = 'A') - 
								(Select isnull(SaldoActual,0) From @report Where secciongroup = 'B')) +
								(((Select isnull(SaldoActual,0) From @report Where secciongroup = 'C') - 
								(Select isnull(SaldoActual,0) From @report Where secciongroup = 'D')) +
								((Select isnull(SaldoActual,0) From @report Where secciongroup = 'E') -
								(Select isnull(SaldoActual,0) From @report Where secciongroup = 'F'))) Where Orden = 61

UPDATE @report set SaldoAnterior = ((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'A') - 
									(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'B')) +
									(((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'C') -
									(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'D')) +
									((Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'E') -
									(Select isnull(SaldoAnterior,0) From @report Where secciongroup = 'F'))) Where Orden = 61

UPDATE @report set SaldoActual = (Select isnull(SaldoActual,0) from @report where orden = 61) +
								(Select isnull(SaldoActual,0) from @report where orden = 62) Where Orden = 63

UPDATE @report set SaldoAnterior = (Select isnull(SaldoAnterior,0) from @report where orden = 61) +
								   (Select isnull(SaldoAnterior,0) from @report where orden = 62) Where Orden = 63
--((Select isnull(SaldoActual,0) From @report where orden = 63)- (Select isnull(SaldoActual,0) From @report where orden = 62)),
--((Select isnull(SaldoAnterior,0) From @report where orden = 63)-(Select isnull(SaldoAnterior,0) From @report where orden = 62)) 
--,1, 'X', 61


Delete @report where orden in (10,11,12,14,15,16,17,18)

if @MostrarVacios =1 
begin
	if @Redondeo =1
		begin
		Select  nombre, Round((ISNULL(SaldoActual,0)/@Division),0) as SaldoActual, Round((ISNULL(SaldoAnterior,0)/@Division),0) as SaldoAnterior,
		negritas, secciongroup, orden from @report Order by orden
		end
	else
		begin
		Select  nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
		negritas, secciongroup, orden from @report Order by orden
		end
end
Else
 begin
	 if @Redondeo =1
		 begin
		 Select  nombre, Round((ISNULL(SaldoActual,0)/@Division),0) as SaldoActual, Round((ISNULL(SaldoAnterior,0)/@Division),0) as SaldoAnterior,
		negritas, secciongroup, orden from @report  Where (SaldoActual<>0 or SaldoAnterior <>0) or negritas in(1,3)  Order by orden
		 end
	 else
		 begin
		Select  nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
		negritas, secciongroup, orden from @report  Where (SaldoActual<>0 or SaldoAnterior <>0) or negritas in(1,3)  Order by orden
		end
End

--select * from @eActual Where nocuenta IN ('43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)
--select * from @eAnterior Where nocuenta IN ('43'+Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)

GO

EXEC SP_FirmasReporte 'Estado de Flujos de Efectivo EF'
GO

Exec SP_CFG_LogScripts 'SP_RPT_Flujo_de_Efectivo_EF','2.30.1'
GO


-- EXEC SP_RPT_Flujo_de_Efectivo_EF 2018,5,0,1,0