/****** Object:  StoredProcedure [dbo].[RPT_SeguimientoIndicadoresMetas]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SeguimientoIndicadoresMetas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SeguimientoIndicadoresMetas]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SeguimientoIndicadoresMetas]    Script Date: 12/03/2012 17:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Bug:	KOR-70
	Date:	2021-07-09
*/

-- Exec RPT_SeguimientoIndicadoresMetas '1529',2021,9,1
CREATE PROCEDURE [dbo].[RPT_SeguimientoIndicadoresMetas] 
	--@IdUsuario int, 
	--@IdMeta int,
	@CadenaMeta varchar(max),
	@Ejercicio int, 
	@Mes int,
	@Calendarizacion bit

AS
BEGIN

Declare @Seguimiento as Table(IdDefMeta int,
						Avance decimal(5,2),
						Cero decimal(13,4),
						Enero decimal(13,4),
						Febrero decimal(13,4),
						Marzo decimal(13,4),
						Abril decimal(13,4),
						Mayo decimal(13,4),
						Junio decimal(13,4),
						Julio decimal(13,4),
						Agosto decimal(13,4),
						Septiembre decimal(13,4),
						Octubre decimal(13,4),
						Noviembre decimal(13,4),
						Diciembre decimal(13,4)
						)

 	Create TABLE #Info(ID int,
						IdPadre int,
						level int,
						Indicador varchar(200),
						Clave varchar(200),
						Descripcion varchar(max),
						IdUnicoProyecto int,
						IdProdMeta int,
						Cantidad int,
						IdAreaResp int,
						IdActInst int,
						Modificado decimal(18,2),
						Comprometido decimal(18,2),
						Devengado decimal(18,2),
						Ejercido decimal(18,2),
						Pagado decimal(18,2),
						Enero int,
						Febrero int,
						Marzo int,
						Abril int,
						Mayo int,
						Junio int,
						Julio int,
						Agosto int,
						Septiembre int,
						Octubre int,
						Noviembre int,
						Diciembre int,
						Ejercicio int
						);
IF @CadenaMeta != ''
BEGIN
--Declare @Cadena varchar(100) = '58,59,60'
	DECLARE @sql nvarchar(max)

SET @sql = 

'WITH tree (ID, IdPadre, level, Indicador, Clave, Descripcion, IdUnicoProyecto, IdProdMeta, Cantidad, IdAreaResp, IdActInst, Modificado, Comprometido, Devengado, Ejercido, Pagado, Ejercicio) as '
+ '( '
+'SELECT IdDefMeta, IdPadre, 0 as level, IdIndicador, Clave, Descripcion,IdUnicoProyecto, IdProdMeta, Cantidad, '
+'ISNULL((SELECT  IdAreaResp FROM C_Departamentos WHERE IdDepartamento = T_DefinicionMetas.IdDepartamento),0) as IdAreaResp, '
+'ISNULL((SELECT IdPadre FROM C_EP_Ramo WHERE Id = T_DefinicionMetas.IdUnicoProyecto AND Nivel = 5),0) as IdActInst, '
+'0 as Modificado , '
+'0 as Comprometido , '
+'0 as Devengado , '
+'0 as Ejercido , '
+'0 as Pagado , '
+'Ejercicio '
+'FROM T_DefinicionMetas '
+'WHERE IdPadre = 0 '
+'AND T_DefinicionMetas.IdDefMeta in (' + @CadenaMeta + ') '

+'UNION ALL '

+'SELECT c2.IdDefMeta, c2.IdPadre, tree.level + 1, c2.IdIndicador, c2.Clave, c2.Descripcion,c2.IdUnicoProyecto, c2.IdProdMeta, c2.Cantidad, '
+'ISNULL((SELECT IdAreaResp FROM C_Departamentos WHERE IdDepartamento = c2.IdDepartamento),0) as IdAreaResp, '
+'ISNULL((SELECT IdPadre FROM C_EP_Ramo WHERE Id = c2.IdUnicoProyecto AND Nivel = 5),0) as IdActInst, '
+'0 as Modificado , '
+'0 as Comprometido , '
+'0 as Devengado , '
+'0 as Ejercido , '
+'0 as Pagado , '
+'c2.Ejercicio '
+'FROM T_DefinicionMetas c2 '
+'INNER JOIN tree ON tree.id = c2.IdPadre '
+'WHERE c2.Ejercicio = ' + Convert(nvarchar(20),@Ejercicio)

