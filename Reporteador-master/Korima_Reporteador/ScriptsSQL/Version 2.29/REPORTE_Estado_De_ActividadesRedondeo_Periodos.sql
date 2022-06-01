/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesRedondeo_Periodos]    Script Date: 07/23/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_ActividadesRedondeo_Periodos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesRedondeo_Periodos]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesRedondeo_Periodos]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec REPORTE_Estado_De_ActividadesRedondeo_Periodos 6,8,2019,0,1,1
CREATE PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesRedondeo_Periodos]
@mes smallint,
@mes2 smallint,
@a�o smallint,
@Miles bit,
@MostrarVacios bit,
@Redondeo bit
AS
BEGIN

--- Manejo Miles de pesos
declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

--Tipos de estructura 5-5 , 5-6 , 6-6
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

--variables 
	Declare @Reporte int
	Declare @SSaldo decimal(15,2)
	Declare @SSaldoAnt Decimal(15,2)
	Declare @SSaldo5 decimal(15,2)
	Declare @SSaldoAnt5 decimal(15,2)
	Declare @433ACR decimal(15,2)
	Declare @433ACRAnt decimal(15,2)
	Declare @434ACR decimal(15,2)
	Declare @434ACRAnt decimal(15,2)
	Declare @551ACR decimal(15,2)
	Declare @551ACRAnt decimal(15,2)
	Declare @552ACR decimal(15,2)
	Declare @552ACRAnt decimal(15,2)
	Declare @554ACR decimal(15,2)
	Declare @554ACRAnt decimal(15,2)
	Declare @555ACR decimal(15,2)
	Declare @555ACRAnt decimal(15,2)

	Declare @433DEU decimal(15,2)
	Declare @433DEUAnt decimal(15,2)
	Declare @434DEU decimal(15,2)
	Declare @434DEUAnt decimal(15,2)
	Declare @551DEU decimal(15,2)
	Declare @551DEUAnt decimal(15,2)
	Declare @552DEU decimal(15,2)
	Declare @552DEUAnt decimal(15,2)
	Declare @554DEU decimal(15,2)
	Declare @554DEUAnt decimal(15,2)
	Declare @555DEU decimal(15,2)
	Declare @555DEUAnt decimal(15,2)
	
