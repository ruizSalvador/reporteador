
/****** Object:  StoredProcedure [dbo].[SP_RPT_Pagos_ADEFAS]   Script Date: 03/08/2018 10:45:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Pagos_ADEFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Pagos_ADEFAS]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Pagos_ADEFAS]    Script Date: 22/08/2018 05:56:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
--Exec SP_RPT_Pagos_ADEFAS '20190101','20190830',0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_Pagos_ADEFAS] 
@FechaInicio Datetime,
@FechaFin Datetime,
@IdProveedor int,
@IdPartida int,
@IdUR int

AS
BEGIN
Select  T_Cheques.Fecha, 
C_CuentasBancarias.CuentaBancaria, 
C_Proveedores.RazonSocial,  
CASE T_Cheques.FolioCheque
WHEN  0 THEN 'Transferencia Electrónica'
ELSE CAST(T_Cheques.FolioCheque as varchar(100)) 
END AS FolioCheque, 
T_Cheques.ImporteCheque, 
T_SolicitudCheques.IdPartida, 
T_SellosPresupuestales.Sello,
T_Cheques.IdPolizaPresupuestoPagado,
CONVERT(Varchar(max),T_Polizas.TipoPoliza) + ' ' + CONVERT(Varchar(max),T_Polizas.Periodo) + ' ' + CONVERT(Varchar(max),T_Polizas.NoPoliza) as NoPoliza
  
From T_SolicitudCheques
LEFT JOIN T_Cheques on T_SolicitudCheques.IdSolicitudCheques=T_Cheques.IdSolicitudCheque
LEFT JOIN C_Proveedores on T_SolicitudCheques.IdProveedor=C_Proveedores.IdProveedor 
LEFT JOIN C_CuentasBancarias on T_Cheques.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
LEFT OUTER JOIN T_Polizas
ON T_Polizas.IdCheque= T_Cheques.IdCheques
LEFT JOIN T_SellosPresupuestales on T_SolicitudCheques.IdSelloPresupuestal=T_SellosPresupuestales.IdSelloPresupuestal
where T_SolicitudCheques.IdPartida Like '9%' 
AND (T_Cheques.Status= 'D' or T_Cheques.Status='I')
AND T_SolicitudCheques.IdPartida = CASE WHEN @IdPartida = 0 THEN  T_SolicitudCheques.IdPartida ELSE @IdPartida END
AND T_SolicitudCheques.Periodo=2019 
AND T_solicitudcheques.FechaCancelacion is null
AND T_SellosPresupuestales.IdAreaResp = CASE WHEN @IdUR = 0 THEN T_SellosPresupuestales.IdAreaResp ELSE @IdUR END  
AND T_solicitudcheques.IdProveedor = CASE WHEN @IdProveedor = 0 THEN T_solicitudcheques.IdProveedor ELSE @IdProveedor END  
AND T_Cheques.IdPolizaCancelacion=0 
AND (T_Cheques.Fecha >= @FechaInicio and T_Cheques.Fecha <= @FechaFin)

Order by T_Cheques.Fecha

END
GO

EXEC SP_FirmasReporte 'Pagos Administrativos de ADEFAS'
GO

Exec SP_CFG_LogScripts 'SP_RPT_Pagos_ADEFAS','2.29'
GO