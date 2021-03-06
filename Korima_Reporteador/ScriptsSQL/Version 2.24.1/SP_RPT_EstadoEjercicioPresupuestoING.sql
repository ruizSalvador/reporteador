
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoING]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_EstadoEjercicioPresupuestoING 1,12,1,2016,'',1
CREATE PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoING] 


@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(6),
@Todo as bit

AS
BEGIN

If @Tipo=1 
BEGIN
Declare @AllData as Table (IdPartida int, 
Clave varchar (100), 
Estimado decimal(18,2), 
Ampliaciones decimal (18,2),
 Reducciones decimal (18,2), 
 Modificado decimal (18,2),
 Devengado decimal (18,2),
 Recaudado decimal (18,2),  
 PorRecaudar decimal (18,2),
 Avance decimal (18,2),
 AvanceTotal decimal (18,2))
--VALORES ABSOLUTOS
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
If @Todo = 1
	Begin
	Insert into @AllData 
	Select TP.IdPartida  , TS.Clave as Clave , 
		sum(ISNULL(TP.Estimado,0)) as Estimado, 
		sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones, 
		sum(ISNULL(TP.Reducciones ,0)) as Reducciones, 
		sum(ISNULL(TP.Modificado ,0)) as Modificado,
		sum(ISNULL(TP.Devengado ,0)) as Devengado,
		sum(ISNULL(TP.Recaudado ,0)) as Recaudado,  
		sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar,
		case sum(ISNULL(TP.Devengado ,0))
			when 0 then 0
			else (sum(ISNULL(TP.Recaudado ,0)) * 100) /Nullif(sum(ISNULL(TP.Devengado ,0)),0)
			end as Avance,
		(Select (sum(ISNULL(TP2.Recaudado ,0)) * 100) / Nullif(sum(ISNULL(TP2.Devengado ,0)),0)   as AvanceTotal  From T_PresupuestoFlujo  As TP2
		where  (Mes BETWEEN @Mes AND @Mes2) AND TP2.Ejercicio  =@Ejercicio)		 
		 as AvanceTotal		 
		From T_PresupuestoFlujo  As TP, C_PartidasGastosIngresos  As TS 
		Where TP.IdPartida  = TS.IdPartidaGI
		and   (Mes BETWEEN @Mes AND @Mes2) AND TP.Ejercicio  =@Ejercicio
		group by TP.IdPartida, TS.Clave--,Devengado, Recaudado
	UNION ALL
	Select TS.IdPartidaGI as IdPartida, TS.Clave as Clave,
			0 as Estimado, 
			0 as Ampliaciones, 
			0 as Reducciones, 
			0 as Modificado,
			0 as Devengado,
			0 as Recaudado,  
			0 as PorRecaudar,
			0 as Avance,
			0 as AvanceTotal		 
		 From C_PartidasGastosIngresos  As TS 
		Order By TP.IdPartida

		Select  
		IdPartida, 
		Clave, 
	SUM(Estimado) as Estimado, 
	SUM(Ampliaciones) as Ampliaciones,
	SUM(Reducciones) as Reducciones, 
	SUM(Modificado) as Modificado,
	SUM(Devengado) as Devengado,
	 SUM(Recaudado) as Recaudado,  
	 SUM(PorRecaudar) as PorRecaudar,
	SUM(Avance) as Avance,
	SUM(AvanceTotal) as AvanceTotal 
		from @AllData 
		Group by IdPartida, Clave
		order by IdPartida
	End
Else
	Begin
		Select TP.IdPartida  , TS.Clave as Clave , 
		sum(ISNULL(TP.Estimado,0)) as Estimado, 
		sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones, 
		sum(ISNULL(TP.Reducciones ,0)) as Reducciones, 
		sum(ISNULL(TP.Modificado ,0)) as Modificado,
		sum(ISNULL(TP.Devengado ,0)) as Devengado,
		sum(ISNULL(TP.Recaudado ,0)) as Recaudado,  
		sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar,
		case sum(ISNULL(TP.Devengado ,0))
			when 0 then 0
			else (sum(ISNULL(TP.Recaudado ,0)) * 100) /Nullif(sum(ISNULL(TP.Devengado ,0)),0)
			end as Avance,
		(Select (sum(ISNULL(TP2.Recaudado ,0)) * 100) / Nullif(sum(ISNULL(TP2.Devengado ,0)),0)   as AvanceTotal  From T_PresupuestoFlujo  As TP2
		where  (Mes BETWEEN @Mes AND @Mes2) AND TP2.Ejercicio  =@Ejercicio)		 
		 as AvanceTotal		 
		From T_PresupuestoFlujo  As TP, C_PartidasGastosIngresos  As TS 
		Where TP.IdPartida  = TS.IdPartidaGI
		and   (Mes BETWEEN @Mes AND @Mes2) AND TP.Ejercicio  =@Ejercicio
		group by TP.IdPartida, TS.Clave--,Devengado, Recaudado
		Order By TP.IdPartida

	End

END

END


Exec SP_FirmasReporte 'Clasificación General'
GO
Exec SP_CFG_LogScripts 'SP_RPT_EstadoEjercicioPresupuestoING'
GO



