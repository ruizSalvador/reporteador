/****** Object:  StoredProcedure [dbo].[SP_RPT_Ing_Egr]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Ing_Egr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Ing_Egr]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_RPT_Ing_Egr]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 -- Exec SP_RPT_Ing_Egr 2021,3
CREATE PROCEDURE [dbo].[SP_RPT_Ing_Egr]	

@Ejercicio int,
@Periodo int

AS
BEGIN


declare @Egresos as table(CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4), Modificado decimal(18,4))
------------------------------------------------------------------------------------
Insert into @Egresos
Select FF.Clave as Clave, FF.DESCRIPCION as Descripcion,

sum(isnull(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO 

where  (Mes BETWEEN  1 AND @Periodo) AND LYear=@Ejercicio AND Year=@Ejercicio 
--AND CR.CLAVE = CASE WHEN @Clave = '' THEN CR.CLAVE else @Clave end
group by FF.Clave, FF.DESCRIPCION
Order By FF.Clave




Declare @Egresos2 as TABLE(
Tipo varchar(10),
Clave varchar(200),
Descripcion varchar (255),

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

INSERT INTO @Egresos2 
Select 'EGR', Clave, Descripcion As Descripcion,
 ISNULL([0],0) ,ISNULL([1],0), ISNULL([2],0), ISNULL([3],0),ISNULL([4],0),ISNULL([5],0),ISNULL([6],0),ISNULL([7],0),ISNULL([8],0),ISNULL([9],0),ISNULL([10],0),ISNULL([11],0),ISNULL([12],0)
From (
		Select FF.CLAVE , FF.DESCRIPCION ,  T_PresupuestoNW.Mes, (isnull(T_PresupuestoNW.Ejercido,0) + isnull(T_PresupuestoNW.Pagado,0)) As Devengado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = T_SellosPresupuestales.IDFUENTEFINANCIAMIENTO 

		where T_PresupuestoNW.year = @Ejercicio AND LYear=@Ejercicio 
		AND (Mes BETWEEN  1 AND @Periodo)
		
	 ) as p
	PIVOT 
	( 
		sum(Devengado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by Clave

--Select * from @Egresos
--Select * from @Egresos2

--------------------------------------------------------------
declare @Ingresos as table(CLAVE varchar(100), DESCRIPCION varchar(max),
Autorizado decimal(18,4), Modificado decimal(18,2))

Insert into @Ingresos
Select FF.CLAVE , FF.DESCRIPCION , 
SUM(isnull(T_PresupuestoFlujo.Estimado,0)) As Aprobado,
SUM(isnull(T_PresupuestoFlujo.Modificado,0)) As Modificado
		from T_PresupuestoFlujo inner join 
		C_PartidasGastosIngresos 
          ON T_PresupuestoFlujo.IdPartida = C_PartidasGastosIngresos.IdPartidaGI  
         LEFT JOIN 
           C_FuenteFinanciamiento FF
          ON FF.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento  

		where T_PresupuestoFlujo.Ejercicio = @Ejercicio
		AND  (Mes BETWEEN  1 AND @Periodo)

		group by FF.Clave, FF.DESCRIPCION
		Order By FF.Clave

Declare @Ingresos2 as TABLE(
Tipo varchar(10),
Clave varchar(200),
Descripcion varchar (255),

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

INSERT INTO @Ingresos2 
Select 'ING', Clave,   Descripcion As Descripcion,
 ISNULL([0],0) ,ISNULL([1],0), ISNULL([2],0), ISNULL([3],0),ISNULL([4],0),ISNULL([5],0),ISNULL([6],0),ISNULL([7],0),ISNULL([8],0),ISNULL([9],0),ISNULL([10],0),ISNULL([11],0),ISNULL([12],0)
From (
		Select FF.CLAVE , FF.DESCRIPCION ,  T_PresupuestoFlujo.Mes, isnull(T_PresupuestoFlujo.Recaudado,0) As Recaudado
		from T_PresupuestoFlujo inner join 
		C_PartidasGastosIngresos 
          ON T_PresupuestoFlujo.IdPartida = C_PartidasGastosIngresos.IdPartidaGI  
         LEFT JOIN 
           C_FuenteFinanciamiento FF
          ON FF.IDFUENTEFINANCIAMIENTO = C_PartidasGastosIngresos.IdFuenteFinanciamiento  

		where T_PresupuestoFlujo.Ejercicio = @Ejercicio 
		AND (Mes BETWEEN  1 AND @Periodo)
		
	 ) as p
	PIVOT 
	( 
		sum(Recaudado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by Clave

--Select * from @Ingresos
--Select * from @Ingresos2

--Select T.Clave, T.Descripcion,
--A.Autorizado,
--T.[0],
--T.[1],
--T.[2],
--T.[3],
--T.[4],
--T.[5],
--T.[6],
--T.[7],
--T.[8],
--T.[9],
--T.[10],
--T.[11],
--T.[12]
--from @Ingresos2 T JOIN @Ingresos a on T.Clave = A.CLAVE


---------------------------------------------------------------

--Select * from @Egresos
--UNION ALL
--Select * from @Ingresos

Select 'ING' as Unidad,T.Clave, T.Descripcion,
A.Modificado as [0],
--T.[0],
T.[1],
T.[2],
T.[3],
T.[4],
T.[5],
T.[6],
T.[7],
T.[8],
T.[9],
T.[10],
T.[11],
T.[12],
T.[1]+T.[2]+T.[3]+T.[4]+T.[5]+T.[6]+T.[7]+T.[8]+T.[9]+T.[10]+T.[11]+T.[12] as Total
from @Ingresos2 T JOIN @Ingresos a on T.Clave = A.CLAVE

UNION ALL

Select 'EGR' as Unidad,T.Clave, T.Descripcion,
A.Modificado as [0],
--T.[0],
T.[1],
T.[2],
T.[3],
T.[4],
T.[5],
T.[6],
T.[7],
T.[8],
T.[9],
T.[10],
T.[11],
T.[12],
T.[1]+T.[2]+T.[3]+T.[4]+T.[5]+T.[6]+T.[7]+T.[8]+T.[9]+T.[10]+T.[11]+T.[12] as Total
from @Egresos2 T JOIN @Egresos a on T.Clave = A.CLAVE



END
GO

EXEC SP_FirmasReporte 'IDEFT Comparativo Ingreso vs Egreso'
GO