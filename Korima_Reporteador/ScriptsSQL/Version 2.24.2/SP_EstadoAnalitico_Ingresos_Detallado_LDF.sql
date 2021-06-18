
/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]   Script Date: 2/1/2017 10:45:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]   Script Date: 12/28/2012 10:45:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--Exec SP_EstadoAnalitico_Ingresos_Detallado_LDF 1,1,7,2016
CREATE PROCEDURE [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]

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

--TIPO
INSERT INTO @Resultado
SELECT     '   '+C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
                      --0 as Excedentes
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
                      Where substring(C_ClasificacionGasto_2.Clave,1,2) in ('51','52','61','62')
                     
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
                      

				  -----resultadoAnual
INSERT INTO @ResultadoAnual
SELECT     '   '+C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      
                      
                      
                      
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones
                      --0 as Excedentes
FROM         @PresupuestoFlujoAnual MovimientosPresupuesto  LEFT OUTER JOIN
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
                      Where substring(C_ClasificacionGasto_2.Clave,1,2) in ('51','52','61','62')
                     
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre

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
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @Resultado) 
and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))
--

--ResultadoAnual
INSERT INTO @ResultadoAnual (Clave, Clasificacion)
SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @Resultado) 
and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))

--


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
else
insert into @Resultado2
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,

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


INSERT INTO @Vaciado
SELECT A.Clave, A.Clasificacion,ISNULL( B.Total_Estimado, 0),ISNULL( B.Total_Estimado, 0) + A.AmpliacionesReducciones  AS Total_Modificado/*A.Total_Modificado */,A.Total_Devengado,A.Total_Recaudado ,
 A.Orden,A.AmpliacionesReducciones ,A.Excedentes,A.Negritas,A.Tab  
 FROM @Resultado2 A LEFT OUTER JOIN @Resultado2Anual B On A.Clave = B.Clave

-------------------------------------------------------------------------------------------------------------------------------------------------
--PRIMER PARTE DEL REPORTE
-------------------------------------------------------------------------------------------------------------------------------------------------


--SELECT * FROM @Vaciado order by Orden

Declare @PresupuestoFlujo_2 as TABLE(
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

Declare @Resultado_1 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Resultado2_2 as TABLE(
Clasificacion varchar(255),
Clasificacion2 varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)





INSERT INTO @PresupuestoFlujo_2 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 




INSERT INTO @Resultado_1 
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_2 MovimientosPresupuesto LEFT OUTER JOIN
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
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_2 MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_2 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
UNION
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_2 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave
--ORDER BY C_ClasificacionGasto.Clave
--
UPDATE @Resultado_1 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_1 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_1 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_1 set Grupo4= SUBSTRING(Clave,1,7)
--
--Concepto
INSERT INTO @Resultado_1 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,7) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and gast.Descripcion NOT IN( select clasificacion from @Resultado)



--Clase
INSERT INTO @Resultado_1 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado_1)

--Tipo
INSERT INTO @Resultado_1 (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado_1)

--Rubro
INSERT INTO @Resultado_1 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado_1)

UPDATE @Resultado_1 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_1 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_1 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_1 set Grupo4= SUBSTRING(Clave,1,7)
UPDATE @Resultado_1 set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado_1 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado_1 set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
UPDATE @Resultado_1 set Grupo4= '0' +SUBSTRING(clave,1,3) where LEN(clave)=4



INSERT INTO @Resultado2_2 
(
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes
)
select Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes from @Resultado_1







INSERT INTO @Vaciado
(
Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado2_2  where Grupo4 BETWEEN 80000 AND 89990
---------------------------------------------------------------
--FIN SEGUNDA PARTE DE REPORTE
---------------------------------------------------------------
INSERT INTO @Vaciado VALUES (NULL,'I. Incentivos Derivados de la Colaboracion Fiscal',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          i1) Tenencia o Uso de Vehiculos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          i2) Fondo de Compensacion ISAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          i3) Impuesto Sobre Automoviles Nuevos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          i4) Fondo de Compensacion de Repecos - Intermedios',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          i5) Otros Incentivos Economicos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
----------------------------------------------------
--fin tercera parte del reporte
----------------------------------------------------
Declare @PresupuestoFlujo_3 as TABLE(
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

Declare @Resultado_2 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Resultado2_3 as TABLE(
Clasificacion varchar(255),
Clasificacion2 varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)





INSERT INTO @PresupuestoFlujo_3 
SELECT * from T_PresupuestoFlujo
--where (mes between 01 and 12 ) and Ejercicio = 2016
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio



INSERT INTO @Resultado_2
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_3 MovimientosPresupuesto LEFT OUTER JOIN
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
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_3 MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_3 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
UNION
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_3 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave
--ORDER BY C_ClasificacionGasto.Clave
--
UPDATE @Resultado_2 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_2 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_2 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_2 set Grupo4= SUBSTRING(Clave,1,7)
--
--Concepto
INSERT INTO @Resultado_2 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,7) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and gast.Descripcion NOT IN( select clasificacion from @Resultado_2)



