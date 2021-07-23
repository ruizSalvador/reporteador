/****** Object:  StoredProcedure [dbo].[SP_Layout_Presupuestal]    Script Date: 22-01-2021 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Layout_Presupuestal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Layout_Presupuestal]
GO
/****** Object:  StoredProcedure [dbo].[SP_Layout_Presupuestal]    Script Date: 22-01-2021 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<>
-- Create date: <22-01-2021>
-- Description:	<SP_Layout_Presupuestal COBACH>
-- =============================================
-- Exec SP_Layout_Presupuestal 12,2020
CREATE PROCEDURE  [dbo].[SP_Layout_Presupuestal]  

@Periodo int,
@Ejercicio int

AS

BEGIN

Select 
'' as Upl,
404 as Entidad,
DP.IdCuentaContable,
CC.NumeroCuenta,
CASE SUBSTRING(NumeroCuenta,1,1)
WHEN '5' THEN CAST(CP.IdPartida as varchar) ELSE REPLICATE('0',5) END as Cog,
CTG.Clave as TipoGasto,
CASE SUBSTRING(NumeroCuenta,1,1)
WHEN '4' THEN RIGHT(NumeroCuenta,5) ELSE 999999 END as CRI,
REPLICATE('0',3) as Actividad,
REPLICATE('0',3) as Ramos,
40400001 as UResponsable,
252 as Funcional,

(SELECT  tabla2.Clave
FROM
(select * from C_EP_Ramo where Id = Sellos.IdProyecto and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
inner join 
(select * from C_EP_Ramo where  Nivel = 3) tabla3
ON tablaAI.IdPadre = tabla3.Id 
inner join 
(select * from C_EP_Ramo where  Nivel = 2) tabla2
ON tabla3.IdPadre = tabla2.Id) as ProgramaPresupuestario,
(SELECT  tablaCom.Clave
FROM
(select * from C_EP_Ramo where Id = Sellos.IdProyecto and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
inner join 
(select * from C_EP_Ramo where  Nivel = 3) tablaCom
ON tablaAI.IdPadre = tablaCom.Id) as Componente,
(SELECT  tabla1.Clave
FROM
(select * from C_EP_Ramo where Id = Sellos.IdProyecto and Nivel = 5) tablaID
inner join
(select * from C_EP_Ramo where  Nivel = 4) tablaAI
ON tablaID.IdPadre = tablaAI.Id
inner join 
(select * from C_EP_Ramo where  Nivel = 3) tabla3
ON tablaAI.IdPadre = tabla3.Id 
inner join 
(select * from C_EP_Ramo where  Nivel = 2) tabla2
ON tabla3.IdPadre = tabla2.Id 
inner join 
(select * from C_EP_Ramo where  Nivel = 1) tabla1
ON tabla2.IdPadre = tabla1.Id ) as Eje,

CCG.Clave as Geografico,
CF.Clave as FuenteFinanciamiento,
REPLICATE('0',8) as Proyecto,
ISNULL(SUM(ImporteCargo),0) as ImporteCargo, ISNULL(SUM(ImporteAbono),0) as ImporteAbono,
'' as DescripcionLinea,
'' as Blank,
'' as Mensajes

FROM T_Polizas TP
INNER JOIN D_Polizas DP on TP.IdPoliza = DP.IdPoliza
INNER JOIN C_Contable CC ON CC.IdCuentaContable = DP.IdCuentaContable
LEFT JOIN T_SellosPresupuestales Sellos ON DP.IdSelloPresupuestal = Sellos.IdSelloPresupuestal
LEFT JOIN C_FuenteFinanciamiento CF ON CF.IDFUENTEFINANCIAMIENTO = Sellos.IdFuenteFinanciamiento
INNER JOIN C_PartidasPres CP ON CP.IdPartida = Sellos.IdPartida
LEFT JOIN C_ClasificadorGeograficoPresupuestal CCG ON CCG.IdClasificadorGeografico = Sellos.IdClasificadorGeografico
LEFT JOIN C_TipoGasto CTG ON CTG.IDTIPOGASTO = Sellos.IdTipoGasto
where (Month(TP.Fecha) = @Periodo and Year(TP.Fecha) = @Ejercicio) 
AND NoPoliza <> 0
AND SUBSTRING(Replace(CC.NumeroCuenta,'-',''),1,1)  <= '5'
Group by DP.IdCuentaContable, CC.NumeroCuenta, CCG.Clave, CF.CLAVE,
CASE SUBSTRING(NumeroCuenta,1,1)
WHEN '5' THEN CAST(CP.IdPartida as varchar) ELSE REPLICATE('0',5) END,
CASE SUBSTRING(NumeroCuenta,1,1)
WHEN '4' THEN RIGHT(NumeroCuenta,5) ELSE 999999 END,
Sellos.IdProyecto, 
CCG.Clave, CTG.Clave 
Order by NumeroCuenta

END

Exec SP_CFG_LogScripts 'SP_Layout_Presupuestal','2.30.1'
GO
