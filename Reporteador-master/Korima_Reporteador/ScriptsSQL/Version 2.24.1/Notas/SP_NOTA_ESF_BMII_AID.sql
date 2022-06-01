/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_BMII_AID]    Script Date: 12/20/2012 12:51:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_ESF_BMII_AID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_ESF_BMII_AID]
GO

/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_BMII_AID]    Script Date: 12/20/2012 12:51:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_NOTA_ESF_BMII_AID]
@Mes Int,
@Año Int,
@Miles bit

AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

BEGIN
DECLARE @Tabla1 as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
Amotizacion Decimal(15,2),
Nota1 text,
Nota2 text,
Nota3 text
)
DECLARE @Tabla2 as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
Amotizacion Decimal(15,2),
Nota1 text,
Nota2 text,
Nota3 text
)

INSERT INTO @Tabla2
Select NumeroCuenta, NombreCuenta, CargosSinFlujo, AbonosSinFlujo, (TotalCargos/@Division) as TotalCargos, 
(TotalAbonos/@Division) as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division
          When 'C' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division
          When 'E' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division
          When 'G' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division
          When 'I' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/@Division
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
                    When 'I'  Then 0
          Else (AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos)/@Division
      End as SaldoAcreedor,
      null as Amotizacion,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota1,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota2,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota3
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And Mes = @Mes And [Year] = @Año And TipoCuenta <> 'X' AND
(NumeroCuenta like '125%' or NumeroCuenta like '127%' or NumeroCuenta like '1265%')
Order By NumeroCuenta 
--5 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12500-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12510-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12520-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12530-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12540-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12590-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12700-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12710-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12720-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12730-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12740-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12750-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12790-00000'
---
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12500-00000')
WHERE NumeroCuenta='12500-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12510-00000')
WHERE NumeroCuenta='12510-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12520-00000')
WHERE NumeroCuenta='12520-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12530-00000')
WHERE NumeroCuenta='12530-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12540-00000')
WHERE NumeroCuenta='12540-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12590-00000')
WHERE NumeroCuenta='12590-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12700-00000')
WHERE NumeroCuenta='12700-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12710-00000')
WHERE NumeroCuenta='12710-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12720-00000')
WHERE NumeroCuenta='12720-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12730-00000')
WHERE NumeroCuenta='12730-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12740-00000')
WHERE NumeroCuenta='12740-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12750-00000')
WHERE NumeroCuenta='12750-00000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12790-00000')
WHERE NumeroCuenta='12790-00000'
--
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-00000')
WHERE NumeroCuenta='12500-00000'
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-00001')
WHERE NumeroCuenta='12510-00000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-00002' or t2.NumeroCuenta ='12650-00003'  or t2.NumeroCuenta ='12650-00004')
WHERE NumeroCuenta='12520-00000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-00005' or t2.NumeroCuenta ='12650-00006' )
WHERE NumeroCuenta='12530-00000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-00007' or t2.NumeroCuenta ='12650-00008')
WHERE NumeroCuenta='12540-00000'
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-00009')
WHERE NumeroCuenta='12590-00000'
--5 Digitos FIN

--6 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12500-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12510-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12520-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12530-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12540-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12590-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12700-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12710-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12720-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12730-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12740-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12750-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12790-000000'
---
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12500-000000')
WHERE NumeroCuenta='12500-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12510-000000')
WHERE NumeroCuenta='12510-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12520-000000')
WHERE NumeroCuenta='12520-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12530-000000')
WHERE NumeroCuenta='12530-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12540-000000')
WHERE NumeroCuenta='12540-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12590-000000')
WHERE NumeroCuenta='12590-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12700-000000')
WHERE NumeroCuenta='12700-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12710-000000')
WHERE NumeroCuenta='12710-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12720-000000')
WHERE NumeroCuenta='12720-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12730-000000')
WHERE NumeroCuenta='12730-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12740-000000')
WHERE NumeroCuenta='12740-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12750-000000')
WHERE NumeroCuenta='12750-000000'
UPDATE @Tabla1 SET SaldoDeudor=(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='12790-000000')
WHERE NumeroCuenta='12790-000000'
--
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-000000')
WHERE NumeroCuenta='12500-000000'
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-000010')
WHERE NumeroCuenta='12510-000000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-000020' or t2.NumeroCuenta ='12650-000030'  or t2.NumeroCuenta ='12650-000040')
WHERE NumeroCuenta='12520-000000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-000050' or t2.NumeroCuenta ='12650-000060' )
WHERE NumeroCuenta='12530-000000'
UPDATE @Tabla1 SET Amotizacion=(SELECT SUM(t2.SaldoAcreedor) from @Tabla2 as t2 
where t2.NumeroCuenta ='12650-000070' or t2.NumeroCuenta ='12650-000080')
WHERE NumeroCuenta='12540-000000'
UPDATE @Tabla1 SET Amotizacion=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12650-000090')
WHERE NumeroCuenta='12590-000000'
--6 Digitos FIN

INSERT INTO @Tabla1 (NombreCuenta,SaldoDeudor,Amotizacion,Nota1,Nota2,Nota3 )
SELECT 'TOTAL' as NombreCuenta, (Select SUM(SaldoDeudor) from @Tabla2 Where NumeroCuenta = '12500-00000' or NumeroCuenta = '12500-000000' or
NumeroCuenta= '12700-00000' or NumeroCuenta = '12700-000000') as SaldoAcreedor, 
(Select SUM(Amotizacion) from @Tabla1) as Amotizacion,
'TOTAL Click Aqui...' as Nota1,'TOTAL Click Aqui...' as Nota2, 
'TOTAL Click Aqui...' as Nota3
Update @Tabla1 Set Nota1= NumeroCuenta +' Click Aqui...', Nota2= NumeroCuenta  + ' Click Aqui...', Nota3= NumeroCuenta  + ' Click Aqui...' 
Where NombreCuenta <>'TOTAL'

SELECT
NumeroCuenta, 
NombreCuenta, 
CargosSinFlujo, 
AbonosSinFlujo, 
TotalCargos, 
TotalAbonos,
SaldoDeudor,
SaldoAcreedor,
Amotizacion,
Nota1,
Nota2,
Nota3
FROM  @Tabla1
END




GO

UPDATE C_Menu set utilizar=1 where idmenu in (1082,1092)
GO
Exec SP_CFG_LogScripts 'SP_NOTA_ESF_BMII_AID'
GO


