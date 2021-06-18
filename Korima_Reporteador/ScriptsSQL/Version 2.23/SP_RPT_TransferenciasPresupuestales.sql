/****** Object:  StoredProcedure [dbo].[SP_RPT_TransferenciasPresupuestales]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_TransferenciasPresupuestales]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_TransferenciasPresupuestales]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_TransferenciasPresupuestales]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_RPT_TransferenciasPresupuestales '20160101','20160708'
CREATE PROCEDURE [dbo].[SP_RPT_TransferenciasPresupuestales]
@FechaInicio datetime,
@FechaFin datetime
AS
BEGIN
Select T_MovimientosPresupuesto.Fecha, MesOrigen, MedDestino as MesDestino, IdSelloPresupuestalOrigen,
       T1.Sello as SelloOrigen,IdSelloPresupuestalDestino,T2.Sello as SelloDestino, Importe,
       T_MovimientosPresupuesto.IdPoliza,T_Polizas.Periodo, T_Polizas.NoPoliza 
 from T_MovimientosPresupuesto 
       Inner Join T_SellosPresupuestales as T1
  On T_MovimientosPresupuesto.IdSelloPresupuestalOrigen = T1.IdSelloPresupuestal
       Inner Join T_SellosPresupuestales as T2
  On T_MovimientosPresupuesto.IdSelloPresupuestalDestino = T2.IdSelloPresupuestal
       Left Join T_Polizas
  On T_Polizas.IdPoliza = T_MovimientosPresupuesto.IdPoliza
where T_MovimientosPresupuesto.TipoMovimiento = 'T'
and T_MovimientosPresupuesto.Fecha >= @FechaInicio and T_MovimientosPresupuesto.Fecha <= @FechaFin

END