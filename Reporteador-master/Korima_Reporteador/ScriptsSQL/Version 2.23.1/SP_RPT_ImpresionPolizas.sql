/****** Object:  StoredProcedure [dbo].[SP_RPT_ImpresionPolizas]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ImpresionPolizas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ImpresionPolizas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ImpresionPolizas]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [SP_RPT_ImpresionPolizas]  2016,1,4,'D',1,2
CREATE PROCEDURE [dbo].[SP_RPT_ImpresionPolizas] 


@Ejercicio  as int,
@Periodo as int,
@Periodo2 as int,  
@TipoPoliza varchar(4),
@FolioDel as int,
@FolioAl as int

AS
BEGIN

 SELECT	Ejercicio, Periodo, T_Polizas.Fecha, 
		CASE T_Polizas.Status
		WHEN 'I' THEN 'Impreso'
		WHEN 'C' THEN 'Capturado'
		END as Status, 		
		T_Polizas.TipoPoliza,
		 NoPoliza, CMOV.Descripcion, 
         CCON.NumeroCuenta, CCON.NombreCuenta, DP.ImporteCargo, 
		 DP.ImporteAbono, DP.Referencia, TS.Sello, T_Polizas.Concepto
                      
FROM	T_Polizas 
LEFT JOIN D_Polizas DP
ON T_Polizas.IdPoliza = DP.IdPoliza 
LEFT JOIN C_TipoMovPolizas CMOV
ON T_Polizas.IdTipoMovimiento = CMOV.IdTipoMovimiento 
LEFT JOIN C_Contable CCON
ON DP.IdCuentaContable = CCON.IdCuentaContable 
LEFT JOIN T_SellosPresupuestales TS
ON DP.IdSelloPresupuestal = TS.IdSelloPresupuestal
WHERE T_Polizas.Ejercicio = @Ejercicio
AND (T_Polizas.Periodo Between @Periodo and @Periodo2)
AND T_Polizas.TipoPoliza = @TipoPoliza
AND (T_Polizas.NoPoliza Between @FolioDel and @FolioAl)
Order by NoPoliza, Periodo
END
GO

EXEC SP_FirmasReporte 'Impresión de Polizas'
GO


