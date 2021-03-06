/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoDeLaDeudaPublica]    Script Date: 11/20/2012 17:27:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoDeLaDeudaPublica]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublica]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoDeLaDeudaPublica]    Script Date: 11/20/2012 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublica]

@mes smallint,
@año smallint,
@MuestraVacios bit
AS
BEGIN
Declare @21311AbonoSinFlujo decimal (15,2)
Declare @21410AbonoSinFlujo decimal (15,2)
Declare @21321AbonoSinFlujo decimal (15,2)
Declare @21420AbonoSinFlujo decimal (15,2)
--
Declare @21311TotalCargos decimal (15,2)
Declare @21410TotalCargos decimal (15,2)
Declare @21321TotalCargos decimal (15,2)
Declare @21420TotalCargos decimal (15,2)
--
Declare @21311TotalAbonos decimal (15,2)
Declare @21410TotalAbonos decimal (15,2)
Declare @21321TotalAbonos decimal (15,2)
Declare @21420TotalAbonos decimal (15,2)
--
Declare @21311SaldoFinal decimal (15,2)
Declare @21410SaldoFinal decimal (15,2)
Declare @21321SaldoFinal decimal (15,2)
Declare @21420SaldoFinal decimal (15,2)
--
Declare @21311FlujoDelPeriodo  decimal (15,2)
Declare @21410FlujoDelPeriodo  decimal (15,2)
Declare @21321FlujoDelPeriodo  decimal (15,2)
Declare @21420FlujoDelPeriodo  decimal (15,2)


DECLARE @tabla AS TABLE(NumeroCuenta varchar(30),NombreCuenta varchar(255),
AbonosSinFlujo decimal(15,2),TotalCargos decimal(15,2),TotalAbonos decimal(15,2),SaldoFinal decimal(15,2),
FlujoDelperiodo decimal(15,2),mes smallint,year smallint,
DeudaPublica varchar(50), Plazo varchar(50), ordenamiento int, ordenamiento2 int)
INSERT INTO @tabla 

SELECT NumeroCuenta, NombreCuenta,  
(AbonosSinFlujo/1000) as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
      (TotalAbonos-TotalCargos)/1000 as SaldoFinal,
      (AbonosSinFlujo+(TotalAbonos-TotalCargos))/1000 as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior' as DeudaPublica,
      'Corto Plazo'as Plazo, 
      1 as ordenamiento,
      0 as ordenamiento2    
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
 AND 
(numerocuenta like '21312-%' or
 numerocuenta like '21311-00000' or
 numerocuenta like '21410-00000' or
 numerocuenta like '21331-%'or
 numerocuenta like '21410-000000' or
 numerocuenta like '21331-000000')
 AND Mes=@mes AND Year=@año 

UNION

SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo/1000) as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
      (TotalAbonos-TotalCargos)/1000 as SaldoFinal,
      (AbonosSinFlujo+(TotalAbonos-TotalCargos))/1000 as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Exterior' as DeudaPublica,
      'Corto Plazo'as Plazo, 
      3 as ordenamiento,
      0 as ordenamiento2     
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
 AND
 (numerocuenta like '21322-%' or
 numerocuenta like '21321-00000' or
 numerocuenta like '21420-00000' or
 numerocuenta like '21332-%'or
 numerocuenta like '21321-000000' or
 numerocuenta like '21420-000000')
 AND Mes=@mes AND Year=@año  
  
UNION

SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo/1000) as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
      (TotalAbonos-TotalCargos)/1000 as SaldoFinal,
      (AbonosSinFlujo+(TotalAbonos-TotalCargos))/1000 as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior' as DeudaPublica,
      'Largo Plazo'as Plazo,
      5 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
 AND 
 (numerocuenta like '2233%' or
 numerocuenta like '2231%' or
 numerocuenta like '2235%')
  AND Mes=@mes AND Year=@año 
  
 UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo/1000) as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
      (TotalAbonos-TotalCargos)/1000 as SaldoFinal,
      (AbonosSinFlujo+(TotalAbonos-TotalCargos))/1000 as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Exterior' as DeudaPublica,
      'Largo Plazo'as Plazo,
      7 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
 AND 
 (numerocuenta like '2234%' or
 numerocuenta like '2232%')
  AND Mes=@mes AND Year=@año 
 
 UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo/1000) as AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, (TotalAbonos/1000) as TotalAbonos,
      (TotalAbonos-TotalCargos)/1000 as SaldoFinal,
      (AbonosSinFlujo+(TotalAbonos-TotalCargos))/1000 as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior y Exterior' as DeudaPublica,
      'Otros pasivos'as Plazo,
      9 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'
 AND 
