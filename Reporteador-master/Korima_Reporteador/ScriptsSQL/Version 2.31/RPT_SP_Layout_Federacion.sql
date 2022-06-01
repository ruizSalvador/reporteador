/****** Object:  StoredProcedure [dbo].[RPT_SP_Layout_Federacion]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Layout_Federacion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Layout_Federacion]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Layout_Federacion]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Layout_Federacion '20211021','20211021',0,0
CREATE PROCEDURE [dbo].[RPT_SP_Layout_Federacion]
 
@FechaIni as DateTime,
@FechaFin as DateTime,
@IdProv as int,
@TipoMov as int

AS
BEGIN

Select  YEAR(@FechaIni) as Ejercicio,
--TP.Folio as OSOC,
	CP.RFC as RFCProv,
		CP.RazonSocial as RSProveedor,
		CP.Domicilio DomProv,
		CP.CP as CPProv,
		(Select RFC from RPT_CFG_DatosEntes) as RFCEnte,
		(Select Nombre from RPT_CFG_DatosEntes) as RSEnte,
		TP.Folio as OCOS,
		TSol.Folio as Requisicion,
		TSC.FolioPorTipo as SolicitudPago,
		TSC.FolioDesconcentrado as NoAprobacion,
		CAST(PEJER.TipoPoliza as varchar(10)) + ' '  + CAST(PEJER.Periodo as varchar (5)) + ' ' + CAST(PEJER.NoPoliza as varchar (50))  as PolizaAprob,
		PEJER.Fecha as FechaPolizaAprob,
		'' as EstatusPolAprob,
		CTCOM.Descripcion as TipoAdj,

		TCON.Codigo as Contrato,
		CPROVCONT.RazonSocial as RSContrato,
		TCON.Definicion as DescripcionCont,
		TP.Fecha as FechaOCOS,
		TCON.ImporteActual as MontoContratado,
		'' as ConvenioMod,
		'' as MontoConvenido,
		'' as FechaConv,
	
		TP.Observaciones as DescripcionBien,
		
		TRF.Factura as Factura,
		TRF.FolioFiscal,
		TRF.FechaFactura,
		TRF.Total as MontoFacturado,

		TS.IdPartida as PartidaClas,
		CG.IdCapitulo as Capitulo,

		-- CAST(PCOMP.TipoPoliza as varchar(10)) + ' '  + CAST(PCOMP.Periodo as varchar (5)) + ' ' + CAST(PCOMP.NoPoliza as varchar (50)) as PolizaComprometido,
		--PCOMP.Fecha as FechaPolizaComprometido,  
		'' as PolEgreAnticipo,
		'' as FechaPolEgreAnticipo,
		'' as EstatusPolEgreAnticipo,
		DP.ImporteCargo as ImportePolDevengado,
		 
		 CAST(PDEV.TipoPoliza as varchar(10)) + ' '  + CAST(PDEV.Periodo as varchar (5)) + ' ' + CAST(PDEV.NoPoliza as varchar (50))  as PolizaDevengado,
		PDEV.Fecha as FechaPolizaDevengado,
	'' as EstatusPolDevengado,
	CFF.CLAVE as FF,

		(Select ImporteCargo from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%'  and D_Polizas.IdSelloPresupuestal = DP.IdSelloPresupuestal and IdPoliza = TC.IdPolizaPresupuestoPagado) as ImportePolPagado,
		
		--ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
	 --   CASE  
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	 --   ELSE
		--(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		--END AS PolizaPagado,
		CAST(POLPAG.TipoPoliza as varchar(10)) + ' '  + CAST(POLPAG.Periodo as varchar (5)) + ' ' + CAST(POLPAG.NoPoliza as varchar (50))  as PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		'' as EstatusPolPagado,

		'' AS ComprobanteBancario,
		TC.Fecha as FechaCheque,
		CCB.CuentaBancaria,
		CB.NombreBanco,
		TC.CuentaADepositar as CuentaBancariaProv,
		CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as MontoPagado
		
		--'OC' as Tipo
		--,DP.IdSelloPresupuestal
		--,TC.IdPolizaPresupuestoPagado 
FROM T_Pedidos TP
LEFT JOIN C_Proveedores CP
    ON TP.IdProveedor = CP.IdProveedor 
LEFT JOIN T_RecepcionFacturas TRF 
	ON TP.IdPedido = TRF.IdPedido and TRF.IdPoliza<>0 
LEFT JOIN T_Solicitudes TSol 
ON TSol.IdSolicitud = TP.IdSolicitud
LEFT JOIN C_TiposCompra CTCOM
ON CTCOM.IdTipoCompra = TP.IdTipoCompra


LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
--LEFT JOIN T_Polizas TPOL
--	ON TPOL.IdPoliza = TRF.IdPoliza
--LEFT JOIN T_AfectacionPresupuesto TAP
--	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' and Cancelacion <> 1
--LEFT JOIN T_Polizas PCOMP
--	ON PCOMP.IdPoliza = TP.IdPoliza
LEFT JOIN T_Polizas PDEV
	ON PDEV.IdPoliza = TRF.IdPoliza and PDEV.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PDEV.IdTipoMovimiento ELSE @TipoMov END
LEFT JOIN T_Polizas PEJER
	ON PEJER.IdPoliza = TSC.IdPolizaPresupuestoEjercido --and PEJER.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PEJER.IdTipoMovimiento ELSE @TipoMov END

LEFT JOIN D_Polizas DP ON DP.IdPoliza = PDEV.IdPoliza AND DP.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '825%' and D_Polizas.IdPoliza = PDEV.IdPoliza)

LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status in ('D','I')
LEFT JOIN T_SolicitudCheques TSC1 
    on TP.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
LEFT JOIN T_Cheques TCH  
    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos)

	LEFT JOIN T_Polizas POLPAG ON POLPAG.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end

--Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
--CASE 
--WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
--ELSE TC.IdPolizaPresupuestoPagado end AND DP2.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%' where IdPoliza = 16017
--)


LEFT JOIN T_Contratos TCON ON TP.IdContrato = TCON.Contrato
LEFT JOIN C_Proveedores CPROVCONT 
ON TCON.IdProveedor = CPROVCONT.IdProveedor  
LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar
where 
--TP.Fecha >= '20210101' and TP.Fecha <= '20211231'
(TP.Fecha >= @FechaIni and TP.Fecha <= @FechaFin)
--AND PDEV.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PDEV.IdTipoMovimiento ELSE @TipoMov END
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END

Group by CP.RFC, CP.RazonSocial, CP.Domicilio, CP.CP, TP.Folio, TSOL.Folio, TSC.FolioPorTipo, TSC.FolioDesconcentrado, 
PDEV.TipoPoliza, PDEV.Periodo, PDEV.NoPoliza, PEJER.TipoPoliza, PEJER.Periodo, PEJER.NoPoliza, PEJER.Fecha,
PDEV.Periodo, PDEV.TipoPoliza, PDEV.NoPoliza, CTCOM.Descripcion, TCON.Codigo, CPROVCONT.RazonSocial, TCON.Definicion, TP.Fecha, TP.Observaciones, 
TRF.Factura, TRF.FolioFiscal, TRF.FechaFactura, TRF.Total, TS.IdPartida, CG.IdCapitulo, DP.ImporteCargo, PDEV.Fecha, CFF.CLAVE, --DP2.ImporteCargo,
POLPAG.TipoPoliza, POLPAG.NoPoliza, POLPAG.Periodo, TC.IdPolizaPresupuestoPagado, TC.Fecha, CCB.CuentaBancaria, CB.NombreBanco, TC.CuentaADepositar,
CBPROV.NombreBanco, TC.ImporteCheque, TCON.ImporteActual, DP.IdSelloPresupuestal


UNION ALL

Select  YEAR(@FechaIni) as Ejercicio,
--TP.Folio as OSOC,
	CP.RFC as RFCProv,
		CP.RazonSocial as RSProveedor,
		CP.Domicilio DomProv,
		CP.CP as CPProv,
		(Select RFC from RPT_CFG_DatosEntes) as RFCEnte,
		(Select Nombre from RPT_CFG_DatosEntes) as RSEnte,
		TOS.Folio as OCOS,
		TSol.Folio as Requisicion,
		TSC.FolioPorTipo as SolicitudPago,
		TSC.FolioDesconcentrado as NoAprobacion,
		CAST(PEJER.TipoPoliza as varchar(10)) + ' '  + CAST(PEJER.Periodo as varchar (5)) + ' ' + CAST(PEJER.NoPoliza as varchar (50))  as PolizaAprob,
		PEJER.Fecha as FechaPolizaAprob,
		'' as EstatusPolAprob,
		CTCOM.Descripcion as TipoAdj,

		TCON.Codigo as Contrato,
		CPROVCONT.RazonSocial as RSContrato,
		TCON.Definicion as DescripcionCont,
		TOS.Fecha as FechaOCOS,
		TCON.ImporteActual as MontoContratado,
		'' as ConvenioMod,
		'' as MontoConvenido,
		'' as FechaConv,
	
		TOS.Observaciones as DescripcionBien,
		
		--TRF.Serie+' '+TRF.Factura as Factura,
		TRF.Factura as Factura,
		TRF.FolioFiscal,
		TRF.FechaFactura,
		TRF.Total as MontoFacturado,

		TS.IdPartida as PartidaClas,
		CG.IdCapitulo as Capitulo,

		-- CAST(PCOMP.TipoPoliza as varchar(10)) + ' '  + CAST(PCOMP.Periodo as varchar (5)) + ' ' + CAST(PCOMP.NoPoliza as varchar (50)) as PolizaComprometido,
		--PCOMP.Fecha as FechaPolizaComprometido,  
		'' as PolEgreAnticipo,
		'' as FechaPolEgreAnticipo,
		'' as EstatusPolEgreAnticipo,
		DP.ImporteCargo as ImportePolDevengado,
		 
		 CAST(PDEV.TipoPoliza as varchar(10)) + ' '  + CAST(PDEV.Periodo as varchar (5)) + ' ' + CAST(PDEV.NoPoliza as varchar (50))  as PolizaDevengado,
		PDEV.Fecha as FechaPolizaDevengado,
	'' as EstatusPolDevengado,
	CFF.CLAVE as FF,

	(Select ImporteCargo from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%'  and D_Polizas.IdSelloPresupuestal = DP.IdSelloPresupuestal and IdPoliza = TC.IdPolizaPresupuestoPagado) as ImportePolPagado,
		
		--ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
	 --   CASE  
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	 --   ELSE
		--(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		--END AS PolizaPagado,
		CAST(POLPAG.TipoPoliza as varchar(10)) + ' '  + CAST(POLPAG.Periodo as varchar (5)) + ' ' + CAST(POLPAG.NoPoliza as varchar (50))  as PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		'' as EstatusPolPagado,

		'' AS ComprobanteBancario,
		TC.Fecha as FechaCheque,
		CCB.CuentaBancaria,
		CB.NombreBanco,
		TC.CuentaADepositar as CuentaBancariaProv,
		CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as MontoPagado
		
		--'OS' as Tipo
		--,DP.IdSelloPresupuestal
		--,TC.IdPolizaPresupuestoPagado 
FROM T_OrdenServicio TOS
LEFT JOIN C_Proveedores CP
    ON TOS.IdProveedor = CP.IdProveedor 
LEFT JOIN T_RecepcionFacturas TRF 
	ON TOS.IdOrden = TRF.IdOrden and TRF.IdPoliza<>0 
LEFT JOIN T_Solicitudes TSol 
ON TSol.IdSolicitud = TOS.IdSolicitud
LEFT JOIN C_TiposCompra CTCOM
ON CTCOM.IdTipoCompra = TOS.IdTipoCompra


LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
--LEFT JOIN T_Polizas TPOL
--	ON TPOL.IdPoliza = TRF.IdPoliza
--LEFT JOIN T_AfectacionPresupuesto TAP
--	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' and Cancelacion <> 1
--LEFT JOIN T_Polizas PCOMP
--	ON PCOMP.IdPoliza = TOS.IdPoliza
LEFT JOIN T_Polizas PDEV
	ON PDEV.IdPoliza = TRF.IdPoliza and PDEV.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PDEV.IdTipoMovimiento ELSE @TipoMov END
LEFT JOIN T_Polizas PEJER
	ON PEJER.IdPoliza = TSC.IdPolizaPresupuestoEjercido --and PEJER.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PEJER.IdTipoMovimiento ELSE @TipoMov END

LEFT JOIN D_Polizas DP ON DP.IdPoliza = PDEV.IdPoliza AND DP.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '825%' and D_Polizas.IdPoliza = PDEV.IdPoliza)

LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status in ('D','I')
LEFT JOIN T_SolicitudCheques TSC1 
    on TOS.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
LEFT JOIN T_Cheques TCH  
    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos)

	LEFT JOIN T_Polizas POLPAG ON POLPAG.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end
--Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
--CASE 
--WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
--ELSE TC.IdPolizaPresupuestoPagado end AND DP2.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%' and D_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado)


LEFT JOIN T_Contratos TCON ON TOS.IdContrato = TCON.Contrato
LEFT JOIN C_Proveedores CPROVCONT 
ON TCON.IdProveedor = CPROVCONT.IdProveedor  
LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar
where 
--TP.Fecha >= '20210101' and TP.Fecha <= '20211231'
(TOS.Fecha >= @FechaIni and TOS.Fecha <= @FechaFin)
--AND PDEV.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PDEV.IdTipoMovimiento ELSE @TipoMov END
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END

Group by CP.RFC, CP.RazonSocial, CP.Domicilio, CP.CP, TOS.Folio, TSOL.Folio, TSC.FolioPorTipo, TSC.FolioDesconcentrado, 
PDEV.TipoPoliza, PDEV.Periodo, PDEV.NoPoliza, PEJER.TipoPoliza, PEJER.Periodo, PEJER.NoPoliza, PEJER.Fecha,
PDEV.Periodo, PDEV.TipoPoliza, PDEV.NoPoliza, CTCOM.Descripcion, TCON.Codigo, CPROVCONT.RazonSocial, TCON.Definicion, TOS.Fecha, TOS.Observaciones, 
TRF.Factura, TRF.FolioFiscal, TRF.FechaFactura, TRF.Total, TS.IdPartida, CG.IdCapitulo, DP.ImporteCargo, PDEV.Fecha, CFF.CLAVE, --DP2.ImporteCargo,
POLPAG.TipoPoliza, POLPAG.NoPoliza, POLPAG.Periodo, TC.IdPolizaPresupuestoPagado, TC.Fecha, CCB.CuentaBancaria, CB.NombreBanco, TC.CuentaADepositar,
CBPROV.NombreBanco, TC.ImporteCheque, TCON.ImporteActual ,DP.IdSelloPresupuestal
	

END

