/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Nominas]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Anexo_Nominas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Anexo_Nominas]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Nominas]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Anexo_Nominas 1,7,2020
CREATE PROCEDURE [dbo].[RPT_SP_Anexo_Nominas] 
  
--@FechaIni as DateTime,
--@FechaFin as DateTime,
--@IdProv as int,
--@TipoMov as int

AS
BEGIN

Select 
  TIN.IdNomina, 
  TIN.Year,
 Quincena,
 NoNomina, 
 '' Beneficiario,
 TP.Concepto,
 TIN.Importe,
 CAST(TP.TipoPoliza as varchar(10)) + ' '  + CAST(TP.Periodo as varchar (5)) + ' ' + CAST(TP.NoPoliza as varchar (50))  as PolizaDev,
 TP.Fecha as FechaPolDev,
 DP.ImporteCargo as ImportePolDevengado,
 CCON.NumeroCuenta as CtaContable,
 CCON.NombreCuenta as DesCta,
 CG.IdCapitulo as Capitulo,
 TS.IdPartida as PartidaClas,
 CPP.DescripcionPartida,
 TS.Sello,
 CFF.CLAVE,
 CFF.DESCRIPCION as DesFF,
 TP.IdTipoMovimiento,
 CMOV.Descripcion,
 TSC.FolioPorTipo as SolPago,
 TSC.Fecha as FechaSol,
 TSC.Beneficiario as BeneSol,
 TSC.Concepto ConcSol,
 TSC.Importe as ImporteSol,
 TSC.FolioDesconcentrado as NoAprobacion,
 TSC.FechaAprobacion,
 TC.Beneficiario as BeneCheque,
 TC.ImporteCheque,
 (Select IdTipoMovimiento from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS TipoMovPagado,
     CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
		(Select NombreCuenta from C_Contable where IdCuentaContable = DP2.IdCuentaContable) as DesCtaPagado
 --TIN.Observaciones, 
		 
	--	TSC.FechaProgramacion,  TSC.Importe as ImporteSol,
		
	--	TC.FolioCheque 
	FROM T_ImportaNomina TIN
	LEFT JOIN T_Polizas TP
	ON TIN.IdPoliza = TP.IdPoliza
	LEFT JOIN D_Polizas DP ON DP.IdPoliza = TP.IdPoliza
	 JOIN C_Contable CCON ON CCON.IdCuentaContable = DP.IdCuentaContable and NumeroCuenta like '51%'
	LEFT JOIN R_NominaSolEgresos RNSOL
	ON TIN.IdNomina = RNSOL.IdNomina
	LEFT JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = RNSOL.IdSolicitudCheques
	LEFT JOIN T_Cheques TC
	ON TC.IdSolicitudCheque = TSC.IdSolicitudCheques
	LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
	LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	LEFT JOIN C_TipoMovPolizas CMOV ON TP.IdTipoMovimiento = CMOV.IdTipoMovimiento

	--LEFT JOIN T_Polizas TPP ON TPP.IdPoliza = TC.IdPolizaPresupuestoPagado
	
Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
ELSE TC.IdPolizaPresupuestoPagado end AND DP2.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%' and D_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado)
	--Where  (TIN.FechaPago >= @FechaIni and TIN.FechaPago <= @FechaFin)
	order by  TIN.IdNomina
END






