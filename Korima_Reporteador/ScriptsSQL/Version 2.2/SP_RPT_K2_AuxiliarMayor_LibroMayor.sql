/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]    Script Date: 12/07/2012 16:17:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AuxiliarMayor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_LibroMayor]    Script Date: 12/07/2012 16:17:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_LibroMayor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_LibroMayor]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_LibroMayor]    Script Date: 12/07/2012 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RPT_K2_LibroMayor] 
@NumeroCuenta varchar(30),
@CuentaAcumulable varchar(30),
@Ejercicio smallint,
@MesInicio smallint,
@MesFin smallint,
@MuestraVacios bit
AS
BEGIN 
 Declare @tabla as table (
		Fecha datetime
      ,Folio varchar(11)
      ,NoAsiento bigint
      ,Referencia varchar (20)
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,Nivel smallint
      ,Concepto varchar (120)
      ,IdDPoliza int
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,CuentaAcumulacion varchar(30)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,TipoCuenta varchar(1)
      ,Numero int
 )
 IF @MuestraVacios=1 Begin
 insert into @tabla 
  SELECT 
		Fecha
      ,Folio
      ,NoAsiento
      ,Referencia
      ,NumeroCuentaContable
      ,NombreCuentaContable
      ,Nivel
      ,Concepto
      ,IdDPoliza
      ,ImporteCargo
      ,ImporteAbono
      ,SaldoFila
      ,CuentaAcumulacion
      ,SaldoInicial
      ,Mes
      ,year
      ,TipoCuenta 
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha) as Numero
      FROM VW_RPT_K2_LibroMayor 
      where 
		month(fecha)>= @Mesinicio 
		and month(fecha)<= @MesFin
		and YEAR(fecha)= @Ejercicio
		AND 
		Mes >= @MesInicio
		AND Mes <= @MesFin 
		AND [year] = @Ejercicio 
		AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
		ORDER BY NumeroCuentaContable, Fecha	
 END
 IF @MuestraVacios=0 Begin
 insert into @tabla 
  SELECT 
 [Fecha]
      ,[Folio]
      ,[NoAsiento]
      ,[Referencia]
      ,[NumeroCuentaContable]
      ,[NombreCuentaContable]
      ,[Nivel]
      ,[Concepto]
      ,[IdDPoliza]
      ,[ImporteCargo]
      ,[ImporteAbono]
      ,[SaldoFila]
      ,[CuentaAcumulacion]
      ,[SaldoInicial]
      ,[Mes]
      ,[year]
      ,TipoCuenta 
      ,ROW_NUMBER() over (partition by NumeroCuentaContable order by NumeroCuentaContable, Fecha) as Numero
      FROM VW_RPT_K2_LibroMayor where 
 month(fecha)>= @Mesinicio 
 and month(fecha)<= @MesFin
 and YEAR(fecha)= @Ejercicio
 AND Mes >= @MesInicio
  AND Mes <= @MesFin 
  AND [Year] = @Ejercicio 
  AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
 AND (ImporteCargo<>0 or ImporteAbono<>0)
 ORDER BY NumeroCuentaContable, Fecha
 END
 
 Update @tabla set SaldoFila = ImporteCargo-importeabono where Numero>1 --and SaldoInicial=SaldoInicial 
 and(
	 TipoCuenta='A' OR
	 TipoCuenta='C' OR
	 TipoCuenta='E' OR
	 TipoCuenta='G' OR
	 TipoCuenta='I' 
 )
  Update @tabla set SaldoFila = ImporteAbono-importecargo where Numero>1 --and SaldoInicial=SaldoInicial 
 and(
	 TipoCuenta<>'A' AND
	 TipoCuenta<>'C' AND
	 TipoCuenta<>'E' AND
	 TipoCuenta<>'G' AND
	 TipoCuenta<>'I' 
 )
 --GO
 Select * from @tabla order by NumeroCuentaContable,Numero
 END
  
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]    Script Date: 12/07/2012 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor] 
@NumeroCuenta varchar(30),
@CuentaAcumulable varchar(30),
@Ejercicio smallint,
@MesInicio smallint,
@MesFin smallint,
@MuestraVacios bit
AS
BEGIN 
 Declare @tabla as table (
		Fecha datetime
      ,Folio varchar(11)
      ,NoAsiento bigint
      ,Referencia varchar (20)
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,Nivel smallint
      ,Concepto varchar (120)
      ,IdDPoliza int
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,CuentaAcumulacion varchar(30)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,TipoCuenta varchar(1)
      ,Numero int
      ,FolioCheque int 
      ,ConceptoPago  varchar(120)
 )
 IF @MuestraVacios=1 Begin
 insert into @tabla 
  SELECT 
		Fecha
      ,Folio
      ,NoAsiento
      ,Referencia
      ,NumeroCuentaContable
      ,NombreCuentaContable
      ,Nivel
      ,Concepto
      ,IdDPoliza
      ,ImporteCargo
      ,ImporteAbono
      ,SaldoFila
      ,CuentaAcumulacion
      ,SaldoInicial
      ,Mes
      ,year
      ,TipoCuenta 
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,IdDPoliza) as Numero
      ,FolioCheque
      ,ConceptoPago
      FROM VW_RPT_K2_AuxiliarDeMayor 
      where 
		month(fecha)>= @Mesinicio 
		and month(fecha)<= @MesFin
		and YEAR(fecha)= @Ejercicio
		AND 
		Mes >= @MesInicio
		AND Mes <= @MesFin 
		AND [year] = @Ejercicio 
		AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
		ORDER BY NumeroCuentaContable, Fecha	
 END
 IF @MuestraVacios=0 Begin
 insert into @tabla 
  SELECT 
 [Fecha]
      ,[Folio]
      ,[NoAsiento]
      ,[Referencia]
      ,[NumeroCuentaContable]
      ,[NombreCuentaContable]
      ,[Nivel]
      ,[Concepto]
      ,[IdDPoliza]
      ,[ImporteCargo]
      ,[ImporteAbono]
      ,[SaldoFila]
      ,[CuentaAcumulacion]
      ,[SaldoInicial]
      ,[Mes]
      ,[year]
      ,TipoCuenta 
	  ,ROW_NUMBER() over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,IdDPoliza ) as Numero
      ,FolioCheque
      ,ConceptoPago
      FROM VW_RPT_K2_AuxiliarDeMayor where 
 month(fecha)>= @Mesinicio 
 and month(fecha)<= @MesFin
 and YEAR(fecha)= @Ejercicio
 AND Mes >= @MesInicio
  AND Mes <= @MesFin 
  AND [Year] = @Ejercicio 
  AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
 AND (ImporteCargo<>0 or ImporteAbono<>0)
 ORDER BY NumeroCuentaContable, Fecha
 END
 
 Update @tabla set SaldoFila = ImporteCargo-importeabono where Numero>1 --and SaldoInicial=SaldoInicial 
 and(
	 TipoCuenta='A' OR
	 TipoCuenta='C' OR
	 TipoCuenta='E' OR
	 TipoCuenta='G' OR
	 TipoCuenta='I' 
 )
  Update @tabla set SaldoFila = ImporteAbono-importecargo where Numero>1 --and SaldoInicial=SaldoInicial 
 and(
	 TipoCuenta<>'A' AND
	 TipoCuenta<>'C' AND
	 TipoCuenta<>'E' AND
	 TipoCuenta<>'G' AND
	 TipoCuenta<>'I' 
 )
 --GO
 Select * from @tabla order by NumeroCuentaContable,Numero--Fecha
END
GO
