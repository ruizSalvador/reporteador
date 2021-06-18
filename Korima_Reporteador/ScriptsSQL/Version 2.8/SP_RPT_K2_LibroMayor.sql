
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_LibroMayor]    Script Date: 07/03/2013 13:50:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_LibroMayor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_LibroMayor]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_LibroMayor]    Script Date: 07/03/2013 13:50:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Batch submitted through debugger: SP_RPT_K2_AuxiliarMayor_LibroMayor.sql|13|0|C:\Users\Samsung\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\OQ0C9842\SP_RPT_K2_AuxiliarMayor_LibroMayor.sql
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
      ,Concepto varchar (max)
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
      ,NoPoliza Int)
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
		isnull(D_Polizas.ImporteCargo,0) as ImporteCargo,
		isnull(D_Polizas.ImporteAbono,0)as ImporteAbono,
			Case C_Contable .TipoCuenta    
      When 'A' Then T_SaldosInicialesCont.CargosSinFlujo + (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'C' Then T_SaldosInicialesCont.CargosSinFlujo + (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'E' Then T_SaldosInicialesCont.CargosSinFlujo + (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'G' Then T_SaldosInicialesCont.CargosSinFlujo + (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'I' Then T_SaldosInicialesCont.CargosSinFlujo  + (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      Else T_SaldosInicialesCont.AbonosSinFlujo +(isnull(D_Polizas.ImporteAbono,0) - isnull(D_Polizas.ImporteCargo,0))
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
T_Polizas.NoPoliza 
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
 where TipoCuenta <> 'X'
 and T_Polizas.NoPoliza>0
 and Mes >= @MesInicio
		AND Mes <= @MesFin 
		AND [year] = @Ejercicio 
		AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
		ORDER BY NumeroCuentaContable, Fecha

 
 Update @tabla set SaldoFila = ImporteCargo-importeabono where Numero>1 --and SaldoInicial=SaldoInicial 
 and(TipoCuenta='A' OR
	 TipoCuenta='C' OR
	 TipoCuenta='E' OR
	 TipoCuenta='G' OR
	 TipoCuenta='I' )
  Update @tabla set SaldoFila = ImporteAbono-importecargo where Numero>1 --and SaldoInicial=SaldoInicial 
 and(TipoCuenta<>'A' AND
	 TipoCuenta<>'C' AND
	 TipoCuenta<>'E' AND
	 TipoCuenta<>'G' AND
	 TipoCuenta<>'I' )
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
      ,NoPoliza Int)

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
      Null as NoPoliza
      from T_SaldosInicialesCont  
JOIN C_Contable ON
C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
where T_SaldosInicialesCont.TotalAbonos =0 
AND T_SaldosInicialesCont.TotalCargos=0
Insert into @Tabla
select * from @tablaVacios where SaldoInicial<>0 
AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
and Mes= @MesInicio
And year = @Ejercicio
END
 
 Select * from @tabla order by NumeroCuentaContable,Numero
 END
  


GO
