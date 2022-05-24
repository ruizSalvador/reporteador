/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conciliacion_MovimientosNoConciliados]    Script Date: 04/11/2013 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Conciliacion_MovimientosNoConciliados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Conciliacion_MovimientosNoConciliados]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conciliacion_MovimientosNoConciliados]    Script Date: 04/11/2013 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_Conciliacion_MovimientosNoConciliados '','20160501','20160531'
CREATE PROCEDURE [dbo].[SP_RPT_K2_Conciliacion_MovimientosNoConciliados]
@CuentaBancaria varchar(15), 
@FechaInicio datetime,
@FechaFin datetime
AS
BEGIN
Declare @tabla as table (
		NombreBanco varchar(100),
		CuentaBancaria varchar(30),
		Sucursal varchar(100),
		ChequesInversion varchar(100),
		Fecha datetime,
		Concepto varchar (Max),
		Cargo decimal(13,2),
		Abono decimal (13,2),
		--Importe decimal (13,2),
		Tipo varchar(150),
		Referencia varchar (50)
		
 )

Insert into @tabla 
SELECT
C_Bancos.NombreBanco, 
c_cuentasbancarias.CuentaBancaria,
c_cuentasbancarias.Sucursal,
CASE c_cuentasbancarias.Chequesinversion when 'A' then 'CUENTA DE CHEQUES' 
When 'I' then 'CUENTA DE INVERSIÓN' 
When 'V' then 'CUENTA VIRTUAL' 
When 'F' then 'CUENTA DE FONDO REVOLVENTE' 
When 'N' then 'CUENTA CANCELADA' 
end as ChequesInversion ,
T_Polizas.Fecha as fecha,
D_Polizas.Concepto as concepto,
D_Polizas.ImporteCargo as cargo,
D_polizas.ImporteAbono as Abono,
--D_EstadoCuentaBancaria.Importe,
'MOVIMIENTOS NO CONCIILADOS EN CONTABILIDAD'  as Tipo,
D_Polizas.Referencia
from T_Polizas
join D_Polizas on
T_Polizas.IdPoliza=D_Polizas.IdPoliza
join C_Contable
on D_Polizas.IdCuentaContable=C_Contable.IdCuentaContable 
join R_CtasContxCtesProvEmp
on C_Contable.IdCuentaContable= R_CtasContxCtesProvEmp.IdCuentaContable 
join C_CuentasBancarias
on R_CtasContxCtesProvEmp.IdCuentaBancaria=C_CuentasBancarias.IdCuentaBancaria 
join C_Bancos
on C_CuentasBancarias.IdBanco=C_Bancos.IdBanco 
----------------------------
where T_Polizas.NoPoliza > 0 and (T_Polizas.IdPolizaCancelacion = 0 or T_Polizas.IdPolizaCancelacion is null) and D_Polizas.IddPoliza not in (
--select IdPoliza from D_Conciliacion)
select D_Polizas.IddPoliza
from T_EstadoCuentaBancario 
inner  join D_EstadoCuentaBancaria 
on T_EstadoCuentaBancario.IdEstadoCuentaBancario = D_EstadoCuentaBancaria.IdEstadoCuentaBancario
inner join T_Conciliacion  
on D_EstadoCuentaBancaria.IdConciliacion  = T_Conciliacion.IdConciliacion 
inner join C_ConceptoEstadoCuentaBancario
on D_EstadoCuentaBancaria.IdConcepto = C_ConceptoEstadoCuentaBancario.IdConcepto 
left join D_Conciliacion 
on D_Conciliacion.IdUnicoEdoCta = D_EstadoCuentaBancaria.IdUnicoEdoCta
left join D_Polizas 
on D_Conciliacion.IdPoliza = D_Polizas.IdDPoliza 
join C_CuentasBancarias 
on T_EstadoCuentaBancario.idcuentabancaria= c_cuentasbancarias.IdCuentaBancaria 
JOIN C_Bancos
on C_CuentasBancarias.IdBanco=C_bancos.idbanco
join T_Polizas 
on D_polizas.idpoliza=T_Polizas.IdPoliza 
where D_EstadoCuentaBancaria.conciliado=1)
---------------------------------------------------

UNION ALL
SELECT
C_Bancos.NombreBanco, 
c_cuentasbancarias.CuentaBancaria,
c_cuentasbancarias.Sucursal,
CASE c_cuentasbancarias.Chequesinversion when 'A' then 'CUENTA DE CHEQUES' 
When 'I' then 'CUENTA DE INVERSIÓN' 
When 'V' then 'CUENTA VIRTUAL' 
When 'F' then 'CUENTA DE FONDO REVOLVENTE' 
When 'N' then 'CUENTA CANCELADA' 
end as ChequesInversion ,
D_EstadoCuentaBancaria.Fecha as fecha,
D_EstadoCuentaBancaria.Observacion as concepto,
case C_ConceptoEstadoCuentaBancario.Tipo when 'C' then Importe else 0 end as Cargo,
case C_ConceptoEstadoCuentaBancario.Tipo when 'A' then Importe else 0 end as Abono,
--D_EstadoCuentaBancaria.Importe,
'MOVIMIENTOS NO CONCIILADOS EN EL BANCO'  as Tipo,
D_EstadoCuentaBancaria.Referencia 

from T_EstadoCuentaBancario 
inner join D_EstadoCuentaBancaria 
on T_EstadoCuentaBancario.IdEstadoCuentaBancario = D_EstadoCuentaBancaria.IdEstadoCuentaBancario
inner join C_ConceptoEstadoCuentaBancario
on D_EstadoCuentaBancaria.IdConcepto = C_ConceptoEstadoCuentaBancario.IdConcepto
--left join D_Conciliacion 
--on D_Conciliacion.IdUnicoEdoCta = D_EstadoCuentaBancaria.IdUnicoEdoCta
--left join D_Polizas 
--on D_Conciliacion.IdPoliza = D_Polizas.IdDPoliza 
join C_CuentasBancarias 
on T_EstadoCuentaBancario.idcuentabancaria= c_cuentasbancarias.IdCuentaBancaria 
--join t_conciliacion on  c_cuentasbancarias.IdCuentaBancaria= T_Conciliacion.IdCuentaBancaria 
JOIN C_Bancos
on C_CuentasBancarias.IdBanco=C_bancos.idbanco
--join T_Polizas 
--on d_polizas.idpoliza=T_Polizas.IdPoliza 
where D_EstadoCuentaBancaria.conciliado=0

order by tipo


--Select * from @Tabla where Concepto like 'COMPUEX%'
if @cuentabancaria <> ''
begin
Select distinct

		NombreBanco +' '+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Fecha,
		Concepto,
		Cargo,
		Abono,
		(Abono-Cargo)as SaldoFila,
		--Importe,
		Tipo,
		Referencia
		
		FROM @Tabla
		Where (Fecha between @FechaInicio and @FechaFin  )
		AND CuentaBancaria = @CuentaBancaria 
		end
		
	else
		begin
		Select 

		NombreBanco +' '+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Fecha,
		Concepto,
		Cargo,
		Abono,
		(Abono-Cargo)as SaldoFila,
		--Importe,
		Tipo,
		Referencia
		
		FROM @Tabla
		Where (Fecha >= @FechaInicio and Fecha <=@FechaFin)
		
		end

END


GO
EXEC SP_FirmasReporte 'Conciliacion Movimientos No Conciliados'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_Conciliacion_MovimientosNoConciliados','2.30.1'
GO


