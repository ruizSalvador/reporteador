/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_PDO]    Script Date: 12/04/2012 22:50:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_ESF_PDO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_ESF_PDO]
GO
/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_PDO]    Script Date: 12/04/2012 22:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_NOTA_ESF_PDO]
@Mes Int,
@Año Int,
@Tipo int,
@Miles bit

AS
BEGIN

declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

DECLARE @Tabla as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
Nota1 text,
Nota2 text
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
Nota1 text,
Nota2 text
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
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota1,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota2
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
Nota1,
Nota2
FROM  @Tabla 
Where substring(NumeroCuenta,1,5) Like '215_0' or substring(NumeroCuenta,1,5) like '224_0'
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
Nota1,
Nota2
FROM  @Tabla 
Where substring(NumeroCuenta,1,5) Like '31_00'
end
insert into @Resultado (NombreCuenta,SaldoAcreedor,Nota1, Nota2 )
select 'TOTAL' as NombreCuenta, SUM(SaldoAcreedor) as SaldoAcreedor,'TOTAL'+' Click aqui...' as Nota1,
'TOTAL'+' Click aqui...' as Nota2
FROM @Resultado
Where NumeroCuenta='21500-00000' or NumeroCuenta='22400-00000' or
NumeroCuenta='21500-000000' or NumeroCuenta='22400-000000' or
NumeroCuenta='31000-00000' or NumeroCuenta='31000-000000'
--UPDATE @Resultado set Nota1='', Nota2='' WHERE NombreCuenta='TOTAL'
SELECT * from @resultado



END
GO
UPDATE C_Menu SET Utilizar= 1 where IdMenu= 1081
GO
UPDATE C_Menu SET Utilizar= 1 where IdMenu= 1095
GO
UPDATE C_Menu SET Utilizar= 1 where IdMenu= 1098
GO
UPDATE C_Menu SET Utilizar= 1 where IdMenu= 1099
GO
UPDATE C_Menu SET Utilizar= 1 where IdMenu= 1100
GO

EXEC SP_FirmasReporte 'Notas al Estado de Situación Financiera Pasivos diferidos y otros'
GO
EXEC SP_FirmasReporte 'Notas al Estado de Variaciones en la Hacienda Pública / Patrimonio'
GO
Exec SP_CFG_LogScripts 'SP_NOTA_ESF_PDO'
GO
--EXEC SP_NOTA_ESF_PDO 1,2012,1
--GO

