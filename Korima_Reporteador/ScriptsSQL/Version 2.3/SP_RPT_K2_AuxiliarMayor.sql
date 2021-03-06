/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]    Script Date: 07/04/2013 10:11:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AuxiliarMayor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]    Script Date: 07/04/2013 10:11:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Batch submitted through debugger: SP_RPT_K2_AuxiliarMayor_LibroMayor.sql|134|0|C:\Users\Samsung\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\OQ0C9842\SP_RPT_K2_AuxiliarMayor_LibroMayor.sql
CREATE PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor] 
@NumeroCuenta varchar(30),
@CuentaAcumulable varchar(30),
@Ejercicio smallint,
@MesInicio smallint,
@MesFin smallint,
@MuestraVacios bit,
@CuentaInicio varchar(30),
@CuentaFin varchar(30)
AS
BEGIN 
Declare @iCuentaInicio bigint
Declare @iCuentaFin bigint
set @iCuentaInicio= CONVERT(bigint,REPLACE(@CuentaInicio,'-',''))
set @iCuentaFin= CONVERT(bigint,REPLACE(@CuentaFin,'-',''))
 
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
      ,iNumeroCuenta bigint
 )
 IF @CuentaInicio ='' Begin
 insert into @tabla 	
		SELECT
T_Polizas.Fecha,
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,
ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,
D_Polizas.Referencia,
C_Contable.NumeroCuenta AS NumeroCuentaContable,
C_Contable.NombreCuenta AS NombreCuentaContable,
C_Contable.Nivel,
T_Polizas.Concepto,
D_Polizas.IdDPoliza,
D_Polizas.ImporteCargo,
D_Polizas.ImporteAbono,
	Case C_Contable .TipoCuenta    
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)
	End as SaldoFila,
c_contable.CuentaAcumulacion,
 Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoInicial,
      T_SaldosInicialesCont.Mes,
T_SaldosInicialesCont.year,
C_Contable.TipoCuenta,
ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,
T_Cheques.FolioCheque,
T_Cheques.ConceptoPago,
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)
LEFT JOIN 
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque 
 where TipoCuenta <> 'X'
 AND T_Polizas.NoPoliza>0 and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
   and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
		AND Mes >= @MesInicio
		AND Mes <= @MesFin 
		AND [year] = @Ejercicio 
		AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
		ORDER BY NumeroCuentaContable, Fecha
		 End
else
begin

 insert into @tabla 
		
SELECT
T_Polizas.Fecha,
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,
ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,
D_Polizas.Referencia,
C_Contable.NumeroCuenta AS NumeroCuentaContable,
C_Contable.NombreCuenta AS NombreCuentaContable,
C_Contable.Nivel,
T_Polizas.Concepto,
D_Polizas.IdDPoliza,
D_Polizas.ImporteCargo,
D_Polizas.ImporteAbono,
	Case C_Contable .TipoCuenta    
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)
      Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)
	End as SaldoFila,
c_contable.CuentaAcumulacion,
 Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoInicial,
      T_SaldosInicialesCont.Mes,
T_SaldosInicialesCont.year,
C_Contable.TipoCuenta,
ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,
T_Cheques.FolioCheque,
T_Cheques.ConceptoPago,
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)
LEFT JOIN 
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque 
 where TipoCuenta <> 'X'
 AND T_Polizas.NoPoliza>0 and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
   and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
		AND Mes >= @MesInicio
		AND Mes <= @MesFin 
		AND [year] = @Ejercicio 
		ORDER BY NumeroCuentaContable, Fecha
end
 
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
 
 IF @MuestraVacios=1
	 BEGIN
Declare @tablaVacios as table (
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
      ,iNumeroCuenta bigint)

insert into @tablaVacios 
select 
null as fecha,
null as Folio,
null as NoAsiento,
null as Referencia,
C_Contable.NumeroCuenta as NumeroCuentaContable,
C_Contable.NombreCuenta as NombreCuentaContable,
C_Contable.Nivel as Nivel,
null as Concepto,
null as IdDPoliza,
null as ImporteCargo,
null as ImporteAbono,
Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoFila,
      C_Contable.CuentaAcumulacion,
Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoInicial,
      T_SaldosInicialesCont.Mes,
      T_SaldosInicialesCont.Year,
      C_Contable.TipoCuenta, 
      Null as Numero,
      Null as FolioCheque,
      null as ConceptoPago,
      convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
      from T_SaldosInicialesCont  
JOIN C_Contable ON
C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
where T_SaldosInicialesCont.TotalAbonos =0 
AND T_SaldosInicialesCont.TotalCargos=0
and Nivel>=0
Insert into @Tabla
select * from @tablaVacios where SaldoInicial<>0 
AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
and Mes= @MesInicio
And year = @Ejercicio
END
if @CuentaInicio =''
  Select * from @tabla order by NumeroCuentaContable,Numero--Fecha
  else
  Select * from @tabla where iNumeroCuenta between @iCuentaInicio and @iCuentaFin order by NumeroCuentaContable,Numero
END


GO