/****** Object:  StoredProcedure [dbo].[SP_RPT_CriTarifario]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CriTarifario]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CriTarifario]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_CriTarifario]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_CriTarifario]
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
      ,Tipo varchar(max)
      ,IdTarifa int
      ,Clave varchar(max)      
      ,estatus varchar(max)
      ,idpoliza int
	  ,NombreCuenta varchar (max)
      )

  DECLARE @Pivot as table (
	Cliente int,
	Clave varchar(max),
	NombreCuenta varchar (max),
	Concepto varchar(max),
	Enero decimal(11,2),
	Febrero decimal(11,2),
	Marzo decimal(11,2),
	Abril decimal(11,2),
	Mayo decimal(11,2),
	Junio decimal(11,2),
	Julio decimal(11,2),
	Agosto decimal(11,2),
	Septiembre decimal(11,2),
	Octubre decimal(11,2),
	Noviembre decimal(11,2),
	Diciembre decimal(11,2)
	--Totales decimal(11,2)
)

DECLARE @Final as table (
	Cliente int,
	Clave varchar(max),
	NombreCuenta varchar (max),
	Concepto varchar(max),
	Enero decimal(11,2),
	Febrero decimal(11,2),
	Marzo decimal(11,2),
	Abril decimal(11,2),
	Mayo decimal(11,2),
	Junio decimal(11,2),
	Julio decimal(11,2),
	Agosto decimal(11,2),
	Septiembre decimal(11,2),
	Octubre decimal(11,2),
	Noviembre decimal(11,2),
	Diciembre decimal(11,2),
	Total decimal(11,2)
)

If @Tipo=1
BEGIN
--Por Recaudar
Insert @TablaTodos 
Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, df.Importe ,df.Concepto  as Concepto, 'Por Recaudar' as Tipo,df.IdTarifa, C_PartidasGastosIngresos.Clave AS CLAVE, Tf.[status], idpoliza, ctipo.Descripcion as NombreCuenta
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
order by Tf.Folio
END


If @Tipo=2
BEGIN
--Recaudados
Insert @TablaTodos 
--Select TRC.Folio , TRC.Fecha, CC.IdCliente as Cliente, dr.Importe ,dr.Descripcion as Concepto,  'Recaudados' as Tipo, dr.IdTarifa, C_PartidasGastosIngresos.Clave,TRC.status, idpoliza, ctipo.Descripcion as NombreCuenta
--FROM c_clientes as cc
--JOIN
--T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
--JOIN
--d_recibos as DR ON dr.IdIngreso = trc.idingreso
--JOIN T_Tarifario 
--ON T_Tarifario.IdTarifa=DR.IdTarifa
--JOIN C_PartidasGastosIngresos
--ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI 
--JOIN C_TipoCuentas ctipo
--ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta
--Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
--and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
--order by trc.Folio 
Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, 
--df.Importe ,
SUM(DP.ImporteAbono) as Importe,
df.Concepto  as Concepto, 'Recaudados' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza, ctipo.Descripcion as NombreCuenta
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
JOIN T_Polizas TP ON TP.IdPoliza = TF.IdPoliza and TP.TipoPoliza ='I'
JOIN D_Polizas DP ON DP.IdPoliza = TF.IdPoliza
JOIN C_Contable CCON ON CCON.IdCuentaContable = DP.IdCuentaContable and NumeroCuenta like '815%'
Where --tf.tipofactura = 4 and 
(Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
Group by TF.Folio, TF.Fecha, CC.IdCliente, DF.Concepto, DF.IdTarifa, C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza,
ctipo.Descripcion

END


If @Tipo=3
BEGIN
--Devoluciones Detalle
Insert @TablaTodos 
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.IdCliente as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto,'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa, C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza, ctipo.Descripcion as NombreCuenta
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
Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, df.Importe ,df.Concepto  as Concepto, 'Por Recaudar' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, IdPoliza, ctipo.Descripcion as NombreCuenta
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

union all
--Recaudados
--Select TRC.Folio , TRC.Fecha, CC.IdCliente as Cliente, dr.Importe ,dr.Descripcion as Concepto, 'Recaudados' as Tipo, dr.IdTarifa,
--C_PartidasGastosIngresos.Clave, TRC.Status, IdPoliza, ctipo.Descripcion as NombreCuenta
--FROM c_clientes as cc
--JOIN
--T_RecibosCaja as TRC ON cc.IdCliente = TRC.IdCliente
--JOIN
--d_recibos as DR ON dr.IdIngreso = trc.idingreso
--JOIN T_Tarifario 
--ON T_Tarifario.IdTarifa=DR.IdTarifa
--JOIN C_PartidasGastosIngresos
--ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
--JOIN C_TipoCuentas ctipo
--ON ctipo.IdTipoCuenta = T_Tarifario.IdTipoCuenta 
--Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and (TRC.Fecha BETWEEN @FechaInicio AND @FechaFin)
--and (dr.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)

Select Tf.Folio , Tf.Fecha , CC.IdCliente as Cliente, 
--df.Importe ,
SUM(DP.ImporteAbono) as Importe,
df.Concepto  as Concepto, 'Recaudados' as Tipo, df.IdTarifa, 
C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza, ctipo.Descripcion as NombreCuenta
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
JOIN T_Polizas TP ON TP.IdPoliza = TF.IdPoliza and TP.TipoPoliza ='I'
JOIN D_Polizas DP ON DP.IdPoliza = TF.IdPoliza
JOIN C_Contable CCON ON CCON.IdCuentaContable = DP.IdCuentaContable and NumeroCuenta like '815%'
Where --tf.tipofactura = 4 and 
(Tf.Fecha >= @FechaInicio AND Tf.Fecha <= @FechaFin) and (df.IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin)
Group by TF.Folio, TF.Fecha, CC.IdCliente, DF.Concepto, DF.IdTarifa, C_PartidasGastosIngresos.Clave, TF.Status, TF.IdPoliza,
ctipo.Descripcion

union all
--Devoluciones Detalle
Select TNC.Folio as Folio ,TNC.Fecha as Fecha, CC.IdCliente as Cliente, dnc.Importe as Importe ,dnc.Concepto as Concepto, 'Devoluciones y Compensaciones' as Tipo, dnc.IdTarifa,
C_PartidasGastosIngresos.Clave, tnc.Estatus, IdPoliza, ctipo.Descripcion as NombreCuenta
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

--Select * from @TablaTodos order by Fecha

if @MostrarCancelados = 1 
BEGIN
insert into @Pivot
SELECT *
FROM (SELECT --YEAR(Fecha) [Year], 
        DATENAME(MONTH, Fecha) as [Mes],
	   Cliente,
	   Clave,
	   NombreCuenta,
	   Concepto, 
       ISNULL([Importe],0) as Importe
      FROM @TablaTodos

      --GROUP BY YEAR(Fecha), Cliente, Concepto, Clave, NombreCuenta, Importe,
      --DATENAME(MONTH, Fecha)) AS Meses	
	  ) as src
PIVOT( SUM([Importe]) 
    FOR Mes IN ([Enero],[Febrero],[Marzo],[Abril],[Mayo],
    [Junio],[Julio],[Agosto],[Septiembre],[Octubre],[Noviembre],
    [Deciembre])) AS NamePivot
END
--ELSE	
--BEGIN
--	Select Folio,Fecha,Cliente, Importe, Concepto, Tipo, Idtarifa, Clave, 'Activo' as Estatus, idpoliza as IdPoliza, NombreCuenta
--	from @TablaTodos 
--	Where Fecha BETWEEN @FechaInicio AND @FechaFin   and (IdTarifa  BETWEEN @TarifarioInicio AND @TarifarioFin) and estatus <> 'N' 	
--	order by tipo
--END

insert into @Final
SELECT Cliente, Clave, NombreCuenta, Concepto,
		isnull(Enero,0) as Enero,
		isnull(Febrero,0) as Febrero,
		isnull(Marzo,0) as Marzo,
		isnull(Abril,0) as Abril,
		isnull(Mayo,0) as Mayo,
		isnull(Junio,0) as Junio,
		isnull(Julio,0) as Julio,
		isnull(Agosto,0) as Agosto,
		isnull(Septiembre,0) as Septiembre,
		isnull(Octubre,0) as Octubre,
		isnull(Noviembre,0) as Noviembre,
		isnull(Diciembre,0) as Diciembre,
		isnull(Enero,0)+isnull(Febrero,0)+isnull(Marzo,0)+isnull(Abril,0)+isnull(Mayo,0)+isnull(Junio,0)+isnull(Julio,0)+isnull(Agosto,0)+isnull(Septiembre,0)+isnull(Octubre,0)+isnull(Noviembre,0)+isnull(Diciembre,0) as Total 
		From @Pivot
		Group by Cliente, Clave, NombreCuenta, Concepto, Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre

 Select * from @Final
END


GO


EXEC SP_FirmasReporte 'Tarifario Ingresos'
GO

-- Exec SP_RPT_CriTarifario 2, '01-01-2021','30-09-2021',1,9999,1
