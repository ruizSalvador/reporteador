/*  
======================================================================================================  
Autor:  Anónimo
=======================================================================================================  
|Versión  |Fecha      |Responsable         |Descripción de Cambio   
-------------------------------------------------------------------------------------------------------  
| 1.0   |2011.11.30 |Anónimo    |Creación de procedimiento.  
-------------------------------------------------------------------------------------------------------  
| 1.1   |2017.09.20 |Karim Zavala  |Se modifico el order by de la consulta que muestra el resulato final.  
=======================================================================================================  
*/      
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AuxiliarMayor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayor]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

SET NOCOUNT ON
GO
--EXEC SP_RPT_K2_AuxiliarMayor '','',2019,1,1,1,'11110-00001','11110-00003',1,0

Create PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayor]     
@NumeroCuenta varchar(30),    
@CuentaAcumulable varchar(30),    
@Ejercicio smallint,    
@MesInicio smallint,    
@MesFin smallint,    
@MuestraVacios bit,    
@CuentaInicio varchar(30),    
@CuentaFin varchar(30),    
@MuestraSinSaldo bit,
@IdCuenta int    
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
	  ,SaldoFinal decimal(18,2)    
      ,Mes smallint    
      ,year smallint    
      ,TipoCuenta varchar(1)    
      ,Numero int    
      ,FolioCheque int     
      ,ConceptoPago  varchar(max)    
      ,iNumeroCuenta bigint    
   ,TipoPoliza varchar(1)    
   ,NoPoliza int
   ,Afectable int   
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
	  ,SaldoFinal decimal(18,2)    
      ,Mes smallint    
      ,year smallint    
      ,TipoCuenta varchar(1)    
      ,Numero int    
      ,FolioCheque int     
      ,ConceptoPago  varchar(max)    
      ,iNumeroCuenta bigint    
   ,TipoPoliza varchar(1)    
   ,NoPoliza int
   ,Afectable int     
      ,NumeroxCuenta int    
      ,TotalGral decimal(18,2) 
	  ,CtaSaldoInicial decimal(18,2)
	  ,CtaMayor varchar(50)
	  ,NombreCtaMayor varchar(250) 
 )    
 IF @NumeroCuenta = '' and @CuentaAcumulable <> ''
 BEGIN   
  
 INSERT into @tabla      
  SELECT    
T_Polizas.Fecha,    
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,    
ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,    
D_Polizas.Referencia,    
VW_C_Contable.NumeroCuenta AS NumeroCuentaContable,    
VW_C_Contable.NombreCuenta AS NombreCuentaContable,    
VW_C_Contable.Nivel,    
T_Polizas.Concepto,    
D_Polizas.IdDPoliza,    
D_Polizas.ImporteCargo,    
D_Polizas.ImporteAbono,    
 Case VW_C_Contable .TipoCuenta        
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)    
 End as SaldoFila,    
VW_C_Contable.CuentaAcumulacion,    
 Case VW_C_Contable .TipoCuenta      
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo     
          Else T_SaldosInicialesCont.AbonosSinFlujo     
      End as SaldoInicial,
	   Case VW_C_Contable .TipoCuenta      
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          Else AbonosSinFlujo - CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos     
      End as SaldoFinal,     
      T_SaldosInicialesCont.Mes,    
T_SaldosInicialesCont.year,    
VW_C_Contable.TipoCuenta,    
ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,    
T_Cheques.FolioCheque,    
D_Polizas.Concepto,    
iNumeroCuenta,    
T_Polizas.TipoPoliza,    
T_Polizas.NoPoliza,
Afectable   
FROM T_Polizas    
JOIN    
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND D_Polizas.IdPoliza in (Select IdPoliza from T_Polizas Where Ejercicio = @Ejercicio)
JOIN    
VW_C_Contable ON VW_C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable     
JOIN    
T_SaldosInicialesCont ON VW_C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable    
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo     
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio     
--AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)    
LEFT JOIN     
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque     
 where TipoCuenta <> 'X'    
 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')    
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)    
 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))    
  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))    
  AND Mes >= @MesInicio    
  AND Mes <= @MesFin     
  AND [year] = @Ejercicio
  AND T_Polizas.Ejercicio =  @Ejercicio    
  AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)    
  ORDER BY NumeroCuentaContable, Fecha    
   --select 'tabla1_1',* from @tabla where concepto='RECLASIFICACION DE CUENTA'--kazb  
   END    
