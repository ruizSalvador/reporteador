Select  YEAR(GETDATE()) as Ejercicio,
--TP.Folio as OSOC,
	CP.RFC as RFCProv,
		CP.RazonSocial as RSProveedor,
		CP.Domicilio DomProv,
		CP.CP as CPProv,
		(Select RFC from RPT_CFG_DatosEntes) as RFCEnte,
		(Select Nombre from RPT_CFG_DatosEntes) as RSEnte,
		TP.Folio as OCOS,
		TSol.Folio as Requisición,
		TSC.FolioPorTipo as SolicitudPago,
		TSC.FolioDesconcentrado as NoAprobación,
		CAST(PEJER.TipoPoliza as varchar(10)) + ' '  + CAST(PEJER.Periodo as varchar (5)) + ' ' + CAST(PEJER.NoPoliza as varchar (50))  as PolizaAprob,
		PEJER.Fecha as FechaPolizaAprob,
		'' as EstatusPolAprob,
		CTCOM.Descripcion as TipoAdj,

		TCON.Codigo as Contrato,
		CPROVCONT.RazonSocial as RSContrato,
		TCON.Definicion as DescripcionCont,
		TP.Fecha as FechaOCOS,
		0 as MontoContratado,
		'' as ConvenioMod,
		'' as MontoConvenido,
		'' as FechaConv,
		--TP.TotalGral as Importe,
		--CASE TP.Estatus
		--WHEN 'C' THEN 'Cancelado'
		--WHEN 'R' THEN 'Recibido'
		--WHEN 'P' THEN 'Pedido'
		--WHEN 'L' THEN 'Consolidado'
		--WHEN 'I' THEN 'Parcial'
		--WHEN 'A' THEN 'Aprobado'
		--END as Estatus,
		TP.Observaciones as DescripcionBien,
		
		TRF.Serie+' '+TRF.Factura as Factura,
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

		--(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques) as PolizaAnticipo,
		--CASE 
		--	WHEN TCH.FolioCheque = 0 AND TCH.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdChequesAgrupador)
		--	WHEN TCH.FolioCheque = 0 AND TCH.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		--ELSE	
	 --   (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		--END AS PolizaAnticipo,
		--(Select Fecha from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques) as FechaPolizaAnticipo,
		--ISNULL((TP.Anticipo),0) as Anticipo,
		--TSC.Fecha as FechaSolicitud,

		

		-- CAST(PEJER.TipoPoliza as varchar(10)) + ' '  + CAST(PEJER.Periodo as varchar (5)) + ' ' + CAST(PEJER.NoPoliza as varchar (50))  as PolizaEjercido,
		--PEJER.Fecha as FechaPolizaEjercido,
		--CASE WHEN PEJER.[Status] = 'C' THEN 'CANCELADA'
		--ELSE 'ACTIVA'
		--END as EstatusPolEgreso,
		--PEJER.IdPoliza,

		 --TSC.FolioDesconcentrado as Aprobacion,
	  --  CASE 
			--WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select FolioCheque from T_Cheques where IdCheques = TC.IdChequesAgrupador)
			--WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN TC.FolioCheque
	  --  ELSE TC.FolioCheque  END AS ChequeTransf,

		--CASE 
		--	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
		--	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		--ELSE	
	 --   (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		--END AS PolizaContable,	
		--	(Select Fecha from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) AS FechaPolizaContable,
			
		ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
	    CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		'' as EstatusPolPagado,
		--CASE WHEN TC.FolioCheque = 0 THEN 'TRANSFERENCIA'
		--ELSE CAST(TC.FolioCheque as varchar(100))
		--END AS ComprobanteBancario,
		'' AS ComprobanteBancario,
		TC.Fecha as FechaCheque,
		CCB.CuentaBancaria,
		CB.NombreBanco,
		TC.CuentaADepositar as CuentaBancariaProv,
		CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as MontoPagado,
		--CASE TC.Status
		--	When 'G' THEN 'No generado'
		--	When 'C' THEN 'Por imprimir'
		--	When 'I' THEN 'Impreso'
		--	When 'D' THEN 'Aplicado'
		--	When 'N' THEN 'Cancelado'
		--	When 'L' THEN 'Consolidado'
		--Else '' END as EstatusCheque,
		'OC' as Tipo
		--,DP.IdSelloPresupuestal
		,TC.IdPolizaPresupuestoPagado 
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
LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TRF.IdPoliza
--LEFT JOIN T_AfectacionPresupuesto TAP
--	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' and Cancelacion <> 1
LEFT JOIN T_Polizas PCOMP
	ON PCOMP.IdPoliza = TP.IdPoliza
LEFT JOIN T_Polizas PDEV
	ON PDEV.IdPoliza = TRF.IdPoliza
LEFT JOIN T_Polizas PEJER
	ON PEJER.IdPoliza = TSC.IdPolizaPresupuestoEjercido

LEFT JOIN D_Polizas DP ON DP.IdPoliza = PDEV.IdPoliza
JOIN C_Contable on C_Contable.IdCuentaContable = DP.IdCuentaContable AND NumeroCuenta like '825%'
LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento

--LEFT JOIN D_Polizas DP2 ON DP2.IdPoliza = TC.IdPolizaPresupuestoPagado
--LEFT JOIN C_Contable C2 on C2.IdCuentaContable = DP2.IdCuentaContable AND C2.NumeroCuenta like '827%'
	
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN T_SolicitudCheques TSC1 
    on TP.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
LEFT JOIN T_Cheques TCH  
    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos)