Declare @Tmp_BalanzaDeComprobacion TABLE(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(15,2),
AbonosSinFlujo decimal(15,2),
TotalCargos decimal(15,2),
TotalAbonos decimal(15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
TipoCuenta int,  
MaskNumeroCuenta varchar(max),
Total int, 
Mes int, 
Year int, 
MaskNombreCuenta varchar(max),
NumeroCuentaAnt varchar(max), 
SaldoDeudorAnt decimal(15,2),
SaldoAcreedorAnt decimal(15,2),
TotalCargosAnt decimal(15,2),
TotalAbonosAnt decimal(15,2),  
MesAnt int,
A�oAnt int,
Agrupador int  )
--Manejo de nombres fijos
Declare @TablaTitulos table
(Numerocuenta varchar(max),
Nombre varchar(max),
Total int)

Insert Into @TablaTitulos values ('400'+REPLICATE('0',@Estructura1-3),'    INGRESOS Y OTROS BENEFICIOS',4)
Insert Into @TablaTitulos values('410'+REPLICATE('0',@Estructura1-3),'          INGRESOS DE GESTI�N',3)
Insert Into @TablaTitulos values('411'+REPLICATE('0',@Estructura1-3),'              IMPUESTOS',2)
Insert Into @TablaTitulos values('412'+REPLICATE('0',@Estructura1-3),'              CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL',2)
Insert Into @TablaTitulos values('413'+REPLICATE('0',@Estructura1-3),'              CONTRIBUCIONES DE MEJORAS',2)
Insert Into @TablaTitulos values('414'+REPLICATE('0',@Estructura1-3),'              DERECHOS',2)
Insert Into @TablaTitulos values('415'+REPLICATE('0',@Estructura1-3),'              PRODUCTOS',2)
Insert Into @TablaTitulos values('416'+REPLICATE('0',@Estructura1-3),'              APROVECHAMIENTOS',2)
Insert Into @TablaTitulos values('417'+REPLICATE('0',@Estructura1-3),'              INGRESOS POR VENTA DE BIENES Y PRESTACI�N DE SERVICIOS',2)
--Insert Into @TablaTitulos values('419'+REPLICATE('0',@Estructura1-3),'              INGRESOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES PENDIENTES DE LIQUIDACI�N O PAGO',2)
--Insert Into @TablaTitulos values('4191'+REPLICATE('0',@Estructura1-4),'                  IMPUESTOS NO COMPRENDIDOS EN LAS FRACCIONES DE LA LEY DE INGRESOS CAUSADOS EN EJERCICIOS FISCALES ANTERIORES	PENDIENTES DE LIQUIDACI�N O PAGO',1)
Insert Into @TablaTitulos values('420'+REPLICATE('0',@Estructura1-3),'          PARTICIPACIONES, APORTACIONES, CONVENIOS, INCENTIVOS DERIVADOS DE LA COLABORACION FISCAL, FONDOS DISTINTOS DE APORTACIONES, TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y SUBVENCIONES, Y PENSIONES Y JUBILACIONES',3)
Insert Into @TablaTitulos values('421'+REPLICATE('0',@Estructura1-3),'              Participaciones, Aportaciones, Convenios, Incentivos Derivados de la Colaboraci�n Fiscal y Fondos Distintos de Aportaciones',2)
Insert Into @TablaTitulos values('422'+REPLICATE('0',@Estructura1-3),'              Transferencias, Asignaciones, Subsidios y Subvenciones, y Pensiones y Jubilaciones',2)
Insert Into @TablaTitulos values('430'+REPLICATE('0',@Estructura1-3),'          OTROS INGRESOS Y BENEFICIOS',3)
Insert Into @TablaTitulos values('431'+REPLICATE('0',@Estructura1-3),'              INGRESOS FINANCIEROS',2)
Insert Into @TablaTitulos values('432'+REPLICATE('0',@Estructura1-3),'              INCREMENTO POR VARIACI�N DE INVENTARIOS',2)
Insert Into @TablaTitulos values('433'+REPLICATE('0',@Estructura1-3),'              DISMINUCI�N DEL EXCESO DE ESTIMACIONES POR P�RDIDA O DETERIORO U OBSOLESCENCIA',2)
Insert Into @TablaTitulos values('4341'+REPLICATE('0',@Estructura1-4),'              DISMINUCI�N DEL EXCESO DE PROVISIONES',1)
Insert Into @TablaTitulos values('439'+REPLICATE('0',@Estructura1-3),'              OTROS INGRESOS Y BENEFICIOS VARIOS',2)

Insert Into @TablaTitulos values('500'+REPLICATE('0',@Estructura1-3),'    GASTOS Y OTRAS P�RDIDAS',4)
Insert Into @TablaTitulos values('510'+REPLICATE('0',@Estructura1-3),'          GASTOS DE FUNCIONAMIENTO',3)
Insert Into @TablaTitulos values('511'+REPLICATE('0',@Estructura1-3),'              SERVICIOS PERSONALES',2)
Insert Into @TablaTitulos values('512'+REPLICATE('0',@Estructura1-3),'              MATERIALES Y SUMINISTROS',2)
Insert Into @TablaTitulos values('513'+REPLICATE('0',@Estructura1-3),'              SERVICIOS GENERALES',2)
Insert Into @TablaTitulos values('520'+REPLICATE('0',@Estructura1-3),'          TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',3)
Insert Into @TablaTitulos values('521'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS INTERNAS Y ASIGNACIONES AL SECTOR P�BLICO',2)
Insert Into @TablaTitulos values('522'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS AL RESTO DEL SECTOR P�BLICO',2)
Insert Into @TablaTitulos values('523'+REPLICATE('0',@Estructura1-3),'              SUBSIDIOS Y SUBVENCIONES',2)
Insert Into @TablaTitulos values('524'+REPLICATE('0',@Estructura1-3),'              AYUDAS SOCIALES',2)
Insert Into @TablaTitulos values('525'+REPLICATE('0',@Estructura1-3),'              PENSIONES Y JUBILACIONES',2)
Insert Into @TablaTitulos values('526'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS A FIDEICOMISOS, MANDATOS Y CONTRATOS AN�LOGOS',2)
Insert Into @TablaTitulos values('527'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS A LA SEGURIDAD SOCIAL',2)
Insert Into @TablaTitulos values('528'+REPLICATE('0',@Estructura1-3),'              DONATIVOS',2)
Insert Into @TablaTitulos values('529'+REPLICATE('0',@Estructura1-3),'              TRANSFERENCIAS AL EXTERIOR',2)
Insert Into @TablaTitulos values('530'+REPLICATE('0',@Estructura1-3),'          PARTICIPACIONES Y APORTACIONES',3)
Insert Into @TablaTitulos values('531'+REPLICATE('0',@Estructura1-3),'              PARTICIPACIONES',2)
Insert Into @TablaTitulos values('532'+REPLICATE('0',@Estructura1-3),'              APORTACIONES',2)
Insert Into @TablaTitulos values('533'+REPLICATE('0',@Estructura1-3),'              CONVENIOS',2)
Insert Into @TablaTitulos values('540'+REPLICATE('0',@Estructura1-3),'          INTERESES, COMISIONES Y OTROS GASTOS DE LA DEUDA P�BLICA',3)
Insert Into @TablaTitulos values('541'+REPLICATE('0',@Estructura1-3),'              INTERESES DE LA DEUDA P�BLICA',2)
Insert Into @TablaTitulos values('542'+REPLICATE('0',@Estructura1-3),'              COMISIONES DE LA DEUDA P�BLICA',2)
Insert Into @TablaTitulos values('543'+REPLICATE('0',@Estructura1-3),'              GASTOS DE LA DEUDA P�BLICA',2)
Insert Into @TablaTitulos values('544'+REPLICATE('0',@Estructura1-3),'              COSTO POR COBERTURAS',2)
Insert Into @TablaTitulos values('545'+REPLICATE('0',@Estructura1-3),'              APOYOS FINANCIEROS',2)
Insert Into @TablaTitulos values('550'+REPLICATE('0',@Estructura1-3),'          OTROS GASTOS Y P�RDIDAS EXTRAORDINARIAS',3)
Insert Into @TablaTitulos values('551'+REPLICATE('0',@Estructura1-3),'              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS Y AMORTIZACIONES',2)
Insert Into @TablaTitulos values('552'+REPLICATE('0',@Estructura1-3),'              PROVISIONES',2)
Insert Into @TablaTitulos values('553'+REPLICATE('0',@Estructura1-3),'              DISMINUCI�N DE INVENTARIOS',2)
Insert Into @TablaTitulos values('554'+REPLICATE('0',@Estructura1-3),'              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR P�RDIDA O DETERIORO U OBSOLESCENCIA',2)
Insert Into @TablaTitulos values('5551'+REPLICATE('0',@Estructura1-4),'              AUMENTO POR INSUFICIENCIA DE PROVISIONES',2)
Insert Into @TablaTitulos values('559'+REPLICATE('0',@Estructura1-3),'              OTROS GASTOS',2)
Insert Into @TablaTitulos values('560'+REPLICATE('0',@Estructura1-3),'          INVERSI�N P�BLICA',3)
Insert Into @TablaTitulos values('561'+REPLICATE('0',@Estructura1-3),'              INVERSI�N P�BLICA NO CAPITALIZABLE',2)
--fin de manejo de nombres fijos


INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT 
dbo.C_Contable.NumeroCuenta, 
dbo.C_Contable.NombreCuenta, 
SUM(T_SaldosInicialesCont.CargosSinFlujo) as CargosSinFlujo, 
	SUM(T_SaldosInicialesCont.AbonosSinFlujo) as AbonosSinFlujo, 
	SUM(T_SaldosInicialesCont.TotalCargos) as TotalCargos, 
	SUM(T_SaldosInicialesCont.TotalAbonos) as TotalAbonos,
					Case C_Contable.TipoCuenta 
						When 'A' Then SUM(T_SaldosInicialesCont.CargosSinFlujo) - SUM(T_SaldosInicialesCont.AbonosSinFlujo) + SUM(T_SaldosInicialesCont.TotalCargos) - SUM(T_SaldosInicialesCont.TotalAbonos)
						When 'C' Then SUM(T_SaldosInicialesCont.CargosSinFlujo) - SUM(T_SaldosInicialesCont.AbonosSinFlujo) + SUM(T_SaldosInicialesCont.TotalCargos) - SUM(T_SaldosInicialesCont.TotalAbonos)
						When 'E' Then SUM(T_SaldosInicialesCont.CargosSinFlujo) - SUM(T_SaldosInicialesCont.AbonosSinFlujo) + SUM(T_SaldosInicialesCont.TotalCargos) - SUM(T_SaldosInicialesCont.TotalAbonos)
						When 'G' Then SUM(T_SaldosInicialesCont.CargosSinFlujo) - SUM(T_SaldosInicialesCont.AbonosSinFlujo) + SUM(T_SaldosInicialesCont.TotalCargos) - SUM(T_SaldosInicialesCont.TotalAbonos)
						When 'I' Then SUM(T_SaldosInicialesCont.CargosSinFlujo) - SUM(T_SaldosInicialesCont.AbonosSinFlujo) + SUM(T_SaldosInicialesCont.TotalCargos) - SUM(T_SaldosInicialesCont.TotalAbonos)
						Else 0
					End as SaldoDeudor,
					Case C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I'  Then 0
						Else SUM(T_SaldosInicialesCont.AbonosSinFlujo) - SUM(T_SaldosInicialesCont.CargosSinFlujo) + SUM(T_SaldosInicialesCont.TotalAbonos) - SUM(T_SaldosInicialesCont.TotalCargos) 
					End as SaldoAcreedor, 
LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, 
LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1) AS MaskNumeroCuenta, 
LEN(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1), 0, '')) AS Total, 
0,--dbo.T_SaldosInicialesCont.Mes, 
2000,--dbo.T_SaldosInicialesCont.Year, 
dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta,
RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt, 
RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt, 
RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt,
RPT_Balanza_Comprobacio_Anterior_1.TotalCargos AS TotalCargosAnt, 
RPT_Balanza_Comprobacio_Anterior_1.TotalAbonos AS TotalAbonosAnt, 
0,--RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt, 
2000,--RPT_Balanza_Comprobacio_Anterior_1.Year AS A�oAnt, 
1 as Agrupador 
FROM         dbo.C_Contable 
INNER JOIN dbo.T_SaldosInicialesCont 
ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable 
LEFT OUTER JOIN dbo.RPT_Balanza_Comprobacio_Anterior_Periodos(@mes, @mes2, @a�o - 1) AS RPT_Balanza_Comprobacio_Anterior_1 
ON dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') 
AND  (dbo.T_SaldosInicialesCont.Mes between @mes and @mes2) 
AND (dbo.T_SaldosInicialesCont.Year = @a�o) 
and LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1) in (Select NumeroCuenta From @TablaTitulos)
GROUP BY dbo.C_Contable.NumeroCuenta,C_Contable.NombreCuenta, C_Contable.TipoCuenta, C_Contable.Afectable, C_Contable.Financiero,
RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta,
RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor,
RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor,
RPT_Balanza_Comprobacio_Anterior_1.TotalCargos,
RPT_Balanza_Comprobacio_Anterior_1.TotalAbonos
ORDER BY dbo.C_Contable.NumeroCuenta

--Acreedor
Select @433ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--AcreedorAnt
Select @433ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--Deudor
Select @433DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--DeudorAnt
Select @433DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A�o and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))

UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCI�N DEL EXCESO DE ESTIMACIONES POR P�RDIDA O DETERIORO U OBSOLESCENCIA', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,
	SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = ('433'+REPLICATE('0',@Estructura1-3))
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,
--	SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = ('551'+REPLICATE('0',@Estructura1-3))
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR P�RDIDA, DETERIORO Y OBSOLESCENCIA',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,
	SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = ('554'+REPLICATE('0',@Estructura1-3))
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta=('415'+REPLICATE('0',@Estructura1-3))
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'
	
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('434'+REPLICATE('0',@Estructura1-3))
--DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('552'+REPLICATE('0',@Estructura1-3))
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('555'+REPLICATE('0',@Estructura1-3))


--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '___0_' and masknumerocuenta not like '___00'
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___1'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___10'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___2'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___20'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___3'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___30'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___4'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___40'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___5'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___50'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___6'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___60'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___7'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___70'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___8'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___80'+REPLICATE('0',@Estructura1-5))
--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___9'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___90'+REPLICATE('0',@Estructura1-5))
--Select * from @Tmp_BalanzaDeComprobacion
--llena las cuentas faltantes (en caso que no esten)

Insert into @Tmp_BalanzaDeComprobacion 
Select NumeroCuenta+'-'+ REPLICATE('0',@Estructura2), 
Nombre,
0,
0,
0,
0,
0,
0,convert(int,SUBSTRING(NumeroCuenta,1,1)),NumeroCuenta,Total,@Mes,@A�o,Nombre,NumeroCuenta,0,0,0,0,@Mes,@A�o-1,1

