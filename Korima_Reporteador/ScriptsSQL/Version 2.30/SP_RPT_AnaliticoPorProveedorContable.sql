/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoPorProveedorContable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoPorProveedorContable]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_AnaliticoPorProveedorContable '20190624','20190624',0,0,0,0
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
	  ,FechaPolizaComprometido Datetime
	  ,Factura varchar(max)
	  ,PolizaDevengado varchar(50)
	  ,FechaPolizaDevengado Datetime
	  ,PolizaAnticipo varchar(50)
	  ,FechaPolizaAnticipo Datetime
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,FechaPolizaEjercido Datetime
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,FechaPolizaContable Datetime
	  ,PolizaPagado varchar(50)
	  ,FechaPolizaPagado Datetime
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
	  ,FechaPolizaComprometido Datetime
	  ,Factura varchar(max)
	  ,PolizaDevengado varchar(50)
	  ,FechaPolizaDevengado Datetime
	  ,PolizaAnticipo varchar(50)
	  ,FechaPolizaAnticipo Datetime
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,FechaPolizaEjercido Datetime
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,FechaPolizaContable Datetime
	  ,PolizaPagado varchar(50)
	  ,FechaPolizaPagado Datetime
	  ,EstatusCheque varchar(max)
	  ,Tipo varchar (10)
	  )
 Declare @OS as table (
		OSOC varchar (20)
      ,Proveedor varchar(max)
      ,Importe Decimal(18,2)
	  ,Estatus varchar(50)
      ,PolizaComprometido varchar(50)
	  ,FechaPolizaComprometido Datetime
	  ,Factura varchar(max)
	  ,PolizaDevengado varchar(50)
	  ,FechaPolizaDevengado Datetime
	  ,PolizaAnticipo varchar(50)
	  ,FechaPolizaAnticipo Datetime
	  ,Anticipo Decimal(18,2)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,FechaPolizaEjercido Datetime
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,FechaPolizaContable Datetime
	  ,PolizaPagado varchar(50)
	  ,FechaPolizaPagado Datetime
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
		(Select Fecha  from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as FechaPolizaComprometido, 
	     TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as FechaPolizaDevengado,
		--(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques) as PolizaAnticipo,
		CASE 
			WHEN TCH.FolioCheque = 0 AND TCH.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdChequesAgrupador)
			WHEN TCH.FolioCheque = 0 AND TCH.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		ELSE	
	    (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		END AS PolizaAnticipo,
		(Select Fecha from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques) as FechaPolizaAnticipo,
		ISNULL((TP.Anticipo),0) as Anticipo,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as FechaPolizaEjercido,

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
			(Select Fecha from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) AS FechaPolizaContable,		   
	    CASE  
			WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
			WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
				(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,

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
LEFT JOIN T_SolicitudCheques TSC1 
    on TP.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
LEFT JOIN T_Cheques TCH  
    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos)


where TP.Fecha >= @FechaInicio and TP.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
    and TP.Folio = (case 
					 when @FolioCompra = 0 and @FolioServicio = 0 then TP.Folio 
					 when @FolioCompra = 0 and @FolioServicio <> 0 then  0
					else  @FolioCompra end)
	--AND TC.Status <> 'L' 
Group by TC.IdChequesAgrupador, TP.Folio, CP.RazonSocial, TP.TotalGral, TP.Estatus, TAP.IdPoliza, TRF.Serie, TRF.Factura, TRF.IdPoliza,
TSC.Fecha, TSC.FolioPorTipo, TSC.IdPolizaPresupuestoEjercido, TSC.FolioDesconcentrado, TC.FolioCheque, TC.Status, TC.IdCheques,
TC.IdPolizaPresupuestoPagado, TC.Entregado, TP.Anticipo,TCH.IdCheques,TPOL.Fecha, TCH.IdChequesAgrupador, TCH.FolioCheque, TCH.Status--TRF.IdObraPago

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
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as FechaPolizaComprometido,
	    TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as FechaPolizaDevengado,
	    --(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  +CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques ) as PolizaAnticipo,
		CASE 
			WHEN TCH.FolioCheque = 0 AND TCH.Status = 'L' THEN (Select top 1 CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdChequesAgrupador)
			WHEN TCH.FolioCheque = 0 AND TCH.Status <> 'L' THEN (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		ELSE	
	    (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TCH.IdCheques)
		END AS PolizaAnticipo,
	    (Select Fecha from T_Polizas where T_Polizas.IdCheque= TCH.IdCheques ) as FechaPolizaAnticipo,
		ISNULL((TOS.Anticipo),0) as Anticipo,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as FechaPolizaEjercido,

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
		
		 (Select Fecha from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) AS FechaPolizaContable,		   
	    CASE  
		WHEN TC.FolioCheque=0 AND TC.Status = 'L' THEN  (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza in (Select top 1 IdPolizaPresupuestoPagado from T_Cheques where T_Cheques.IdCheques = TC.IdChequesAgrupador))
		WHEN TC.FolioCheque=0 AND TC.Status = 'D' AND TC.Entregado = 0 THEN  'PAGO ELECTRONICO'
	    ELSE
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		END AS PolizaPagado,
		(Select Fecha from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) AS FechaPolizaPagado,
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
LEFT JOIN T_SolicitudCheques TSC1 
    on TOS.IdSolicitudChequesAnticipo= TSC1.IdSolicitudCheques
LEFT JOIN T_Cheques TCH  
    on TCH.IdSolicitudCheque= TSC1.IdSolicitudCheques and TSC1.IdSolicitudCheques not in (Select IdSolicitudChequesOriginal From T_Viaticos) 
	--and TCH.IdChequesAgrupador = 0
where TOS.Fecha >= @FechaInicio and TOS.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
	and TOS.Folio = (case 
					when @FolioServicio = 0 and @FolioCompra = 0 then TOS.Folio 
					when @FolioServicio = 0 and @FolioCompra <> 0 then 0
					else  @FolioServicio end)
	--AND TC.Status <> 'L'
Group by TC.IdChequesAgrupador, TOS.Folio, CP.RazonSocial, TOS.TotalGral, TOS.Estatus, TAP.IdPoliza, TRF.Serie, TRF.Factura, TRF.IdPoliza,
TSC.Fecha, TSC.FolioPorTipo, TSC.IdPolizaPresupuestoEjercido, TSC.FolioDesconcentrado, TC.FolioCheque, TC.Status, TC.IdCheques,
TC.IdPolizaPresupuestoPagado, TC.Entregado, TOS.Anticipo,TCH.IdCheques,TPOL.Fecha, TCH.IdChequesAgrupador, TCH.FolioCheque, TCH.Status--TRF.IdObraPago

	Insert into @tabla
         Select  
		 OSOC
		,Proveedor 
		,Importe 
	    ,Estatus 
		,PolizaComprometido 
		,FechaPolizaComprometido
		,Factura 
		,PolizaDevengado
		,FechaPolizaDevengado
		,PolizaAnticipo
		,FechaPolizaAnticipo
		,Anticipo 
		,FechaSolicitud 
		,SolicitudPago 
		,PolizaEjercido 
		,FechaPolizaEjercido
		,Aprobacion
		,ChequeTransf 
		,PolizaContable 
		,FechaPolizaContable
		,PolizaPagado 
		,FechaPolizaPagado 
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
		,FechaPolizaComprometido
		,Factura 
		,PolizaDevengado
		,FechaPolizaDevengado
		,PolizaAnticipo
		,FechaPolizaAnticipo
		,Anticipo 
		,FechaSolicitud 
		,SolicitudPago 
		,PolizaEjercido 
		,FechaPolizaEjercido
		,Aprobacion
		,ChequeTransf 
		,PolizaContable 
		,FechaPolizaContable
		,PolizaPagado 
		,FechaPolizaPagado 
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

EXEC SP_FirmasReporte 'Anal�tico por Proveedor Contable'
GO
Exec SP_CFG_LogScripts 'SP_RPT_AnaliticoPorProveedorContable','2.30'
GO

--Exec SP_RPT_AnaliticoPorProveedorContable '20170101','20171231',0,0,0,1