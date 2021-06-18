/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoPorProveedorContable]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Informativa_Proveedores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Informativa_Proveedores]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Informativa_Proveedores]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Informativa_Proveedores 1,7,2020,0
CREATE PROCEDURE [dbo].[SP_RPT_Informativa_Proveedores] 
 
@Periodo1 as int,
@Periodo2 as int, 
@Ejercicio as int,
@IdProveedor as int

 
 AS
 BEGIN
Select ROW_NUMBER() OVER (Order by RazonSocial) Numero,
RazonSocial, RFC, Domicilio, NombreCiudad, CP, 
(Select Descripcion from C_FuenteFinanciamiento Where IdFuenteFinanciamiento = (Select IdFuenteFinanciamiento from T_SellosPresupuestales Where IdSelloPresupuestal = (Select top 1 IdSelloPresupuestal from D_RecepcionFacturas where IdRecepcionServicios = TRF.IdRecepcionServicios))) as FuenteF,
--TS.IdFuenteFinanciamiento,
'' as Recurso,
CASE PorDeposito
WHEN 0 Then 'Cheque'
WHEN 1 Then 'Transferencia'
END as FormaPago,
Concepto as DescripcionGasto,
ImporteCheque,
FechaFactura,
Folio
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

	Where Year(TC.Fecha) = @Ejercicio and (Month(TC.Fecha) Between @Periodo1 and @Periodo2)
	AND TC.IdChequesAgrupador = 0 AND TC.Status in ('D','I')
	AND TRF.IdProveedor = CASE WHEN @IdProveedor = 0 THEN TRF.IdProveedor ELSE @IdProveedor END
--Group by CP.RazonSocial, CP.RFC, CP.Domicilio, CC.NombreCiudad, CP.CP, 
--TSC.PorDeposito, TSC.Concepto, TRF.FechaFactura, TRF.Folio, TRF.IdRecepcionServicios, TC.ImporteCheque 

END

Exec SP_CFG_LogScripts 'SP_RPT_Informativa_Proveedores','2.30'
GO
