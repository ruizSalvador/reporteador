/****** Object:  View [dbo].[VW_RPT_K2_CatalogoCuentasContablesTXT]    Script Date: 06/18/2013 17:09:18 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_CatalogoCuentasContablesTXT]'))
DROP VIEW [dbo].[VW_RPT_K2_CatalogoCuentasContablesTXT]
GO

/****** Object:  View [dbo].[VW_RPT_K2_CatalogoCuentasContablesTXT]    Script Date: 06/18/2013 17:09:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_CatalogoCuentasContablesTXT]
AS

SELECT 
SUBSTRING (a.NumeroCuenta,1,1)+REPLICATE(' ',3) as Genero,
SUBSTRING (a.NumeroCuenta,2,1) as Grupo,
SUBSTRING (a.NumeroCuenta,3,1)+REPLICATE(' ',5) as Rubro,
SUBSTRING (a.NumeroCuenta,4,1)+REPLICATE(' ',4)  as Cuenta,
SUBSTRING (a.NumeroCuenta,5,1)+REPLICATE(' ',4)  as SubCuenta,
REPLACE(Substring(a.numerocuenta,1,len(rtrim(a.numerocuenta))),'-','')+REPLICATE(' ',22-len(rtrim(a.numerocuenta))) as CuentaContable,
Substring(rtrim(a.NombreCuenta),1,300)+ REPLICATE(' ',300-(len(substring(rtrim(a.NombreCuenta),1,300))))as NombreCuenta, 
a.Nivel+1 as Nivel,
case a.TipoCuenta
when 'A' then 'D'
when 'C' then 'D'
when 'E' then 'D'
when 'G' then 'D'
when 'I' then 'D'
when 'B' then 'A'
when 'D' then 'A'
when 'F' then 'A'
when 'H' then 'A'
when 'J' then 'A'
end  as Naturaleza,
Case A.Afectable 
When 0 then 'C'
When 1 Then 'R'
end as TipoCuenta,
(Select REPLACE(rtrim(B.numerocuenta),'-','')+REPLICATE(' ',16-Len(REPLACE(rtrim(B.numerocuenta),'-',''))) From C_Contable B Where a.IdCuentaAfectacion=b.IdCuentaContable) AS CuentaControl 
From C_Contable A
Where Nivel>=0
GO




