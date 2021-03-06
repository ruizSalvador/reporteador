
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayorCvePres]    Script Date: 08/08/2014 18:44:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- Batch submitted through debugger: SP_RPT_K2_AuxiliarMayor_LibroMayor.sql|134|0|C:\Users\Samsung\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\OQ0C9842\SP_RPT_K2_AuxiliarMayor_LibroMayor.sql
alter PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayorCvePres] 
@NumeroCuenta varchar(30),
@CuentaAcumulable varchar(30),
@Ejercicio smallint,
@MesInicio smallint,
@MesFin smallint,
@MuestraVacios bit,
@CuentaInicio varchar(30),
@CuentaFin varchar(30),
@CvePres int
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
      ,NombreCuentaContable varchar (max)
      ,Nivel smallint
      ,Concepto varchar (max)
      ,IdDPoliza int
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,CuentaAcumulacion varchar(max)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,TipoCuenta varchar(1)
      ,Numero int
      ,FolioCheque int 
      ,ConceptoPago  varchar(max)
      ,iNumeroCuenta bigint
      ,CvePresupuestal varchar(Max)
      ,IdCvePres int
 )
  Declare @tabla2 as table (
		Fecha datetime
      ,Folio varchar(11)
      ,NoAsiento bigint
      ,Referencia varchar (20)
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (max)
      ,Nivel smallint
      ,Concepto varchar (max)
      ,IdDPoliza int
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,CuentaAcumulacion varchar(max)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,TipoCuenta varchar(1)
      ,Numero int
      ,FolioCheque int 
      ,ConceptoPago  varchar(max)
      ,iNumeroCuenta bigint
      ,NumeroxCuenta int
      ,CvePresupuestal varchar(Max)
      ,IdCvePres int
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
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, sellos.sello, sellos.IdSelloPresupuestal 
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
--AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)
LEFT JOIN 
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque left outer join T_SellosPresupuestales Sellos
on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
 where TipoCuenta <> 'X'
 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
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
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, Sellos.Sello, sellos.IdSelloPresupuestal 
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
--AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)
LEFT JOIN 
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque 
left outer join T_SellosPresupuestales sellos on d_polizas.IdSelloPresupuestal = sellos.idselloPresupuestal
 where TipoCuenta <> 'X'
 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
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
      ,NombreCuentaContable varchar (max)
      ,Nivel smallint
      ,Concepto varchar (max)
      ,IdDPoliza int
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,CuentaAcumulacion varchar(max)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,TipoCuenta varchar(max)
      ,Numero int
      ,FolioCheque int 
      ,ConceptoPago  varchar(max)
      ,iNumeroCuenta bigint
      ,CvePresupuestal varchar(Max)
      ,IdCvePres int)

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
      convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, ''CvePresupuestal, 0
      from T_SaldosInicialesCont  
JOIN C_Contable ON
C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
where T_SaldosInicialesCont.TotalAbonos =0 
AND T_SaldosInicialesCont.TotalCargos=0
and Nivel>=0
Insert into @Tabla
select * from @tablaVacios where SaldoInicial<>0 
AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
AND Mes >= @MesInicio
AND Mes <= @MesFin 
And year = @Ejercicio
END
if @CuentaInicio =''
insert @tabla2 
  Select 
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
      ,Numero 
      ,FolioCheque 
      ,ConceptoPago  
      ,iNumeroCuenta 
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,Mes) as NumeroxCuenta, isnull(CvePresupuestal, '')CvePresupuestal, ISNULL(IdCvePres,0)IdCvePres
   from @tabla where  (Mes between @MesInicio AND  @MesFin) And year = @Ejercicio AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable) 
   and isnull(IdCvePres,0) = case when @CvePres = 0 then isnull(IdCvePres,0) else @CvePres end  order by NumeroCuentaContable,Numero--Fecha
  else
  insert into @tabla2
  Select  
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
      ,Numero 
      ,FolioCheque 
      ,ConceptoPago  
      ,iNumeroCuenta 
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,Mes) as NumeroxCuenta, isnull(CvePresupuestal,'')CvePresupuestal, ISNULL(IdCvePres,0)idCvePres 
  from @tabla where (iNumeroCuenta between @iCuentaInicio and @iCuentaFin) AND (Mes between @MesInicio
		AND @MesFin)  And year = @Ejercicio and isnull(IdCvePres,0) = case when @CvePres = 0 then isnull(IdCvePres,0) else @CvePres end order by NumeroCuentaContable,Numero
END
--update @tabla2 set SaldoFila= SaldoFila+SaldoInicial where NumeroxCuenta=1 and ((ImporteAbono<>null or ImporteCargo<>null) or (ImporteAbono<>0 or ImporteCargo<>0))
DELETE FROM @tabla2 Where NumeroxCuenta>1 and ((ImporteAbono is null And ImporteCargo is null) or (ImporteAbono=0 And ImporteCargo=0)) and saldoFila =SaldoFila and SaldoInicial=SaldoInicial and Mes > @MesInicio 
select * from @tabla2 


