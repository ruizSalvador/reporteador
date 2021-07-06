/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]    Script Date: 07/22/2013 15:39:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto]    Script Date: 07/22/2013 15:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto 1,12,1,2020,'','','','',1,1,1
CREATE PROCEDURE [dbo].[SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(8),  
@ClaveUR as varchar(15),  
@ClaveP as varchar(60),
@ClaveProg varchar(20),
@AprAnual as int,
@AmpRedAnual as bit,
@TransfAnual as bit
  
AS
BEGIN

declare @Anual1 as table(IdSelloPresupuestal int, Sello varchar(max), 
	Autorizado decimal(18,2), 
	Ampliaciones decimal(18,2),
	Reducciones decimal(18,2), 
	TransferenciaAmp decimal(18,2),
	TransferenciaRed decimal(18,2),
	Modificado decimal(18,2),
	PreComprometido decimal(18,2),
	Comprometido decimal(18,2),
	Devengado decimal(18,2),
	Ejercido decimal(18,2),
	Pagado decimal(18,2),
	PresDispComp decimal(18,2),
	Recalendarizaciones decimal(18,2)
)

declare @Todo1 as table(IdSelloPresupuestal int, Sello varchar(max),
Autorizado decimal(18,4), Ampliaciones decimal(18,4), Reducciones decimal(18,4),TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4), PreComprometido decimal(18,4), Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4), Recalendarizaciones decimal(18,2))


If @Tipo=1 
BEGIN

--VALORES ABSOLUTOS
--Consulta Estado del Ejercicio del Presupuesto 

If @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP <> '' 
begin

--*******Anual*************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
C_EP_Ramo  CEPR
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*************************************************
Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP = 0 
begin
--***************Anual******************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP
LEFT JOIN @Anual1 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA, 
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
Order By TP.IdSelloPresupuestal
--**************************************************************
Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF 
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP = 0 
begin
--***************Anual*******************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
  C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
  C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF <> '' and @ClaveUR = 0   and @ClaveP  <> ''
begin
--*****************Anual*****************************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP
LEFT JOIN @Anual1 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto

group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
Order By TP.IdSelloPresupuestal

--***************************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
  C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP = 0 
begin
--*********************************Anual****************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP
LEFT JOIN @Anual1 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
C_EP_Ramo  CEPR
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
Order By TP.IdSelloPresupuestal
--******************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP
LEFT JOIN @Anual1 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP  <> ''
begin
--*******************Anual*****************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*****************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and CA.Clave=@ClaveUR and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR = 0   and @ClaveP <> '' 
begin
--****************Anual***************************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--***********************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and cp.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end

else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP = 0 
begin
--*****************************************Anual*************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto 
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--***********************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as CP, c_arearesponsabilidad as CA,
 C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
end
END




If @Tipo=2 
BEGIN

--declare @Anual2 as table(IdSelloPresupuestal int, Sello varchar(max), 
--	Autorizado decimal(18,2), 
--	Ampliaciones decimal(18,2),
--	Reducciones decimal(18,2), 
--	TransferenciaAmp decimal(18,2),
--	TransferenciaRed decimal(18,2),
--	Modificado decimal(18,2),
--	PreComprometido decimal(18,2),
--	Comprometido decimal(18,2),
--	Devengado decimal(18,2),
--	Ejercido decimal(18,2),
--	Pagado decimal(18,2),
--	PresDispComp decimal(18,2)
--)


--VALORES RELATIVOS
--Consulta Estado del Ejercicio del Presupuesto

If @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP <> '' 
begin

--************************************Anual***********************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and CP.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--****************************************************************************

Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR and CP.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP = 0 
begin
--***********************************Anual*********************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF 
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*************************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF <> '' and @ClaveUR <> ''  and @ClaveP = 0 
begin
--************************Anual**************************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

--*******************************************************************************

Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones
From T_PresupuestoNW As TP,
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end


else if @ClaveFF <> '' and @ClaveUR = 0  and @ClaveP <> ''
begin
--*************************Anual*************************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones
From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CP.ClavePartida=@ClaveP 
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*******************************************************************************
Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CF.CLAVE = @ClaveFF and CP.ClavePartida=@ClaveP 
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP = 0
begin
--************************Anual****************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

--*********************************************************************

Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR 
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR <> ''  and @ClaveP <> ''
begin
--***************************Anual*****************************************
Insert into @Anual1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR  and CP.ClavePartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*************************************************************************

Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CA.Clave=@ClaveUR  and CP.ClavePartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP <> '' 
begin
--************************Anual**************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and CP.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--*******************************************************************

Insert into @Todo1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones

From T_PresupuestoNW As TP,
 T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
 C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and CP.clavepartida=@ClaveP
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end 
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end


else if @ClaveFF = 0 and @ClaveUR = 0  and @ClaveP = 0 
begin
--******************Anual1****************************************
Insert into @Anual1
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

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0),0) as Recalendarizaciones

