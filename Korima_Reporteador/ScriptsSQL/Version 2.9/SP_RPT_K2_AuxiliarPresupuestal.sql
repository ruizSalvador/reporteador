/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarPresupuestal]    Script Date: 10/06/2014 12:50:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AuxiliarPresupuestal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AuxiliarPresupuestal]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AuxiliarPresupuestal]    Script Date: 10/06/2014 12:50:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_AuxiliarPresupuestal]
@MesInicio INT,
@MesFin INT,
@Ejercicio INT,
@IdSello INT,
@IdSelloFin INT
AS
BEGIN 
Declare @Resultado table(
IdSelloPresupuestal Int,
Sello varchar(max),
IdMovimiento int,
Fecha date,
TipoMovimiento varchar(max),
IdPoliza varchar(max),
ImporteComprometido decimal (18,4),
Devengado decimal (18,4),
Ejercido decimal (18,4),
Pagado decimal (18,4),
Tipo varchar(max),
PeriodoFolio int,
c1 varchar(max),
c2 varchar(max),
c3 varchar(max),
c4 varchar(max),
c5 varchar(max),
c6 varchar(max),
c7 varchar(max),
c8 varchar(max),
c9 varchar(max)
)
--PRESUPUESTO
DECLARE @tablaPresupuesto AS TABLE(
	IdSelloPresupuestal INT,
	Sello VARCHAR(MAX), 
	IdMovimiento INT,
	Fecha DATE,
	Mes INT,
	Ejercicio INT,
	TipoMovimiento VARCHAR(MAX), 
	Importe DECIMAL(18,4),
	IdPoliza int)
	
INSERT INTO @tablaPresupuesto
--ORIGEN
		SELECT 
		T_MovimientosPresupuesto.IdSelloPresupuestalOrigen,
		T_SellosPresupuestales.Sello as Sello,
		T_MovimientosPresupuesto.IdMovimiento,
		T_MovimientosPresupuesto.Fecha,
		T_MovimientosPresupuesto.MesOrigen as Mes,
		T_MovimientosPresupuesto.Ejercidio as Ejercicio,
		CASE T_MovimientosPresupuesto.TipoMovimiento
		WHEN 'A' THEN 'Aprobado'
		WHEN 'M' THEN 'Ampliación'
		WHEN 'R' THEN 'Reducción'
		WHEN 'T' THEN 'Transferencia (-) '
		ELSE 'Modificado' END AS TipoMovimiento, 
		T_MovimientosPresupuesto.Importe,
		T_MovimientosPresupuesto.IdPoliza
		FROM T_MovimientosPresupuesto
		JOIN T_SellosPresupuestales 
		ON T_SellosPresupuestales.IdSelloPresupuestal=T_MovimientosPresupuesto.IdSelloPresupuestalOrigen
		WHERE YEAR(T_MovimientosPresupuesto.Fecha)= @Ejercicio 
		AND MONTH(T_MovimientosPresupuesto.Fecha) BETWEEN @MesInicio AND @MesFin 
		UNION
		--DESTINO
		SELECT 
		T_MovimientosPresupuesto.IdSelloPresupuestalDestino,
		T_SellosPresupuestales.Sello as Sello,
		T_MovimientosPresupuesto.IdMovimiento,
		T_MovimientosPresupuesto.Fecha,
		T_MovimientosPresupuesto.MedDestino as Mes,
		T_MovimientosPresupuesto.Ejercidio as Ejercicio,
		CASE T_MovimientosPresupuesto.TipoMovimiento
		WHEN 'A' THEN 'Aprobado'
		WHEN 'M' THEN 'Ampliación'
		WHEN 'R' THEN 'Reducción'
		WHEN 'T' THEN 'Transferencia (+) '
		ELSE 'Modificado' END AS TipoMovimiento, 
		T_MovimientosPresupuesto.Importe,
		T_MovimientosPresupuesto.IdPoliza
		FROM T_MovimientosPresupuesto
		JOIN T_SellosPresupuestales 
		ON T_SellosPresupuestales.IdSelloPresupuestal=T_MovimientosPresupuesto.IdSelloPresupuestalDestino 
		
		WHERE --YEAR(T_MovimientosPresupuesto.Fecha)= @Ejercicio 
		--AND MONTH(T_MovimientosPresupuesto.Fecha) BETWEEN @MesInicio AND @MesFin
		--AND 
		T_MovimientosPresupuesto.Ejercidio= @Ejercicio 
		AND T_MovimientosPresupuesto.MedDestino BETWEEN @MesInicio AND @MesFin
		--AND T_MovimientosPresupuesto.IdSelloPresupuestalDestino = @IdSello

