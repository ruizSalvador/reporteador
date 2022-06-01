/****** Object:  StoredProcedure [dbo].[SP_RPT_Anexos_1000]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Anexos_1000]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Anexos_1000]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_RPT_Anexos_1000]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 -- Exec SP_RPT_Anexos_1000 2014,3,3
CREATE PROCEDURE [dbo].[SP_RPT_Anexos_1000]	

@Ejercicio int,
@Periodo1 int,
@periodo2 int

AS
BEGIN

Select 
  --TIN.IdNomina,
  DATENAME (MONTH, TIN.FechaPago) Periodo,
  TS.IdPartida,
  DP.IdSelloPresupuestal,
  --'Varias' as Partida,
  CG.IdCapitulo,
  TIN.Observaciones as DescPago,
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
	  TC.Fecha as FechaExp,
	  '' as FechaCobro,
   '' NoComprobante,
   '' FechaComprobante,
   '' RSProv,
   '' SubTotal,
   '' Iva,
   '' Total,
   '' OtrasRet,

   '' TraspasoRecPropio,
   '' TraspasoRecEstatal,
   '' Devoluciones,
   '' NetoPagado,
   '' Cheques,
   '' PagadoOtrasCtas,
   '' ConceptoPagoDev


	FROM T_ImportaNomina TIN

	 JOIN R_NominaSolEgresos RNSOL 
	ON TIN.IdNomina = RNSOL.IdNomina --and RNSOL.Tipo='N'
	 JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = RNSOL.IdSolicitudCheques
	 JOIN T_Cheques TC
	ON TC.IdSolicitudCheque = TSC.IdSolicitudCheques and TC.Status in ('D','I')

LEFT JOIN C_CuentasBancarias CCB
on TC.IdCuentaBancaria= CCB.IdCuentaBancaria 
LEFT JOIN C_Bancos CB
on CCB.IdBanco= CB.idbanco
LEFT JOIN C_Bancos CBPROV
ON CBPROV.IdBanco = TC.IdBancoADespositar

 LEFT JOIN T_Polizas TPP ON TPP.IdPoliza = 
	CASE 
WHEN TC.IdPolizaPresupuestoPagado = 0 THEN null 
ELSE	TC.IdPolizaPresupuestoPagado end

Left JOIN D_Polizas DP ON DP.IdPoliza = TPP.IdPoliza

	LEFT JOIN T_SellosPresupuestales As TS  ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
	LEFT JOIN C_PartidasPres As CPP ON CPP.IdPartida = TS.IdPartida
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CPP.IdConcepto
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
	LEFT JOIN C_FuenteFinanciamiento CFF on CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	--LEFT JOIN C_TipoMovPolizas CMOV ON TP.IdTipoMovimiento = CMOV.IdTipoMovimiento

Where
 YEAR(TIN.FechaPago) = @Ejercicio
AND (MONTH(TIN.FechaPago) >= @Periodo1 and MONTH(TIN.FechaPago) <= @Periodo2)

Group by 
TS.IdSelloPresupuestal,
DP.IdSelloPresupuestal,
DP.IdCuentaContable,

TC.ConceptoPago,
CB.NombreBanco,
--TP.Concepto, 
TIN.Importe,
TC.FolioCheque,
TC.Fecha,
--TP.Fecha,
CG.IdCapitulo,

TS.Sello,
CFF.DESCRIPCION,
TPP.TipoPoliza,
TPP.Periodo,
TPP.NoPoliza,
TPP.Fecha,
TIN.FechaPago,
CBPROV.NombreBanco,
TS.IdPartida,
TIN.Observaciones,
RNSOL.IdSolicitudCheques,
--DP2.ImporteCargo, C2.NumeroCuenta, C2.NombreCuenta, 
TIN.IdNomina 
--TPP.TipoPoliza ,TPP.NoPoliza, TPP.Periodo, TPP.Fecha
	order by  TIN.IdNomina, RNSOL.IdSolicitudCheques
-------------------------------------
END
GO

EXEC SP_FirmasReporte 'IDEFT Anexo 4'
GO