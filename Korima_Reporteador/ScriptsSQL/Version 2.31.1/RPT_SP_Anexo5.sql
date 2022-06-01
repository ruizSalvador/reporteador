/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo5]    Script Date: 09/05/2013 13:46:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Anexo5]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Anexo5]
GO
/****** Object:  StoredProcedure [dbo].[RPT_SP_Anexo5]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Anexo5 '20210401','20210430',0,1000
CREATE PROCEDURE [dbo].[RPT_SP_Anexo5]
 
--@Ejercicio int,
@Fecha1 date,
@Fecha2 date,
@IdFF int,
@IdCapitulo int

AS
BEGIN

Select CG.IdCapitulo, TS.IdPartida, CP.DescripcionPartida,  
TP.Concepto, 
CProv.RazonSocial, CProv.RFC,
TP.NoPoliza, TP.Fecha as FechaPoliza, 
TC.Fecha as FechaPago, 
--TC.ImporteCheque,
D_Polizas.ImporteCargo as ImporteCheque,
FF.CLAVE, FF.DESCRIPCION

		
		from T_Polizas TP JOIN D_Polizas 
		On TP.IdPoliza = D_Polizas.IdPoliza
		 JOIN T_SellosPresupuestales TS
		On D_Polizas.IdSelloPresupuestal = TS.IdSelloPresupuestal
		LEFT JOIN T_Cheques TC on TP.IdCheque = TC.IdCheques
		LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida 
		LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
		LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo 
		LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IDFUENTEFINANCIAMIENTO 
		LEFT JOIN C_Proveedores CProv ON CProv.IdProveedor = TC.IdProveedor
		inner join C_TipoMovPolizas
					on TP.IdTipoMovimiento = C_TipoMovPolizas.IdTipoMovimiento
		 JOIN VW_C_Contable as CC ON CC.IdCuentaContable = D_Polizas.IdCuentaContable 

		where 
		(TP.Fecha >= @Fecha1 and TP.Fecha <= @Fecha2) 
		--and TipoPoliza = 'E'
		--AND NoPoliza > 0
		AND LEFT(CC.NumeroCuenta,3) = '827'
		and TP.NoPoliza > 0 and ISNULL(TP.IdPolizaCancelacion,0) = 0 and C_TipoMovPolizas.CancelaManual = 0
		AND FF.IDFUENTEFINANCIAMIENTO = CASE WHEN @IdFF = 0 THEN FF.IDFUENTEFINANCIAMIENTO ELSE @IdFF END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
		

		order by NoPoliza
END

EXEC SP_FirmasReporte 'Anexo 5'
GO
		
