/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_Rubro]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_Rubro]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_EstadoEjercicioIngresos_Rubro 1,4,0,2018,0
CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_Rubro]

@MesInicio as int,
@MesFin as int,
@MostrarVacios as bit,
@Ejercicio as int,
@AmpRedAnual as int

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
PorRecaudar decimal(13,2))

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



Declare @Resultado as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
AmpliacionesReducciones decimal(15,2)
)


Declare @ResultadoAnual as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
AmpliacionesReducciones decimal(15,2)
)


Declare @Vaciado as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas bit,
Tab int
)


Declare @Resultado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas bit,
Tab int
)



Declare @Resultado2Anual as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas bit,
Tab int
)


--
--SELECT * from T_PresupuestoFlujo
INSERT INTO @PresupuestoFlujo 
Select * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 

            
INSERT INTO @PresupuestoFlujoAnual
SELECT * FROM T_PresupuestoFlujo
WHERE (mes between 0 and 0) and Ejercicio = @Ejercicio


INSERT INTO @Resultado 
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado,
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
				      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
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
---------------------------resultadoAnual

insert into @ResultadoAnual
 SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado,
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
				      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
FROM         @PresupuestoFlujoAnual MovimientosPresupuesto LEFT OUTER JOIN
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
---------------------------------------------




----TIPO
--INSERT INTO @Resultado
--SELECT     '   '+C_ClasificacionGasto_2.Descripcion AS Clasificacion,
--					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
--					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
--                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
--                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
--                      C_ClasificacionGasto_2.Clave,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
--                      --SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
--                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
--                      --0 as Excedentes
--FROM         @PresupuestoFlujo MovimientosPresupuesto  LEFT OUTER JOIN
--                      C_PartidasGastosIngresos 
--                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto 
--                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
--                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
--                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
--                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
--                      Where substring(C_ClasificacionGasto_2.Clave,1,2) in ('51','52','61','62')
                     
--GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
--                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
                      

				  -----resultadoAnual
--INSERT INTO @ResultadoAnual
--SELECT     '   '+C_ClasificacionGasto_2.Descripcion AS Clasificacion,
--					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
--					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
--                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
--                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
--                      C_ClasificacionGasto_2.Clave,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
--                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
--                      --SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
--                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
--                      --0 as Excedentes
--FROM         @PresupuestoFlujoAnual MovimientosPresupuesto  LEFT OUTER JOIN
--                      C_PartidasGastosIngresos 
--                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto 
--                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
--                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
--                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
--                      LEFT OUTER JOIN
--                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
--                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
--                      Where substring(C_ClasificacionGasto_2.Clave,1,2) in ('51','52','61','62')
                     
--GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
--                      C_ClasificacionGasto_3.IdClasificacionGIPadre

--------------------------------                  






--
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)




---------------------
INSERT INTO @ResultadoAnual (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

---------------------



--
--INSERT INTO @Resultado (Clave, Clasificacion)
--SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
--where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @Resultado) 
--and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))
----

----ResultadoAnual
--INSERT INTO @ResultadoAnual (Clave, Clasificacion)
--SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
--where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @Resultado) 
--and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))

--