--PRESUPUESTO MODIFICADO		 
INSERT into @tablaPresupuesto 
SELECT t.IdSelloPresupuestal,
	t.Sello, 
	t.IdMovimiento,
	t.Fecha,
	t.Mes,
	t.Ejercicio,
	'Modificado', 
	T_PresupuestoNW.Modificado as Importe,
	t.IdPoliza from @TablaPresupuesto t
	JOIN T_PresupuestoNW ON T_PresupuestoNW.IdSelloPresupuestal= t.IdSelloPresupuestal
	AND t.Mes=T_PresupuestoNW.Mes 
	AND t.Ejercicio= T_PresupuestoNW.Year
	
	--COSULTA FINAL	
IF @IdSello<>0 BEGIN 
insert into @Resultado 
SELECT 
IdSelloPresupuestal,
Sello,
IdMovimiento,
Fecha,
TipoMovimiento,
IdPoliza,
Importe,
0 as devengado,
0 as Ejercido,
0 as Pagado,
'1' as Tipo,
mes as PeriodoFolio,
'Id Movimiento' as c1,
'Fecha' as c2,
'Tipo de Movimiento' as c3,
'No. Poliza' as c4,
'Importe' as c5,
'' as c6,
'' as c7,
'' as c8,
'Periodo'as c9
FROM @tablaPresupuesto WHERE IdSelloPresupuestal between @IdSello and @IdSelloFin ORDER BY IdSelloPresupuestal 

END
ELSE BEGIN

insert into @Resultado 
SELECT 
IdSelloPresupuestal,
Sello,
IdMovimiento,
Fecha,
TipoMovimiento,
IdPoliza,
Importe,
0 as devengado,
0 as Ejercido,
0 as Pagado,
'1' as Tipo,
mes as PeriodoFolio,
'Id Movimiento' as c1,
'Fecha' as c2,
'Tipo de Movimiento' as c3,
'No. Poliza' as c4,
'Importe' as c5,
'' as c6,
'' as c7,
'' as c8,
'Periodo' as c9
FROM @tablaPresupuesto ORDER BY IdSelloPresupuestal

END

DECLARE @tablaMovimientos AS TABLE (
	IdSelloPresupuestal INT,
	Sello VARCHAR(MAX),
	IdMov INT,
	Fecha DATE,
	TipoMovimientoGenera varchar(MAX),
	IdPoliza INT,
	Comprometido DECIMAL (18,4),
	Devengado DECIMAL (18,4),
	Ejercido DECIMAL (18,4),
	Pagado DECIMAL (18,4))
INSERT INTO @tablaMovimientos
		SELECT 
		T_AfectacionPresupuesto.IdSelloPresupuestal,
		T_SellosPresupuestales.Sello,
		T_AfectacionPresupuesto.IdMovimiento,
		T_AfectacionPresupuesto.Fecha,
		CASE T_AfectacionPresupuesto.TipoMovimientoGenera
		WHEN 'P' THEN 'Orden de Compra'
		WHEN 'S' THEN 'Orden de servicio'
		WHEN 'F' THEN 'Recepción factura'
		WHEN 'B' THEN 'Aprobacion de solicitud de egresos'
		WHEN 'C' THEN 'Cheque / Tranferencia electónica'
		WHEN 'G' THEN 'Gastos por comprobar'
		WHEN 'N' THEN 'Devengado nómina'
		WHEN 'W' THEN 'Nota de crédito'
		WHEN 'Y' THEN 'Recibo de caja'
		WHEN 'H' THEN 'Factura de venta'
		WHEN 'M' THEN 'Nómina comprometido'
		ELSE '' END AS TipoMovimientoGenera,
		T_AfectacionPresupuesto.IdPoliza,
		CASE T_AfectacionPresupuesto.TipoAfectacion WHEN 'C' THEN T_AfectacionPresupuesto.Importe ELSE 0 END AS Comprometido,
		CASE T_AfectacionPresupuesto.TipoAfectacion WHEN 'D' THEN T_AfectacionPresupuesto.Importe ELSE 0 END AS Devengado,
		CASE T_AfectacionPresupuesto.TipoAfectacion WHEN 'E' THEN T_AfectacionPresupuesto.Importe ELSE 0 END AS Ejercido,
		CASE T_AfectacionPresupuesto.TipoAfectacion WHEN 'P' THEN T_AfectacionPresupuesto.Importe ELSE 0 END AS Pagado
		FROM T_AfectacionPresupuesto
		JOIN T_SellosPresupuestales 
		ON T_SellosPresupuestales.IdSelloPresupuestal=T_AfectacionPresupuesto.IdSelloPresupuestal
		WHERE T_AfectacionPresupuesto.Periodo=@Ejercicio AND T_AfectacionPresupuesto.Mes BETWEEN @MesInicio and @MesFin 
		AND T_AfectacionPresupuesto.TipoAfectacion IN ('C','D','E','P')
		--AND T_AfectacionPresupuesto.IdSelloPresupuestal= @IdSello