(numerocuenta like '211%' or
 numerocuenta like '212%' or
 numerocuenta like '221%' or
 numerocuenta like '222%')
  AND Mes=@mes AND Year=@año 
 
ORDER BY ordenamiento
 --SELECT @21311 = (select@
 
 
 select @21410AbonoSinFlujo = (select abonossinflujo from @tabla where NumeroCuenta='22410-00000' or NumeroCuenta= '22410-000000')
 select @21410TotalCargos = (select TotalCargos from @tabla where NumeroCuenta='22410-00000' or NumeroCuenta= '22410-000000')
 select @21410TotalAbonos = (select TotalAbonos from @tabla where NumeroCuenta='22410-00000' or NumeroCuenta= '22410-000000')
 select @21410SaldoFinal = (select SaldoFinal from @tabla where NumeroCuenta='22410-00000' or NumeroCuenta= '22410-000000')
 select @21410FlujoDelPeriodo = (select FlujoDelperiodo from @tabla where NumeroCuenta='22410-00000' or NumeroCuenta= '22410-000000')
 -- 
 select @21420AbonoSinFlujo = (select abonossinflujo from @tabla where NumeroCuenta='22420-00000' or NumeroCuenta= '22420-000000')
 select @21420TotalCargos = (select TotalCargos from @tabla where NumeroCuenta='22420-00000' or NumeroCuenta= '22420-000000')
 select @21420TotalAbonos = (select TotalAbonos from @tabla where NumeroCuenta='22420-00000' or NumeroCuenta= '22420-000000')
 select @21420SaldoFinal = (select SaldoFinal from @tabla where NumeroCuenta='22420-00000' or NumeroCuenta= '22420-000000')
 select @21420FlujoDelPeriodo  = (select FlujoDelperiodo from @tabla where NumeroCuenta='22420-00000' or NumeroCuenta= '22420-000000')
 --
 
UPDATE @tabla set NombreCuenta = 'Títulos y valores', AbonosSinFlujo= AbonosSinFlujo+@21410AbonoSinFlujo, TotalCargos = TotalCargos + @21410TotalCargos, TotalAbonos = TotalAbonos+@21410TotalAbonos,SaldoFinal=SaldoFinal+@21410SaldoFinal , FlujoDelperiodo= FlujoDelperiodo+@21410FlujoDelPeriodo
where NumeroCuenta= '22311-00000' or NumeroCuenta= '22311-000000'
UPDATE @tabla set NombreCuenta = 'Títulos y valores', AbonosSinFlujo= AbonosSinFlujo+@21420AbonoSinFlujo, TotalCargos = TotalCargos + @21420TotalCargos, TotalAbonos = TotalAbonos+@21420TotalAbonos,SaldoFinal=SaldoFinal+@21420SaldoFinal , FlujoDelperiodo= FlujoDelperiodo+@21420FlujoDelPeriodo
where NumeroCuenta= '22321-00000' or NumeroCuenta= '22321-000000'

DELETE from @tabla where NumeroCuenta= '21410-00000' or NumeroCuenta= '21410-000000'
DELETE from @tabla where NumeroCuenta= '21420-00000' or NumeroCuenta= '21420-000000'
--
insert into @tabla 

select top (1) '' as NumeroCuenta , 'SubTotal corto plazo' as NombreCuenta, sum(AbonosSinFlujo), SUM(TotalCargos), Sum(TotalAbonos), SUM(SaldoFinal), SUM(FlujoDelperiodo), @mes as Mes, @año as year,'Deuda Pública Exterior' as DeudaPublica, Plazo, 3 as ordenamiento,0 as ordenamiento2  
from @tabla where 
(numerocuenta like '21312-00000' or
 numerocuenta like '21311-00000' or
 numerocuenta like '21410-00000' or
 numerocuenta like '21331-00000' or
 numerocuenta like '21410-000000' or
 numerocuenta like '21331-000000' or
 numerocuenta like '21312-000000' or
 numerocuenta like '21311-000000' or
 numerocuenta like '21322-00000' or
 numerocuenta like '21321-00000' or
 numerocuenta like '21420-00000' or
 numerocuenta like '21332-00000'or
 numerocuenta like '21322-000000' or
 numerocuenta like '21321-000000' or
 numerocuenta like '21420-000000' or
 numerocuenta like '21332-000000')
 group by ordenamiento, DeudaPublica, plazo 
 insert into @tabla 
 select top (1) '' as NumeroCuenta , 'SubTotal Largo plazo' as NombreCuenta, sum(AbonosSinFlujo), SUM(TotalCargos), Sum(TotalAbonos), SUM(SaldoFinal), SUM(FlujoDelperiodo), @mes as Mes, @año as year, 'Deuda publica Exterior' as DeudaPublica, Plazo, 7 as ordenamiento,0 as ordenamiento2  
from @tabla where 
(numerocuenta like '22330-00000' or
 numerocuenta like '22310-00000' or
 numerocuenta like '22350-00000' or
 numerocuenta like '22330-000000' or
 numerocuenta like '22310-000000' or
 numerocuenta like '22350-000000' or
 numerocuenta like '22340-00000' or
 numerocuenta like '22320-00000' or
 numerocuenta like '22340-000000' or
 numerocuenta like '22320-000000')
 group by ordenamiento, DeudaPublica, plazo 
 insert into @tabla 
  select top (1) '' as NumeroCuenta , 'SubTotal Otros pasivos' as NombreCuenta, sum(AbonosSinFlujo), SUM(TotalCargos), Sum(TotalAbonos), SUM(SaldoFinal), SUM(FlujoDelperiodo), @mes as Mes, @año as year, 'Deuda publica Interior y exterior' as DeudaPublica, 'Otros pasivos' as Plazo, 9 as ordenamiento, 1 as ordenamiento2  
from @tabla where 
(numerocuenta like '21100-00000' or
 numerocuenta like '21200-00000' or
 numerocuenta like '22100-00000' or
 numerocuenta like '22200-00000' or
 numerocuenta like '21100-000000' or
 numerocuenta like '21200-000000' or
 numerocuenta like '22100-000000' or
 numerocuenta like '22200-000000')
 group by ordenamiento, DeudaPublica, plazo 
 insert into @tabla 
  select top (1) '' as NumeroCuenta , 'Total deuda pública y otros pasivos' as NombreCuenta, sum(AbonosSinFlujo), SUM(TotalCargos), Sum(TotalAbonos), SUM(SaldoFinal), SUM(FlujoDelperiodo), @mes as Mes, @año as year, 'Deuda publica Interior y exterior' as DeudaPublica, 'Otros pasivos' as Plazo, 9 as ordenamiento, 2 as ordenamiento2  
from @tabla where 
NombreCuenta= 'SubTotal Otros pasivos'or
NombreCuenta = 'SubTotal Largo plazo' or
NombreCuenta = 'SubTotal corto plazo'

 if @MuestraVacios=1  
 begin
 select 
 NumeroCuenta,
	NombreCuenta,
	AbonosSinFlujo as AbonosSinFlujo,
	TotalCargos as TotalCargos,
	TotalAbonos as TotalAbonos,
	SaldoFinal as SaldoFinal,
	FlujoDelperiodo as FlujoDelperiodo,
	mes,
	year,
	DeudaPublica, 
	Plazo, 
	ordenamiento,
	ordenamiento2
  from @tabla
 order by ordenamiento, ordenamiento2  
 end
 else
 select 
  NumeroCuenta,
	NombreCuenta,
	AbonosSinFlujo as AbonosSinFlujo,
	TotalCargos as TotalCargos,
	TotalAbonos as TotalAbonos,
	SaldoFinal as SaldoFinal,
	FlujoDelperiodo as FlujoDelperiodo,
	mes,
	year,
	DeudaPublica, 
	Plazo, 
	ordenamiento,
	ordenamiento2
  from @tabla
 where
  AbonosSinFlujo <>0
  OR TotalCargos <> 0
  OR TotalAbonos <>0
  OR SaldoFinal <> 0
  OR FlujoDelperiodo <>0 
  --or NombreCuenta = 'SubTotal corto plazo'
  --or NombreCuenta = 'SubTotal Largo plazo'
  --or NombreCuenta = 'SubTotal Otros pasivos'
  --or NombreCuenta = 'Total deuda publica y otros pasivos'
  order by ordenamiento,ordenamiento2 
 


END
GO
EXEC SP_FirmasReporte 'Analitico de la deuda pública'
GO