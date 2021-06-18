
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ChequesTrasferencias]    Script Date: 07/22/2013 15:39:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ChequesTrasferencias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ChequesTrasferencias]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ChequesTrasferencias]    Script Date: 07/22/2013 15:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_K2_ChequesTrasferencias '20150101', '20151231', '31030846', 2, '', 0
CREATE PROCEDURE [dbo].[SP_RPT_K2_ChequesTrasferencias]
@FechaInicio as Datetime,
@FechaFin as Datetime,
@CuentaBancaria as Varchar(max),
@Tipo as tinyint,
@Estatus as varchar(1),
@Entregado as tinyint

AS
BEGIN
DECLARE @tabla as table (
	PorDeposito smallint,
	Fecha datetime,
	Foliocheque int,
	Beneficiario varchar(100),
	ImporteCheque decimal(11,2),
	Factura varchar(40),
	NoPoliza varchar(max),
	SolicitudEgreso smallint,
	status varchar(1) ,
	CuentaBancaria varchar(max),
	Entregado tinyint,
	TipoMovimiento Varchar(max),
	Estatus Varchar(max),
	IdSolicitudCheque int,
	IdChequesAgrupador int,
	FechaImpresion datetime,
	NumPoliza int,
	RFC varchar(max),
	Concepto varchar(max),
	CuentaContable varchar(max),
	FolioFiscal varchar(100)
)
DECLARE @TablaResultado as table (
	PorDeposito smallint,
	Fecha datetime,
	Foliocheque int,
	Beneficiario varchar(100),
	ImporteCheque decimal(11,2),
	Factura varchar(40),
	NoPoliza varchar(max),
	SolicitudEgreso smallint,
	status varchar(1) ,
	CuentaBancaria varchar(max),
	Entregado tinyint,
	TipoMovimiento Varchar(max),
	Estatus Varchar(max),
	IdSolicitudCheque int,
	IdChequesAgrupador int,
	FechaImpresion datetime,
	NumPoliza int,
	RFC varchar(max),
	Concepto varchar(max),
	CuentaContable varchar(max),
	FolioFiscal varchar(100)
)

IF @CuentaBancaria <>'' BEGIN
INSERT INTO @tabla
	SELECT  
	T_SolicitudCheques.PorDeposito,
	T_cheques.Fecha,
	T_cheques.FolioCheque, 
	T_cheques.Beneficiario,
	T_cheques.ImporteCheque,
	T_RecepcionFacturas.Factura as Factura,
	CONVERT(Varchar(max),T_Polizas.TipoPoliza) + ' ' + CONVERT(Varchar(max),T_Polizas.Periodo) + ' ' + CONVERT(Varchar(max),T_Polizas.NoPoliza) as NoPoliza,
	T_SolicitudCheques.FolioPorTipo as SolicitudEgreso,
	T_Cheques.Status,
	C_Bancos.NombreBanco+' '+ C_CuentasBancarias.CuentaBancaria  as CuentaBancaria,
	T_Cheques.Entregado,
	'' as TipoMovimiento,
	'' as Estatus,
	T_Cheques.IdSolicitudCheque,
	T_Cheques.IdChequesAgrupador,
	T_Cheques.FechaImpresion,
	T_Polizas.NoPoliza as NumPoliza,
	CASE
		WHEN T_Cheques.IdProveedor = 0 THEN C_Empleados.Rfc 
	    ELSE C_Proveedores.RFC 
	END as RFC,
	T_Cheques.ConceptoPago,
	C_Contable.NumeroCuenta,
	T_RecepcionFacturas.FolioFiscal  
	FROM T_cheques
	LEFT OUTER JOIN T_Polizas
	ON T_Polizas.IdCheque= T_Cheques.IdCheques
	LEFT OUTER JOIN T_SolicitudCheques
	ON T_SolicitudCheques.IdSolicitudCheques = T_Cheques.IdSolicitudCheque
	LEFT OUTER JOIN C_CuentasBancarias 
	ON T_Cheques.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
	--AND T_SolicitudCheques.IdCuentaBancaria= C_CuentasBancarias.IdCuentaBancaria 
	LEFT OUTER JOIN C_Bancos 
	ON C_CuentasBancarias.IdBanco=C_Bancos.IdBanco
	LEFT OUTER JOIN T_RecepcionFacturas 
	ON T_RecepcionFacturas.IdRecepcionServicios = T_SolicitudCheques.IdRecepcionServicios 
	left outer join C_Proveedores 
	ON C_Proveedores.IdProveedor=T_SolicitudCheques.IdProveedor
	left outer join R_CtasContxCtesProvEmp
	on R_CtasContxCtesProvEmp.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria  
	left outer join c_contable 
	ON R_CtasContxCtesProvEmp.IdCuentaContable=c_contable.IdCuentaContable
	left outer join C_Empleados
	ON  C_Empleados.NumeroEmpleado = T_Cheques.NumeroEmpleado
	Where T_Cheques.Fecha between @FechaInicio and @FechaFin
	--AND T_SolicitudCheques.PorDeposito=@Tipo
	AND C_CuentasBancarias.CuentaBancaria=@CuentaBancaria
	and R_CtasContxCtesProvEmp.IdTipoCuenta=45
