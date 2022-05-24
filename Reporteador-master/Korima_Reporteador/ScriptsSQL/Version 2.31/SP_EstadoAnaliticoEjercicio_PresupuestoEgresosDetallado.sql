

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]    Script Date: 10/06/2017 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]    Script Date: 10/06/2017 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado]  
  @Mes  as int,   
  @Mes2 as int,    
  @Ejercicio as int,
  @MuestraCeros as int,
  @Tipo as int
AS  
BEGIN  
  

 declare @IdArea as int,  
@AmpRedAnual int
 select @IdArea=0
 select @AmpRedAnual=1
	 If @Tipo = 6
	 begin
	Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2),IdClaveFF int)  
	Insert into @Anual6  
	Select CN.IdConcepto  as Clave,   
	sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red  
	,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG  
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo  ,TS.IDFUENTEFINANCIAMIENTO
	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

	--Tabla de titulos   
	Declare @Titulos as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
	INSERT INTO @Titulos  
	SELECT CG.IdCapitulo as IdClave,   
	CG.Descripcion as Descripcion,   
	CN.IdConcepto  as Clave,   
	CN.Descripcion as Descripcion2,   
	CN.IdCapitulo as IdClave2,   
	0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado,   
	0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio   ,0 as IdClaveFF
	From  C_ConceptosNEP As CN, C_CapitulosNEP As CG  
	WHERE CG.IdCapitulo = CN.IdCapitulo  


	Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  

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
	sum(ISNULL(TP.Devengado,0))as SubEjercicio,
	(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG 
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo,CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,TS.IdFuenteFinanciamiento
	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

	insert into @rpt  
	select* from @Titulos t   
	where t.Clave not in (select Clave from @rpt)  


	 If @AmpRedAnual = 1  
	  Begin  
	   update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  and a.IdClaveFF=r.IdClaveFF
		if @MuestraCeros = 0
		begin
		delete from @rpt where Autorizado=0
		end
	   select * from @rpt Order by  IdClave , Clave, IdClave2  
	  End  
	 --Else  
	 -- Begin  
	 --  update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  
	 --  select * from @rpt Order by  IdClave , Clave, IdClave2  
	 -- End  
	 end
Else if @Tipo=2   
BEGIN  
declare @Anual2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
Insert into @Anual2  
Select CR.CLAVE, CR.Nombre,  
  
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
sum(ISNULL(TP.Devengado,0)) as SubEjercicio   
   ,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF   
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR  
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp  
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CR.CLAVE, CR.Nombre  ,TS. IDFUENTEFINANCIAMIENTO
Order By CR.CLAVE  
--VALORES ABSOLUTOS  
  
declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
Insert into @rptt  
Select CR.CLAVE, CR.Nombre,   
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
sum(ISNULL(TP.Devengado,0)) as SubEjercicio   
  ,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR  
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp  
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CR.CLAVE, CR.Nombre ,TS.IdFuenteFinanciamiento
Order By CR.CLAVE  
  
If @AmpRedAnual = 1  
 Begin  
 if @MuestraCeros = 0
		begin
		delete from @rptt where Autorizado=0
		end
 Select    
  a.CLAVE,a.DESCRIPCION,  
  isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,  
  isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,isnull(a.Amp_Red,0) as Amp_Red,isnull(r.SubEjercicio,0) as SubEjercicio,isnull(r.IdClaveFF,0) as IdClaveFF   
  from @Anual2 a  
  LEFT JOIN @rptt r  
  ON a.CLAVE = r.CLAVE  and a.IdClaveFF=r.IdClaveFF 
 End  
--Else  
 --Begin  
 -- Select    
 -- a.CLAVE,a.DESCRIPCION,  
 -- isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,  
 -- isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,isnull(r.Amp_Red,0) as Amp_Red,isnull(r.SubEjercicio,0) as SubEjercicio   
 -- from @Anual2 a  
 -- LEFT JOIN @rptt r  
 -- ON a.CLAVE = r.CLAVE  
 --End  
END  
	
Else if @Tipo=7   
BEGIN  
Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int)  
Insert into @Anual7  
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 
       ,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF        
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS  
where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad   ,TS.IdFuenteFinanciamiento
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  
Declare @Titulos7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
INSERT INTO @Titulos7  
SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,  
0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio  , 0 as IdClaveFF 
FROM C_funciones As CF, C_Finalidades As CFS  
WHERE CF.IdFinalidad = CFS.IdFinalidad   
GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad   
ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  
Declare @rpt7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
insert into @rpt7  
--VALORES ABSOLUTOS   
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **  
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
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
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--sum(ISNULL(TP.Comprometido,0)) as SubEjercicio   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
sum(ISNULL(TP.Devengado,0)) as SubEjercicio   
    ,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF   
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS  
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad   ,TS.IDFUENTEFINANCIAMIENTO
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  
insert into @rpt7  
select* from @Titulos7 t   
where t.Clave not in (select Clave from @rpt7)  
  
If @AmpRedAnual = 1  
 Begin  
  update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave and a.IdClaveFF = r.IdClaveFF
 End  
--ELse  
-- Begin  
--  update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave  
-- End  
 if @MuestraCeros = 0
		begin
		delete from @rpt7 where Autorizado=0
		end
select * from @rpt7  Order by  IdClave , Clave, IdClave2  
END  
END  
  go
EXEC SP_FirmasReporte 'Clasificacion por Objeto Gasto(Capitulo y Concepto)'  

go 


