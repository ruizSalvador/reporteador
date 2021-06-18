/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des]    Script Date: 22/04/2021 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des]    Script Date: 22/04/2021 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_K2_AuxiliarMayorCvePres_Des '','',2021,1,1,0,'11110-00001','93000-00000',0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des] 

--alter PROCEDURE [dbo].[SP_RPT_K2_AuxiliarMayorCvePres_Des] 
@NumeroCuenta varchar(30),
@CuentaAcumulable varchar(30),
@Ejercicio smallint,
@MesInicio smallint,
@MesFin smallint,
@MuestraVacios bit,
@CuentaInicio varchar(30),
@CuentaFin varchar(30),
@CvePres int,
@CvePres2 int,
@ClaveFF varchar(6)

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
	  ,FFClave varchar(max)
	  ,FFDescripcion varchar(max)
	  ,TGClave varchar(max)
	  ,TGDescripcion varchar(max)
	  ,URClave varchar(max)
	  ,URDescripcion varchar(max)
	  ,IdPartida int
	  ,DescripcionPartida varchar(max)
	  ,ProgClave varchar(max)
	  ,ProgDescripcion varchar(max)
	  ,ProyClave varchar(max)
	  ,ProyDescripcion varchar(max)
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
	  ,FFClave varchar(max)
	  ,FFDescripcion varchar(max)
	  ,TGClave varchar(max)
	  ,TGDescripcion varchar(max)
	  ,URClave varchar(max)
	  ,URDescripcion varchar(max)
	  ,IdPartida int
	  ,DescripcionPartida varchar(max)
	  ,ProgClave varchar(max)
	  ,ProgDescripcion varchar(max)
	  ,ProyClave varchar(max)
	  ,ProyDescripcion varchar(max)
 )
 IF @CuentaInicio ='' 
 BEGIN
	If @ClaveFF <> ''
		Begin
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
			convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, sellos.sello, sellos.IdSelloPresupuestal,
			CF.CLAVE as FFClave, CF.DESCRIPCION as FFDescripcion,
			CTG.Clave as TGClave, CTG.DESCRIPCION as TGDescripcion,
			CA.Clave as URClave, CA.Nombre as URDescripcion,
			CPP.IdPartida, CPP.DescripcionPartida,
			CEPR.Clave as ProgClave, CEPR.Nombre as ProgDescripcion,
			CPI.CLAVE as ProyClave, CPI.NOMBRE as ProyDescripcion

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
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque join T_SellosPresupuestales Sellos
			on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto
			LEFT  JOIN C_ProyectosInversion CPI ON CPI.PROYECTO = Sellos.Proyecto
			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
				AND Mes >= @MesInicio
				AND Mes <= @MesFin 
				AND [year] = @Ejercicio 
				AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
				AND CF.Clave= @ClaveFF
				ORDER BY NumeroCuentaContable, Fecha
		end
	else
		Begin
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
			convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, sellos.sello, sellos.IdSelloPresupuestal,
			CF.CLAVE as FFClave, CF.DESCRIPCION as FFDescripcion,
			CTG.Clave as TGClave, CTG.DESCRIPCION as TGDescripcion,
			CA.Clave as URClave, CA.Nombre as URDescripcion,
			CPP.IdPartida, CPP.DescripcionPartida,
			CEPR.Clave as ProgClave, CEPR.Nombre as ProgDescripcion,
			CPI.CLAVE as ProyClave, CPI.NOMBRE as ProyDescripcion
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
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque  join T_SellosPresupuestales Sellos
			on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
			--INNER JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto
			LEFT  JOIN C_ProyectosInversion CPI ON CPI.PROYECTO = Sellos.Proyecto
			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
					AND Mes >= @MesInicio
					AND Mes <= @MesFin 
					AND [year] = @Ejercicio 
					AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
					--AND CF.Clave= @ClaveFF
					ORDER BY NumeroCuentaContable, Fecha
		End
 END
