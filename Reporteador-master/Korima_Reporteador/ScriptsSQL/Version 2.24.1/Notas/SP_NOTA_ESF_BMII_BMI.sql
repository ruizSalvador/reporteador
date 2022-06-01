/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_BMII_BMI]    Script Date: 12/12/2012 16:58:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_ESF_BMII_BMI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_ESF_BMII_BMI]
GO

/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_BMII_BMI]    Script Date: 12/12/2012 16:58:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_NOTA_ESF_BMII_BMI]
@Mes Int,
@Año Int,
@Miles bit
--,
--@Tipo int

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
DepreciacionAcumulada decimal(15,2),
Nota1 text,
Nota2 text
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
DepreciacionAcumulada decimal(15,2),
Nota1 text,
Nota2 text
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
      null as DepreciacionAcumulada,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota1,
      substring(NumeroCuenta,1,5)+' Click aqui...' as Nota2
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And Mes = @Mes And [Year] = @Año And TipoCuenta <> 'X' AND
(NumeroCuenta like '1263%' or NumeroCuenta like '1261%' or NumeroCuenta like '1262%'or NumeroCuenta like '123%'or NumeroCuenta like '124%')
Order By NumeroCuenta 

--5 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12400-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12411-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12412-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12413-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12419-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12421-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12422-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12423-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12429-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12431-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12432-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12441-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12442-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12443-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12444-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12445-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12449-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12450-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12461-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12462-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12463-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12464-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12465-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12466-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12467-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12468-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12469-00000'
--
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12300-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12310-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12320-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12330-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12390-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12340-00000'
--
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00000'), SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12400-00000')
WHERE NumeroCuenta='12400-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00001') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00001')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12411-00000')
WHERE NumeroCuenta='12411-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00002') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00002')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12412-00000')
WHERE NumeroCuenta='12412-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00003') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00003')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12413-00000')
WHERE NumeroCuenta='12413-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00004') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00004')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12419-00000')
WHERE NumeroCuenta='12419-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00005') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00005')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12421-00000')
WHERE NumeroCuenta='12421-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00006') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00006')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12422-00000')
WHERE NumeroCuenta='12422-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00007') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00007')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12423-00000')
WHERE NumeroCuenta='12423-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00008') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00008')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12429-00000')
WHERE NumeroCuenta='12429-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00009') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00009')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12431-00000')
WHERE NumeroCuenta='12431-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00010') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00010')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12432-00000')
WHERE NumeroCuenta='12432-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00011') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00011')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12441-00000')
WHERE NumeroCuenta='12441-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00012') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00012')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12442-00000')
WHERE NumeroCuenta='12442-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00013') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00013')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12443-00000')
WHERE NumeroCuenta='12443-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00014') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00014')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12444-00000')
WHERE NumeroCuenta='12444-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00015') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00015')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12445-00000')
WHERE NumeroCuenta='12445-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00016') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00016')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12449-00000')
WHERE NumeroCuenta='12449-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00017') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00017')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12450-00000')
WHERE NumeroCuenta='12450-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00018') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00018')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12461-00000')
WHERE NumeroCuenta='12461-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00019') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00019')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12462-00000')
WHERE NumeroCuenta='12462-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00020') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00020')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12462-00000')
WHERE NumeroCuenta='12462-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00021') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00021')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12464-00000')
WHERE NumeroCuenta='12464-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00022') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00022')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12465-00000')
WHERE NumeroCuenta='12465-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-00023') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00023')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12466-00000')
WHERE NumeroCuenta='12466-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00024') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00024')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12467-00000')
WHERE NumeroCuenta='12467-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12630-00025') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-00025')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12469-00000')
WHERE NumeroCuenta='12469-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12610-00000') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-00000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12300-00000')
WHERE NumeroCuenta='12300-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12610-00001') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-00001')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12310-00000')
WHERE NumeroCuenta='12310-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12610-00002') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-00002')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12320-00000')
WHERE NumeroCuenta='12320-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12610-00003') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-00003')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12330-00000')
WHERE NumeroCuenta='12330-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12610-00004') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-00004')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12390-00000')
WHERE NumeroCuenta='12390-00000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2 
Where NumeroCuenta= '12620-00000') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12620-00000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12340-00000')
WHERE NumeroCuenta='12340-00000'
--5 Digitos FIN