+') '
+'SELECT ID, IdPadre, level, Indicador, Clave, Descripcion,IdUnicoProyecto, IdProdMeta, Cantidad, IdAreaResp, IdActInst, Modificado, Comprometido, Devengado, Ejercido, Pagado,0,0,0,0,0,0,0,0,0,0,0,0, Ejercicio '
+'FROM tree '

Insert into #info
EXEC (@sql)

Insert into @Seguimiento
Select IdDefMeta, Avance, 
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (	
SELECT 
IdDefMeta,
Avance,
Cantidad,
Month(FechaAprobacion) as Mes
FROM T_SeguimientoMeta Where Year(FechaAprobacion) = @Ejercicio And Estatus = 'Aprobado' AND Month(FechaAprobacion) <= @Mes
) as p
	PIVOT 
	( 
		sum(Cantidad) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable



UPDATE I SET
	 I.Modificado = ISNULL(( SELECT SUM(p.Modificado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @Ejercicio 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),   
	 I.Comprometido = ISNULL(( SELECT SUM(p.Comprometido)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @Ejercicio 
				AND p.Mes <= @Mes AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),   
	I.Devengado = ISNULL(( SELECT SUM(p.Devengado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @Ejercicio 
				AND p.Mes <= @Mes AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00), 
	I.Ejercido = ISNULL(( SELECT SUM(p.Ejercido)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @Ejercicio 
				AND p.Mes <= @Mes AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),
	I.Pagado = ISNULL(( SELECT SUM(p.Pagado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @Ejercicio 
				AND p.Mes <= @Mes AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00)   
	FROM #info I
END
ELSE
BEGIN


	WITH tree (ID, IdPadre, level, Indicador, Clave, Descripcion, IdUnicoProyecto, IdProdMeta, Cantidad, IdAreaResp, IdActInst, Modificado, Comprometido, Devengado, Ejercido, Pagado,Ejercicio) as 
(
   SELECT IdDefMeta, IdPadre, 0 as level, IdIndicador, Clave, Descripcion,IdUnicoProyecto, IdProdMeta, Cantidad,
   ISNULL((SELECT  IdAreaResp FROM C_Departamentos WHERE IdDepartamento = T_DefinicionMetas.IdDepartamento),0) as IdAreaResp,
   ISNULL((SELECT IdPadre FROM C_EP_Ramo WHERE Id = T_DefinicionMetas.IdUnicoProyecto AND Nivel = 5),0) as IdActInst,
   0 as Modificado ,
   0 as Comprometido ,
   0 as Devengado ,
   0 as Ejercido ,
   0 as Pagado,
   Ejercicio
   FROM T_DefinicionMetas
   WHERE IdPadre = 0
   --AND T_DefinicionMetas.IdDefMeta = @IdMeta

   UNION ALL

   SELECT c2.IdDefMeta, c2.IdPadre, tree.level + 1, c2.IdIndicador, c2.Clave, c2.Descripcion,c2.IdUnicoProyecto, c2.IdProdMeta, c2.Cantidad,
   ISNULL((SELECT IdAreaResp FROM C_Departamentos WHERE IdDepartamento = c2.IdDepartamento),0) as IdAreaResp,
   ISNULL((SELECT IdPadre FROM C_EP_Ramo WHERE Id = c2.IdUnicoProyecto AND Nivel = 5),0) as IdActInst,
   0 as Modificado ,
   0 as Comprometido ,
   0 as Devengado ,
   0 as Ejercido ,
   0 as Pagado ,
   c2.Ejercicio
   FROM T_DefinicionMetas c2 
     INNER JOIN tree ON tree.id = c2.IdPadre
	 
)


Insert into #Info
SELECT ID, IdPadre, level, Indicador, Clave, Descripcion,IdUnicoProyecto, IdProdMeta, Cantidad, IdAreaResp, IdActInst, Modificado, Comprometido, Devengado, Ejercido, Pagado,0,0,0,0,0,0,0,0,0,0,0,0,Ejercicio
FROM tree

Insert into @Seguimiento
Select IdDefMeta, Avance, 
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (	
SELECT 
IdDefMeta,
Avance,
Cantidad,
Month(FechaAprobacion) as Mes
FROM T_SeguimientoMeta 
Where Year(FechaAprobacion) = @Ejercicio 
AND Estatus = 'Aprobado' --AND Month(FechaAprobacion) <= @Mes
) as p
	PIVOT 
	( 
		sum(Cantidad) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

 --Select * from #info
--------------------------------------------------------------------------------
CREATE TABLE #Ejercicios (
       RowID int IDENTITY(1, 1), 
      Ejercicio int
 )
DECLARE @NumberRecordsEj int
Declare @RowCounterEj int
DECLARE @EjercicioPadre int

INSERT INTO #Ejercicios
Select distinct Ejercicio from T_DefinicionMetas where IdPadre = 0

SET @NumberRecordsEj = @@RowCount 
SET @RowCounterEj = 1

WHILE @RowCounterEj <= @NumberRecordsEj
BEGIN
 SELECT @EjercicioPadre = Ejercicio 
 FROM #Ejercicios
 WHERE RowID = @RowCounterEj


						UPDATE I SET
	 I.Modificado = ISNULL(( SELECT SUM(p.Modificado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @EjercicioPadre 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),   
	 I.Comprometido = ISNULL(( SELECT SUM(p.Comprometido)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @EjercicioPadre 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),   
	I.Devengado = ISNULL(( SELECT SUM(p.Devengado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @EjercicioPadre 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00), 
	I.Ejercido = ISNULL(( SELECT SUM(p.Ejercido)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @EjercicioPadre 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00),
	I.Pagado = ISNULL(( SELECT SUM(p.Pagado)
				From T_PresupuestoNw p JOIN T_SellosPresupuestales s
				ON p.IdSelloPresupuestal = s.IdSelloPresupuestal
				AND p.[Year] =  @EjercicioPadre 
				AND p.Mes = 0 AND
				(I.IdAreaResp <> 0 AND I.IdAreaResp = s.IdAreaResp ) AND
				(I.IdActInst <> 0 AND I.IdActInst = s.IdActInstitucional)  AND
				(I.IdUnicoProyecto <> 0 AND I.IdUnicoProyecto = s.IdProyecto)   
			  ),0.00)   
	FROM #info I Where Ejercicio = @EjercicioPadre
									

 SET @RowCounterEj = @RowCounterEj + 1
END

DROP TABLE #Ejercicios
END

Update I set 
I.Enero = ISNULL(S.Enero,0),
I.Febrero = ISNULL(S.Febrero,0),
I.Marzo = ISNULL(S.Marzo,0),
I.Abril = ISNULL(S.Abril,0),
I.Mayo = ISNULL(S.Mayo,0),
I.Junio = ISNULL(S.Junio,0),
I.Julio = ISNULL(S.Julio,0),
I.Agosto = ISNULL(S.Agosto,0),
I.Septiembre = ISNULL(S.Septiembre,0),
I.Octubre = ISNULL(S.Octubre,0),
I.Noviembre = ISNULL(S.Noviembre,0),
I.Diciembre = ISNULL(S.Diciembre,0)

FROM #Info I JOIN 
(
Select IdDefMeta,
SUM(Enero) as Enero,
SUM(Febrero) as Febrero,
SUM(Marzo) as Marzo,
SUM(Abril) as Abril,
SUM(Mayo) as Mayo,
SUM(Junio) as Junio,
SUM(Julio) as Julio,
SUM(Agosto) as Agosto,
SUM(Septiembre) as Septiembre,
SUM(Octubre) as Octubre,
SUM(Noviembre) as Noviembre,
SUM(Diciembre) as Diciembre
 FROM @Seguimiento 
group by IdDefMeta
) S
ON I.ID = S.IdDefMeta

-------------------------*************************************************
CREATE TABLE #Sumatorias (
       RowID int IDENTITY(1, 1), 
      IdPadre int,
	  Nivel int
 )
DECLARE @NumberRecords int
Declare @RowCounter int
DECLARE @NumeroCuenta varchar(100)
DECLARE @IdPadre int
DECLARE @Nivel int

SET @Nivel = (Select max(level) from #info)
--Select @Nivel

WHILE @Nivel >= 0
BEGIN
--Select @Nivel

INSERT INTO #Sumatorias
SELECT distinct IdPadre, level FROM #Info 
     Where level = @Nivel

--Select * from #Sumatorias	 

SET @NumberRecords = @@RowCount 
SET @RowCounter = 1

	WHILE @RowCounter <= @NumberRecords
	BEGIN
	 SELECT @IdPadre = IdPadre,
	 @Nivel = Nivel
	 FROM #Sumatorias
	 WHERE RowID = @RowCounter


						Update #Info set
						Modificado = (Select ISNULL(SUM(Modificado),0) from #Info Where [level] = @Nivel and IdPadre = @IdPadre),
						Comprometido = (Select ISNULL(SUM(Comprometido),0) from #Info Where [level] = @Nivel and IdPadre = @IdPadre),
						Devengado = (Select ISNULL(SUM(Devengado),0) from #Info Where [level] = @Nivel and IdPadre = @IdPadre),
						Ejercido = (Select ISNULL(SUM(Ejercido),0) from #Info Where [level] = @Nivel and IdPadre = @IdPadre),
						Pagado = (Select ISNULL(SUM(Pagado),0) from #Info Where [level] = @Nivel and IdPadre = @IdPadre)
					
						Where ID = @IdPadre and [level] = @Nivel -1
									

	 SET @RowCounter = @RowCounter + 1

	END
	SET @Nivel = @Nivel - 1
	TRUNCATE TABLE #Sumatorias


END

DROP TABLE #Sumatorias
-------------------------*************************************************

If @Calendarizacion != 0
BEGIN
Select 

ID ,
IdPadre,
Clave,
Descripcion,
level,
CI.Nombre as Indicador,
F.Cantidad,
CPM.Nombre as Entregable,
IdUnicoProyecto,
Enero,
Febrero,
Marzo,
Abril,
Mayo,
Junio,
Julio,
Agosto,
Septiembre,
Octubre,
Noviembre,
Diciembre ,
IdAreaResp,
IdActInst,
Modificado as Presupuesto_Asignado,
(Enero+Febrero+Marzo+Abril+Mayo+Junio+Julio+Agosto+Septiembre+Octubre+Noviembre+Diciembre) as Cantidad_Av,
CONCAT(CAST(ISNULL(CAST(((Enero+Febrero+Marzo+Abril+Mayo+Junio+Julio+Agosto+Septiembre+Octubre+Noviembre+Diciembre) * 100) as decimal(18,2)),0)/NULLIF(Cantidad,0) as decimal(18,2)),'%') as Porc_Av,
Comprometido,
CONCAT(CAST(ISNULL((Comprometido * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Comprometido, 
Devengado,
CONCAT(CAST(ISNULL((Devengado * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Devengado, 
Ejercido,
CONCAT(CAST(ISNULL((Ejercido * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Ejercido, 
Pagado,
CONCAT(CAST(ISNULL((Pagado * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Pagado

from #info F
LEFT JOIN C_ProductosMetas CPM on F.IdProdMeta = CPM.IdProdMeta 
LEFT JOIN C_Indicadores CI on F.Indicador = CI.IdIndicador
END
ELSE
BEGIN
Select 

ID ,
IdPadre,
Clave,
Descripcion,
level,
CI.Nombre as Indicador,
F.Cantidad,
CPM.Nombre as Entregable,
IdUnicoProyecto,
(Enero+Febrero+Marzo+Abril+Mayo+Junio+Julio+Agosto+Septiembre+Octubre+Noviembre+Diciembre) as Cantidad_Av,
CONCAT(CAST(ISNULL(CAST(((Enero+Febrero+Marzo+Abril+Mayo+Junio+Julio+Agosto+Septiembre+Octubre+Noviembre+Diciembre) * 100) as decimal(18,2)),0)/NULLIF(Cantidad,0) as decimal(18,2)),'%') as Porc_Av,

IdAreaResp,
IdActInst,
Modificado as Presupuesto_Asignado,
Comprometido,
CONCAT(CAST(ISNULL((Comprometido * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Comprometido, 
Devengado,
CONCAT(CAST(ISNULL((Devengado * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Devengado, 
Ejercido,
CONCAT(CAST(ISNULL((Ejercido * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Ejercido, 
Pagado,
CONCAT(CAST(ISNULL((Pagado * 100),0)/NULLIF(Modificado,0) as decimal(18,2)),'%') as Porc_Pagado

from #info F
LEFT JOIN C_ProductosMetas CPM on F.IdProdMeta = CPM.IdProdMeta 
LEFT JOIN C_Indicadores CI on F.Indicador = CI.IdIndicador
END

DROP TABLE #Info

 
END
GO 