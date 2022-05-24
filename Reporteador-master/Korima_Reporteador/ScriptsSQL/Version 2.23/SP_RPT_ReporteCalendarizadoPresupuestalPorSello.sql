/****** Object:  StoredProcedure [dbo].[SP_RPT_ReporteCalendarizadoPresupuestalPorSello]    Script Date: 05/20/2016 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ReporteCalendarizadoPresupuestalPorSello]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ReporteCalendarizadoPresupuestalPorSello]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ReporteCalendarizadoPresupuestalPorSello]    Script Date: 05/20/2016 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_ReporteCalendarizadoPresupuestalPorSello 1,12,2,2016,'',4,4,'','',''
CREATE PROCEDURE [dbo].[SP_RPT_ReporteCalendarizadoPresupuestalPorSello] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveP as int,
@ClaveFF as int,
@ClaveFF2 as int,
@ClaveUR as int,
@ClaveUR2 as int,
@IdEP as int

AS
BEGIN

Declare @rpt as table(
 IdSello varchar(10), Sello varchar(max), IdCapitulo int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4), IdFuenteFinanciamiento varchar(10), Mes int)

Declare @rptFinal as table(
 IdSello varchar(10), Sello varchar(max), IdCapitulo int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4), IdFuenteFinanciamiento varchar(10), Mes int)

DECLARE @Pivot as table (
	IdSello int,
	Sello varchar(max),
	 IdCapitulo int,
	[0] decimal(18,2),
	[1] decimal(18,2),
	[2] decimal(18,2),
	[3] decimal(18,2),
	[4] decimal(18,2),
	[5] decimal(18,2),
	[6] decimal(18,2),
	[7] decimal(18,2),
	[8] decimal(18,2),
	[9] decimal(18,2),
	[10] decimal(18,2),
	[11] decimal(18,2),
	[12] decimal(18,2))

Insert Into @rpt
Select TP.IdSelloPresupuestal , TS.Sello, CG.IdCapitulo,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio,  
CF.IdFuenteFinanciamiento as IdFuenteFinanciamiento,
Mes
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG,
C_PartidasGenericasPres, C_FuenteFinanciamiento CF, C_EP_Ramo CEPR, C_AreaResponsabilidad CAR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
and CP.IdPartidaGenerica=C_PartidasGenericasPres.IdPartidaGenerica AND TS.IdFuenteFinanciamiento = CF.IDFUENTEFINANCIAMIENTO AND CEPR.Id = TS.IdProyecto AND CAR.IdAreaResp = TS.IdAreaResp
AND CEPR.Id = case when @IdEP = '' then CEPR.id else @IdEP end
AND CP.ClavePartida = case when @ClaveP = '' then CP.ClavePartida else @ClaveP end
--AND CF.IdFuenteFinanciamiento Between (CASE WHEN @ClaveFF = '' THEN CAR.Clave ELSE @ClaveFF END) and (CASE WHEN @ClaveFF2 = '' THEN CAR.Clave ELSE @ClaveFF2 END)
AND CAR.IdAreaResp Between (CASE WHEN @ClaveUR = '' THEN CAR.IdAreaResp ELSE @ClaveUR END) and (CASE WHEN @ClaveUR2 = '' THEN CAR.IdAreaResp ELSE @ClaveUR2 END)
group by TP.IdSelloPresupuestal, TS.Sello, CF.IDFUENTEFINANCIAMIENTO, Mes, CG.IdCapitulo
Order By TP.IdSelloPresupuestal


If @ClaveFF <> ''
	Begin
	Insert into @rptFinal
		select * from @rpt where IdFuenteFinanciamiento Between @ClaveFF and  @ClaveFF2 Order by  IdSello 
	End
Else
	Begin
	Insert into @rptFinal
		select * from @rpt Order by  IdSello
	End

	If @Tipo=0
	BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo, Autorizado,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Autorizado]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
	END

If @Tipo=1
	BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo,Modificado,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Modificado]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
END

If @Tipo=2
	BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo, Comprometido,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Comprometido]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
END

If @Tipo=3
	BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo, Devengado,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Devengado]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
END

If @Tipo=4
	BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo, Ejercido,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Ejercido]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
END

If @Tipo=5
BEGIN
		insert into @Pivot
		SELECT IdSello, Sello, IdCapitulo,
			[0],[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12] 
		FROM (SELECT 
			   IdSello, Sello, IdCapitulo, Pagado,Mes
			  FROM @rptFinal
	
			  ) as Todo  
		PIVOT( SUM([Pagado]) 
			FOR Mes IN ([0],[1],[2],[3],[4],[5],
			[6],[7],[8],[9],[10],[11],
			[12])) AS NamePivot
END



Select IdSello, Sello, IdCapitulo,
	isnull([1],0)+isnull([2],0)+isnull([3],0)+isnull([4],0)+isnull([5],0)+isnull([6],0)+isnull([7],0)+isnull([8],0)+isnull([9],0)+isnull([10],0)+isnull([11],0)+isnull([12],0) as [0], 
	IsNull([1],0) as [1], IsNull([2],0) as [2], IsNull([3],0) as [3], IsNull([4],0) as [4], IsNull([5],0) as [5], IsNull([6],0) as [6],
	IsNull([7],0) as [7], IsNull([8],0) as [8], IsNull([9],0) as [9], IsNull([10],0) as [10], IsNull([11],0) as [11], IsNull([12],0) as [12]
	From @Pivot
    Order by IdCapitulo,IdSello

END
GO

EXEC SP_FirmasReporte 'REPORTE CALENDARIZADO PRESUPUESTAL POR SELLO'
GO