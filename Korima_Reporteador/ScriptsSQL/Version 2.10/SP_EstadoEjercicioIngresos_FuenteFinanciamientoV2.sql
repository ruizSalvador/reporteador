/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]
GO
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2]
@MesInicio int,
@MesFin int,
@MostrarVacios bit,
@Ejercicio int,
@IdFuenteFinanciamiento int

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

Declare @Report as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden Int,
AmpliacionesReducciones decimal(15,2),
Excedentes decimal(15,2),
FuenteFinanciamiento varchar(max),
Negritas bit,
Tab int
)

--

INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
where (mes between @MesInicio and @MesFin ) and Ejercicio = @Ejercicio 


INSERT INTO @RubroTipo
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(ABS(MovimientosPresupuesto.Reducciones),0)) AS AmpliacionesReducciones,
                      C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, 
                      C_FuenteFinanciamiento.DESCRIPCION as FuenteFinanciamiento 
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
                      JOIN
                      C_FuenteFinanciamiento 
                      ON C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento 
                      where C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO =@IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave, C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, 
                      C_FuenteFinanciamiento.DESCRIPCION  
ORDER BY C_ClasificacionGasto_3.Clave
--
--TIPO
INSERT INTO @RubroTipo
SELECT     '   '+C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(MovimientosPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(MovimientosPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUM (isnull(MovimientosPresupuesto.Ampliaciones,0) )- SUM (isnull(MovimientosPresupuesto.Reducciones,0)) AS AmpliacionesReducciones,
                      C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, 
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
                      Where substring(C_ClasificacionGasto_2.Clave,1,2) in ('51','52','61','62')
                      AND C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO = @IdFuenteFinanciamiento 
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,C_FuenteFinanciamiento.IDFUENTEFINANCIAMIENTO, 
                      C_FuenteFinanciamiento.DESCRIPCION 
  
--Para Mostrar vacios                              
--
INSERT INTO @RubroTipo (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @RubroTipo)
--
INSERT INTO @RubroTipo (Clave, Clasificacion)
SELECT distinct gast.Clave,'   '+gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Clave NOT IN( select Clave from @RubroTipo) 
and gast.Clave in ('51'+replicate('0',len(gast.Clave)-2),'52'+replicate('0',len(gast.Clave)-2),'61'+replicate('0',len(gast.Clave)-2),'62'+replicate('0',len(gast.Clave)-2))
--
INSERT INTO @RubroTipo(Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,Clave,AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento) 
Select  Clasificacion,Total_Estimado,Total_Modificado,Total_Devengado,Total_Recaudado,'X',AmpliacionesReducciones,IdFuenteFinanciamiento,FuenteFinanciamiento
from @RubroTipo Where Clave = '9'+REPLICATE('0',len(clave)-1)
--

If @MostrarVacios=1
begin
	INSERT @Report 
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
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipo
	--Order by Orden,clave
	UNION
	SELECT 
	'',
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
	FuenteFinanciamiento,
	0 as negritas,
	1 as tab
	from @RubroTipo
	where Total_Estimado<>0 OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
	UNION
	SELECT 
	'',
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
	
	INSERT @Report values('','Ingresos del Gobierno',null,null,null,null,1,null,null,null,1,0)
	update @Report Set Orden=2 where Clave='1'+replicate('0',LEN(clave)-1)
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
	INSERT @Report values('','Ingresos de Organismos y Empresa',null,null,null,null,13,null,null,null,1,0)
	update @Report Set Orden=14 where Clave='2'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=15 where Clave='7'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=16, Clave = '90000' where Clave='X'
	INSERT @Report values('','Ingresos Derivados de Financiamientos',null,null,null,null,17,null,null,null,1,0)
	update @Report Set Orden=18 where Clave='0'+replicate('0',LEN(clave)-1)
	update @Report Set Orden=19 where Clasificacion='Total'
	
	update @Report set Clasificacion='     '+Clasificacion  where tab=1
	select * from @Report order by orden
		
END 



GO
