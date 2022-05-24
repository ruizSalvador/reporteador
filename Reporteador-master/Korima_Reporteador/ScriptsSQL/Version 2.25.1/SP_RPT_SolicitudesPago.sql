/****** Object:  StoredProcedure [dbo].[SP_RPT_SolicitudesPago]    Script Date: 05/11/2017 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_SolicitudesPago]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_SolicitudesPago]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_SolicitudesPago]    Script Date: 05/11/2017 09:36:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_SolicitudesPago '20170517','20171231',0
CREATE PROCEDURE [dbo].[SP_RPT_SolicitudesPago] 
  
@FechaInicio as Datetime,
@FechaFin as Datetime,
@IdTipo int

AS
BEGIN

 Declare @Reporte as table (
		NoOrden varchar (20)
      ,TipoOrden varchar(max)
      ,EstatusOrden varchar(50)
	  ,NoFactura varchar(50)
      ,FechaSolicitud datetime
	  ,ConceptoPago varchar(max)
	  ,Beneficiario varchar(max)
	  ,CuentaContable varchar(max)
	  ,UR varchar(max)
	  ,Proyecto varchar(max)
	  ,FF varchar(max)
	  ,TotalOrden Decimal(18,2)
	  ,ChequeTransf int
	  ,CuentaBancaria varchar(max)
	  ,TipoCheque varchar(max)
	  ,PolizaComprometido varchar(100)
	  ,FechaComprometido datetime
	  ,PolizaDevengado varchar(50)
	  ,FechaDevengado datetime
	  ,PolizaEjercido varchar(100)
	  ,FechaEjercido datetime
	  ,PolizaContable varchar(100)
	  ,PolizaPagado varchar(100)
	  ,FechaPagado datetime
	  ,Tipo varchar (10)
	  ,IdChequesAgrupador int
	  ,IdCheque int
	  )


Insert into @Reporte
Select Distinct TSC.folioporTipo as OSOC,
		CASE TipoProveedor 
			WHEN 'P' THEN 'Proveedor'
			WHEN 'C' THEN 'Contratista'
			WHEN 'V' THEN 'Beneficiario'
		END as TipoOrden,
		CASE
	WHEN TC.Status = 'I' AND TC.Entregado = 1 THEN 'Pagado' 
	WHEN TC.Status = 'D' THEN 'Pagado'
	WHEN TC.Status = 'G' THEN 'Pendiente'
	WHEN TC.Status = 'L' AND TC.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN TSC.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as EstatusOrden,
	TRF.Folio as NoFatura,
	TSC.Fecha as FechaSolicitud,	
		TSC.Concepto as ConceptoPago,
		TSC.Beneficiario as Beneficiario,
		CASE TipoProveedor 
			WHEN 'P' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 1))
			WHEN 'C' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 9))
			WHEN 'V' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 1))
		END as CuentaContable,
		(Select Clave + ' ' + Nombre From C_AreaResponsabilidad Where IdAreaResp = (Select IdAreaResp From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DP.IdSelloPresupuestal))) as UR,
		(Select Clave + ' ' + Nombre From C_ProyectosInversion Where PROYECTO = (Select Proyecto From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DP.IdSelloPresupuestal))) as Proyecto,
		(Select Clave + ' ' + Descripcion From C_FuenteFinanciamiento Where IDFUENTEFINANCIAMIENTO = (Select IdFuenteFinanciamiento From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DP.IdSelloPresupuestal))) as FF,
		TSC.Importe as TotalOrden,
		CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select FolioCheque from T_Cheques where IdCheques = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN TC.FolioCheque
	    ELSE TC.FolioCheque  END AS ChequeTransf,
		(Select CCB.CuentaBancaria + '-' + Sucursal) as CuentaBancaria,
		CASE TSC.PorDeposito
			WHEN 1 THEN 'Transferencia'
			WHEN 0 THEN 'Cheque'
		END as TipoCheque,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
		TP.Fecha as FechaComprometido,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		TRF.Fecha as FechaDevengado,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		TSC.FechaAprobacion as FechaEjercido,
		CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
	    (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable,				   
	    CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		CASE WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN TC.Fecha
			 ELSE TC.FechaEntrega END as FechaPagado,
		'OC' as Tipo,
		TC.IdChequesAgrupador,
		TC.IdCheques

FROM T_SolicitudCheques TSC
LEFT JOIN T_RecepcionFacturas TRF
    ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios
LEFT JOIN T_Pedidos TP
   ON TP.IdPedido = TRF.IdPedido
LEFT JOIN D_Pedidos DP
   ON DP.IdPedido = TP.IdPedido
LEFT JOIN C_Proveedores CP
    ON TP.IdProveedor = CP.IdProveedor  
LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TRF.IdPoliza
LEFT JOIN T_AfectacionPresupuesto TAP
	ON TAP.IdMovimiento = TP.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'S' and Cancelacion <> 1
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN C_CuentasBancarias CCB 
	ON CCB.IdCuentaBancaria = TC.IdCuentaBancaria
where (TSC.Fecha >= @FechaInicio and TSC.Fecha <= @FechaFin) AND TP.ConsumibleActivo = CASE WHEN @IdTipo = 0 THEN TP.ConsumibleActivo ELSE @IdTipo END
	--AND TC.Status in ('I','L','D') 

	UNION ALL

 Select Distinct TSC.folioporTipo as OSOC,
		CASE TipoProveedor 
			WHEN 'P' THEN 'Proveedor'
			WHEN 'C' THEN 'Contratista'
			WHEN 'V' THEN 'Beneficiario'
		END as TipoOrden,
		CASE
	WHEN TC.Status = 'I' AND TC.Entregado = 1 THEN 'Pagado' 
	WHEN TC.Status = 'D' THEN 'Pagado'
	WHEN TC.Status = 'G' THEN 'Pendiente'
	WHEN TC.Status = 'L' AND TC.IdChequesAgrupador <> 0 THEN 'Pagado'
	WHEN TSC.Estatus = 'C' THEN 'Pendiente'
	ELSE 'Pendiente' 
END as EstatusOrden,
	TRF.Folio as NoFatura,
	TSC.Fecha as FechaSolicitud,	
		TSC.Concepto as ConceptoPago,
		TSC.Beneficiario as Beneficiario,
		CASE TipoProveedor 
			WHEN 'P' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 1))
			WHEN 'C' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 9))
			WHEN 'V' THEN (Select RTRIM(NumeroCuenta) + '-' + NombreCuenta From C_Contable Where IdCuentaContable =(Select IdCuentaContable from R_CtasContxCtesProvEmp where idproveedor = TRF.IdProveedor and IdTipoCuenta = 1))
		END as CuentaContable,
		(Select Clave + ' ' + Nombre From C_AreaResponsabilidad Where IdAreaResp = (Select IdAreaResp From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DOS.IdSelloPresupuestal))) as UR,
		(Select Clave + ' ' + Nombre From C_ProyectosInversion Where PROYECTO = (Select Proyecto From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DOS.IdSelloPresupuestal))) as Proyecto,
		(Select Clave + ' ' + Descripcion From C_FuenteFinanciamiento Where IDFUENTEFINANCIAMIENTO = (Select IdFuenteFinanciamiento From T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 DOS.IdSelloPresupuestal))) as FF,
		TSC.Importe as TotalOrden,
		CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select FolioCheque from T_Cheques where IdCheques = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN TC.FolioCheque
	    ELSE TC.FolioCheque  END AS ChequeTransf,
		(Select CCB.CuentaBancaria + '-' + Sucursal) as CuentaBancaria,
		CASE TSC.PorDeposito
			WHEN 1 THEN 'Transferencia'
			WHEN 0 THEN 'Cheque'
		END as TipoCheque,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
		TOS.Fecha as FechaComprometido,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		TRF.Fecha as FechaDevengado,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		TSC.FechaAprobacion as FechaEjercido,
		CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		ELSE	
	    (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques)
		END AS PolizaContable,				   
	    CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		CASE WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN TC.Fecha
			 ELSE TC.FechaEntrega END as FechaPagado,
		'OS' as Tipo,
		TC.IdChequesAgrupador,
		TC.IdCheques

FROM T_SolicitudCheques TSC
LEFT JOIN T_RecepcionFacturas TRF
    ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios
LEFT JOIN T_OrdenServicio TOS
   ON TOS.IdOrden = TRF.IdOrden
LEFT JOIN D_OrdenServicio DOS
   ON DOS.IdOrden = TOS.IdOrden
LEFT JOIN C_Proveedores CP
    ON TOS.IdProveedor = CP.IdProveedor  
LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TRF.IdPoliza
LEFT JOIN T_AfectacionPresupuesto TAP
	ON TAP.IdMovimiento = TOS.Idorden and TipoAfectacion = 'C' and TipoMovimientoGenera = 'S' and Cancelacion <> 1
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN C_CuentasBancarias CCB 
	ON CCB.IdCuentaBancaria = TC.IdCuentaBancaria
where (TSC.Fecha >= @FechaInicio and TSC.Fecha <= @FechaFin)
	AND TOS.IdTipoOrdenServicio = CASE WHEN @IdTipo = 0 THEN TOS.IdTipoOrdenServicio ELSE @IdTipo END
	--AND TC.Status in ('I','L','D')

Select * From @Reporte Where IdCheque not in (Select Distinct IdChequesAgrupador From @Reporte Where IdChequesAgrupador <> 0)
						OR IdCheque is null
		
End

EXEC SP_FirmasReporte 'Reporte de Solicitudes de Pago'
GO
Exec SP_CFG_LogScripts 'SP_RPT_SolicitudesPago'
GO