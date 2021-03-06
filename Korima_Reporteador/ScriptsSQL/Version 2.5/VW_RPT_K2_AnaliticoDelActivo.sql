/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_AnaliticoDelActivo]'))
DROP VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo]
GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo_Total]    Script Date: 10/24/2012 09:40:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_AnaliticoDelActivo_Total]'))
DROP VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo_Total]
GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo_Total]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo_Total]
AS

Select NumeroCuenta, NombreCuenta, (CargosSinFlujo/1000) as CargosSinFlujo, (AbonosSinFlujo/1000)*-1 as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
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
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/1000)*-1
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/1000)*-1
      else (CargosSinFlujo+TotalCargos-TotalAbonos)/1000 
      end as SaldoFinal,
      case substring(NumeroCuenta,1,3)
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/1000 )*-1
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/1000)*-1
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)/1000 
      end as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
AND  (NumeroCuenta like '10000-00000' or NumeroCuenta like '10000-000000' or NumeroCuenta like '100000-000000')


GO
/****** Object:  View [dbo].[VW_RPT_K2_AnaliticoDelActivo]    Script Date: 10/24/2012 09:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_AnaliticoDelActivo]
AS

Select NumeroCuenta, 
Case C_Contable.Nivel
when 0 then NombreCuenta
when 1 then '  '+NombreCuenta 
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta)) 
end as NombreCuenta, 
(CargosSinFlujo/1000) as CargosSinFlujo, (AbonosSinFlujo/1000)*-1 as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
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
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/1000)*-1
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/1000 )*-1
      else (CargosSinFlujo+TotalCargos-TotalAbonos)/1000  end 
      as SaldoFinal,
      case substring(NumeroCuenta,1,3)
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/1000 )*-1
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/1000)*-1
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)/1000 end 
       as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year
      
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 And TipoCuenta <> 'X'
AND  (NumeroCuenta like '1__00-00000' or NumeroCuenta like '1__00-000000' or NumeroCuenta like '1__000-000000')


GO

Exec SP_FirmasReporte 'Analitico del activo'
Go
