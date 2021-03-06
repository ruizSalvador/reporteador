/****** Object:  StoredProcedure [dbo].[SP_RPT_Tarifario_Ingresos]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Tarifario_Ingresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Tarifario_Ingresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Tarifario_Ingresos]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_Tarifario_Ingresos 1,'20210101','20210930',1,99999
CREATE PROCEDURE [dbo].[SP_RPT_Tarifario_Ingresos]
@Tipo as int, 
@FechaInicio as DateTime,
@FechaFin as DateTime,
@TarifarioInicio as int,
@TarifarioFin as int


AS
BEGIN

If @Tipo=1
BEGIN
--Por Recaudar
Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe ,df.Concepto  as Concepto, df.IdTarifa
FROM c_clientes as cc
JOIN
T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
JOIN
D_Facturas as DF ON df.IdFactura = tf.IdFactura
Where tf.tipofactura = 4 and (Tf.Fecha BETWEEN @FechaInicio AND @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by Tf.Folio
END


If @Tipo=2
BEGIN
--Recaudados
Select TRC.Folio , TRC.Fecha, CC.RazonSocial as Cliente, dr.Importe ,dr.Descripcion as Concepto, dr.IdTarifa 
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by trc.Folio 
END


If @Tipo=3
BEGIN
--Devoluciones Detalle
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.RazonSocial as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto, dnc.IdTarifa
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
Where TNC.Tipo=1  and (TNC.Fecha BETWEEN @FechaInicio AND @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by TNC.Folio 
END


If @Tipo=4
BEGIN
Declare @TablaTodos as table (
       Folio int
      ,Fecha datetime
      ,Cliente varchar (255)
      ,Importe decimal (15,2)
      ,Concepto varchar(150)
      ,Tipo varchar(50)
      ,IdTarifa int
      )
      
Insert @TablaTodos      
--Por Recaudar
Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe ,df.Concepto  as Concepto, 'Por Recaudar' as Tipo, df.IdTarifa
FROM c_clientes as cc
JOIN
T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
JOIN
D_Facturas as DF ON df.IdFactura = tf.IdFactura
Where tf.tipofactura = 4 and (Tf.Fecha BETWEEN @FechaInicio AND @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all
--Recaudados
Select TRC.Folio , TRC.Fecha, CC.RazonSocial as Cliente, dr.Importe ,dr.Descripcion as Concepto, 'Recaudados' as Tipo, dr.IdTarifa
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all
--Devoluciones Detalle
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.RazonSocial as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto, 'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
Where TNC.Tipo=1 and (TNC.Fecha BETWEEN @FechaInicio AND @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)


Select * from @TablaTodos 
Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) 
order by tipo

END


END


GO


EXEC SP_FirmasReporte 'Tarifario Ingresos'
GO