/****** Object:  StoredProcedure [dbo].[SP_CalendarioMensualIngresos]    Script Date: 03/21/2013 13:01:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CalendarioMensualIngresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_CalendarioMensualIngresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_CalendarioMensualIngresos]    Script Date: 03/21/2013 13:01:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CalendarioMensualIngresos]
@Fecha as datetime,
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
Trasferencias decimal(15,2),
Ejercidio integer,
MedDestino integer
)
DECLARE @Tmp_AfectacionPresupuesto AS TABLE(
Id int,
Comprometido decimal(15,2),
Devengado decimal(15,2),
Recaudado decimal(15,2),
Ejercido decimal (15,2),
Pagado decimal(15,2),
Periodo smallint,
Mes smallint
)
Declare @Resultado as TABLE(

Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Periodo smallint,
Mes smallint
)
--

Insert Into @Tmp_MovimientosPresupuesto (Id, Estimado, Ampliaciones, Reducciones,Ejercidio,MedDestino )
SELECT IdPartidaGIDestino as Id, [A] as [Estimado], [M] AS [Ampliaciones], [R] as [Reducciones],Ejercidio,MedDestino
From (
	Select  Sum(Importe) as Tot_Importe, TipoMovimiento, IdPartidaGIDestino,ejercidio as Ejercidio, 
	case medDestino when 0 then 0 else  meddestino end as MedDestino 
	From T_MovimientosPresupuesto 
	Where IdPartidaGIDestino > 0 
	And year(Fecha)=year(@fecha)
	Group By TipoMovimiento, IdPartidaGIDestino,fecha,MedDestino,ejercidio) p
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
Insert Into @Tmp_AfectacionPresupuesto (Id, Devengado, Recaudado,Periodo,Mes)
SELECT  IdPartidaGI, [D] as [Devengado], [K] AS [Recaudado],Periodo,Mes
From (
	Select Sum(Importe) as Tot_Importe, TipoAfectacion, IdPartidaGI,Periodo as Periodo,
	case Mes when 0 then 0 else mes end as Mes
	From T_AfectacionPresupuesto 
Where Importe <> 0 And 
	year(Fecha) =year(@Fecha) AND
	IdPartidaGI > 0 
	Group By 
	IdPartidaGI, 
	TipoAfectacion,fecha,Mes,periodo ) p
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
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_3.Clave,1,3) as Grupo3,
                      MovimientosPresupuesto.Ejercidio as Periodo,
                      MovimientosPresupuesto.MedDestino as Mes
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
                      left JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto 
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
GROUP BY C_ClasificacionGasto_3.Descripcion, C_ClasificacionGasto_3.Clave,AfectacionPresupuesto.Periodo,AfectacionPresupuesto.Mes,
MovimientosPresupuesto.Ejercidio, MovimientosPresupuesto.MedDestino
UNION

--TIPO
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,3) as Grupo3,
                      MovimientosPresupuesto.Ejercidio as periodo,
                      MovimientosPresupuesto.MedDestino as Mes
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
                     left JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto  
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,AfectacionPresupuesto.Periodo,AfectacionPresupuesto.Mes,
                      MovimientosPresupuesto.Ejercidio, MovimientosPresupuesto.MedDestino
UNION
--CLASE                      
SELECT      C_ClasificacionGasto_1.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_1.Clave,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,2) as Grupo2, 
                      SUBSTRING(C_ClasificacionGasto_1.Clave,1,3) as Grupo3,
                      MovimientosPresupuesto.Ejercidio as periodo,
                      MovimientosPresupuesto.MedDestino as mes
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto RIGHT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.Id = C_PartidasGastosIngresos.IdPartidaGI 
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
                      left JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
GROUP BY C_ClasificacionGasto_1.Descripcion, C_ClasificacionGasto_1.Clave,AfectacionPresupuesto.Periodo,AfectacionPresupuesto.Mes,
MovimientosPresupuesto.Ejercidio, MovimientosPresupuesto.MedDestino

--
UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
--
--Clase
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2,Grupo3)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2, SUBSTRING(gast.Clave,1,3) as Grupo3  
From C_ClasificacionGasto as gast
where gast.Nivel=4 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

--TIPO
INSERT INTO @Resultado (Clave, Clasificacion,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2 
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado)
--
--Rubro
INSERT INTO @Resultado (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado)

UPDATE @Resultado set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado set Grupo3= SUBSTRING(Clave,1,3)
UPDATE @Resultado set Grupo1= '0' where LEN(Clave)=4 or SUBSTRING(clave,1,1)='0'
UPDATE @Resultado set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
UPDATE @Resultado set Grupo3= '0' +SUBSTRING(clave,1,2) where LEN(clave)=4
--
Delete from @Resultado where Clave not like '___00' and LEN(Clave)=5
Delete from @Resultado where Clave not like '___0' and LEN(Clave)=4

DECLARE @Tabla as table(
Clave varchar (7),
Clasificacion varchar(255),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Orden varchar(7),
[0] decimal (15,2),
[1] decimal (15,2),
[2] decimal (15,2),
[3] decimal (15,2),
[4] decimal (15,2),
[5] decimal (15,2),
[6] decimal (15,2),
[7] decimal (15,2),
[8] decimal (15,2),
[9] decimal (15,2),
[10] decimal (15,2),
[11] decimal (15,2),
[12] decimal (15,2)

)

DECLARE @Tabla2 as table(
Clave varchar (7),
Clasificacion varchar(255),
Grupo1 varchar(7),
Grupo2 varchar(7),
Grupo3 varchar(7),
Orden varchar(7),
[0] decimal (15,2),
[1] decimal (15,2),
[2] decimal (15,2),
[3] decimal (15,2),
[4] decimal (15,2),
[5] decimal (15,2),
[6] decimal (15,2),
[7] decimal (15,2),
[8] decimal (15,2),
[9] decimal (15,2),
[10] decimal (15,2),
[11] decimal (15,2),
[12] decimal (15,2)

)

If @MostrarVacios=1
begin
INSERT INTO @Tabla 
Select Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Orden,
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (	
SELECT DISTINCT
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
--isnull(Total_Modificado,0) as Total_Modificado,
--isnull(Total_Devengado,0) as Total_Devengado,
--isnull(Total_Recaudado,0) as Total_Recaudado,
--isnull(Total_Modificado-Total_Recaudado ,0)as PorRecaudar,
--isnull((Total_Modificado/nullif(Total_Estimado,0)),0) as PorcModificado,
--isnull((Total_Devengado/nullif(Total_Estimado,0)),0)as PorcDevengado,
--isnull((Total_Recaudado/nullif(Total_Estimado,0)),0)as PorcRecaudado,
--isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
--isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
--isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
--isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
--isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0) as ResRecaudado,
(case  when len(clave)= 4 then 10 when substring(clave,1,1)='0' then 10 when len(clave)=5 then Grupo1  end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Periodo,
Mes
from @Resultado
Where year(@Fecha)= Periodo or Periodo is null
--Order by Orden,Grupo3
) as p
	PIVOT 
	( 
		sum(Total_Estimado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable
end 
else
INSERT INTO @Tabla 
Select Clave, Clasificacion,Grupo1,Grupo2,Grupo3,Orden,
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (	
SELECT DISTINCT
Clave,
Clasificacion,
isnull(Total_Estimado,0) as Total_Estimado,
--isnull(Total_Modificado,0) as Total_Modificado,
--isnull(Total_Devengado,0) as Total_Devengado,
--isnull(Total_Recaudado,0) as Total_Recaudado,
--isnull(Total_Modificado-Total_Recaudado ,0)as PorRecaudar,
--isnull((Total_Modificado/nullif(Total_Estimado,0)),0)as PorcModificado,
--isnull((Total_Devengado/nullif(Total_Estimado,0)),0) as PorcDevengado,
--isnull((Total_Recaudado/nullif(Total_Estimado,0)),0) as PorcRecaudado,
--isnull((Select Sum(Total_Modificado)- Sum(Total_Recaudado) from @Resultado where Grupo2 like '_0'),0) as SumaPorRecaudar,
--isnull((Select Sum(Total_Estimado)from @Resultado where Grupo2 like '_0'),0) as SumaEstimado,
--isnull((Select Sum(Total_Modificado)from @Resultado where Grupo2 like '_0'),0) as SumaModificado,
--isnull((Select Sum(Total_Devengado)from @Resultado where Grupo2 like '_0'),0) as SumaDevengado,
--isnull((Select Sum(Total_Recaudado)from @Resultado where Grupo2 like '_0'),0) as SumaRecaudado,
isnull((Select SUM(Total_Modificado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResModificado,
isnull((Select SUM(Total_Devengado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0'),0) as ResDevengado,
isnull((Select SUM(Total_Recaudado)/nullif(SUM(Total_Estimado),0) from @Resultado where Grupo2 like '_0' ),0)as ResRecaudado,
(case  when len(clave)= 4 then 10  when len(clave)=5 then Grupo1 when substring(clave,1,1)='0' then 10 end)as Orden,
Grupo1,
Grupo2,
Grupo3,
Periodo,
Mes
from @Resultado
where Total_Estimado<>0 and (year(@Fecha)= Periodo or Periodo is null) --OR Total_Modificado <> 0 OR Total_Devengado <>0 OR Total_Recaudado <>0
--Order by Clave,Grupo3
) as p
	PIVOT 
	( 
		sum(Total_Estimado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable
 
 Update @Tabla set Orden='99' where Orden='10'
 
 insert into @Tabla2 
 Select distinct Clave,Clasificacion,Grupo1,Grupo2,Grupo3,Orden,
 isnull(Sum ([0]),0)as [0],
 isnull(Sum ([1]),0)as [1],
 isnull(Sum ([2]),0)as [2],
 isnull(Sum ([3]),0)as [3],
 isnull(Sum ([4]),0)as [4],
 isnull(Sum ([5]),0)as [5],
 isnull(Sum ([6]),0)as [6],
 isnull(Sum ([7]),0)as [7],
 isnull(Sum ([8]),0)as [8],
 isnull(Sum ([9]),0)as [9],
 isnull(Sum ([10]),0)as [10],
 isnull(Sum ([11]),0)as [11],
 isnull(Sum ([12]),0)as [12]
 from @Tabla group by Clave,Clasificacion,Grupo1,Grupo2,Grupo3,Orden  order by orden   

update @Tabla2 set [0]= [0]+[1]+[2]+[3]+[4]+[5]+[6]+[7]+[8]+[9]+[10]+[11]+[12]

select * from @Tabla2 
END 
GO

EXEC SP_FirmasReporte 'Calendario de Ingresos Base Mensual'
GO

