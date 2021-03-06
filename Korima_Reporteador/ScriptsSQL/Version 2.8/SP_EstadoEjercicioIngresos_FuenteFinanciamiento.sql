/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamiento]    Script Date: 16/01/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamiento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamiento]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamiento]    Script Date: 16/01/2014 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamiento]
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
Grupo2 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
FuenteFinanciamiento varchar(150)
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
Orden tinyint,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)

Declare @Resultado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
--FuenteFinanciamiento varchar(150),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
PorRecaudar decimal (15,2),
PorcModificado decimal (15,2),
PorcDevengado decimal (15,2),
PorcRecaudado decimal (15,2),
SumaPorRecaudar decimal (15,2),
SumaEstimado decimal (15,2),
SumaModificado decimal (15,2),
SumaDevengado decimal (15,2),
SumaRecaudado decimal (15,2),
ResModificado decimal (15,2),
ResDevengado decimal (15,2),
ResRecaudado decimal (15,2),
Orden varchar(10),
IdClasificacionGI int,
IdClasificacionGIPadre int,
Grupo1 varchar(7),
Grupo2 varchar(7),
--Grupo3 varchar(7),
--Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
SumaAmpliacionesReducciones decimal(15,2), 
SumaExcedentes decimal(15,2),
Tribut varchar(100),
ordenado int,
SumaGrupos decimal(15,2)
)
--
INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 
--
Insert into @Rubro
Exec SP_EstadoEjercicioIngresos_Rubro @MesInicio,@MesFin,0,@Ejercicio
--
INSERT INTO @Resultado 
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes,
                      C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento 
FROM         @PresupuestoFlujo MovimientosPresupuesto  LEFT OUTER JOIN
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
                      JOIN
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre, C_FuenteFinanciamiento.DESCRIPCION
                      
ORDER BY C_ClasificacionGasto_2.Clave
--
INSERT INTO @Resultado (Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
Select 
Clave,
Clasificacion,
isnull(Total_Estimado,0),
isnull(Total_Modificado,0),
isnull(Total_Devengado,0),
isnull(Total_Recaudado,0),
isnull(AmpliacionesReducciones,0),
Excedentes 
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

--
UPDATE @Resultado set FuenteFinanciamiento ='(Ingreso sin Clasificar)' where FuenteFinanciamiento is null

Declare @SumaGrupos as TABLE(
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Tribut varchar(150)
)


--
If @FuenteFinanciamiento = ''
begin
-- IF1
If @MostrarVacios=1
begin
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)  as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)  as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
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
Grupo2,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as SumaGrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
Order by Orden,clave
end 
else
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0) as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0) as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
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
Grupo2,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as SumaGrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
and (Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0)
Order by Clave,Orden
END 

else
--IF2
If @MostrarVacios=1
begin
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0)  as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0)  as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)  as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
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
Grupo2,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as Sumagrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
and FuenteFinanciamiento=@FuenteFinanciamiento
union
SELECT 
Clave,
Clasificacion,
0 as Total_Estimado,
0 as Total_Modificado,
0 as Total_Devengado,
0 as Total_Recaudado,
0 as PorRecaudar,
0 as PorcModificado,
0 as PorcDevengado,
0 as PorcRecaudado,
0 as SumaPorRecaudar,
0 as SumaEstimado,
0 as SumaModificado,
0 as SumaDevengado,
0 as SumaRecaudado,
0 as ResModificado,
0 as ResDevengado,
0 as ResRecaudado,
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
Grupo2,
0 as AmpliacionesReducciones,
0 as Excedentes,
0 as SumaAmpliacionesReducciones, 
0 as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as SumaGrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
and FuenteFinanciamiento <> @FuenteFinanciamiento
Order by Orden,clave
end 
else
insert into @Resultado2 
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
isnull((Total_Modificado/nullif(Total_Estimado,0)),0) as PorcModificado,
isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
isnull((Total_Recaudado/nullif(Total_Modificado,0)),0) as PorcRecaudado,
isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0)as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
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
Grupo2,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
isnull((Select Sum(AmpliacionesReducciones)from @Resultado where Grupo2 like '_0'),0) as SumaAmpliacionesReducciones, 
isnull((Select SUM(isnull(Total_Recaudado,0))-sum(isnull(Total_Estimado,0)) from @Resultado where Grupo2 like '_0'),0)as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as SumaGrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
and (Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0)
and FuenteFinanciamiento=@FuenteFinanciamiento
union
SELECT 
Clave,
Clasificacion,
0 as Total_Estimado,
0 as Total_Modificado,
0 as Total_Devengado,
0 as Total_Recaudado,
0 as PorRecaudar,
0 as PorcModificado,
0 as PorcDevengado,
0 as PorcRecaudado,
0 as SumaPorRecaudar,
0 as SumaEstimado,
0 as SumaModificado,
0 as SumaDevengado,
0 as SumaRecaudado,
0 as ResModificado,
0 as ResDevengado,
0 as ResRecaudado,
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
Grupo2,
0 as AmpliacionesReducciones,
0 as Excedentes,
0 as SumaAmpliacionesReducciones, 
0 as SumaExcedentes,
cast(case
         When Clave in (11000,12000,13000,14000,15000,16000,17000,18000) then 'Tributarios'            
		 else 'No Tributarios' end as varchar (max)) as Tribut,
cast(case
		when Grupo2 =40 then 1
		when Grupo2 =50 then 2
		when Grupo2 =60 then 3
		when Grupo2 =30 then 4
		else 0 end as Int) as ordenado, 0 as SumaGrupos
from @Resultado
where Clave in (11000,12000,13000,14000,15000,16000,17000,18000,40000,50000,60000,30000)
and FuenteFinanciamiento <> @FuenteFinanciamiento
Order by Clave,Orden
END 

insert into @SumaGrupos 
select 
SUM(isnull(Total_Estimado,0)),
SUM(isnull(Total_Modificado,0)),
SUM(isnull(Total_Devengado,0)),
SUM(isnull(Total_Recaudado,0)),
Tribut
FROM @Resultado2
group by Tribut
--------------------------------

update @Resultado2 
set a.SumaGrupos = case when b.Total_Recaudado <>0 or b.Total_Modificado<>0 then b.Total_Recaudado/ b.Total_Modificado else 0 end
from @Resultado2 a join
@Sumagrupos b on a.Tribut=b.Tribut 

update @Resultado2 set ResRecaudado=(select SUM(Total_Recaudado)/SUM(Total_Modificado) from @SumaGrupos)

select * from @Resultado2

GO
EXEC SP_FirmasReporte 'Estado del ejercicio de Ingresos Por Fuente de Financiamiento'
GO