END
ELSE BEGIN
INSERT INTO @tabla
	SELECT  
	T_SolicitudCheques.PorDeposito,
	T_cheques.Fecha,
	T_cheques.FolioCheque, 
	T_cheques.Beneficiario,
	T_cheques.ImporteCheque,
	T_RecepcionFacturas.Factura as Factura,
	CONVERT(Varchar(max),T_Polizas.TipoPoliza) + ' ' + CONVERT(Varchar(max),T_Polizas.Periodo) + ' ' + CONVERT(Varchar(max),T_Polizas.NoPoliza) as NoPoliza,
	T_SolicitudCheques.FolioPorTipo as SolicitudEgreso,
	T_Cheques.Status,
	C_Bancos.NombreBanco+' '+ C_CuentasBancarias.CuentaBancaria  as CuentaBancaria,
	T_Cheques.Entregado,
	'' as TipoMovimiento,
	'' as Estatus,
	T_Cheques.IdSolicitudCheque,
	T_Cheques.IdChequesAgrupador,
	T_Cheques.FechaImpresion,
	T_Polizas.NoPoliza as NumPoliza,
	CASE
		WHEN T_Cheques.IdProveedor = 0 THEN C_Empleados.Rfc 
	    ELSE C_Proveedores.RFC 
	END as RFC,
	T_Cheques.ConceptoPago,
	C_Contable.NumeroCuenta,
	T_RecepcionFacturas.FolioFiscal     
	FROM T_cheques
	LEFT OUTER JOIN T_Polizas
	ON T_Polizas.IdCheque= T_Cheques.IdCheques
	LEFT OUTER JOIN T_SolicitudCheques
	ON T_SolicitudCheques.IdSolicitudCheques = T_Cheques.IdSolicitudCheque
	LEFT OUTER JOIN C_CuentasBancarias 
	ON T_Cheques.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
	--AND T_SolicitudCheques.IdCuentaBancaria= C_CuentasBancarias.IdCuentaBancaria 
	LEFT OUTER JOIN C_Bancos 
	ON C_CuentasBancarias.IdBanco=C_Bancos.IdBanco
	LEFT OUTER JOIN T_RecepcionFacturas 
	ON T_RecepcionFacturas.IdRecepcionServicios = T_SolicitudCheques.IdRecepcionServicios 
	left outer join C_Proveedores 
	ON C_Proveedores.IdProveedor=T_SolicitudCheques.IdProveedor 
	left outer join R_CtasContxCtesProvEmp
	on R_CtasContxCtesProvEmp.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria  
	left outer join c_contable 
	ON R_CtasContxCtesProvEmp.IdCuentaContable=c_contable.IdCuentaContable
	left outer join C_Empleados
	ON  C_Empleados.NumeroEmpleado = T_Cheques.NumeroEmpleado 
	Where T_Cheques.Fecha between @FechaInicio and @FechaFin
	AND R_CtasContxCtesProvEmp.IdTipoCuenta=45
