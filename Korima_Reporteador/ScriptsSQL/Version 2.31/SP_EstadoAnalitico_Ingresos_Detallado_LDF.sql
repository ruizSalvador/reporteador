
/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]    Script Date: 24/08/2018 01:37:00 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]    Script Date: 24/08/2018 01:37:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec SP_EstadoAnalitico_Ingresos_Detallado_LDF 1,12,1,2021
CREATE PROCEDURE [dbo].[SP_EstadoAnalitico_Ingresos_Detallado_LDF]
@MesInicio as int,
@MesFin as int,
@MostrarVacios as bit,
@Ejercicio as int

AS
BEGIN


declare @var1 decimal(15,2)
declare @var2 decimal(15,2)
declare @var3 decimal(15,2)
declare @var4 decimal(15,2)
declare @var5 decimal(15,2)

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
Orden int,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden int,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Resultado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden int,
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
Orden int,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas bit,
Tab int
)


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
					  LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
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
					  Where C_FuenteFinanciamiento.IdClave in (11,14,15,16,17)
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave 
ORDER BY C_ClasificacionGasto_3.Clave
--

---------------------------

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
					  LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
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
					  Where C_FuenteFinanciamiento.IdClave in (11,14,15,16,17)
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
					  LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
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
					  AND C_FuenteFinanciamiento.IdClave in (11,14,15,16,17)
                     
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
					  LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
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
					  AND C_FuenteFinanciamiento.IdClave in (11,14,15,16,17)
                     
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre

--------------------------------   
--
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

-------------------------------------------------------------------------------------------
Declare @Ingresos as table(IdClaveFF varchar(100), DescripcionFF varchar(max), Clave varchar(max),
Estimado decimal(18,4), Modificado decimal(18,4),
Devengado decimal(18,4), Recaudado decimal(18,4), AmpliacionesReducciones decimal (18,2))


Insert Into @Ingresos
SELECT    
 C_FuenteFinanciamiento.IdClave, 
                      C_FuenteFinanciamiento.DESCRIPCION , C_PartidasGastosIngresos.Clave,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado, 
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado,  
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado, 
                      --C_ClasificacionGasto_3.Clave as Clave, 
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(ABS(MovimientosPresupuesto.Reducciones),0)) AS AmpliacionesReducciones 
                     
		            FROM  @PresupuestoFlujo MovimientosPresupuesto LEFT OUTER JOIN 
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI  
                     
                     LEFT JOIN 
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento  

					GROUP BY --C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave, C_FuenteFinanciamiento.CLAVE,
                      C_FuenteFinanciamiento.DESCRIPCION ,C_FuenteFinanciamiento.IdClave, C_PartidasGastosIngresos.Clave
-------------------------------------------------------------------------------------------

--select * from @Resultado

DELETE FROM @Resultado Where Clave = '80000'
DELETE FROM @Resultado Where Clave = '90000'
DELETE FROM @Resultado Where Clave = '00000'
DELETE FROM @Resultado Where Clave = '51000'
DELETE FROM @Resultado Where Clave = '61000'

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

	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='IMPUESTOS')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('1000','IMPUESTOS')
	END
	
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('2000','CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL')
	END
	
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='CONTRIBUCIONES DE MEJORA' OR Clasificacion = 'Contribuciones de mejoras')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('3000','CONTRIBUCIONES DE MEJORA')
	END
	
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='DERECHOS')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('4000','DERECHOS')
	END
	
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='PRODUCTOS')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('5000','PRODUCTOS')
	END
	
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='APROVECHAMIENTOS')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('6000','APROVECHAMIENTOS')
	END
	 
	 IF NOT EXISTS( SELECT Clasificacion FROM @Resultado   WHERE Clasificacion ='INGRESOS POR VENTA DE BIENES Y SERVICIOS' OR Clasificacion = 'Ingresos por venta de bienes, prestación de servicios y otros ingresos')
    BEGIN
	INSERT INTO @Resultado (Clave, Clasificacion) VALUES('7000','INGRESOS POR VENTA DE BIENES Y SERVICIOS')
	END

--select * from @Resultado

