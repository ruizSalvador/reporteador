/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivoSinMiles]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_AnaliticoDelActivoSinMiles]'))
DROP VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivoSinMiles]
GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo_TotalSin Miles]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_AnaliticoDelActivo_TotalSinMiles]'))
DROP VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo_TotalSinMiles]
GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo_TotalSinMiles]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo_TotalSinMiles]
AS

Select NumeroCuenta, NombreCuenta, (CargosSinFlujo) as CargosSinFlujo, (AbonosSinFlujo)*-1 as AbonosSinFlujo, (TotalCargos) as TotalCargos, (TotalAbonos) as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      case substring(NumeroCuenta,1,3)
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos))*-1
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos))*-1
      else (CargosSinFlujo+TotalCargos-TotalAbonos)
      end as SaldoFinal,
      case substring(NumeroCuenta,1,3)
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo))*-1
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo))*-1
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)
      end as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year 
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
AND  (NumeroCuenta like '10000-00000' or NumeroCuenta like '10000-000000')


GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivoSinMiles]
AS

Select NumeroCuenta, NombreCuenta, (CargosSinFlujo) as CargosSinFlujo, (AbonosSinFlujo)*-1 as AbonosSinFlujo, (TotalCargos) as TotalCargos, (TotalAbonos) as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'C' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'E' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'G' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          When 'I' Then CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo  + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      case substring(NumeroCuenta,1,3)
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos))*-1
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos))*-1
      else (CargosSinFlujo+TotalCargos-TotalAbonos)  end 
      as SaldoFinal,
      case substring(NumeroCuenta,1,3)
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo))*-1
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo))*-1
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo) end 
       as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year
      
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 And TipoCuenta <> 'X'
AND  (NumeroCuenta like '1___0-00000' or NumeroCuenta like '1___0-000000')


GO

Exec SP_FirmasReporte 'Analitico del activo'
Go
