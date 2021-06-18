/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_Actividades]    Script Date: 03/10/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_Actividades]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Estado_De_Actividades]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_Actividades]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[REPORTE_Estado_De_Actividades]
@mes smallint,
@año smallint,
@Miles bit
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
MesAnt int,
AñoAnt int,
Agrupador int  )


INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT 
dbo.C_Contable.NumeroCuenta, 
dbo.C_Contable.NombreCuenta, 
dbo.T_SaldosInicialesCont.CargosSinFlujo, 
dbo.T_SaldosInicialesCont.AbonosSinFlujo, 
dbo.T_SaldosInicialesCont.TotalCargos, 
dbo.T_SaldosInicialesCont.TotalAbonos, 
CASE C_Contable.TipoCuenta 
WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
ELSE 0 END AS SaldoDeudor, 
CASE C_Contable.TipoCuenta 
WHEN 'A' THEN 0 
WHEN 'C' THEN 0 
WHEN 'E' THEN 0 
WHEN 'G' THEN 0 
WHEN 'I' THEN 0 
ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS SaldoAcreedor, 
LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, 
LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1) AS MaskNumeroCuenta, 
LEN(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, @Estructura1), 0, '')) AS Total, 
dbo.T_SaldosInicialesCont.Mes, 
dbo.T_SaldosInicialesCont.Year, 
dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt, 
RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt, 
RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt, 
RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt, 
RPT_Balanza_Comprobacio_Anterior_1.Year AS AñoAnt, 
1 as Agrupador 
FROM         dbo.C_Contable 
INNER JOIN dbo.T_SaldosInicialesCont 
ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable 
LEFT OUTER JOIN dbo.RPT_Balanza_Comprobacio_Anterior(@mes , @año - 1) AS RPT_Balanza_Comprobacio_Anterior_1 
ON dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') 
AND  (dbo.T_SaldosInicialesCont.Mes = @mes) 
AND (dbo.T_SaldosInicialesCont.Year = @año) 
ORDER BY dbo.C_Contable.NumeroCuenta
--Acreedor
Select @433ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--AcreedorAnt
Select @433ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--Deudor
Select @433DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))
--DeudorAnt
Select @433DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('433'+REPLICATE('0',@Estructura1-3)))
Select @434DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('434'+REPLICATE('0',@Estructura1-3)))
select @551DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('551'+REPLICATE('0',@Estructura1-3)))
select @552DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('552'+REPLICATE('0',@Estructura1-3)))
select @554DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('554'+REPLICATE('0',@Estructura1-3)))
select @555DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta=('555'+REPLICATE('0',@Estructura1-3)))

UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCIÓN DEL EXCESO DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA Y PROVISIONES', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,
	SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = ('433'+REPLICATE('0',@Estructura1-3))
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES Y PROVISIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,
	SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = ('551'+REPLICATE('0',@Estructura1-3))
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA, DETERIORO U OBSOLESCENCIA Y PROVISIONES',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,
	SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = ('554'+REPLICATE('0',@Estructura1-3))
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta=('415'+REPLICATE('0',@Estructura1-3))
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'
	
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('434'+REPLICATE('0',@Estructura1-3))
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('552'+REPLICATE('0',@Estructura1-3))
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = ('555'+REPLICATE('0',@Estructura1-3))


--delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '___0_' and masknumerocuenta not like '___00'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___1'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___10'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___2'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___20'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___3'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___30'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___4'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___40'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___5'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___50'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___6'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___60'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___7'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___70'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___8'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___80'+REPLICATE('0',@Estructura1-5))
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like ('___9'+REPLICATE('0',@Estructura1-4)+'-') and masknumerocuenta not like ('___90'+REPLICATE('0',@Estructura1-5))

--- consulta sin miles
if @miles = 1 
SELECT 
NumeroCuenta,
NombreCuenta,
(CargosSinFlujo/1000) as CargosSinFlujo,
(AbonosSinFlujo/1000) as AbonosSinFlujo,
(TotalCargos/1000) as TotalCargos,
(TotalAbonos/1000) as TotalAbonos,
(SaldoDeudor/1000) as SaldoDeudor,
(SaldoAcreedor/1000) as SaldoAcreedor,
TipoCuenta,  
MaskNumeroCuenta,
Total, 
Mes, 
Year, 
MaskNombreCuenta,
NumeroCuentaAnt, 
(SaldoDeudorAnt/1000) as SaldoDeudorAnt,
(SaldoAcreedorAnt/1000) as SaldoDeudorAnt,
MesAnt,
AñoAnt,
Agrupador
FROM @Tmp_BalanzaDeComprobacion

else
SELECT 
NumeroCuenta,
NombreCuenta,
(CargosSinFlujo) as CargosSinFlujo,
(AbonosSinFlujo) as AbonosSinFlujo,
(TotalCargos) as TotalCargos,
(TotalAbonos) as TotalAbonos,
(SaldoDeudor) as SaldoDeudor,
(SaldoAcreedor) as SaldoAcreedor,
TipoCuenta,  
MaskNumeroCuenta,
Total, 
Mes, 
Year, 
MaskNombreCuenta,
NumeroCuentaAnt, 
(SaldoDeudorAnt) as SaldoDeudorAnt,
(SaldoAcreedorAnt) as SaldoAcreedorAnt,
MesAnt,
AñoAnt,
Agrupador
FROM @Tmp_BalanzaDeComprobacion
--FIN DE PROCEDIMIENTO

END



GO


