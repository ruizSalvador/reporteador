/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasPorPagar]    Script Date: 09/09/2014 11:06:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_CuentasPorPagar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_CuentasPorPagar]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasPorPagar]    Script Date: 09/09/2014 11:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_CuentasPorPagar]
@FechaInicial DATE,
@FechaFinal DATE,
@Beneficiario vARCHAR(MAX),
@TipoProveedor CHAR(1),
@Estatus CHAR(1)
AS

BEGIN
DECLARE @consulta NVARCHAR(MAX)
SET @consulta =

'SELECT
T_SolicitudCheques.FechaProgramacion,
T_SolicitudCheques.Beneficiario,
T_SolicitudCheques.Importe,
T_RecepcionFacturas.Factura,
T_SolicitudCheques.Concepto,
CASE C_Proveedores.TipoProveedor
WHEN ''C'' THEN ''Contratista''
WHEN ''P'' THEN ''Proveedor''
WHEN ''V'' THEN ''Beneficiario''
ELSE '''' END AS TipoProveedor,
T_SolicitudCheques.FolioPorTipo,
CASE T_SolicitudCheques.Estatus
WHEN ''N'' THEN ''Cancelado''
WHEN ''A'' THEN ''Aprobado''
WHEN ''C'' THEN ''Capturado''
ELSE '''' END AS Estatus,
T_SolicitudCheques.FechaAprobacion
FROM T_SolicitudCheques
LEFT OUTER JOIN C_Proveedores
ON C_Proveedores.IdProveedor = T_SolicitudCheques.IdProveedor 
LEFT OUTER JOIN T_RecepcionFacturas 
ON T_SolicitudCheques.IdRecepcionServicios= T_RecepcionFacturas.IdRecepcionServicios 

where T_SolicitudCheques.FechaProgramacion between ' + QUOTENAME(REPLACE(CONVERT(NVARCHAR, @FechaInicial, 103), ' ', '/'),'''') +' AND '+ QUOTENAME(REPLACE(CONVERT(NVARCHAR, @FechaFinal, 103), ' ', '/'),'''')+''

IF @Beneficiario<>''  SET @Consulta+= ' AND T_SolicitudCheques.Beneficiario='+QUOTENAME(@Beneficiario,'''')+''
IF @TipoProveedor<>'' SET @consulta +=' AND C_Proveedores.TipoProveedor='+QUOTENAME(@TipoProveedor,'''')+''
IF @Estatus <>'' SET @consulta+=' AND T_SolicitudCheques.Estatus='+QUOTENAME(@Estatus,'''')+''

--print @consulta
EXEC (@Consulta)
END

GO


/****** Object:  View [dbo].[VW_RPT_K2_Beneficiarios]    Script Date: 09/10/2014 09:08:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_Beneficiarios]'))
DROP VIEW [dbo].[VW_RPT_K2_Beneficiarios]
GO

/****** Object:  View [dbo].[VW_RPT_K2_Beneficiarios]    Script Date: 09/10/2014 09:08:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_Beneficiarios] AS
SELECT DISTINCT Beneficiario FROM T_SolicitudCheques

GO