From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal
--****************************************************************
--Select * from @Anual1

Insert into @Todo1
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


(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
ISNULL((Select SUM(Importe) from T_MovimientosPresupuesto Where IdSelloPresupuestalOrigen = IdSelloPresupuestalDestino and IdSelloPresupuestalOrigen= TP.IdSelloPresupuestal and T_MovimientosPresupuesto.Estatus='A' and Ejercidio=@Ejercicio and IdSelloPresupuestalOrigen <>0 and (MedDestino Between @Mes and @Mes2)),0) as Recalendarizaciones


From T_PresupuestoNW As TP, 
T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, c_partidaspres as cp, c_arearesponsabilidad as ca,
C_EP_Ramo  CEPR
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio
AND CEPR.CLAVE =CASE WHEN @ClaveProg = '' THEN CEPR.CLAVE else @ClaveProg end  
AND TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
AND TS.idpartida = CP.idpartida
AND CA.idarearesp = TS.idarearesp
AND CEPR.Id = TS.IdProyecto
group by TP.IdSelloPresupuestal, TS.Sello
Order By TP.IdSelloPresupuestal

end

END
	IF @AprAnual = 1
	BEGIN
		Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(A.Autorizado,0) as Autorizado, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Ampliaciones,0)
		ELSE isnull(T.Ampliaciones,0) 
		END as Ampliaciones, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Reducciones,0)
		ELSE isnull(T.Reducciones,0) 
		END as Reducciones,
		CASE @TransfAnual
		WHEN 1 THEN isnull(A.TransferenciaAmp,0)
		ELSE isnull(T.TransferenciaAmp,0) 
		END as TransferenciaAmp,
		--ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed,
		CASE @TransfAnual
		WHEN 1 THEN isnull(A.TransferenciaRed,0)
		ELSE isnull(T.TransferenciaRed,0) 
		END as TransferenciaRed,
		CASE @AmpRedAnual
		WHEN 1 THEN 
			CASE @TransfAnual WHEN 1 THEN (ISNULL(A.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(A.TransferenciaRed,0)))
			ELSE (ISNULL(A.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(T.TransferenciaRed,0)))
			END
		ELSE
			CASE @TransfAnual WHEN 1 THEN (ISNULL(A.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) 
			ELSE (ISNULL(A.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) 
			END
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, 
		ISNULL(T.Pagado,0) as Pagado, 
		--ISNULL(T.PresDispComp,0) as PresDispComp
		CASE @AmpRedAnual
		WHEN 1 THEN 
			CASE @TransfAnual WHEN 1 THEN (ISNULL(A.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			ELSE (ISNULL(A.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			END
		ELSE
			CASE @TransfAnual WHEN 1 THEN (ISNULL(A.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			ELSE (ISNULL(A.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			END
		END as PresDispComp,
		T.Recalendarizaciones
		FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
	END
	ELSE
	BEGIN
		Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(T.Autorizado,0) as Autorizado, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Ampliaciones,0)
		ELSE isnull(T.Ampliaciones,0) 
		END as Ampliaciones, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Reducciones,0)
		ELSE isnull(T.Reducciones,0) 
		END as Reducciones,
		CASE @TransfAnual
		WHEN 1 THEN isnull(A.TransferenciaAmp,0)
		ELSE isnull(T.TransferenciaAmp,0) 
		END as TransferenciaAmp,
		--ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed,
		CASE @TransfAnual
		WHEN 1 THEN isnull(A.TransferenciaRed,0)
		ELSE isnull(T.TransferenciaRed,0) 
		END as TransferenciaRed,
		CASE @AmpRedAnual
		WHEN 1 THEN 
			CASE @TransfAnual WHEN 1 THEN (ISNULL(T.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) 
			ELSE (ISNULL(T.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) 
			END
		ELSE
			CASE @TransfAnual WHEN 1 THEN (ISNULL(T.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) 
			ELSE (ISNULL(T.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) 
			END
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, 
		ISNULL(T.Pagado,0) as Pagado, 
		--ISNULL(T.PresDispComp,0) as PresDispComp
		CASE @AmpRedAnual
		WHEN 1 THEN 
			CASE @TransfAnual WHEN 1 THEN (ISNULL(T.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			ELSE (ISNULL(T.Autorizado,0) + (ISNULL(A.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(A.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			END
		ELSE
			CASE @TransfAnual WHEN 1 THEN (ISNULL(T.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(A.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(A.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			ELSE (ISNULL(T.Autorizado,0) + (ISNULL(T.Ampliaciones,0) + ISNULL(T.TransferenciaAmp,0)) - (ISNULL(T.Reducciones,0) + ISNULL(T.TransferenciaRed,0))) - ISNULL(T.Comprometido,0)
			END
		END as PresDispComp,
		T.Recalendarizaciones
		FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
	END
END
GO
Exec SP_CFG_LogScripts 'SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto','2.30.1'
GO