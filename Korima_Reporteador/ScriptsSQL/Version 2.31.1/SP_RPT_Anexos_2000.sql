/****** Object:  StoredProcedure [dbo].[SP_RPT_Anexos_2000]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Anexos_2000]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Anexos_2000]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_Anexos_2000]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_RPT_Anexos_2000 2021,4,4
CREATE PROCEDURE [dbo].[SP_RPT_Anexos_2000]
 
@Ejercicio int,
@Periodo1 int,
@periodo2 int

AS
BEGIN
Select
--TP.IdPedido,
  DATENAME (MONTH, TP.Fecha) Periodo,
  TS.IdPartida,
  DP.IdSelloPresupuestal,
  CG.IdCapitulo,
  TRF.Observaciones as DescPago,
  CB.NombreBanco,
  TC.ConceptoPago,
 CFF.DESCRIPCION as TipoRecurso,
  TS.Sello as Sello,
   CAST(TPP.TipoPoliza as varchar(10)) + ' '  + CAST(TPP.Periodo as varchar (5)) + ' ' + CAST(TPP.NoPoliza as varchar (50))  as PolizaPag,
   TPP.Fecha as FechaPolPag,
   CBPROV.NombreBanco as BancoProv,
   CASE 
   WHEN TC.FolioCheque > 0 THEN 'CH ' + CAST(TC.FolioCheque as varchar)
    ELSE CAST(TPP.TipoPoliza as varchar(10)) + ' '  + CAST(TPP.Periodo as varchar (5)) + ' ' + CAST(TPP.NoPoliza as varchar (50))  
	END as NoCheque_Transf,
	  
	  --TC.FolioCheque as NoCheque_Transf,
	  TC.Fecha as FechaExp,
	  '' as FechaCobro,
   TRF.Folio as FolioFac,
   TRF.FechaFactura,
	CP.RazonSocial as RazonSocialFac,
	TRF.SubTotal,
	TRF.IVA,
	TRF.Total,
	TRF.Retencion,
	TC.ImporteCheque as NetoPagado,
	TC.ConceptoPago as ConceptoFPago

	
FROM T_Pedidos TP
 JOIN T_RecepcionFacturas TRF 
	ON TP.IdPedido = TRF.IdPedido and TRF.IdPoliza<>0 
	LEFT JOIN C_Proveedores CP
    ON TRF.IdProveedor = CP.IdProveedor 


LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status in ('D','I')
	JOIN T_Polizas TPP ON TPP.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end

Left JOIN D_Polizas DP ON DP.IdPoliza = TPP.IdPoliza
LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	

LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar

where 
YEAR(TP.Fecha) = @Ejercicio
AND (MONTH(TP.Fecha) >= @Periodo1 and MONTH(TP.Fecha) <= @periodo2)


Group by 
--TP.IdPedido,
TS.IdSelloPresupuestal,
DP.IdSelloPresupuestal,
DP.IdCuentaContable,
TC.FolioCheque,
TC.ConceptoPago,
CB.NombreBanco,
TRF.Folio,
TRF.FechaFactura,
CP.RazonSocial,
--TIN.Importe,
TC.Fecha,
--TP.Fecha,
CG.IdCapitulo,
TS.Sello,
CFF.DESCRIPCION,
TPP.TipoPoliza,
TPP.Periodo,
TPP.NoPoliza,
TPP.Fecha,
TC.ImporteCheque,
TP.Fecha,
CBPROV.NombreBanco,
TS.IdPartida,
TP.Observaciones,
TRF.SubTotal,
	TRF.IVA,
	TRF.Total,
	TRF.Retencion,
	TRF.Total,
	TRF.Observaciones

	--Order by TP.IdPedido



UNION ALL

Select
--TP.IdPedido,
  DATENAME (MONTH, TOS.Fecha) Periodo,
  TS.IdPartida,
  DP.IdSelloPresupuestal,
  --'Varias' as Partida,
  CG.IdCapitulo,
  TRF.Observaciones as DescPago,
  CB.NombreBanco,
  TC.ConceptoPago,
 CFF.DESCRIPCION as TipoRecurso,
  TS.Sello as Sello,
   CAST(TPP.TipoPoliza as varchar(10)) + ' '  + CAST(TPP.Periodo as varchar (5)) + ' ' + CAST(TPP.NoPoliza as varchar (50))  as PolizaPag,
   TPP.Fecha as FechaPolPag,
   CBPROV.NombreBanco as BancoProv,
   CASE 
   WHEN TC.FolioCheque > 0 THEN 'CH ' + CAST(TC.FolioCheque as varchar)
    ELSE CAST(TPP.TipoPoliza as varchar(10)) + ' '  + CAST(TPP.Periodo as varchar (5)) + ' ' + CAST(TPP.NoPoliza as varchar (50))  
	END as NoCheque_Transf,
	  --TC.FolioCheque as NoCheque_Transf,
	  TC.Fecha as FechaExp,
	  '' as FechaCobro,
   TRF.Folio,
   TRF.FechaFactura,
	CP.RazonSocial,
	TRF.SubTotal,
	TRF.IVA,
	TRF.Total,
	TRF.Retencion,
	TC.ImporteCheque as NetoPagado,
	TC.ConceptoPago as ConceptoFPago

	
FROM T_OrdenServicio TOS
 JOIN T_RecepcionFacturas TRF 
	ON TOS.IdOrden = TRF.IdOrden and TRF.IdPoliza<>0 
	LEFT JOIN C_Proveedores CP
    ON TRF.IdProveedor = CP.IdProveedor 


LEFT JOIN T_SolicitudCheques TSC
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 
LEFT JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque and TC.Status in ('D','I')
	JOIN T_Polizas TPP ON TPP.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end

Left JOIN D_Polizas DP ON DP.IdPoliza = TPP.IdPoliza
LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	

LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar

where 
YEAR(TOS.Fecha) = @Ejercicio
AND (MONTH(TOS.Fecha) >= @Periodo1 and MONTH(TOS.Fecha) <= @periodo2)


Group by 
--TP.IdPedido,
TS.IdSelloPresupuestal,
DP.IdSelloPresupuestal,
DP.IdCuentaContable,
TC.FolioCheque,
TC.ConceptoPago,
CB.NombreBanco,
TRF.Folio,
TRF.FechaFactura,
CP.RazonSocial,
--TIN.Importe,
TC.Fecha,
--TP.Fecha,
CG.IdCapitulo,
TS.Sello,
CFF.DESCRIPCION,
TPP.TipoPoliza,
TPP.Periodo,
TPP.NoPoliza,
TPP.Fecha,
TC.ImporteCheque,
TOS.Fecha,
CBPROV.NombreBanco,
TS.IdPartida,
TOS.Observaciones,
TRF.SubTotal,
	TRF.IVA,
	TRF.Total,
	TRF.Retencion,
	TRF.Total,
	TRF.Observaciones

	Order by TRF.Folio


END
GO

EXEC SP_FirmasReporte 'IDEFT Anexo 4'
GO
