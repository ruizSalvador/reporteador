/****** Object:  StoredProcedure [dbo].[SP_RPT_AplicaciónRecursosFORTAMUNDetallado]    Script Date: 1/11/2017 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AplicaciónRecursosFORTAMUNDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AplicaciónRecursosFORTAMUNDetallado]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_AplicaciónRecursosFORTAMUNDetallado]    Script Date: 1/11/2017 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_AplicaciónRecursosFORTAMUNDetallado]   
  
@Mes  as int,   
@Mes2 as int,    
@Tipo as int,  
@Ejercicio as int,  
@IdFF as varchar(6),  
@IdArea as int,  
@AmpRedAnual int,  
@IdSello int,  
@IdSelloFin int,  
@IdPartida int,  
@IdCapitulo int  
  
AS  
BEGIN  
if @Tipo=6  
BEGIN   
Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))  
Insert into @Anual6  
Select CN.IdConcepto  as Clave,   
sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red  
--,ts.IdFuenteFinanciamiento
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG  ,C_FuenteFinanciamiento As CF
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and ts.IdFuenteFinanciamiento=@IdFF
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo--,ts.IdFuenteFinanciamiento 
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  
  
--Tabla de titulos   
Declare @Titulos as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))  
  
INSERT INTO @Titulos  
SELECT CG.IdCapitulo as IdClave,   
CG.Descripcion as Descripcion,   
CN.IdConcepto  as Clave,   
CN.Descripcion as Descripcion2,   
CN.IdCapitulo as IdClave2,   
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado,   
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio   
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG  
WHERE CG.IdCapitulo = CN.IdCapitulo  
  
Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))  
Insert into @rpt  
--VALORES ABSOLUTOS  
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **  
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,  
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
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
sum(ISNULL(TP.Devengado,0))as SubEjercicio  
--,ts.IdFuenteFinanciamiento 
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG  ,C_FuenteFinanciamiento As CF
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END and ts.IdFuenteFinanciamiento=@IdFF
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo -- ,ts.IdFuenteFinanciamiento
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  
  
insert into @rpt  
select* from @Titulos t   
where t.Clave not in (select Clave from @rpt)  
  
 If @AmpRedAnual = 1  
  Begin  
   update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  
   select * from @rpt Order by  IdClave , Clave, IdClave2  
  End  
 Else  
  Begin  
   update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  
   select * from @rpt Order by  IdClave , Clave, IdClave2  
  End  
END    
END  
  go

  --exec SP_RPT_EstadoEjercicioPresupuestoEGR @Mes=1,@Mes2=11,@Tipo=6,@Ejercicio=2017,@IdFF=N'',@IdArea=0,@AmpRedAnual=0,@IdSello=0,@IdSelloFin=0,@IdPartida=0,@IdCapitulo=0
  --exec SP_RPT_AplicaciónRecursosFORTAMUNDetallado @Mes=1,@Mes2=3,@Tipo=6,@Ejercicio=N'2017',@IdFF=N'12',@IdArea=0,@AmpRedAnual=0,@IdSello=0,@IdSelloFin=0,@IdPartida=0,@IdCapitulo=0

  --select * from C_FuenteFinanciamiento where IDFUENTEFINANCIAMIENTO in(1,5,6,7,8,12,13,14,16)