--else    
IF @IdCuenta <> 0
BEGIN    
    
 INSERT into @tabla     
      
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
	  Case C_Contable .TipoCuenta      
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          Else AbonosSinFlujo - CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos     
      End as SaldoFinal,  
      T_SaldosInicialesCont.Mes,    
T_SaldosInicialesCont.year,    
C_Contable.TipoCuenta,    
ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,    
T_Cheques.FolioCheque,    
D_Polizas.Concepto,    
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta,    
T_Polizas.TipoPoliza,    
T_Polizas.NoPoliza,
Afectable    
FROM T_Polizas    
JOIN    
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND D_Polizas.IdPoliza in (Select IdPoliza from T_Polizas Where Ejercicio = @Ejercicio) 
JOIN    
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable     
JOIN    
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable    
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo     
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio     
--AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)    
LEFT JOIN     
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque     
 where TipoCuenta <> 'X'    
 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')    
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)    
 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))    
  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))    
  AND Mes >= @MesInicio    
  AND Mes <= @MesFin     
  AND [year] = @Ejercicio
  AND T_Polizas.Ejercicio =  @Ejercicio    
  AND D_Polizas.IdCuentaContable = @IdCuenta 
  ORDER BY NumeroCuentaContable, Fecha    
END

IF @CuentaInicio <> ''
BEGIN
 INSERT into @tabla 
	SELECT    
T_Polizas.Fecha,    
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,    
ROW_NUMBER() over(order by t_polizas.idpoliza)as NoAsiento,    
D_Polizas.Referencia,    
VW_C_Contable.NumeroCuenta AS NumeroCuentaContable,    
VW_C_Contable.NombreCuenta AS NombreCuentaContable,    
VW_C_Contable.Nivel,    
T_Polizas.Concepto,    
D_Polizas.IdDPoliza,    
D_Polizas.ImporteCargo,    
D_Polizas.ImporteAbono,    
 Case VW_C_Contable .TipoCuenta        
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo + (D_Polizas.ImporteCargo - D_Polizas.ImporteAbono)    
      Else T_SaldosInicialesCont.AbonosSinFlujo +(D_Polizas.ImporteAbono - D_Polizas.ImporteCargo)    
 End as SaldoFila,    
VW_C_Contable.CuentaAcumulacion,    
 Case VW_C_Contable .TipoCuenta      
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo     
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo     
          Else T_SaldosInicialesCont.AbonosSinFlujo     
      End as SaldoInicial,  
	  Case VW_C_Contable .TipoCuenta      
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos          
          Else AbonosSinFlujo - CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos     
      End as SaldoFinal,  
      T_SaldosInicialesCont.Mes,    