If @MostrarVacios=1
	BEGIN
		insert into @Resultado2
			SELECT 
			Clave,
			Clasificacion,
			isnull(Total_Estimado,0) as Total_Estimado,
			isnull(Total_Modificado,0) as Total_Modificado,
			isnull(Total_Devengado,0) as Total_Devengado,
			isnull(Total_Recaudado,0) as Total_Recaudado,
			--isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
			--isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
			--isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
			--isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
			--isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ), 0)  as ResModificado,
			--isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
			--isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0)as ResRecaudado,
			(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
			isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
			(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
			0 as negritas,
			1 as tab
			from @Resultado
			--Order by Orden,clave
			UNION
			SELECT 
			'',
			'Total',
			SUM(isnull(Total_Estimado,0)) as Total_Estimado,
			SUM(isnull(Total_Modificado,0)) as Total_Modificado,
			SUM(isnull(Total_Devengado,0)) as Total_Devengado,
			SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
			--0,
			--0,
			--0,
			--0,
			--0,
			--0,
			--0,
			17 as Orden,
			SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
			SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
			1 as negritas,
			0 as tab
			from @Resultado
			Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
			Order by Orden,clave
			end 
ELSE
		insert into @Resultado2
		SELECT 
		Clave,
		Clasificacion,
		isnull(Total_Estimado,0) as Total_Estimado,
		isnull(Total_Modificado,0) as Total_Modificado,
		isnull(Total_Devengado,0) as Total_Devengado,
		isnull(Total_Recaudado,0) as Total_Recaudado,
		--isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
		--isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
		--isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
		--isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
		--isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResModificado,
		--isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
		--isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0) as ResRecaudado,
		(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
		isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
		isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
		0 as negritas,
		1 as tab
		from @Resultado
		where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
		--Order by Orden,Clave
		UNION
		SELECT 
		'',
		'Total',
		SUM(isnull(Total_Estimado,0)) as Total_Estimado,
		SUM(isnull(Total_Modificado,0)) as Total_Modificado,
		SUM(isnull(Total_Devengado,0)) as Total_Devengado,
		SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
		--0,
		--0,
		--0,
		--0,
		--0,
		--0,
		--0,
		17 as Orden,
		SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
		SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
		1 as negritas,
		0 as tab
		from @Resultado
		Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
		Order by Orden,Clave

		--insert @Resultado2 Values('','Ingresos del Gobierno',null,null,null,null,0,null,null,1,0)
		--update @Resultado2 set Orden=1 where substring(Clave,1,1)='1' 
		--update @Resultado2 set Orden=2 where substring(Clave,1,1)='3' 
		--update @Resultado2 set Orden=3 where substring(Clave,1,1)='4' 
		--update @Resultado2 set Orden=4 where substring(Clave,1,1)='5' 
		--update @Resultado2 set Orden=5 where substring(Clave,1,2)='51' 
		--update @Resultado2 set Orden=6 where substring(Clave,1,2)='52' 
		--update @Resultado2 set Orden=7 where substring(Clave,1,1)='6' 
		--update @Resultado2 set Orden=8 where substring(Clave,1,2)='61' 
		--update @Resultado2 set Orden=9 where substring(Clave,1,2)='62' 
		--update @Resultado2 set Orden=10 where substring(Clave,1,1)='8'
		--insert @Resultado2 Values('','Ingresos de Organismos y Empresas',null,null,null,null,11,null,null,1,0)
		--update @Resultado2 set Orden=12 where substring(Clave,1,1)='2'
		--update @Resultado2 set Orden=13 where substring(Clave,1,1)='7'
		--update @Resultado2 set Orden=14 where substring(Clave,1,1)='9'
		--insert @Resultado2 Values('','Ingresos Derivados de Financiamiento',null,null,null,null,15,null,null,1,0)
		--update @Resultado2 set Orden=16 where substring(Clave,1,1)='0'
		--update @Resultado2 set Clasificacion='     '+Clasificacion  where tab=1


		--select * from @Resultado2 order by Orden

If @MostrarVacios=1
begin
insert into @Resultado2Anual
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
--isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
--isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
--isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
--isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
--isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ), 0)  as ResModificado,
--isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
--isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0)as ResRecaudado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
(isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))as Excedentes,
0 as negritas,
1 as tab
from @ResultadoAnual
--Order by Orden,clave
UNION
SELECT 
'',
'Total',
SUM(isnull(Total_Estimado,0)) as Total_Estimado,
SUM(isnull(Total_Modificado,0)) as Total_Modificado,
SUM(isnull(Total_Devengado,0)) as Total_Devengado,
SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
--0,
--0,
--0,
--0,
--0,
--0,
--0,
17 as Orden,
SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
1 as negritas,
0 as tab
from @ResultadoAnual
Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
Order by Orden,clave
end 
	else
		insert into @Resultado2Anual
		SELECT 
		Clave,
		Clasificacion,
		isnull(Total_Estimado,0) as Total_Estimado,
		isnull(Total_Modificado,0) as Total_Modificado,
		isnull(Total_Devengado,0) as Total_Devengado,
		isnull(Total_Recaudado,0) as Total_Recaudado,
		--isnull(Total_Modificado,0)-isnull(Total_Recaudado ,0) as PorRecaudar,
		--isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
		--isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
		--isnull((Total_Recaudado/nullif(Total_Modificado,0)),0)as PorcRecaudado,
		--isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResModificado,
		--isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado ),0)as ResDevengado,
		--isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Modificado),0) from @Resultado ),0) as ResRecaudado,
		(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
		isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
		isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
		0 as negritas,
		1 as tab
		from @ResultadoAnual
		where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
		--Order by Orden,Clave
		UNION
		SELECT 
		'',
		'Total',
		SUM(isnull(Total_Estimado,0)) as Total_Estimado,
		SUM(isnull(Total_Modificado,0)) as Total_Modificado,
		SUM(isnull(Total_Devengado,0)) as Total_Devengado,
		SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
		--0,
		--0,
		--0,
		--0,
		--0,
		--0,
		--0,
		17 as Orden,
		SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
		SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
		1 as negritas,
		0 as tab
		from @ResultadoAnual
		Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
		Order by Orden,Clave
	END 

If @AmpRedAnual = 1
BEGIN
		INSERT INTO @Vaciado
		SELECT A.Clave, A.Clasificacion,ISNULL( B.Total_Estimado, 0),ISNULL( B.Total_Estimado, 0) + A.AmpliacionesReducciones  AS Total_Modificado/*A.Total_Modificado */,A.Total_Devengado,A.Total_Recaudado ,
		 A.Orden,A.AmpliacionesReducciones ,A.Excedentes,A.Negritas,A.Tab  
		 FROM @Resultado2 A LEFT OUTER JOIN @Resultado2Anual B On A.Clave = B.Clave
END
ELSE
	BEGIN
		INSERT INTO @Vaciado
		SELECT A.Clave, A.Clasificacion,ISNULL( A.Total_Estimado, 0),ISNULL( A.Total_Estimado, 0) + A.AmpliacionesReducciones  AS Total_Modificado/*A.Total_Modificado */,A.Total_Devengado,A.Total_Recaudado ,
		 A.Orden,A.AmpliacionesReducciones ,A.Excedentes,A.Negritas,A.Tab  
		 FROM @Resultado2 A LEFT OUTER JOIN @Resultado2Anual B On A.Clave = B.Clave
	END


SELECT * FROM @Vaciado order by Orden


GO
EXEC SP_FirmasReporte 'Estado sobre el Ejercicio de los Ingresos por Rubro'
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicioIngresos_Rubro'
GO





