/****** Object:  StoredProcedure [dbo].[SP_RPT_LayoutEgresos]    Script Date: 03/03/2017 10:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_LayoutEgresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_LayoutEgresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_LayoutEgresos]    Script Date: 03/03/2017 10:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_LayoutEgresos '20200126',2020,0
Create Procedure [dbo].[SP_RPT_LayoutEgresos]
@date as datetime, @Ejercicio as int, @AmpRedAnual bit
AS

Declare @trimestre int
Declare @mes as int
set @mes = DATEPART(mm, @date)	
set @trimestre = DATEPART(QQ, @date)

Declare @Header as TABLE (
Campo1 varchar (2),
Campo2 int,
Campo3 varchar(100),
Campo4 int,
Campo5 int,
Campo6 int,
Campo7 int,
Campo8 decimal (15,2),
Campo9 decimal (15,2),
Campo10 decimal (15,2),
Campo11 decimal (15,2),
Campo12 decimal (15,2),
Campo13 decimal (15,2),
Rec decimal(15,2),
Campo14 decimal (15,2))

Declare @Detail as TABLE (
Campo1 int,
Campo2 varchar(100),
Campo3 varchar(100),
Campo4 varchar(1),
Campo5 varchar(1),
Campo6 varchar(1),
Campo7 varchar(100),
Campo8 varchar(100),
Campo9 varchar(100),
Campo10 varchar(100),
Campo11 varchar(100),
Campo12 varchar(100),
Campo13 varchar(100),
Campo14 varchar(100),
Campo15 varchar(100),
Campo16 varchar(100),
Campo17 varchar(2),
Campo18 varchar(1),
Campo19 varchar(2),
Campo20 varchar(150),
Campo21 decimal (15,2),
Campo22 decimal (15,2),
Campo23 decimal (15,2),
Campo24 decimal (15,2),
Campo25 decimal (15,2),
Campo26 decimal (15,2),
Rec decimal(15,2),
Campo27 decimal (15,2))

 INSERT INTO @Header
		  Select 'MP',
				    1,
(Select Clave From C_RamoPresupuestal Where IDRAMOPRESUPUESTAL = (Select top 1 IDRAMOPRESUPUESTAL From T_SellosPresupuestales)),
   @Ejercicio,
   @trimestre,
   @mes,
(Select count(TS.IdSelloPresupuestal)  from T_SellosPresupuestales TS WHERE LYear = @Ejercicio),
CASE WHEN @AmpRedAnual = 0 THEN 
	ISNULL((Select SUM(Ampliaciones) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0) + ISNULL((Select SUM(TransferenciaAmp) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0)
ELSE
	ISNULL((Select SUM(Ampliaciones) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes = 0)),0) + ISNULL((Select SUM(TransferenciaAmp) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and 12)),0)
END,
CASE WHEN @AmpRedAnual = 0 THEN 
ISNULL((Select SUM(Reducciones)  from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0) + ISNULL((Select SUM(TransferenciaRed) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0)
ELSE
ISNULL((Select SUM(Reducciones)  from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes = 0)),0) + ISNULL((Select SUM(TransferenciaRed) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and 12)),0)
END,
ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes) and LEFT(TS.IdPartida,1)<>1),0) +
ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and 12) and LEFT(TS.IdPartida,1) = 1),0) ,
ISNULL((Select SUM(Devengado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Ejercido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Pagado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0),
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and MedDestino <= @mes),0),
(ISNULL((Select SUM(Modificado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0) - ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes)),0)) 

Declare @IdPartida int
Declare @IdSello int
Declare @IdSubFuncion int
Declare @IdArea int
Declare @IdTipoGasto int
Declare @IdProyecto int
Declare @IdFuente int
Declare @IdClasGeo int
--Declare @Proyecto int
Declare @IdNivelAdicional3 int

DECLARE Registros CURSOR FOR
SELECT IdSelloPresupuestal, IdAreaResp, IdPartida, IdSubFuncion, IdTipoGasto, IdProyecto, IdFuenteFinanciamiento, IdClasificadorGeografico, IdNivelAdicional3
FROM T_SellosPresupuestales where LYear = @Ejercicio order by IdSelloPresupuestal
  
OPEN Registros
	FETCH NEXT FROM Registros INTO  @IdSello, @IdArea, @IdPartida, @IdSubfuncion, @IdTipoGasto, @IdProyecto, @IdFuente, @IdClasGeo, @IdNivelAdicional3
WHILE @@FETCH_STATUS = 0
		BEGIN
	INSERT INTO @Detail VALUES (
	2,
	(Select Clave From C_RamoPresupuestal Where IDRAMOPRESUPUESTAL = (Select top 1 IDRAMOPRESUPUESTAL From T_SellosPresupuestales)), 
	(Select Clave From C_AreaResponsabilidad Where IdAreaResp = @IdArea),
	(Select SUBSTRING(Clave,1,1) From C_SubFunciones Where IdSubFuncion = @IdSubFuncion),
	(Select SUBSTRING(Clave,2,1) From C_SubFunciones Where IdSubFuncion = @IdSubFuncion),
	(Select SUBSTRING(Clave,3,1) From C_SubFunciones Where IdSubFuncion = @IdSubFuncion),
	(Select Clave From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = @IdProyecto))))),
	(Select Clave From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = @IdProyecto)))),
	(Select SUBSTRING(Clave,1,1) From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = @IdProyecto))),
	(Select SUBSTRING(Clave,2,3) From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = @IdProyecto))),
	(Select Clave From C_EP_RAMO Where Id = (Select IdPadre From C_EP_RAMO Where Id = @IdProyecto)),
	(Select Clave From C_EP_RAMO Where Id = @IdProyecto),
	@IdPartida,
	(Select Clave From C_TipoGasto Where C_TipoGasto.IDTIPOGASTO = @IdTipoGasto),
	(Select SUBSTRING(Clave,1,2) From C_FuenteFinanciamiento Where IDFUENTEFINANCIAMIENTO = @IdFuente),
	(Select SUBSTRING(Clave,3,2) From C_FuenteFinanciamiento Where IDFUENTEFINANCIAMIENTO = @IdFuente),
	(Select (SUBSTRING(Clave ,CHARINDEX('-', Clave) + 1 ,2)) From C_FuenteFinanciamiento Where IDFUENTEFINANCIAMIENTO = @IdFuente),
	(Select SUBSTRING(Clave,1,1) From C_ClasificadorGeograficoPresupuestal Where IdClasificadorGeografico = @IdClasGeo),
	(Select (SUBSTRING(Clave ,CHARINDEX('-', Clave) + 1 ,2)) From C_ClasificadorGeograficoPresupuestal Where IdClasificadorGeografico = @IdClasGeo),
	--(Select Clave From C_ProyectosInversion Where PROYECTO = @Proyecto), 
	(Select Clave From C_NivelAdicional3 Where IdNivelAdicional3 = @IdNivelAdicional3),  --DM 20180309
	CASE WHEN @AmpRedAnual = 0 THEN 
		ISNULL((Select SUM(Ampliaciones)  from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0) + ISNULL((Select SUM(TransferenciaAmp) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0)
	ELSE
		ISNULL((Select SUM(Ampliaciones)  from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES = 0) and TP.IdSelloPresupuestal = @IdSello),0) + ISNULL((Select SUM(TransferenciaAmp) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and 12) and TP.IdSelloPresupuestal = @IdSello),0)
	END,
	CASE WHEN @AmpRedAnual = 0 THEN 
		ISNULL((Select SUM(Reducciones) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0) + ISNULL((Select SUM(TransferenciaRed) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0)
	ELSE
		ISNULL((Select SUM(Reducciones) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES = 0) and TP.IdSelloPresupuestal = @IdSello),0) + ISNULL((Select SUM(TransferenciaRed) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and 12) and TP.IdSelloPresupuestal = @IdSello),0)
	END,
	CASE LEFT(@IdPartida,1)
	WHEN 1 THEN ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and 12) and TP.IdSelloPresupuestal = @IdSello),0)
	ELSE ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0) 
	END,
	--ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0),
	ISNULL((Select SUM(Devengado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0),
	ISNULL((Select SUM(Ejercido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0),
	ISNULL((Select SUM(Pagado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (MES Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0),
	ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= @IdSello and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and MedDestino <= @mes),0),
	(ISNULL((Select SUM(Modificado) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0) - ISNULL((Select SUM(Comprometido) from T_PresupuestoNW TP Inner Join T_SellosPresupuestales TS On TP.IdSelloPresupuestal = TS.IdSelloPresupuestal WHERE LYear = @Ejercicio AND (Mes Between 1 and @mes) and TP.IdSelloPresupuestal = @IdSello),0)))
	
   FETCH NEXT FROM Registros INTO @IdSello, @IdArea, @IdPartida, @IdSubfuncion, @IdTipoGasto, @IdProyecto, @IdFuente, @IdClasGeo, @IdNivelAdicional3  

	END
CLOSE Registros
DEALLOCATE Registros


Select  
Campo1 as F1,
CAST(Campo2 as varchar(1))as F2,
CAST(Campo3 as varchar(100)) as F3,
CAST(Campo4 as varchar(4)) as F4,
CAST(Campo5 as varchar(1)) as F5,
CAST(Campo6 as varchar(2)) as F6,
CAST(Campo7 as varchar(200)) as F7,
CAST(ISNULL(Campo8,0)-ISNULL(Rec,0) as varchar(18)) as F8,
CAST(ISNULL(Campo9,0)-ISNULL(Rec,0) as varchar(18)) as F9,
--CAST(ISNULL(Campo8,0) as varchar(18)) as F8,
--CAST(ISNULL(Campo9,0) as varchar(18)) as F9,
CAST(Campo10 as varchar(18))as F10,
CAST(Campo11 as varchar(18))as F11,
CAST(Campo12 as varchar(18))as F12,
CAST(Campo13 as varchar(18))as F13,
CAST(Campo14 as varchar(18))as F14,
null as F15,
null as F16,
null as F17,
null as F18,
null as F19,
null as F20,
null as F21,
null as F22,
null as F23,
null as F24,
null as F25,
null as F26,
null as F27
 
from @Header

UNION ALL

Select
CAST(Campo1 as varchar(2)) as F1,
Campo2 as F2,
Campo3 as F3,
Campo4 as F4,
CAST(Campo5 as varchar(18)) as F5,
CAST(Campo6 as varchar(18)) as F6,
CAST(Campo7 as varchar(18)) as F7,
CAST(Campo8 as varchar(18)) as F8,
CAST(Campo9 as varchar(18)) as F9,
CAST(Campo10 as varchar(18))as F10,
CAST(Campo11 as varchar(18))as F11,
CAST(Campo12 as varchar(18))as F12,
CAST(Campo13 as varchar(18))as F13,
CAST(Campo14 as varchar(18))as F14,
Campo15 as F15,
Campo16 as F16,
Campo17 as F17,
Campo18 as F18,
Campo19 as F19,
Campo20 as F20,
ISNULL(Campo21,0)-ISNULL(Rec,0) as F21,
ISNULL(Campo22,0)-ISNULL(Rec,0) as F22,
--ISNULL(Campo21,0) as F21,
--ISNULL(Campo22,0) as F22,
Campo23 as F23,
Campo24 as F24,
Campo25 as F25,
Campo26 as F26,
Campo27 as F27

from @Detail
Order by F1 desc

GO

Exec SP_CFG_LogScripts 'SP_RPT_LayoutEgresos','2.30.1'
GO