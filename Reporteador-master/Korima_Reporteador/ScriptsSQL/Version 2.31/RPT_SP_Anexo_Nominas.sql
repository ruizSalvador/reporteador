/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Nominas]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Anexo_Nominas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Anexo_Nominas]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Nominas]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Anexo_Nominas '20210101','20210228',0
CREATE PROCEDURE [dbo].[RPT_SP_Anexo_Nominas] 
  
@FechaIni as DateTime,
@FechaFin as DateTime,
@TipoMov as int

AS
BEGIN


Select 
  --TIN.IdNomina, 
  TIN.Year as Ejercicio,
 Quincena,
 NoNomina, 
 TC.Beneficiario as BeneficiarioNom,
 TP.Concepto as ConceptoNom,
 TIN.Importe as ImporteNom,
 CAST(TP.TipoPoliza as varchar(10)) + ' '  + CAST(TP.Periodo as varchar (5)) + ' ' + CAST(TP.NoPoliza as varchar (50))  as PolizaDev,
 TP.Fecha as FechaPolDev,
 DP.ImporteCargo as ImportePolDevengado,
 --CCON.NumeroCuenta as CtaContableDev, 
 --CCON.NombreCuenta as DesCtaDev,
 (Select NumeroCuenta from C_Contable Where IdCuentaContable = DP.IdCuentaContable) as CtaContableDev,
 (Select NombreCuenta from C_Contable Where IdCuentaContable = DP.IdCuentaContable) as DesCtaDev,
 CG.IdCapitulo as Capitulo,
 TS.IdPartida as PartidaClas,
 CPP.DescripcionPartida,
 TS.Sello,
 CFF.CLAVE as ClaveFF,
 CFF.DESCRIPCION as DesFF,
 TP.IdTipoMovimiento as NTPDev,
 CMOV.Descripcion as DescripcionTP,
 TSC.FolioPorTipo as SolPago,
 TSC.Fecha as FechaSol,
 TSC.Beneficiario as BeneSol,
 TSC.Concepto ConcSol,
 TSC.Importe as ImporteSol,
 TSC.FolioDesconcentrado as NoAprobacion,
 TSC.FechaAprobacion,
 TC.Beneficiario as BeneCheque,
 TC.ImporteCheque,
 TPP.IdTipoMovimiento	AS TipoMovPagado,
 CMOVPDO.Descripcion as DesTipoMovPagado,

		CAST(TPP.TipoPoliza as varchar(10)) + ' '  + CAST(TPP.Periodo as varchar (5)) + ' ' + CAST(TPP.NoPoliza as varchar (50))  as PolizaPagado,

		--(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		TPP.Fecha AS FechaPolizaPagado,
		--ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
		--C2.NumeroCuenta  as CtaPagado,
		--C2.NombreCuenta as DesCtaPagado
				(Select ImporteCargo from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%'  and D_Polizas.IdSelloPresupuestal = DP.IdSelloPresupuestal and IdPoliza = TC.IdPolizaPresupuestoPagado) as ImportePolPagado,
		(Select NumeroCuenta from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%'  and D_Polizas.IdSelloPresupuestal = DP.IdSelloPresupuestal and IdPoliza = TC.IdPolizaPresupuestoPagado) as CtaPagado,
		(Select NombreCuenta from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%'  and D_Polizas.IdSelloPresupuestal = DP.IdSelloPresupuestal and IdPoliza = TC.IdPolizaPresupuestoPagado) as DesCtaPagado

	FROM T_ImportaNomina TIN
	LEFT JOIN T_Polizas TP
	ON TIN.IdPoliza = TP.IdPoliza and TP.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN TP.IdTipoMovimiento ELSE @TipoMov END
	LEFT JOIN D_Polizas DP ON DP.IdPoliza = TP.IdPoliza AND DP.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '5%' and D_Polizas.IdPoliza = TP.IdPoliza)

	LEFT JOIN R_NominaSolEgresos RNSOL
	ON TIN.IdNomina = RNSOL.IdNomina
	LEFT JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = RNSOL.IdSolicitudCheques
	LEFT JOIN T_Cheques TC
	ON TC.IdSolicitudCheque = TSC.IdSolicitudCheques and TC.Status in ('D','I')
	LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
	LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	LEFT JOIN C_TipoMovPolizas CMOV ON TP.IdTipoMovimiento = CMOV.IdTipoMovimiento

	--LEFT JOIN T_Polizas TPP ON TPP.IdPoliza = TC.IdPolizaPresupuestoPagado
	LEFT JOIN T_Polizas TPP ON TPP.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end
	LEFT JOIN C_TipoMovPolizas CMOVPDO ON TPP.IdTipoMovimiento = CMOVPDO.IdTipoMovimiento
	
--Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
--CASE 
--WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
--ELSE TC.IdPolizaPresupuestoPagado end AND DP2.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%' and D_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado)
--LEFT JOIN C_Contable C2 on C2.IdCuentaContable = DP2.IdCuentaContable
	Where  (TIN.FechaPago >= @FechaIni and TIN.FechaPago <= @FechaFin)

Group by TIN.Year, TIN.Quincena, TIN.NoNomina, TC.Beneficiario, TP.Concepto, TIN.Importe, TP.TipoPoliza, TP.Periodo, TP.NoPoliza, TP.Fecha, DP.ImporteCargo, DP.IdCuentaContable,
CG.IdCapitulo, TS.IdPartida, TS.Sello, CPP.DescripcionPartida, CFF.CLAVE, CFF.DESCRIPCION, TP.IdTipoMovimiento, CMOV.Descripcion, TSC.FolioPorTipo, TSC.Fecha, TSC.Beneficiario, TSC.Concepto, TSC.Importe,
TSC.FolioDesconcentrado, TSC.FechaAprobacion, TC.ImporteCheque, TPP.IdTipoMovimiento, CMOVPDO.Descripcion, TC.Entregado, TC.IdChequesAgrupador, TC.Status, TC.FolioCheque, TC.IdPolizaPresupuestoPagado,
DP.IdSelloPresupuestal,
--DP2.ImporteCargo, C2.NumeroCuenta, C2.NombreCuenta, 
TIN.IdNomina, TPP.TipoPoliza ,TPP.NoPoliza, TPP.Periodo, TPP.Fecha
	order by  TIN.IdNomina
-------------------------------------


END






