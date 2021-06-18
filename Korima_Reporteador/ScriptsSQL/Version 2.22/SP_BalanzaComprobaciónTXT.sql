/****** Object:  StoredProcedure [dbo].[SP_CatalogoBalanzaTXT]    Script Date: 07/23/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BalanzaComprobaciónTXT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_BalanzaComprobaciónTXT]
GO

/****** Object:  StoredProcedure [dbo].[SP_BalanzaComprobaciónTXT]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_BalanzaComprobaciónTXT]
@Ejercicio int
AS

Declare @SaldosIniciales as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,0), 
AbonosSinFlujo Decimal(18,0),
TotalCargos Decimal(18,0),
TotalAbonos Decimal(18,0),
SaldoDeudor  Decimal(18,0),
SaldoAcreedor  Decimal(18,0),
Afectable int,
Financiero int,
CuentaNumero bigint)


Declare @Acumulado1 as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,0), 
AbonosSinFlujo Decimal(18,0),
TotalCargos Decimal(18,0),
TotalAbonos Decimal(18,0),
SaldoDeudor  Decimal(18,0),
SaldoAcreedor  Decimal(18,0),
Afectable int,
Financiero int)


Declare @Resultado as table (
Num1 varchar(2),
Num2 varchar(2),
Num3 varchar(2),
Num4 varchar(2),
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,0), 
AbonosSinFlujo Decimal(18,0),
TotalCargos1 Decimal(18,0),
TotalAbonos1 Decimal(18,0),
Afectable int,
Financiero int,
CuentaNumero bigint)

BEGIN

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
						When 'I' Then 0
						Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero,
					convert(bigint, Replace(Numerocuenta,'-','')) as CuentaNumero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And Mes = 1  And [Year] = @Ejercicio And TipoCuenta <> 'X' and Nivel>=0 
	Order By NumeroCuenta

INSERT INTO @Acumulado1 
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
						When 'I' Then 0
						Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo) + SUM(TotalAbonos) - SUM(TotalCargos) 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
    And Mes Between 1 and 12  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
	Order By NumeroCuenta




	Insert into @Resultado 
Select 
SUBSTRING (Inicial.NumeroCuenta,1,1) as Num1,
SUBSTRING (Inicial.NumeroCuenta,2,1) as Num2,
SUBSTRING (Inicial.NumeroCuenta,3,1) as Num3,
SUBSTRING (Inicial.NumeroCuenta,4,1) as Num4,
SUBSTRING (Inicial.NumeroCuenta,1,4)NumeroCuenta,
--REPLACE(Substring(Inicial.numerocuenta,1,len(rtrim(Inicial.numerocuenta))),'-','')+REPLICATE(' ',11-len(rtrim(Inicial.numerocuenta))) as CuentaContable, 
Inicial.NombreCuenta,  
ISNULL(Inicial.CargosSinFlujo,0), 
ISNULL(Inicial.AbonosSinFlujo,0), 
ISNULL(Acumulado1.TotalCargos,0), 
ISNULL(Acumulado1.TotalAbonos,0),
Inicial.Afectable,
Inicial.Financiero,
Inicial.CuentaNumero 
FROM @SaldosIniciales Inicial
LEFT OUTER JOIN @Acumulado1 Acumulado1
ON Inicial.NumeroCuenta = Acumulado1.NumeroCuenta 


SELECT 
SUBSTRING (NumeroCuenta,1,1) as Num1,
SUBSTRING (NumeroCuenta,2,1) as Num2,
SUBSTRING (NumeroCuenta,3,1) as Num3,
SUBSTRING (NumeroCuenta,4,1) as Num4,
NumeroCuenta,
SUM(CargosSinFlujo) as CargosSinFlujo, 
SUM(AbonosSinFlujo) as AbonosSinFlujo, 
SUM(TotalCargos1) as TotalCargos, 
SUM(TotalAbonos1) as TotalAbonos
 FROM  @Resultado 
 Group by NumeroCuenta
END
GO
--exec SP_BalanzaComprobaciónTXT 2015