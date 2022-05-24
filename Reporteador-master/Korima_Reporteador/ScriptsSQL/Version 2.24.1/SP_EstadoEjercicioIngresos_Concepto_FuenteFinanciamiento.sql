/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]    Script Date: 07/02/2014 17:39:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]    Script Date: 07/02/2014 17:39:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento 1,0,12,'',2016
CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento]
@MesInicio as int,
@MostrarVacios as bit,
@MesFin as int,
@FuenteFinanciamiento as varchar(150),
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



--------------agregado
Declare @PresupuestoFlujoAnual as TABLE(
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
-------------/agregad

Declare @Resultado as TABLE(
Clasificacion varchar(Max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
FuenteFinanciamiento varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2)
)


-------------agregado
Declare @ResultadoAnual as TABLE(
Clasificacion varchar(Max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
FuenteFinanciamiento varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2)
)
----/





Declare @Resultado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(MAx),
FuenteFinanciamiento varchar(max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,4),
PorcRecaudado decimal (15,4),
SumaPorRecaudar decimal (15,2),
SumaEstimado decimal (15,2),
SumaModificado decimal (15,2),
SumaDevengado decimal (15,2),
SumaRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,4),
Orden varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
SumaGrupos decimal(15,4)
)



------Agregado
Declare @Vaciado as TABLE(
Clave varchar(7),
Clasificacion varchar(MAx),
FuenteFinanciamiento varchar(max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,4),
PorcRecaudado decimal (15,4),
SumaPorRecaudar decimal (15,2),
SumaEstimado decimal (15,2),
SumaModificado decimal (15,2),
SumaDevengado decimal (15,2),
SumaRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,4),
Orden varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
SumaGrupos decimal(15,4)
)
------/Agragado

------agregado
Declare @Resultado2Anual as TABLE(
Clave varchar(7),
Clasificacion varchar(MAx),
FuenteFinanciamiento varchar(max),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,4),
PorcRecaudado decimal (15,4),
SumaPorRecaudar decimal (15,2),
SumaEstimado decimal (15,2),
SumaModificado decimal (15,2),
SumaDevengado decimal (15,2),
SumaRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,4),
Orden varchar(Max),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
SumaGrupos decimal(15,4)
)
------/agragado



INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @mesinicio and @mesfin ) and Ejercicio = @Ejercicio 
--
INSERT INTO @Resultado 
--Concepto
SELECT      C_PartidasGastosIngresos.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,4) as Grupo4,
                      ((SUM (isnull(MovimientosPresupuesto.Ampliaciones,0)))+ (SUM (isnull(MovimientosPresupuesto.Reducciones,0)))) AS AmpliacionesReducciones
FROM         @PresupuestoFlujo MovimientosPresupuesto RIGHT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
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
                      JOIN
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave, C_FuenteFinanciamiento.DESCRIPCION, C_PartidasGastosIngresos.Descripcion



--------------agregado
INSERT INTO @PresupuestoFlujoAnual 
SELECT * from T_PresupuestoFlujo
where (mes between 0 and 0 ) and Ejercicio = @Ejercicio 
--agregado


INSERT INTO @ResultadoAnual 
--Concepto
SELECT      C_PartidasGastosIngresos.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,4) as Grupo4,
                      ((SUM (isnull(MovimientosPresupuesto.Ampliaciones,0)))+ (SUM (isnull(MovimientosPresupuesto.Reducciones,0)))) AS AmpliacionesReducciones
FROM         @PresupuestoFlujoAnual MovimientosPresupuesto RIGHT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
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
                      JOIN
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave, C_FuenteFinanciamiento.DESCRIPCION, C_PartidasGastosIngresos.Descripcion
-------------/agregado





--Concepto
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,4) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and 
gast.Descripcion NOT IN( select clasificacion from @Resultado)


--------------agregado
INSERT INTO @ResultadoAnual (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,4) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and 
gast.Descripcion NOT IN( select clasificacion from @ResultadoAnual)
-------------/agregado



UPDATE @Resultado set FuenteFinanciamiento ='(Ingreso sin Clasificar)' where FuenteFinanciamiento is null

--------------agregado
UPDATE @ResultadoAnual set FuenteFinanciamiento ='(Ingreso sin Clasificar)' where FuenteFinanciamiento is null
-------------/agregado

Declare @SumaGrupos as TABLE(
--Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
--Clave varchar(7),
FuenteFinanciamiento varchar(150)
--Grupo1 varchar(7),
--Grupo2 varchar(7),
--Grupo3 varchar(7),
--Grupo4 varchar(7),
--AmpliacionesReducciones decimal(15,2)
)

