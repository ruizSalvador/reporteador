/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 22/04/2021 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Informativa_Proveedores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Informativa_Proveedores]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Informativa_Proveedores]    Script Date: 22/04/2021 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Informativa_Proveedores 1,1,2021,3671
CREATE PROCEDURE [dbo].[SP_RPT_Informativa_Proveedores] 
 
@Periodo1 as int,
@Periodo2 as int, 
@Ejercicio as int,
@IdProveedor as int

 
 AS
 BEGIN

 DECLARE @Tabla TABLE (Numero int, RazonSocial varchar(max), RFC varchar(max), Domicilio varchar(max), NombreCiudad varchar(200), CP int, FuenteF varchar(max), Recurso varchar(100), FormaPago varchar(200), DescripcionGasto varchar(max), ImporteCheque Decimal(18,2), 
FechaFactura Datetime, Folio int, [Status] varchar(2), FolioAgrupador Int, FechaFolioAgrupador Datetime)

Insert into @Tabla
Select ROW_NUMBER() OVER (Order by RazonSocial) Numero,
RazonSocial, RFC, Domicilio, NombreCiudad, CP, 
(Select Descripcion from C_FuenteFinanciamiento Where IdFuenteFinanciamiento = (Select IdFuenteFinanciamiento from T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 IdSelloPresupuestal from D_RecepcionFacturas where IdRecepcionServicios = TRF.IdRecepcionServicios))) as FuenteF,
--TS.IdFuenteFinanciamiento,
'' as Recurso,
CASE TSC.PorDeposito
WHEN 0 Then 'Cheque'
WHEN 1 Then 'Transferencia'
END as FormaPago,
TSC.Concepto as DescripcionGasto,
TC.ImporteCheque,
TRF.FechaFactura,
TRF.Folio, 
TC.Status,
TRFA.Folio,
TCA.Fecha
 From
 T_RecepcionFacturas TRF
 --LEFT JOIN D_RecepcionFacturas DRF
	--ON TRF.IdRecepcionServicios = DRF.IdRecepcionServicios
LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN C_Proveedores CP
    ON TRF.IdProveedor = CP.IdProveedor
LEFT JOIN C_Ciudades CC
	ON CP.IdCiudad = CC.IdCiudad
LEFT JOIN T_Cheques TCA
ON TC.IdChequesAgrupador = TCA.IdCheques
LEFT JOIN T_SolicitudCheques TSCA
ON TCA.IdSolicitudCheque = TSCA.IdSolicitudCheques
LEFT JOIN T_RecepcionFacturas TRFA
ON TRFA.IdRecepcionServicios = TSCA.IdRecepcionServicios

	Where Year(TC.Fecha) = @Ejercicio and (Month(TC.Fecha) Between @Periodo1 and @Periodo2)
	--AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
	AND TC.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where (MONTH(T_Cheques.Fecha) Between @Periodo1 and @Periodo2) and YEAR(T_Cheques.Fecha) = @Ejercicio)    
	AND TC.Status <> 'G'
	AND TRF.IdProveedor = CASE WHEN @IdProveedor = 0 THEN TRF.IdProveedor ELSE @IdProveedor END


Select * from @Tabla Where Month(FechaFolioAgrupador) Between @Periodo1 and @Periodo2 
OR FechaFolioAgrupador is null

END

Exec SP_CFG_LogScripts 'SP_RPT_Informativa_Proveedores','2.30.1'
GO