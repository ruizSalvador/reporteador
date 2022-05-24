/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoPorProveedorContable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoPorProveedorContable]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_AnaliticoPorProveedorContable '01/01/2016','31/12/2016','',0,0
CREATE PROCEDURE [dbo].[SP_RPT_AnaliticoPorProveedorContable] 
  
@FechaInicio as Datetime,
@FechaFin as Datetime,
@Proveedor as int,
@FolioServicio as int,
@FolioCompra as int

AS
BEGIN
Declare @tabla as table (
		OSOC varchar (20)
      ,Proveedor varchar(max)
      ,Importe Decimal(18,2)
      ,PolizaComprometido varchar(50)
	  ,Factura varchar(50)
	  ,PolizaDevengado varchar(50)
	  ,FechaSolicitud Datetime
	  ,SolicitudPago int
	  ,PolizaEjercido varchar(50)
	  ,Aprobacion int
	  ,ChequeTransf int
	  ,PolizaContable varchar(50)
	  ,PolizaPagado varchar(50)
	  ,Tipo varchar (10)
 )

 Insert into @tabla
------------------------------------------------------OC------------------------------
Select Distinct TP.Folio as OSOC,
		CP.RazonSocial as Proveedor,
		TP.TotalGral as Importe,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
	TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
	  TSC.FolioDesconcentrado as Aprobacion,
	    TC.FolioCheque as ChequeTransf,	
	    (Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) as PolizaContable,			   
	    Case  when TC.FolioCheque=0 then 		
	    'PAGO ELECTRONICO'
	    else
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		end as PolizaPagado,
-----		
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
	ON TAP.IdMovimiento = tp.IdPedido and TipoAfectacion = 'C' and TipoMovimientoGenera = 'P' 
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status <> 'L' and TC.Status in ('I','D')

where TP.Fecha >= @FechaInicio and TP.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
     and TP.Folio = (case 
					 when @FolioCompra = 0 and @FolioServicio = 0 then TP.Folio 
					 when @FolioCompra = 0 and @FolioServicio <> 0 then  0
					else  @FolioCompra end)


UNION ------------------------------------------------OS-------------------------------------------

 Select Distinct TOS.Folio as OSOC,
		CP.RazonSocial as Proveedor,
		TOS.TotalGral as Importe,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TAP.IdPoliza) as PolizaComprometido,
TRF.Serie+' '+TRF.Factura as Factura,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TRF.IdPoliza) as PolizaDevengado,
		TSC.Fecha as FechaSolicitud,
		TSC.FolioPorTipo as SolicitudPago,
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TSC.IdPolizaPresupuestoEjercido) as PolizaEjercido,
	  TSC.FolioDesconcentrado as Aprobacion,
	  TC.FolioCheque as ChequeTransf,	  
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdCheque = TC.IdCheques) as PolizaContable,
		Case  when TC.FolioCheque=0  then 		
	    'PAGO ELECTRONICO'
	    else
		(Select CAST(T_Polizas.TipoPoliza as varchar(10)) + ' '  + CAST(T_Polizas.Periodo as varchar (5)) + ' ' + CAST(T_Polizas.NoPoliza as varchar (50)) from T_Polizas where T_Polizas.IdPoliza = TC.IdPolizaPresupuestoPagado) 
		end as PolizaPagado,
----		
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
	ON TAP.IdMovimiento = TOS.Idorden and TipoAfectacion = 'C' and TipoMovimientoGenera = 'S'
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status <> 'L' 	and TC.Status in ('I','D')
where TOS.Fecha >= @FechaInicio and TOS.Fecha <= @FechaFin
	and CP.IdProveedor = (case when @Proveedor = '' then CP.IdProveedor else  @Proveedor end)
	and TOS.Folio = (case 
					when @FolioServicio = 0 and @FolioCompra = 0 then TOS.Folio 
					when @FolioServicio = 0 and @FolioCompra <> 0 then 0
					else  @FolioServicio end)

Select * from @tabla order by Tipo
end
