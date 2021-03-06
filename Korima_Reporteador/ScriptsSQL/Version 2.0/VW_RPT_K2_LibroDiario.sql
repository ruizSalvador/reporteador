
/****** Object:  View [dbo].[VW_RPT_K2_LibroDiario]    Script Date: 09/19/2012 12:52:38 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_LibroDiario]'))
DROP VIEW [dbo].[VW_RPT_K2_LibroDiario]
GO

/****** Object:  View [dbo].[VW_RPT_K2_LibroDiario]    Script Date: 09/19/2012 12:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_LibroDiario] AS 

SELECT
T_Polizas.Fecha,
T_Polizas.TipoPoliza + CAST(t_polizas.NoPoliza AS VARCHAR(10)) AS Folio,
ROW_NUMBER() over(partition by D_Polizas.IdSelloPresupuestal order by D_Polizas.Iddpoliza)as NoAsiento,
D_Polizas.Referencia,
D_Polizas.IdSelloPresupuestal,
(select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta not like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable) AS NumeroCuentaContable,
(select case when (select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta not like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable) IS null
then null
when (select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta not like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable)IS not null
then C_Contable.NombreCuenta
end) as NombreCuentaContable,
(select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable) AS NumeroCuentaPresupuestal,
(Select case when (select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable)is null 
then null
when (select C_Contable.NumeroCuenta from C_Contable where C_Contable.NumeroCuenta like '8%' and C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable) IS not null
then c_contable.NombreCuenta end) as NombreCuentaPresupuestal,
T_Polizas.Concepto,
D_Polizas.ImporteCargo,
D_Polizas.ImporteAbono,
D_Polizas.IdPoliza,
D_Polizas.IdDPoliza

FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 

GO