from @TablaTitulos where Numerocuenta not in (Select MaskNumeroCuenta from @Tmp_BalanzaDeComprobacion)

--NumeroCuenta varchar(max),
--NombreCuenta varchar(max),
--CargosSinFlujo decimal(15,2),
--AbonosSinFlujo decimal(15,2),
--TotalCargos decimal(15,2),
--TotalAbonos decimal(15,2),
--SaldoDeudor decimal(15,2),
--SaldoAcreedor decimal(15,2),
--TipoCuenta int,  
--MaskNumeroCuenta varchar(max),
--Total int, 
--Mes int, 
--Year int, 
--MaskNombreCuenta varchar(max),
--NumeroCuentaAnt varchar(max), 
--SaldoDeudorAnt decimal(15,2),
--SaldoAcreedorAnt decimal(15,2),
--MesAnt int,
--A�oAnt int,
--Agrupador int

--Select * from @Tmp_BalanzaDeComprobacion
--Select * from @TablaTitulos

if @MostrarVacios =1 
begin
	if @Redondeo = 1 
		begin
		SELECT 
		A.NumeroCuenta,
		NombreCuenta,
		Round(isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0),0) as CargosSinFlujo,
		Round(isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0),0) as AbonosSinFlujo,
		Round(isnull(cast((TotalCargos/@Division)as decimal (18,2)),0),0) as TotalCargos,
		Round(isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0),0) as TotalAbonos,
		Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) as SaldoDeudor,
		Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) as SaldoAcreedor,
		TipoCuenta,  
		MaskNumeroCuenta,
		A.Total, 
		Mes, 
		Year,
		CASE  
			WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))
			WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))
			ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))
		END  as MaskNombreCuenta,
		NumeroCuentaAnt, 
		Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0) as SaldoDeudorAnt,
		Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) as SaldoAcreedorAnt,
		Round(isnull(cast((TotalCargosAnt/@Division)as decimal (18,4)),0),0) as TotalCargosAnt,
	    Round(isnull(cast((TotalAbonosAnt/@Division)as decimal (18,4)),0),0) as TotalAbonosAnt,
		MesAnt,
		A�oAnt,
		Agrupador
		FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.MaskNumeroCuenta = B.NumeroCuenta
		order by MaskNumeroCuenta
		end
	else
		begin
		SELECT 
		A.NumeroCuenta,
		NombreCuenta,
		isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0) as CargosSinFlujo,
		isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0) as AbonosSinFlujo,
		isnull(cast((TotalCargos/@Division)as decimal (18,2)),0) as TotalCargos,
		isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0) as TotalAbonos,
		isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0) as SaldoDeudor,
		isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0) as SaldoAcreedor,
		TipoCuenta,  
		MaskNumeroCuenta,
		A.Total, 
		Mes, 
		Year, 
		CASE  
			WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))
			WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))
			ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))
		END  as MaskNombreCuenta,
		NumeroCuentaAnt, 
		isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0) as SaldoDeudorAnt,
		isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0) as SaldoAcreedorAnt,
		isnull(cast((TotalCargosAnt/@Division)as decimal (18,4)),0) as TotalCargosAnt,
	    isnull(cast((TotalAbonosAnt/@Division)as decimal (18,4)),0) as TotalAbonosAnt,
		MesAnt,
		A�oAnt,
		Agrupador
		FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.MaskNumeroCuenta = B.NumeroCuenta
		order by MaskNumeroCuenta
		end
