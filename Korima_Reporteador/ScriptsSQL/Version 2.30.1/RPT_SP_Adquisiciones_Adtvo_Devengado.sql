/****** Object:  StoredProcedure [dbo].[RPT_SP_Adquisiciones_Adtvo_Devengado]    Script Date: 06/10/2021 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Adquisiciones_Adtvo_Devengado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Adquisiciones_Adtvo_Devengado]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_Adquisiciones_Adtvo_Devengado]    Script Date: 06/10/2021 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Exec RPT_SP_Adquisiciones_Adtvo_Devengado 2020,'20200101','20201231',0,0,0,0
-- Exec RPT_SP_Adquisiciones_Adtvo_Devengado 2020,1,12,0,0,0,0
CREATE PROCEDURE [dbo].[RPT_SP_Adquisiciones_Adtvo_Devengado]

@Ejercicio int,
@Periodo1 int,
@Periodo2 int,
@TipoMov int,
@IdCapitulo int,
@IdPartida int,
@IdProv int

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


SELECT 
	TRF.IdRecepcionServicios as Id_Devengado,
	TRF.Observaciones,
	--0 as Id_registro,
	(Select top 1 IdCheques from T_Cheques where IdSolicitudCheque = (Select top 1 IdSolicitudCheques from T_SolicitudCheques Where IdRecepcionServicios = TRF.IdRecepcionServicios)) as Id_registro,
	sellos.IdSelloPresupuestal as Id_Clave_Presupuestal,
	sellos.sello as CLAVE_PRESUPUESTAL, 
	sellos.LYear as Ejercicio,
	CRP.CLAVE as Id_Clasificacion_Administrativa,
	CA.Clave as ID_UR, 
	CA.Nombre as DESC_UR,
	CEPR.Clave as CLAS_PROGRAMATICA, 
	CEPR.Nombre as DESCRIPCION_CLAS_PROGRAMATICA,
	CR.CLAVE as Clasificacion_Fun_Finalidades,
	CR.Descripcion as Descripcion_Finalidad,
	SUBSTRING(CFUN.Clave,2,1) as Funcion,
	CFUN.Nombre as Desc_Funcion,
	SUBSTRING(CSUBF.Clave,3,1) as Subfuncion,
	CSUBF.Nombre as Desc_Subfuncion,
	'' as Sub_Sub_Funcion,
	'' as Desc_SsFuncion,
	'' as Actividad_Institucional,
	CPP.IdPartida as OBJ_GASTO, 
	CPP.DescripcionPartida as DESC_OBJ_GASTO,
	CTG.Clave as ID_TIPO_GASTO, 
	CTG.DESCRIPCION as TIPO_GASTO,
	--0  as ID_CRI, '' as DESC_CRI,
	CF.CLAVE as ID_FF,  CF.DESCRIPCION as DESC_FF,
	CG.Clave as ID_MUNICIPIO, CG.Descripcion as MUNICIPIO,

	--CC.NumeroCuenta,

	LEFT(CC.NumeroCuenta,1) as GENERO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,1) +Replicate('0',@Estructura1-1)+'-'+@cerosEstructura)) as DESC_GENERO,

		SUBSTRING(CC.NumeroCuenta,2,1) as GRUPO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,2) +Replicate('0',@Estructura1-2)+'-'+@cerosEstructura)) as DESC_GRUPO,

	
		SUBSTRING(CC.NumeroCuenta,3,1) as RUBRO,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,3) +Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) as DESC_RUBRO,

			SUBSTRING(CC.NumeroCuenta,4,1) as CUENTA,
	(Select NombreCuenta from C_Contable WHere NumeroCuenta = (LEFT(CC.NumeroCuenta,4) +Replicate('0',@Estructura1-4)+'-'+@cerosEstructura)) as DESC_CUENTA,

	SUBSTRING(CC.NumeroCuenta,9,1) as SUBCUENTA,
	(Select Descripcion from C_ConceptosNEP WHere IdConcepto = (SUBSTRING(CC.NumeroCuenta,8,2) +Replicate('0',2))) as DESC_SUBCUENTA,

	
	SUBSTRING(CC.NumeroCuenta,10,1) as SS_CUENTA,
	(Select DescripcionPartida from C_PartidasGenericasPres WHere IdPartidaGenerica = (SUBSTRING(CC.NumeroCuenta,8,3) +Replicate('0',1))) as DESC_SS_CUENTA,


		SUBSTRING(CC.NumeroCuenta,11,1) as SS_CUENTA_ESP,
	(Select DescripcionPartida from C_PartidasPres WHere IdPartida = (SUBSTRING(CC.NumeroCuenta,8,4))) as DESC_SS_CUENTA_ESP,

			TP.IdTipoMovimiento as Id_Tipo_Movimiento,
			CTMP.Descripcion as Desc_Tipo_Movimiento,
			'' as Id_Proyecto,
			'' as Desc_Proyecto,
			TP.IdPoliza as Id_Poliza,
			TP.TipoPoliza,
			TP.Periodo,
			TP.NoPoliza,
			'DIARIO' as Origen,
			DP.Referencia,
			TRF.Factura as No_Factura,
			TRF.FechaFactura as Fecha_Factura,
			'' as Contrato,
			--TRF.Total as Importe_Factura,
			DP.ImporteCargo as Importe_Factura,
			TRF.Observaciones as Concepto_Factura,
			(Select top 1 ConceptoPago from T_Cheques where IdSolicitudCheque = (Select top 1 IdSolicitudCheques from T_SolicitudCheques Where IdRecepcionServicios = TRF.IdRecepcionServicios)) as Id_Documentacion,
			--TRF.Total as Importe_Devengado,
			DP.ImporteCargo as Importe_Devengado,
			'PESOS' as Denominacion,
			DP.ImporteCargo as Importe_Total_Pagado,
			TRF.IdProveedor,
			CP.RFC,
			CP.RazonSocial AS Desc_Proveedor,
			TRF.Total as Cifra_Control
			
			FROM T_RecepcionFacturas TRF
			LEFT JOIN T_Polizas TP ON TP.IdPoliza = TRF.IdPoliza
			
			LEFT JOIN D_Polizas DP ON DP.IdPoliza= TP.IdPoliza AND TP.Ejercicio = @Ejercicio
			--JOIN
			LEFT JOIN VW_C_Contable CC ON CC.IdCuentaContable= DP.IdCuentaContable 
			
			--left join T_SolicitudCheques on T_SolicitudCheques.IdRecepcionServicios = TRF.IdRecepcionServicios
			--left join T_Cheques on T_Cheques.idSolicitudCheque = T_SolicitudCheques.IdSolicitudCheques

			JOIN T_SellosPresupuestales Sellos on DP.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
			LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento
			LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
			LEFT JOIN C_AreaResponsabilidad CA ON CA.IdAreaResp = Sellos.IdAreaResp
			LEFT JOIN C_PartidasPres CPP ON CPP.IdPartida = Sellos.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CCAP ON CCAP.IdCapitulo = CN.IdCapitulo

			LEFT JOIN   C_EP_Ramo  CEPR on CEPR.Id = Sellos.IdProyecto
			LEFT JOIN C_RamoPresupuestal CRP ON CRP.IDRAMOPRESUPUESTAL = Sellos.IdRamoPresupuestal
			LEFT JOIN C_ClasificadorGeograficoPresupuestal CG ON CG.IdClasificadorGeografico = Sellos.IdClasificadorGeografico
			LEFT JOIN C_TipoMovPolizas CTMP ON CTMP.IdTipoMovimiento = TP.IdTipoMovimiento
			LEFT JOIN C_Proveedores CP ON CP.IdProveedor = TRF.IdProveedor
			LEFT JOIN C_SubFunciones CSUBF ON CSUBF.IdSubFuncion = sellos.IdSubFuncion
			LEFT JOIN C_Funciones CFUN ON CFUN.IdFuncion = CSUBF.IdFuncion
			LEFT JOIN C_Ramo CR ON CR.IdRamo = CFUN.IdFinalidad

			 where TipoCuenta <> 'X'
			 AND (TP.NoPoliza>0 )
			  
			AND (MONTH(TP.Fecha) >= @Periodo1  AND MONTH(TP.Fecha) <= @Periodo2 ) 
			--AND (TP.Fecha >= @FechaIni  AND TP.Fecha <= @FechaFin)
			
			AND YEAR(TP.Fecha) <= @Ejercicio --AND [year] = @Ejercicio 
			
			AND (CC.NumeroCuenta like '5%')
			AND CTMP.IdTipoMovimiento =CASE WHEN @TipoMov = 0 THEN CTMP.IdTipoMovimiento else @TipoMov end
			AND CCAP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CCAP.IdCapitulo ELSE @IdCapitulo END
			AND Sellos.IdPartida = CASE WHEN @IdPartida = 0 THEN Sellos.IdPartida ELSE @IdPartida END
			AND CP.IdProveedor =  CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
				
			ORDER BY TP.IdPoliza


END

			