--------------agregado
Declare @SumaGruposAnual as TABLE(
--Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
--Clave varchar(7),
FuenteFinanciamiento varchar(150)
--Grupo1 varchar(7),
--Grupo2 varchar(7),
--Grupo3 varchar(7),
--Grupo4 varchar(7),
--AmpliacionesReducciones decimal(15,2)
)
-------------/agregado

insert into @SumaGrupos 
select 
--Clasificacion,
SUM(isnull(Total_Estimado,0)),
SUM(isnull(Total_Modificado,0)),
SUM(isnull(Total_Devengado,0)),
SUM(isnull(Total_Recaudado,0)),
--Clave,
FuenteFinanciamiento
--Grupo1,
--Grupo2,
--Grupo3,
--Grupo4,
--AmpliacionesReducciones
FROM @Resultado
group by FuenteFinanciamiento




--------------agregado
insert into @SumaGruposAnual 
select 
--Clasificacion,
SUM(isnull(Total_Estimado,0)),
SUM(isnull(Total_Modificado,0)),
SUM(isnull(Total_Devengado,0)),
SUM(isnull(Total_Recaudado,0)),
--Clave,
FuenteFinanciamiento
--Grupo1,
--Grupo2,
--Grupo3,
--Grupo4,
--AmpliacionesReducciones
FROM @ResultadoAnual
group by FuenteFinanciamiento
-------------/agregado


--1
If @FuenteFinanciamiento = ''
begin
--1a
If @MostrarVacios=1
begin
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0)as PorRecaudar,
case when ISNULL (Total_Estimado,0)<> 0 then
isnull((Total_Modificado/nullif(Total_Estimado,0)),0) else 0 end as PorcModificado,
case when ISNULL (Total_Estimado,0)<> 0 then
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)else 0 end as PorcDevengado,
case when ISNULL(Total_Modificado,0)<> 0 then 
isnull((Total_Recaudado/isnull(Total_Modificado,0)),0)else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
Case when isnull(Total_Modificado,0) <>0 and isnull(Total_Estimado,0) <> 0 then
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResModificado,
Case when isnull(Total_Devengado,0) <>0 and isnull(Total_Estimado,0) <> 0 then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResDevengado,
Case when isnull(Total_Modificado,0) <>0 and isnull(Total_Recaudado,0) <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @Resultado),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @Resultado 
Order by Orden,Grupo4
--1a
end 
else
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull(Total_Recaudado/Total_Modificado,0) else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
Case when Total_Devengado <>0 and Total_Estimado <> 0 then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) else 0 end as ResDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @Resultado ),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
--FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @Resultado
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Clave,Grupo4
end
else
If @MostrarVacios=1
begin
insert into @Resultado2 
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
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Total_Recaudado/Total_Modificado),0) else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
Case when Total_Estimado <>0 and Total_Modificado <>0 then
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResModificado,
Case when Total_Devengado <>0 and Total_Estimado <>0  then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)else 0 end as ResDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @Resultado),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @Resultado
where FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Orden,Grupo4
end 
else
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
Case when Total_Estimado>0 then
isnull(Total_Modificado-Total_Recaudado ,0)else 0 end as PorRecaudar,
Case when Total_Estimado<>0 then
isnull((Total_Modificado/Total_Estimado),0)else 0 end as PorcModificado,
Case when Total_Estimado<>0 then
isnull((Total_Devengado/Total_Estimado),0)else 0 end  as PorcDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Total_Recaudado/Total_Modificado),0)else 0 end  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
isnull((Select SUM(Total_Devengado)/SUM(Total_Estimado) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @Resultado ),0) as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
--FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @Resultado
where (Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0)
AND FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Clave,Grupo4
end

