

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]    Script Date: 10/06/2017 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]    Script Date: 10/06/2013 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado 0, 1,3,6,2020,0,0,0
CREATE PROCEDURE  [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]  
  --@Mes  as int,   
  --@Mes2 as int,    
  --@Ejercicio as int,
 @MuestraCeros as int = 0,
  --@Tipo as int

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
--@ClaveFF as varchar(10),
@IdArea as int,
@AprAnual as bit,
@AmpRedAnual bit

AS  
BEGIN  
  

-- declare @IdArea as int,  
--@AmpRedAnual int
 --select @IdArea=0
 --select @AmpRedAnual=1

--If @Tipo = 6
--	 begin
--	Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2),IdClaveFF int)  
--	Insert into @Anual6  
--	Select CN.IdConcepto  as Clave,   
--	sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red  
--	,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
--	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG  
--	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
--	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
--	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo  ,TS.IDFUENTEFINANCIAMIENTO
--	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

--	--Tabla de titulos   
--	Declare @Titulos as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
--	INSERT INTO @Titulos  
--	SELECT CG.IdCapitulo as IdClave,   
--	CG.Descripcion as Descripcion,   
--	CN.IdConcepto  as Clave,   
--	CN.Descripcion as Descripcion2,   
--	CN.IdCapitulo as IdClave2,   
--	0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado,   
--	0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio   ,0 as IdClaveFF
--	From  C_ConceptosNEP As CN, C_CapitulosNEP As CG  
--	WHERE CG.IdCapitulo = CN.IdCapitulo  


--	Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  

--	Insert into @rpt  
--	--VALORES ABSOLUTOS  
--	--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **  
--	Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,  
  
--	sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
   
--	sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--	sum(ISNULL(TP.Devengado,0)) as Devengado,   
--	sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--	sum(ISNULL(TP.Pagado,0)) as Pagado,   
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--	sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--	sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--	sum(ISNULL(TP.Devengado,0))as SubEjercicio,
--	(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
--	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG 
--	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
--	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
--	Group by  CG.IdCapitulo,CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,TS.IdFuenteFinanciamiento
--	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

--	insert into @rpt  
--	select* from @Titulos t   
--	where t.Clave not in (select Clave from @rpt)  


--	 If @AmpRedAnual = 1  
--	  Begin  
--	   update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  and a.IdClaveFF=r.IdClaveFF
--		if @MuestraCeros = 0
--		begin
--		select * from @rpt where IdClaveFF in (11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--	   else
--	   begin 
--	   select * from @rpt where IdClaveFF in (0,11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--	   end
--	  End  
--	 --Else  
--	 -- Begin  
--	 --  update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  
--	 --  select * from @rpt Order by  IdClave , Clave, IdClave2  
--	 -- End  
--	 end
IF @Tipo=6 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN 
Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual6
Select CN.IdConcepto  as Clave, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt
select* from @Titulos t 
where t.Clave not in (select Clave from @rpt)

	If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
	If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
	select * from @rpt Order by  IdClave , Clave, IdClave2
END

Else if @Tipo=16 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual16 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual16
Select CN.IdConcepto  as Clave, sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo
--Tabla de titulos 
Declare @Titulos16 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos16
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt16 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rpt16
--VALORES RELATIVOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt16
select* from @Titulos16 t 
where t.Clave not in (select Clave from @rpt16)


If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End
	Else
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End



END

--Else if @Tipo=2   
--BEGIN  
--declare @Anual2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
--Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
--Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
--Insert into @Anual2  
--Select CR.CLAVE, CR.Nombre,  
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
--sum(ISNULL(0,0)) as Comprometido,   
--sum(ISNULL(0,0)) as Devengado,   
--sum(ISNULL(0,0)) as Ejercido,  
--sum(ISNULL(0,0)) as Pagado,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0)))) - sum(ISNULL(0,0)) As PresDispComp,  
--sum(ISNULL(0,0)) - sum(ISNULL(0,0)) AS CompNoDev,  
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))- sum(ISNULL(0,0))  AS PresSinDev,  
--sum(ISNULL(0,0)) -  sum(ISNULL(0,0)) AS Deuda,  
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) -   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as Amp_Red,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))-  
--sum(ISNULL(0,0)) as SubEjercicio 
--, case FF.IdClave 
--		  when '11' then '11'
--          when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF 
--From T_SellosPresupuestales As TS 
--left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
--left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
--left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--Where (TP.Mes BETWEEN  1 AND 12) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
--group by FF.IdClave,CR.Clave,CR.Nombre
--Order By CR.CLAVE 
----VALORES ABSOLUTOS  
  
--declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
--Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
--Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
--Insert into @rptt  
--Select CR.CLAVE, CR.Nombre,  
--sum(ISNULL(0,0)) as Autorizado,   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaAmp,   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaRed,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))as Modificado,  
--sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--sum(ISNULL(TP.Devengado,0)) as Devengado,   
--sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--sum(ISNULL(TP.Pagado,0)) as Pagado,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--sum(ISNULL(TP.Devengado,0)) as SubEjercicio 
--, case FF.IdClave 
--		  when '11' then '11'
--          when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF 
--From T_SellosPresupuestales As TS 
--left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
--left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
--left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--Where (TP.Mes BETWEEN  @Mes AND @Mes2) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
--group by FF.IdClave,CR.Clave,CR.Nombre
--Order By CR.CLAVE 
  
--If @AmpRedAnual = 1  
-- Begin  
-- if @MuestraCeros = 0
-- begin
--  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
--  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
--  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @Anual2  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF
--   union 
--  Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @rptt  
--  where IdClaveFF in (11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF)as X
--  group by CLAVE,DESCRIPCION,IdClaveFF
--end
--else
--begin 
--  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
--  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
--  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @Anual2  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF
--   union 
--   	Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @rptt  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF)as X
--  group by CLAVE,DESCRIPCION,IdClaveFF
--end
 
-- End  
--END  

Else if @Tipo=2 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
declare @Anual2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE
--VALORES ABSOLUTOS

declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual2 a
		LEFT JOIN @rptt r
		ON a.CLAVE = r.CLAVE
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual2 a
		LEFT JOIN @rptt r
		ON a.CLAVE = r.CLAVE
	End
END

Else if @Tipo=12 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
declare @Anual12 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @Anual12
Select CR.CLAVE, CR.Nombre,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE
--VALORES RELATIVOS
--Consulta para Reporte Ramo o Dependencia Estado del Ejercicio del Presupuesto
declare @rptt12 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rptt12
Select CR.CLAVE, CR.Nombre,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual12 a
		LEFT JOIN @rptt12 r
		ON a.CLAVE = r.CLAVE
	End
	Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual12 a
		LEFT JOIN @rptt12 r
		ON a.CLAVE = r.CLAVE
	End
END

Else if @Tipo=7 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual7
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes = 0)	 AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

Declare @Titulos7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos7
SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,
0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
FROM C_funciones As CF, C_Finalidades As CFS
WHERE CF.IdFinalidad = CFS.IdFinalidad 
GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad 

Declare @rpt7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

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


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2)	 AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

insert into @rpt7
select* from @Titulos7 t 
where t.Clave not in (select Clave from @rpt7)

If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave
	End
If @AmpRedAnual = 1
	Begin
		update r set r.Amp_Red = a.Amp_Red FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave
	End
select * from @rpt7 Order by  IdClave , Clave, IdClave2
END

Else if @Tipo=17 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual17
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
 sum(ISNULL(TP.Autorizado,0)) as Autorizado,
 (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

declare @Titulos17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos17
SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,
0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
FROM C_funciones As CF, C_Finalidades As CFS
WHERE CF.IdFinalidad = CFS.IdFinalidad 
GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad 

Declare @rpt17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

insert into @rpt17
--VALORES RELATIVOS 
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  ***
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) )As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

insert into @rpt17
select* from @Titulos17 t 
where t.Clave not in (select Clave from @rpt17)


If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
	End

If @AmpRedAnual = 1
	Begin
		update r set r.Amp_Red = a.Amp_Red FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
	End

--Else
--	Begin
--		update r set r.Autorizado = a.Autorizado FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
--	End

select * from @rpt17 Order by  IdClave , Clave, IdClave2

END
	
--Else if @Tipo=7   
--BEGIN  
--Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  

