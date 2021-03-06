/****** Object:  StoredProcedure [dbo].[SP_RPT_DifusionLeydeIngresos]    Script Date: 03/26/2013 16:39:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_DifusionLeydeIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_DifusionLeydeIngresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_DifusionLeydeIngresos]    Script Date: 03/26/2013 16:39:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_DifusionLeydeIngresos]
@Ejercicio as int,
@MostrarVacios as bit

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
Grupo1 varchar(7)
--Grupo2 varchar(7),
--Grupo3 varchar(7)
)


Insert Into @Tmp_MovimientosPresupuesto (Id, Estimado, Ampliaciones, Reducciones )
SELECT IdPartidaGIDestino as Id, [A] as [Estimado], [M] AS [Ampliaciones], [R] as [Reducciones]
From (
	Select  Sum(Importe) as Tot_Importe, TipoMovimiento, IdPartidaGIDestino
	From T_MovimientosPresupuesto 
	Where IdPartidaGIDestino > 0 And Ejercidio =  @Ejercicio 
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
	 Periodo = @Ejercicio  And IdPartidaGI > 0 
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
--RUBRO
SELECT     C_ClasificacionGasto_3.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_3.Clave as Clave,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1
                     -- SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      --SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto LEFT OUTER JOIN
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
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave 
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1
                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      --SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3
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



--
UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
--UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
--UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
--

--TIPO
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1
--SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
--Rubro
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
--UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
--UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
--UPDATE @Resultado set Grupo2= ''0'' +SUBSTRING(clave,1,1) where LEN(clave)=4
--UPDATE @Resultado set Grupo3= ''0'' +SUBSTRING(clave,1,2) where LEN(clave)=4
--
Delete from @Resultado where Clave not like '___00' and LEN(Clave)=5
Delete from @Resultado where Clave not like '___0' and LEN(Clave)=4


If @MostrarVacios=1
begin
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Monto,
--isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like ''_0''),0) as SumaEstimado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when len(Clave)=3  then 2 end)as Orden,
--(case  when len(clave)= 4 then 10 when substring(clave,1,1)=''0'' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1
--Grupo2,
--Grupo3 
from @Resultado where clave in(10000,20000,30000,40000,50000,60000,70000,80000,90000,0000)
Order by Orden
end 
else
SELECT 
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Monto,
--isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like ''_0''),0) as SumaEstimado,

(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
Grupo1
--Grupo2,
--Grupo3
from @Resultado
where Total_Estimado<>0 
Order by Clave
END 


GO


EXEC SP_FirmasReporte 'Difusión a la Ciudadanía de la Ley de Ingresos'
GO

UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1206)
GO