UPDATE @Resultado SET Clasificacion ='A. Impuestos' WHERE Clasificacion = 'IMPUESTOS'
UPDATE @Resultado SET Clasificacion ='B. Cuotas y Aportaciones de Seguridad Social' WHERE Clasificacion = 'CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL'
UPDATE @Resultado SET Clasificacion ='C. Contribuciones de Mejoras' WHERE Clasificacion = 'CONTRIBUCIONES DE MEJORA' OR Clasificacion = 'Contribuciones de mejoras'
UPDATE @Resultado SET Clasificacion ='D. Derechos' WHERE Clasificacion = 'DERECHOS'
UPDATE @Resultado SET Clasificacion ='E. Productos' WHERE Clasificacion = 'PRODUCTOS'
UPDATE @Resultado SET Clasificacion ='F. Aprovechamientos' WHERE Clasificacion = 'APROVECHAMIENTOS'
UPDATE @Resultado SET Clasificacion ='G. Ingresos por Venta de Bienes y Prestación de Servicios' WHERE Clasificacion = 'INGRESOS POR VENTA DE BIENES Y SERVICIOS' OR Clasificacion = 'Ingresos por venta de bienes, prestación de servicios y otros ingresos'



INSERT INTO @ResultadoAnual (Clave, Clasificacion)
SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @Resultado) 
and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))




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



If @MostrarVacios=1
begin

INSERT INTO @Vaciado VALUES(NULL,'Ingresos de Libre Disposición',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL)
end



--INSERT INTO @Vaciado
--SELECT A.Clave, A.Clasificacion,ISNULL( B.Total_Estimado, 0),ISNULL( B.Total_Estimado, 0) + ISNULL( A.AmpliacionesReducciones, 0)  AS Total_Modificado/*A.Total_Modificado */,A.Total_Devengado,A.Total_Recaudado ,
-- A.Orden,A.AmpliacionesReducciones ,A.Excedentes,A.Negritas,A.Tab  
 --FROM @Resultado2 A LEFT OUTER JOIN @Resultado2Anual B On A.Clave = B.Clave

INSERT INTO @Vaciado
SELECT A.Clave, A.Clasificacion,ISNULL( A.Total_Estimado, 0),ISNULL( A.Total_Estimado, 0) + ISNULL( A.AmpliacionesReducciones, 0)  AS Total_Modificado/*A.Total_Modificado */,A.Total_Devengado,A.Total_Recaudado ,
 A.Orden,A.AmpliacionesReducciones ,A.Excedentes,A.Negritas,A.Tab  
 FROM @Resultado2 A LEFT OUTER JOIN @Resultado2Anual B On A.Clave = B.Clave

 Update @Vaciado set Orden = CAST(LEFT(Clave,1) as int) Where Clave is not null

 If @MostrarVacios=1
begin

INSERT INTO @Vaciado (Clasificacion,Orden) VALUES('H. Participaciones (H=h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11)',8)
INSERT INTO @Vaciado (Clasificacion) VALUES('   h1) Fondo General de Participaciones ')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h2) Fondo de Fomento Municipal')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h3) Fondo de Fiscalización y Recaudación')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h4) Fondo de Compensación')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h5) Fondo de Extracción de Hidrocarburos')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h6) Impuesto Especial Sobre Producción y Servicios')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h7) 0.136% de la Recaudación Federal Participable')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h8) 3.17% Sobre Extracción de Petróleo')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h9) Gasolinas y Diésel')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h10) Fondo del Impuesto Sobre la Renta')
INSERT INTO @Vaciado (Clasificacion) VALUES('   h11) Fondo de Estabilización de los Ingresos de las Entidades Federativas')
INSERT INTO @Vaciado (Clasificacion,Orden) VALUES('I. Incentivos Derivados de la Colaboración Fiscal (I=i1+i2+i3+i4+i5)',9)
INSERT INTO @Vaciado (Clasificacion) VALUES('   i1) Tenencia o Uso de Vehículos')
INSERT INTO @Vaciado (Clasificacion) VALUES('   i2) Fondo de Compensación ISAN')
INSERT INTO @Vaciado (Clasificacion) VALUES('   i3) Impuesto Sobre Automóviles Nuevos')
INSERT INTO @Vaciado (Clasificacion) VALUES('   i4) Fondo de Compensación de Repecos-Intermedios')
INSERT INTO @Vaciado (Clasificacion) VALUES('   i5) Otros Incentivos Económicos')
INSERT INTO @Vaciado (Clasificacion,Orden) VALUES('J. Transferencias y Asignaciones',10)
INSERT INTO @Vaciado (Clasificacion,Orden) VALUES('K. Convenios',11)
INSERT INTO @Vaciado (Clasificacion, Orden) VALUES('   k1) Otros Convenios y Subsidios',30)
INSERT INTO @Vaciado (Clasificacion,Orden) VALUES('L. Otros Ingresos de Libre Disposición (L=l1+l2)',12)
INSERT INTO @Vaciado (Clasificacion) VALUES('   l1) Participaciones en Ingresos Locales')
INSERT INTO @Vaciado (Clasificacion) VALUES('   l2) Otros Ingresos de Libre Disposición')