end
else
begin
	if @Redondeo=1
	begin
		SELECT 
		A.NumeroCuenta,
		NombreCuenta,
		Round(isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0),0) as CargosSinFlujo,
		Round(isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0),0) as AbonosSinFlujo,
		Round(isnull(cast((TotalCargos/@Division)as decimal (18,2)),0),0) as TotalCargos,
		Round(isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0),0) as TotalAbonos,
		Round(isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0),0) as SaldoDeudor,
		Round(isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0),0) as SaldoAcreedor,
		TipoCuenta,  
		MaskNumeroCuenta,
		A.Total, 
		Mes, 
		Year, 
		CASE  
			WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))
			WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))
			ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))
		END  as MaskNombreCuenta,
		NumeroCuentaAnt, 
		Round(isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0),0) as SaldoDeudorAnt,
		Round(isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0),0) as SaldoAcreedorAnt,
		Round(isnull(cast((TotalCargosAnt/@Division)as decimal (18,4)),0),0) as TotalCargosAnt,
	    Round(isnull(cast((TotalAbonosAnt/@Division)as decimal (18,4)),0),0) as TotalAbonosAnt,
		MesAnt,
		A�oAnt,
		Agrupador
		FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.MaskNumeroCuenta = B.NumeroCuenta
		Where SaldoDeudor <>0 or SaldoAcreedor<>0 or SaldoDeudorAnt <>0 or SaldoAcreedorAnt <> 0
		order by MaskNumeroCuenta
	end 
	else
	begin
		SELECT 
		A.NumeroCuenta,
		NombreCuenta,
		isnull(cast((CargosSinFlujo/@Division)as decimal (18,2)),0) as CargosSinFlujo,
		isnull(cast((AbonosSinFlujo/@Division)as decimal (18,2)),0) as AbonosSinFlujo,
		isnull(cast((TotalCargos/@Division)as decimal (18,2)),0) as TotalCargos,
		isnull(cast((TotalAbonos/@Division)as decimal (18,2)),0) as TotalAbonos,
		isnull(cast((SaldoDeudor/@Division)as decimal (18,3)),0) as SaldoDeudor,
		isnull(cast((SaldoAcreedor/@Division)as decimal (18,3)),0) as SaldoAcreedor,
		TipoCuenta,  
		MaskNumeroCuenta,
		A.Total, 
		Mes, 
		Year, 
		CASE  
			WHEN MaskNumeroCuenta IN ('400'+REPLICATE('0',@Estructura1-3),'500'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,5))+LOWER(SUBSTRING(B.Nombre,6,LEN(B.Nombre))))
			WHEN MaskNumeroCuenta IN ('410'+REPLICATE('0',@Estructura1-3),'420'+REPLICATE('0',@Estructura1-3),'430'+REPLICATE('0',@Estructura1-3),'510'+REPLICATE('0',@Estructura1-3),'520'+REPLICATE('0',@Estructura1-3),'530'+REPLICATE('0',@Estructura1-3),'540'+REPLICATE('0',@Estructura1-3),'550'+REPLICATE('0',@Estructura1-3),'560'+REPLICATE('0',@Estructura1-3)) 
				THEN (Select UPPER(LEFT(B.Nombre,11))+LOWER(SUBSTRING(B.Nombre,12,LEN(B.Nombre))))
			ELSE (Select UPPER(LEFT(B.Nombre,15))+LOWER(SUBSTRING(B.Nombre,16,LEN(B.Nombre))))
		END  as MaskNombreCuenta,
		NumeroCuentaAnt, 
		isnull(cast((SaldoDeudorAnt/@Division)as decimal (18,4)),0) as SaldoDeudorAnt,
		isnull(cast((SaldoAcreedorAnt/@Division)as decimal (18,4)),0) as SaldoAcreedorAnt,
		isnull(cast((TotalCargosAnt/@Division)as decimal (18,4)),0) as TotalCargosAnt,
	    isnull(cast((TotalAbonosAnt/@Division)as decimal (18,4)),0) as TotalAbonosAnt,
		MesAnt,
		A�oAnt,
		Agrupador
		FROM @Tmp_BalanzaDeComprobacion A LEFT JOIN @TablaTitulos B ON A.MaskNumeroCuenta = B.NumeroCuenta
		Where SaldoDeudor <>0 or SaldoAcreedor<>0 or SaldoDeudorAnt <>0 or SaldoAcreedorAnt <> 0
		order by MaskNumeroCuenta
		end
end
--FIN DE PROCEDIMIENTO

END
GO

EXEC SP_FirmasReporte 'Estado de actividades por Periodos'
GO

Exec SP_CFG_LogScripts 'REPORTE_Estado_De_ActividadesRedondeo_Periodos','2.29'
GO

