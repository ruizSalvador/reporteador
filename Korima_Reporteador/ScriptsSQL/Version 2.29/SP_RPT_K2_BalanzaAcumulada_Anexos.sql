/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_BalanzaAcumulada_Anexos]    Script Date: 06/01/2015 13:02:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_BalanzaAcumulada_Anexos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_BalanzaAcumulada_Anexos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_BalanzaAcumulada_Anexos]    Script Date: 06/01/2015 13:02:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_BalanzaAcumulada_Anexos]
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
@Suma bit,
@CtoNivel bit
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
CuentaNumero bigint,
Nivel int)

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
Financiero int,
Nivel int)

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
Financiero int,
Nivel int)

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
CuentaNumero bigint,
Nivel int,
Negritas int)

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
CuentaNumero bigint,
Nivel int,
Negritas int)

IF (@CtoNivel = 0 OR @Suma = 1)
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
						When 'I'  Then 0
						Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
					End as SaldoAcreedor, Afectable,C_Contable.Financiero,
					convert(bigint, Replace(Numerocuenta,'-','')) as CuentaNumero,
					Nivel 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And Mes = @PeriodoIncial  And [Year] = @Ejercicio And TipoCuenta <> 'X' and Nivel>=0 
	Order By NumeroCuenta
 END
ELSE
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
							When 'I'  Then 0
							Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
						End as SaldoAcreedor, Afectable,C_Contable.Financiero,
						convert(bigint, Replace(Numerocuenta,'-','')) as CuentaNumero,
						Nivel 
		From C_Contable, T_SaldosInicialesCont 
		Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
		And Mes = @PeriodoIncial  And [Year] = @Ejercicio And TipoCuenta <> 'X' --and Nivel>=0 
		and Nivel in (2,3)
		Order By NumeroCuenta
 END

IF (@CtoNivel = 0  OR  @Suma = 1)
BEGIN
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
					End as SaldoAcreedor, Afectable,C_Contable.Financiero, Nivel 
	From C_Contable, T_SaldosInicialesCont
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And Mes = @PeriodoFinal  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
	Order By NumeroCuenta
 END
ELSE 
 BEGIN
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
					End as SaldoAcreedor, Afectable,C_Contable.Financiero, Nivel 
	From C_Contable, T_SaldosInicialesCont
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And Mes = @PeriodoFinal  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
	And Nivel in (2,3)
	Order By NumeroCuenta
 END

IF (@CtoNivel = 0  OR  @Suma = 1)
 BEGIN
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
					End as SaldoAcreedor, Afectable,C_Contable.Financiero, Nivel 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And (Mes between @PeriodoIncial and @PeriodoFinal)  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero, Nivel 
	Order By NumeroCuenta
 END
ELSE
 BEGIN
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
					End as SaldoAcreedor, Afectable,C_Contable.Financiero, Nivel 
	From C_Contable, T_SaldosInicialesCont 
	Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	And (Mes between @PeriodoIncial and @PeriodoFinal)  And [Year] = @Ejercicio And TipoCuenta <> 'X' 
	And Nivel in (2,3)
	GROUP BY NumeroCuenta,NombreCuenta, TipoCuenta, Afectable, Financiero, Nivel 
	Order By NumeroCuenta
 END

Insert into @Resultado 
Select Inicial.NumeroCuenta, 
CASE 
	when Inicial.Nivel = 2 then Inicial.NombreCuenta
	when Inicial.Nivel = 3 then '    '+Inicial.NombreCuenta 
	when Inicial.Nivel = 4 then '      '+Inicial.NombreCuenta
	when Inicial.Nivel = 5 then '        '+Inicial.NombreCuenta
   when Inicial.Nivel >= 6 then '          '+Inicial.NombreCuenta 
	ELSE Inicial.NombreCuenta
	END as NombreCuenta, 
