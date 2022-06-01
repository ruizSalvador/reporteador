
/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6]    Script Date: 07/24/2013 10:48:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6]
GO

/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6]    Script Date: 07/24/2013 10:48:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6]

 @Mes int,
 @Año int

AS
BEGIN

Declare @Reporte int
	Declare @SSaldo decimal(15,2)
	Declare @SSaldoAnt Decimal(15,2)
	Declare @SSaldo5 decimal(15,2)
	Declare @SSaldoAnt5 decimal(15,2)
	Declare @Var11610 decimal(15,2)
	Declare @Var11620 decimal(15,2)
	Declare @Var11621 decimal(15,2)
	DEclare @Var11622 decimal(15,2)
	Declare @Var11623 decimal(15,2)
	Declare @Var11624 decimal(15,2)
	Declare @Var11625 decimal(15,2)
	Declare @Var12810 decimal(15,2)
	Declare @Var12820 decimal(15,2)
	Declare @Var12830 decimal(15,2)
	Declare @Var12840 decimal(15,2)
	Declare @Var12890 decimal(15,2)
	Declare @Var12600_00000 decimal(15,2)
	Declare @Var12610_00000 decimal(15,2)
	Declare @Var12610_01000 decimal(15,2)
	DEclare @Var12610_02000 decimal(15,2)
	Declare @Var12610_03000 decimal(15,2)
	Declare @Var12610_04000 decimal(15,2)
	Declare @Var12620_00000 decimal(15,2)
	Declare @Var12630 decimal(15,2)
	Declare @Var12630_01000 decimal(15,2)
	Declare @Var12630_02000 decimal(15,2)
	Declare @Var12630_03000 decimal(15,2)
	Declare @Var12630_04000 decimal(15,2)
	Declare @Var12630_05000 decimal(15,2)
	Declare @Var12630_06000 decimal(15,2)
	Declare @Var12630_07000 decimal(15,2)
	Declare @Var12630_08000 decimal(15,2)
	Declare @Var12630_09000 decimal(15,2)
	Declare @Var12630_10000 decimal(15,2)
	Declare @Var12630_11000 decimal(15,2)
	Declare @Var12630_12000 decimal(15,2)
	Declare @Var12630_13000 decimal(15,2)
	Declare @Var12630_14000 decimal(15,2)
	Declare @Var12630_15000 decimal(15,2)
	Declare @Var12630_16000 decimal(15,2)
	Declare @Var12630_17000 decimal(15,2)
	Declare @Var12630_18000 decimal(15,2)
	Declare @Var12630_19000 decimal(15,2)
	Declare @Var12630_20000 decimal(15,2)
	Declare @Var12630_21000 decimal(15,2)
	Declare @Var12630_22000 decimal(15,2)
	Declare @Var12630_23000 decimal(15,2)
	Declare @Var12630_24000 decimal(15,2)
	Declare @Var12630_25000 decimal(15,2)
	DEclare @Var12640_00000 decimal(15,2)
	Declare @Var12640_01000 decimal(15,2)
	Declare @Var12640_02000 decimal(15,2)
	Declare @Var12640_03000 decimal(15,2)
	Declare @Var12640_04000 decimal(15,2)
	Declare @Var12640_05000 decimal(15,2)
	Declare @Var12640_06000 decimal(15,2)
	Declare @Var12640_07000 decimal(15,2)
	Declare @Var12640_08000 decimal(15,2)
	Declare @Var12640_09000 decimal(15,2)
	Declare @Var12650 decimal(15,2)
	Declare @Var12650_01000 decimal(15,2)
	Declare @Var12650_02000 decimal(15,2)
	Declare @Var12650_03000 decimal(15,2)
	Declare @Var12650_04000 decimal(15,2)
	Declare @Var12650_05000 decimal(15,2)
	Declare @Var12650_06000 decimal(15,2)
	Declare @Var12650_07000 decimal(15,2)
	Declare @Var12650_08000 decimal(15,2)
	Declare @Var12650_09000 decimal(15,2)
	
	Declare @Var22310 decimal(15,2)
	Declare @Var22320 decimal(15,2)
	
	Declare @Var11610Ant decimal(15,2)
	Declare @Var11620Ant decimal(15,2)
	Declare @Var11621Ant decimal(15,2)
	DEclare @Var11622Ant decimal(15,2)
	Declare @Var11623Ant decimal(15,2)
	Declare @Var11624Ant decimal(15,2)
	Declare @Var11625Ant decimal(15,2)
	Declare @Var12810Ant decimal(15,2)
	Declare @Var12820Ant decimal(15,2)
	Declare @Var12830Ant decimal(15,2)
	Declare @Var12840Ant decimal(15,2)
	Declare @Var12890Ant decimal(15,2)
	Declare @Var12600_00000Ant decimal(15,2)
	Declare @Var12610_00000Ant decimal(15,2)
	Declare @Var12610_01000Ant decimal(15,2)
	DEclare @Var12610_02000Ant decimal(15,2)
	Declare @Var12610_03000Ant decimal(15,2)
	Declare @Var12610_04000Ant decimal(15,2)
	DEclare @Var12620_00000Ant decimal(15,2)
	Declare @Var12630Ant decimal(15,2)
	Declare @Var12630_01000Ant decimal(15,2)
	Declare @Var12630_02000Ant decimal(15,2)
	Declare @Var12630_03000Ant decimal(15,2)
	Declare @Var12630_04000Ant decimal(15,2)
	Declare @Var12630_05000Ant decimal(15,2)
	Declare @Var12630_06000Ant decimal(15,2)
	Declare @Var12630_07000Ant decimal(15,2)
	Declare @Var12630_08000Ant decimal(15,2)
	Declare @Var12630_09000Ant decimal(15,2)
	Declare @Var12630_10000Ant decimal(15,2)
	Declare @Var12630_11000Ant decimal(15,2)
	Declare @Var12630_12000Ant decimal(15,2)
	Declare @Var12630_13000Ant decimal(15,2)
	Declare @Var12630_14000Ant decimal(15,2)
	Declare @Var12630_15000Ant decimal(15,2)
	Declare @Var12630_16000Ant decimal(15,2)
	Declare @Var12630_17000Ant decimal(15,2)
	Declare @Var12630_18000Ant decimal(15,2)
	Declare @Var12630_19000Ant decimal(15,2)
	Declare @Var12630_20000Ant decimal(15,2)
	Declare @Var12630_21000Ant decimal(15,2)
	Declare @Var12630_22000Ant decimal(15,2)
	Declare @Var12630_23000Ant decimal(15,2)
	Declare @Var12630_24000Ant decimal(15,2)
	Declare @Var12630_25000Ant decimal(15,2)
	DEclare @Var12640_00000Ant decimal(15,2)
	Declare @Var12640_01000Ant decimal(15,2)
	Declare @Var12640_02000Ant decimal(15,2)
	Declare @Var12640_03000Ant decimal(15,2)
	Declare @Var12640_04000Ant decimal(15,2)
	Declare @Var12640_05000Ant decimal(15,2)
	Declare @Var12640_06000Ant decimal(15,2)
	Declare @Var12640_07000Ant decimal(15,2)
	Declare @Var12640_08000Ant decimal(15,2)
	Declare @Var12640_09000Ant decimal(15,2)
	Declare @Var12650Ant decimal(15,2)
	Declare @Var12650_01000Ant decimal(15,2)
	Declare @Var12650_02000Ant decimal(15,2)
	Declare @Var12650_03000Ant decimal(15,2)
	Declare @Var12650_04000Ant decimal(15,2)
	Declare @Var12650_05000Ant decimal(15,2)
	Declare @Var12650_06000Ant decimal(15,2)
	Declare @Var12650_07000Ant decimal(15,2)
	Declare @Var12650_08000Ant decimal(15,2)
	Declare @Var12650_09000Ant decimal(15,2)
	
	Declare @Var22310Ant decimal(15,2)
	Declare @Var22320Ant decimal(15,2)
	


