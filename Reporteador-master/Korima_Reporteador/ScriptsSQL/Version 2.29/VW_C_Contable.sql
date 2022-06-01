
/****** Object:  View [dbo].[VW_C_Contable]    Script Date: 06/24/2013 15:53:53 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_Contable]'))
DROP VIEW [dbo].[VW_C_Contable]
GO

/****** Object:  View [dbo].[VW_C_Contable]    Script Date: 06/24/2013 15:53:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_C_Contable]
AS

SELECT        IdCuentaContable, IdPartidaGI, NumeroCuenta, NombreCuenta, IdCuentaAfectacion, CuentaAcumulacion, TipoCuenta, Afectable, Nivel, Alta, Exportada, Financiero, AfectaDisponibilidad, IdSelloPresupuestal, 
                         IdCuentaContableMayor, Utilizar, Armonizado, Observaciones, SuSaldoRepresenta, Descripcion, Fecha, SaldarCierreEjercicio, CrearSubcuentasAutomaticas, FechaAuditoria, HoraAuditoria, IdUsuarioModifica,
						 convert(bigint,replace (C_Contable.NumeroCuenta,'-','') ) as iNumeroCuenta
FROM            dbo.C_Contable where Nivel >= 0
GO

Exec SP_CFG_LogScripts 'VW_C_Contable','2.29'
GO