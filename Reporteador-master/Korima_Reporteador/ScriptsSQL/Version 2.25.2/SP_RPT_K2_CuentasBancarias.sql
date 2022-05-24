
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasBancarias]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_CuentasBancarias]   ') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_CuentasBancarias]  
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasBancarias]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

CREATE PROCEDURE [dbo].[SP_RPT_K2_CuentasBancarias]   
@Ejercicio int,
@Periodo int
AS BEGIN  
  
Declare @tabla table(    
NombreBanco varchar(30),  
CuentaBancaria varchar(15),  
Saldo decimal(18,2)  
)  

INSERT INTO @tabla   
SELECT C_Bancos.NombreBanco,C_CuentasBancarias.CuentaBancaria,  
       (T_SaldosInicialesCont.CargosSinFlujo- T_SaldosInicialesCont.AbonosSinFlujo)+(T_SaldosInicialesCont.TotalCargos-T_SaldosInicialesCont.TotalAbonos) as Saldo
FROM C_Bancos  
JOIN C_CuentasBancarias  
ON C_CuentasBancarias.IdBanco =C_Bancos.IdBanco 
JOIN R_CtasContxCtesProvEmp
ON C_CuentasBancarias.IdCuentaBancaria=R_CtasContxCtesProvEmp.IdCuentaBancaria
JOIN T_SaldosInicialesCont
ON T_SaldosInicialesCont.IdCuentaContable=R_CtasContxCtesProvEmp.IdCuentaContable
WHERE T_SaldosInicialesCont.Mes = @Periodo and T_SaldosInicialesCont.Year = @Ejercicio and C_CuentasBancarias.CuentaBancaria <> '' 

SELECT *   
FROM @tabla where Saldo > 0 
ORDER BY NombreBanco,CuentaBancaria    
END  

go 
  
  --exec SP_RPT_K2_CuentasBancarias 2017,6
