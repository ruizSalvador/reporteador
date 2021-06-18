/****** Object:  StoredProcedure [dbo].[SP_ControlPresupuestalIngreso]    Script Date: 12/28/2012 10:41:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ControlPresupuestalIngreso]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_ControlPresupuestalIngreso]
GO
/****** Object:  StoredProcedure [dbo].[SP_ControlPresupuestalIngreso]    Script Date: 12/28/2012 10:41:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_ControlPresupuestalIngreso 7,2016
CREATE PROCEDURE [dbo].[SP_ControlPresupuestalIngreso] 

--@MesInicio as int,
--@MostrarVacios as bit,
@MesFin as int,
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
EstimadoAnual decimal (15,2),
EstimadoMes decimal (15,2),
RecaudadoMes decimal (15,2),
RecaudadoAcumulado decimal (15,2),
Clave varchar(7),
IdClasificacionGI smallint,
IdClasificacionGIPadre smallint,
Grupo1 varchar(7),
Grupo2 varchar(7),
PorRecaudarAcumulado decimal(15,2),
Excedentes decimal (15,2)
)
--
Declare @Rubro as TABLE(
Clave varchar(7),
Clasificacion varchar(255),	
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
--PorRecaudar decimal (15,2),
--PorcModificado decimal (15,2),
--PorcDevengado decimal (15,2),
--PorcRecaudado decimal (15,2),
--ResModificado decimal (15,2),
--ResDevengado decimal (15,2),
--ResRecaudado decimal (15,2),
Orden tinyint,
AmpliacionesReducciones decimal (15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)
--
INSERT INTO @PresupuestoFlujo 
SELECT * from T_PresupuestoFlujo
--where (mes between 1 and @MesFin ) and Ejercicio = @Ejercicio 
where (mes between 1 and @MesFin ) and Ejercicio = @Ejercicio 

--
Insert into @Rubro
Exec SP_EstadoEjercicioIngresos_Rubro 1,@MesFin,0,@Ejercicio,0
--Exec SP_EstadoEjercicioIngresos_Rubro 1,12,0,2014
--
INSERT INTO @Resultado 
--Consulta para obtener el Presupuesto Estimado Anual
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  isnull(SUM(MovimientosPresupuesto.Estimado),0) AS EstimadoAnual, 
					  0 AS EstimadoMes,
                      0 AS RecaudadoMes, 
                      0 AS RecaudadoAcumulado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2 ,
                      0 AS PorRecaudarAcumulado,
                      0 as Excedentes
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
                  WHere   MovimientosPresupuesto.Mes = 0
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
ORDER BY C_ClasificacionGasto_2.Clave

INSERT INTO @Resultado 
--Consulta para obtener el Presupuesto Estimado Mensual y el Recaudado Mensual
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  0 AS EstimadoAnual, 
					  isnull(SUM(MovimientosPresupuesto.Estimado),0) AS EstimadoMes,
                      isnull(SUM(MovimientosPresupuesto.Recaudado),0) AS RecaudadoMes, 
                      0 AS RecaudadoAcumulado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2 ,
                      0 AS PorRecaudarAcumulado,
                      0 as Excedentes
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
                  WHere   MovimientosPresupuesto.Mes = @MesFin
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
ORDER BY C_ClasificacionGasto_2.Clave

INSERT INTO @Resultado 
--Consulta para obtener el Presupuesto Recaudado Acumulado
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  0 AS EstimadoAnual, 
					  0 AS EstimadoMes,
                      0 AS RecaudadoMes, 
                      isnull(SUM(MovimientosPresupuesto.Recaudado),0) AS RecaudadoAcumulado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2 ,
                      0 AS PorRecaudarAcumulado,
                      0 as Excedentes
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
                  WHere   MovimientosPresupuesto.Mes BETWEEN  1 AND @MesFin AND Ejercicio=@Ejercicio
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
ORDER BY C_ClasificacionGasto_2.Clave
--
INSERT INTO @Resultado (Clave,
Clasificacion,
EstimadoAnual,
EstimadoMes,
RecaudadoMes,
RecaudadoAcumulado,
PorRecaudarAcumulado,
Excedentes)
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

select Clasificacion, isnull(sum(EstimadoAnual),0) as EstimadoAnual, isnull(sum(EstimadoMes),0) as EstimadoMes, isnull(sum(RecaudadoMes),0) as RecaudadoMes, isnull(sum(RecaudadoAcumulado),0) as RecaudadoAcumulado,
Clave, IdClasificacionGI, IdClasificacionGIPadre, Grupo1, Grupo2, isnull((SUM(EstimadoAnual)-SUM(RecaudadoAcumulado)),0) as PorRecaudarAcumulado,
--isnull((Select Sum(EstimadoAnual)from @Resultado),0) as SumaEstimadoAnual,
--isnull((Select Sum(EstimadoMes)from @Resultado),0) as SumaEstimadoMes,
--isnull((Select Sum(RecaudadoMes)from @Resultado),0) as SumaRecaudadoMes,
--isnull((Select Sum(RecaudadoAcumulado)from @Resultado),0) as SumaRecaudadoAcumulado,
--isnull(SUM(PorRecaudarAcumulado),0) as SumaPorRecaudarAcumulado,
(case  when substring(clave,1,1)= '0' then 2  when substring(clave,1,1) <> '0' then 1 end)as Orden
 from @Resultado
 group by Clasificacion, Clave, IdClasificacionGI, IdClasificacionGIPadre, Grupo1, Grupo2
order by Clave, Orden
END
GO

EXEC SP_FirmasReporte 'Control Presupuestal Ingreso'
GO
Exec SP_CFG_LogScripts 'SP_ControlPresupuestalIngreso'
GO
--exec SP_ControlPresupuestalIngreso 12,2014