/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_CE_Rubro_Tipo]    Script Date: 01/04/2013 16:10:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_CE_Rubro_Tipo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_CE_Rubro_Tipo]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_CE_Rubro_Tipo]    Script Date: 01/04/2013 16:10:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_CE_Rubro_Tipo]
@Fecha as date,
@MostrarVacios as bit,
@FechaFin as date

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
IdClasificacionGI smallint,
IdClasificacionGIPadre smallint,
Grupo1 varchar(7),
Grupo2 varchar(7)
)
--
Declare @Rubro as TABLE(
Clave varchar(7),
Clasificacion varchar(255),	
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,2),
PorcRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,2),
Orden tinyint
)
--
Insert into @Rubro
Exec SP_EstadoEjercicioIngresos_Rubro @Fecha,@FechaFin,0

Insert Into @Tmp_MovimientosPresupuesto (Id, Estimado, Ampliaciones, Reducciones )
SELECT IdPartidaGIDestino as Id, [A] as [Estimado], [M] AS [Ampliaciones], [R] as [Reducciones]
From (
	Select  Sum(Importe) as Tot_Importe, TipoMovimiento, IdPartidaGIDestino
	From T_MovimientosPresupuesto 
	Where IdPartidaGIDestino > 0 And Fecha between @fecha and @FechaFin
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
	Fecha between @Fecha and @FechaFin And IdPartidaGI > 0 
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
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2 
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
ORDER BY C_ClasificacionGasto_2.Clave
--
INSERT INTO @Resultado (Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado)
Select 
Clave,
Clasificacion,
isnull(Total_Estimado,0),
isnull(Total_Modificado,0),
isnull(Total_Devengado,0),
isnull(Total_Recaudado,0)
From @Rubro 
--
UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)

INSERT INTO @Resultado (Clave, Clasificacion,IdClasificacionGI,IdClasificacionGIPadre,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,gast.IdClasificacionGI,gast.IdClasificacionGIPadre,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2  
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado set Grupo1= '0' where LEN(Clave)=4
UPDATE @Resultado set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
--
Delete from @Resultado where Clave not like '__000' and LEN(Clave)=5
Delete from @Resultado where Clave not like '__00' and LEN(Clave)=4
--
INSERT INTO @Resultado (Grupo1,Grupo2,Clasificacion,
Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado)
Select 'I' as Grupo1, '' as Grupo2, 'INGRESOS CORRIENTES' as clasificacion,
(Select SUM (Total_Estimado) from @Resultado where Clave in ('10000','20000','30000','40000','70000','80000','90000')) as Total_Estimado,
(Select SUM (Total_Modificado) from @Resultado where Clave in ('10000','20000','30000','40000','70000','80000','90000')) as Total_Modificado, 
(Select SUM (Total_Devengado) from @Resultado where Clave in ('10000','20000','30000','40000','70000','80000','90000')) as Total_Devengado, 
(Select SUM (Total_Recaudado) from @Resultado where Clave in ('10000','20000','30000','40000','70000','80000','90000')) as Total_Recaudado
--
INSERT INTO @Resultado (Grupo1,Grupo2,Clasificacion,
Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado)
Select 'II' as Grupo1, '' as Grupo2, 'INGRESOS DE CAPITAL' as clasificacion,
(Select SUM (Total_Estimado) from @Resultado where Clave in ('50000','60000')) as Total_Estimado,
(Select SUM (Total_Modificado) from @Resultado where Clave in ('50000','60000')) as Total_Modificado, 
(Select SUM (Total_Devengado) from @Resultado where Clave in ('50000','60000')) as Total_Devengado, 
(Select SUM (Total_Recaudado) from @Resultado where Clave in ('50000','60000')) as Total_Recaudado
--
INSERT INTO @Resultado (Grupo1,Grupo2,Clasificacion,
Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado)
Select 'III' as Grupo1, '' as Grupo2, 'FINANCIAMIENTO' as clasificacion,
(Select SUM (Total_Estimado) from @Resultado where Clave in ('0000')) as Total_Estimado,
(Select SUM (Total_Modificado) from @Resultado where Clave in ('0000')) as Total_Modificado, 
(Select SUM (Total_Devengado) from @Resultado where Clave in ('0000')) as Total_Devengado, 
(Select SUM (Total_Recaudado) from @Resultado where Clave in ('0000')) as Total_Recaudado
--
INSERT INTO @Resultado (Grupo1,Grupo2,Clasificacion,
Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado)
Select '' as Grupo1, 'III.I' as Grupo2, 'Fuentes financieras' as clasificacion,
(Select SUM (Total_Estimado) from @Resultado where Clave in ('0000')) as Total_Estimado,
(Select SUM (Total_Modificado) from @Resultado where Clave in ('0000')) as Total_Modificado, 
(Select SUM (Total_Devengado) from @Resultado where Clave in ('0000')) as Total_Devengado, 
(Select SUM (Total_Recaudado) from @Resultado where Clave in ('0000')) as Total_Recaudado



If @MostrarVacios=1
begin
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado-Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)  as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)  as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0)  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
(case  
when Grupo1='5' then 9.6
when Grupo1='6' then 9.7
when len(clave)= 4 then 10  
when len(clave)=5 then Grupo1 
when len(Clave)=3  then 2
when Grupo1='I' then 0.5 
when Grupo1='II' then 9.5
when Grupo1='III' then 9.8
when Grupo2='III.I' then 9.9
end)as Orden,
IdClasificacionGI,
IdClasificacionGIPadre,
Grupo1,
Grupo2 
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
isnull(Total_Modificado-Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0) as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Estimado,0)),0) as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
(case  
when Grupo1='5' then 9.6
when Grupo1='6' then 9.7
when len(clave)= 4 then 10  
when len(clave)=5 then Grupo1 
when len(Clave)=3  then 2
when Grupo1='I' then 0.5 
when Grupo1='II' then 9.5
when Grupo1='III' then 9.8
when Grupo2='III.I' then 9.9
end)as Orden,
IdClasificacionGI,
IdClasificacionGIPadre,
Grupo1,
Grupo2
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Clave,Orden
END 



GO

EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos Clasificacion economica por Rubro y Tipo'
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1122)
GO
