/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ComprobacionDeGastos]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ComprobacionDeGastos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ComprobacionDeGastos]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ComprobacionDeGastos]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_ComprobacionDeGastos '11110-10001','11110-10002',1,2016
CREATE PROCEDURE [dbo].[SP_RPT_K2_ComprobacionDeGastos]   
--@NumeroCuenta nvarchar(20)
@CuentaInicio varchar(30),
@CuentaFin varchar(30),
@Mes int,
@Ejercicio int


AS BEGIN  

  declare @IdCuentaContable int
  declare @IdCuentaContable2 int
  declare @NoEmpleado int
  declare @NoEmpleado2 int

  DECLARE @Cuentas TABLE (IdCuentaContable int,NumeroCuenta varchar(100),iNumeroCuenta int)
  Declare @NoEmpleados TABLE(NoEmpleado int)


Declare @iCuentaInicio bigint    
Declare @iCuentaFin bigint    
set @iCuentaInicio= CONVERT(bigint,REPLACE(@CuentaInicio,'-',''))    
set @iCuentaFin= CONVERT(bigint,REPLACE(@CuentaFin,'-','')) 

Insert into @Cuentas
Select IdCuentaContable, NumeroCuenta, iNumeroCuenta from VW_C_Contable Where iNumeroCuenta between @iCuentaInicio and @iCuentaFin

  --Select @IdCuentaContable = (Select IdCuentaContable from C_Contable where NumeroCuenta=@CuentaInicio)
  --Select @IdCuentaContable2 = (Select IdCuentaContable from C_Contable where NumeroCuenta=@CuentaFin)

  --Select @IdCuentaContable
  --Select @NoEmpleado= (Select NumeroEmpleado from R_CtasContxCtesProvEmp where IdCuentaContable = @IdCuentaContable) --Obtener No. Empleado
  --Select @NoEmpleado2= (Select NumeroEmpleado from R_CtasContxCtesProvEmp where IdCuentaContable = @IdCuentaContable2) --Obtener No. Empleado

  Insert into @NoEmpleados
  Select ISNULL(NumeroEmpleado,0) from R_CtasContxCtesProvEmp where IdCuentaContable in (Select IdCuentaContable from @Cuentas)
  --Select * from T_Cheques where IdTipoMovimiento in (397,398,288) and NumeroEmpleado=@NoEmpleado


  select A.IdCheques,B.CuentaBancaria ,A.ImporteCheque , C.NoPoliza as Numero,convert(CHAR(10), C.Fecha, 111) as Fecha,C.TotalCargos as Monto,C.NoPoliza as Folio,C.Concepto
  --convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
   INTO #T1 from T_Cheques A 
  left join C_CuentasBancarias B on A.IdCuentaBancaria=B.IdCuentaBancaria  
  left join T_Polizas C on A.IdCheques = C.IdCheque
  where A.IdTipoMovimiento in (397,398,288) 
  and (A.NumeroEmpleado in (Select NoEmpleado from @NoEmpleados))
  and Month(C.Fecha) = @Mes
  and Year(C.Fecha) = @Ejercicio
 
  select A.IdCheques as Cheques,C.NoPoliza as NumeroD,convert(CHAR(10), C.Fecha, 111) as FechaD,C.TotalCargos as MontoD,C.NoPoliza as FolioD,C.Concepto as ConceptoD
  --convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
  INTO #T2 from T_Cheques A  
  inner join T_Viaticos B on A.IdSolicitudCheque = B.IdSolicitudChequesOriginal 
  inner join T_Polizas C on C.IdPoliza = B.IdPoliza 
  where A.IdTipoMovimiento in (397,398,288) 
  and (A.NumeroEmpleado in (Select NoEmpleado from @NoEmpleados)) 
  and  B.IdSolicitudChequesOriginal > 0
  and Month(C.Fecha) = @Mes
  and Year(C.Fecha) = @Ejercicio

  --select * from #T1
  --select * from #T2 order by cheques

  select * from #T1 a left JOIN #T2 b on a.IdCheques = b.Cheques order by IdCheques

    drop table #T1
    drop table #T2
  
END  

go 
  
  --Exec [SP_RPT_K2_ComprobacionDeGastos] '11230-20109'
  --Exec [SP_RPT_K2_ComprobacionDeGastos] '11230-20002'
  Exec SP_CFG_LogScripts 'SP_RPT_K2_ComprobacionDeGastos','2.30'
GO