T_SaldosInicialesCont.year,    
VW_C_Contable.TipoCuenta,    
ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,    
T_Cheques.FolioCheque,    
D_Polizas.Concepto,    
VW_C_Contable.iNumeroCuenta,    
T_Polizas.TipoPoliza,    
T_Polizas.NoPoliza,
Afectable    
FROM T_Polizas    
JOIN    
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND D_Polizas.IdPoliza in (Select IdPoliza from T_Polizas Where Ejercicio = @Ejercicio)   
JOIN    
VW_C_Contable ON VW_C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable     
JOIN    
T_SaldosInicialesCont ON VW_C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable  
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo     
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio     
--AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)    
LEFT JOIN     
T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque     
 where TipoCuenta <> 'X'    
 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')    
 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)    
 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))    
  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))    
  AND Mes >= @MesInicio    
  AND Mes <= @MesFin     
  AND [year] = @Ejercicio
  AND T_Polizas.Ejercicio =  @Ejercicio 
  AND VW_C_Contable.iNumeroCuenta BETWEEN @iCuentaInicio and @iCuentaFin
  
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
 --select 'tabla1_2',* from @tabla where concepto='RECLASIFICACION DE CUENTA'--kazb  
  Update @tabla set SaldoFila = ImporteAbono-importecargo where Numero>1 --and SaldoInicial=SaldoInicial     
 and(    
  TipoCuenta<>'A' AND    
  TipoCuenta<>'C' AND    
  TipoCuenta<>'E' AND    
  TipoCuenta<>'G' AND    
  TipoCuenta<>'I'     
 )    
   --select 'tabla1_3',* from @tabla where concepto='RECLASIFICACION DE CUENTA'--kazb  
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
	  ,SaldoFinal decimal(18,2)    
      ,Mes smallint    
      ,year smallint    
      ,TipoCuenta varchar(max)    
      ,Numero int    
      ,FolioCheque int     
      ,ConceptoPago  varchar(max)    
      ,iNumeroCuenta bigint    
   ,TipoPoliza varchar(1)    
   ,NoPoliza int 
   ,Afectable int   
   )   
   
IF @CuentaInicio <> ''
	BEGIN
	--Vacios Existentes en el periodo    
Insert into @tablaVacios     
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
	  Case C_Contable .TipoCuenta      
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          Else AbonosSinFlujo - CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos     
      End as SaldoFinal,    
      T_SaldosInicialesCont.Mes,    
      T_SaldosInicialesCont.Year,    
      C_Contable.TipoCuenta,     
      Null as Numero,    
      Null as FolioCheque,    
      null as ConceptoPago,    
      convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta,    
   Null as TipoPoliza,    
   Null as NoPoliza,
   C_Contable.Afectable    
      from T_SaldosInicialesCont      
JOIN C_Contable ON    
C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable
JOIN    
VW_C_Contable ON VW_C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable      
where     
T_SaldosInicialesCont.TotalAbonos =0     
AND T_SaldosInicialesCont.TotalCargos=0 and C_Contable.Nivel>=0
AND VW_C_Contable.iNumeroCuenta BETWEEN @iCuentaInicio and @iCuentaFin 
	END
ELSE
	BEGIN
	--Vacios Existentes en el periodo    
Insert into @tablaVacios     
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
	  Case C_Contable .TipoCuenta      
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + T_SaldosInicialesCont.TotalCargos - T_SaldosInicialesCont.TotalAbonos     
          Else AbonosSinFlujo - CargosSinFlujo + T_SaldosInicialesCont.TotalAbonos - T_SaldosInicialesCont.TotalCargos     
      End as SaldoFinal,    
      T_SaldosInicialesCont.Mes,    
      T_SaldosInicialesCont.Year,    
      C_Contable.TipoCuenta,     
      Null as Numero,    
      Null as FolioCheque,    
      null as ConceptoPago,    
      convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta,    
   Null as TipoPoliza,    
   Null as NoPoliza,
   Afectable    
      from T_SaldosInicialesCont      
JOIN C_Contable ON    
C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable     
where     
T_SaldosInicialesCont.TotalAbonos =0     
AND T_SaldosInicialesCont.TotalCargos=0 and     
Nivel>=0 
	END 
    
IF @MuestraSinSaldo =1 BEGIN 
IF @CuentaInicio <> ''
	BEGIN
	--Vacios NO existentes en el periodo    
Insert @tablaVacios     
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
0 as SaldoFila,    
C_Contable.CuentaAcumulacion,    
0 as SaldoInicial,
0 as SaldoFinal,    
@MesInicio as Mes,    
@Ejercicio as Year,    
C_Contable.TipoCuenta,     
Null as Numero,    
Null as FolioCheque,    
null as ConceptoPago,    
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta,    
Null as TipoPoliza,    
Null as NoPoliza,
C_Contable.Afectable    
from C_Contable  
JOIN    
VW_C_Contable ON VW_C_Contable.IdCuentaContable= C_Contable.IdCuentaContable   
where C_Contable.Nivel>=0 
AND VW_C_Contable.iNumeroCuenta BETWEEN @iCuentaInicio and @iCuentaFin 
and C_Contable.NumeroCuenta not in (Select NumeroCuentaContable from @tablaVacios where Year =@Ejercicio and (Mes between @mesinicio and @mesFin))
	END
		ELSE
	BEGIN
	--Vacios NO existentes en el periodo    
