/****** Object:  View [dbo].[VW_RPT_K2_MovimientosMensualesCuentasPublicasTXT]    Script Date: 06/20/2013 14:15:50 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_MovimientosMensualesCuentasPublicasTXT]'))
DROP VIEW [dbo].[VW_RPT_K2_MovimientosMensualesCuentasPublicasTXT]
GO

/****** Object:  View [dbo].[VW_RPT_K2_MovimientosMensualesCuentasPublicasTXT]    Script Date: 06/20/2013 14:15:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_RPT_K2_MovimientosMensualesCuentasPublicasTXT]
AS

Select
REPLACE(Substring(NumeroCuenta,1,LEN(rtrim(numerocuenta))),'-','')+REPLICATE(' ',22-LEN(rtrim(numerocuenta))) as NumeroCuenta,
       Case C_Contable .TipoCuenta 
		  -- 
          When 'A' Then case when T_SaldosInicialesCont.CargosSinFlujo<0 then 
          '-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo)end
          
          When 'C' Then case when T_SaldosInicialesCont.CargosSinFlujo<0 then 
          '-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo )end
          --
          When 'E' Then case when T_SaldosInicialesCont.CargosSinFlujo<0 then 
          '-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo )end
          --
          When 'G' Then case when T_SaldosInicialesCont.CargosSinFlujo<0 then 
          '-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo )end
          --
          When 'I' Then case when T_SaldosInicialesCont.CargosSinFlujo<0 then 
          '-'+REPLACE (REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo))))+convert(varchar(20),T_SaldosInicialesCont.CargosSinFlujo )end
          --
          Else case when T_SaldosInicialesCont.AbonosSinFlujo <0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.AbonosSinFlujo ))))+convert(varchar(20),T_SaldosInicialesCont.AbonosSinFlujo),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),T_SaldosInicialesCont.AbonosSinFlujo ))))+convert(varchar(20),T_SaldosInicialesCont.AbonosSinFlujo)end
      End as SaldoInicial,
      --
      Case when TotalCargos <0 then
      '-'+Replace(REPLICATE('0',15-(LEN(convert(varchar(20),TotalCargos))))+convert(varchar(20),TotalCargos) ,'-','') 
	  else REPLICATE('0',15-(LEN(convert(varchar(20),TotalCargos))))+convert(varchar(20),TotalCargos)end AS Cargos, 
	  --
	  case when TotalAbonos <0 then
	  '-'+Replace (REPLICATE('0',15-(LEN(convert(varchar(20),TotalAbonos))))+convert(varchar(20),TotalAbonos),'-','')
      Else REPLICATE('0',15-(LEN(convert(varchar(20),TotalAbonos))))+convert(varchar(20),TotalAbonos)End AS Abonos,

       Case C_Contable .TipoCuenta  
          When 'A' Then case when (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)<0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)end
          When 'C' Then case when (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)<0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)end
          When 'E' Then case when (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)<0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)end
          When 'G' Then case when (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)<0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos),'-','') 
          else REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)end
          When 'I' Then case when (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)<0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos))))+ convert(varchar(20),CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)end
          Else  case when AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos <0 then
          '-'+REPLACE(REPLICATE('0',15-(LEN(convert(varchar(20),AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos))))+ convert(varchar(20),AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos),'-','')
          else REPLICATE('0',15-(LEN(convert(varchar(20),AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos))))+ convert(varchar(20),AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos)end
      End as SaldoActual,
            T_SaldosInicialesCont.Mes,
T_SaldosInicialesCont.year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable AND C_Contable.Nivel >=0
And TipoCuenta <> 'X'

GO