--PROCEDIMIENTO FINAL
--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO
DECLARE  @Tmp_BalanzaDeComprobacion TABLE(
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


--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO AÑO ANTERIOR

DECLARE @Tmp_BalanzaDeComprobacionAnterior TABLE(
IdCuentaContable bigint, 
NumeroCuenta varchar(max),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),  
Mes int, 
Year int)

--LLENO TABLA EN MEMORIA DE SALDOS ANTERIORES

INSERT INTO @Tmp_BalanzaDeComprobacionAnterior SELECT     TOP (100) PERCENT dbo.C_Contable.IdCuentaContable, dbo.C_Contable.NumeroCuenta,
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
                      ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS SaldoAcreedor,dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
AND (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000' ) 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') 
and dbo.T_SaldosInicialesCont.Mes = @mes 
and dbo.T_SaldosInicialesCont.Year = @Año-1 
ORDER BY dbo.C_Contable.NumeroCuenta

--LLENO TABLA TEMPORTAL DE AFECTACION PRESUPUESTO

INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos 
                      WHEN 'C' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos 
                      WHEN 'E' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos 
                      WHEN 'G' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos
                      WHEN 'I' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos 
                      ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN 0 
                      WHEN 'C' THEN 0 
                      WHEN 'E' THEN 0 
                      WHEN 'G' THEN 0 
                      WHEN 'I' THEN 0 
                      ELSE dbo.T_SaldosInicialesCont.AbonosSinFlujo - dbo.T_SaldosInicialesCont.CargosSinFlujo + dbo.T_SaldosInicialesCont.TotalAbonos - dbo.T_SaldosInicialesCont.TotalCargos END AS SaldoAcreedor, 
                      LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, 
                      LEFT(dbo.C_Contable.NumeroCuenta, 6) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 6)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 6), 0, '')) AS Total, 
                      dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, 
                      dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, 
                      dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, 
                      BalanzaDeComprobacionAnterior.SaldoDeudor AS SaldoDeudorAnt, 
                      BalanzaDeComprobacionAnterior.SaldoAcreedor AS SaldoAcreedorAnt, 
                      BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS AñoAnt,1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      @Tmp_BalanzaDeComprobacionAnterior BalanzaDeComprobacionAnterior ON 
                      dbo.C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') 