Insert @tablaVacios     
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
0 as SaldoFila,    
C_Contable.CuentaAcumulacion,    
0 as SaldoInicial,
0 as SaldoFinal,    
@MesInicio as Mes,    
@Ejercicio as Year,    
C_Contable.TipoCuenta,     
Null as Numero,    
Null as FolioCheque,    
null as ConceptoPago,    
convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta,    
Null as TipoPoliza,    
Null as NoPoliza,
Afectable    
from C_Contable    
where Nivel>=0 and C_Contable.NumeroCuenta not in (Select NumeroCuentaContable from @tablaVacios where Year =@Ejercicio and (Mes between @mesinicio and @mesFin))
	END   
    
END    
    
Insert into @Tabla    
select * from @tablaVacios where     
--SaldoInicial<>0 AND     
(NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)    
AND Mes >= @MesInicio    
AND Mes <= @MesFin     
And year = @Ejercicio    
and NumeroCuentaContable not in (select NumeroCuentaContable  from @tabla where year=@Ejercicio and(Mes between @MesInicio and @MesFin ))    
END  
    
--IF @CuentaInicio =''    
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
	  ,SaldoFinal     
      ,Mes     
      ,year     
      ,TipoCuenta     
      ,Numero     
      ,FolioCheque     
      ,ConceptoPago      
      ,iNumeroCuenta    
   ,TipoPoliza    
   ,NoPoliza 
   ,Afectable    
      ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,Mes) as NumeroxCuenta
	,0
	,0
	,''
	,''   
   from @tabla where  (Mes between @MesInicio AND  @MesFin) And year = @Ejercicio 
   --AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable) order by NumeroCuentaContable,Numero--Fecha    
  --else    
  --insert into @tabla2    
  --Select      
  --Fecha    
  --    ,Folio    
  --    ,NoAsiento    
  --    ,Referencia    
  --    ,NumeroCuentaContable    
  --    ,NombreCuentaContable    
  --    ,Nivel     
  --    ,Concepto     
  --    ,IdDPoliza    
  --    ,ImporteCargo    
  --    ,ImporteAbono    
  --    ,SaldoFila    
  --    ,CuentaAcumulacion     
  --    ,SaldoInicial
	 -- ,SaldoFinal     
  --    ,Mes     
  --    ,year     
  --    ,TipoCuenta     
  --    ,Numero     
  --    ,FolioCheque     
  --    ,ConceptoPago      
  --    ,iNumeroCuenta    
  -- ,TipoPoliza    
  -- ,NoPoliza   
  -- ,Afectable  
  --    ,ROW_NUMBER ()over (partition by NumeroCuentaContable order by NumeroCuentaContable,Fecha,Mes) as NumeroxCuenta
	 -- ,0
	 -- ,0
	 -- ,''
	 -- ,''
  --from @tabla where (iNumeroCuenta between @iCuentaInicio and @iCuentaFin) AND (Mes between @MesInicio    
  --AND @MesFin)  And year = @Ejercicio order by NumeroCuentaContable,Numero
  

END  

