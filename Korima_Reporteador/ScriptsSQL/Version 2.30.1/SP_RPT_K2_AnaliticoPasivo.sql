/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoPasivo]    Script Date: 10/28/2014 13:47:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AnaliticoPasivo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AnaliticoPasivo]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoPasivo]    Script Date: 10/28/2014 13:47:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_AnaliticoPasivo 0,0,7,2019,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_AnaliticoPasivo]
@Miles Bit,
@Totales Bit,
--@MostrarVacios Bit,
@Periodo int,
@Ejercicio int,
@MostarSinSaldo bit
AS


--Manejo de miles de pesos
Declare @Division int
IF @Miles= 1 set @Division =1000
else Set @Division=1

--Tipos de estructura 5-5 , 5-6 , 6-6
Declare @Estructura1 as int
Declare @Estructura2 as int
Set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
Set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
Declare @CerosEstructura varchar(20)
Set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @Tabla  table(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(18,4),
AbonosSinFlujo decimal(18,4),
TotalCargos decimal(18,4),
TotalAbonos decimal(18,4),
SaldoDeudor decimal(18,4),
SaldoAcreedor decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4)
)

Declare @SaldosIniciales as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int,
CuentaNumero bigint)

Declare @Acumulado as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int)

Declare @Resultado as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4)
)



INSERT INTO @SaldosIniciales 
	Select NumeroCuenta, NombreCuenta, CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos,
					Case C_Contable.TipoCuenta 
						When 'A' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'C' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'E' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'G' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						When 'I' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
						Else 0
					End as SaldoDeudor,
					Case C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I'  Then 0
						Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero,
					convert(bigint, Replace(Numerocuenta,'-','')) as CuentaNumero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	AND Mes = 1  And [Year] = @Ejercicio 
    AND TipoCuenta <> 'X'
    AND  (NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
	--and Nivel>=0 
	Order By NumeroCuenta
 


INSERT INTO @Acumulado 
	Select NumeroCuenta, NombreCuenta, SUM(CargosSinFlujo), SUM(AbonosSinFlujo), SUM(TotalCargos), SUM(TotalAbonos),
					Case C_Contable.TipoCuenta 
						When 'A' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'C' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'E' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'G' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						When 'I' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
						Else 0
					End as SaldoDeudor,
					Case C_Contable.TipoCuenta 
						When 'A' Then 0
						When 'C' Then 0
						When 'E' Then 0
						When 'G' Then 0
						When 'I'  Then 0
						Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo) + SUM(TotalAbonos) - SUM(TotalCargos) 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And (Mes between 1 and @Periodo)  And [Year] = @Ejercicio 
	 AND TipoCuenta <> 'X'
    AND  (NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
	Order By NumeroCuenta


Insert into @Resultado
Select Inicial.NumeroCuenta, 
Inicial.NombreCuenta, 
ISNULL(Inicial.CargosSinFlujo,0)/@division, 
ISNULL(Inicial.AbonosSinFlujo,0)/@division, 
ISNULL(Acumulado.TotalCargos,0)/@division, 
ISNULL(Acumulado.TotalAbonos,0)/@division,
0 as SaldoDeudor,
0 as SaldoAcreedor,
((Inicial.AbonosSinFlujo+Acumulado.TotalAbonos-Acumulado.TotalCargos))/@division as SaldoFinal,
((Inicial.AbonosSinFlujo+Acumulado.TotalAbonos-Acumulado.TotalCargos)-Inicial.AbonosSinFlujo)/@division as FlujoDelPeriodo
FROM @SaldosIniciales Inicial
LEFT OUTER JOIN @Acumulado Acumulado
ON Inicial.NumeroCuenta =Acumulado.NumeroCuenta 
 
--If @MostarSinSaldo=0 DELETE FROM @Tabla where (CargosSinFlujo = 0 OR TotalCargos = 0 OR TotalAbonos = 0 OR SaldoFinal = 0 OR FlujoDelperiodo = 0)

--if @MostrarVacios=1 begin
Insert @Resultado
SELECT NumeroCuenta, 
NombreCuenta,
0 as CargosSinflujo,
0 as AbonosSinFlujos,
0 as TotalCargos,
0 as TotalAbonos,
0 as SaldoDeudor,
0 as SaldoAcreedor,
0 as SaldoFinal,
0 as FlujoDelPeriodo
from C_Contable Where NumeroCuenta not in (Select NumeroCuenta from @Resultado ) and 
(NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
--end


If @Totales=1 Begin
If @MostarSinSaldo=1
	SELECT * from @Resultado where NumeroCuenta ='2'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura ORDER BY NumeroCuenta
Else
	SELECT * from @Resultado where NumeroCuenta ='2'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura AND  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
End
Else Begin 
If @MostarSinSaldo=1
	SELECT * from @Resultado ORDER BY NumeroCuenta
Else 
	SELECT * from @Resultado where  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
End

     
GO

EXEC SP_FirmasReporte 'Analitico del pasivo'
GO