AND (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000' ) 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') 
AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') 
AND (LEN(REPLACE(REPLACE(dbo.C_Contable.NumeroCuenta, '0', ''), '-', '')) = 1) 
AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) 
AND (dbo.T_SaldosInicialesCont.Year = @Año)
ORDER BY dbo.C_Contable.NumeroCuenta



select @SSaldo = dbo.Saldo_Cuenta('400000-000000',@Mes,@Año)
select @SSaldoAnt = dbo.Saldo_Cuenta('400000-000000',@Mes,@Año-1)
select @SSaldo5 = dbo.Saldo_Cuenta('500000-000000',@Mes,@Año)
select @SSaldoAnt5 = dbo.Saldo_Cuenta('500000-000000' ,@Mes , @Año-1)

select  @Var11610 =dbo.Saldo_Cuenta('116100-000000',@Mes,@Año)
select @Var11620 =dbo.Saldo_Cuenta('116200-000000',@Mes,@Año)
select @Var11621 =dbo.Saldo_Cuenta('116210-000000',@Mes,@Año)
select @Var11622=dbo.Saldo_Cuenta('116220-000000',@Mes,@Año)
select @Var11623 = dbo.Saldo_Cuenta('116230-000000',@Mes,@Año)
select @Var11624=dbo.Saldo_Cuenta('116240-000000',@Mes,@Año)
select @Var11625 = dbo.Saldo_Cuenta('116250-000000',@Mes,@Año)
select @Var12810 = dbo.Saldo_Cuenta('128100-000000',@Mes,@Año)
select @Var12820=dbo.Saldo_Cuenta('128200-000000',@Mes,@Año)
select @Var12830=dbo.Saldo_Cuenta('128300-000000',@Mes,@Año)
select @Var12840 = dbo.Saldo_Cuenta('128400-000000',@Mes,@Año)
select @Var12890 = dbo.Saldo_Cuenta('128900-000000',@Mes,@Año)
select @Var12600_00000 = dbo.Saldo_Cuenta('126000-000000',@Mes,@Año)
select @Var12610_00000 = dbo.Saldo_Cuenta('126100-000000',@Mes,@Año)
select @Var12610_01000 = dbo.Saldo_Cuenta('126100-010000',@Mes,@Año)
select @Var12610_02000 = dbo.Saldo_Cuenta('126100-020000',@Mes,@Año)
select @Var12610_03000 = dbo.Saldo_Cuenta('126100-030000',@Mes,@Año)
select @Var12610_04000 = dbo.Saldo_Cuenta('126100-040000',@Mes,@Año) 
select @Var12620_00000 = dbo.Saldo_Cuenta('126200-000000',@Mes,@Año)
select @Var12630 = dbo.Saldo_Cuenta('126300-000000',@Mes,@Año)