ELSE
BEGIN

	If @ClaveFF <>''
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
			convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, Sellos.Sello, sellos.IdSelloPresupuestal,
			CF.CLAVE as FFClave, CF.DESCRIPCION as FFDescripcion,
			CTG.Clave as TGClave, CTG.DESCRIPCION as TGDescripcion,
			CA.Clave as URClave, CA.Nombre as URDescripcion,
			CPP.IdPartida, CPP.DescripcionPartida,
			CEPR.Clave as ProgClave, CEPR.Nombre as ProgDescripcion,
			CPI.CLAVE as ProyClave, CPI.NOMBRE as ProyDescripcion
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
			left outer join T_SellosPresupuestales sellos on d_polizas.IdSelloPresupuestal = sellos.idselloPresupuestal
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto
			LEFT  JOIN C_ProyectosInversion CPI ON CPI.PROYECTO = Sellos.Proyecto
			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
					AND Mes >= @MesInicio
					AND Mes <= @MesFin 
					AND [year] = @Ejercicio 
					AND CF.Clave = @ClaveFF
					ORDER BY NumeroCuentaContable, Fecha
			end
		Else
			Begin
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
				convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, Sellos.Sello, sellos.IdSelloPresupuestal,
				CF.CLAVE as FFClave, CF.DESCRIPCION as FFDescripcion,
			CTG.Clave as TGClave, CTG.DESCRIPCION as TGDescripcion,
			CA.Clave as URClave, CA.Nombre as URDescripcion,
			CPP.IdPartida, CPP.DescripcionPartida,
			CEPR.Clave as ProgClave, CEPR.Nombre as ProgDescripcion,
			CPI.CLAVE as ProyClave, CPI.NOMBRE as ProyDescripcion
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
				left outer join T_SellosPresupuestales sellos on d_polizas.IdSelloPresupuestal = sellos.idselloPresupuestal
				--INNER JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
				LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto
			LEFT  JOIN C_ProyectosInversion CPI ON CPI.PROYECTO = Sellos.Proyecto
				 where TipoCuenta <> 'X'
				 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
				 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
				 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
				  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
						AND Mes >= @MesInicio
						AND Mes <= @MesFin 
						AND [year] = @Ejercicio 
						--AND CF.Clave = @ClaveFF
						ORDER BY NumeroCuentaContable, Fecha
			End
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
      ,IdCvePres int
	  ,FFClave varchar(max)
	  ,FFDescripcion varchar(max)
	  ,TGClave varchar(max)
	  ,TGDescripcion varchar(max)
	  ,URClave varchar(max)
	  ,URDescripcion varchar(max)
	  ,IdPartida int
	  ,DescripcionPartida varchar(max)
	  ,ProgClave varchar(max)
	  ,ProgDescripcion varchar(max)
	  ,ProyClave varchar(max)
	  ,ProyDescripcion varchar(max)
	  )

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
      convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta, ''CvePresupuestal, 0,
	  '','','','','','','','','','','',''
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
	  ,FFClave 
	  ,FFDescripcion 
	  ,TGClave 
	  ,TGDescripcion 
	  ,URClave 
	  ,URDescripcion 
	  ,IdPartida 
	  ,DescripcionPartida 
	  ,ProgClave 
	  ,ProgDescripcion 
	  ,ProyClave 
	  ,ProyDescripcion 
   from @tabla where  (Mes between @MesInicio AND  @MesFin) And year = @Ejercicio AND (NumeroCuentaContable = @NumeroCuenta OR substring(NumeroCuentaContable,1,LEN(@cuentaacumulable)) = @CuentaAcumulable) 
   and isnull(IdCvePres,0) >= case when @CvePres = 0 then isnull(IdCvePres,0) else @CvePres end  
   and isnull(IdCvePres,0) <= case when @CvePres2 = 0 then isnull(IdCvePres,0) else @CvePres2 end  
   order by NumeroCuentaContable,Numero--Fecha

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
	  ,FFClave 
	  ,FFDescripcion 
	  ,TGClave 
	  ,TGDescripcion 
	  ,URClave 
	  ,URDescripcion 
	  ,IdPartida 
	  ,DescripcionPartida 
	  ,ProgClave 
	  ,ProgDescripcion 
	  ,ProyClave 
	  ,ProyDescripcion 
  from @tabla where (iNumeroCuenta between @iCuentaInicio and @iCuentaFin) AND (Mes between @MesInicio
		AND @MesFin)  And year = @Ejercicio and isnull(IdCvePres,0) >= case when @CvePres = 0 then isnull(IdCvePres,0) else @CvePres end 
		and isnull(IdCvePres,0) <= case when @CvePres2 = 0 then isnull(IdCvePres,0) else @CvePres2 end 
		order by NumeroCuentaContable,Numero
END
--update @tabla2 set SaldoFila= SaldoFila+SaldoInicial where NumeroxCuenta=1 and ((ImporteAbono<>null or ImporteCargo<>null) or (ImporteAbono<>0 or ImporteCargo<>0))
DELETE FROM @tabla2 Where NumeroxCuenta>1 and ((ImporteAbono is null And ImporteCargo is null) or (ImporteAbono=0 And ImporteCargo=0)) and saldoFila =SaldoFila and SaldoInicial=SaldoInicial and Mes > @MesInicio 
select * from @tabla2 


