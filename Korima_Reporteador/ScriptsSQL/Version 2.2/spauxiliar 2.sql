USE [FOJAL]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]    Script Date: 05/23/2013 09:18:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor] 
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
      ,IdPoliza int
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
  SELECT Distinct
		Fecha
      ,Folio
      ,ROW_NUMBER() over(order by IdPoliza) as NoAsiento
      ,Referencia
      ,NumeroCuentaContable
      ,NombreCuentaContable
      ,Nivel
      ,Concepto
      ,IdPoliza
      ,ImporteCargo
      ,ImporteAbono
      ,SaldoFila
      ,CuentaAcumulacion
      ,SaldoInicial
      ,Mes
      ,year
      ,TipoCuenta 
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha) as Numero
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
  SELECT distinct 
 [Fecha]
      ,[Folio]
      ,ROW_NUMBER() over(order by IdPoliza) as [NoAsiento]
      ,[Referencia]
      ,[NumeroCuentaContable]
      ,[NombreCuentaContable]
      ,[Nivel]
      ,[Concepto]
      ,[IdPoliza]
      ,[ImporteCargo]
      ,[ImporteAbono]
      ,[SaldoFila]
      ,[CuentaAcumulacion]
      ,[SaldoInicial]
      ,[Mes]
      ,[year]
      ,TipoCuenta 
	  ,ROW_NUMBER() over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha ) as Numero
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
 Select distinct * from @tabla order by NumeroCuentaContable,Numero--Fecha
END

GO


