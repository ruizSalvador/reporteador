/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2 1,1,1,2021,"'11'",0,0
CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]
@MesInicio int,
@MesFin int,
@MostrarVacios bit,
@Ejercicio int,
@CadenaFF varchar(max),
--@IdFuenteFinanciamiento int,
@AprAnual as int,
@AmpRedAnual int

AS
BEGIN
CREATE TABLE #PresupuestoFlujo (
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
CREATE TABLE #PresupuestoFlujoAnual (
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
-------------/agregado

Declare @RubroTipo as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
AmpliacionesReducciones decimal(15,2),
IdFuenteFinanciamiento int,
FuenteFinanciamiento varchar(max)
)


--------------agregado
Declare @RubroTipoAnual as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
AmpliacionesReducciones decimal(15,2),
IdFuenteFinanciamiento int,
FuenteFinanciamiento varchar(max)
)
-------------/agregado

Declare @Report as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden float,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
FuenteFinanciamiento varchar(max),
Negritas bit,
Tab int
)

--
--------------agregado
Declare @ReportAnual as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden float,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
FuenteFinanciamiento varchar(max),
Negritas bit,
Tab int
)
-------------/agregado


--------------agregado
Declare @Vaciado as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden float,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
FuenteFinanciamiento varchar(max),
Negritas bit,
Tab int
)
-------------/agregado



INSERT INTO #PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 


--------------agregado
INSERT INTO #PresupuestoFlujoAnual 
SELECT * from T_PresupuestoFlujo
where (mes between 0 and 0 ) and Ejercicio = @Ejercicio
-------------/agregado

--IF @CadenaFF = '' SET @CadenaFF = 'C_FuenteFinanciamiento.CLAVE'

DECLARE @sql nvarchar(max)
SET @sql = 'SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion, ' +
					  'SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, ' +
					  'SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado, ' +
                      'SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, ' + 
                      'SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado, ' +
                      'C_ClasificacionGasto_3.Clave as Clave, ' +
                      'SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(ABS(MovimientosPresupuesto.Reducciones),0)) AS AmpliacionesReducciones, ' +
                      'C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, ' + 
                      'C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento ' +
		            'FROM  #PresupuestoFlujo MovimientosPresupuesto LEFT OUTER JOIN ' +
                      'C_PartidasGastosIngresos ' +
                      'ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI ' + 
                     'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto ' +
                      'ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_1 ' +
                      'ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_2 ' + 
                      'ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_3 ' +
                      'ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI ' +
                      'JOIN ' +
                      'C_FuenteFinanciamiento ' +
                      'ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento ' + 
                      --where C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO =@IdFuenteFinanciamiento 
		            'where C_FuenteFinanciamiento.CLAVE in (' + @CadenaFF + ')' +
					'GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave, C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, ' +
                     ' C_FuenteFinanciamiento.DESCRIPCION ' + 
					'ORDER BY C_ClasificacionGasto_3.Clave '

INSERT INTO @RubroTipo
EXEC (@sql)
--

--------------agregado Anual
DECLARE @sqlanual nvarchar(max)
SET @sqlanual = 'SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion, ' +
					  'SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, ' +
					  'SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado, ' +
                      'SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, ' + 
                      'SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado, ' +
                      'C_ClasificacionGasto_3.Clave as Clave, ' +
                      'SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(ABS(MovimientosPresupuesto.Reducciones),0)) AS AmpliacionesReducciones, ' +
                      'C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, ' + 
                      'C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento ' +
		            'FROM  #PresupuestoFlujoAnual MovimientosPresupuesto LEFT OUTER JOIN ' +
                      'C_PartidasGastosIngresos ' +
                      'ON MovimientosPresupuesto.IdPartida = C_PartidasGastosIngresos.IdPartidaGI ' + 
                     'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto ' +
                      'ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_1 ' +
                      'ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_2 ' + 
                      'ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI ' +
                      'LEFT OUTER JOIN ' +
                      'C_ClasificacionGasto AS C_ClasificacionGasto_3 ' +
                      'ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI ' +
                      'JOIN ' +
                      'C_FuenteFinanciamiento ' +
                      'ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento ' + 
                      --where C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO =@IdFuenteFinanciamiento 
		            'where C_FuenteFinanciamiento.CLAVE in (' + @CadenaFF + ')' +
					'GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave, C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, ' +
                     ' C_FuenteFinanciamiento.DESCRIPCION ' + 
					'ORDER BY C_ClasificacionGasto_3.Clave '