DELETE FROM @Vaciado Where Clasificacion = 'Total'
 
 
 
UPDATE @Vaciado set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81') and IdClaveFF in ('11','14','15','16','17')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81') and IdClaveFF in ('11','14','15','16','17')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81') and IdClaveFF in ('11','14','15','16','17')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81') and IdClaveFF in ('11','14','15','16','17')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81') and IdClaveFF in ('11','14','15','16','17'))
			Where Orden = 8

UPDATE @Vaciado set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('84') and IdClaveFF in ('11','14','15','16','17')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('84') and IdClaveFF in ('11','14','15','16','17')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('84') and IdClaveFF in ('11','14','15','16','17')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('84') and IdClaveFF in ('11','14','15','16','17')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('84') and IdClaveFF in ('11','14','15','16','17'))
			Where Orden = 9

UPDATE @Vaciado set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91') and IdClaveFF in ('11','14','15','16','17')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91') and IdClaveFF in ('11','14','15','16','17')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91') and IdClaveFF in ('11','14','15','16','17')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91') and IdClaveFF in ('11','14','15','16','17')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91') and IdClaveFF in ('11','14','15','16','17'))
			Where Orden = 10

UPDATE @Vaciado set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('11','14','15','16','17')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('11','14','15','16','17')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('11','14','15','16','17')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('11','14','15','16','17')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('11','14','15','16','17'))
			Where Orden in (11,30)

UPDATE @Vaciado set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82','85','93','95','97','99') and IdClaveFF in ('11','14','15','16','17')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82','85','93','95','97','99') and IdClaveFF in ('11','14','15','16','17')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82','85','93','95','97','99') and IdClaveFF in ('11','14','15','16','17')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82','85','93','95','97','99') and IdClaveFF in ('11','14','15','16','17')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82','85','93','95','97','99') and IdClaveFF in ('11','14','15','16','17'))
			Where Orden = 12


end

DELETE FROM @Vaciado Where Clasificacion = 'Total'
-------------------------------------------------------------------------------------------------------------------------------------------------
--PRIMER PARTE DEL REPORTE
-------------------------------------------------------------------------------------------------------------------------------------------------

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


