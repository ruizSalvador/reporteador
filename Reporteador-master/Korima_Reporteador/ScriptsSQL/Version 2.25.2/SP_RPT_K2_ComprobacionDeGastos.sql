
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ComprobacionDeGastos]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ComprobacionDeGastos]   ') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ComprobacionDeGastos]  
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ComprobacionDeGastos]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

CREATE PROCEDURE [dbo].[SP_RPT_K2_ComprobacionDeGastos]   
@NumeroCuenta nvarchar(20)
AS BEGIN  

  declare @IdCuentaContable int
  declare @NoEmpleado int

  Select @IdCuentaContable = (Select IdCuentaContable from C_Contable where NumeroCuenta=@NumeroCuenta)
  --Select @IdCuentaContable
  Select @NoEmpleado= (Select NumeroEmpleado from R_CtasContxCtesProvEmp where IdCuentaContable = @IdCuentaContable) --Obtener No. Empleado
  --Select @NoEmpleado
 
  --Select * from T_Cheques where IdTipoMovimiento in (397,398,288) and NumeroEmpleado=@NoEmpleado

  select A.IdCheques,B.CuentaBancaria ,A.ImporteCheque , C.NoPoliza as Numero,convert(CHAR(10), C.Fecha, 111) as Fecha,C.TotalCargos as Monto,C.NoPoliza as Folio,C.Concepto
   INTO #T1 from T_Cheques A 
  left join C_CuentasBancarias B on A.IdCuentaBancaria=B.IdCuentaBancaria  
  left join T_Polizas C on A.IdCheques = C.IdCheque
  where A.IdTipoMovimiento in (397,398,288) and A.NumeroEmpleado=@NoEmpleado
 
  select A.IdCheques as Cheques,C.NoPoliza as NumeroD,convert(CHAR(10), C.Fecha, 111) as FechaD,C.TotalCargos as MontoD,C.NoPoliza as FolioD,C.Concepto as ConceptoD
  INTO #T2 from T_Cheques A  
  inner join T_Viaticos B on A.IdSolicitudCheque = B.IdSolicitudChequesOriginal 
  inner join T_Polizas C on C.IdPoliza = B.IdPoliza 
  where A.IdTipoMovimiento in (397,398,288) and A.NumeroEmpleado=@NoEmpleado and  B.IdSolicitudChequesOriginal > 0

  --select * from #T1
  --select * from #T2 order by cheques

  select * from #T1 a left JOIN #T2 b on a.IdCheques = b.Cheques order by IdCheques

    drop table #T1
    drop table #T2
  
END  

go 
  
  --Exec [SP_RPT_K2_ComprobacionDeGastos] '11230-20109'
  --Exec [SP_RPT_K2_ComprobacionDeGastos] '11230-20002'