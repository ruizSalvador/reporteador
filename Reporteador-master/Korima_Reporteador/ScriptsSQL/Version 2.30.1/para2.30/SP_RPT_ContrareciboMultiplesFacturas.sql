/****** Object:  StoredProcedure [dbo].[SP_RPT_ContrareciboMultiplesFacturas]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ContrareciboMultiplesFacturas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ContrareciboMultiplesFacturas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ContrareciboMultiplesFacturas]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_ContrareciboMultiplesFacturas "'1','556','455'",26,2020
CREATE PROCEDURE [dbo].[SP_RPT_ContrareciboMultiplesFacturas]

 @Cadena varchar(max),
 @IdProveedor smallint,
 @Ejercicio int

AS
BEGIN
DECLARE @tblData as TABLE(Factura varchar(200), Fecha Datetime, Total Decimal(18,2), Folio int, FechaProgramacion Datetime, Amortizacion Decimal(18,2), Anticipo Decimal (18,2), OCOS varchar(100) )

DECLARE @sql nvarchar(max)

SET @sql = 'Select Factura,T_RecepcionFacturas.Fecha,SUM(T_recepcionFacturas.Total),T_RecepcionFacturas.Folio,T_RecepcionFacturas.FechaProgramacion,SUM(ISNULL(IdObraPago,0)) as Amortizacion, SUM(ISNULL(T_SolicitudCheques.Importe,0)) as Anticipo, ' 
		  +'CONCAT(''OC'','' '', CAST(T_Pedidos.Folio as varchar)) '
		  +'From T_RecepcionFacturas '
		  +'LEFT JOIN R_AnticiposCheques ON T_recepcionFacturas.IdPedido = R_AnticiposCheques.IDPEDIDO '
		  +'LEFT JOIN T_SolicitudCheques ON R_AnticiposCheques.IDSOLCHEQUES = T_SolicitudCheques.IdSolicitudCheques '
		  +'LEFT JOIN T_Pedidos ON T_Pedidos.IdPedido = T_recepcionFacturas.IdPedido '
		  +'Where Factura in (' + @Cadena + ') and T_recepcionFacturas.IdPedido <> 0 and T_RecepcionFacturas.IdProveedor =  ' + Convert(nvarchar(200),@IdProveedor) + ' and Year(T_recepcionFacturas.Fecha) = ' + Convert(nvarchar(20),@Ejercicio)
		  +' AND T_recepcionFacturas.Estatus <> ''N'''
		  +'Group by Factura, T_RecepcionFacturas.Fecha, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.FechaProgramacion, T_RecepcionFacturas.IdObraPago, T_SolicitudCheques.Importe, T_Pedidos.Folio ' 
		  +'UNION ALL '
		  +'Select Factura,T_RecepcionFacturas.Fecha,SUM(T_recepcionFacturas.Total),T_RecepcionFacturas.Folio,T_RecepcionFacturas.FechaProgramacion,SUM(ISNULL(IdObraPago,0)) as Amortizacion, SUM(ISNULL(T_SolicitudCheques.Importe,0)) as Anticipo, '
		  +'CONCAT(''OS'','' '', CAST(T_OrdenServicio.Folio as varchar)) '
		  +'From T_RecepcionFacturas '
		  +'LEFT JOIN R_AnticiposCheques ON T_recepcionFacturas.IdOrden = R_AnticiposCheques.IDORDENSERVICIO '
		  +'LEFT JOIN T_SolicitudCheques ON R_AnticiposCheques.IDSOLCHEQUES = T_SolicitudCheques.IdSolicitudCheques '
		  +'LEFT JOIN T_OrdenServicio ON T_OrdenServicio.IdOrden = T_recepcionFacturas.IdOrden '
		  +'Where Factura in (' + @Cadena + ') and T_recepcionFacturas.IdOrden <> 0 and T_RecepcionFacturas.IdProveedor =  ' + Convert(nvarchar(200),@IdProveedor) + ' and Year(T_recepcionFacturas.Fecha) = ' + Convert(nvarchar(20),@Ejercicio)
		  +' AND T_recepcionFacturas.Estatus <> ''N'''
		  +'Group by Factura, T_RecepcionFacturas.Fecha, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.FechaProgramacion, T_RecepcionFacturas.IdObraPago, T_SolicitudCheques.Importe, T_OrdenServicio.Folio ' 

Insert Into @tblData
EXEC (@sql)

Declare @SumImporte as Decimal (18,2)
Declare @SumAmortizacion as Decimal (18,2)
Declare @SumAnticipo as Decimal (18,2)
Set @SumImporte = (Select SUM(Total) From @tblData)
Set @SumAmortizacion = (Select SUM(Amortizacion) From @tblData)
Set @SumAnticipo = (Select SUM(Anticipo) From @tblData)

Select Factura, Fecha, Total, Folio, Fecha, FechaProgramacion, Amortizacion, Anticipo, OCOS, 
((@SumImporte-@SumAnticipo)-@SumAmortizacion) as TotalPagar
From @tblData

END

Exec SP_CFG_LogScripts 'SP_RPT_ContrareciboMultiplesFacturas','2.30'
GO