select @Var12630_01000  = dbo.Saldo_Cuenta('126300-010000',@Mes,@Año)
select @Var12630_02000  = dbo.Saldo_Cuenta('126300-020000',@Mes,@Año)
select @Var12630_03000  = dbo.Saldo_Cuenta('126300-030000',@Mes,@Año)
select @Var12630_04000  = dbo.Saldo_Cuenta('126300-040000',@Mes,@Año)
select @Var12630_05000  = dbo.Saldo_Cuenta('126300-050000',@Mes,@Año)
select @Var12630_06000  = dbo.Saldo_Cuenta('126300-060000',@Mes,@Año)
select @Var12630_07000  = dbo.Saldo_Cuenta('126300-070000',@Mes,@Año)
select @Var12630_08000  = dbo.Saldo_Cuenta('126300-080000',@Mes,@Año)
select @Var12630_09000  = dbo.Saldo_Cuenta('126300-090000',@Mes,@Año)
select @Var12630_10000  = dbo.Saldo_Cuenta('126300-100000',@Mes,@Año)
select @Var12630_11000  = dbo.Saldo_Cuenta('126300-110000',@Mes,@Año)
select @Var12630_12000  = dbo.Saldo_Cuenta('126300-120000',@Mes,@Año)
select @Var12630_13000  = dbo.Saldo_Cuenta('126300-130000',@Mes,@Año)
select @Var12630_14000  = dbo.Saldo_Cuenta('126300-140000',@Mes,@Año)
select @Var12630_15000  = dbo.Saldo_Cuenta('126300-150000',@Mes,@Año)
select @Var12630_16000  = dbo.Saldo_Cuenta('126300-160000',@Mes,@Año)
select @Var12630_17000  = dbo.Saldo_Cuenta('126300-170000',@Mes,@Año)
select @Var12630_18000  = dbo.Saldo_Cuenta('126300-180000',@Mes,@Año)
select @Var12630_19000  = dbo.Saldo_Cuenta('126300-190000',@Mes,@Año)
select @Var12630_20000  = dbo.Saldo_Cuenta('126300-200000',@Mes,@Año)
select @Var12630_21000  = dbo.Saldo_Cuenta('126300-210000',@Mes,@Año)
select @Var12630_22000  = dbo.Saldo_Cuenta('126300-220000',@Mes,@Año)
select @Var12630_23000  = dbo.Saldo_Cuenta('126300-230000',@Mes,@Año)
select @Var12630_24000  = dbo.Saldo_Cuenta('126300-240000',@Mes,@Año)
select @Var12630_25000  = dbo.Saldo_Cuenta('126300-250000',@Mes,@Año)

select @Var12640_00000 = dbo.Saldo_Cuenta('126400-000000',@Mes,@Año) 

select @Var12640_01000 = dbo.Saldo_Cuenta('126400-010000',@Mes,@Año) 
select @Var12640_02000 = dbo.Saldo_Cuenta('126400-020000',@Mes,@Año) 
select @Var12640_03000 = dbo.Saldo_Cuenta('126400-030000',@Mes,@Año) 
select @Var12640_04000 = dbo.Saldo_Cuenta('126400-040000',@Mes,@Año) 
select @Var12640_05000 = dbo.Saldo_Cuenta('126400-050000',@Mes,@Año) 
select @Var12640_06000 = dbo.Saldo_Cuenta('126400-060000',@Mes,@Año) 
select @Var12640_07000 = dbo.Saldo_Cuenta('126400-070000',@Mes,@Año) 
select @Var12640_08000 = dbo.Saldo_Cuenta('126400-080000',@Mes,@Año) 
select @Var12640_09000 = dbo.Saldo_Cuenta('126400-090000',@Mes,@Año) 

select @Var12650 = dbo.Saldo_Cuenta('126500-000000',@Mes,@Año)

select @Var12650_01000 = dbo.Saldo_Cuenta('126500-010000',@Mes,@Año) 
select @Var12650_02000 = dbo.Saldo_Cuenta('126500-020000',@Mes,@Año) 
select @Var12650_03000 = dbo.Saldo_Cuenta('126500-030000',@Mes,@Año) 
select @Var12650_04000 = dbo.Saldo_Cuenta('126500-040000',@Mes,@Año) 
select @Var12650_05000 = dbo.Saldo_Cuenta('126500-050000',@Mes,@Año) 
select @Var12650_06000 = dbo.Saldo_Cuenta('126500-060000',@Mes,@Año) 
select @Var12650_07000 = dbo.Saldo_Cuenta('126500-070000',@Mes,@Año) 
select @Var12650_08000 = dbo.Saldo_Cuenta('126500-080000',@Mes,@Año) 
select @Var12650_09000 = dbo.Saldo_Cuenta('126500-090000',@Mes,@Año) 
	
