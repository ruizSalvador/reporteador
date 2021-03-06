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
@MesInicio as int,
@MesFin as int,
@MostrarVacios as bit,
@Ejercicio as int

AS
BEGIN
Declare @PresupuestoFlujo as TABLE(
Ejerciio int,
IdPartida int,
Mes Int,
Estimado decimal(13,2),
Ampliaciones decimal(13,2),
Reducciones decimal(13,2),
Modificado decimal(13,2),
Devengado decimal(13,2),
Recaudado decimal(13,2),
PorRecaudar decimal(13,2)
)

Declare @Resultado as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
AmpliacionesReducciones decimal(15,2)
)
--

INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 


INSERT INTO @Resultado 
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
FROM         @PresupuestoFlujo MovimientosPresupuesto LEFT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
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
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ), 0)  as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0)as ResRecaudado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes
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
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0) as ResRecaudado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Orden,Clave
END 


GO
EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Rubro'
GO

SP_EstadoEjercicioIngresos_Rubro 4,4,1,2013

GO