Left JOIN D_Polizas DP2 ON DP2.IdPoliza = --TC.IdPolizaPresupuestoPagado 
CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null
ELSE TC.IdPolizaPresupuestoPagado end
 LEFT JOIN C_Contable C2 on C2.IdCuentaContable = DP2.IdCuentaContable AND C2.NumeroCuenta like '827%'

LEFT JOIN T_Contratos TCON ON TP.IdContrato = TCON.Contrato
LEFT JOIN C_Proveedores CPROVCONT 
ON TCON.IdProveedor = CPROVCONT.IdProveedor  
LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar
where TP.Fecha >= '20210101' and TP.Fecha <= '20211231'
--AND TP.Folio = 656
	
	--AND TC.Status <> 'L' 
--Group by TC.IdChequesAgrupador, TP.Folio, CP.RazonSocial, CP.RFC, TP.TotalGral, TP.Estatus, TRF.Serie, TRF.Factura, TRF.IdPoliza, TRF.FechaFactura,TP.IdPoliza,
--TSC.Fecha, TSC.FolioPorTipo, TSC.IdPolizaPresupuestoEjercido, TSC.FolioDesconcentrado, TC.FolioCheque, TC.Status, TC.IdCheques,
--TC.IdPolizaPresupuestoPagado, TC.Entregado, TP.Anticipo,TCH.IdCheques,TPOL.Fecha, TCH.IdChequesAgrupador, TCH.FolioCheque, TCH.Status,--TRF.IdObraPago
--PCOMP.TipoPoliza, PCOMP.Periodo, PCOMP.NoPoliza,PCOMP.Fecha,
--PDEV.TipoPoliza, PDEV.Periodo, PDEV.NoPoliza,PDEV.Fecha,
--PEJER.TipoPoliza, PEJER.Periodo, PEJER.NoPoliza,PEJER.Fecha,
--PEJER.IdPoliza, DP.IdSelloPresupuestal, TP.Observaciones, TRF.Total, CFF.CLAVE,
--TCON.Codigo, PDEV.[Status], PEJER.[Status], TC.Fecha, CCB.CuentaBancaria, CB.NombreBanco, TC.CuentaADepositar,
--CBPROV.NombreBanco, TC.ImporteCheque
--order by PEJER.IdPoliza

--Select * from T_Polizas where Idpoliza = 1258
--Select * from D_Polizas where Idpoliza = 1258
--update D_Polizas set IdSelloPresupuestal = 4198 where IdDPoliza = 24804
--Select * from T_SellosPresupuestales where IdSelloPresupuestal = 4198

--Select * from T_SolicitudCheques
--Select * from D_DepositosaBancos