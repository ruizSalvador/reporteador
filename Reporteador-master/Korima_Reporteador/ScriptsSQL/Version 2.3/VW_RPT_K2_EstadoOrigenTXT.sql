
/****** Object:  View [dbo].[VW_RPT_K2_EstadoOrigenTXT]    Script Date: 06/24/2013 15:53:53 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_EstadoOrigenTXT]'))
DROP VIEW [dbo].[VW_RPT_K2_EstadoOrigenTXT]
GO


/****** Object:  View [dbo].[VW_RPT_K2_EstadoOrigenTXT]    Script Date: 06/24/2013 15:53:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_RPT_K2_EstadoOrigenTXT]
AS 
SELECT 
REPLACE(Substring(a.numerocuenta,1,len(rtrim(a.numerocuenta))),'-','')+REPLICATE(' ',22-len(rtrim(a.numerocuenta))) as CuentaContable,
Substring(rtrim(a.NombreCuenta),1,300)+ REPLICATE(' ',300-(len(substring(rtrim(a.NombreCuenta),1,300))))as NombreCuenta, 
      --
      Case when TotalCargos <0 then
      '-'+Replace(REPLICATE('0',15-(LEN(convert(varchar(20),TotalCargos))))+convert(varchar(20),TotalCargos) ,'-','') 
	  else REPLICATE('0',15-(LEN(convert(varchar(20),TotalCargos))))+convert(varchar(20),TotalCargos)end AS Cargos,
	  --
	  T_SaldosInicialesCont.Mes,
	  T_SaldosInicialesCont.year
From C_Contable A, T_SaldosInicialesCont 
Where  A.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable AND A.Nivel >=0
And TipoCuenta <> 'X'
And substring(A.NumeroCuenta,1,2)='11' 

GO
