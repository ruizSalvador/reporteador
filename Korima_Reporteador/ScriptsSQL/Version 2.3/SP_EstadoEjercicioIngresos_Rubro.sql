/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_Rubro]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro]
@Fecha as datetime,
@FechaFin as datetime,
@MostrarVacios as bit

AS
BEGIN
DECLARE @Tmp_MovimientosPresupuesto AS TABLE(
Id int,
Aprobado decimal(15,2),
Estimado decimal (15,2),
Ampliaciones decimal(15,2),
Reducciones decimal (15,2),
Modificado decimal (15,2),
Trasferencias decimal(15,2)
)
DECLARE @Tmp_AfectacionPresupuesto AS TABLE(
Id int,
Comprometido decimal(15,2),
Devengado decimal(15,2),
Recaudado decimal(15,2),
Ejercido decimal (15,2),
Pagado decimal(15,2)
)
Declare @Resultado as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7)
)
--
Insert Into @Tmp_MovimientosPresupuesto (Id, Estimado, Ampliaciones, Reducciones )
SELECT IdPartidaGIDestino as Id, [A] as [Estimado], [M] AS [Ampliaciones], [R] as [Reducciones]
From (
	Select  Sum(Importe) as Tot_Importe, TipoMovimiento, IdPartidaGIDestino
	From T_MovimientosPresupuesto 
	--Where IdPartidaGIDestino > 0 And Fecha between @fecha and @FechaFin
	Where IdPartidaGIDestino > 0 And ((MedDestino between MONTH(@Fecha) and month(@FechaFin)) and (Ejercidio between YEAR(@Fecha) and YEAR(@FechaFin)))
	Group By TipoMovimiento, IdPartidaGIDestino ) p
Pivot (
	Sum( Tot_Importe ) 
	For TipoMovimiento In ([A], [M], [R])
) as PivotTable
Where IdPartidaGIDestino > 0 
Order By IdPartidaGIDestino
--
Update @Tmp_MovimientosPresupuesto Set Estimado = 0 Where IsNull( Estimado, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Ampliaciones = 0 Where IsNull( Ampliaciones, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Reducciones = 0 Where IsNull( Reducciones, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Modificado = Estimado + Ampliaciones - Reducciones
--
Insert Into @Tmp_AfectacionPresupuesto (Id, Devengado, Recaudado)
SELECT  IdPartidaGI, [D] as [Devengado], [K] AS [Recaudado]
From (
	Select Sum(Importe) as Tot_Importe, TipoAfectacion, IdPartidaGI
	From T_AfectacionPresupuesto 
	Where Importe <> 0 And 
	--Fecha between @Fecha and @FechaFin  And IdPartidaGI > 0 
	((Mes between MONTH(@Fecha) and MONTH(@FechaFin) )and (Periodo  between YEAR(@Fecha) and YEAR(@FechaFin)))
	And IdPartidaGI > 0
	Group By IdPartidaGI, TipoAfectacion ) p
Pivot (
Sum( Tot_Importe ) 
For TipoAfectacion In ([D], [K] )
) as PivotTable
Where IdPartidaGI > 0 
Order By IdPartidaGI
--
Update @Tmp_AfectacionPresupuesto Set Devengado = 0 Where IsNull( Devengado, 1 ) = 1
--
Update @Tmp_AfectacionPresupuesto Set Recaudado = 0 Where IsNull( Recaudado, 1 ) = 1
--
INSERT INTO @Resultado 
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto LEFT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.Id = C_PartidasGastosIngresos.IdPartidaGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
                      LEFT OUTER JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto 
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave 
ORDER BY C_ClasificacionGasto_3.Clave
--
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
If @MostrarVacios=1
begin
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0)as PorcRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ), 0)  as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResRecaudado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden
from @Resultado
Order by Orden,clave

end 
else
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0)as PorcRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0) as ResRecaudado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Orden,Clave
END 

 
GO
EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Rubro'
GO