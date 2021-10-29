/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Comprobaciones]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Anexo_Comprobaciones]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Anexo_Comprobaciones]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo_Comprobaciones]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Anexo_Comprobaciones '20210203','20210203',0,0
CREATE PROCEDURE [dbo].[RPT_SP_Anexo_Comprobaciones]
 
@FechaIni as DateTime,
@FechaFin as DateTime,
@IdProv as int,
@TipoMov as int

AS
BEGIN

Select  
TV.Folio as OCOS,
--TV.IdViaticos,
 YEAR(@FechaIni) as Ejercicio,

		(Select RFC from RPT_CFG_DatosEntes) as RFCEnte,
		(Select Nombre from RPT_CFG_DatosEntes) as RSEnte,
	 TSC.FolioPorTipo as SolicitudEgreso,
	 --CASE  
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
		--	WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	 --   ELSE
		--(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		--END AS PolizaPagado,
		CAST(POLPAG.TipoPoliza as varchar(10)) + ' '  + CAST(POLPAG.Periodo as varchar (5)) + ' ' + CAST(POLPAG.NoPoliza as varchar (50))  as PolizaPagado,

		--CASE 
		--	WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
		--	WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		--ELSE	
	 --   (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		--END AS PolizaPagado,
		--(Select Fecha from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) AS FechaPolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
		'' EstatusPolPagado,
	    (Select TotalCargos from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS ImportePolPagado,
		CCE.NumeroCuenta as CuentaDeudor,
		CCE.NombreCuenta NombreCuentaDeudor,
		'' as ComprobanteBancario,
		CCB.CuentaBancaria as CuentaDepositante,
		CB.NombreBanco BancoDepositante,
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
		TC.IdPolizaCancelacion as IdCancelacion,
		ISNULL(DP.ImporteCargo,0) as ImportePolDiario,
		CASE WHEN TC.ImporteCheque is null THEN 0
		ELSE ISNULL(TC.ImporteCheque,0) - (Select ISNULL(SUM(ImporteCargo),0) from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '5%' Where IdPoliza = TV.IdPoliza) END as ImporteDevuelto,
		--ISNULL(TC.ImporteCheque,0) -  ISNULL(SUM(DP.ImporteCargo),0)  as ImporteDevuelto,
		null as CuentaImporteDevuelto,
		null as PolImpDevuelto,
		null as FechaPolImpDevuelto,
	    
		 
		-- CAST(PDEV.TipoPoliza as varchar(10)) + ' '  + CAST(PDEV.Periodo as varchar (5)) + ' ' + CAST(PDEV.NoPoliza as varchar (50))  as PolizaDevengado,
		--PDEV.Fecha as FechaPolizaDevengado,
	--'' as EstatusPolDevengado,
	--CFF.CLAVE as FF,

			
		ISNULL(DP2.ImporteCargo,0) as ImportePolPagado,
		
		--'' AS ComprobanteBancario,
		--TC.Fecha as FechaCheque,
		
		TC.CuentaADepositar as CuentaBancariaProv,
		--CBPROV.NombreBanco as BancoProv,
		TC.ImporteCheque as MontoPagado

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
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status in ('D','I')
LEFT JOIN R_CtasContxCtesProvEmp RCTAS	
	ON RCTAS.NumeroEmpleado = TV.NumeroEmpleado
LEFT JOIN C_Contable CCE
	ON CCE.IdCuentaContable = RCTAS.IdCuentaContable

LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TV.IdPoliza
	LEFT JOIN D_Polizas DP ON DP.IdPoliza = TPOL.IdPoliza AND DP.IdCuentaContable in (Select D_Polizas.IdCuentaContable from D_Polizas join C_Contable on D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable AND NumeroCuenta like '5%' and D_Polizas.IdPoliza = TPOL.IdPoliza)
	--ON DP.IdPoliza = TPOL.IdPoliza


LEFT JOIN C_Proveedores CP
    ON DV.IdProveedor = CP.IdProveedor 
--LEFT JOIN C_Contable on C_Contable.IdCuentaContable = DV.IdCuentaContable AND NumeroCuenta like '825%'
LEFT JOIN T_SellosPresupuestales As TS  ON DV.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	
	LEFT JOIN T_Polizas POLPAG ON POLPAG.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end

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
--Where TV.Folio > 0
Where  (TV.Fecha >= @FechaIni and TV.Fecha <= @FechaFin)
AND CP.IdProveedor = CASE WHEN @IdProv = 0 THEN CP.IdProveedor ELSE @IdProv END

Group by TV.Folio,
TSC.FolioPorTipo, 
TC.IdChequesAgrupador, 
TC.FolioCheque, 
TC.IdPolizaPresupuestoPagado, 
TC.Status, 
TC.Entregado,
CCE.NumeroCuenta, 
CCE.NombreCuenta,
CCB.CuentaBancaria,
CB.NombreBanco, 
CB2.CuentaBancaria, 
CBPROV.NombreBanco, 
TC.ImporteCheque,
CP.RFC, 
CP.RazonSocial, 
TV.Justificacion,
TRF.FolioFiscal, 
TRF.FechaFactura,
TRF.Total,
C2.NumeroCuenta,
TS.Sello, 
TS.IdPartida,
CG.IdCapitulo,
CFF.CLAVE, 
CFF.DESCRIPCION, 
TPOL.TipoPoliza, 
TPOL.Periodo, 
TPOL.NoPoliza,
TPOL.Fecha,
TC.IdPolizaCancelacion,
DP.ImporteCargo ,
DP2.ImporteCargo, 
TC.CuentaADepositar,
TV.IdPoliza,
TSC.Importe,
POLPAG.Periodo,
POLPAG.NoPoliza,
POLPAG.TipoPoliza

order by TV.Folio
END
