/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Ingresos]    Script Date: 11/14/2014 13:46:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Ingresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Ingresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Ingresos]    Script Date: 11/14/2014 13:46:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Ingresos]
@FechaInicio date, @FechaFin date, @Tipo int,@CuentaBancaria varchar(max)

AS

Declare @tabla table(
Id int,
Tipo int,
Fecha date,
Cuenta varchar(max),
Concepto varchar(max),
Importe decimal(15,2),
Origen varchar(20),
EjercicioAnterior varchar(max),
ClaveConcepto varchar(max),
Cliente varchar(max),
FolioDocumento int,
NoPoliza Int,
AfectacionPresupuestal varchar(max),
ClavePartida varchar(max),
DescripcionCuenta varchar(max),
NombreBanco Varchar(max)
)

if @tipo is null or @tipo=1 begin
--FACTURAS
insert @tabla
select D_Ingresos.Id, 
D_Ingresos.Tipo,
D_Ingresos.Fecha,
D_Ingresos.Cuenta,
D_Ingresos.Concepto,
D_Ingresos.Importe,
D_Ingresos.Origen,
CASE D_Ingresos.EjercicioAnterior
WHEN 1 THEN 'Si'
WHEN 0 THEN 'No' end as EjercicioAnterior,
D_Ingresos.ClaveConcepto,
C_Clientes.RazonSocial,
t_facturas.Folio,
T_Polizas.NoPoliza,
case T_Tarifario.AfectacionPresupuestal
when 3 then 'Con Afectación Presupuestal'
when 2 then 'Sin Afectación Presupuestal' end as AfectacionPresupuestal,
C_PartidasGastosIngresos.Clave,
C_TipoCuentas.Descripcion,
C_Bancos.NombreBanco  
from D_Ingresos
left JOIN t_facturas 
ON T_Facturas.IdFactura=D_Ingresos.IdFactura
JOIN T_Tarifario
ON T_Tarifario.ClaveSistemaIngresos = D_Ingresos.ClaveConcepto 
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas 
ON C_TipoCuentas.IdTipoCuenta =T_Tarifario.IdTipoCuenta 
LEFT OUTER JOIN C_Clientes
ON C_Clientes.IdCliente=D_Ingresos.IdCliente 
LEFT OUTER JOIN T_Polizas
ON T_Polizas.IdPoliza=T_Facturas.IdPoliza 
LEFT OUTER JOIN C_CuentasBancarias 
ON C_CuentasBancarias.CuentaBancaria =D_Ingresos.Cuenta
LEFT OUTER JOIN C_Bancos 
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco
Where (D_Ingresos.Fecha BETWEEN @FechaInicio AND @FechaFin) AND D_Ingresos.Cuenta=isnull(@CuentaBancaria,D_Ingresos.Cuenta)
and D_Ingresos.Tipo=1
-------------------------------------------------------
end
if @tipo is null or @tipo=2 begin
--Recibos Caja
insert @tabla
select D_Ingresos.Id, 
D_Ingresos.Tipo,
D_Ingresos.Fecha,
D_Ingresos.Cuenta,
D_Ingresos.Concepto,
D_Ingresos.Importe,
D_Ingresos.Origen,
CASE D_Ingresos.EjercicioAnterior
WHEN 1 THEN 'Si'
WHEN 0 THEN 'No' end as EjercicioAnterior,
D_Ingresos.ClaveConcepto, 
C_Clientes.RazonSocial,
T_RecibosCaja.Folio,
T_Polizas.NoPoliza,
case T_Tarifario.AfectacionPresupuestal
when 3 then 'Con Afectación Presupuestal'
when 2 then 'Sin Afectación Presupuestal' end as AfectacionPresupuestal,
C_PartidasGastosIngresos.Clave,
C_TipoCuentas.Descripcion,
C_Bancos.NombreBanco   
from D_Ingresos
left JOIN T_RecibosCaja 
ON T_RecibosCaja.IdIngreso=D_Ingresos.IdRecibo 
JOIN T_Tarifario
ON T_Tarifario.ClaveSistemaIngresos = D_Ingresos.ClaveConcepto 
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas 
ON C_TipoCuentas.IdTipoCuenta =T_Tarifario.IdTipoCuenta 
LEFT OUTER JOIN C_Clientes
ON C_Clientes.IdCliente=D_Ingresos.IdCliente 
LEFT OUTER JOIN T_Polizas
ON T_Polizas.IdPoliza=T_RecibosCaja.IdPoliza 
LEFT OUTER JOIN C_CuentasBancarias 
ON C_CuentasBancarias.CuentaBancaria =D_Ingresos.Cuenta
LEFT OUTER JOIN C_Bancos 
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco
Where (D_Ingresos.Fecha BETWEEN @FechaInicio AND @FechaFin) AND D_Ingresos.Cuenta=isnull(@CuentaBancaria,D_Ingresos.Cuenta)
AND D_Ingresos.Tipo=2
----------------------------------------------------------------------
end
if @tipo is null or @tipo=3 begin
--NOTA DE CREDITO
insert @tabla
select D_Ingresos.Id, 
D_Ingresos.Tipo,
D_Ingresos.Fecha,
D_Ingresos.Cuenta,
D_Ingresos.Concepto,
D_Ingresos.Importe,
D_Ingresos.Origen,
CASE D_Ingresos.EjercicioAnterior
WHEN 1 THEN 'Si'
WHEN 0 THEN 'No' end as EjercicioAnterior,
D_Ingresos.ClaveConcepto, 
C_Clientes.RazonSocial,
T_NotaCredito.Folio,
T_Polizas.NoPoliza,
case T_Tarifario.AfectacionPresupuestal
when 3 then 'Con Afectación Presupuestal'
when 2 then 'Sin Afectación Presupuestal' end as AfectacionPresupuestal,
C_PartidasGastosIngresos.Clave,
C_TipoCuentas.Descripcion,
C_Bancos.NombreBanco   
from D_Ingresos
left JOIN T_NotaCredito 
ON T_NotaCredito.IdNotaCredito=D_Ingresos.IdNotaCredito 
JOIN T_Tarifario
ON T_Tarifario.ClaveSistemaIngresos = D_Ingresos.ClaveConcepto 
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas 
ON C_TipoCuentas.IdTipoCuenta =T_Tarifario.IdTipoCuenta
JOIN C_Clientes
ON C_Clientes.IdCliente=D_Ingresos.IdCliente 
LEFT OUTER JOIN T_Polizas
ON T_Polizas.IdPoliza=T_NotaCredito.IdPoliza 
LEFT OUTER JOIN C_CuentasBancarias 
ON C_CuentasBancarias.CuentaBancaria =D_Ingresos.Cuenta
LEFT OUTER JOIN C_Bancos 
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco
Where (D_Ingresos.Fecha BETWEEN @FechaInicio AND @FechaFin) AND D_Ingresos.Cuenta=isnull(@CuentaBancaria,D_Ingresos.Cuenta)
AND D_Ingresos.Tipo=3
--------------------------------------------- 
end
if @tipo is null or @tipo=4 begin
--FACTURAS
insert @tabla
select D_Ingresos.Id, 
D_Ingresos.Tipo,
D_Ingresos.Fecha,
D_Ingresos.Cuenta,
D_Ingresos.Concepto,
D_Ingresos.Importe,
D_Ingresos.Origen,
CASE D_Ingresos.EjercicioAnterior
WHEN 1 THEN 'Si'
WHEN 0 THEN 'No' end as EjercicioAnterior,
D_Ingresos.ClaveConcepto,
C_Clientes.RazonSocial,
t_facturas.Folio,
T_Polizas.NoPoliza,
case T_Tarifario.AfectacionPresupuestal
when 3 then 'Con Afectación Presupuestal'
when 2 then 'Sin Afectación Presupuestal' end as AfectacionPresupuestal,
C_PartidasGastosIngresos.Clave,
C_TipoCuentas.Descripcion,
C_Bancos.NombreBanco   
from D_Ingresos
left JOIN t_facturas 
ON T_Facturas.IdFactura=D_Ingresos.IdFactura
JOIN T_Tarifario
ON T_Tarifario.ClaveSistemaIngresos = D_Ingresos.ClaveConcepto 
JOIN C_PartidasGastosIngresos
ON C_PartidasGastosIngresos.IdPartidaGI=T_Tarifario.IdPartidaGI
JOIN C_TipoCuentas 
ON C_TipoCuentas.IdTipoCuenta =T_Tarifario.IdTipoCuenta 
JOIN C_Clientes
ON C_Clientes.IdCliente=D_Ingresos.IdCliente 
LEFT OUTER JOIN T_Polizas
ON T_Polizas.IdPoliza=t_facturas.IdPoliza 
LEFT OUTER JOIN C_CuentasBancarias 
ON C_CuentasBancarias.CuentaBancaria =D_Ingresos.Cuenta
LEFT OUTER JOIN C_Bancos 
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco
Where (D_Ingresos.Fecha BETWEEN @FechaInicio AND @FechaFin) AND D_Ingresos.Cuenta=isnull(@CuentaBancaria,D_Ingresos.Cuenta)
and D_Ingresos.Tipo=4
-------------------------------------------------------
end
select * from @tabla 

GO

EXEC SP_FirmasReporte 'Reporte Ingresos'
GO

