/****** Object:  StoredProcedure [dbo].[SP_RPT_PuntoRecaudacionTarifario]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_PuntoRecaudacionTarifario]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_PuntoRecaudacionTarifario]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_PuntoRecaudacionTarifario]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_PuntoRecaudacionTarifario]
@Tipo as int, 
@FechaInicio as DateTime,
@FechaFin as DateTime

AS
BEGIN

Declare @TablaTodos as table (
	   Punto varchar (255)
	  ,Concepto varchar(max)
      ,Importe decimal (15,2)
      ,Tipo varchar(max)
      )

Declare @Final as table (
	   Punto varchar (255)
	  ,Concepto varchar(max)
      ,Importe decimal (15,2)
	  ,Negritas bit
      )	 


If @Tipo=1
BEGIN
--Por Recaudar
Insert @TablaTodos 
Select cp.Nombre as Punto, df.Concepto as Concepto, df.Importe , 'Por Recaudar' as Tipo
FROM D_Facturas as df
JOIN T_Facturas as TF 
ON df.IdFactura = tf.IdFactura
JOIN C_PuntosIngreso cp
ON cp.IdPunto = tf.IdPuntoIngreso
Where tf.tipofactura = 4 and Tf.Fecha>= @FechaInicio AND Tf.Fecha<=@FechaFin
group by cp.Nombre, df.Concepto, df.Importe

END


If @Tipo=2
BEGIN
--Recaudados
Insert @TablaTodos 
Select cp.Nombre as Punto, dr.Descripcion as Concepto, dr.Importe, 'Recaudados' as Tipo
FROM d_recibos as DR 
JOIN T_RecibosCaja as TRC 
ON dr.IdIngreso = trc.idingreso
JOIN C_PuntosIngreso CP
ON trc.IdPuntoIngreso = cp.IdPunto
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and TRC.Fecha>= @FechaInicio AND TRC.Fecha<=@FechaFin
group by cp.Nombre, dr.Descripcion, dr.Importe
END


If @Tipo=3
BEGIN
      
Insert @TablaTodos      
--Por Recaudar
Select cp.Nombre as Punto, df.Concepto as Concepto, df.Importe , 'Por Recaudar' as Tipo
FROM D_Facturas as df
JOIN T_Facturas as TF 
ON df.IdFactura = tf.IdFactura
JOIN C_PuntosIngreso cp
ON cp.IdPunto = tf.IdPuntoIngreso
Where tf.tipofactura = 4 and Tf.Fecha>= @FechaInicio AND Tf.Fecha<=@FechaFin 
group by cp.Nombre, df.Concepto, df.Importe

union all
--Recaudados
Select cp.Nombre as Punto, dr.Descripcion as Concepto, dr.Importe, 'Recaudados' as Tipo
FROM d_recibos as DR 
JOIN T_RecibosCaja as TRC 
ON dr.IdIngreso = trc.idingreso
JOIN C_PuntosIngreso CP
ON trc.IdPuntoIngreso = cp.IdPunto
Where TRC.TipoIngreso <> 'N' and TRC.TipoIngreso <> 'O' and TRC.TipoPago <> 'E' and TRC.Fecha>= @FechaInicio AND TRC.Fecha<=@FechaFin
group by cp.Nombre, dr.Descripcion, dr.Importe

END

--Select ISNULL(Punto, 'SubTotal') Punto, 
--Count(Importe) as Importe from @TablaTodos
--group by Punto
--With Rollup
Insert into @Final
Select Punto, ISNULL(Concepto,'TOTAL') Concepto, sum(Importe) as Importe, 0 as Negritas from @TablaTodos group by Punto, Concepto
With Rollup


Update @Final set Negritas = 1 Where Concepto='TOTAL'
Update @Final set Concepto = 'TOTAL GENERAL' Where Punto IS NULL
Select * From @Final

END
GO

EXEC SP_FirmasReporte 'Tarifario Ingresos'
GO

--exec SP_RPT_PuntoRecaudacionTarifario 1, '01-01-2015','03-11-2105'
