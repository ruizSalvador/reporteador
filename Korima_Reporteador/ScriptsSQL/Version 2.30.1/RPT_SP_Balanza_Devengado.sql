/****** Object:  StoredProcedure [dbo].[RPT_SP_Balanza_Devengado]    Script Date: 06/10/2020 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Balanza_Devengado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Balanza_Devengado]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_Balanza_Devengado]    Script Date: 06/10/2020 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Exec RPT_SP_Balanza_Devengado '20200101','20201231'
CREATE PROCEDURE [dbo].[RPT_SP_Balanza_Devengado]

--@Ejercicio int,
@FechaIni Date,
@FechaFin Date

AS

BEGIN

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @SaldosFinales as table (
IdCuenta int,
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int)

INSERT INTO @SaldosFinales
Select C_Contable.IdCuentaContable, NumeroCuenta, NombreCuenta, 
	CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos,
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
					End as SaldoAcreedor, Afectable,C_Contable.Financiero 
	From C_Contable JOIN T_SaldosInicialesCont ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
	Where  
	 Mes = 12  And [Year] = YEAR(@FechaFin) And TipoCuenta <> 'X' AND (NumeroCuenta like '825%' OR NumeroCuenta like '814%')
	Order By NumeroCuenta

SELECT
	sellos.sello as CLAVE_PRESUPUESTAL, 
	--sellos.IdSelloPresupuestal,
	CA.Clave as ID_UR, CA.Nombre as DESC_UR,
	CEPR.Clave as CLASPROGRAMATICA, CEPR.Nombre as DESCRIPCIONCLASPROGRAMATICA,
	CPP.IdPartida as OBJ_GASTO, CPP.DescripcionPartida as DESC_OBJ_GASTO,
	CTG.Clave as ID_TIPO_GASTO, CTG.DESCRIPCION as TIPO_GASTO,
	0  as ID_CRI, '' as DESC_CRI,
	CF.CLAVE as ID_FF, CF.DESCRIPCION as DESC_FF,
	CG.Clave as ID_MUNICIPIO, CG.Descripcion as MUNICIPIO,

	LEFT(CC.NumeroCuenta,1) as GENERO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,1) +Replicate('0',@Estructura1-1)+'-'+@cerosEstructura)) as DESC_GENERO,

		LEFT(CC.NumeroCuenta,2) as GRUPO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,2) +Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)) as DESC_GRUPO,

	
		LEFT(CC.NumeroCuenta,3) as RUBRO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,3) +Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) as DESC_RUBRO,

			LEFT(CC.NumeroCuenta,5) as CUENTA,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,5) +Replicate('0',@Estructura1-5)+'-'+@cerosEstructura)) as DESC_CUENTA,

	'0' as SUBCUENTA,
	'' as DESC_SUBCUENTA,

	'0' as SS_CUENTA,
	'' as DESC_SS_CUENTA,

	RIGHT(TRIM(CC.NumeroCuenta),5) as SS_CUENTA_ESP,
CC.NombreCuenta  as DESC_SSCUENTA,
--CC.NumeroCuenta,

			0.0000 as  InicialDeudor,
			0.0000 as InicialAcreedor,
			--TotalCargos, TotalAbonos,
			D_Polizas.ImporteCargo,
			D_Polizas.ImporteAbono,
					Finales.SaldoDeudor as FinalDeudor,
					Finales.SaldoAcreedor as FinalAcreedor,			

			--T_polizas.idpoliza,
			T_polizas.NoPoliza AS Poliza,
			T_Polizas.Fecha,
			D_Polizas.Referencia
			
			FROM T_Polizas
			JOIN
			D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND T_Polizas.Ejercicio = YEAR(@FechaFin)
			JOIN
			C_Contable CC ON CC.IdCuentaContable= D_Polizas.IdCuentaContable 
			LEFT JOIN 
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque join T_SellosPresupuestales Sellos
			on d_polizas.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT join   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto

			LEFT JOIN C_ClasificadorGeograficoPresupuestal CG ON CG.IdClasificadorGeografico = Sellos.IdClasificadorGeografico
LEFT JOIN T_SolicitudCheques TSCA
ON T_Cheques.IdSolicitudCheque = TSCA.IdSolicitudCheques
LEFT JOIN T_RecepcionFacturas TRFA
ON TRFA.IdRecepcionServicios = TSCA.IdRecepcionServicios
LEFT JOIN @SaldosFinales Finales  ON Finales.IdCuenta = D_Polizas.IdCuentaContable

			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			AND T_Polizas.Fecha >= @FechaIni 
			AND T_Polizas.Fecha <= @FechaFin 
			--AND YEAR(T_Polizas.Fecha) <= @Ejercicio 
			AND (CC.NumeroCuenta like '825%') 
				
			--ORDER BY T_Polizas.IdPoliza


	UNION ALL

	SELECT
	sellos.Clave as CLAVE_PRESUPUESTAL, 
	--sellos.IdSelloPresupuestal,
	'' as ID_UR, '' as DESC_UR,
	'' as CLASPROGRAMATICA, '' as DESCRIPCIONCLASPROGRAMATICA,
	'' as OBJ_GASTO, '' as DESC_OBJ_GASTO,
	'' as ID_TIPO_GASTO, '' as TIPO_GASTO,
	Sellos.IdPartidaGI  as ID_CRI, Sellos.Descripcion as DESC_CRI,
	CF.CLAVE as ID_FF, CF.DESCRIPCION as DESC_FF,
	'' as ID_MUNICIPIO, '' as MUNICIPIO,

	LEFT(CC.NumeroCuenta,1) as GENERO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,1) +Replicate('0',@Estructura1-1)+'-'+@cerosEstructura)) as DESC_GENERO,

		LEFT(CC.NumeroCuenta,2) as GRUPO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,2) +Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)) as DESC_GRUPO,

	
		LEFT(CC.NumeroCuenta,3) as RUBRO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,3) +Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) as DESC_RUBRO,

			LEFT(CC.NumeroCuenta,5) as CUENTA,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,5) +Replicate('0',@Estructura1-5)+'-'+@cerosEstructura)) as DESC_CUENTA,

	'0' as SUBCUENTA,
	'' as DESC_SUBCUENTA,

	'0' as SS_CUENTA,
	'' as DESC_SS_CUENTA,

	RIGHT(TRIM(CC.NumeroCuenta),5) as SS_CUENTA_ESP,
CC.NombreCuenta  as DESC_SSCUENTA,
--CC.NumeroCuenta,
--T_Polizas.IdPoliza,

			0.0000 as  InicialDeudor,
			0.0000 as InicialAcreedor,
			--TotalCargos, TotalAbonos,
			D_Polizas.ImporteCargo,
			D_Polizas.ImporteAbono,
					Finales.SaldoDeudor as FinalDeudor,
					Finales.SaldoAcreedor as FinalAcreedor,			

			--T_polizas.idpoliza,
			T_polizas.NoPoliza AS Poliza,
			T_Polizas.Fecha,
			D_Polizas.Referencia
			
			FROM T_Polizas
			JOIN
			D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza AND T_Polizas.Ejercicio = YEAR(@FechaFin)
			JOIN
			C_Contable CC ON CC.IdCuentaContable= D_Polizas.IdCuentaContable 

			LEFT JOIN 
			T_Cheques ON T_Cheques.IdCheques=T_Polizas.IdCheque join C_PartidasGastosIngresos Sellos
			on d_polizas.IdPartidaDeFlujo = Sellos.IdPartidaGI
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			
LEFT JOIN @SaldosFinales Finales  ON Finales.IdCuenta = D_Polizas.IdCuentaContable

			 where TipoCuenta <> 'X'
			 AND (T_Polizas.NoPoliza>0 --and (T_Polizas.TipoPoliza='I' or T_Polizas.TipoPoliza='D')
			 OR ((T_Cheques.IdChequesAgrupador= 0  OR T_Cheques.IdChequesAgrupador is null)
			 and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N')))and T_Polizas.NoPoliza>0))
			  -- and( T_Cheques.Status= 'D' or ((T_Cheques.Status='I'OR T_Cheques.Status='N') and T_Cheques.Entregado=1)))
			AND (T_Polizas.Fecha >= @FechaIni 
			AND T_Polizas.Fecha <= @FechaFin)
			--AND YEAR(T_Polizas.Fecha) <= YEAR(@FechaFin) --AND [year] = 2020 

			AND (CC.NumeroCuenta like '814%') 
				
		ORDER BY T_polizas.NoPoliza


END

			


