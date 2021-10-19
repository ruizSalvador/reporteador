Select  
TV.Folio as OCOS,
--TV.IdViaticos,
--YEAR(@FechaIni) as Ejercicio,
--TP.Folio as OSOC,
	--CP.RFC as RFCProv,
	--	CP.RazonSocial as RSProveedor,
	--	CP.Domicilio DomProv,
	--	CP.CP as CPProv,
		(Select RFC from RPT_CFG_DatosEntes) as RFCEnte,
		(Select Nombre from RPT_CFG_DatosEntes) as RSEnte,
	 TSC.FolioPorTipo as SolicitudEgreso,
	 CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		'' EstatusPolPagado,
	    (Select TotalCargos from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS ImportePolPagado,
		CCE.NumeroCuenta as CuentaDeudor,
		CCE.NombreCuenta NombreCuentaDeudor,
		'' as ComprobanteBancario,
		CCB.CuentaBancaria as CuentaDepositante,
		CB.NombreBanco NombreCtaDepositante,
		CB2.CuentaBancaria as CtaProv,
		CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as ImportePagado,
		CP.RFC as RFCProv,
	    CP.RazonSocial as RSProveedor,
		TV.Justificacion as DescripcionBien,
		TRF.FolioFiscal,
		TRF.FechaFactura,
		TRF.Total as MontoFacturado,
		C2.NumeroCuenta as CuentaPagado,
		TS.Sello,
		TS.IdPartida as PartidaClas,
		CG.IdCapitulo as Capitulo,
		CFF.CLAVE as FF,
		CFF.DESCRIPCION as DesFF,
		 CAST(TPOL.TipoPoliza as varchar(10)) + ' '  + CAST(TPOL.Periodo as varchar (5)) + ' ' + CAST(TPOL.NoPoliza as varchar (50)) as PolizaDiario,
		TPOL.Fecha as FechaPolDiario, 
		'' as cancel,
		ISNULL(DP.ImporteCargo,0) as ImportePolDiario,
		(Select ISNULL(SUM(ImporteCargo),0) from D_Polizas Where IdPoliza = TV.IdPoliza) as ImporteDevuelto,
		--TSol.Folio as Requisicion,
		--TSC.FolioPorTipo as SolicitudPago,
		--TSC.FolioDesconcentrado as NoAprobacion,
		--CAST(PEJER.TipoPoliza as varchar(10)) + ' '  + CAST(PEJER.Periodo as varchar (5)) + ' ' + CAST(PEJER.NoPoliza as varchar (50))  as PolizaAprob,
		--PEJER.Fecha as FechaPolizaAprob,
		--'' as EstatusPolAprob,
		--CTCOM.Descripcion as TipoAdj,


	    
		 
		-- CAST(PDEV.TipoPoliza as varchar(10)) + ' '  + CAST(PDEV.Periodo as varchar (5)) + ' ' + CAST(PDEV.NoPoliza as varchar (50))  as PolizaDevengado,
		--PDEV.Fecha as FechaPolizaDevengado,
	--'' as EstatusPolDevengado,
	--CFF.CLAVE as FF,

			
		--ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
		
		--'' AS ComprobanteBancario,
		--TC.Fecha as FechaCheque,
		
		TC.CuentaADepositar as CuentaBancariaProv,
		--CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as MontoPagado
		
		--'OC' as Tipo
		--,DP.IdSelloPresupuestal
		--,TC.IdPolizaPresupuestoPagado 
FROM T_Viaticos TV
 JOIN D_Viaticos DV ON TV.IdViaticos = DV.IdViatico
LEFT JOIN T_RecepcionFacturas TRF 
	ON TV.IdViaticos = TRF.IdViaticos and TRF.IdPoliza<>0 
--LEFT JOIN T_Solicitudes TSol 
--ON TSol.IdSolicitud = TP.IdSolicitud
LEFT JOIN C_TiposCompra CTCOM
ON CTCOM.IdTipoCompra = TV.IdTipoCompra


LEFT JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = TV.IdSolicitudChequesOriginal
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN R_CtasContxCtesProvEmp RCTAS	
	ON RCTAS.NumeroEmpleado = TV.NumeroEmpleado
LEFT JOIN C_Contable CCE
	ON CCE.IdCuentaContable = RCTAS.IdCuentaContable

LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TV.IdPoliza
Left JOIN D_Polizas DP 
	ON DP.IdPoliza = TPOL.IdPoliza

--LEFT JOIN T_AfectacionPresupuesto TAP
--	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' and Cancelacion <> 1
--LEFT JOIN T_Polizas PCOMP
--	ON PCOMP.IdPoliza = TP.IdPoliza
--LEFT JOIN T_Polizas PDEV
--	ON PDEV.IdPoliza = TRF.IdPoliza
--LEFT JOIN T_Polizas PEJER
--	ON PEJER.IdPoliza = TSC.IdPolizaPresupuestoEjercido


LEFT JOIN C_Proveedores CP
    ON DV.IdProveedor = CP.IdProveedor 
--LEFT JOIN C_Contable on C_Contable.IdCuentaContable = DV.IdCuentaContable AND NumeroCuenta like '825%'
LEFT JOIN T_SellosPresupuestales As TS  ON DV.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	
--LEFT JOIN T_Cheques TC
--	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
--LEFT JOIN T_SolicitudCheques TSC1 
--    on TP.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
--LEFT JOIN T_Cheques TCH  
--    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos)

Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
ELSE TC.IdPolizaPresupuestoPagado end AND DP2.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '827%' and D_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado)
LEFT JOIN C_Contable C2 on C2.IdCuentaContable = DP2.IdCuentaContable

--LEFT JOIN T_Contratos TCON ON TP.IdContrato = TCON.Contrato
--LEFT JOIN C_Proveedores CPROVCONT 
--ON TCON.IdProveedor = CPROVCONT.IdProveedor  
LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco

LEFT JOIN C_CuentasBancarias CB2
on TC.IdBancoADespositar= CB2.IdCuentaBancaria
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar
Where TV.Folio > 0
AND YEAR(TV.Fecha) = 2021
--Group by TV.Folio,TSC.FolioPorTipo, TC.IdChequesAgrupador, TC.FolioCheque, TC.IdPolizaPresupuestoPagado, TC.Status, TC.Entregado, CCE.NumeroCuenta, CCE.NombreCuenta,
--CCB.CuentaBancaria, CB.NombreBanco, CB2.CuentaBancaria, CBPROV.NombreBanco, TC.ImporteCheque, CP.RFC, CP.RazonSocial, TV.Justificacion, TRF.FolioFiscal, TRF.FechaFactura, TRF.Total,
--C2.NumeroCuenta, TS.Sello, TS.IdPartida, CG.IdCapitulo, CFF.CLAVE, CFF.DESCRIPCION, TPOL.TipoPoliza, TPOL.Periodo, TPOL.NoPoliza, TPOL.Fecha,
--DP.ImporteCargo, DP2.ImporteCargo, TC.CuentaADepositar

order by TV.Folio
--where 
--TP.Fecha >= '20210101' and TP.Fecha <= '20211231'
--TP.Fecha >= @FechaIni and TP.Fecha <= @FechaFin
--AND PDEV.IdTipoMovimiento = CASE WHEN @TipoMov = 0 THEN PDEV.IdTipoMovimiento ELSE @TipoMov END
--AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END
--Select * from T_Viaticos

--Select * from T_Polizas where TipoPoliza = 'E'
--Select * from T_Viaticos where folio = 1
--Select * from D_Viaticos where IdViatico in (2,3)