--6 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '12400-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12411-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12412-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12413-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12419-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12421-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12422-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12423-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12429-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12431-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12432-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12441-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12442-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12443-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12444-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12445-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12449-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12450-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12461-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12462-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12463-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12464-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12465-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12466-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12467-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12468-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12469-000000'
--
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12300-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12310-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12320-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12330-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12390-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta  from C_Contable Where NumeroCuenta= '12340-000000'
--
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-000000'), SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12400-000000')
WHERE NumeroCuenta='12400-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-000010') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000010')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12411-000000')
WHERE NumeroCuenta='12411-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-000020') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000020')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12412-000000')
WHERE NumeroCuenta='12412-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000030') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000030')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12413-000000')
WHERE NumeroCuenta='12413-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000040') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000040')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12419-000000')
WHERE NumeroCuenta='12419-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000050') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000050')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12421-000000')
WHERE NumeroCuenta='12421-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000060') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000060')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12422-000000')
WHERE NumeroCuenta='12422-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000070') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000070')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12423-000000')
WHERE NumeroCuenta='12423-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000080') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000080')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12429-000000')
WHERE NumeroCuenta='12429-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000090') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000090')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12431-000000')
WHERE NumeroCuenta='12431-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000100') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000100')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12432-000000')
WHERE NumeroCuenta='12432-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2  
Where NumeroCuenta= '12630-000110') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000110')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12441-000000')
WHERE NumeroCuenta='12441-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000120') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000120')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12442-000000')
WHERE NumeroCuenta='12442-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000130') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000130')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12443-000000')
WHERE NumeroCuenta='12443-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000140') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000140')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12444-000000')
WHERE NumeroCuenta='12444-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000150') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000150')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12445-000000')
WHERE NumeroCuenta='12445-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000160') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000160')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12449-000000')
WHERE NumeroCuenta='12449-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000170') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000170')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12450-000000')
WHERE NumeroCuenta='12450-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000180') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000180')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12461-000000')
WHERE NumeroCuenta='12461-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000190') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000190')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12462-000000')
WHERE NumeroCuenta='12462-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000200') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000200')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12463-000000')
WHERE NumeroCuenta='12463-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000210') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000210')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12464-000000')
WHERE NumeroCuenta='12464-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000220') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000220')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12465-000000')
WHERE NumeroCuenta='12465-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000230') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000230')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12466-000000')
WHERE NumeroCuenta='12466-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000240') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000240')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12467-000000')
WHERE NumeroCuenta='12467-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12630-000250') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12630-000250')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12469-000000')
WHERE NumeroCuenta='12469-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12610-000000') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-000000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12300-000000')
WHERE NumeroCuenta='12300-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12610-000010') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-000010')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12310-000000')
WHERE NumeroCuenta='12310-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12610-000020') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-000020')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12320-000000')
WHERE NumeroCuenta='12320-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12610-000030') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-000030')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12330-000000')
WHERE NumeroCuenta='12330-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12610-000040') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12610-000040')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12390-000000')
WHERE NumeroCuenta='12390-000000'
UPDATE @Tabla1 SET DepreciacionAcumulada = (SELECT TotalAbonos from @Tabla2   
Where NumeroCuenta= '12620-000000') , SaldoAcreedor=(SELECT t2.SaldoAcreedor from @Tabla2 as t2 where t2.NumeroCuenta ='12620-000000')
,TotalCargos=(Select TotalCargos from @Tabla2 where NumeroCuenta='12340-000000')
WHERE NumeroCuenta='12340-000000'
--6 Digitos FIN
INSERT INTO @Tabla1 (NumeroCuenta,NombreCuenta,TotalCargos,SaldoAcreedor,Nota1,Nota2,DepreciacionAcumulada  )
SELECT 'TOTAL','TOTAL' as NombreCuenta,(Select SUM(totalCargos) from @Tabla1 where substring(NumeroCuenta,1,5) in ('12400','12300')) 
,(Select SUM(SaldoAcreedor) from @Tabla2 Where NumeroCuenta = '12610-00000' or NumeroCuenta = '12610-000000' or
NumeroCuenta= '12630-00000' or NumeroCuenta = '12630-000000') as SaldoAcreedor, 'TOTAL Click Aqui...' as Nota1,'TOTAL Click Aqui...' as Nota2,
(Select SUM(TotalAbonos ) from @Tabla2 Where NumeroCuenta = '12610-00000' or NumeroCuenta = '12610-000000' or
NumeroCuenta= '12630-00000' or NumeroCuenta = '12630-000000') as DepreciacionAcumulada
Update @Tabla1 Set Nota1= NumeroCuenta+' Click Aqui...', Nota2= NumeroCuenta + ' Click Aqui' where NumeroCuenta <>'TOTAL'




SELECT
NumeroCuenta, 
NombreCuenta, 
isnull(CargosSinFlujo,0) as CargosSinFlujo, 
isnull(AbonosSinFlujo,0) as AbonosSinFlujo, 
isnull(TotalCargos,0) as TotalCargos, 
isnull(TotalAbonos,0) as TotalAbonos,
isnull(SaldoDeudor,0) as SaldoDeudor,
isnull(SaldoAcreedor,0) as SaldoAcreedor,
isnull(DepreciacionAcumulada,0) as DepreciacionAcumulada,
Nota1,
Nota2,
NumeroCuenta +' Click Aqui...' as Nota3,
(isnull(TotalCargos,0)-isnull(SaldoAcreedor,0)) as SaldoDepreciar
FROM  @Tabla1
 
--Where NumeroCuenta Like '123_0-00000' or substring(NumeroCuenta,1,5) like '124_0'
--order by NumeroCuenta
END




GO

UPDATE C_Menu set utilizar=1 where idmenu in (1082,1091)
GO
Exec SP_CFG_LogScripts 'SP_NOTA_ESF_BMII_BMI'
GO

