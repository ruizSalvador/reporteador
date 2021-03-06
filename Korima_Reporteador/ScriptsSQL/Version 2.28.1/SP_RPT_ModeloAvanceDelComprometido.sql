IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ModeloAvanceDelComprometido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ModeloAvanceDelComprometido]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ModeloAvanceDelComprometido]    Script Date: 28/01/2019 09:33:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_ModeloAvanceDelComprometido 1,12,2,2019,11301,'','','','',''
CREATE PROCEDURE [dbo].[SP_RPT_ModeloAvanceDelComprometido] 

@Mes  as int, 
@Mes2 as int,  
--@Tipo as int,
@Ejercicio as int,
@ClaveP as int,
@ClaveFF as int,
@ClaveFF2 as int,
@ClaveUR as int,
@ClaveUR2 as int,
@IdEP as int

AS
BEGIN

Declare @rpt as table(Proy varchar(max),FF varchar(max),TP varchar(max),PE Varchar(max),DescripcionPE Varchar(max),
IdClaveCap int, DescripcionCap Varchar(max),Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),
TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),Disponible decimal(18,4))
Insert into @rpt

--VALORES ABSOLUTOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **

Select CEPR.Clave as 'Proy.', CF.Clave as 'FF', CNA3.Clave as 'TP', CG.IdCapitulo as 'PE', CG.Descripcion as DescripcionPE, 
CP.IdPartida as IdClaveCap, CP.DescripcionPartida  as DescripcionCap,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0))as Disponible
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG,
C_PartidasGenericasPres, C_FuenteFinanciamiento CF, C_EP_Ramo CEPR, C_AreaResponsabilidad CAR, C_NivelAdicional3 CNA3
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
and CP.IdPartidaGenerica=C_PartidasGenericasPres.IdPartidaGenerica AND TS.IdFuenteFinanciamiento = CF.IDFUENTEFINANCIAMIENTO AND CEPR.Id = TS.IdProyecto AND CAR.IdAreaResp = TS.IdAreaResp
AND CEPR.Id = CASE WHEN @IdEP = '' THEN CEPR.id ELSE @IdEP END
AND CP.ClavePartida = CASE WHEN @ClaveP = '' THEN CP.ClavePartida ELSE @ClaveP END
AND CF.IdFuenteFinanciamiento Between (CASE WHEN @ClaveFF = '' THEN CAR.Clave ELSE @ClaveFF END) and (CASE WHEN @ClaveFF2 = '' THEN CAR.Clave ELSE @ClaveFF2 END)
AND CAR.IdAreaResp Between (CASE WHEN @ClaveUR = '' THEN CAR.IdAreaResp ELSE @ClaveUR END) and (CASE WHEN @ClaveUR2 = '' THEN CAR.IdAreaResp ELSE @ClaveUR2 END)
AND TS.IdNivelAdicional3 = CNA3.IdNivelAdicional3

Group by  CEPR.Clave, CF.Clave, CNA3.Clave, CG.IdCapitulo, CG.Descripcion,CP.DescripcionPartida, CP.IdPartida
Order by  CG.IdCapitulo, CP.IdPartida

	
	SELECT * FROM @rpt

END

Exec SP_FirmasReporte 'Modelo Avance del Comprometido'
GO

