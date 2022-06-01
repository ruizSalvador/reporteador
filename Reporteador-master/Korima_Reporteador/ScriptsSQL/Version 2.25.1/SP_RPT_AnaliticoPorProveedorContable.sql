/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoPorProveedorContable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoPorProveedorContable]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_AnaliticoPorProveedorContable '20170101','20171231',0,0,0,1
CREATE PROCEDURE [dbo].[SP_RPT_AnaliticoPorProveedorContable] 
  
@FechaInicio as Datetime,
@FechaFin as Datetime,
@Proveedor as int,
@FolioServicio as int,
@FolioCompra as int,
@Cancelados as bit

AS
BEGIN
 Declare @tabla as table (
		OSOC varchar (20)
      ,Proveedor varchar(max)
      ,Importe Decimal(18,2)
	  ,Estatus varchar(50)
      ,PolizaComprometido varchar(50)
	  ,Factura varchar(50)
	  ,PolizaDevengado varchar(50)
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,PolizaPagado varchar(50)
	  ,EstatusCheque varchar(max)
	  ,Tipo varchar (10)
	  ,ForSum varchar (150)	  
      )

 Declare @OC as table (
		OSOC varchar (20)
      ,Proveedor varchar(max)
      ,Importe Decimal(18,2)
	  ,Estatus varchar(50)
      ,PolizaComprometido varchar(50)
	  ,Factura varchar(50)
	  ,PolizaDevengado varchar(50)
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,PolizaPagado varchar(50)
	  ,EstatusCheque varchar(max)
	  ,Tipo varchar (10)
	  )

 Declare @OS as table (
		OSOC varchar (20)
      ,Proveedor varchar(max)
      ,Importe Decimal(18,2)
	  ,Estatus varchar(50)
      ,PolizaComprometido varchar(50)
	  ,Factura varchar(50)
	  ,PolizaDevengado varchar(50)
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,PolizaPagado varchar(50)
	  ,EstatusCheque varchar(max)
	  ,Tipo varchar (10)
	  )

---------------------------------------------OC------------------------------------------------
Insert into @OC
Select Distinct TP.Folio as OSOC,
		CP.RazonSocial as Proveedor,
		TP.TotalGral as Importe,
		CASE TP.Estatus
		WHEN 'C' THEN 'Cancelado'
		WHEN 'R' THEN 'Recibido'
		WHEN 'P' THEN 'Pedido'
		WHEN 'L' THEN 'Consolidado'
		WHEN 'I' THEN 'Parcial'
		WHEN 'A' THEN 'Aprobado'
		END as Estatus,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
	TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		ISNULL((TRF.IdObraPago/100),0) as Anticipo,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		 TSC.FolioDesconcentrado as Aprobacion,
	    CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select FolioCheque from T_Cheques where IdCheques = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN TC.FolioCheque
	    ELSE TC.FolioCheque  END AS ChequeTransf,
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
		CASE TC.Status
			When 'G' THEN 'No generado'
			When 'C' THEN 'Por imprimir'
			When 'I' THEN 'Impreso'
			When 'D' THEN 'Aplicado'
			When 'N' THEN 'Cancelado'
			When 'L' THEN 'Consolidado'
		Else '' END as EstatusCheque,
		'OC' as Tipo
		
FROM T_Pedidos TP
LEFT JOIN C_Proveedores CP
    ON TP.IdProveedor = CP.IdProveedor 
LEFT JOIN T_RecepcionFacturas TRF 
	ON TP.IdPedido = TRF.IdPedido and TRF.IdPoliza<>0 

LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TRF.IdPoliza
LEFT JOIN T_AfectacionPresupuesto TAP
	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' and Cancelacion <> 1
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque

where TP.Fecha >= @FechaInicio and TP.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
    and TP.Folio = (case 
					 when @FolioCompra = 0 and @FolioServicio = 0 then TP.Folio 
					 when @FolioCompra = 0 and @FolioServicio <> 0 then  0
					else  @FolioCompra end)
	--AND TC.Status <> 'L' 
Group by TC.IdChequesAgrupador, TP.Folio, CP.RazonSocial, TP.TotalGral, TP.Estatus, TAP.IdPoliza, TRF.Serie, TRF.Factura, TRF.IdPoliza,
TSC.Fecha, TSC.FolioPorTipo, TSC.IdPolizaPresupuestoEjercido, TSC.FolioDesconcentrado, TC.FolioCheque, TC.Status, TC.IdCheques,
TC.IdPolizaPresupuestoPagado, TC.Entregado, TRF.IdObraPago