select @Var22310 = dbo.Saldo_Cuenta('223100-000000',@Mes,@Año)
select @Var22320 = dbo.Saldo_Cuenta('223200-000000',@Mes,@Año)


select @Var11610Ant =dbo.Saldo_Cuenta('116100-000000',@Mes,@Año-1)
select @Var11620Ant =dbo.Saldo_Cuenta('116200-000000',@Mes,@Año-1)
select @Var11621Ant =dbo.Saldo_Cuenta('116210-000000',@Mes,@Año-1)
select @Var11622Ant=dbo.Saldo_Cuenta('116220-000000',@Mes,@Año-1)
select @Var11623Ant = dbo.Saldo_Cuenta('116230-000000',@Mes,@Año-1)
select @Var11624Ant=dbo.Saldo_Cuenta('116240-000000',@Mes,@Año-1)
select @Var11625Ant = dbo.Saldo_Cuenta('116250-000000',@Mes,@Año-1)
select @Var12810Ant = dbo.Saldo_Cuenta('128100-000000',@Mes,@Año-1)
select @Var12820Ant=dbo.Saldo_Cuenta('128200-000000',@Mes,@Año-1)
select @Var12830Ant=dbo.Saldo_Cuenta('128300-000000',@Mes,@Año-1)
select @Var12840Ant = dbo.Saldo_Cuenta('128400-000000',@Mes,@Año-1)
select @Var12890Ant = dbo.Saldo_Cuenta('128900-000000',@Mes,@Año-1)
select @Var12600_00000Ant = dbo.Saldo_Cuenta('126000-000000',@Mes,@Año-1)
select @Var12610_00000Ant = dbo.Saldo_Cuenta('126100-000000',@Mes,@Año-1)

select @Var12610_01000Ant = dbo.Saldo_Cuenta('126100-010000',@Mes,@Año-1)
select @Var12610_02000Ant = dbo.Saldo_Cuenta('126100-020000',@Mes,@Año-1)
select @Var12610_03000Ant = dbo.Saldo_Cuenta('126100-030000',@Mes,@Año-1)
select @Var12610_04000Ant = dbo.Saldo_Cuenta('126100-040000',@Mes,@Año-1)

select @Var12620_00000Ant = dbo.Saldo_Cuenta('126200-000000',@Mes,@Año-1)
select @Var12630Ant = dbo.Saldo_Cuenta('126300-000000',@Mes,@Año-1)

select @Var12630_01000Ant  = dbo.Saldo_Cuenta('126300-010000',@Mes,@Año-1)
select @Var12630_02000Ant  = dbo.Saldo_Cuenta('126300-020000',@Mes,@Año-1)
select @Var12630_03000Ant  = dbo.Saldo_Cuenta('126300-030000',@Mes,@Año-1)
select @Var12630_04000Ant  = dbo.Saldo_Cuenta('126300-040000',@Mes,@Año-1)
select @Var12630_05000Ant  = dbo.Saldo_Cuenta('126300-050000',@Mes,@Año-1)
select @Var12630_06000Ant  = dbo.Saldo_Cuenta('126300-060000',@Mes,@Año-1)
select @Var12630_07000Ant  = dbo.Saldo_Cuenta('126300-070000',@Mes,@Año-1)
select @Var12630_08000Ant  = dbo.Saldo_Cuenta('126300-080000',@Mes,@Año-1)
select @Var12630_09000Ant  = dbo.Saldo_Cuenta('126300-090000',@Mes,@Año-1)
select @Var12630_10000Ant  = dbo.Saldo_Cuenta('126300-100000',@Mes,@Año-1)
select @Var12630_11000Ant  = dbo.Saldo_Cuenta('126300-110000',@Mes,@Año-1)
select @Var12630_12000Ant  = dbo.Saldo_Cuenta('126300-120000',@Mes,@Año-1)
select @Var12630_13000Ant  = dbo.Saldo_Cuenta('126300-130000',@Mes,@Año-1)
select @Var12630_14000Ant  = dbo.Saldo_Cuenta('126300-140000',@Mes,@Año-1)
select @Var12630_15000Ant  = dbo.Saldo_Cuenta('126300-150000',@Mes,@Año-1)
select @Var12630_16000Ant  = dbo.Saldo_Cuenta('126300-160000',@Mes,@Año-1)
select @Var12630_17000Ant  = dbo.Saldo_Cuenta('126300-170000',@Mes,@Año-1)
select @Var12630_18000Ant  = dbo.Saldo_Cuenta('126300-180000',@Mes,@Año-1)
select @Var12630_19000Ant  = dbo.Saldo_Cuenta('126300-190000',@Mes,@Año-1)
select @Var12630_20000Ant  = dbo.Saldo_Cuenta('126300-200000',@Mes,@Año-1)
select @Var12630_21000Ant  = dbo.Saldo_Cuenta('126300-210000',@Mes,@Año-1)
select @Var12630_22000Ant  = dbo.Saldo_Cuenta('126300-220000',@Mes,@Año-1)
select @Var12630_23000Ant  = dbo.Saldo_Cuenta('126300-230000',@Mes,@Año-1)
select @Var12630_24000Ant  = dbo.Saldo_Cuenta('126300-240000',@Mes,@Año-1)
select @Var12630_25000Ant  = dbo.Saldo_Cuenta('126300-250000',@Mes,@Año-1)

