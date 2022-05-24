
/****** Object:  View [dbo].[VW_RPT_K2_PresupuestoEgresosTXT]    Script Date: 06/21/2013 14:19:52 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_PresupuestoEgresosTXT]'))
DROP VIEW [dbo].[VW_RPT_K2_PresupuestoEgresosTXT]
GO

/****** Object:  View [dbo].[VW_RPT_K2_PresupuestoEgresosTXT]    Script Date: 06/21/2013 14:19:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_PresupuestoEgresosTXT]
AS


SELECT 
--ROW_NUMBER()OVER(order by T_SellosPresupuestales.Sello ) as Num,
CONVERT(varchar(30),SUBSTRING (REPLACE(T_SellosPresupuestales.Sello,'-',''),1,21))+
REPLICATE(' ',21-(LEN(CONVERT(varchar(30),SUBSTRING (REPLACE(T_SellosPresupuestales.Sello,'-',''),1,21))))) as CuentaPublica,
Substring(rtrim(C_AreaResponsabilidad.Nombre),1,300)+ REPLICATE(' ',300-(len(SUBSTRING(rtrim(C_AreaResponsabilidad.Nombre),1,300)))) as Departamento,
case when T_PresupuestoNW.Autorizado <0 then 
'-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Autorizado))))+convert(varchar(20),T_PresupuestoNW.Autorizado),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Autorizado))))+convert(varchar(20),T_PresupuestoNW.Autorizado) end as ImporteAutorizado,
--
case when (T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp)<0 then
'-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp))))+convert(varchar(20),T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp))))+convert(varchar(20),T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp)end as Aumento,
--
case when(T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)<0 then
'-'+ REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed))))+convert(varchar(20),T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed))))+convert(varchar(20),T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)end as Disminucion,
--
case when T_PresupuestoNW.Modificado <0 then
'-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Modificado))))+convert(varchar(20),T_PresupuestoNW.Modificado),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoNW.Modificado))))+convert(varchar(20),T_PresupuestoNW.Modificado)end as Modificado,
--
case when ((T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)-(T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp))<0
then '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),(T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)-(T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp)))))+convert(varchar(20),(T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)-(T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp)),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),(T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)-(T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp)))))+convert(varchar(20),(T_PresupuestoNW.Reducciones + T_PresupuestoNW.TransferenciaRed)-(T_PresupuestoNW.Ampliaciones + T_PresupuestoNW.TransferenciaAmp))end as DiferenciaPresupuestal,
--
case when (T_PresupuestoNW.Modificado-T_PresupuestoNW.Autorizado)<0
then '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),(T_PresupuestoNW.Modificado-T_PresupuestoNW.Autorizado)))))+convert(varchar(20),(T_PresupuestoNW.Modificado-T_PresupuestoNW.Autorizado)),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),(T_PresupuestoNW.Modificado-T_PresupuestoNW.Autorizado)))))+convert(varchar(20),(T_PresupuestoNW.Modificado-T_PresupuestoNW.Autorizado)) end as PresupuestoFinal,
T_PresupuestoNW.Year 
--
FROM T_SellosPresupuestales
JOIN C_AreaResponsabilidad 
ON C_AreaResponsabilidad.IdAreaResp= T_SellosPresupuestales.IdAreaResp
JOIN T_PresupuestoNW
ON T_PresupuestoNW.IdSelloPresupuestal=T_SellosPresupuestales.IdSelloPresupuestal 
Where T_PresupuestoNW.Mes=0


GO