--Clase
INSERT INTO @Resultado_2 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado_2)

--Tipo
INSERT INTO @Resultado_2 (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado_2)

--Rubro
INSERT INTO @Resultado_2 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado_2)

UPDATE @Resultado_2 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_2 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_2 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_2 set Grupo4= SUBSTRING(Clave,1,7)
UPDATE @Resultado_2 set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado_2 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado_2 set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
UPDATE @Resultado_2 set Grupo4= '0' +SUBSTRING(clave,1,3) where LEN(clave)=4



INSERT INTO @Resultado2_3 
(
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes
)
select Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes from @Resultado_2







INSERT INTO @Vaciado
(
Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado2_3   where Grupo4 = 90000
-----------------------------------------------------------------
---fin parte 4
----------------------------------------------------------
Declare @PresupuestoFlujo_4 as TABLE(
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

Declare @Resultado_3 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Resultado2_4 as TABLE(
Clasificacion varchar(255),
Clasificacion2 varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)





INSERT INTO @PresupuestoFlujo_4 
SELECT * from T_PresupuestoFlujo
--where (mes between 01 and 12 ) and Ejercicio = 2016
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio



INSERT INTO @Resultado_3
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_4 MovimientosPresupuesto LEFT OUTER JOIN
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
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_4 MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_4 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
UNION
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_4 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave
--ORDER BY C_ClasificacionGasto.Clave
--
UPDATE @Resultado_3 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_3 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_3 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_3 set Grupo4= SUBSTRING(Clave,1,7)
--
--Concepto
INSERT INTO @Resultado_3 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,7) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and gast.Descripcion NOT IN( select clasificacion from @Resultado_3)



--Clase
INSERT INTO @Resultado_3 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado_3)

--Tipo
INSERT INTO @Resultado_3 (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado_3)

--Rubro
INSERT INTO @Resultado_3 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado_3)

UPDATE @Resultado_3 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_3 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_3 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_3 set Grupo4= SUBSTRING(Clave,1,7)
UPDATE @Resultado_3 set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado_3 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado_3 set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
UPDATE @Resultado_3 set Grupo4= '0' +SUBSTRING(clave,1,3) where LEN(clave)=4



INSERT INTO @Resultado2_4 
(
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes
)
select Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes from @Resultado_3


INSERT INTO @Vaciado
(
Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado2_4   where Grupo4 = 83100
-----------------------------------------------------------------
---fin parte 5
----------------------------------------------------------
Declare @PresupuestoFlujo_5 as TABLE(
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

Declare @Resultado_4 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Resultado2_5 as TABLE(
Clasificacion varchar(255),
Clasificacion2 varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)





INSERT INTO @PresupuestoFlujo_5 
SELECT * from T_PresupuestoFlujo
--where (mes between 01 and 12 ) and Ejercicio = 2016
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio



INSERT INTO @Resultado_4
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_5 MovimientosPresupuesto LEFT OUTER JOIN
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
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_5 MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_5 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
UNION
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_5 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave
--ORDER BY C_ClasificacionGasto.Clave
--
UPDATE @Resultado_4 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_4 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_4 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_4 set Grupo4= SUBSTRING(Clave,1,7)
--
--Concepto
INSERT INTO @Resultado_4 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,7) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)



--Clase
INSERT INTO @Resultado_4 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