select @Var12640_00000Ant = dbo.Saldo_Cuenta('126400-000000',@Mes,@Año-1) 

select @Var12640_01000Ant = dbo.Saldo_Cuenta('126400-010000',@Mes,@Año-1) 
select @Var12640_02000Ant = dbo.Saldo_Cuenta('126400-020000',@Mes,@Año-1) 
select @Var12640_03000Ant = dbo.Saldo_Cuenta('126400-030000',@Mes,@Año-1) 
select @Var12640_04000Ant = dbo.Saldo_Cuenta('126400-040000',@Mes,@Año-1) 
select @Var12640_05000Ant = dbo.Saldo_Cuenta('126400-050000',@Mes,@Año-1) 
select @Var12640_06000Ant = dbo.Saldo_Cuenta('126400-060000',@Mes,@Año-1) 
select @Var12640_07000Ant = dbo.Saldo_Cuenta('126400-070000',@Mes,@Año-1) 
select @Var12640_08000Ant = dbo.Saldo_Cuenta('126400-080000',@Mes,@Año-1) 
select @Var12640_09000Ant = dbo.Saldo_Cuenta('126400-090000',@Mes,@Año-1) 

select @Var12650Ant = dbo.Saldo_Cuenta('126500-000000',@Mes,@Año-1)

select @Var12650_01000Ant = dbo.Saldo_Cuenta('126500-010000',@Mes,@Año-1) 
select @Var12650_02000Ant = dbo.Saldo_Cuenta('126500-020000',@Mes,@Año-1) 
select @Var12650_03000Ant = dbo.Saldo_Cuenta('126500-030000',@Mes,@Año-1) 
select @Var12650_04000Ant = dbo.Saldo_Cuenta('126500-040000',@Mes,@Año-1) 
select @Var12650_05000Ant = dbo.Saldo_Cuenta('126500-050000',@Mes,@Año-1) 
select @Var12650_06000Ant = dbo.Saldo_Cuenta('126500-060000',@Mes,@Año-1) 
select @Var12650_07000Ant = dbo.Saldo_Cuenta('126500-070000',@Mes,@Año-1) 
select @Var12650_08000Ant = dbo.Saldo_Cuenta('126500-080000',@Mes,@Año-1) 
select @Var12650_09000Ant = dbo.Saldo_Cuenta('126500-090000',@Mes,@Año-1) 
	
select @Var22310Ant = dbo.Saldo_Cuenta('223100-000000',@Mes,@Año-1)
select @Var22320Ant = dbo.Saldo_Cuenta('223200-000000',@Mes,@Año-1)



UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor= SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt= SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5 where MaskNumeroCuenta='321000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='320000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='300000'
--INICIAN UPDATES PARA LAS CUENTAS A MODIFICAR
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='112200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='112000-000000' --Misma afectacion a Cuenta padre

