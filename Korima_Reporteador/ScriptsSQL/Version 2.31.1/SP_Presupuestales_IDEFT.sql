/****** Object:  StoredProcedure [dbo].[SP_Presupuestales_IDEFT]    Script Date: 11/26/2012 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Presupuestales_IDEFT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Presupuestales_IDEFT]
GO
/******** Object:  StoredProcedure [dbo].[SP_Presupuestales_IDEFT]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_Presupuestales_IDEFT 1,12,5,2021,0,0,"'15399','1551041B','1111041B','1525'"
CREATE PROCEDURE [dbo].[SP_Presupuestales_IDEFT] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
--@ClaveFF as varchar(10),
--@IdArea as int,
@AprAnual as bit,
@AmpRedAnual bit,
@CadenaFF varchar(max)


AS
BEGIN


 IF @Tipo= 1 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar en la sección LDF (Ley Disciplina Financiera)
BEGIN

CREATE TABLE #Anual1 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual1 nvarchar(max),
 @sqlRpt1 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual1 =
'Select CR.CLAVE, CR.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.CLAVE, CR.Descripcion ' +
'Order By CR.CLAVE ' 

Insert Into #Anual1
EXEC (@sqlAnual1)


CREATE TABLE #rpt1 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt1 =
'Select CR.CLAVE, CR.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.CLAVE, CR.Descripcion ' +
'Order By CR.CLAVE ' 

Insert Into #rpt1
EXEC (@sqlRpt1)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual1 a
		LEFT JOIN #rpt1 r
		ON a.CLAVE = r.CLAVE
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual1 a
		LEFT JOIN #rpt1 r
		ON a.CLAVE = r.CLAVE
	End

	DROP TABLE #Anual1
	DROP TABLE #rpt1

END


 IF @Tipo= 2 
BEGIN

CREATE TABLE #Anual2 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual2 nvarchar(max),
 @sqlRpt2 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual2 =
'Select CG.IdCapitulo, CG.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
--'LEFT JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CG.IdCapitulo, CG.Descripcion ' +
'Order By CG.IdCapitulo ' 

Insert Into #Anual2
EXEC (@sqlAnual2)


CREATE TABLE #rpt2 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt2 =
'Select CG.IdCapitulo, CG.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
--'LEFT JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CG.IdCapitulo, CG.Descripcion ' +
'Order By CG.IdCapitulo '  

Insert Into #rpt2
EXEC (@sqlRpt2)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual2 a
		LEFT JOIN #rpt2 r
		ON a.CLAVE = r.CLAVE
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual2 a
		LEFT JOIN #rpt2 r
		ON a.CLAVE = r.CLAVE
	End

	DROP TABLE #Anual2
	DROP TABLE #rpt2

END
    
IF @Tipo= 3 
BEGIN

CREATE TABLE #Anual3 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual3 nvarchar(max),
 @sqlRpt3 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual3 =
'Select FF.CLAVE, FF.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by FF.CLAVE, FF.Descripcion ' +
'Order By FF.CLAVE ' 

Insert Into #Anual3
EXEC (@sqlAnual3)


CREATE TABLE #rpt3 (CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt3 =
'Select FF.CLAVE, FF.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by FF.CLAVE, FF.Descripcion ' +
'Order By FF.CLAVE ' 

Insert Into #rpt3
EXEC (@sqlRpt3)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual3 a
		LEFT JOIN #rpt3 r
		ON a.CLAVE = r.CLAVE
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual3 a
		LEFT JOIN #rpt3 r
		ON a.CLAVE = r.CLAVE
	End

	DROP TABLE #Anual3
	DROP TABLE #rpt3

END

IF @Tipo= 4
BEGIN

CREATE TABLE #Anual4 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual4 nvarchar(max),
 @sqlRpt4 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual4 =
'Select CR.Clave, CR.Descripcion, CG.IdCapitulo, CG.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CR.Descripcion, CG.IdCapitulo, CG.Descripcion  ' +
'Order By CR.Clave, CG.IdCapitulo  ' 

Insert Into #Anual4
EXEC (@sqlAnual4)


CREATE TABLE #rpt4 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt4 =
'Select CR.Clave, CR.Descripcion, CG.IdCapitulo, CG.Descripcion, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CR.Descripcion, CG.IdCapitulo, CG.Descripcion  ' +
'Order By CR.Clave, CG.IdCapitulo  '  

Insert Into #rpt4
EXEC (@sqlRpt4)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual4 a
		LEFT JOIN #rpt4 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual4 a
		LEFT JOIN #rpt4 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End

	DROP TABLE #Anual4
	DROP TABLE #rpt4

END

IF @Tipo= 5
BEGIN

CREATE TABLE #Anual5 (CLAVE varchar(100), CLAVE2 varchar(100), CLAVE3 varchar(100), CLAVE4 varchar(100), DESCRIPCION varchar(max),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual5 nvarchar(max),
 @sqlRpt5 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual5 =
'Select CR.Clave, CU.Clave, CP.IdPartida, CT.Clave, CP.DescripcionPartida, CU.Nombre,   ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'JOIN C_NivelAdicional3 As CT ON CT.IdNivelAdicional3 = TS.IdNivelAdicional3 ' +
'LEFT JOIN C_AreaResponsabilidad As CU ON CU.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
--'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
--'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CU.Clave, CP.IdPartida, CT.Clave, CP.DescripcionPartida, CU.Nombre  ' +
'Order By CR.Clave, CU.Clave, CP.IdPartida   '   

Insert Into #Anual5
EXEC (@sqlAnual5)


CREATE TABLE #rpt5 (CLAVE varchar(100), CLAVE2 varchar(100), CLAVE3 varchar(100), CLAVE4 varchar(100), DESCRIPCION varchar(max),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt5 =
'Select CR.Clave, CU.Clave, CP.IdPartida, CT.Clave, CP.DescripcionPartida, CU.Nombre,   ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'JOIN C_NivelAdicional3 As CT ON CT.IdNivelAdicional3 = TS.IdNivelAdicional3 ' +
'LEFT JOIN C_AreaResponsabilidad As CU ON CU.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
--'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
--'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CU.Clave, CP.IdPartida, CT.Clave, CP.DescripcionPartida, CU.Nombre  ' +
'Order By CR.Clave, CU.Clave, CP.IdPartida   '   

Insert Into #rpt5
EXEC (@sqlRpt5)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		a.CLAVE3,
		a.CLAVE4,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual5 a
		LEFT JOIN #rpt5 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2 and a.CLAVE3 = r.CLAVE3 and a.CLAVE4 = r.CLAVE4
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		a.CLAVE3,
		a.CLAVE4,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual5 a
		LEFT JOIN #rpt5 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2 and a.CLAVE3 = r.CLAVE3 and a.CLAVE4 = r.CLAVE4
	End

	DROP TABLE #Anual5
	DROP TABLE #rpt5

END

IF @Tipo= 6
BEGIN

CREATE TABLE #Anual6 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual6 nvarchar(max),
 @sqlRpt6 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual6 =
'Select CR.Clave, CR.Descripcion, CU.Clave, CU.Nombre, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_AreaResponsabilidad As CU ON CU.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CR.Descripcion, CU.Clave, CU.Nombre  ' +
'Order By CR.Clave, CU.Clave  ' 

Insert Into #Anual6
EXEC (@sqlAnual6)


CREATE TABLE #rpt6 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt6 =
'Select CR.Clave, CR.Descripcion, CU.Clave, CU.Nombre, ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
'JOIN C_NivelAdicional1 As CR ON CR.IdNivelAdicional1 = TS.IdNivelAdicional1 ' +
'LEFT JOIN C_AreaResponsabilidad As CU ON CU.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CR.Clave, CR.Descripcion, CU.Clave, CU.Nombre  ' +
'Order By CR.Clave, CU.Clave   '  

Insert Into #rpt6
EXEC (@sqlRpt6)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual6 a
		LEFT JOIN #rpt6 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual6 a
		LEFT JOIN #rpt6 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End

	DROP TABLE #Anual6
	DROP TABLE #rpt6

END

IF @Tipo= 7
BEGIN

CREATE TABLE #Anual7 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4), EjPag  decimal(18,4),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

DECLARE @sqlAnual7 nvarchar(max),
 @sqlRpt7 nvarchar(max)

--Insert into @Anual1
SET @sqlAnual7 =
'Select CP.IdPartida, CP.DescripcionPartida, CG.IdCapitulo, CG.Descripcion,  ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
--'LEFT JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'where  (Mes BETWEEN  1 AND 12)  ' +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CP.IdPartida, CP.DescripcionPartida, CG.IdCapitulo, CG.Descripcion  ' +
'Order By CP.IdPartida,CG.IdCapitulo   ' 

Insert Into #Anual7
EXEC (@sqlAnual7)


CREATE TABLE #rpt7 (CLAVE varchar(100),DESCRIPCION varchar(max), CLAVE2 varchar(100),DESCRIPCION2 varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4), Modificado  decimal(18,4), Comprometido  decimal(18,4), Devengado  decimal(18,4),
Ejercido  decimal(18,4), Pagado decimal(18,4), EjPag decimal (18,2),
--PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),
Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Set @sqlRpt7 =
'Select CP.IdPartida, CP.DescripcionPartida, CG.IdCapitulo, CG.Descripcion,  ' +

'sum(ISNULL(TP.Autorizado,0)) as Autorizado, ' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado, ' +
 
'sum(ISNULL(TP.Comprometido,0)) as Comprometido, ' +
'sum(ISNULL(TP.Devengado,0)) as Devengado, ' +
'sum(ISNULL(TP.Ejercido,0)) as Ejercido, ' +
'sum(ISNULL(TP.Pagado,0)) as Pagado, ' + 

'sum(ISNULL(TP.Ejercido,0)) +' +
'sum(ISNULL(TP.Pagado,0)) as EjPag,' +
'(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - ' +
'(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, ' +
'(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- ' +
'sum(ISNULL(TP.Devengado,0)) as SubEjercicio ' +

'From T_PresupuestoNW As TP JOIN  T_SellosPresupuestales As TS  ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  ' +
--'LEFT JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp ' +
'LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida ' +
'LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto ' +
'LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo ' +
'LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO ' +

'Where ' +
' Mes >=  ' + Convert(nvarchar(20),@Mes) + ' and Mes <= ' + Convert(nvarchar(20),@Mes2) +
'and LYear =  ' + Convert(nvarchar(20),@Ejercicio) + ' and Year = ' + Convert(nvarchar(20),@Ejercicio) +
'AND  FF.Clave in (' + @CadenaFF + ') ' +

'group by CP.IdPartida, CP.DescripcionPartida, CG.IdCapitulo, CG.Descripcion  ' +
'Order By CP.IdPartida,CG.IdCapitulo   '   

Insert Into #rpt7
EXEC (@sqlRpt7)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual7 a
		LEFT JOIN #rpt7 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		a.CLAVE2,a.DESCRIPCION2,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,
		--isnull(r.Modificado,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(r.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(r.Autorizado,0) + ISNULL(r.Amp_Red,0) 
		END as Modificado,
		isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado, isnull(r.EjPag,0) as EjPag,
		--isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from #Anual7 a
		LEFT JOIN #rpt7 r
		ON a.CLAVE = r.CLAVE and a.CLAVE2 = r.CLAVE2
	End

	DROP TABLE #Anual7
	DROP TABLE #rpt7

END


-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
 
END

GO

EXEC SP_FirmasReporte 'IDEFT Presupuestales'
GO


--Exec SP_RPT_EstadoEjercicioPresupuestoEGR 6,1,21,2015,''

