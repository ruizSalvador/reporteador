/****** Object:  StoredProcedure [dbo].[RPT_SP_Comparativo_Calendarizado_Pres]    Script Date: 07/05/2021 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Comparativo_Calendarizado_Pres]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Comparativo_Calendarizado_Pres]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Comparativo_Calendarizado_Pres]    Script Date: 07/05/2021 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec RPT_SP_Comparativo_Calendarizado_Pres 3,2021,10000,11101,0,0,0,0,3
CREATE PROCEDURE [dbo].[RPT_SP_Comparativo_Calendarizado_Pres]

@PeriodoFin int,
@Ejercicio int,
@IdCapitulo int,
@IdPartida int,
@IdUR int,
@IdDepto int,
@ClaveProg int,
@IdFF int,
@Tipo int


AS 
BEGIN

Declare @Modificado as TABLE(
IdSello int,
Sello varchar (255),
IdCap int,
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

Declare @Comprometido as TABLE(
IdSello int,
Sello varchar (255),
IdCap int,
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

Declare @Devengado as TABLE(
IdSello int,
Sello varchar (255),
IdCap int,
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

IF @Tipo = 1
BEGIN

	INSERT INTO @Modificado
	Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
	[0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
	From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		--isnull(T_PresupuestoNW.Modificado,0) As Modificado
		(ISNULL(T_PresupuestoNW.Autorizado,0) +(ISNULL(T_PresupuestoNW.Ampliaciones,0) + ISNULL(T_PresupuestoNW.TransferenciaAmp,0)) - (ISNULL(T_PresupuestoNW.Reducciones,0) + ISNULL(T_PresupuestoNW.TransferenciaRed,0)))as Modificado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end

		
	 ) as p
	PIVOT 
	( 
		sum(Modificado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap

	INSERT INTO @Comprometido 
Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		isnull(T_PresupuestoNW.Comprometido,0) As Comprometido
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end 

		
	 ) as p
	PIVOT 
	( 
		sum(Comprometido) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap


SELECT M.IdSello, M.Sello, M.IdCap,
isnull(M.[1],0)-isnull(C.[1],0) + isnull(M.[2],0)-isnull(C.[2],0) + isnull(M.[3],0)-isnull(C.[3],0) + isnull(M.[4],0)-isnull(C.[4],0) + isnull(M.[5],0)-isnull(C.[5],0) +
isnull(M.[6],0)-isnull(C.[6],0) + isnull(M.[7],0)-isnull(C.[7],0) + isnull(M.[8],0)-isnull(C.[8],0) + isnull(M.[9],0)-isnull(C.[9],0) + isnull(M.[10],0)-isnull(C.[10],0) +
isnull(M.[11],0)-isnull(C.[11],0) + isnull(M.[12],0)-isnull(C.[12],0) as [0],
isnull(M.[1],0)-isnull(C.[1],0) as [1],
isnull(M.[2],0)-isnull(C.[2],0) as [2],
isnull(M.[3],0)-isnull(C.[3],0) as [3],
isnull(M.[4],0)-isnull(C.[4],0) as [4],
isnull(M.[5],0)-isnull(C.[5],0) as [5],
isnull(M.[6],0)-isnull(C.[6],0) as [6],
isnull(M.[7],0)-isnull(C.[7],0) as [7],
isnull(M.[8],0)-isnull(C.[8],0) as [8],
isnull(M.[9],0)-isnull(C.[9],0) as [9],
isnull(M.[10],0)-isnull(C.[10],0) as [10],
isnull(M.[11],0)-isnull(C.[11],0) as [11],
isnull(M.[12],0)-isnull(C.[12],0) as [12]
from @Modificado M JOIN @Comprometido C ON M.IdSello = C.IdSello
Order by IdCap,IdSello

END
-------------------------

IF @Tipo = 2
BEGIN

	INSERT INTO @Modificado
	Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
	[0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
	From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		(ISNULL(T_PresupuestoNW.Autorizado,0) +(ISNULL(T_PresupuestoNW.Ampliaciones,0) + ISNULL(T_PresupuestoNW.TransferenciaAmp,0)) - (ISNULL(T_PresupuestoNW.Reducciones,0) + ISNULL(T_PresupuestoNW.TransferenciaRed,0)))as Modificado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end

		
	 ) as p
	PIVOT 
	( 
		sum(Modificado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap

	INSERT INTO @Devengado
Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		isnull(T_PresupuestoNW.Devengado,0) As Devengado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end 

		
	 ) as p
	PIVOT 
	( 
		sum(Devengado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap


SELECT M.IdSello, M.Sello, M.IdCap,

isnull(M.[1],0)-isnull(D.[1],0) + isnull(M.[2],0)-isnull(D.[2],0) + isnull(M.[3],0)-isnull(D.[3],0) + isnull(M.[4],0)-isnull(D.[4],0) + isnull(M.[5],0)-isnull(D.[5],0) +
isnull(M.[6],0)-isnull(D.[6],0) + isnull(M.[7],0)-isnull(D.[7],0) + isnull(M.[8],0)-isnull(D.[8],0) + isnull(M.[9],0)-isnull(D.[9],0) + isnull(M.[10],0)-isnull(D.[10],0) +
isnull(M.[11],0)-isnull(D.[11],0) +isnull(M.[12],0)-isnull(D.[12],0) as [0],
isnull(M.[1],0)-isnull(D.[1],0) as [1],
isnull(M.[2],0)-isnull(D.[2],0) as [2],
isnull(M.[3],0)-isnull(D.[3],0) as [3],
isnull(M.[4],0)-isnull(D.[4],0) as [4],
isnull(M.[5],0)-isnull(D.[5],0) as [5],
isnull(M.[6],0)-isnull(D.[6],0) as [6],
isnull(M.[7],0)-isnull(D.[7],0) as [7],
isnull(M.[8],0)-isnull(D.[8],0) as [8],
isnull(M.[9],0)-isnull(D.[9],0) as [9],
isnull(M.[10],0)-isnull(D.[10],0) as [10],
isnull(M.[11],0)-isnull(D.[11],0) as [11],
isnull(M.[12],0)-isnull(D.[12],0) as [12]
from @Modificado M JOIN @Devengado D ON M.IdSello = D.IdSello
Order by IdCap,IdSello

END
-------------------------

IF @Tipo = 3
BEGIN

	INSERT INTO @Devengado
	Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
	[0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
	From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		isnull(T_PresupuestoNW.Devengado,0) As Devengado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end

		
	 ) as p
	PIVOT 
	( 
		sum(Devengado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap

	INSERT INTO @Comprometido
Select IdSelloPresupuestal, Sello, IdCapitulo As IdCap, 
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (
		Select T_PresupuestoNW.IdSelloPresupuestal, T_SellosPresupuestales.Sello, C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, 
		isnull(T_PresupuestoNW.Comprometido,0) As Comprometido
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_SellosPresupuestales.LYear = @Ejercicio
		AND T_PresupuestoNW.Mes Between 1 and @PeriodoFin
		AND C_CapitulosNEP.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN C_CapitulosNEP.IdCapitulo ELSE @IdCapitulo END
		AND T_SellosPresupuestales.IdPartida = CASE WHEN @IdPartida = 0 THEN T_SellosPresupuestales.IdPartida ELSE @IdPartida END
		AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END
		AND T_SellosPresupuestales.IdDepartamento = CASE WHEN @IdDepto = 0 THEN T_SellosPresupuestales.IdDepartamento ELSE @IdDepto END
		AND T_SellosPresupuestales.IdProyecto = CASE WHEN @ClaveProg = 0 THEN T_SellosPresupuestales.IdProyecto else @ClaveProg end 
		AND T_SellosPresupuestales.IdFuenteFinanciamiento = CASE WHEN @IdFF = 0 THEN T_SellosPresupuestales.IdFuenteFinanciamiento else @IdFF end 

		
	 ) as p
	PIVOT 
	( 
		sum(Comprometido) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdCap


SELECT D.IdSello, D.Sello, D.IdCap,
isnull(D.[1],0)-isnull(C.[1],0) + isnull(D.[2],0)-isnull(C.[2],0) + isnull(D.[3],0)-isnull(C.[3],0) + isnull(D.[4],0)-isnull(C.[4],0) + isnull(D.[5],0)-isnull(C.[5],0) +
isnull(D.[6],0)-isnull(C.[6],0) + isnull(D.[7],0)-isnull(C.[7],0) + isnull(D.[8],0)-isnull(C.[8],0) + isnull(D.[9],0)-isnull(C.[9],0) + isnull(D.[10],0)-isnull(C.[10],0) +
isnull(D.[11],0)-isnull(C.[11],0) +isnull(D.[12],0)-isnull(C.[12],0) as [0],
isnull(D.[1],0)-isnull(C.[1],0) as [1],
isnull(D.[2],0)-isnull(C.[2],0) as [2],
isnull(D.[3],0)-isnull(C.[3],0) as [3],
isnull(D.[4],0)-isnull(C.[4],0) as [4],
isnull(D.[5],0)-isnull(C.[5],0) as [5],
isnull(D.[6],0)-isnull(C.[6],0) as [6],
isnull(D.[7],0)-isnull(C.[7],0) as [7],
isnull(D.[8],0)-isnull(C.[8],0) as [8],
isnull(D.[9],0)-isnull(C.[9],0) as [9],
isnull(D.[10],0)-isnull(C.[10],0) as [10],
isnull(D.[11],0)-isnull(C.[11],0) as [11],
isnull(D.[12],0)-isnull(C.[12],0) as [12]
from @Devengado D JOIN @Comprometido C ON D.IdSello = C.IdSello
Order by IdCap,IdSello

END
-------------------------
END 


GO


EXEC SP_FirmasReporte 'Comparativo Presupuestal por Sello'
GO
Exec SP_CFG_LogScripts 'RPT_SP_Comparativo_Calendarizado_Pres','2.30.1'
GO


