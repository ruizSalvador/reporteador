/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]    Script Date: 07/22/2013 15:39:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]    Script Date: 07/22/2013 15:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(8),
@ClaveUR as varchar(8),
@ClaveP as varchar(8)

AS
BEGIN

If @Tipo=1 
BEGIN

--VALORES ABSOLUTOS
--Consulta Estado del Ejercicio del Presupuesto 

If @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP <> '' 
begin

Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP = 0 
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP = 0 
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF <> '' and @ClaveUR = 0   and @ClaveP  <> ''
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and cp.clavepartida=@ClaveP
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP = 0 
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP  <> ''
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR = 0   and @ClaveP <> '' 
begin
Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and cp.clavepartida=@ClaveP
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP = 0 
begin

Select TP.IdSelloPresupuestal , TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,  
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) as PreComprometido,
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end
END




If @Tipo=2 
BEGIN

--VALORES RELATIVOS
--Consulta Estado del Ejercicio del Presupuesto

If @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP <> '' 
begin

Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and CP.clavepartida=@ClaveP
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP = 0 
begin

Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP = 0 
begin
Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end


else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP <> ''
begin
Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,  
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CP.ClavePartida=@ClaveP 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP = 0
begin
Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP <> ''
begin
Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR  and CP.ClavePartida=@ClaveP 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP <> '' 
begin

Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CP.clavepartida=@ClaveP
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end


else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP = 0 
begin

Select TP.IdSelloPresupuestal, TS.Sello, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
sum(ISNULL(TP.Ampliaciones,0)) as Ampliaciones,
sum(ISNULL(TP.Reducciones,0)) as Reducciones,
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
sum(ISNULL(TP.TransferenciaAmp,0)) as TransferenciaAmp, 
sum(ISNULL(TP.TransferenciaRed,0)) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Precomprometido,0)) As Precomprometido,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

END

END

