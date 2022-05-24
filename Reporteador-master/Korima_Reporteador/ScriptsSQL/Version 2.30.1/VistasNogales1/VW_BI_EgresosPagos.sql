
/****** Object:  View [dbo].[VW_BI_EgresosPagos]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BI_EgresosPagos]'))
DROP VIEW [dbo].[VW_BI_EgresosPagos]
GO
/****** Object:  View [dbo].[VW_BI_EgresosPagos]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_BI_EgresosPagos]
AS

SELECT  
	T_SolicitudCheques.FolioPorTipo as NoSolPago,
	T_cheques.Fecha as FechaPago,
	T_cheques.FolioCheque as ChequeoTrans,
	T_SolicitudCheques.Concepto as Descripcion,
	CASE
		WHEN T_Cheques.IdProveedor = 0 THEN C_Empleados.Rfc 
	    ELSE C_Proveedores.RFC 
	END as CveProveedor,
	C_Proveedores.RazonSocial as Proveedor,
	T_cheques.Beneficiario,
	T_cheques.ImporteCheque TotalPago,
	C_Bancos.NombreBanco+' '+ C_CuentasBancarias.CuentaBancaria  as Cuenta,
	CASE WHEN T_cheques.FolioCheque > 0 THEN 'Cheques'
	ELSE 'Transferencia Electrónica' END as TipoPago,
	CASE T_SolicitudCheques.IdRecepcionServicios
	WHEN 0 THEN 'Solicitu de Pago'
    ELSE 'Factura'
	END as Origen
	FROM T_cheques
	LEFT OUTER JOIN T_SolicitudCheques
	ON T_SolicitudCheques.IdSolicitudCheques = T_Cheques.IdSolicitudCheque
	LEFT OUTER JOIN C_CuentasBancarias 
	ON T_Cheques.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
	LEFT OUTER JOIN C_Bancos 
	ON C_CuentasBancarias.IdBanco=C_Bancos.IdBanco
	left outer join C_Proveedores 
	ON C_Proveedores.IdProveedor=T_SolicitudCheques.IdProveedor 
	left outer join R_CtasContxCtesProvEmp
	on R_CtasContxCtesProvEmp.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria  
	left outer join C_Empleados
	ON  C_Empleados.NumeroEmpleado = T_Cheques.NumeroEmpleado 
	Where 
	 R_CtasContxCtesProvEmp.IdTipoCuenta=45

GO