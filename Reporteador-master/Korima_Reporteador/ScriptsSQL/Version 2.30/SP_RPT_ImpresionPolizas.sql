/****** Object:  StoredProcedure [dbo].[SP_RPT_ImpresionPolizas]    Script Date: 08/28/2015 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ImpresionPolizas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ImpresionPolizas]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ImpresionPolizas]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec [SP_RPT_ImpresionPolizas]  2020,4,8,'D',1,1,0,0
CREATE PROCEDURE [dbo].[SP_RPT_ImpresionPolizas] 


@Ejercicio  as int,
@Periodo as int,
@Periodo2 as int,  
@TipoPoliza varchar(4),
@FolioDel as int,
@FolioAl as int,
@IdTipoMov as int,
@ConClave bit

AS
BEGIN

Declare @Polizas as table (
Ejercicio int,
Periodo int, 
Fecha Datetime,
Status varchar(100),
TipoPoliza varchar(4),
NoPoliza int, 
Descripcion varchar(max),
Numerocuenta varchar(100),
NombreCuenta varchar(max),
ImporteCargo Decimal(18,2),
ImporteAbono Decimal(18,2),
Referencia varchar(200),
Sello varchar(200),
Concepto varchar(max)
)

If @IdTipoMov = 0
BEGIN
	INSERT INTO @Polizas
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
ELSE
BEGIN
	INSERT INTO @Polizas
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
	AND T_Polizas.IdTipoMovimiento = @IdTipoMov
	Order by NoPoliza, Periodo
END

IF @ConClave = 0
BEGIN
	Update @Polizas set Sello = null Where NumeroCuenta not like '8%' 
END

Select * from @Polizas Order by NoPoliza, Periodo

END
GO

EXEC SP_FirmasReporte 'Impresión de Polizas'
GO


Exec SP_CFG_LogScripts 'SP_RPT_ImpresionPolizas','2.30'
GO


