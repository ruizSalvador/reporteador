/****** Object:  StoredProcedure [dbo].[SP_RPT_Tarifario_Ingresos]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Tarifario_Ingresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Tarifario_Ingresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Tarifario_Ingresos]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_Tarifario_Ingresos 1,'20210101','20211231',74,74,1
CREATE PROCEDURE [dbo].[SP_RPT_Tarifario_Ingresos]
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
      ,Cliente varchar (300)
      ,Importe decimal (15,2)
      ,Concepto varchar(300)
	 ,Descripcion varchar(300)
      ,Tipo varchar(300)
      ,IdTarifa int
      ,Clave varchar(max)      
      ,estatus varchar(50)
      ,idpoliza int
      )

Declare @Final as table (
       Folio int
      ,Fecha datetime
      ,Cliente varchar (300)
      ,Importe decimal (15,2)
      ,Concepto varchar(300)
	 ,Descripcion varchar(300)
      ,Tipo varchar(300)
      ,IdTarifa int
      ,Clave varchar(max)      
      ,estatus varchar(50)
      ,idpoliza int
	  ,Total decimal(18,2)
      )


If @Tipo=1
BEGIN
--Por Recaudar
Insert @TablaTodos                                                                          
Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe ,df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion, 'Por Recaudar' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza
FROM c_clientes as cc
JOIN T_Facturas as TF 
ON cc.IdCliente = tf.IdCliente 
JOIN D_Facturas as DF 
ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where PagoInmediato in (0) AND
tf.tipofactura = 4 and (Tf.Fecha BETWEEN @FechaInicio AND @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by Tf.Folio
END


If @Tipo=2
BEGIN
--Recaudados
Insert @TablaTodos 
Select TRC.Folio , TRC.Fecha, CC.RazonSocial as Cliente, dr.Importe ,dr.Descripcion as Concepto ,C_PartidasGastosIngresos.Descripcion as Descripcion,  'Recaudados' as Tipo, dr.IdTarifa, C_PartidasGastosIngresos.Clave,TRC.status, idpoliza
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DR.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 

Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by trc.Folio 
END


If @Tipo=3
BEGIN
--Devoluciones Detalle
Insert @TablaTodos 
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.RazonSocial as Cliente, dnc.Importe as Importe, dnc.Concepto as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion, 'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa, C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DNC.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where TNC.Tipo=1  and (TNC.Fecha BETWEEN @FechaInicio AND @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by TNC.Folio 
END

If @Tipo=4
BEGIN
--Por Recaudar-Recaudados
Insert @TablaTodos 
Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe , df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion, 'Por Recaudar-Recaudados' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza
FROM c_clientes as cc
JOIN T_Facturas as TF 
ON cc.IdCliente = tf.IdCliente 
JOIN D_Facturas as DF 
ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where PagoInmediato in (1,2) AND
tf.tipofactura = 4 and (Tf.Fecha BETWEEN @FechaInicio AND @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
order by Tf.Folio
END


If @Tipo=5
BEGIN
      
Insert @TablaTodos      
--Por Recaudar
Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe , df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion, 'Por Recaudar' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza
FROM c_clientes as cc
JOIN T_Facturas as TF 
ON cc.IdCliente = tf.IdCliente 
JOIN D_Facturas as DF 
ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where PagoInmediato in (0) AND
tf.tipofactura = 4 and (Tf.Fecha BETWEEN @FechaInicio AND @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all
--Recaudados
Select TRC.Folio , TRC.Fecha, CC.RazonSocial as Cliente, dr.Importe , dr.Descripcion as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion , 'Recaudados' as Tipo, dr.IdTarifa
,C_PartidasGastosIngresos.Clave, TRC.Status, IdPoliza
FROM c_clientes as cc
JOIN
T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
JOIN
d_recibos as DR ON dr.IdIngreso = trc.idingreso
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DR.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

union all

--Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, 
--df.Importe ,
--df.Concepto  as Concepto, 
--C_PartidasGastosIngresos.Descripcion,
--'Por Recaudar-Recaudados' as Tipo, 
--df.IdTarifa, 
--C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza

--FROM c_clientes as cc
--JOIN
--T_Facturas as TF ON cc.IdCliente = tf.IdCliente 
--JOIN
--D_Facturas as DF ON df.IdFactura = tf.IdFactura
--JOIN T_Tarifario 
--ON T_Tarifario.IdTarifa=DF.IdTarifa
--JOIN C_PartidasGastosIngresos
--ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
--JOIN C_TipoCuentas ctipo
--ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
--JOIN T_Polizas TP ON TP.IdPoliza = TF.IdPoliza and TP.TipoPoliza ='I'
--Where PagoInmediato in (1,2)
--AND (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

Select Tf.Folio , Tf.Fecha , CC.RazonSocial as Cliente, df.Importe , df.Concepto  as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion, 'Por Recaudar-Recaudados' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza
FROM c_clientes as cc
JOIN T_Facturas as TF 
ON cc.IdCliente = tf.IdCliente 
JOIN D_Facturas as DF 
ON df.IdFactura = tf.IdFactura
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DF.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where PagoInmediato in (1,2) AND
tf.tipofactura = 4 and (Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
--order by Tf.Folio

union all

--Devoluciones Detalle
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.RazonSocial as Cliente, dnc.Importe as Importe , dnc.Concepto as Concepto, C_PartidasGastosIngresos.Descripcion as Descripcion , 'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa
,C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza
FROM c_clientes as cc
JOIN
T_NotaCredito as tnc ON cc.IdCliente = tnc.IdCliente 
JOIN
d_notacredito as dnc ON dnc.IdNotaCredito = tnc.idnotacredito
JOIN T_Tarifario 
ON T_Tarifario.IdTarifa=DNC.IdTarifa
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
Where TNC.Tipo=1 and (TNC.Fecha BETWEEN @FechaInicio AND @FechaFin) and (dnc.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)


END



if @MostrarCancelados = 1 
BEGIN
Insert Into @Final
	Select Folio,Fecha,Cliente, Importe, Concepto,Descripcion, Tipo, Idtarifa, Clave, 
	Case Estatus
	when 'N' Then 'Cancelado'
	Else  'Activo'
	End as Estatus, idpoliza as IdPoliza
	,0
	 from @TablaTodos	 
	Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) 
	order by tipo

	Update @Final set Total = (Select SUM(Importe) from @Final)

	Select * from @Final
END
ELSE	
BEGIN
Insert Into @Final
	Select Folio,Fecha,Cliente, Importe, Concepto,Descripcion, Tipo, Idtarifa, Clave, 'Activo' as Estatus, idpoliza as IdPoliza, 0
	from @TablaTodos 
	Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) and estatus <> 'N' 	
	order by tipo


IF @Tipo=5 
	BEGIN
	Declare @other as decimal(18,2) = (Select ISNULL(SUM(Importe),0) from @Final Where Tipo not in ('Devoluciones y Compensaciones','Por Recaudar-Recaudados' ) )
	Declare @dev as decimal(18,2) = (Select SUM(Importe) from @Final Where Tipo = 'Devoluciones y Compensaciones' )	
	Declare @Rec as decimal(18,2) = (Select SUM(Importe) from @Final Where Tipo = 'Por Recaudar-Recaudados' )


		Update @Final set Total = isnull(@other,0) + (isnull(@dev,0)-isnull(@Rec,0))
	END
ELSE
	BEGIN
		Update @Final set Total = (Select ISNULL(SUM(Importe),0) from @Final)
	END

	Select * from @Final
END


END


GO


EXEC SP_FirmasReporte 'Tarifario Ingresos'
GO
Exec SP_CFG_LogScripts 'SP_RPT_Tarifario_Ingresos','2.31'
GO


