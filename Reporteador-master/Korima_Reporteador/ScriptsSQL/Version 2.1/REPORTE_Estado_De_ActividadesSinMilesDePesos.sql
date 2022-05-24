/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesSinMiles]    Script Date: 02/07/2013 10:54:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_ActividadesSinMiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesSinMiles]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_ActividadesSinMiles]    Script Date: 02/07/2013 10:54:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[REPORTE_Estado_De_ActividadesSinMiles]

 @Mes int,
 @Año int
 
AS
BEGIN
	
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
--PROCEDIMIENTO FINAL

Declare @Tmp_BalanzaDeComprobacion TABLE(NumeroCuenta varchar(max),NombreCuenta varchar(max),CargosSinFlujo decimal(15,2),AbonosSinFlujo decimal(15,2),TotalCargos decimal(15,2),TotalAbonos decimal(15,2),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),TipoCuenta int,  MaskNumeroCuenta varchar(max),Total int, Mes int, Year int, MaskNombreCuenta varchar(max),NumeroCuentaAnt varchar(max), SaldoDeudorAnt decimal(15,2),SaldoAcreedorAnt decimal(15,2),MesAnt int,AñoAnt int,Agrupador int  )

INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt, RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt, RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.Year AS AñoAnt, 1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      dbo.RPT_Balanza_Comprobacio_Anterior(@Mes , @Año - 1) AS RPT_Balanza_Comprobacio_Anterior_1 ON 
                      dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) AND (dbo.T_SaldosInicialesCont.Year = @Año) 
ORDER BY dbo.C_Contable.NumeroCuenta
--Acreedor
Select @433ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43300')
Select @434ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43400')
select @551ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55100')
select @552ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55200')
select @554ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55400')
select @555ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55500')
--AcreedorAnt
Select @433ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43300')
Select @434ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43400')
select @551ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55100')
select @552ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55200')
select @554ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55400')
select @555ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55500')
--Deudor
Select @433DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43300')
Select @434DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43400')
select @551DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55100')
select @552DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55200')
select @554DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55400')
select @555DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55500')
--DeudorAnt
Select @433DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43300')
Select @434DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='43400')
select @551DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55100')
select @552DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55200')
select @554DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55400')
select @555DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @Año and MaskNumeroCuenta='55500')

UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCIÓN DEL EXCESO DE ESTIMACIONES POR PÉRDIDA O DETERIORO U OBSOLESCENCIA Y PROVISIONES', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,
	SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = '43300'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES Y PROVISIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,
	SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = '55100'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR PÉRDIDA, DETERIORO U OBSOLESCENCIA Y PROVISIONES',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,
	SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = '55400'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta='41500'
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'
	
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '43400'
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '55200'
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '55500'

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
(SaldoAcreedorAnt) as SaldoDeudorAnt,
MesAnt,
AñoAnt,
Agrupador
FROM @Tmp_BalanzaDeComprobacion
--FIN DE PROCEDIMIENTO

END

--//////////FIN REPORTE_Estado_De_ActividadesSinMiles


GO