If @MostrarVacios=1
begin
		

	UPDATE @Resultado_1 SET Clasificacion ='         l1) Participaciones en Ingresos Locales ' where clave = 81102
    UPDATE @Resultado_1 SET Clasificacion ='k1) Otros Convenios y Subsidios' WHERE Clave = 83100

	
	 UPDATE @Vaciado SET  Clave  = 83100 where  Clasificacion ='k1) Otros Convenios y Subsidios'

	-- select * from @Resultado_1
	   
	   set @var1 = (select top 1 Total_Estimado from @Resultado_1 where Clave =   83100)
       set @var2 = (select top 1 Total_Modificado from @Resultado_1 where Clave = 83100)
       set @var3 = (select top 1 Total_Devengado from @Resultado_1 where Clave =  83100)
       set @var4 = (select top 1 Total_Recaudado from @Resultado_1 where Clave =  83100)
	   set @var5 = (select top 1 AmpliacionesReducciones from @Resultado_1 where Clave =  83100)



	  --UPDATE @Vaciado SET Clasificacion = '   k1) Otros Convenios y Subsidios',Total_Estimado = @var1,Total_Modificado =  @var2 ,Total_Devengado =  @var3 ,Total_Recaudado = @var4 ,AmpliacionesReducciones = @var5 WHERE Clasificacion = '   k1) Otros Convenios y Subsidios'

	   set @var1 = (select top 1 Total_Estimado from @Resultado_1 where Clave =   81102)
       set @var2 = (select top 1 Total_Modificado from @Resultado_1 where Clave = 81102)
       set @var3 = (select top 1 Total_Devengado from @Resultado_1 where Clave =  81102)
       set @var4 = (select top 1 Total_Recaudado from @Resultado_1 where Clave =  81102)
       set @var5 = (select top 1 AmpliacionesReducciones from @Resultado_1 where Clave =  81102)

	   --UPDATE @Vaciado SET Clasificacion ='   l1) Participaciones en Ingresos Locales',Total_Estimado = @var1,Total_Modificado =  @var2 ,Total_Devengado =  @var3 ,Total_Recaudado = @var4 ,AmpliacionesReducciones = @var5 WHERE Clasificacion = '   l1) Participaciones en Ingresos Locales'
	   	

	DELETE FROM @Vaciado Where Clave = '61000'
	DELETE FROM @Vaciado Where Clave = '51000'
	DELETE FROM @Vaciado Where Clave = '62000'
	DELETE FROM @Vaciado Where Clave = '52000'
	DELETE FROM @Vaciado Where Clasificacion = 'Convenios'

	end
ELSE 
If @MostrarVacios!=1
begin

       set @var1 = (select top 1 Total_Estimado from @Resultado_1 where Clave =   83100)
       set @var2 = (select top 1 Total_Modificado from @Resultado_1 where Clave = 83100)
       set @var3 = (select top 1 Total_Devengado from @Resultado_1 where Clave =  83100)
       set @var4 = (select top 1 Total_Recaudado from @Resultado_1 where Clave =  83100)
	   set @var5 = (select top 1 AmpliacionesReducciones from @Resultado_1 where Clave =  83100)

      If  @var1 != 0 OR @var2 !=0 OR @var3 !=0 OR @var4 != 0 OR @var5 != 0
        begin

		UPDATE @Resultado_1 SET Clasificacion ='k1) Otros Convenios y Subsidios' WHERE Clave = 83100
		INSERT INTO @Vaciado (Clasificacion) VALUES('   k1) Otros Convenios y Subsidios')
		UPDATE @Vaciado SET  Clave  = 83100 where  Clasificacion ='k1) Otros Convenios y Subsidios'
		UPDATE @Vaciado SET Clasificacion = '   k1) Otros Convenios y Subsidios',Total_Estimado = @var1,Total_Modificado =  @var2 ,Total_Devengado =  @var3 ,Total_Recaudado = @var4 ,AmpliacionesReducciones = @var5 WHERE Clasificacion = '   k1) Otros Convenios y Subsidios'


		END




	   set @var1 = (select top 1 Total_Estimado from @Resultado_1 where Clave =   81102)
       set @var2 = (select top 1 Total_Modificado from @Resultado_1 where Clave = 81102)
       set @var3 = (select top 1 Total_Devengado from @Resultado_1 where Clave =  81102)
       set @var4 = (select top 1 Total_Recaudado from @Resultado_1 where Clave =  81102)
	   set @var5 = (select top 1 AmpliacionesReducciones from @Resultado_1 where Clave =  81102)

		If  @var1 != 0 OR @var2 !=0 OR @var3 !=0 OR @var4 != 0 OR @var5 != 0
        begin

		INSERT INTO @Vaciado (Clasificacion) VALUES('   l1) Participaciones en Ingresos Locales')
		UPDATE @Resultado_1 SET Clasificacion ='         l1) Participaciones en Ingresos Locales ' where clave = 81102
	    UPDATE @Vaciado SET Clasificacion ='   l1) Participaciones en Ingresos Locales',Total_Estimado = @var1,Total_Modificado =  @var2 ,Total_Devengado =  @var3 ,Total_Recaudado = @var4 ,AmpliacionesReducciones = @var5 WHERE Clasificacion = '   l1) Participaciones en Ingresos Locales'

		end
		


