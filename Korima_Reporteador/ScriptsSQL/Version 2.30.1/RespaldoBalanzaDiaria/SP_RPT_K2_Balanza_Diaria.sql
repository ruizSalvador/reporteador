 
/******** Object:  StoredProcedure [dbo].[SP_RPT_K2_Balanza_Diaria]    Script Date: 07/03/2013 13:50:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Balanza_Diaria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Balanza_Diaria]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Balanza_Diaria]    Script Date: 07/03/2013 13:50:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 --EXEC SP_RPT_K2_Balanza_Diaria '2019-06-06'
 --EXEC SP_RPT_K2_Balanza_Diaria '2019-06-12'
 CREATE PROCEDURE [dbo].[SP_RPT_K2_Balanza_Diaria] 
@DayDate date

AS
BEGIN 
 --Declare @Date datetime = @DayDate
 Declare @SaldosIniciales as Table (IdCuentaContable int, NumeroCuenta varchar(100), CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal (18,2))
 Declare @SaldosAdicionales as Table (IdCuentaContable int, NumeroCuenta varchar(100), CargosSinFlujo decimal(18,2), AbonosSinFlujo decimal (18,2))
 Declare @SaldosDia as Table (IdCuentaContable int, TotalCargos decimal(18,2), TotalAbonos decimal (18,2))
 Declare @Ejercicio int = YEAR(@DayDate)

 Declare @BalAcum as table (
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

Declare @mesSP int
Declare @DateIni date =  (SELECT DATEADD(m, DATEDIFF(m,0,@DayDate),0))
Set @mesSP = (Select MONTH(DATEADD(month,-1,@DayDate)))  

INSERT INTO @BalAcum
EXEC SP_RPT_K2_BalanzaAcumulada 1,@mesSP,@Ejercicio,0,0,0,0,0,0,'','',0,0

 Insert into @SaldosDia
Select 
IdCuentaContable, 
ISNULL(SUM(ImporteCargo),0), ISNULL(SUM(ImporteAbono),0) from T_Polizas
Inner Join D_Polizas on T_Polizas.IdPoliza = D_Polizas.IdPoliza
where Fecha= @DayDate and Year(Fecha) = @Ejercicio and NoPoliza <> 0
Group by D_Polizas.IdCuentaContable
Order by IdCuentaContable

IF ((Select DAY(@DayDate)) <> 1)
BEGIN
		Insert Into @SaldosAdicionales
		Select 
		IdCuentaContable, '',
		ISNULL(SUM(ImporteCargo),0), ISNULL(SUM(ImporteAbono),0) from T_Polizas
		Inner Join D_Polizas on T_Polizas.IdPoliza = D_Polizas.IdPoliza
		Where (Fecha >= @DateIni and  Fecha <= DATEADD(day,-1,@DayDate)) and NoPoliza <> 0
		and Year(Fecha) = @Ejercicio
		Group by D_Polizas.IdCuentaContable
		Order by IdCuentaContable
END

  UPDATE SA  
  SET SA.NumeroCuenta = C.NumeroCuenta
  FROM @SaldosAdicionales SA 
  JOIN C_Contable C
  ON SA.IdCuentaContable = C.[IdCuentaContable]
  --(SELECT NumeroCuenta FROM C_Contable WHERE IdCuentaContable = [IdCuentaContable])

IF ((Select DAY(@DayDate)) <> 1)
BEGIN
	Insert into @SaldosIniciales
	Select 
	IdCuentaContable, B.NumeroCuenta,
	ISNULL(B.SaldoDeudor,0) - ISNULL(SA.AbonosSinFlujo,0), 
	ISNULL(B.SaldoAcreedor,0) + ISNULL(SA.CargosSinFlujo,0)
	from @BalAcum B LEFT JOIN 
	@SaldosAdicionales SA ON B.NumeroCuenta = SA.NumeroCuenta
END
ELSE
BEGIN
Insert into @SaldosIniciales
	Select 
	0, B.NumeroCuenta,
	ISNULL(B.SaldoDeudor,0), 
	ISNULL(B.SaldoAcreedor,0)
	from @BalAcum B 
END

 UPDATE SI 
  SET SI.IdCuentaContable = C.IdCuentaContable
  FROM @SaldosIniciales SI 
  JOIN C_Contable C
  ON SI.NumeroCuenta = C.[NumeroCuenta]

  Select * from @BalAcum
--Select * from @SaldosDia order by IdCuentaContable
--Select * from @SaldosAdicionales order by IdCuentaContable
--Select * from @SaldosIniciales order by IdCuentaContable

--Select DATEADD(day,-1,GETDATE())


--Select * from C_Contable where idcuentacontable = 1724
TRUNCATE TABLE T_SaldosInicialesContDay

INSERT INTO T_SaldosInicialesContDay (IdCuentaContable, CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos)
Select S2.IdCuentaContable, ISNULL(S2.CargosSinFlujo,0) as CargosSinFlujo, ISNULL(S2.AbonosSinFlujo,0) as AbonosSinFlujo, ISNULL(TotalCargos,0) as TotalCargos, ISNULL(TotalAbonos,0) as TotalAbonos
from @SaldosIniciales S2 LEFT JOIN
 @SaldosDia S1 ON S1.IdCuentaContable = S2.IdCuentaContable
order by IdCuentaContable

INSERT INTO T_SaldosInicialesContDay (IdCuentaContable, TotalCargos, TotalAbonos, CargosSinFlujo, AbonosSinFlujo)
SELECT IdCuentaContable, TotalCargos, TotalAbonos,0,0 FROM  @SaldosDia 
   WHERE IdCuentaContable NOT IN (SELECT IdCuentaContable FROM T_SaldosInicialesContDay)

INSERT INTO T_SaldosInicialesContDay (IdCuentaContable)
SELECT IdCuentaContable FROM  C_Contable 
   WHERE IdCuentaContable NOT IN (SELECT IdCuentaContable FROM T_SaldosInicialesContDay)


   --(Select distinct IdCuentaContable from T_SaldosInicialesCont where IdCuentaContable not in (Select distinct IdCuentaContable from T_SaldosInicialesContDay))
   --Select * from T_SaldosInicialesContDay order by IdCuentaContable
  --Select distinct IdCuentaContable from T_SaldosInicialesCont order by IdCuentaContable where IdCuentaContable not in (Select distinct IdCuentaContable from T_SaldosInicialesContDay)
     --Select * from C_Contable order by NumeroCuenta
--Select * from VW_RPT_K2_Balanza_De_Comprobacion
END
GO

--Select * from T_SaldosInicialesCont order by IdCuentaContable 

Select * from C_Contable where NumeroCuenta in 
('10000-00000','11000-00000','11100-00000','11120-00000','11120-09000','11120-09001','11200-00000','11230-00000','11230-00001')

   Mes = 6 And [Year] = 2019 AND (TotalCargos <> 0 OR TotalAbonos <> 0)

   SELECT * FROM VW_RPT_K2_Balanza_De_Comprobacion Where Mes = 6 And [Year] = 2019 AND (TotalCargos <> 0 OR TotalAbonos <> 0) Order by NumeroCuenta
   Select * from VW_RPT_K2_Balanza_De_Comprobacion Where