INSERT INTO @RubroTipoAnual
EXEC (@sqlanual)
-------------/agregado




-------------/agregado



--Para Mostrar vacios                              
--
INSERT INTO @RubroTipo (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @RubroTipo)
--

--------------agregado
INSERT INTO @RubroTipoAnual (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @RubroTipoAnual)
-------------/agregado

--INSERT INTO @RubroTipo (Clave, Clasificacion)
--SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
--where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @RubroTipo) 
--and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))
----
--------------agregado
--INSERT INTO @RubroTipoAnual (Clave, Clasificacion)
--SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
--where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @RubroTipoAnual) 
--and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))
---------------/agregado


INSERT INTO @RubroTipo(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'X',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipo Where Clave = '9'+REPLICATE('0',len(clave)-1)

INSERT INTO @RubroTipo(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'Y',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipo Where Clave = '2'+REPLICATE('0',len(clave)-1)

INSERT INTO @RubroTipo(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'Z',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipo Where Clave = '5'+REPLICATE('0',len(clave)-1)
-- BR


--------------agregado
INSERT INTO @RubroTipoAnual(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'X',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipoAnual Where Clave = '9'+REPLICATE('0',len(clave)-1)

INSERT INTO @RubroTipoAnual(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'Y',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipoAnual Where Clave = '2'+REPLICATE('0',len(clave)-1)

INSERT INTO @RubroTipoAnual(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
--Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
Select  Clasificacion,0,0,0,0,'Z',0,IdFuenteFinanciamiento,FuenteFinanciamiento -- BR
from @RubroTipoAnual Where Clave = '5'+REPLICATE('0',len(clave)-1)
-------------/agregado

If @MostrarVacios=1
begin
	INSERT @Report 
	SELECT distinct
	Clave,
	Clasificacion,
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0) ))as Excedentes,
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipo
	group by Clave, Clasificacion, FuenteFinanciamiento
	--Order by Orden,clave
	UNION
	SELECT distinct
	'00100',
	'Total',
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	3 as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
	'',
	1 as negritas,
	0 as tab
	from @RubroTipo
	Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
	Order by Orden,clave
end 
else begin
	INSERT @Report 
	SELECT distinct
	Clave,
	Clasificacion,
	isnull(Total_Estimado,0) as Total_Estimado,
	isnull(Total_Modificado,0) as Total_Modificado,
	isnull(Total_Devengado,0) as Total_Devengado,
	isnull(Total_Recaudado,0) as Total_Recaudado,
	(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
	isnull(AmpliacionesReducciones,0) as AmpliacionesReducciones,
	isnull(Total_Recaudado,0)-isnull(Total_Estimado,0)as Excedentes,
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipo
	where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
	UNION
	SELECT distinct
	'00100',
	'Total',
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	3 as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
	'',
	1 as negritas,
	0 as tab
	from @RubroTipo
	Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
	Order by Orden,Clave
	end



--------------agregado

If @MostrarVacios=1
begin
	INSERT @ReportAnual 
	SELECT distinct
	Clave,
	Clasificacion,
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))) as Excedentes,
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipoAnual
	group by Clave, Clasificacion, FuenteFinanciamiento
	--Order by Orden,clave
	UNION
	SELECT distinct
	'00100',
	'Total',
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	3 as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0))) as Excedentes,
	'',
	1 as negritas,
	0 as tab
	from @RubroTipoAnual
	Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
	--group by Clave, Clasificacion, FuenteFinanciamiento
	Order by Orden,clave
	