--Declare @Anual7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  


--Insert into @Anual7Aux  
--Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 
--       ,--(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF 
--	    case FF.IdClave 
--		     when '11' then '11'
--                  when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF
--	   ,(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado           
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS ,c_fuentefinanciamiento FF 
--where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
--AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad,FF.IdClave
--Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

--insert into @Anual7 
--Select IdClave ,
--Descripcion ,
--Clave,
--Descripcion2 ,
--IdClave2, 
--sum(isnull(Autorizado,0)) , 
--sum(isnull(Amp_Red ,0)),
--IdClaveFF ,
--sum(isnull(Modificado,0))  
--from @Anual7Aux
--group by IdClave ,
--Descripcion ,
--Clave,
--Descripcion2 ,
--IdClave2,
--IdClaveFF 

  
--Declare @Titulos7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
--INSERT INTO @Titulos7  
--SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,  
--0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio  , 0 as IdClaveFF 
--FROM C_funciones As CF, C_Finalidades As CFS  
--WHERE CF.IdFinalidad = CFS.IdFinalidad   
--GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad   
--ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  
--Declare @rpt7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  

--Declare @rpt7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int) 
  
--insert into @rpt7Aux  
----VALORES ABSOLUTOS   
----Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **  
--Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
--sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--sum(ISNULL(TP.Devengado,0)) as Devengado,   
--sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--sum(ISNULL(TP.Pagado,0)) as Pagado,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
----(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
----(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
----sum(ISNULL(TP.Comprometido,0)) as SubEjercicio   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--sum(ISNULL(TP.Devengado,0)) as SubEjercicio   
--    ,case FF.IdClave 
--                  when '11' then '11'
--                  when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF --(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF   
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS  ,C_FuenteFinanciamiento As FF 
--where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
--AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--group by CF.Clave,CF.Nombre,FF.IdClave,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
--Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  

--  insert into @rpt7
--   select IdClave,
--   Descripcion,
--   Clave ,
--   Descripcion2 ,
--   IdClave2 ,  
--   Sum(isnull(Autorizado,0)) ,
--    Sum(isnull(TransferenciaAmp,0)) ,
--    Sum(isnull(TransferenciaRed,0))  ,
--    Sum(isnull(Modificado,0))  ,
--    Sum(isnull(Comprometido,0)) ,  
--    Sum(isnull(Devengado,0))  ,
--    Sum(isnull(Ejercido,0))  ,
--    Sum(isnull(Pagado,0))  ,
--    Sum(isnull(PresDispComp,0))  ,
--    Sum(isnull(CompNoDev,0))  ,  
--    Sum(isnull(PresSinDev,0))  ,
--    Sum(isnull(Deuda,0))  ,
--    Sum(isnull(Amp_Red,0))  ,
--    Sum(isnull(SubEjercicio,0))  ,
--   IdClaveFF
--   from @rpt7Aux
--   group by IdClave,
--   Descripcion,
--   Clave ,
--   Descripcion2 ,
--   IdClave2 ,
--   IdClaveFF

--insert into @rpt7  
--select* from @Titulos7 t   
--where t.Clave not in (select Clave from @rpt7)  
  
--If @AmpRedAnual = 1  
-- Begin  
--	update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red,r.Modificado=(a.Autorizado+r.Amp_Red) FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave and a.IdClaveFF in (0,11,12,13,14,15,16,17)--and a.IdClaveFF = r.IdClaveFF
-- End  
----ELse  
---- Begin  
----  update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave  
---- End  
-- if @MuestraCeros = 0
--		begin
--		select * from @rpt7 where IdClaveFF in (11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--		else
--		begin 
--		select * from @rpt7 where IdClaveFF in (0,11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--END  
END  
GO

EXEC SP_FirmasReporte 'LDF Clasificación por Objeto Gasto(Capitulo y Concepto)'  
GO
EXEC SP_FirmasReporte 'LDF Clasificación Administrativa'  
GO
EXEC SP_FirmasReporte 'LDF Clasificación Funcional (Finalidad Y Función)'  
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado','2.31'
GO
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado @Mes=9,@Mes2=9,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado @Mes=0,@Mes2=0,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7