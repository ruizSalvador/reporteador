/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EndeudamientoNeto]    Script Date: 12/04/2014 12:21:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_EndeudamientoNeto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_EndeudamientoNeto]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_EndeudamientoNeto]    Script Date: 12/04/2014 12:21:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_K2_EndeudamientoNeto 2,5,2021,0
CREATE PROCEDURE [dbo].[SP_RPT_K2_EndeudamientoNeto]
@MesInicio int, @MesFin Int, @Ejercicio int, @Mayor bit
AS
BEGIN

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

declare @rpt as table (Numerocuenta varchar(max),NombreCuenta varchar(max), Abonos decimal(18,4),Cargos decimal(18,4), Endeudamiento decimal(18,4),Grupo varchar(max))

If @mayor =1 BEGIN
Insert Into @rpt 
Select c_contable.NumeroCuenta,c_contable.NombreCuenta,
CASE WHEN SUM(TS.TotalAbonos) = 0 THEN (Select AbonosSinFlujo from T_SaldosInicialesCont  Where IdCuentaContable = TS.IdCuentaContable AND Mes = @MesInicio AND YEAR = @Ejercicio)
ELSE SUM(TS.TotalAbonos) END as Abonos, 
SUM(TS.TotalCargos) as Cargos, SUM(TS.TotalAbonos)-SUM(TS.TotalCargos) as Endeudamiento,
'Créditos Bancarios' as Grupo
 From T_SaldosInicialesCont TS
 Join c_contable on C_Contable.IdCuentaContable=TS.IdCuentaContable 
 Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21310'+REPLICATE('0',@estructura1-5),'21410'+REPLICATE('0',@estructura1-5),'31330'+REPLICATE('0',@estructura1-5),'22330'+REPLICATE('0',@estructura1-5),'22310'+REPLICATE('0',@estructura1-5),'22351'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))=@CerosEstructura
 Group By NumeroCuenta, NombreCuenta, TS.IdCuentaContable

 UNION

 Select c_contable.NumeroCuenta,c_contable.NombreCuenta,
 CASE WHEN SUM(TS.TotalAbonos) = 0 THEN (Select AbonosSinFlujo from T_SaldosInicialesCont  Where IdCuentaContable = TS.IdCuentaContable AND Mes = @MesInicio AND YEAR = @Ejercicio)
ELSE SUM(TS.TotalAbonos) END as Abonos, 
SUM(TS.TotalCargos) as Cargos, SUM(TS.TotalAbonos)-SUM(TS.TotalCargos) as Endeudamiento,
'Otros Instrumentos de Deuda'as Grupo 
 From T_SaldosInicialesCont TS
 Join c_contable on C_Contable.IdCuentaContable=TS.IdCuentaContable 
 Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21320'+REPLICATE('0',@estructura1-5),'21410'+REPLICATE('0',@estructura1-5),'21330'+REPLICATE('0',@estructura1-5),'22340'+REPLICATE('0',@estructura1-5),'22320'+REPLICATE('0',@estructura1-5),'22352'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))=@CerosEstructura
 Group By NumeroCuenta, NombreCuenta, TS.IdCuentaContable


END 
ELSE BEGIN
Insert Into @rpt 
Select c_contable.NumeroCuenta,c_contable.NombreCuenta,
CASE WHEN SUM(TS.TotalAbonos) = 0 THEN (Select AbonosSinFlujo from T_SaldosInicialesCont  Where IdCuentaContable = TS.IdCuentaContable AND Mes = @MesInicio AND YEAR = @Ejercicio)
ELSE SUM(TS.TotalAbonos) END as Abonos, 
SUM(TS.TotalCargos) as Cargos, SUM(TS.TotalAbonos)-SUM(TS.TotalCargos) as Endeudamiento,
'Créditos Bancarios' as Grupo
 From T_SaldosInicialesCont TS
 Join c_contable on C_Contable.IdCuentaContable=TS.IdCuentaContable 
 Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21310'+REPLICATE('0',@estructura1-5),'21410'+REPLICATE('0',@estructura1-5),'31330'+REPLICATE('0',@estructura1-5),'22330'+REPLICATE('0',@estructura1-5),'22310'+REPLICATE('0',@estructura1-5),'22351'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))<>@CerosEstructura
 Group By NumeroCuenta, NombreCuenta, TS.IdCuentaContable

 UNION

 Select c_contable.NumeroCuenta,c_contable.NombreCuenta,
 CASE WHEN SUM(TS.TotalAbonos) = 0 THEN (Select AbonosSinFlujo from T_SaldosInicialesCont  Where IdCuentaContable = TS.IdCuentaContable AND Mes = @MesInicio AND YEAR = @Ejercicio)
ELSE SUM(TS.TotalAbonos) END as Abonos,
SUM(TS.TotalCargos) as Cargos, SUM(TS.TotalAbonos)-SUM(TS.TotalCargos) as Endeudamiento,
'Otros Instrumentos de Deuda'as Grupo 
From T_SaldosInicialesCont TS
Join c_contable on C_Contable.IdCuentaContable=TS.IdCuentaContable 
 Where (Mes between @MesInicio and @MesFin) and Year =@Ejercicio
 AND Substring(NumeroCuenta, 1,@Estructura1) in ('21320'+REPLICATE('0',@estructura1-5),'21410'+REPLICATE('0',@estructura1-5),'21330'+REPLICATE('0',@estructura1-5),'22340'+REPLICATE('0',@estructura1-5),'22320'+REPLICATE('0',@estructura1-5),'22352'+REPLICATE('0',@estructura1-5)) and 
 SUBSTRING (numerocuenta, @Estructura1+2,LEN(numerocuenta))<>@CerosEstructura
 Group By NumeroCuenta, NombreCuenta, TS.IdCuentaContable
 END

 Update @rpt set Endeudamiento = Abonos - Cargos
 
Select * From @rpt Where Abonos + Cargos + Endeudamiento <> 0
END

 
GO


Exec SP_FirmasReporte 'Endeudamiento Neto'
GO



