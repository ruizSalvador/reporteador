/****** Object:  StoredProcedure [dbo].[SP_RPT_ContrareciboMultiplesFacturas]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ContrareciboMultiplesFacturas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ContrareciboMultiplesFacturas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ContrareciboMultiplesFacturas]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_ContrareciboMultiplesFacturas "'A 23374','A 23376','A 23607'"
CREATE PROCEDURE [dbo].[SP_RPT_ContrareciboMultiplesFacturas]

 @Cadena varchar(max)

AS
BEGIN
DECLARE @tblData as TABLE(Factura varchar(200), Fecha Datetime, Total Decimal(18,2), Folio int, FechaProgramacion Datetime, Amortizacion Decimal(18,2), Anticipo Decimal (18,2) )

DECLARE @sql nvarchar(max)

SET @sql = 'Select Factura,T_RecepcionFacturas.Fecha,SUM(Total),Folio,T_RecepcionFacturas.FechaProgramacion,SUM(ISNULL(IdObraPago,0)) as Amortizacion, SUM(ISNULL(T_SolicitudCheques.Importe,0)) as Anticipo From T_RecepcionFacturas '
		  +'LEFT JOIN R_AnticiposCheques ON T_recepcionFacturas.IdPedido = R_AnticiposCheques.IDPEDIDO '
		  +'LEFT JOIN T_SolicitudCheques ON R_AnticiposCheques.IDSOLCHEQUES = T_SolicitudCheques.IdSolicitudCheques '
		  +'Where Factura in (' + @Cadena + ') and T_recepcionFacturas.IdPedido <> 0 '
		  +'Group by Factura, T_RecepcionFacturas.Fecha, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.FechaProgramacion, T_RecepcionFacturas.IdObraPago, T_SolicitudCheques.Importe ' 
		  +'UNION ALL '
		  +'Select Factura,T_RecepcionFacturas.Fecha,SUM(Total),Folio,T_RecepcionFacturas.FechaProgramacion,SUM(ISNULL(IdObraPago,0)) as Amortizacion, SUM(ISNULL(T_SolicitudCheques.Importe,0)) as Anticipo From T_RecepcionFacturas '
		  +'LEFT JOIN R_AnticiposCheques ON T_recepcionFacturas.IdOrden = R_AnticiposCheques.IDORDENSERVICIO '
		  +'LEFT JOIN T_SolicitudCheques ON R_AnticiposCheques.IDSOLCHEQUES = T_SolicitudCheques.IdSolicitudCheques '
		  +'Where Factura in (' + @Cadena + ') and T_recepcionFacturas.IdPedido = 0'
		  +'Group by Factura, T_RecepcionFacturas.Fecha, T_RecepcionFacturas.Total, T_RecepcionFacturas.Folio, T_RecepcionFacturas.FechaProgramacion, T_RecepcionFacturas.IdObraPago, T_SolicitudCheques.Importe' 

Insert Into @tblData
EXEC (@sql)

Declare @SumImporte as Decimal (18,2)
Declare @SumAmortizacion as Decimal (18,2)
Declare @SumAnticipo as Decimal (18,2)
Set @SumImporte = (Select SUM(Total) From @tblData)
Set @SumAmortizacion = (Select SUM(Amortizacion) From @tblData)
Set @SumAnticipo = (Select SUM(Anticipo) From @tblData)

Select Factura, Fecha, Total, Folio, Fecha, FechaProgramacion, Amortizacion, Anticipo, 
((@SumImporte-@SumAnticipo)-@SumAmortizacion) as TotalPagar
From @tblData

END