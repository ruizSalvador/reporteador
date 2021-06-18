/****** Object:  StoredProcedure [dbo].[SP_PolizasDeCuadre]    Script Date: 03/12/2015 11:45:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_PolizasDeCuadre]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_PolizasDeCuadre]
GO

/****** Object:  StoredProcedure [dbo].[SP_PolizasDeCuadre]    Script Date: 03/12/2015 11:45:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PolizasDeCuadre]
@periodo1 smallint,
@periodo2 smallint,
@Ejercicio int


AS

Declare @Polizas as table (
Periodo int, 
TipoPoliza varchar(4),
NoPoliza int, 
Concepto varchar(max),
Abono Decimal(18,2),
Cargo Decimal(18,2))

BEGIN

Insert Into  @Polizas
Select T_Polizas.Periodo,T_Polizas.TipoPoliza,T_Polizas.NoPoliza,T_polizas.Concepto,
      sum(D_Polizas.ImporteAbono) Abono,sum(D_Polizas.ImporteCargo) Cargo
From T_Polizas
      Inner Join D_Polizas
      On T_Polizas.idPoliza = D_Polizas.IdPoliza
      Inner Join C_Contable
      On D_Polizas.IdCuentaContable = C_Contable.IdCuentaContable
Where  T_Polizas.Periodo in (1,2,3,4,5,6,7,8,9,10,11) 
	  And T_Polizas.Ejercicio = @Ejercicio
	  And T_Polizas.Periodo Between @periodo1 and @periodo2 
	  and T_Polizas.NoPoliza > 0 and NumeroCuenta Not Like '8%'
	  and T_Polizas.TipoPoliza in ('D','E','I')
Group by T_Polizas.NoPoliza,T_Polizas.TipoPoliza,T_Polizas.Periodo,T_polizas.Concepto
Order by Periodo,TipoPoliza,NoPoliza

Select * from @Polizas Where Abono <> Cargo order by Periodo,TipoPoliza,NoPoliza
	
END
GO
--exec SP_PolizasDeCuadre 1,12,2015