end


INSERT INTO @Vaciado2 (Clave, Clasificacion, Total_Estimado ,Total_Modificado,Total_Devengado,Total_Recaudado,Orden,AmpliacionesReducciones ,Excedentes, Negritas,Tab)	SELECT Clave, Clasificacion, Total_Estimado ,Total_Modificado,Total_Devengado,Total_Recaudado,Orden,AmpliacionesReducciones ,Excedentes, Negritas,Tab  FROM @Vaciado 


If @MostrarVacios=1
begin



--------------------------------------
-- fin parte 6
----------------------------------------
--INSERT INTO @Vaciado2 VALUES (NULL,'          l2) Otros Ingresos de Libre Disposición',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES(NULL,'I. Total de Ingresos de Libre Disposición (I=A+B+C+D+E+F+G+H+I+J+K+L)',NULL,NULL,NULL,NULL,13,NULL,NULL,1,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'Ingresos Excedentes de Ingresos de Libre Disposición',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'A. Aportaciones ( A= a1+a2+a3+a4+a5+a6+a7+a8)',NULL,NULL,NULL,NULL,14,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a1) Fondo de Aportaciones para la Nomina Educativa y Gasto Operativo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a2) Fondo de aportaciones para los Servicios de Salud',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a3) Fondo de Aportaciones para la Infraestructura  Social',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a4) Fondo de Aportaciones para el Fortalecimiento de los Municipios y de las Demarcaciones Territoriales del  Distrito Federal',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a5) Fondo de Aportaciones Multiples',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a6) Fondo de Aportaciones para la Educación Tecnológica y de Adultos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a7) Fondo de Aportaciones para la Seguridad Pública de los Estados y del Distrito Federal',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'          a8) Fondo de Aportaciones para el Fortalecimiento de las Entidades Federativas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'B.Convenios ( B= b1+b2+b3+b4)',NULL,NULL,NULL,NULL,15,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         b1) Convenios de Protección Social en Salud',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         b2) Convenios de Descentralización',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         b3) Convenios de Reasignación',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         b4) Otros Convenios y Subsidios',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'C. Fondo Distintos de Aportaciones (C= c1+c2)',NULL,NULL,NULL,NULL,16,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         c1) Fondo para Entidades Federativas y Municipios Productores de Hidrocarburos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'         c2) Fondo Minero',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'D. Transferencias, Asignaciones, Subsidios y Subvenciones, y Pensiones y Jubilaciones',NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'E. Otras Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,18,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'II.  Total de Transferencias Federales Etiquetadas (II=A+B+C+D+E)',NULL,NULL,NULL,NULL,19,NULL,NULL,1,NULL)

--SELECT * FROM  @Vaciado2

------------------------------------
---fin parte 7
------------------------------------
INSERT INTO @Vaciado2 (Clave ,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones,Orden,Negritas) SELECT top 1 Clave,'III. Ingresos Derivados de Financiamientos ( III = A)',Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones,20,'1' FROM @Resultado_1  where Clave = 0000