--------------agregado
If @FuenteFinanciamiento = ''
begin
--1a
If @MostrarVacios=1
begin
insert into @Resultado2Anual 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0)as PorRecaudar,
case when ISNULL (Total_Estimado,0)<> 0 then
isnull((Total_Modificado/nullif(Total_Estimado,0)),0) else 0 end as PorcModificado,
case when ISNULL (Total_Estimado,0)<> 0 then
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)else 0 end as PorcDevengado,
case when ISNULL(Total_Modificado,0)<> 0 then 
isnull((Total_Recaudado/isnull(Total_Modificado,0)),0)else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @ResultadoAnual where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaRecaudado,
Case when isnull(Total_Modificado,0) <>0 and isnull(Total_Estimado,0) <> 0 then
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @ResultadoAnual where Grupo2 like '_0'),0)else 0 end as ResModificado,
Case when isnull(Total_Devengado,0) <>0 and isnull(Total_Estimado,0) <> 0 then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @ResultadoAnual where Grupo2 like '_0'),0)else 0 end as ResDevengado,
Case when isnull(Total_Modificado,0) <>0 and isnull(Total_Recaudado,0) <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @ResultadoAnual),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @ResultadoAnual 
Order by Orden,Grupo4
--1a
end 
else
insert into @Resultado2Anual 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull(Total_Recaudado/Total_Modificado,0) else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @ResultadoAnual where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @ResultadoAnual where Grupo2 like '_0'),0)as ResModificado,
Case when Total_Devengado <>0 and Total_Estimado <> 0 then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @ResultadoAnual where Grupo2 like '_0'),0) else 0 end as ResDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @ResultadoAnual ),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
--FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @ResultadoAnual
where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
Order by Clave,Grupo4
end
else
If @MostrarVacios=1
begin
insert into @Resultado2Anual 
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
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Total_Recaudado/Total_Modificado),0) else 0 end as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @ResultadoAnual where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaRecaudado,
Case when Total_Estimado <>0 and Total_Modificado <>0 then
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @ResultadoAnual where Grupo2 like '_0'),0)else 0 end as ResModificado,
Case when Total_Devengado <>0 and Total_Estimado <>0  then
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @ResultadoAnual where Grupo2 like '_0'),0)else 0 end as ResDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @ResultadoAnual),0)else 0 end as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @ResultadoAnual
where FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Orden,Grupo4
end 
else
insert into @Resultado2Anual 
SELECT 
Clave,
Clasificacion,
FuenteFinanciamiento,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
Case when Total_Estimado>0 then
isnull(Total_Modificado-Total_Recaudado ,0)else 0 end as PorRecaudar,
Case when Total_Estimado<>0 then
isnull((Total_Modificado/Total_Estimado),0)else 0 end as PorcModificado,
Case when Total_Estimado<>0 then
isnull((Total_Devengado/Total_Estimado),0)else 0 end  as PorcDevengado,
Case when Total_Modificado <>0 and Total_Recaudado <> 0 then
isnull((Total_Recaudado/Total_Modificado),0)else 0 end  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @ResultadoAnual where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @ResultadoAnual where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/SUM(Total_Estimado) from @ResultadoAnual where Grupo2 like '_0'),0) as ResModificado,
isnull((Select SUM(Total_Devengado)/SUM(Total_Estimado) from @ResultadoAnual where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(isnull(Total_Recaudado,0))/SUM(isnull(Total_Modificado,0)) from @ResultadoAnual ),0) as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
--FuenteFinanciamiento,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as SumaGrupos
from @ResultadoAnual
where (Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0)
AND FuenteFinanciamiento=@FuenteFinanciamiento 
Order by Clave,Grupo4
-------------/agregado


update @Resultado2 
set a.SumaGrupos = case when isnull(b.Total_Modificado,0)<>0  then isnull(b.Total_Recaudado,0)/ b.Total_Modificado else 0 end
from @Resultado2 a join
@SumaGrupos b on a.FuenteFinanciamiento=b.FuenteFinanciamiento 



--------------agregado
update @Resultado2Anual 
set a.SumaGrupos = case when isnull(b.Total_Modificado,0)<>0  then isnull(b.Total_Recaudado,0)/ b.Total_Modificado else 0 end
from @Resultado2Anual a join
@SumaGrupos b on a.FuenteFinanciamiento=b.FuenteFinanciamiento 

-------------/agregado


----Agregado
INSERT INTO @Vaciado
SELECT   A.Clave, 
         A.Clasificacion,
	    A.FuenteFinanciamiento,
	    ISNULL( B.Total_Estimado, 0) as Total_Estimado,
	    ISNULL( B.Total_Estimado, 0) + A.AmpliacionesReducciones  AS Total_Modificado,
	    A.Total_Devengado,
	    A.Total_Recaudado ,
         A.PorRecaudar,
	    A.PorcModificado,
	    A.PorcDevengado,
	    A.PorcRecaudado,
	    A.SumaPorRecaudar,
	    A.SumaEstimado ,
	    A.SumaModificado,
	    A.SumaDevengado,
	    A.SumaRecaudado ,
	    A.ResModificado,
	    A.ResDevengado,
	    A.ResRecaudado ,
	    A.Orden,
	    A.Grupo1,
	    A.Grupo2,
	    A.Grupo3,
	    A.Grupo4 ,
	    A.AmpliacionesReducciones ,
	    A.Excedentes,
	    A.SumaGrupos
 FROM @Resultado2 A LEFT OUTER JOIN @Vaciado B On A.Orden = B.Orden 
 ------/Agregado

 Select * from @Vaciado
-- select * from @Resultado2Anual

--select * from @Resultado2

GO
EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Concepto y Fuente de financiamiento'
GO

UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1125)
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento'
GO



