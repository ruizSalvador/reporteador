/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_ED_OA]    Script Date: 12/06/2012 10:29:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_ESF_ED_OA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_ESF_ED_OA]
GO
/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_ED_OA]    Script Date: 12/06/2012 10:29:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_NOTA_ESF_ED_OA]
@Mes Int,
@Año Int,
@Tipo int,
@Miles bit

AS

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

BEGIN
DECLARE @Tabla as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
Nota1 Text
)

DECLARE @Resultado as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
Nota1 Text
)
INSERT INTO @Tabla 
Select NumeroCuenta, NombreCuenta, CargosSinFlujo, AbonosSinFlujo, TotalCargos, TotalAbonos,
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
                    When 'I'  Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      (NumeroCuenta)+' Click Aqui...' as Nota1
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And Mes = @Mes And [Year] = @Año And TipoCuenta <> 'X' 
Order By NumeroCuenta

IF @Tipo=1 Begin
Insert into @Resultado 
SELECT
NumeroCuenta, 
NombreCuenta, 
CargosSinFlujo, 
AbonosSinFlujo, 
TotalCargos, 
TotalAbonos,
(SaldoDeudor/@Division)as SaldoDeudor,
(SaldoAcreedor/@Division) as SaldoAcreedor,
Nota1
FROM  @Tabla 
Where substring(NumeroCuenta,1,5) Like '116_0' or substring(NumeroCuenta,1,5) like '128_0'
end
IF @Tipo=2 Begin
Insert into @Resultado 
SELECT
NumeroCuenta, 
NombreCuenta, 
CargosSinFlujo, 
AbonosSinFlujo, 
TotalCargos, 
TotalAbonos,
(SaldoDeudor/@Division)as SaldoDeudor,
(SaldoAcreedor/@Division) as SaldoAcreedor,
Nota1
FROM  @Tabla 
Where NumeroCuenta Like '129%'
end
IF @Tipo=3 Begin
Insert into @Resultado 
SELECT
NumeroCuenta, 
NombreCuenta, 
CargosSinFlujo, 
AbonosSinFlujo, 
TotalCargos, 
TotalAbonos,
(SaldoDeudor/@Division) as SaldoDeudor,
(SaldoAcreedor/@Division)AS SaldoAcreedor,
Nota1
FROM  @Tabla 
Where Substring(NumeroCuenta,1,5) Like '2166_'or substring(NumeroCuenta,1,5) like '225_0'
end
if @Tipo=3 begin
insert into @Resultado (NumeroCuenta,NombreCuenta,SaldoAcreedor)
select '2'as NumeroCuenta, 'TOTAL' as NombreCuenta, SUM(SaldoAcreedor) as SaldoAcreedor
FROM @Resultado
Where NumeroCuenta='21660-00000' or NumeroCuenta='22500-00000' or
NumeroCuenta='21660-000000' or NumeroCuenta='22500-000000'
end
if @Tipo=2 begin
insert into @Resultado (NumeroCuenta,NombreCuenta,SaldoDeudor)
select '1'as NumeroCuenta, 'TOTAL' as NombreCuenta, SUM(SaldoDeudor) as SaldoDeudor
FROM @Resultado
Where NumeroCuenta='12900-00000' or NumeroCuenta='12900-00000'
end
if @Tipo=1 begin
insert into @Resultado (NumeroCuenta,NombreCuenta,SaldoDeudor)
select '1'as NumeroCuenta,'TOTAL' as NombreCuenta, SUM(SaldoDeudor) as SaldoDeudor
FROM @Resultado
Where NumeroCuenta='11600-00000' or NumeroCuenta='12800-00000' or
NumeroCuenta='11600-000000' or NumeroCuenta='12800-000000'
end
UPDATE @Resultado SET Nota1='TOTAL Click aqui...' WHERE NombreCuenta='TOTAL'

SELECT * from @resultado

END

GO

EXEC SP_FirmasReporte 'Notas al Estado de Situación Financiera Estimaciones y Deterioros'
GO
EXEC SP_FirmasReporte 'Notas al Estado de Situación Financiera Otros Activos'
GO
EXEC SP_FirmasReporte 'Notas al Estado de Situación Financiera Fondos de Bienes de Terceros en Administracón y/o en garantía a corto y largo plazo'
GO

UPDATE C_Menu SET Utilizar=1 WHERE IdMenu=1093
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu=1094
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu=1095
GO
UPDATE C_Menu SET Utilizar=1 WHERE IdMenu=1097
GO

Exec SP_CFG_LogScripts 'SP_NOTA_ESF_ED_OA'
GO

--EXEC SP_NOTA_ESF_ED_OA 1,2012,1
--GO