if @NumeroCuenta = '' and @CuentaAcumulable <> ''
BEGIN
    declare @Estructura1 as int
	declare @Estructura2 as int
	set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
	set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
	declare @CerosEstructura varchar(20)
	set @CerosEstructura = REPLICATE('0',@Estructura2)

 Declare @Cuentas as table (    
  Cuenta varchar(100))
  Insert into @Cuentas
  select distinct NumeroCuentaContable from @tabla2 where Afectable = 1

  Declare @TotalGral as Table(
  Cuenta varchar(100),
  SaldoInicial decimal(18,2),
  SaldoFinal decimal(18,2))
  Insert into @TotalGral
  Select Cuenta, 
  (Select top 1 SaldoInicial from @tabla2 where NumeroCuentaContable = Cuenta and (Fecha = (Select MIN(Fecha) from @tabla2 Where NumeroCuentaContable = Cuenta) or Fecha is null)),
  (Select top 1 SaldoFinal from @tabla2 where NumeroCuentaContable = Cuenta and (Fecha = (Select MAX(Fecha) from @tabla2 Where NumeroCuentaContable = Cuenta) or Fecha is null))
  from @Cuentas 

  declare @cta varchar(30) = (Select @CuentaAcumulable+Replicate('0',@Estructura1-LEN(@CuentaAcumulable))+'-'+@cerosEstructura)
  UPDATE @tabla2 set TotalGral = (Select SUM(SaldoFinal) from @TotalGral)
  UPDATE @tabla2 set CtaSaldoInicial = (Select SUM(SaldoInicial) from @TotalGral)
  UPDATE @tabla2 set CtaMayor = (Select @CuentaAcumulable+Replicate('0',@Estructura1-LEN(@CuentaAcumulable))+'-'+@cerosEstructura)
  UPDATE @tabla2 set NombreCtaMayor = (Select NombreCuenta from C_Contable where NumeroCuenta = (Select top 1 CtaMayor from @tabla2))
END

if @cta is null
BEGIN
set @cta = ''
END
 --Select * from @TotalGral
--select 'tabla2',* from @tabla2 where concepto='RECLASIFICACION DE CUENTA'--kazb  
--update @tabla2 set SaldoFila= SaldoFila+SaldoInicial where NumeroxCuenta=1 and ((ImporteAbono<>null or ImporteCargo<>null) or (ImporteAbono<>0 or ImporteCargo<>0))    
DELETE FROM @tabla2 Where NumeroxCuenta>1 and ((ImporteAbono is null And ImporteCargo is null) or (ImporteAbono=0 And ImporteCargo=0)) and saldoFila =SaldoFila and SaldoInicial=SaldoInicial and Mes > @MesInicio     
--select * from @tabla2 order by Fecha,Numero,TipoPoliza,NoPoliza asc--where fecha is not null    
--select * from @tabla2 order by Fecha,TipoPoliza,Numero,NoPoliza asc--where fecha is not null    
select * from @tabla2 where NumeroCuentaContable <> @cta order by Fecha,Numero,NoPoliza asc--where fecha is not null
--select * from @tabla2 order by NumeroCuentaContable 
--Select * from @tabla2
--Select distinct NumeroCuentaContable, SaldoFinal  from @tabla2 --order by NumeroCuentaContable
  --select distinct SaldoFinal from @tabla2 where SaldoFinal <> 0 --in (select distinct NumeroCuentaContable from @tabla2 where SaldoFinal <> 0) 


--Select distinct t2.NumeroCuentaContable,
--(Select top 1 SaldoFinal from @tabla2 Where NumeroCuentaContable = t2.NumeroCuentaContable)
-- from @tabla2 t2 where t2.NumeroCuentaContable in (select distinct NumeroCuentaContable from @tabla2 where SaldoFinal <> 0)

 --Declare @Cuentas as table (    
 -- Cuenta varchar(100))
 -- Insert into @Cuentas
 -- select distinct NumeroCuentaContable from @tabla2 where Afectable = 1

 -- Declare @TotalGral as Table(
 -- Cuenta varchar(100),
 -- SaldoFinal decimal(18,2))
 -- Insert into @TotalGral
 -- Select Cuenta, 
 -- (Select top 1 SaldoFinal from @tabla2 where NumeroCuentaContable = Cuenta)
 -- from @Cuentas 

 GO
 Exec SP_CFG_LogScripts 'SP_RPT_K2_AuxiliarMayor','2.29'
GO

