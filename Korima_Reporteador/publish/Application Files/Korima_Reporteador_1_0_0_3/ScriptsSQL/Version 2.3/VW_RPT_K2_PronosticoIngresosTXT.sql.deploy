/****** Object:  View [dbo].[VW_RPT_K2_PronosticoIngresosTXT]    Script Date: 06/24/2013 15:31:29 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_PronosticoIngresosTXT]'))
DROP VIEW [dbo].[VW_RPT_K2_PronosticoIngresosTXT]
GO

/****** Object:  View [dbo].[VW_RPT_K2_PronosticoIngresosTXT]    Script Date: 06/24/2013 15:31:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_PronosticoIngresosTXT]
AS 
SELECT 
substring(REPLACE(rtrim(C_PartidasGastosIngresos.Clave),' ',''),1,21)+
REPLICATE (' ',21-(len(CONVERT(varchar(30),substring(REPLACE(rtrim(C_PartidasGastosIngresos.Clave),' ',''),1,21))))) as CuentaContable,
substring(rtrim(C_PartidasGastosIngresos.Descripcion),1,300)+REPLICATE (' ',300-len(substring(rtrim(C_PartidasGastosIngresos.Descripcion),1,300))) as Nombre,
--
Case when T_PresupuestoFlujo.Estimado<0 then
'-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoFlujo.Estimado))))+convert(varchar(20),T_PresupuestoFlujo.Estimado),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoFlujo.Estimado))))+convert(varchar(20),T_PresupuestoFlujo.Estimado) end as Importe,
--
Case when T_PresupuestoFlujo.Modificado<0 then
'-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoFlujo.Modificado))))+convert(varchar(20),T_PresupuestoFlujo.Modificado),'-','')
else REPLICATE('0',15-(LEN(convert(varchar(20),T_PresupuestoFlujo.Modificado))))+convert(varchar(20),T_PresupuestoFlujo.Modificado) end as Modificacion,
--
T_PresupuestoFlujo.Ejercicio 
FROM
C_PartidasGastosIngresos
JOIN T_PresupuestoFlujo
ON T_PresupuestoFlujo.IdPartida = C_PartidasGastosIngresos.IdPartidaGI 
where T_PresupuestoFlujo.Mes=0




GO


