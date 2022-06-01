
/****** Object:  StoredProcedure [dbo].[SP_Interfaz_CONTPAQi_MandaMovtos]    Script Date: 10/21/2013 14:26:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Interfaz_CONTPAQi_MandaMovtos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Interfaz_CONTPAQi_MandaMovtos]
GO


/****** Object:  StoredProcedure [dbo].[SP_Interfaz_CONTPAQi_MandaMovtos]    Script Date: 10/21/2013 14:26:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Interfaz_CONTPAQi_MandaMovtos]
@IdPoliza INT
as

DECLARE @Tabla TABLE (NumeroCuenta VARCHAR(MAX),Concepto VARCHAR(MAX), Referencia VARCHAR(MAX),TipoMovto INT, ImporteAbono DECIMAL(15,2),ImporteCargo DECIMAL(15,2),TipoCuenta CHAR(1), IdPoliza INT)
INSERT @Tabla  
SELECT Replace(dbo.C_Contable.NumeroCuenta,'-','' ) as NumeroCuenta, left(D_Polizas.Concepto,99) as Concepto, left(D_Polizas.Referencia,9) as Referencia, 
D_Polizas.iva as TipoMovto, 
Case C_Contable.TipoCuenta
	When 'B' Then  
		case when D_Polizas.ImporteCargo>0  then  
		isnull(D_Polizas.ImporteAbono,0)+ ISNULL(D_Polizas.ImporteCargo*-1,0)
		else D_Polizas.ImporteAbono 
	End
		When 'D' Then 
		case when isnull(D_Polizas.ImporteCargo,0) >0 	then  
		isnull(D_Polizas.ImporteAbono,0)+ ISNULL(D_Polizas.ImporteCargo*-1,0) 
		else D_Polizas.ImporteAbono 
	End
		When 'H' Then 
		case when isnull(D_Polizas.ImporteCargo,0) <>0 	then  
		isnull(D_Polizas.ImporteAbono,0)+ ISNULL(D_Polizas.ImporteCargo*-1,0) 
		else D_Polizas.ImporteAbono 
		End
	Else isnull(D_Polizas.ImporteAbono,0)
End as ImporteAbono, 
	Case C_Contable.TipoCuenta
		When 'A' Then 
		case when isnull(D_Polizas.ImporteAbono,0) >0 	then  
		isnull(D_Polizas.ImporteCargo,0) + ISNULL(D_Polizas.ImporteAbono*-1,0) 
		else D_Polizas.ImporteCargo
	End
		When 'C' Then 
		case when isnull(D_Polizas.ImporteAbono,0) >0 	then  
		isnull(D_Polizas.ImporteCargo,0)+ ISNULL(D_Polizas.ImporteAbono*-1,0) 
		else D_Polizas.ImporteCargo
	End
		When 'G' Then 
		case when isnull(D_Polizas.ImporteAbono,0) <>0 	then  
		isnull(D_Polizas.ImporteCargo,0)+ ISNULL(D_Polizas.ImporteAbono*-1,0) 
		else D_Polizas.ImporteCargo
	End
	Else isnull(D_Polizas.ImporteCargo,0) 
End as ImporteCargo,
C_Contable.TipoCuenta, D_Polizas.IdPoliza
FROM dbo.D_Polizas INNER JOIN dbo.C_Contable ON dbo.D_Polizas.IdCuentaContable = dbo.C_Contable.IdCuentaContable 
where IdPoliza=@IdPoliza

-------------------
UPDATE @Tabla SET ImporteCargo =0 where ImporteCargo <>0 and ImporteAbono<>0 and TipoMovto=2
UPDATE @Tabla SET ImporteAbono =0 where ImporteCargo <>0 and ImporteAbono<>0 and TipoMovto=1
UPDATE @Tabla SET TipoMovto =1 where ImporteCargo <>0 and ImporteAbono =0
UPDATE @Tabla SET TIpoMovto =2 where ImporteCargo =0 and ImporteAbono <>0

---------------------
Select * from @Tabla  where IdPoliza=@IdPoliza
GO


