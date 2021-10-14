/****** Object:  StoredProcedure [dbo].[SP_RPT_TarifarioIngresosUsuario]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_TarifarioIngresosUsuario]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_TarifarioIngresosUsuario]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_TarifarioIngresosUsuario]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Exec SP_RPT_TarifarioIngresosUsuario 2,'20211014','20211230',1,9999,1
CREATE PROCEDURE [dbo].[SP_RPT_TarifarioIngresosUsuario]
@Tipo as int, 
@FechaInicio as DateTime,
@FechaFin as DateTime,
@TarifarioInicio as int,
@TarifarioFin as int,
@MostrarCancelados as bit

AS
BEGIN

Declare @TablaTodos as table (
       Folio int
      ,Fecha datetime
      ,Cliente int
      ,Importe decimal (15,2)
      ,Concepto varchar(max)
	  ,Descripcion varchar(300)
      ,Tipo varchar(max)
      ,IdTarifa int
      ,Clave varchar(max)      
      ,estatus varchar(max)
      ,idpoliza int
	  ,NombreCuenta varchar (max)
	  ,NomCliente varchar(max)
      )


If @Tipo=1
BEGIN
--Por Recaudar
Insert @TablaTodos 
Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, df.Importe ,df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion, 'Por Recaudar' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN T_Facturas as TF 
ON cc.IdCliente = tf.IdCliente 
JOIN D_Facturas as DF 
ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
Where tf.tipofactura = 4 and (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
AND PagoInmediato in (0)
order by Tf.Folio
END


If @Tipo=2
BEGIN
--Recaudados
Insert @TablaTodos 

Select TRC.Folio , TRC.Fecha, CC.IdCliente as Cliente, dr.Importe ,dr.Descripcion as Concepto, C_PartidasGastosIngresos.Descripcion, 'Recaudados' as Tipo, dr.IdTarifa, C_PartidasGastosIngresos.Clave,TRC.status, idpoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DR.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha >= @FechaInicio AND TRC.Fecha <= @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all

Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, 
df.Importe ,
df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion, 'Recaudados' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
--,TP.TipoPoliza
FROM c_clientes as cc
JOIN
T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
JOIN
D_Facturas as DF ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
--JOIN T_Polizas TP ON TP.IdPoliza = TF.IdPoliza and TP.TipoPoliza ='I'
Where PagoInmediato in (1,2)
AND (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
--Group by 


END


If @Tipo=3
BEGIN
--Devoluciones Detalle
Insert @TablaTodos 
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.IdCliente as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto, C_PartidasGastosIngresos.Descripcion, 'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa, C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DNC.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta 
Where TNC.Tipo=1  and (TNC.Fecha >= @FechaInicio AND TNC.Fecha <= @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by TNC.Folio 
END


If @Tipo=4
BEGIN
      
Insert @TablaTodos      
--Por Recaudar
Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, df.Importe ,df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion, 'Por Recaudar' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, IdPoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN
T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
JOIN
D_Facturas as DF ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
Where tf.tipofactura = 4 and (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
AND PagoInmediato in (0)

union all
--Recaudados
Select TRC.Folio , TRC.Fecha, CC.IdCliente as Cliente, dr.Importe ,dr.Descripcion as Concepto,  C_PartidasGastosIngresos.Descripcion, 'Recaudados' as Tipo, dr.IdTarifa, C_PartidasGastosIngresos.Clave,TRC.status, idpoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DR.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha >= @FechaInicio AND TRC.Fecha <= @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all

Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, 
df.Importe ,
df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion, 'Recaudados' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
--,TP.TipoPoliza
FROM c_clientes as cc
JOIN
T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
JOIN
D_Facturas as DF ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
--JOIN T_Polizas TP ON TP.IdPoliza = TF.IdPoliza and TP.TipoPoliza ='I'
Where PagoInmediato in (1,2)
AND (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
--Group by 
union all
--Devoluciones Detalle
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.IdCliente as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto, C_PartidasGastosIngresos.Descripcion,  'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa,
C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza, ctipo.Descripcion, CC.RazonSocial as NomCliente
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DNC.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas ctipo
ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta 
Where TNC.Tipo=1 and (TNC.Fecha >= @FechaInicio AND TNC.Fecha <= @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)


END


if @MostrarCancelados = 1 
BEGIN
	Select Folio,Fecha,Cliente, NomCliente, Importe, Concepto, Descripcion, Tipo, Idtarifa, Clave, 
	Case Estatus
	when 'N' Then 'Cancelado'
	Else  'Activo'
	End as Estatus, idpoliza as IdPoliza,
	NombreCuenta
	 from @TablaTodos	 
	Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) 
	order by tipo
END
ELSE	
BEGIN
	Select Folio,Fecha,Cliente, NomCliente, Importe, Concepto, Descripcion, Tipo, Idtarifa, Clave, 'Activo' as Estatus, idpoliza as IdPoliza, NombreCuenta
	from @TablaTodos 
	Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) and estatus <> 'N' 	
	order by tipo
END


END


GO


EXEC SP_FirmasReporte 'Tarifario Ingresos'
GO

