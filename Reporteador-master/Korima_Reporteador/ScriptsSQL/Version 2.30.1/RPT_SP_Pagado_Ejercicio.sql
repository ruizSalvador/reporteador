/****** Object:  StoredProcedure [dbo].[RPT_SP_Pagado_Ejercicio]    Script Date: 06/10/2021 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPT_SP_Pagado_Ejercicio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RPT_SP_Pagado_Ejercicio]
GO

/****** Object:  StoredProcedure [dbo].[RPT_SP_Pagado_Ejercicio]    Script Date: 06/10/2021 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec RPT_SP_Pagado_Ejercicio 2020,0,0
CREATE PROCEDURE [dbo].[RPT_SP_Pagado_Ejercicio]

@FechaIni Date,
@FechaFin Date,
--@Ejercicio int,
@TipoMov int,
@BancoId int

AS

BEGIN


Select TCH.IdSolicitudCheque as Id_registro_pago, 
TCH.IdCheques as Id_registro, 
TCH.IdTipoMovimiento as IdTipoMovimiento,
C_TipoMovPolizas.Descripcion as Descripciono_tipo_movimiento, 
YEAR(TSC.Fecha) as Año_Gasto,
Sellos.IdSelloPresupuestal as Id_Clave_Presupuestal,
ISNULL(Sellos.Sello,'') as Clave_presupuestal,
CF.IDFUENTEFINANCIAMIENTO as Id_Fuente_Financiamiento,  ISNULL(CF.DESCRIPCION,'') as Fuente_Financiamiento,
ISNULL(T_Contratos.Codigo,'') as Contrato,
ISNULL(TRF.Folio,'') as No_Factura,
TRF.FechaFactura as Fecha_Factura,
CONCAT(Convert(DATE,TCH.Fecha),' ',Convert(varchar(20),TCH.HoraImpresion,108)) as Fecha_Hora_Pago,
TP.Concepto,
ISNULL(TRF.Factura,'') as factura,
TRF.Total as Importe_Total,

--DP.ImporteCargo as Importe_Pagado,
CASE WHEN TRF.Folio is null Then TCH.ImporteCheque
ELSE DRF.Importe END as Importe_Pagado,
--DRF.Importe  as Importe_Pagado,

CASE WHEN TCH.FolioCheque > 0 THEN 'Cheques'
	ELSE 'Transferencia Electrónica' END as Forma_Pago,
	CMON.Descripcion as Denominacion,
	CASE TCH.Status 
	WHEN 'N' Then 'Cancelado'
	ELSE 'Activo' END AS Estatus_Pago,
	TCH.FechaCancelacion as Fecha_Cancelacion,
	TCH.FolioCheque as No_de_Cheque,
	C_Bancos.NombreBanco as Banco,
	C_CuentasBancarias.CuentaBancaria as Cuenta_Bancaria,
	TCH.IdProveedor as Id_Proveedor,
	ISNULL(C_Proveedores.RFC,'') as RFC,
	ISNULL(C_Proveedores.RazonSocial,'') as Descripcion_Proveedor,
	CE1.Nombres + CE1.ApellidoPaterno + CE1.ApellidoMaterno as Usuario_formulo,
	CE2.Nombres + CE2.ApellidoPaterno + CE2.ApellidoMaterno as Usuario_reviso,
	CE2.Nombres + CE2.ApellidoPaterno + CE2.ApellidoMaterno as Usuario_autorizo,

	TPD.IdPoliza,
	CASE TPD.TipoPoliza WHEN 'D' Then 'Diario'
	WHEN 'E' THEN 'Egreso' ELSE ''
	END as TipoPoliza,
	TPD.Periodo,
	TPD.NoPoliza,

	TP.IdPoliza as IdPolizaE,
	CASE TP.TipoPoliza WHEN 'D' Then 'Diario'
	WHEN 'E' THEN 'Egreso' ELSE ''
	END as TipoPolizaE,
	TP.Periodo PeriodoE,
	TP.NoPoliza NoPolizaE
	

FROM T_cheques TCH
	 LEFT JOIN T_SolicitudCheques TSC
	ON TSC.IdSolicitudCheques = TCH.IdSolicitudCheque

	LEFT JOIN T_RecepcionFacturas TRF
	ON TRF.IdRecepcionServicios = TSC.IdRecepcionServicios 

	LEFT JOIN T_Polizas TPD
	ON TRF.IdPoliza = TPD.IdPoliza


	LEFT JOIN D_RecepcionFacturas DRF
	ON DRF.IdRecepcionServicios = TRF.IdRecepcionServicios

	JOIN T_Polizas TP On TCH.IdCheques = TP.IdCheque AND YEAR(TP.Fecha) = YEAR(@FechaFin)
	--JOIN D_Polizas DP ON DP.IdPoliza= TP.IdPoliza AND TP.Ejercicio = 2020
	LEFT JOIN T_SellosPresupuestales Sellos on DRF.IdSelloPresupuestal = Sellos.IdSelloPresupuestal 
	LEFT JOIN C_FuenteFinanciamiento  CF ON Sellos.IdFuenteFinanciamiento = CF.IdFuenteFinanciamiento

	LEFT JOIN C_CuentasBancarias 
	ON TCH.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
	LEFT JOIN C_Bancos 
	ON C_CuentasBancarias.IdBanco=C_Bancos.IdBanco
	LEFT JOIN C_TipoMovPolizas
	ON C_TipoMovPolizas.IdTipoMovimiento = TCH.IdTipoMovimiento
	LEFT JOIN C_Proveedores 
	ON C_Proveedores.IdProveedor=TCH.IdProveedor 
	
	LEFT JOIN C_Usuarios CUF
	ON CUF.IdUsuario = TSC.IdUsuario

	LEFT JOIN C_Empleados CE1
	ON  CE1.NumeroEmpleado = CUF.NumeroEmpleado 

	LEFT JOIN C_Usuarios CUR
	ON CUR.IdUsuario = TCH.IdUsuario

	LEFT JOIN C_Empleados CE2
	ON  CE2.NumeroEmpleado = CUR.NumeroEmpleado 

	LEFT JOIN T_Contratos ON T_Contratos.Contrato = TRF.IdContrato
	LEFT JOIN C_MonedaExtrangera CMON ON CMON.IdMoneda = TCH.IdMoneda

	WHERE TCH.Status not in ('G','L')
	--AND YEAR(TCH.Fecha) = @Ejercicio
	AND (TP.Fecha >= @FechaIni AND TP.Fecha <= @FechaFin)
	AND C_Bancos.IdBanco =CASE WHEN @BancoId = 0 THEN C_Bancos.IdBanco else @BancoId end 
	AND C_TipoMovPolizas.IdTipoMovimiento =CASE WHEN @TipoMov = 0 THEN C_TipoMovPolizas.IdTipoMovimiento else @TipoMov end 

	Order by TCH.IdCheques

END
GO

Exec SP_CFG_LogScripts 'RPT_SP_Pagado_Ejercicio','2.30.1'
GO