---------------------------------------------OS------------------------------------------------
Insert into @OS
 Select Distinct TOS.Folio as OSOC,
		CP.RazonSocial as Proveedor,
		TOS.TotalGral as Importe,
		CASE TOS.Estatus
		WHEN 'C' THEN 'Cancelado'
		WHEN 'R' THEN 'Recibido'
		WHEN 'P' THEN 'Pedido'
		WHEN 'L' THEN 'Consolidado'
		WHEN 'I' THEN 'Parcial'
		WHEN 'A' THEN 'Aprobado'
		END as Estatus,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
	TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		ISNULL((TRF.IdObraPago/100),0) as Anticipo,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		 TSC.FolioDesconcentrado as Aprobacion,
	    CASE 
			WHEN TC.FolioCheque = 0 AND TC.Status = 'L' THEN (Select FolioCheque from T_Cheques where IdCheques = TC.IdChequesAgrupador)
			WHEN TC.FolioCheque = 0 AND TC.Status <> 'L' THEN TC.FolioCheque
	    ELSE TC.FolioCheque  END AS ChequeTransf,
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
		CASE TC.Status
			When 'G' THEN 'No generado'
			When 'C' THEN 'Por imprimir'
			When 'I' THEN 'Impreso'
			When 'D' THEN 'Aplicado'
			When 'N' THEN 'Cancelado'
			When 'L' THEN 'Consolidado'
		Else '' END as EstatusCheque,		
		'OS' as Tipo

FROM T_OrdenServicio TOS
LEFT JOIN C_Proveedores CP
    ON TOS.IdProveedor = CP.IdProveedor 
LEFT JOIN T_RecepcionFacturas TRF
	ON TOS.IdOrden = TRF.IdOrden and TRF.IdPoliza<>0
LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
LEFT JOIN T_Polizas TPOL
	ON TPOL.IdPoliza = TRF.IdPoliza
LEFT JOIN T_AfectacionPresupuesto TAP
	ON TAP.IdMovimiento = TOS.Idorden and TipoAfectacion = 'C' and TipoMovimientoGenera = 'S' and Cancelacion <> 1
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
where TOS.Fecha >= @FechaInicio and TOS.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
	and TOS.Folio = (case 
					when @FolioServicio = 0 and @FolioCompra = 0 then TOS.Folio 
					when @FolioServicio = 0 and @FolioCompra <> 0 then 0
					else  @FolioServicio end)
	--AND TC.Status <> 'L'
Group by TC.IdChequesAgrupador, TOS.Folio, CP.RazonSocial, TOS.TotalGral, TOS.Estatus, TAP.IdPoliza, TRF.Serie, TRF.Factura, TRF.IdPoliza,
TSC.Fecha, TSC.FolioPorTipo, TSC.IdPolizaPresupuestoEjercido, TSC.FolioDesconcentrado, TC.FolioCheque, TC.Status, TC.IdCheques,
TC.IdPolizaPresupuestoPagado, TC.Entregado, TRF.IdObraPago


	  Insert into @tabla
Select  
		OSOC
		,Proveedor 
		,Importe 
	    ,Estatus 
		,PolizaComprometido 
		,Factura 
		,PolizaDevengado
		,Anticipo 
		,FechaSolicitud 
		,SolicitudPago 
		,PolizaEjercido 
		,Aprobacion
		,ChequeTransf 
		,PolizaContable 
		,PolizaPagado 
		,EstatusCheque 
		,Tipo 
		,CASE
		when rownumber=1 then OSOC else 'X' end as ForSum
		from 
		(Select *,Row_number() Over(Partition by OSOC order by OSOC) rownumber from @OC) c
	
		UNION

		Select  
		OSOC
		,Proveedor 
		,Importe 
	    ,Estatus 
		,PolizaComprometido 
		,Factura 
		,PolizaDevengado
		,Anticipo 
		,FechaSolicitud 
		,SolicitudPago 
		,PolizaEjercido 
		,Aprobacion
		,ChequeTransf 
		,PolizaContable 
		,PolizaPagado 
		,EstatusCheque 
		,Tipo 
		,CASE
		when rownumber=1 then OSOC else 'X' end as ForSum
		from 
		(Select *,Row_number() Over(Partition by OSOC order by OSOC) rownumber from @OS) c


	If @Cancelados = 1
			Begin
				Select * from @tabla order by Tipo			
			End
		Else
			Begin	
				Select * from @tabla where Estatus <> 'Cancelado' order by Tipo
			End
End

EXEC SP_FirmasReporte 'Analítico por Proveedor Contable'
GO
Exec SP_CFG_LogScripts 'SP_RPT_AnaliticoPorProveedorContable'
GO