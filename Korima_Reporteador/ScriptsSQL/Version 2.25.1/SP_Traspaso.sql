/****** Object:  StoredProcedure [dbo].[SP_Traspaso]    Script Date: 02/01/2017 11:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Traspaso]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Traspaso]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Traspaso]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                        
CREATE PROCEDURE [dbo].[SP_Traspaso]


@FechaInicio as Datetime,
@FechaFin as Datetime,
@CuentaBancaria as Varchar(max),
@reporte as int
	
AS
BEGIN



DECLARE @tamaño int
set @tamaño = len(@CuentaBancaria)


 
IF (@reporte = 1 and @tamaño > 5)begin 

--IF (@CuentaBancaria IS NOT NULL) begin 

DECLARE @VariableTabla TABLE (  
idUnicoTraspaso varchar(max),
Fecha varchar(max),
Importe varchar(max),
CuentaBancaria varchar(max),
Sucursal varchar(max),
ChequesInversion varchar(max) ,
CuentaBancariaDestino varchar(max),
SucursalDestino varchar(max),
ChequesInversionDestino varchar(max)
 )

 


insert @VariableTabla
SELECT idUnicoTraspaso,Fecha,Importe,
uno.CuentaBancaria,
uno.Sucursal,
uno.ChequesInversion,
dos.CuentaBancaria as CuentaBancariaDestino,
dos.Sucursal as SucursalDestino,dos.ChequesInversion  
FROM T_TraspasosBancarios 
INNER JOIN c_cuentasbancarias uno
 on T_TraspasosBancarios.IdCuentaBancariaOrigen = uno.IdCuentaBancaria
 inner join c_cuentasbancarias dos on T_TraspasosBancarios.IdCuentaBancariaDestino = dos.IdCuentaBancaria 
 
 
 

  where Fecha between @FechaInicio and @FechaFin and uno.CuentaBancaria = @CuentaBancaria
  
 
  

  UPDATE @VariableTabla SET ChequesInversion = 'CHEQUES' WHERE ChequesInversion = 'A';

  UPDATE @VariableTabla SET ChequesInversion = 'INVERSION' WHERE ChequesInversion = 'I';

  UPDATE @VariableTabla SET ChequesInversion = 'VIRTUAL' WHERE ChequesInversion = 'V';


 
  UPDATE @VariableTabla SET ChequesInversionDestino = 'CHEQUES' WHERE ChequesInversionDestino = 'A';

  UPDATE @VariableTabla SET ChequesInversionDestino = 'INVERSION' WHERE ChequesInversionDestino = 'I';

  UPDATE @VariableTabla SET ChequesInversionDestino = 'VIRTUAL' WHERE ChequesInversionDestino = 'V';



select * from @VariableTabla

END




IF (@reporte = 1 and @tamaño < 5)begin 

DECLARE @VariableTabla1 TABLE (  
idUnicoTraspaso varchar(max),
Fecha varchar(max),
Importe varchar(max),
CuentaBancaria varchar(max),
Sucursal varchar(max),
ChequesInversion varchar(max) ,
CuentaBancariaDestino varchar(max),
SucursalDestino varchar(max),
ChequesInversionDestino varchar(max)
 )

 


insert @VariableTabla1
SELECT idUnicoTraspaso,Fecha,Importe,
uno.CuentaBancaria,
uno.Sucursal,
uno.ChequesInversion,
dos.CuentaBancaria as CuentaBancariaDestino,
dos.Sucursal as SucursalDestino,dos.ChequesInversion  
FROM T_TraspasosBancarios 
INNER JOIN c_cuentasbancarias uno
 on T_TraspasosBancarios.IdCuentaBancariaOrigen = uno.IdCuentaBancaria
 inner join c_cuentasbancarias dos on T_TraspasosBancarios.IdCuentaBancariaDestino = dos.IdCuentaBancaria 
 where Fecha between @FechaInicio and @FechaFin ---and uno.CuentaBancaria = @CuentaBancaria
  
 
  

  UPDATE @VariableTabla1 SET ChequesInversion = 'CHEQUES' WHERE ChequesInversion = 'A';

  UPDATE @VariableTabla1 SET ChequesInversion = 'INVERSION' WHERE ChequesInversion = 'I';

  UPDATE @VariableTabla1 SET ChequesInversion = 'VIRTUAL' WHERE ChequesInversion = 'V';


 
  UPDATE @VariableTabla1 SET ChequesInversionDestino = 'CHEQUES' WHERE ChequesInversionDestino = 'A';

  UPDATE @VariableTabla1 SET ChequesInversionDestino = 'INVERSION' WHERE ChequesInversionDestino = 'I';

  UPDATE @VariableTabla1 SET ChequesInversionDestino = 'VIRTUAL' WHERE ChequesInversionDestino = 'V';



select * from @VariableTabla1

END


IF (@reporte = 2 and @tamaño > 5)BEGIN

DECLARE @VariableTabla2 TABLE (  
Sucursal varchar(max),
CuentaBancaria varchar(max),
Saldo varchar(max),
FechaINVERSION varchar(max),
Dias varchar(max),
FechaVencimiento varchar(max),
TasaInteresBruta varchar(max),
CapitalMasIntereses varchar(max)
)

 




insert @VariableTabla2
SELECT 
uno.Sucursal ,
CuentaBancaria, 
SaldoActual,
Fecha ,
DiasInteres,
FinInversion,
TasaInteresBruta,
RendimientoTotal
FROM T_Inversiones INNER JOIN c_cuentasbancarias uno on T_Inversiones.IdCuentaBancaria =  uno.IdCuentaBancaria
where Fecha between @FechaInicio and @FechaFin and uno.CuentaBancaria = @CuentaBancaria


select * from @VariableTabla2 




END



IF (@reporte = 2 and @tamaño < 5)BEGIN

DECLARE @VariableTabla22 TABLE (  
Sucursal varchar(max),
CuentaBancaria varchar(max),
Saldo varchar(max),
FechaINVERSION varchar(max),
Dias varchar(max),
FechaVencimiento varchar(max),
TasaInteresBruta varchar(max),
CapitalMasIntereses varchar(max)
)

 




insert @VariableTabla22
SELECT 
uno.Sucursal ,
CuentaBancaria, 
SaldoActual,
Fecha ,
DiasInteres,
FinInversion,
TasaInteresBruta,
RendimientoTotal
FROM T_Inversiones INNER JOIN c_cuentasbancarias uno on T_Inversiones.IdCuentaBancaria =  uno.IdCuentaBancaria
where Fecha between @FechaInicio and @FechaFin 


select * from @VariableTabla22 


END
	
END

EXEC SP_FirmasReporte 'SP_Traspaso'
GO

Exec SP_CFG_LogScripts 'Jose Raygoza Ochoa'
GO

