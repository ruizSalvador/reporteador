
/****** Object:  StoredProcedure [dbo].[SP_RPT_ConciliacionBancaria]    Script Date: 04/11/2013 16:31:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ConciliacionBancaria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ConciliacionBancaria]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_ConciliacionBancaria]    Script Date: 04/11/2013 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_ConciliacionBancaria '0365916916','20190501','20190531'
CREATE PROCEDURE [dbo].[SP_RPT_ConciliacionBancaria]
@CuentaBancaria varchar(25), 
@FechaInicio datetime,
@FechaFin datetime
AS
BEGIN

Declare @tablaTodo as table (
		Referencia varchar(150),
		Fecha datetime,
		Concepto varchar (300),
		Cargo decimal (18,2),
	    Abono decimal (18,2),
		Importe decimal (18,2),
		TipoMov varchar (20),
		Titulo varchar (max),
		InDepConciliados Decimal (18,2),
		EgRetConciliados Decimal (18,2),
		InBancNoConsXNos Decimal (18,2),
		EgBancNoConsXNos Decimal (18,2),
		InDepNoConsXBanco Decimal (20,2),
		RetNoConsXBanco Decimal (20,2),
		SaldoInicial Decimal (20,2),
		SaldoFinBancario Decimal (18,2),
		SaldoFinContable Decimal (18,2),
		Orden Int
		
 )
-------------------------------------------NO CONCILIADOS CONTABILIDAD--------------------------------------------
Declare @tablaNoConciliados as table (
		Cuenta varchar(250),
		ChequesInversion varchar(200),
		Fecha datetime,
		Concepto varchar (Max),
		Cargo decimal(18,2),
		Abono decimal (18,2),
		SaldoFila decimal (18,2),
		Tipo varchar(250),
		Referencia varchar (250)
		
 )

 Declare @tablaNoConciliadosConta as table (
		Cuenta varchar(250),
		ChequesInversion varchar(200),
		Fecha datetime,
		Concepto varchar (Max),
		Cargo decimal(18,2),
		Abono decimal (18,2),
		SaldoFila decimal (18,2),
		Tipo varchar(250),
		Referencia varchar (250),
		InDepConciliados Decimal (18,2),
		EgRetConciliados Decimal (18,2),
		InBancNoConsXNos Decimal (18,2),
		EgBancNoConsXNos Decimal (18,2),
		InDepNoConsXBanco Decimal (18,2),
		RetNoConsXBanco Decimal (18,2)
		
 )
 
 insert into @tablaNoConciliados
Exec SP_RPT_K2_Conciliacion_MovimientosNoConciliados @CuentaBancaria,@FechaInicio,@FechaFin

insert into @tablaNoConciliadosConta
Select 
		Cuenta,
		ChequesInversion,
		Fecha,
		Concepto,
		Cargo,
		Abono,
		SaldoFila,
		Tipo,
		Referencia,
		0 as InDepConciliados,
		 0 asEgRetConciliados,
		0 as InBancNoConsXNos,
		0 as EgBancNoConsXNos,
		0 as InDepNoConsXBanco,
		0 as RetNoConsXBanco
from @tablaNoConciliados Where Tipo = 'MOVIMIENTOS NO CONCIILADOS EN CONTABILIDAD'
----------------------------------NO CONCILIADOS BANCO--------------------------------------------
Declare @tablaNoConciliadosBanco as table (
		Cuenta varchar(250),
		ChequesInversion varchar(200),
		Fecha datetime,
		Concepto varchar (Max),
		Cargo decimal(18,2),
		Abono decimal (18,2),
		SaldoFila decimal (18,2),
		Tipo varchar(250),
		Referencia varchar (250),
		InDepConciliados Decimal (18,2),
		EgRetConciliados Decimal (18,2),
		InBancNoConsXNos Decimal (18,2),
		EgBancNoConsXNos Decimal (18,2),
		InDepNoConsXBanco Decimal (18,2),
		RetNoConsXBanco Decimal (18,2)
		
 )

 insert into @tablaNoConciliadosBanco
Select 
		Cuenta,
		ChequesInversion,
		Fecha,
		Concepto,
		Cargo,
		Abono,
		SaldoFila,
		Tipo,
		Referencia,
		0 as InDepConciliados,
		 0 asEgRetConciliados,
		0 as InBancNoConsXNos,
		0 as EgBancNoConsXNos,
		0 as InDepNoConsXBanco,
		0 as RetNoConsXBanco
from @tablaNoConciliados where Tipo = 'MOVIMIENTOS NO CONCIILADOS EN EL BANCO'
----------------------------------CONCILIADOS-----------------------------------------------------
Declare @tablaConciliadosFinal as table (
		Cuenta varchar(250),
		ChequesInversion varchar(200),
		Fecha datetime,
		Concepto varchar (Max),
		Cargo decimal(18,2),
		Abono decimal (18,2),
		SaldoFila decimal (18,2),
		Tipo varchar(250),
		Referencia varchar (250)
		
 )

Declare @tablaConciliados as table (
		NombreBanco varchar(200),
		CuentaBancaria varchar(50),
		Sucursal varchar(200),
		ChequesInversion varchar(80),
		Referencia varchar(50),
		FechaContable datetime,
		Concepto varchar (300),
		FechaBancaria datetime,
		Observacion varchar(200),
		Cargo decimal (18,2),
	    Abono decimal (18,2)
		
 )

 Declare @tablaConciliados2 as table (
		--NombreBanco varchar(100),
		CuentaBancaria varchar(200),
		--Sucursal varchar(100),
		ChequesInversion varchar(60),
		Referencia varchar(20),
		FechaContable datetime,
		MovimientoContable varchar (200),
		FechaBancaria datetime,
		EstadoCuenta varchar(100),
		Cargo decimal (18,2),
	    Abono decimal (18,2),
		InDepConciliados Decimal (18,2),
		EgRetConciliados Decimal (18,2),
		InBancNoConsXNos Decimal (18,2),
		EgBancNoConsXNos Decimal (18,2),
		InDepNoConsXBanco Decimal (18,2),
		RetNoConsXBanco Decimal (18,2)
		
 )

 

Insert into @tablaConciliados 
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
T_Polizas.Fecha as FechaContable ,
D_Polizas.Concepto,
D_EstadoCuentaBancaria.Fecha as FechaBancaria,
D_EstadoCuentaBancaria.Observacion ,
D_Polizas.ImporteCargo as Cargo,
D_Polizas.ImporteAbono as Abono

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

if @cuentabancaria <> ''
begin
	insert into @tablaConciliados2
Select 

		NombreBanco +' '+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Referencia,
		FechaContable,
		Concepto,
		FechaBancaria,
		Observacion,
		Cargo,
		Abono,
		0 as InDepConciliados,
	    0 asEgRetConciliados,
		0 as InBancNoConsXNos,
		0 as EgBancNoConsXNos,
		0 as InDepNoConsXBanco,
		0 as RetNoConsXBanco
		
		FROM @TablaConciliados
		Where (FechaBancaria>= @FechaInicio and FechaBancaria <= @FechaFin  AND CuentaBancaria = @CuentaBancaria )
		   --OR (Fechacontable>= @FechaInicio and Fechacontable <= @FechaFin  AND CuentaBancaria = @CuentaBancaria )
	 
		end
		
		else
	begin
	insert into @tablaConciliados2
		Select 
		NombreBanco +' CTA.'+CuentaBancaria + ' '+Sucursal as Cuenta,
		ChequesInversion,
		Referencia,
		FechaContable,
		Concepto,
		FechaBancaria,
		Observacion,
		Cargo,
		Abono,
		0 as InDepConciliados,
	    0 asEgRetConciliados,
		0 as InBancNoConsXNos,
		0 as EgBancNoConsXNos,
		0 as InDepNoConsXBanco,
		0 as RetNoConsXBanco
		
		FROM @TablaConciliados
		Where (FechaBancaria>= @FechaInicio and FechaBancaria <= @FechaFin  )
		--and (Fechacontable>= @FechaInicio and Fechacontable <= @FechaFin )
		
		end

Insert into @tablaTodo

Select Referencia,
		FechaContable, 
		MovimientoContable,
		Cargo,
		Abono,
		CASE
		WHEN Abono = 0 Then Cargo
		ELSE Abono
		End as Importe,		
		CASE
		WHEN Abono = 0 THEN 'ABONO'
		WHEN Cargo = 0 THEN 'CARGO'
		END AS TipoMov,
		CASE 
		 WHEN Abono = 0 Then 'DEPOSITOS BANCARIOS CONCILIADOS'
		 WHEN Cargo = 0 Then 'RETIROS BANCARIOS CONCILIADOS'
		 END AS Titulo,
		 InDepConciliados,
	    EgRetConciliados,
		 InBancNoConsXNos,
		 EgBancNoConsXNos,
		 InDepNoConsXBanco,
		 RetNoConsXBanco,
		0 as SaldoInicial,
		0 as SaldoFinBancario,
		0 as SaldoFinContable,
		0 as Orden
		From @tablaConciliados2
	
		UNION ALL

Select Referencia,
		Fecha, 
		Concepto,
		Cargo,
		Abono,
		--Tipo,
		CASE
		WHEN Abono = 0 Then Cargo
		ELSE Abono
		End as Importe,		
		CASE
		WHEN  Abono = 0 THEN 'ABONO'
		WHEN  Cargo = 0 THEN 'CARGO'
		END AS TipoMov,
		CASE 
		 WHEN Abono = 0 Then 'INGRESOS CONTABLES NO CONCILIADOS'
		 WHEN Cargo = 0 Then 'EGRESOS CONTABLES NO CONCILIADOS'
		 END AS Titulo,
		 InDepConciliados,
	     EgRetConciliados,
		 InBancNoConsXNos,
		 EgBancNoConsXNos,
		 InDepNoConsXBanco,
		 RetNoConsXBanco,
		 0 as SaldoInicial,
		0 as SaldoFinBancario,
		0 as SaldoFinContable,
		0 as Orden
		From @tablaNoConciliadosConta --Where Importe >=0
		--order by TipoMov

UNION ALL

Select Referencia,
		Fecha, 
		Concepto,
		Cargo,
		Abono,
		--Tipo,
		CASE
		WHEN Abono = 0 Then Cargo
		ELSE Abono
		End as Importe,		
		CASE
		WHEN  Abono = 0 THEN 'ABONO'
		WHEN  Cargo = 0 THEN 'CARGO'
		END AS TipoMov,
		CASE 
		 WHEN Abono = 0 Then 'RETIROS BANCARIOS  NO CONSIDERADOS POR NOSOTROS'
		 WHEN Cargo = 0 Then 'DEPOSITOS BANCARIOS NO CONSIDERADOS POR NOSOTROS'
		 END AS Titulo,
		 InDepConciliados,
	     EgRetConciliados,
		 InBancNoConsXNos,
		 EgBancNoConsXNos,
		 InDepNoConsXBanco,
		 RetNoConsXBanco,
		 0 as SaldoInicial,
		0 as SaldoFinBancario,
		0 as SaldoFinContable,
		0 as Orden
		From @tablaNoConciliadosBanco
		--order by Titulo




Update @tablaTodo set InDepNoConsXBanco = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'INGRESOS CONTABLES NO CONCILIADOS')
Update @tablaTodo set  Orden = 3 Where Titulo = 'INGRESOS CONTABLES NO CONCILIADOS'
Update @tablaTodo set RetNoConsXBanco = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'EGRESOS CONTABLES NO CONCILIADOS')
Update @tablaTodo set Orden = 4 Where Titulo = 'EGRESOS CONTABLES NO CONCILIADOS'
Update @tablaTodo set InDepConciliados = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'DEPOSITOS BANCARIOS CONCILIADOS')
Update @tablaTodo set Orden = 1 Where Titulo = 'DEPOSITOS BANCARIOS CONCILIADOS'
Update @tablaTodo set EgRetConciliados = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'RETIROS BANCARIOS CONCILIADOS')
Update @tablaTodo set Orden = 2 Where Titulo = 'RETIROS BANCARIOS CONCILIADOS'
Update @tablaTodo set InBancNoConsXNos = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'DEPOSITOS BANCARIOS NO CONSIDERADOS POR NOSOTROS')
Update @tablaTodo set Orden = 5 Where Titulo = 'DEPOSITOS BANCARIOS NO CONSIDERADOS POR NOSOTROS'
Update @tablaTodo set EgBancNoConsXNos = (Select IsNull(Sum(Importe),0) from @tablaTodo Where Titulo = 'RETIROS BANCARIOS  NO CONSIDERADOS POR NOSOTROS')
Update @tablaTodo set Orden = 6 Where Titulo = 'RETIROS BANCARIOS  NO CONSIDERADOS POR NOSOTROS'
If exists (Select Isnull(SaldoInicial,0) from T_EstadoCuentaBancario Inner Join  C_CuentasBancarias on T_EstadoCuentaBancario.idcuentabancaria= c_cuentasbancarias.IdCuentaBancaria where CuentaBancaria = @CuentaBancaria and Mes = Month(@FechaInicio))
Begin 
Update @tablaTodo set SaldoInicial = (Select Isnull(SaldoInicial,0) from T_EstadoCuentaBancario Inner Join  C_CuentasBancarias on T_EstadoCuentaBancario.idcuentabancaria= c_cuentasbancarias.IdCuentaBancaria where CuentaBancaria = @CuentaBancaria and Mes = Month(@FechaInicio))
end
Else
Begin
Update @tablaTodo set SaldoInicial = 0
End 
Update @tablaTodo set SaldoFinBancario = (SaldoInicial + InDepConciliados)  - (EgRetConciliados) 
Update @tablaTodo set SaldoFinContable = (SaldoFinBancario + InDepNoConsXBanco) - RetNoConsXBanco

Select * from @tablaTodo Where Importe >=0 order by Orden asc

END
GO
Exec SP_CFG_LogScripts 'SP_RPT_ConciliacionBancaria','2.29'
GO