--INSERT INTO @Vaciado2 VALUES (NULL,'III. Ingresos Derivados de Financiamientos ( III = A)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL)

UPDATE @Resultado_1 SET Clasificacion ='     A. Ingresos Derivados de Financiamientos' WHERE Clave = 0000
INSERT INTO @Vaciado2 (Clave ,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones) SELECT top 1 Clave,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones FROM @Resultado_1  where Clave = 0000




set @var1 = (select top 1 Total_Estimado from @Vaciado2 where Clave = 0000)
set @var2 = (select top 1 Total_Modificado from @Vaciado2 where Clave = 0000)
set @var3 = (select top 1 Total_Devengado from @Vaciado2 where Clave = 0000)
set @var4 = (select top 1 Total_Recaudado from @Vaciado2 where Clave = 0000)
set @var5 = (select top 1 AmpliacionesReducciones  from @Vaciado2 where Clave = 0000)


If  @var1 = 0 and @var2 =0 and @var3 =0 and @var4 = 0 and @var5 = 0
begin

Update @Vaciado2  set Clave = NULL,Total_Estimado = NULL,Total_Modificado = NULL,Total_Devengado = NULL,Total_Recaudado = NULL,AmpliacionesReducciones = NULL  where Clave = 0000

end


---------------------------------------------
---fin parte 8
--------------------------------------------
INSERT INTO @Vaciado2 VALUES (NULL,'IV. Total de Ingresos ( IV= I+II+III)',NULL,NULL,NULL,NULL,21,NULL,NULL,1,NULL)
--INSERT INTO @Vaciado2 VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'Datos Informativos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL)
--INSERT INTO @Vaciado2 VALUES (NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'   1. Ingresos Derivados de Financiamientos con Fuente de Pago de Ingresos de Libre Disposición',NULL,NULL,NULL,NULL,22,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'   2. Ingresos Derivados de Financiamientos con Fuente de Pago de Transferencias Federales Etiquetadas',NULL,NULL,NULL,NULL,23,NULL,NULL,NULL,NULL)
INSERT INTO @Vaciado2 VALUES (NULL,'   3. Ingresos Derivados de Financiamientos ( 3= 1+ 2)',NULL,NULL,NULL,NULL,24,NULL,NULL,1,NULL)


UPDATE @Vaciado2 set Total_Estimado = (Select SUM(ISNULL(Total_Estimado,0)) from @Vaciado2 Where Orden in (1,2,3,4,5,6,7,8,9,10,11,12)),
			Total_Modificado = (Select SUM(ISNULL(Total_Modificado,0)) from @Vaciado2 Where Orden in (1,2,3,4,5,6,7,8,9,10,11,12)),
			Total_Devengado = (Select SUM(ISNULL(Total_Devengado,0)) from @Vaciado2 Where Orden in (1,2,3,4,5,6,7,8,9,10,11,12)),
			Total_Recaudado = (Select SUM(ISNULL(Total_Recaudado,0)) from @Vaciado2 Where Orden in (1,2,3,4,5,6,7,8,9,10,11,12)),
			AmpliacionesReducciones = (Select SUM(ISNULL(AmpliacionesReducciones,0)) from @Vaciado2 Where Orden in (1,2,3,4,5,6,7,8,9,10,11,12))
			Where Orden = 13


UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0'))
			Where Orden = 20

UPDATE @Vaciado2 set Total_Estimado = (Select SUM(ISNULL(Total_Estimado,0)) from @Vaciado2 Where Orden in (13,19,20)),
			Total_Modificado = (Select SUM(ISNULL(Total_Modificado,0)) from @Vaciado2 Where Orden in (13,19,20)),
			Total_Devengado = (Select SUM(ISNULL(Total_Devengado,0)) from @Vaciado2 Where Orden in (13,19,20)),
			Total_Recaudado = (Select SUM(ISNULL(Total_Recaudado,0)) from @Vaciado2 Where Orden in (13,19,20)),
			AmpliacionesReducciones = (Select SUM(ISNULL(AmpliacionesReducciones,0)) from @Vaciado2 Where Orden in (13,19,20))
			Where Orden = 21



UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('82') and IdClaveFF in ('25','26','27'))
			Where Orden = 14

UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('83') and IdClaveFF in ('25','26','27'))
			Where Orden = 15

UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('85') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('85') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('85') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('85') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('85') and IdClaveFF in ('25','26','27'))
			Where Orden = 16


UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91','93','95') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91','93','95') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91','93','95') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91','93','95') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('91','93','95') and IdClaveFF in ('25','26','27'))
			Where Orden = 17

UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81','84','97','99') and IdClaveFF in ('25','26','27')) + (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81','84','97','99') and IdClaveFF in ('25','26','27')) + (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81','84','97','99') and IdClaveFF in ('25','26','27')) + (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81','84','97','99') and IdClaveFF in ('25','26','27')) + (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,2) in ('81','84','97','99') and IdClaveFF in ('25','26','27')) + (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7') and IdClaveFF in ('25','26','27'))
			Where Orden = 18


UPDATE @Vaciado2 set Total_Estimado = (Select SUM(ISNULL(Total_Estimado,0)) from @Vaciado2 Where Orden in (14,15,16,17,18)),
			Total_Modificado = (Select SUM(ISNULL(Total_Modificado,0)) from @Vaciado2 Where Orden in (14,15,16,17,18)),
			Total_Devengado = (Select SUM(ISNULL(Total_Devengado,0)) from @Vaciado2 Where Orden in (14,15,16,17,18)),
			Total_Recaudado = (Select SUM(ISNULL(Total_Recaudado,0)) from @Vaciado2 Where Orden in (14,15,16,17,18)),
			AmpliacionesReducciones = (Select SUM(ISNULL(AmpliacionesReducciones,0)) from @Vaciado2 Where Orden in (14,15,16,17,18))
			Where Orden = 19

UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF not in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF not in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF not in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF not in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF not in ('25','26','27'))
			Where Orden = 22

UPDATE @Vaciado2 set Total_Estimado = (Select ISNULL(SUM(Estimado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in ('25','26','27')),  
			Total_Modificado = (Select ISNULL(SUM(Modificado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in ('25','26','27')),
			Total_Devengado = (Select ISNULL(SUM(Devengado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in ('25','26','27')),
			Total_Recaudado = (Select ISNULL(SUM(Recaudado),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in ('25','26','27')),
			AmpliacionesReducciones = (Select ISNULL(SUM(AmpliacionesReducciones),0) from @Ingresos Where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in ('25','26','27'))
			Where Orden = 23


UPDATE @Vaciado2 set Total_Estimado = (Select SUM(ISNULL(Total_Estimado,0)) from @Vaciado2 Where Orden in (22,23)),
			Total_Modificado = (Select SUM(ISNULL(Total_Modificado,0)) from @Vaciado2 Where Orden in (22,23)),
			Total_Devengado = (Select SUM(ISNULL(Total_Devengado,0)) from @Vaciado2 Where Orden in (22,23)),
			Total_Recaudado = (Select SUM(ISNULL(Total_Recaudado,0)) from @Vaciado2 Where Orden in (22,23)),
			AmpliacionesReducciones = (Select SUM(ISNULL(AmpliacionesReducciones,0)) from @Vaciado2 Where Orden in (22,23))
			Where Orden = 24

END
ELSE 
If @MostrarVacios!=1
begin

set @var1 = (select top 1 Total_Estimado from @Resultado_1 where Clave = 0000)
set @var2 = (select top 1 Total_Modificado from @Resultado_1 where Clave = 0000)
set @var3 = (select top 1 Total_Devengado from @Resultado_1 where Clave = 0000)
set @var4 = (select top 1 Total_Recaudado from @Resultado_1 where Clave = 0000)
set @var4 = (select top 1 AmpliacionesReducciones  from @Resultado_1 where Clave = 0000)


If  @var1 != 0 or @var2 !=0 or @var3 !=0 or @var4 != 0 or @var5 != 0
begin
 INSERT INTO @Vaciado2 (Clave ,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones,Negritas) SELECT top 1 Clave,'III. Ingresos Derivados de Financiamientos ( III = A)',Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones,'1' FROM @Resultado_1  where Clave = 0000
 UPDATE @Resultado_1 SET Clasificacion ='     A. Ingresos Derivados de Financiamientos' WHERE Clave = 0000
 INSERT INTO @Vaciado2 (Clave ,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones) SELECT top 1 Clave,Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,AmpliacionesReducciones FROM @Resultado_1  where Clave = 0000

END



END


end


DELETE FROM  @Vaciado2  Where  Clasificacion IS NULL


select 
Clave ,
Clasificacion,
Total_Estimado, 
Total_Modificado,
Total_Devengado ,
Total_Recaudado ,
Orden ,
AmpliacionesReducciones, 
 Total_Recaudado- Total_Estimado as Excedentes ,
Negritas,
Tab
from @Vaciado2 



--end


GO

EXEC SP_FirmasReporte 'LDF Estado Analitico Ingresos Detallado'
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnalitico_Ingresos_Detallado_LDF','2.31'
GO