END
--Cheques
IF @Tipo=0 BEGIN
	--Todos
	IF @Estatus='' Begin
	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'No Generados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal 
	from @tabla a Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'G'
	
	INSERT INTO @TablaResultado SELECT a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Por Imprimir' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'C' AND IdChequesAgrupador=0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Impresos No Entregados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (status= 'I') and Foliocheque>0 and Entregado=0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Impresos Entregados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (status= 'I') and Entregado=1 and Foliocheque>0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Cancelados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status='N' and Foliocheque>0 order by CuentaBancaria, Fecha 
	
	Select * from @TablaResultado order by CuentaBancaria,Fecha 
	
	--Select * from @tabla where PorDeposito=0 and status <>'L' order by CuentaBancaria, Fecha
	End
	
	--No Generados
	IF @Estatus='G' Begin 
	INSERT INTO @TablaResultado Select * from @tabla Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'G' order by CuentaBancaria, Fecha
	UPDATE @TablaResultado Set TipoMovimiento='Cheque'
	UPDATE @TablaResultado Set Estatus= 'No Generados'
	Select * from @TablaResultado 
	--Select * from @tabla Where PorDeposito=0 AND status= 'G' and Entregado=0 order by CuentaBancaria, Fecha
	End
		
	--Por Imprimir
	IF @Estatus='C' begin 
	INSERT INTO @TablaResultado Select * from @tabla Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'C' AND IdChequesAgrupador=0 order by CuentaBancaria, Fecha
	UPDATE @TablaResultado Set TipoMovimiento='Cheque'
	UPDATE @TablaResultado Set Estatus= 'Por Imprimir'
	Select * from @TablaResultado 
	--Select * from @tabla Where PorDeposito=0 AND status= 'C' and Entregado=0 order by CuentaBancaria, Fecha
	End
	
	--Impresos No Entregados
	IF @Estatus='I'  and @Entregado=0 Begin 
	INSERT INTO @TablaResultado Select * from @tabla Where (status= 'I') and Foliocheque>0 and Entregado=0 order by CuentaBancaria, Fecha 
	UPDATE @TablaResultado Set TipoMovimiento='Cheque'
	UPDATE @TablaResultado Set Estatus= 'Impresos No Entregados'
	Select * from @TablaResultado 
	--Select * from @tabla Where PorDeposito=0 AND status= 'I' and Entregado=0 order by CuentaBancaria, Fecha
	End
	
	--Impresos Entregados
	IF @Estatus='I' and @Entregado=1 begin
	INSERT INTO @TablaResultado Select * from @tabla Where (status= 'I') and Entregado=1 and Foliocheque>0 order by CuentaBancaria, Fecha 
	UPDATE @TablaResultado Set TipoMovimiento='Cheque'
	UPDATE @TablaResultado Set Estatus= 'Impresos Entregados'
	Select * from @TablaResultado 
	--Select * from @tabla Where PorDeposito=0 AND status= 'I' and Entregado=1 order by CuentaBancaria, Fecha
	end
	
	--Cancelados
	IF @Estatus='N' begin
	INSERT INTO @TablaResultado Select * from @tabla where status='N' and Foliocheque>0 order by CuentaBancaria, Fecha
	UPDATE @TablaResultado Set TipoMovimiento='Cheque'
	UPDATE @TablaResultado Set Estatus= 'Cancelados'
	select * from @TablaResultado 
	--Select * from @tabla where PorDeposito=0 AND status='N' order by CuentaBancaria, Fecha
	end
END

