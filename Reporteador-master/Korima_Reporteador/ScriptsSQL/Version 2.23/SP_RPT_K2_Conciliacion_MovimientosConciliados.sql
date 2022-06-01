/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conciliacion_MovimientosConciliados]    Script Date: 04/10/2013 18:03:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Conciliacion_MovimientosConciliados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Conciliacion_MovimientosConciliados]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Conciliacion_MovimientosConciliados]    Script Date: 04/10/2013 18:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_Conciliacion_MovimientosConciliados '0102022702','2016','20160131'
CREATE PROCEDURE [dbo].[SP_RPT_K2_Conciliacion_MovimientosConciliados]
@CuentaBancaria varchar(15), 
@FechaInicio datetime,
@FechaFin datetime
AS
BEGIN
Declare @tabla as table (
		NombreBanco varchar(100),
		CuentaBancaria varchar(30),
		Sucursal varchar(100),
		ChequesInversion varchar(60),
		Referencia varchar(20),
		FechaContable datetime,
		MovimientoContable varchar (200),
		FechaBancaria datetime,
		EstadoCuenta varchar(100),
		Importe decimal (13,2)
		
 )

Insert into @tabla 
SELECT distinct
C_Bancos.NombreBanco, 
C_cuentasbancarias.CuentaBancaria,
C_cuentasbancarias.Sucursal,
CASE c_cuentasbancarias.Chequesinversion when 'A' then 'CUENTA DE CHEQUES' 
When 'I' then 'CUENTA DE INVERSIÓN' 
When 'V' then 'CUENTA VIRTUAL' 
When 'F' then 'CUENTA DE FONDO REVOLVENTE' 
When 'N' then 'CUENTA CANCELADA' 
end as ChequesInversion ,
D_EstadoCuentaBancaria.Referencia,
T_Polizas.Fecha ,
D_Polizas.Concepto,
D_EstadoCuentaBancaria.Fecha,
D_EstadoCuentaBancaria.Observacion ,
D_EstadoCuentaBancaria.Importe 

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
where D_EstadoCuentaBancaria.conciliado=1


--Select @CuentaBancaria
if @cuentabancaria <> ''
begin
Select 

		NombreBanco +' '+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Referencia,
		FechaContable,
		MovimientoContable,
		FechaBancaria,
		EstadoCuenta,
		Importe
		
		FROM @Tabla
		Where (Fechacontable between @FechaInicio and @FechaFin  AND CuentaBancaria = @CuentaBancaria )
		OR (FechaBancaria  between @FechaInicio and @FechaFin AND CuentaBancaria = @CuentaBancaria )
	 
		end
		
		else
		begin
		Select 

		NombreBanco +' CTA.'+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Referencia,
		FechaContable,
		MovimientoContable,
		FechaBancaria,
		EstadoCuenta,
		Importe
		
		FROM @Tabla
		Where (Fechacontable between @FechaInicio and @FechaFin  )
		and (FechaBancaria  between @FechaInicio and @FechaFin )
		
		end

END

GO

EXEC SP_FirmasReporte 'Conciliacion Movimientos Conciliados'
GO
