
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoING]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoING]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
--VALORES ABSOLUTOS
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
If @Todo = 1
	Begin
		Select TS.IdPartidaGI as IdPartida, TS.Clave as Clave , 
		sum(ISNULL(TP.Estimado,0)) as Estimado, 
		sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones, 
		sum(ISNULL(TP.Reducciones ,0)) as Reducciones, 
		sum(ISNULL(TP.Modificado ,0)) as Modificado,
		sum(ISNULL(TP.Devengado ,0)) as Devengado,
		sum(ISNULL(TP.Recaudado ,0)) as Recaudado,  
		sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar,
		case sum(ISNULL(TP.Devengado ,0))
			when 0 then 0
			else (sum(ISNULL(TP.Recaudado ,0)) * 100) /sum(ISNULL(TP.Devengado ,0))
			end as Avance,
		(Select (sum(ISNULL(TP2.Recaudado ,0)) * 100) / sum(ISNULL(TP2.Devengado ,0))   as AvanceTotal  From T_PresupuestoFlujo  As TP2
		where  (Mes BETWEEN @Mes AND @Mes2) AND TP2.Ejercicio  =@Ejercicio)		 
		 as AvanceTotal		 
		From T_PresupuestoFlujo  As TP 
		RIGHT JOIN C_PartidasGastosIngresos  As TS 
		ON TP.IdPartida  = TS.IdPartidaGI
		WHERE  (Mes BETWEEN @Mes AND @Mes2 AND TP.Ejercicio  =@Ejercicio) OR (TS.Ejercicio = @Ejercicio)
		--From T_PresupuestoFlujo  As TP
		--RIGHT JOIN C_PartidasGastosIngresos  As TS 
		--ON  TP.IdPartida  = TS.IdPartidaGI 
		--and  (Mes BETWEEN @Mes AND @Mes2) AND TP.Ejercicio  =@Ejercicio or TS.Ejercicio = @Ejercicio
		group by TS.IdPartidaGI, TS.Clave--,Devengado, Recaudado
		Order By Ts.IdPartidaGI
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
			else (sum(ISNULL(TP.Recaudado ,0)) * 100) /sum(ISNULL(TP.Devengado ,0))
			end as Avance,
		(Select (sum(ISNULL(TP2.Recaudado ,0)) * 100) / sum(ISNULL(TP2.Devengado ,0))   as AvanceTotal  From T_PresupuestoFlujo  As TP2
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



--exec [SP_RPT_EstadoEjercicioPresupuestoING]  1,12,1,2016,'',1