ISNULL(Inicial.CargosSinFlujo,0), 
ISNULL(Inicial.AbonosSinFlujo,0), 
ISNULL(Acumulado.TotalCargos,0), 
ISNULL(Acumulado.TotalAbonos,0),
ISNULL(Final.SaldoDeudor,0),
ISNULL(Final.SaldoAcreedor,0),
Inicial.Afectable,
Inicial.Financiero,
Inicial.CuentaNumero,
Inicial.Nivel,
CASE Inicial.Financiero When 1 Then 1 ELSE 0 END AS Negritas 
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

if @CuentaInicio<>'' and @CuentaFin<>'' 
Begin
	declare @like varchar(10)
	Set @like = SUBSTRING(@CuentaFin,1,3)+'%'
	
	insert #ResultadoTMP
	select * from @Resultado Where (CuentaNumero Between @CuentaInicio  AND @CuentaFin and Financiero in (0,1,2) and Nivel >=2) OR (NumeroCuenta LIKE @like and Financiero in (0,1,2) and Nivel >=2) order by NumeroCuenta
End
Else
Begin
	insert #ResultadoTMP 
	select * from @Resultado Where Financiero in (0,1,2) and Nivel >=2 order by NumeroCuenta
End


declare @cmd as varchar(max)

if @Suma = 1 begin
	if @Mayor =1
	begin
		SET @CMD= 'Select
		SUM(CargosSinFlujo)AS CargosSinFlujo ,
		SUM(AbonosSinFlujo)AS AbonosSinFlujo,
		SUM(TotalCargos) AS TotalCargos,
		SUM(TotalAbonos)AS TotalAbonos,
		SUM(SaldoDeudor) AS SaldoDeudor,
		SUM(SaldoAcreedor) AS SaldoAcreedor
		FROM #ResultadoTMP Where 1 = 1'
	end
	else begin
		SET @CMD= 'Select
		SUM(CargosSinFlujo)AS CargosSinFlujo ,
		SUM(AbonosSinFlujo)AS AbonosSinFlujo,
		SUM(TotalCargos) AS TotalCargos,
		SUM(TotalAbonos)AS TotalAbonos,
		SUM(SaldoDeudor) AS SaldoDeudor,
		SUM(SaldoAcreedor) AS SaldoAcreedor
		FROM #ResultadoTMP Where Afectable = 1'
	end	
end 
else begin
	SET @cmd ='Select * from #ResultadoTMP Where 1=1'
end
 

if @Saldo =1 set @cmd += ' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0)'
if @Movimientos =1 set @cmd += ' AND (TotalCargos <> 0 OR TotalAbonos <> 0 and Financiero in (0,1,2) and Nivel >=2)'
if @SaldoYMovimientos =1  set @cmd += ' AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))'
if @SaldoOMovimientos =1 set @cmd+=' AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)'
if @Mayor =1 set @cmd += ' AND Financiero = 1'
if @DeOrden =1 set @cmd +=' AND NumeroCuenta NOT LIKE ''8%'' AND NumeroCuenta NOT LIKE ''7%'' AND NumeroCuenta NOT LIKE ''9%'''
--if @CuentaInicio<>'' and @CuentaFin<>'' set @cmd += ' AND (CuentaNumero Between '+@CuentaInicio+ ' AND '+@CuentaFin +') and Financiero in (0,1,2) and Nivel >=2 OR (NumeroCuenta LIKE ''' + SUBSTRING(@CuentaFin,1,3) + '%''' + ' and Financiero in (0,1,2) and Nivel >=2) '

if @Suma = 0 begin  -- Ordenar por número de cuenta al final
   set @cmd += ' order by NumeroCuenta' --DM 20151005
END
--print @cmd
exec (@cmd)
Drop table #ResultadoTMP

GO


EXEC SP_FirmasReporte 'Balanza de Comprobación Acumulada'
GO

Exec SP_CFG_LogScripts 'SP_RPT_K2_BalanzaAcumulada_Anexos','2.29'
GO
--Select SUBSTRING('1250000000',1,3)

--EXEC SP_RPT_K2_BalanzaAcumulada_Anexos 3,10,2019,0,0,0,0,0,0,'1110000000','1250000000',0,0
--EXEC SP_RPT_K2_BalanzaAcumulada 3,10,2015,0,0,0,0,0,0,'','',1,0
