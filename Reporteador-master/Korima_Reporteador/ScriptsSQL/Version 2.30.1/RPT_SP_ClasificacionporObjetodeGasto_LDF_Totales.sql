
/****** Object:  StoredProcedure [dbo].[RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales]    Script Date: 10/06/2017 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales]    Script Date: 10/06/2017 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales 1,4,2021,0,16,0,0,0
CREATE PROCEDURE  [dbo].[RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales]  
  @Mes  as int,   
  @Mes2 as int,    
  @Ejercicio as int,
  @MuestraCeros as int,
  @Tipo as int,
  @IdArea as int,
  @AprAnual as bit,
  @AmpRedAnual bit
AS  
BEGIN 

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
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave in (25,26,27)
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
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave  in (25,26,27)
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
	--select * from @rpt Order by  IdClave , Clave, IdClave2

END

IF @Tipo=6 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN 
Declare @Anual6_2 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual6_2
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
Declare @Titulos_2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos_2
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt_2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rpt_2
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

insert into @rpt_2
select* from @Titulos_2 t 
where t.Clave not in (select Clave from @rpt_2)

	If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual6_2 a, @rpt_2 r Where a.Clave = r.Clave
			--select * from @rpt_2 Order by  IdClave , Clave, IdClave2
		End
	If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual6_2 a, @rpt_2 r Where a.Clave = r.Clave
			--select * from @rpt_2 Order by  IdClave , Clave, IdClave2
		End
	--select * from @rpt_2 Order by  IdClave , Clave, IdClave2
END

If @Tipo = 6
BEGIN
	Insert into @rpt
	Select * from @rpt_2 Order by  IdClave , Clave, IdClave2

	Select * from @rpt Order by  IdClave , Clave, IdClave2
END


If @Tipo=16 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual16 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual16
Select CN.IdConcepto  as Clave, sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave in (25,26,27)
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
AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave  in (25,26,27)
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
			--select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End
	Else
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			--select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End

END 



If @Tipo=16 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual16_2 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual16_2
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
Declare @Titulos16_2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos16_2
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt16_2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))


Insert into @rpt16_2
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

insert into @rpt16_2
select* from @Titulos16_2 t 
where t.Clave not in (select Clave from @rpt16_2)


If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual16_2 a, @rpt16_2 r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16_2 a, @rpt16_2 r Where a.Clave = r.Clave
			--select * from @rpt16_2 Order by  IdClave , Clave, IdClave2
		End
	Else
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16_2 a, @rpt16_2 r Where a.Clave = r.Clave
			--select * from @rpt16_2 Order by  IdClave , Clave, IdClave2
		End



END

If @Tipo = 16
BEGIN
	Insert into @rpt16
	Select * from @rpt16_2 Order by  IdClave , Clave, IdClave2

	Select * from @rpt16 Order by  IdClave , Clave, IdClave2
END

END

Exec SP_CFG_LogScripts 'RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales','2.30.1'
GO