--Tipo
INSERT INTO @Resultado_4 (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

--Rubro
INSERT INTO @Resultado_4 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

UPDATE @Resultado_4 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_4 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_4 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_4 set Grupo4= SUBSTRING(Clave,1,7)
UPDATE @Resultado_4 set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado_4 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado_4 set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
UPDATE @Resultado_4 set Grupo4= '0' +SUBSTRING(clave,1,3) where LEN(clave)=4



INSERT INTO @Resultado2_5
(
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes
)
select Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes from @Resultado_4


INSERT INTO @Vaciado
(
Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado2_5   where Grupo4 = 81102
--------------------------------------
-- fin parte 6
----------------------------------------
INSERT INTO @Vaciado VALUES (NULL,'          l2) Otros Ingresos de Libre Disposicion',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'Ingresos Excedentes de Ingresos de Libre Disposicion',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'A. Aportaciones ( A= a1+a2+a3+a4+a5+a6+a7+a8)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a1) Fondo de Aportaciones para la Nomina Educativa y Gasto Operativo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a2) Fondo de aportaciones para los Servicios de Salud',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a3) Fondo de Aportaciones para la Infraestructura  Social',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a4) Fondo de Aportaciones para el Fortalecimiento de los Municipios y de las Demarcaciones Territoriales del  Distrito Federal',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a5) Fondo de Aportaciones Multiples',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a6) Fondo de Aportaciones para la Educacion Tecnologica y de Adultos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a7) Fondo de Aportaciones para la Seguridad Publica de los Estados y del Distrito Federal',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'          a8) Fondo de Aportaciones para el Fortalecimiento de las Entidades Federativas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'B.Convenios ( B= b1+b2+b3+b4)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         b1) Convenios de Proteccion Social en Salud',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         b2) Convenios de Descentralizacion',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         b3) Convenios de Reasignacion',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         b4) Otros Convenios y Subsidios',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'C. Fondo Distintos de Aportaciones (C= c1+c2)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         c1) Fondo para Entidades Federativas y Municipios Productroes de Hidrocarburos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'         c2) Fondo Minero',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'D.Transferencias, Subsidios y Subvenciones, y Pensiones y Jubilaciones',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'E. Otras Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'II.  Total de Trasnferencias Federales Etiquetadas (II=A+B+C+D+E)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
------------------------------------
---fin parte 7
------------------------------------
Declare @PresupuestoFlujo_6 as TABLE(
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

Declare @Resultado_5 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Resultado2_6 as TABLE(
Clasificacion varchar(255),
Clasificacion2 varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Grupo4 varchar(7),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2)
)





INSERT INTO @PresupuestoFlujo_6 
SELECT * from T_PresupuestoFlujo
--where (mes between 01 and 12 ) and Ejercicio = 2016
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio



INSERT INTO @Resultado_5
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_6 MovimientosPresupuesto LEFT OUTER JOIN
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
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes
FROM         @PresupuestoFlujo_6 MovimientosPresupuesto  LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_6 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave
--ORDER BY C_ClasificacionGasto_1.Clave
UNION
--Concepto
SELECT      C_ClasificacionGasto.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
					  C_ClasificacionGasto.Clave,
					  SUBSTRING(C_ClasificacionGasto.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto.Clave,1,3) as Grupo3,
                      SUBSTRING(C_ClasificacionGasto.Clave,1,7) as Grupo4,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )+ SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      0 as Excedentes 
FROM         @PresupuestoFlujo_6 MovimientosPresupuesto RIGHT OUTER JOIN
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
GROUP BY C_ClasificacionGasto.Descripcion, C_ClasificacionGasto.Clave
--ORDER BY C_ClasificacionGasto.Clave
--
UPDATE @Resultado_5 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_5 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_5 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_5 set Grupo4= SUBSTRING(Clave,1,7)
--
--Concepto
INSERT INTO @Resultado_5 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Grupo4 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3,
SUBSTRING(gast.Clave,1,7) as Grupo4
From C_ClasificacionGasto as gast
where gast.Nivel=5 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)



--Clase
INSERT INTO @Resultado_5 (Clave, Clasificacion,Grupo1,Grupo2,Grupo3 )
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

--Tipo
INSERT INTO @Resultado_5 (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

--Rubro
INSERT INTO @Resultado_5 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado_4)

UPDATE @Resultado_5 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado_5 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado_5 set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado_5 set Grupo4= SUBSTRING(Clave,1,7)
UPDATE @Resultado_5 set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado_5 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado_5 set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
UPDATE @Resultado_5 set Grupo4= '0' +SUBSTRING(clave,1,3) where LEN(clave)=4



INSERT INTO @Resultado2_6
(
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes
)
select Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
Clave,
Grupo1,
Grupo2,
Grupo3,
Grupo4,
AmpliacionesReducciones,
Excedentes from @Resultado_5

INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'III. Ingresos Derivados de Financiamientos ( III = A)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

INSERT INTO @Vaciado
(
Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado,
AmpliacionesReducciones,
Excedentes
)
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
isnull(Total_Modificado,0) as Total_Modificado,
isnull(Total_Devengado,0) as Total_Devengado,
isnull(Total_Recaudado,0) as Total_Recaudado,
isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes
from @Resultado2_6   where Grupo4 = 0000

----------------------------------------------
---fin parte 8
--------------------------------------------
INSERT INTO @Vaciado VALUES (NULL,'IV. Total de Ingresos ( IV= I+II+III)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'Datos Informativos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'1. Ingresos Derivados de Financiamientos con Fuente de Pago de Ingresos de Libre Disposicion',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'2. Ingresos Derivados de Financiamientos con Fuente de Pago de Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado VALUES (NULL,'3. Ingresos Derivados de Financiamientos ( 3= 1+ 2)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)






SELECT * FROM @Vaciado --order by Orden

EXEC SP_FirmasReporte 'EstadoAnalitico Ingresos Detallado LDF'
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnalitico_Ingresos_Detallado_LDF'
GO
