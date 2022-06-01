/****** Object:  StoredProcedure [dbo].[SP_BalanzaTXT]    Script Date: 07/23/2014 09:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BalanzaTXT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_BalanzaTXT]
GO

/****** Object:  StoredProcedure [dbo].[SP_BalanzaTXT]    Script Date: 03/10/2014 09:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_BalanzaTXT 1,2017,5
CREATE PROCEDURE [dbo].[SP_BalanzaTXT]
@trimestre smallint,
@Ejercicio int,
@Nivel int

AS
Declare @mes1 as int
Declare @mes2 as int


IF @trimestre = 1
Begin
	set @mes1 = 1
	set @mes2 = 3
End

IF @trimestre = 2
Begin
	set @mes1 = 4
	set @mes2 = 6
End

IF @trimestre = 3
Begin
	set @mes1 = 7
	set @mes2 = 9
End

IF @trimestre = 4
Begin
	set @mes1 = 10
	set @mes2 = 12
End

Declare @Header as table (
TipoArchivo varchar(4), 
TipoRegistro int, 
Ejercicio int,
Trimestre int,
NoRegistros int,
AcumSaldoInicial Decimal(15,2),
AcumCargos Decimal(15,2),
AcumAbonos Decimal(15,2))

Declare @SaldosIniciales as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,2), 
AbonosSinFlujo Decimal(18,2),
TotalCargos Decimal(18,2),
TotalAbonos Decimal(18,2),
SaldoDeudor  Decimal(18,2),
SaldoAcreedor  Decimal(18,2),
Afectable int,
Financiero int,
CuentaNumero bigint,
TipoCuenta varchar(2))


Declare @Acumulado1 as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo Decimal (18,2), 
AbonosSinFlujo Decimal(18,2),
TotalCargos Decimal(18,2),
TotalAbonos Decimal(18,2),
SaldoDeudor  Decimal(18,2),
SaldoAcreedor  Decimal(18,2),
Afectable int,
Financiero int)


Declare @Resultado as table (
TipoRegistro int,
CuentaContable varchar(100), 
SaldoInicial decimal (15,2), 
Cargos Decimal(15,2),
Abonos Decimal(15,2))

BEGIN

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)


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
					convert(bigint, Replace(Numerocuenta,'-','')) as CuentaNumero,
					TipoCuenta 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And Mes = @mes1  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and SUBSTRING(NumeroCuenta,1,1) <= 5  --DM Solicitan que salgan todas
	AND Nivel>=0 
	Order By NumeroCuenta

--Select  * from @SaldosIniciales

IF @Estructura1 = 5
BEGIN
	IF @Nivel = 4
		BEGIN
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
		AND (Mes Between @mes1 and @mes2)  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and SUBSTRING(NumeroCuenta,1,1) <= 5 
		AND C_Contable.IdCuentaContable >10
		AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and SUBSTRING(NumeroCuenta,5,1)=0)
		AND SUBSTRING(NumeroCuenta ,CHARINDEX('-', NumeroCuenta) + 1 ,@Estructura2) = @CerosEstructura
		GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero
		Order By NumeroCuenta
		END
	ELSE 
		BEGIN
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
			AND (Mes Between @mes1 and @mes2)  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and SUBSTRING(NumeroCuenta,1,1) <= 5 
			AND C_Contable.IdCuentaContable >10
			--AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and SUBSTRING(NumeroCuenta,5,1)>=0) --DM: Ya no mostrar de 4to Nivel 
			AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and SUBSTRING(NumeroCuenta,5,1)>=1) --Al seleccionar 5to Nivel
			AND SUBSTRING(NumeroCuenta ,CHARINDEX('-', NumeroCuenta) + 1 ,@Estructura2) = @CerosEstructura
			GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero
			Order By NumeroCuenta

		END
END
ELSE
BEGIN
	IF @Nivel = 4
		BEGIN
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
			AND (Mes Between @mes1 and @mes2)  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and SUBSTRING(NumeroCuenta,1,1) <= 5 
			AND C_Contable.IdCuentaContable >10
			AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and SUBSTRING(NumeroCuenta,5,1)=0 and SUBSTRING(NumeroCuenta,6,1)=0)
			AND SUBSTRING(NumeroCuenta ,CHARINDEX('-', NumeroCuenta) + 1 ,@Estructura2) = @CerosEstructura
			GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero
			Order By NumeroCuenta
		END
	ELSE
		BEGIN
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
			AND (Mes Between @mes1 and @mes2)  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and SUBSTRING(NumeroCuenta,1,1) <= 5 
			AND C_Contable.IdCuentaContable >10
			--AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and (SUBSTRING(NumeroCuenta,5,1)>=0 or  SUBSTRING(NumeroCuenta,6,1)>=0))
			AND (SUBSTRING(NumeroCuenta,1,1) >= 1 and SUBSTRING(NumeroCuenta,2,1) >= 1 and SUBSTRING(NumeroCuenta,3,1) >=1 and SUBSTRING(NumeroCuenta,4,1)>=1 and (SUBSTRING(NumeroCuenta,5,1)>=1 or  SUBSTRING(NumeroCuenta,6,1)>=1))
			AND SUBSTRING(NumeroCuenta ,CHARINDEX('-', NumeroCuenta) + 1 ,@Estructura2) = @CerosEstructura
			GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero
			Order By NumeroCuenta
		END
END

--Select * from @SaldosIniciales
--Select * from @Acumulado1

Insert into @Resultado 
Select
2,
CASE WHEN (SUBSTRING(I.NumeroCuenta,5,1) = 0 and SUBSTRING(I.NumeroCuenta,6,1) =0)
	 THEN SUBSTRING(I.NumeroCuenta,1,1) + '.' + SUBSTRING(I.NumeroCuenta,2,1) + '.' + SUBSTRING(I.NumeroCuenta,3,1) + '.' + SUBSTRING(I.NumeroCuenta,4,1) --+ '.' + SUBSTRING(I.NumeroCuenta,5,1) --DM Se quita el cero en 4to Nivel
	 WHEN (SUBSTRING(I.NumeroCuenta,5,1) = 0 and SUBSTRING(I.NumeroCuenta,6,1) >=0) OR (SUBSTRING(I.NumeroCuenta,5,1) >= 0 and SUBSTRING(I.NumeroCuenta,6,1) >0)
	 THEN SUBSTRING(I.NumeroCuenta,1,1) + '.' + SUBSTRING(I.NumeroCuenta,2,1) + '.' + SUBSTRING(I.NumeroCuenta,3,1) + '.' + SUBSTRING(I.NumeroCuenta,4,1) + '.' + SUBSTRING(I.NumeroCuenta,5,2)
ELSE SUBSTRING(I.NumeroCuenta,1,1) + '.' + SUBSTRING(I.NumeroCuenta,2,1) + '.' + SUBSTRING(I.NumeroCuenta,3,1) + '.' + SUBSTRING(I.NumeroCuenta,4,1) + '.' + SUBSTRING(I.NumeroCuenta,5,1)
END AS CuentaContable,
CASE I.TipoCuenta
	WHEN 'A' THEN I.CargosSinFlujo
	WHEN 'B' THEN I.AbonosSinFlujo
	WHEN 'C' THEN I.CargosSinFlujo
	WHEN 'D' THEN I.AbonosSinFlujo
	WHEN 'E' THEN I.CargosSinFlujo
	WHEN 'F' THEN I.AbonosSinFlujo
	WHEN 'G' THEN I.CargosSinFlujo
	WHEN 'H' THEN I.AbonosSinFlujo
	WHEN 'I' THEN I.CargosSinFlujo
	WHEN 'J' THEN I.AbonosSinFlujo
	WHEN 'K' THEN I.CargosSinFlujo
END as SaldoInicial,
ISNULL(A.TotalCargos,0),
ISNULL(A.TotalAbonos,0)

FROM @SaldosIniciales I
INNER JOIN @Acumulado1 A
ON I.NumeroCuenta = A.NumeroCuenta  

Insert Into @Header
	Select 'TC',
	1,
	@Ejercicio,
	@trimestre,
	(Select count(TipoRegistro) from @Resultado),
	(Select SUM(SaldoInicial) from @Resultado),
	(Select SUM(Cargos) from @Resultado),
	(Select SUM(Abonos) from @Resultado)


Select 
TipoArchivo as F1, 
CAST(TipoRegistro as varchar(1)) as F2, 
CAST(Ejercicio as varchar(4)) as F3,
CAST(Trimestre as varchar(1)) as F4,
NoRegistros as F5,
AcumSaldoInicial as F6,
AcumCargos as F7,
AcumAbonos as F8 
from @Header

UNION ALL
Select 
CAST(TipoRegistro as varchar(1)) as F1,
CuentaContable as F2,
CAST(SaldoInicial as varchar(18)) as F3,
CAST(Cargos as varchar(18)) as F4,
Abonos as F5, 
null as F6,
null as F7,
null as F8
from @Resultado
Order By F2

END


--Select * from @Acumulado1

GO

Exec SP_CFG_LogScripts 'SP_BalanzaTXT'
GO


--EXEC [SP_BalanzaTXT] 1,2017,5