--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='112200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11620 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11620Ant  where NumeroCuenta='114000-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11621 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11621Ant  where NumeroCuenta='114100-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11622 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11622Ant  where NumeroCuenta='114200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11623 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11623Ant  where NumeroCuenta='114300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11624 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11624Ant  where NumeroCuenta='114400-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11625 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11625Ant  where NumeroCuenta='114500-000000' 

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12810 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12810Ant  where NumeroCuenta='122100-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12820 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12820Ant  where NumeroCuenta='122200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12830 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12830Ant  where NumeroCuenta='122300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12840 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12840Ant  where NumeroCuenta='122400-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12890 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12890Ant  where NumeroCuenta='122900-000000' 

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_01000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_01000Ant  where NumeroCuenta='123100-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_02000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_02000Ant  where NumeroCuenta='123200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_03000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_03000Ant  where NumeroCuenta='123300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12620_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12620_00000Ant  where NumeroCuenta='123400-000000' 

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_04000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_04000Ant  where NumeroCuenta='123900-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12610_01000+@Var12610_02000+@Var12610_03000+@Var12620_00000+@Var12610_04000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12610_01000Ant+@Var12610_02000Ant+@Var12610_03000Ant+@Var12620_00000Ant+@Var12610_04000Ant)  where NumeroCuenta='123000-000000'--mimos movimientos a su cuenta padre

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630Ant)  where NumeroCuenta='124000-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_01000+@Var12630_02000+@Var12630_03000+@Var12630_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_01000Ant+@Var12630_02000Ant+@Var12630_03000Ant+@Var12630_04000Ant)  where NumeroCuenta='124100-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_05000+@Var12630_06000+@Var12630_07000+@Var12630_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_05000Ant+@Var12630_06000Ant+@Var12630_07000Ant+@Var12630_08000Ant)  where NumeroCuenta='124200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_09000+@Var12630_10000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_09000Ant+@Var12630_10000Ant)  where NumeroCuenta='124300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_11000+@Var12630_12000+@Var12630_13000+@Var12630_14000+@Var12630_15000+@Var12630_16000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_11000Ant+@Var12630_12000Ant+@Var12630_13000Ant+@Var12630_14000Ant+@Var12630_15000Ant+@Var12630_16000Ant)  where NumeroCuenta='124400-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630_17000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630_17000Ant  where NumeroCuenta='124500-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_18000+@Var12630_19000+@Var12630_20000+@Var12630_21000+@Var12630_22000+@Var12630_23000+@Var12630_24000+@Var12630_25000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_18000Ant+@Var12630_19000Ant+@Var12630_20000Ant+@Var12630_21000Ant+@Var12630_22000Ant+@Var12630_23000Ant+@Var12630_24000Ant+@Var12630_25000Ant)  where NumeroCuenta='124600-000000' 
--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630Ant  where NumeroCuenta='124700-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12640_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12640_00000Ant  where NumeroCuenta='124800-000000' 

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650Ant  where NumeroCuenta='125000-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_01000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_01000Ant  where NumeroCuenta='125100-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_02000+@Var12650_03000+@Var12650_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_02000Ant+@Var12650_03000Ant+@Var12650_04000Ant)  where NumeroCuenta='125200-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_05000+@Var12650_06000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_05000Ant+@Var12650_06000Ant)  where NumeroCuenta='125300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_07000+@Var12650_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_07000Ant+@Var12650_08000Ant)  where NumeroCuenta='125400-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_09000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_09000  where NumeroCuenta='125900-000000' 

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22310 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22310Ant  where NumeroCuenta='223300-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22320 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22320Ant  where NumeroCuenta='223400-000000' 

delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____0_' and masknumerocuenta not like '____00'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____1_' and masknumerocuenta not like '____10'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____2_' and masknumerocuenta not like '____20'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____3_' and masknumerocuenta not like '____30'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____4_' and masknumerocuenta not like '____40'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____5_' and masknumerocuenta not like '____50'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____6_' and masknumerocuenta not like '____60'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____7_' and masknumerocuenta not like '____70'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____8_' and masknumerocuenta not like '____80'
delete from @Tmp_BalanzaDeComprobacion where masknumerocuenta like '____9_' and masknumerocuenta not like '____90'


SELECT     
ISNULL(SUM(SaldoDeudor),0) AS SaldoDeudor, 
ISNULL(SUM(SaldoAcreedor),0) AS SaldoAcreedor, 
ISNULL(SUM(SaldoDeudorAnt),0) AS SaldoDeudorAnt, 
ISNULL(SUM(SaldoAcreedorAnt),0) AS SaldoAcreedorAnt
FROM          @Tmp_BalanzaDeComprobacion


--FIN DE PROCEDIMIENTO

END

--//////////FIN REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles


GO


