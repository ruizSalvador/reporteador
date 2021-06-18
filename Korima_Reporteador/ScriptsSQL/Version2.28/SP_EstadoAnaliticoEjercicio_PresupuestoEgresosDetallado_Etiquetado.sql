

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado]    Script Date: 10/06/2017 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado]    Script Date: 10/06/2017 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado]  
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
		 select * from @rpt where IdClaveFF in (25,26,27) Order by  IdClave , Clave, IdClave2  
		end
		else
		begin 
		 select * from @rpt where IdClaveFF in (0,25,26,27) Order by  IdClave , Clave, IdClave2  
		end
	  
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
sum(ISNULL(0,0)) as Comprometido,   
sum(ISNULL(0,0)) as Devengado,   
sum(ISNULL(0,0)) as Ejercido,  
sum(ISNULL(0,0)) as Pagado,   
(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0)))) - sum(ISNULL(0,0)) As PresDispComp,  
sum(ISNULL(0,0)) - sum(ISNULL(0,0)) AS CompNoDev,  
(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))- sum(ISNULL(0,0))  AS PresSinDev,  
sum(ISNULL(0,0)) -  sum(ISNULL(0,0)) AS Deuda,  
(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) -   
(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as Amp_Red,   
(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))-  
sum(ISNULL(0,0)) as SubEjercicio 
, case FF.IdClave 
		  when '25' then '25'
		  when '26' then '25'
		  when '27' then '25'
		  when '0' then '0'
		  else '11'
		  end as idclaveFF 
From T_SellosPresupuestales As TS 
left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
Where (TP.Mes BETWEEN  1 AND 12) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
group by FF.IdClave,CR.Clave,CR.Nombre
Order By CR.CLAVE 
--VALORES ABSOLUTOS  
  
declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
Insert into @rptt  
Select CR.CLAVE, CR.Nombre,  
sum(ISNULL(0,0)) as Autorizado,   
(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaAmp,   
(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaRed,   
(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))as Modificado,  
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
, case FF.IdClave 
		  when '25' then '25'
		  when '26' then '25'
		  when '27' then '25'
		  when '0' then '0'
		  else '11'
		  end as idclaveFF 
From T_SellosPresupuestales As TS 
left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
Where (TP.Mes BETWEEN  @Mes AND @Mes2) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
group by FF.IdClave,CR.Clave,CR.Nombre
Order By CR.CLAVE 
  
If @AmpRedAnual = 1  
 Begin  
 if @MuestraCeros = 0
 begin
  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
  from @Anual2  
  where IdClaveFF in (0,25,26,27)
  group by CLAVE,DESCRIPCION,IdClaveFF
   union 
  Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
  from @rptt  
  where IdClaveFF in (25,26,27)
  group by CLAVE,DESCRIPCION,IdClaveFF)as X
  group by CLAVE,DESCRIPCION,IdClaveFF
end
else
begin 
  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
  from @Anual2  
  where IdClaveFF in (0,25,26,27)
  group by CLAVE,DESCRIPCION,IdClaveFF
   union 
   Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
  from @rptt  
  where IdClaveFF in (0,25,26,27)
  group by CLAVE,DESCRIPCION,IdClaveFF)as X
  group by CLAVE,DESCRIPCION,IdClaveFF
end
 
 End  
END  
	
Else if @Tipo=7   
BEGIN  
Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  

Declare @Anual7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  


Insert into @Anual7Aux  
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 
       ,--(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF 
	    case FF.IdClave 
		  when '25' then '25'
		  when '26' then '25'
		  when '27' then '25'
		  when '0' then '0'
		  else '11'
		  end as idclaveFF
	   ,(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado           
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS ,c_fuentefinanciamiento FF 
where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad,FF.IdClave
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

insert into @Anual7 
Select IdClave ,
Descripcion ,
Clave,
Descripcion2 ,
IdClave2, 
sum(isnull(Autorizado,0)) , 
sum(isnull(Amp_Red ,0)),
IdClaveFF ,
sum(isnull(Modificado,0))  
from @Anual7Aux
group by IdClave ,
Descripcion ,
Clave,
Descripcion2 ,
IdClave2,
IdClaveFF 

  
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

Declare @rpt7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int) 
  
insert into @rpt7Aux  
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
    ,case FF.IdClave 
		  when '25' then '25'
		  when '26' then '25'
		  when '27' then '25'
		  when '0' then '0'
		  else '11'
		  end as idclaveFF --(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF   
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS  ,C_FuenteFinanciamiento As FF 
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad ,FF.IdClave
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

  insert into @rpt7
   select IdClave,
   Descripcion,
   Clave ,
   Descripcion2 ,
   IdClave2 ,  
   Sum(isnull(Autorizado,0)) ,
    Sum(isnull(TransferenciaAmp,0)) ,
    Sum(isnull(TransferenciaRed,0))  ,
    Sum(isnull(Modificado,0))  ,
    Sum(isnull(Comprometido,0)) ,  
    Sum(isnull(Devengado,0))  ,
    Sum(isnull(Ejercido,0))  ,
    Sum(isnull(Pagado,0))  ,
    Sum(isnull(PresDispComp,0))  ,
    Sum(isnull(CompNoDev,0))  ,  
    Sum(isnull(PresSinDev,0))  ,
    Sum(isnull(Deuda,0))  ,
    Sum(isnull(Amp_Red,0))  ,
    Sum(isnull(SubEjercicio,0))  ,
   IdClaveFF
   from @rpt7Aux
   group by IdClave,
   Descripcion,
   Clave ,
   Descripcion2 ,
   IdClave2 ,
   IdClaveFF

insert into @rpt7  
select* from @Titulos7 t   
where t.Clave not in (select Clave from @rpt7)  

If @AmpRedAnual = 1  
 Begin  
	--update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red,r.Modificado=(a.Autorizado+r.Amp_Red) FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave and a.IdClaveFF in (0,25,26,27)--and a.IdClaveFF = r.IdClaveFF
  	update r set r.Autorizado = a.Autorizado,r.Modificado=(a.Autorizado+r.Amp_Red) FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave and a.IdClaveFF in (0,25,26,27)--and a.IdClaveFF = r.IdClaveFF
 End  
--ELse  
-- Begin  
--  update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave  
-- End  
 if @MuestraCeros = 0
		begin
		select * from @rpt7 where IdClaveFF in (25,26,27) Order by  IdClave , Clave, IdClave2  
		end
		else
		begin 
		select * from @rpt7 where IdClaveFF in (0,25,26,27) Order by  IdClave , Clave, IdClave2
		end
END  
END  
  go
EXEC SP_FirmasReporte 'Clasificacion por Objeto Gasto(Capitulo y Concepto)'  

go 

--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado @Mes=1,@Mes2=11,@Ejercicio=2017,@MuestraCeros=1,@Tipo=6
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado @Mes=12,@Mes2=12,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado @Mes=0,@Mes2=0,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7