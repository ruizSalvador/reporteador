/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]    Script Date: 01/16/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]    Script Date: 01/16/2014 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]
@Fecha as date,
@MostrarVacios as bit,
@FechaFin as date,
@FuenteFinanciamiento as varchar(150)

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
Clave varchar(7),
FuenteFinanciamiento varchar(150),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2)
)

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
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,4) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto RIGHT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.Id = C_PartidasGastosIngresos.IdPartidaGI 
                      INNER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      INNER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
                      LEFT OUTER JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto 
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
                      JOIN
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave, C_FuenteFinanciamiento.DESCRIPCION
--Concepto
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,4) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and 
gast.Descripcion NOT IN( select clasificacion from @Resultado)

UPDATE @Resultado set FuenteFinanciamiento ='(Ingreso sin Clasificar)' where FuenteFinanciamiento is null
--1
If @FuenteFinanciamiento = ''
begin
--1a
If @MostrarVacios=1
begin
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0)as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0) as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes
from @Resultado
Order by Orden,Grupo4
--1a
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
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0) as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Clave,Grupo4
end
else
If @MostrarVacios=1
begin
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado-Total_Recaudado ,0)as PorRecaudar,
Case when Total_Estimado <>0 and Total_Modificado <>0 then
isnull((Total_Modificado/Total_Estimado),0) else 0 end as PorcModificado,
Case when Total_Estimado <>0 and Total_Devengado <>0  then
isnull((Total_Devengado/Total_Estimado),0) else 0 end as PorcDevengado,
Case when Total_Estimado <>0 and Total_Recaudado <> 0 then
isnull((Total_Recaudado/Total_Estimado),0) else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
Case when Total_Estimado <>0 and Total_Modificado <>0 then
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResModificado,
Case when Total_Estimado <>0 and Total_Devengado <>0  then
isnull((Select SUM(Total_Devengado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResDevengado,
Case when Total_Estimado <>0 and Total_Recaudado <> 0 then
isnull((Select SUM(Total_Recaudado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0' ),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes
from @Resultado
where FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Orden,Grupo4
end 
else
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
Case when Total_Estimado>0 then
isnull(Total_Modificado-Total_Recaudado ,0)else 0 end as PorRecaudar,
Case when Total_Estimado>0 then
isnull((Total_Modificado/Total_Estimado),0)else 0 end as PorcModificado,
Case when Total_Estimado>0 then
isnull((Total_Devengado/Total_Estimado),0)else 0 end  as PorcDevengado,
Case when Total_Estimado>0 then
isnull((Total_Recaudado/Total_Estimado),0)else 0 end  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
isnull((Select SUM(Total_Devengado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
AND FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Clave,Grupo4
end




GO

EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Concepto y Fuente de financiamiento'
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1125)
GO