--CONSULTA FINAL
IF @IdSello <>0 BEGIN 
insert into @Resultado 
SELECT 
IdSelloPresupuestal,
Sello,
IdMov,
Fecha,
TipoMovimientoGenera,
IdPoliza,
Comprometido,
Devengado,
Ejercido,
Pagado,
'2' as Tipo,
0 as PeriodoFolio,
'Id Movimiento' as c1,
'Fecha' as c2,
'Movimiento' as c3,
'Polizas' as c4,
'Comprometido' as c5,
'Devengado' as c6,
'Ejercido' as c7,
'Pagado'  as c8,
'Folio' as c9
from @tablaMovimientos Where IdSelloPresupuestal between @IdSello and @IdSelloFin  ORDER BY IdSelloPresupuestal 
END
ELSE BEGIN 
insert into @Resultado 
SELECT 
IdSelloPresupuestal,
Sello,
IdMov,
Fecha,
TipoMovimientoGenera,
IdPoliza,
Comprometido,
Devengado,
Ejercido,
Pagado,
'2' as Tipo,
0 as PeriodoFolio,
'Id Movimiento' as c1,
'Fecha' as c2,
'Movimiento' as c3,
'Polizas' as c4,
'Comprometido' as c5,
'Devengado' as c6,
'Ejercido' as c7,
'Pagado'  as c8, 
'Folio'as c9
FROM @tablaMovimientos ORDER BY IdSelloPresupuestal
END
--CONSULTA POLIZAS y FOLIOS RESTANTES
update @resultado set idpoliza=T_Recepcionfacturas.IdPoliza, PeriodoFolio= T_RecepcionFacturas.Folio from @Resultado  join T_Recepcionfacturas ON idMovimiento = IdRecepcionServicios where TipoMovimiento='Recepción factura'
update @resultado set idpoliza=T_Viaticos.IdPoliza, PeriodoFolio = T_Viaticos.Folio from @Resultado  join T_Viaticos ON idMovimiento = IdViaticos where TipoMovimiento='Gastos por comprobar'
update @resultado set idpoliza=T_SolicitudCheques.IdPolizaPresupuestoEjercido, PeriodoFolio= T_SolicitudCheques.FolioPorTipo from @Resultado  join T_SolicitudCheques ON idMovimiento = IdSolicitudCheques where TipoMovimiento='Aprobacion de solicitud de egresos'

--SIN USO
--update @resultado set idpoliza=T_NotaCredito.IdPoliza, PeriodoFolio= T_NotaCredito.Folio from @Resultado  join T_NotaCredito ON idMovimiento = IdNotaCredito where TipoMovimiento='Nota de crédito'
--update @resultado set idpoliza=T_RecibosCaja.IdPoliza, PeriodoFolio= T_RecibosCaja.Folio from @Resultado  join T_RecibosCaja ON idMovimiento = IdIngreso where TipoMovimiento='Recibo de caja'
--update @resultado set idpoliza=T_Facturas.IdPoliza, PeriodoFolio= T_Facturas.Folio from @Resultado  join T_Facturas ON idMovimiento = IdFactura where TipoMovimiento='Factura de venta'

--folio e id identicos
update @resultado set idpoliza=T_Cheques.IdPolizaPresupuestoPagado, PeriodoFolio=T_Cheques.IdPolizaPresupuestoPagado  from @Resultado  join T_Cheques ON idMovimiento = IdCheques where TipoMovimiento='Cheque / Tranferencia electónica'
update @resultado set idpoliza=T_ImportaNomina.IdPoliza, PeriodoFolio= T_ImportaNomina.IdPoliza  from @Resultado  join T_ImportaNomina ON idMovimiento = IdNomina where TipoMovimiento='Devengado nómina'

--Solo se actualizan solo Folios
update @resultado set PeriodoFolio= T_Pedidos.Folio from @Resultado  JOIN T_Pedidos ON idMovimiento = IdPedido where TipoMovimiento='Orden de Compra'
update @resultado set PeriodoFolio= T_OrdenServicio.Folio from @Resultado  JOIN T_OrdenServicio ON idMovimiento = IdOrden where TipoMovimiento='Orden de servicio'
update @Resultado set PeriodoFolio=IdMovimiento where TipoMovimiento='Nómina comprometido'



--actualiza de id de poliza a numero de poliza
update @Resultado set IdPoliza='D'+ convert(Varchar(max),T_Polizas.Periodo)+' ' +convert(varchar(max),T_Polizas.NoPoliza) From @Resultado R JOIN T_Polizas ON R.IdPoliza=T_Polizas.IdPoliza 

select * from @Resultado 

END

GO

EXEC SP_FirmasReporte 'AuxiliarPresupuestal'
GO