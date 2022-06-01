/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_BalanzaAcumulada]    Script Date: 06/01/2015 13:02:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_BalanzaAcumulada]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_BalanzaAcumulada]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_BalanzaAcumulada]    Script Date: 06/01/2015 13:02:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_BalanzaAcumulada]
@PeriodoIncial int, 
@PeriodoFinal int, 
@Ejercicio int,
@Saldo bit, 
@Movimientos bit, 
@Mayor bit, 
@DeOrden bit,
@SaldoYMovimientos bit,
@SaldoOMovimientos bit,
@CuentaInicio varchar(20),
@CuentaFin VArchar(20),
@Suma bit
AS
--declare @CuentaInicio2 Bigint
--set @Cuentainicio2=Convert(bigint,@CuentaInicio )
--declare @CuentaFin2 Bigint
--set @CuentaFin2=Convert(bigint,@CuentaFin )

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

Declare @SaldosFinales as table (
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
Afectable int,
Financiero int,
CuentaNumero bigint)

CREATE TABLE #ResultadoTMP (
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
And Mes = @PeriodoIncial  And [Year] = @Ejercicio And TipoCuenta <> 'X' and Nivel>=0 
Order By NumeroCuenta

INSERT INTO @SaldosFinales
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
                End as SaldoAcreedor, Afectable,C_Contable.Financiero 
From C_Contable, T_SaldosInicialesCont
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And Mes = @PeriodoFinal  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
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
And (Mes between @PeriodoIncial and @PeriodoFinal)  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero 
Order By NumeroCuenta

Insert into @Resultado 
Select Inicial.NumeroCuenta, 
Inicial.NombreCuenta, 
ISNULL(Inicial.CargosSinFlujo,0), 
ISNULL(Inicial.AbonosSinFlujo,0), 
ISNULL(Acumulado.TotalCargos,0), 
ISNULL(Acumulado.TotalAbonos,0),
ISNULL(Final.SaldoDeudor,0),
ISNULL(Final.SaldoAcreedor,0),
Inicial.Afectable,
Inicial.Financiero,
Inicial.CuentaNumero 
FROM @SaldosIniciales Inicial
LEFT OUTER JOIN @SaldosFinales Final
ON Inicial.NumeroCuenta = Final.NumeroCuenta 
LEFT OUTER JOIN @Acumulado Acumulado
ON Inicial.NumeroCuenta =Acumulado.NumeroCuenta 
--where 
--CuentaNumero >=Isnull(@CuentaInicio,CuentaNumero)
--Select * from @Resultado
--Select * from @SaldosFinales 
--Select * from @Acumulado 
--select * from @SaldosIniciales 

insert #ResultadoTMP 
select * from @Resultado
declare @cmd as varchar(max)
if @Suma = 1 begin
SET @CMD= 'Select
 SUM(CargosSinFlujo) AS CargosSinFlujo,
SUM(AbonosSinFlujo) AS AbonosSinFlujo,
SUM(TotalCargos) AS TotalCargos,
SUM(TotalAbonos) AS TotalAbonos,
SUM(SaldoDeudor) AS SaldoDeudor,
SUM(SaldoAcreedor) AS SaldoAcreedor
FROM #ResultadoTMP Where 1 = 1'
end 
else begin
SET @cmd ='Select * from #ResultadoTMP Where 1=1'
end



if @Mayor =1 
	begin
		set @cmd += ' AND Financiero = 1'
		if @Saldo =1 set @cmd += ' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0)'
		if @Movimientos =1 set @cmd += ' AND (TotalCargos <> 0 OR TotalAbonos <> 0)'
		if @SaldoYMovimientos =1  set @cmd += ' AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))'
		if @SaldoOMovimientos =1 set @cmd+=' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)'
		if @DeOrden =1 set @cmd +=' AND NumeroCuenta NOT LIKE ''8%'' AND NumeroCuenta NOT LIKE ''7%'' AND NumeroCuenta NOT LIKE ''9%'''
		if @CuentaInicio<>'' and @CuentaFin<>'' set @cmd += ' AND (CuentaNumero Between '+@CuentaInicio+ ' AND '+@CuentaFin +')'
	end

else
	begin
		set @cmd += ' and Afectable = 1'
		if @Saldo =1 set @cmd += ' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0) and Afectable = 1'
		if @Movimientos =1 set @cmd += ' AND (TotalCargos <> 0 OR TotalAbonos <> 0) and Afectable = 1'
		if @SaldoYMovimientos =1  set @cmd += ' AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0)) and Afectable = 1'
		if @SaldoOMovimientos =1 set @cmd+=' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0) and Afectable = 1'
		if @DeOrden =1 set @cmd +=' AND NumeroCuenta NOT LIKE ''8%'' AND NumeroCuenta NOT LIKE ''7%'' AND NumeroCuenta NOT LIKE ''9%'' and Afectable = 1'
		if @CuentaInicio<>'' and @CuentaFin<>'' set @cmd += ' AND (CuentaNumero Between '+@CuentaInicio+ ' AND '+@CuentaFin +') and Afectable = 1'
	end
--print @cmd
exec (@cmd)
Drop table #ResultadoTMP

GO


EXEC SP_FirmasReporte 'Balanza de Comprobación Acumulada'
GO