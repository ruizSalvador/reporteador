/****** Object:  StoredProcedure [dbo].[SP_RPT_CuentasGastoFactura]    Script Date: 05/10/2017 09:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CuentasGastoFactura]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CuentasGastoFactura]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CuentasGastoFactura]     Script Date: 05/10/2017 09:36:13******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_CuentasGastoFactura '20170101','20170730'
CREATE PROCEDURE [dbo].[SP_RPT_CuentasGastoFactura]

@FechaInicio datetime,
@FechaFin datetime

AS

Declare @RPT as table(
Cuenta varchar(max),
Fecha Datetime,
NoPoliza int,
RazonSocial Varchar(max),
Concepto varchar(max),
IdCheque int,
FolioCheque int,
Factura varchar(max),
NombreBanco varchar(max),
Importe decimal(18,2)
)


INSERT INTO @RPT
Select Distinct NumeroCuenta as Cuenta, TP.Fecha, TP.NoPoliza, 
CP.RazonSocial, TP.Concepto, TC.IdCheques, TC.FolioCheque, TR.Factura,
CB.NombreBanco, TC.ImporteCheque

FROM T_RecepcionFacturas TR
LEFT JOIN T_Polizas TP 
	ON TR.IdPoliza = TP.IdPoliza
LEFT JOIN D_Polizas DP 
	ON DP.IdPoliza = TP.IdPoliza
LEFT JOIN T_SolicitudCheques TSC
	ON TR.IdRecepcionServicios = TSC.IdRecepcionServicios 
INNER JOIN T_Cheques TC
	ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
LEFT JOIN C_Contable CC 
	ON CC.IdCuentaContable= DP.IdCuentaContable 
LEFT JOIN C_CuentasBancarias CCB 
	ON CCB.IdCuentaBancaria = TC.IdCuentaBancaria
LEFT JOIN C_Bancos CB 
	ON CB.IdBanco = CCB.IdBanco
LEFT JOIN C_Proveedores CP 
	ON CP.IdProveedor = TR.IdProveedor
where (TR.Fecha >= @FechaInicio AND TR.Fecha <= @FechaFin)
AND CC.NumeroCuenta  like '5%' 

UNION ALL

Select  Distinct CC.NumeroCuenta as Cuenta, TP.Fecha , TP.NoPoliza, 
		(Select CE.Nombres + ' ' + CE.ApellidoPaterno + ' ' + CE.ApellidoMaterno) as RazonSocial,
		DV.Observacion as Concepto,
		null as IdCheque, 
		null as FolioCheque,
		DV.Referencia as Factura, 
		'Comprobación de Gastos' as NombreBanco,
		DV.Importe as Importe
FROM T_Viaticos TV
		LEFT JOIN D_Viaticos DV ON TV.IdViaticos = DV.IdViatico
		LEFT JOIN T_SolicitudCheques TSC ON TV.IdSolicitudChequesOriginal = TSC.IdSolicitudCheques
		INNER JOIN T_Cheques TC ON TSC.IdSolicitudCheques = TC.IdSolicitudCheque
		LEFT JOIN T_Polizas TP ON TP.IdPoliza = TV.IdPoliza
		LEFT JOIN D_Polizas DP ON DP.IdPoliza = TP.IdPoliza
		LEFT JOIN C_Empleados CE ON TV.NumeroEmpleado = CE.NumeroEmpleado
		LEFT JOIN C_Contable CC ON CC.IdCuentaContable = DP.IdCuentaContable
		where (TV.Fecha >= @FechaInicio AND TV.Fecha <= @FechaFin) and DP.ImporteCargo = DV.Importe
		AND CC.NumeroCuenta  like '5%'

select * from @RPT order by NoPoliza

GO

EXEC SP_FirmasReporte 'Cuentas de Gasto por Factura'
GO

Exec SP_CFG_LogScripts 'SP_RPT_CuentasGastoFactura'
GO