--Transferencias Electronicas
IF @Tipo=1 BEGIN
	--Todos
	IF @Estatus='' begin 
	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Pendientes' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where PorDeposito=1 AND status<> 'L' and status <>'N' and IdSolicitudCheque<>0 and ImporteCheque<>0 and (NumPoliza =0 or NumPoliza is null)

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Aplicados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status= 'D' and YEAR(FechaImpresion)=year(@FechaInicio)

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Cancelados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status= 'N' and Foliocheque=0 order by CuentaBancaria, Fecha
	
	Select * from @TablaResultado order by CuentaBancaria, Fecha
	--Select * from @tabla where PorDeposito=1 AND status <> 'L' order by CuentaBancaria, Fecha
	end
	
	--Pendientes
	IF @Estatus='G' begin 
	INSERT INTO @TablaResultado Select * from @tabla where PorDeposito=1 AND status<> 'L' and status <>'N' and IdSolicitudCheque<>0 and ImporteCheque<>0 and (NumPoliza =0 or NumPoliza is null) order by CuentaBancaria, Fecha
	Update @TablaResultado Set TipoMovimiento='Transferencia Electrónica'
	UPDATE @TablaResultado Set Estatus= 'Pendientes'
	Select * from @TablaResultado 
	--Select * from @tabla where PorDeposito=1 AND status= 'G' order by CuentaBancaria, Fecha
	end
	
	--Aplicados
	IF @Estatus='D' begin 
	INSERT INTO @TablaResultado Select * from @tabla where status= 'D' and YEAR(FechaImpresion)=year(@FechaInicio) order by CuentaBancaria, Fecha
	Update @TablaResultado Set TipoMovimiento='Transferencia Electrónica'
	UPDATE @TablaResultado Set Estatus= 'Aplicados'
	Select * from @TablaResultado
	--Select * from @tabla where PorDeposito=1 AND  status= 'D'order by CuentaBancaria, Fecha
	end
	
	--Cancelados
	IF @Estatus='N' begin 
	INSERT INTO @TablaResultado Select * from @tabla where status= 'N' and Foliocheque=0 order by CuentaBancaria, Fecha
	Update @TablaResultado Set TipoMovimiento='Transferencia Electrónica'
	UPDATE @TablaResultado Set Estatus= 'Cancelados'
	Select * from @TablaResultado 
	--Select * from @tabla where PorDeposito=1 AND  status= 'N' order by CuentaBancaria, Fecha
	end
END

--TODOS (Cheques y Transferencias)
IF @Tipo=2 BEGIN
	--Cheques
	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'No Generados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal 
	from @tabla a Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'G'
	
	INSERT INTO @TablaResultado SELECT a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Por Imprimir' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (PorDeposito=0 or IdSolicitudCheque=0)AND status= 'C' AND IdChequesAgrupador=0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Impresos No Entregados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (status= 'I') and Foliocheque>0 and Entregado=0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Impresos Entregados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a Where (status= 'I') and Entregado=1 and Foliocheque>0 

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Cheque' as TipoMovimiento, 'Cancelados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status='N' and Foliocheque>0 order by CuentaBancaria, Fecha 
	
	--Transferencias
	
	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Pendientes' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where PorDeposito=1 AND status<> 'L' and status <>'N' and IdSolicitudCheque<>0 and ImporteCheque<>0 and (NumPoliza =0 or NumPoliza is null)

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Aplicados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status= 'D' and YEAR(FechaImpresion)=year(@FechaInicio)

	INSERT INTO @TablaResultado Select a.PorDeposito,a.Fecha,a.Foliocheque,a.Beneficiario,a.ImporteCheque,a.Factura,a.NoPoliza,a.SolicitudEgreso,a.status,a.CuentaBancaria,a.Entregado,	
	'Transferencia Electrónica' as TipoMovimiento, 'Cancelados' as Estatus, a.IdSolicitudCheque,a.IdChequesAgrupador,a.FechaImpresion, a.NumPoliza, a.RFC,a.Concepto,a.CuentaContable, a.FolioFiscal  
	from @tabla a where status= 'N' and Foliocheque=0 order by CuentaBancaria, Fecha
	
	Select * from @TablaResultado order by CuentaBancaria, Fecha
	--Select * from @tabla where status <> 'L' and PorDeposito >=0  order by CuentaBancaria, Fecha
END
END


GO

Exec SP_FirmasReporte 'Cheques y Transferencias'
GO