end 
else begin
	INSERT @ReportAnual 
	SELECT distinct
	Clave,
	Clasificacion,
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM(isnull(Total_Recaudado,0)-isnull(Total_Estimado,0))as Excedentes,
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipoAnual
	where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
	group by Clave, Clasificacion, FuenteFinanciamiento
	UNION
	SELECT distinct
	'00100',
	'Total',
	SUM(isnull(Total_Estimado,0)) as Total_Estimado,
	SUM(isnull(Total_Modificado,0)) as Total_Modificado,
	SUM(isnull(Total_Devengado,0)) as Total_Devengado,
	SUM(isnull(Total_Recaudado,0)) as Total_Recaudado,
	3 as Orden,
	SUM(isnull(AmpliacionesReducciones,0)) as AmpliacionesReducciones,
	SUM((isnull(Total_Recaudado,0))-(isnull(Total_Estimado,0)))as Excedentes,
	'',
	1 as negritas,
	0 as tab
	from @RubroTipoAnual
	Where Clave not in('51'+replicate('0',len(Clave)-2),'52'+replicate('0',len(Clave)-2),'61'+replicate('0',len(Clave)-2),'62'+replicate('0',len(Clave)-2))
	Order by Orden,Clave
	end


-------------/agregado
	INSERT @Report values('','Ingresos del Poder Ejecutivo Federal o Estatal y de los Municipios',null,null,null,null,1,null,null,null,1,0)
	update @Report Set Orden=2 where Clave='1'+replicate('0',LEN(clave)-1)
	--update @Report Set Orden=2.5, Clave = '20000' where Clave='Y'
	update @Report Set Orden=3 where Clave='3'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=4 where Clave='4'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=5 where Clave='5'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=6 where Clave='51'+replicate('0',LEN(clave)-2)
	update @Report Set Orden=7 where Clave='52'+replicate('0',LEN(clave)-2)
	update @Report Set Orden=8 where Clave='6'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=9 where Clave='61'+replicate('0',LEN(clave)-2)
	update @Report Set Orden=10 where Clave='62'+replicate('0',LEN(clave)-2)
	update @Report Set Orden=11 where Clave='8'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=12 where Clave='9'+replicate('0',LEN(clave)-1)
	INSERT @Report values('','Ingresos de los Entes Públicos de los Poderes Legislativo y Judicial, de los Órganos Autónomos y del Sector Paraestatal o Paramunicipal, así como de las Empresas Productivas del Estado',null,null,null,null,13,null,null,null,1,0)
	update @Report Set Orden=14 where Clave='2'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=2.5, Clave = '20000' where Clave='Y'
	update @Report Set Orden=14.5, Clave = '50000' where Clave='Z'
	update @Report Set Orden=15 where Clave='7'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=16, Clave = '90000' where Clave='X'   -----------  BR


	INSERT @Report values('','Ingresos Derivados de Financiamientos',null,null,null,null,17,null,null,null,1,0)
	update @Report Set Orden=18 where Clave='0'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=19 where Clasificacion='Total'
	
	update @Report set Clasificacion='     '+Clasificacion  where tab=1

	-- Delete from @Report where Orden = 16
	--------------agregado
	INSERT @ReportAnual values('','Ingresos del Poder Ejecutivo Federal o Estatal y de los Municipios',null,null,null,null,1,null,null,null,1,0)
	update @ReportAnual Set Orden=2 where Clave='1'+replicate('0',LEN(clave)-1)
	--update @ReportAnual Set Orden=2.5, Clave = '20000' where Clave='Y'
	update @ReportAnual Set Orden=3 where Clave='3'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=4 where Clave='4'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=5 where Clave='5'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=6 where Clave='51'+replicate('0',LEN(clave)-2)
	update @ReportAnual Set Orden=7 where Clave='52'+replicate('0',LEN(clave)-2)
	update @ReportAnual Set Orden=8 where Clave='6'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=9 where Clave='61'+replicate('0',LEN(clave)-2)
	update @ReportAnual Set Orden=10 where Clave='62'+replicate('0',LEN(clave)-2)
	update @ReportAnual Set Orden=11 where Clave='8'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=12 where Clave='9'+replicate('0',LEN(clave)-1)
	INSERT @ReportAnual values('','Ingresos de los Entes Públicos de los Poderes Legislativo y Judicial, de los Órganos Autónomos y del Sector Paraestatal o Paramunicipal, así como de las Empresas Productivas del Estado',null,null,null,null,13,null,null,null,1,0)
	update @ReportAnual Set Orden=14 where Clave='2'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=2.5, Clave = '20000' where Clave='Y'
	update @ReportAnual Set Orden=14.5, Clave = '50000' where Clave='Z'   -----------  BR
	update @ReportAnual Set Orden=15 where Clave='7'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=16, Clave = '90000' where Clave='X'   -----------  BR
	INSERT @ReportAnual values('','Ingresos Derivados de Financiamientos',null,null,null,null,17,null,null,null,1,0)
	update @ReportAnual Set Orden=18 where Clave='0'+replicate('0',LEN(clave)-1)
	update @ReportAnual Set Orden=19 where Clasificacion='Total'
	
	update @ReportAnual set Clasificacion='     '+Clasificacion  where tab=1

	--Delete from @ReportAnual where Orden = 16
  
 If @AprAnual = 1
	 BEGIN
		 INSERT INTO @Vaciado
		 SELECT distinct  B.Clave, B.Clasificacion,ISNULL( B.Total_Estimado, 0) as Total_Estimado,ISNULL( B.Total_Estimado, 0) + ISNULL(A.AmpliacionesReducciones,0)  AS Total_Modificado/*A.Total_Modificado */,ISNULL(A.Total_Devengado,0) as Total_Devengado, ISNULL(A.Total_Recaudado,0) as Total_Recaudado,
		 B.Orden,
		 CASE @AmpRedAnual
		WHEN 1 THEN isnull(B.AmpliacionesReducciones,0)
		ELSE isnull(A.AmpliacionesReducciones,0) 
		END as AmpliacionesReducciones,
		 --ISNULL(A.AmpliacionesReducciones,0) ,
		 A.Excedentes,A.FuenteFinanciamiento,B.Negritas,A.Tab  
		 FROM @ReportAnual B LEFT JOIN @Report A On A.Clave = B.Clave and A.FuenteFinanciamiento = B.FuenteFinanciamiento 
	  --Select * from @Vaciado order by orden
	 END
 Else
	 BEGIN
		 INSERT INTO @Vaciado
		 SELECT distinct  B.Clave, B.Clasificacion,ISNULL( A.Total_Estimado, 0) as Total_Estimado,ISNULL( A.Total_Estimado, 0) + ISNULL(A.AmpliacionesReducciones,0)  AS Total_Modificado/*A.Total_Modificado */,ISNULL(A.Total_Devengado,0) as Total_Devengado, ISNULL(A.Total_Recaudado,0) as  Total_Recaudado,
		 B.Orden,
		 CASE @AmpRedAnual
		WHEN 1 THEN isnull(B.AmpliacionesReducciones,0)
		ELSE isnull(A.AmpliacionesReducciones,0) 
		END as AmpliacionesReducciones,
		 --ISNULL(A.AmpliacionesReducciones,0) ,
		 A.Excedentes,A.FuenteFinanciamiento,B.Negritas,B.Tab  
		 FROM @ReportAnual B LEFT JOIN @Report A On A.Clave = B.Clave and A.FuenteFinanciamiento = B.FuenteFinanciamiento 
	 END


 Update @Vaciado set 
 Total_Estimado = Null, 
 Total_Modificado = Null,
 Total_Devengado = Null,
 Total_Recaudado = Null,
 AmpliacionesReducciones = Null,
 Excedentes = Null
 where Clasificacion in ('Ingresos del Poder Ejecutivo Federal o Estatal y de los Municipios','Ingresos de los Entes Públicos de los Poderes Legislativo y Judicial, de los Órganos Autónomos y del Sector Paraestatal o Paramunicipal, así como de las Empresas Productivas del Estado','Ingresos Derivados de Financiamientos')

 --Delete from @Vaciado where Orden = 16

 select 
Clave ,
Clasificacion ,
SUM(Total_Estimado) as Total_Estimado ,
SUM(Total_Modificado) as Total_Modificado,
SUM(Total_Devengado) as Total_Devengado ,
SUM(Total_Recaudado) as Total_Recaudado,
Orden,
SUM(AmpliacionesReducciones) as AmpliacionesReducciones,
SUM((Total_Recaudado)-(Total_Estimado)) as Excedentes,
--FuenteFinanciamiento varchar(max),
Negritas,
Tab 
	from @Vaciado 
	group by Clave, Clasificacion, Orden, Negritas, Tab
	order by orden 
		
DROP TABLE #PresupuestoFlujo
DROP TABLE #PresupuestoFlujoAnual

END 
GO
EXEC SP_FirmasReporte 'Estado Analitico De Ingresos por fuente de financiamiento'
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2','2.30.1'
GO