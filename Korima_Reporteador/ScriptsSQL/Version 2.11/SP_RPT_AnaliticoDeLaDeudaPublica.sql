/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaV2]    Script Date: 11/20/2012 17:27:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaV2]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaV2]    Script Date: 11/20/2012 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_AnaliticoDeLaDeudaPublicaV2]
@mes smallint,
@año smallint,
@MuestraVacios bit,
@Miles bit
AS
BEGIN

--- Manejo Miles de pesos
declare @Division int
if @Miles=1 set @Division=1000
else set @Division=1

--Tipos de estructura 5-5 , 5-6 , 6-6
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

--Variables de montos
Declare @21311AbonoSinFlujo decimal (15,2)
Declare @21410AbonoSinFlujo decimal (15,2)
Declare @21321AbonoSinFlujo decimal (15,2)
Declare @21420AbonoSinFlujo decimal (15,2)
--
Declare @21311FlujoDelPeriodo  decimal (15,2)
Declare @21410FlujoDelPeriodo  decimal (15,2)
Declare @21321FlujoDelPeriodo  decimal (15,2)
Declare @21420FlujoDelPeriodo  decimal (15,2)

--Creacion de tabla temporal
DECLARE @tabla AS TABLE(NumeroCuenta varchar(30),
	NombreCuenta varchar(255),
	AbonosSinFlujo decimal(15,2),
	FlujoDelperiodo decimal(15,2),
	mes smallint,
	year smallint,
	DeudaPublica varchar(50), 
	Plazo varchar(50), 
	ordenamiento int, 
	ordenamiento2 int)
	
--Creacion de tabla de titulos
DECLARE @tablaTitulos AS TABLE(NumeroCuenta varchar(30),
	NombreCuenta varchar(255),
	AbonosSinFlujo decimal(15,2),
	FlujoDelperiodo decimal(15,2),
	mes smallint,
	year smallint,
	DeudaPublica varchar(50), 
	Plazo varchar(50), 
	ordenamiento int, 
	ordenamiento2 int)

--Se llena la tabla temporal de 5 consultas
INSERT INTO @tabla 
SELECT NumeroCuenta, NombreCuenta,  
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior' as DeudaPublica,
      'Corto Plazo'as Plazo, 
      1 as ordenamiento,
      0 as ordenamiento2    
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'AND 
  numerocuenta in  ('21310'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,
				    '21410'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,
				    '21331'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 AND Mes=@mes AND Year=@año 

UNION

SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Exterior' as DeudaPublica,
      'Corto Plazo'as Plazo, 
      3 as ordenamiento,
      0 as ordenamiento2     
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X' AND
  numerocuenta in  ('21420'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura, 
				    '21332'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 AND Mes=@mes AND Year=@año  
  
UNION

SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior' as DeudaPublica,
      'Largo Plazo'as Plazo,
      5 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'  AND 
  numerocuenta in  ('22330'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,
				   '22310'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,
				   '22351'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  AND Mes=@mes AND Year=@año 
  
 UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Exterior' as DeudaPublica,
      'Largo Plazo'as Plazo,
      7 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'  AND 
  numerocuenta in  ('22320'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,
				   '22352'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  AND Mes=@mes AND Year=@año 
 
 UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      'Deuda Pública Interior y Exterior' as DeudaPublica,
      'Otros Pasivos'as Plazo,
      9 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'  AND 
  numerocuenta in  ('21900'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  AND Mes=@mes AND Year=@año 
 ----
  UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      '' as DeudaPublica,
      ''as Plazo,
      10 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'  AND 
  numerocuenta in  ('21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  AND Mes=@mes AND Year=@año 
    UNION
 
 SELECT NumeroCuenta, NombreCuenta, 
(AbonosSinFlujo) as AbonosSinFlujo, 
      (AbonosSinFlujo+(TotalAbonos-TotalCargos)) as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year,
      '' as DeudaPublica,
      ''as Plazo,
      11 as ordenamiento,
      0 as ordenamiento2      
FROM C_Contable, T_SaldosInicialesCont 
WHERE  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 AND TipoCuenta <> 'X'  AND 
  numerocuenta in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  AND Mes=@mes AND Year=@año
 ---
ORDER BY ordenamiento
 
 --Se calculan los montos y se guardan en variables 
 select @21410AbonoSinFlujo = (select abonossinflujo from @tabla where NumeroCuenta in('22410'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura))
 select @21410FlujoDelPeriodo = (select FlujoDelperiodo from @tabla where NumeroCuenta in('22410'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura))
 -- 
 select @21420AbonoSinFlujo = (select abonossinflujo from @tabla where NumeroCuenta in ('22420'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura))
 select @21420FlujoDelPeriodo  = (select FlujoDelperiodo from @tabla where NumeroCuenta in('22420'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura))


--Se llena la tabla de titulos sin valores
INSERT INTO @tablaTitulos  Values('','DEUDA PÚBLICA',Null,Null,@mes, @año,'','',1,1)
INSERT INTO @tablaTitulos  Values('','    Corto Plazo',Null,Null,@mes, @año,'','',1,2)
INSERT INTO @tablaTitulos  Values('','Deuda Interna',Null,Null,@mes, @año,'','',1,3)
INSERT INTO @tablaTitulos  Values('21310'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Instituciones de Crédito',0,0,@mes, @año,'','',0,4)
INSERT INTO @tablaTitulos  Values('21410'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Títulos y Valores',0,0,@mes, @año,'','',0,5)
INSERT INTO @tablaTitulos  Values('21331'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Arrendamientos Financieros',0,0,@mes, @año,'','',0,6)
INSERT INTO @tablaTitulos  Values('','Deuda Externa',Null,Null,@mes, @año,'','',1,7)
INSERT INTO @tablaTitulos  Values('','  Organismos Financieros Internacionales',0,0,@mes, @año,'','',0,8)
INSERT INTO @tablaTitulos  Values('','  Deuda Bilateral',0,0,@mes, @año,'','',0,9)
INSERT INTO @tablaTitulos  Values('21420'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Títulos y Valores',0,0,@mes, @año,'','',0,10)
INSERT INTO @tablaTitulos  Values('21332'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Arrendamientos Financieros',0,0,@mes, @año,'','',0,11)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,12)
INSERT INTO @tablaTitulos  Values('','Subtotal Corto Plazo',Null,Null,@mes, @año,'','',0,13)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,14)
INSERT INTO @tablaTitulos  Values('','    Largo Plazo',Null,Null,@mes, @año,'','',1,15)
INSERT INTO @tablaTitulos  Values('','Deuda Interna',Null,Null,@mes, @año,'','',1,16)
INSERT INTO @tablaTitulos  Values('22330'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Instituciones de Crédito',0,0,@mes, @año,'','',0,17)
INSERT INTO @tablaTitulos  Values('22310'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Títulos y Valores',0,0,@mes, @año,'','',0,18)
INSERT INTO @tablaTitulos  Values('22351'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Arrendamientos Financieros',0,0,@mes, @año,'','',0,19)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,20)
INSERT INTO @tablaTitulos  Values('','Deuda Externa',Null,Null,@mes, @año,'','',1,21)
INSERT INTO @tablaTitulos  Values('','  Organismos Financieros Internacionales',0,0,@mes, @año,'','',0,22)
INSERT INTO @tablaTitulos  Values('','  Deuda Bilateral',0,0,@mes, @año,'','',0,23)
INSERT INTO @tablaTitulos  Values('22320'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Títulos y Valores',0,0,@mes, @año,'','',0,24)
INSERT INTO @tablaTitulos  Values('22352'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Arrendamientos Financieros',0,0,@mes, @año,'','',0,25)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,26)
INSERT INTO @tablaTitulos  Values('','Subtotal Largo Plazo',Null,Null,@mes, @año,'','',0,27)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,28)
INSERT INTO @tablaTitulos  Values('21900'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'  Otros Pasivos',0,0,@mes, @año,'','',0,29)
INSERT INTO @tablaTitulos  Values('','',Null,Null,@mes, @año,'','',0,30)
INSERT INTO @tablaTitulos  Values('','Total Deuda y Otros Pasivos',Null,Null,@mes, @año,'','',1,31)

update @tablaTitulos 
set a.AbonosSinFlujo=isnull(b.AbonosSinFlujo,0)/@Division, a.FlujoDelPeriodo=isnull(b.FlujoDelPeriodo,0)/@Division 
from @tablaTitulos a
join @tabla b
 on a.numerocuenta=b.numerocuenta
 ----
 --Se suman las cantidades de la cuenta 22 y 23, se le resta las cantidades actuales del reporte, y el resultado se suma a la cuenta 21900
 Declare @AbonosSinFlujo decimal(15,2)
 select @AbonosSinFlujo = SUM(Isnull(AbonosSinFlujo,0)) From @tabla Where numerocuenta in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 
  Declare @RESTAAbonosSinFlujo decimal(15,2)
 select @RESTAAbonosSinFlujo = SUM(Isnull(AbonosSinFlujo,0)) From @tabla Where numerocuenta not in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
 
 set @AbonosSinFlujo=@AbonosSinFlujo-@RESTAAbonosSinFlujo
 --
 
  Declare @FlujoDelPeriodo decimal(15,2)
  select @FlujoDelPeriodo = SUM(Isnull(FlujoDelperiodo,0)) From @tabla Where numerocuenta in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  
  Declare @RESTAFlujoDelPeriodo decimal(15,2)
  select @RESTAFlujoDelPeriodo = SUM(Isnull(FlujoDelperiodo,0)) From @tabla Where numerocuenta not in  ('22000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)
  
  Set @FlujoDelPeriodo=@FlujoDelPeriodo-@RESTAFlujoDelPeriodo
  
 
 update @tablaTitulos 
set AbonosSinFlujo=(AbonosSinFlujo+@AbonosSinFlujo)/@Division, FlujoDelPeriodo=isnull(FlujoDelPeriodo+@FlujoDelPeriodo,0)/@Division 
from @tablaTitulos
 Where numerocuenta in  ('21900'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura,'21000'+REPLICATE('0',@Estructura1-5)+'-'+@CerosEstructura)

 
 ----

Update @tablaTitulos 
set AbonosSinFlujo = (select SUM(AbonosSinflujo) from @tablaTitulos where ordenamiento2 in(4,5,6,10,11)), 
FlujoDelperiodo = (select SUM(FlujoDelperiodo) from @tablaTitulos where ordenamiento2 in(4,5,6,10,11))
where ordenamiento2=13

Update @tablaTitulos 
set AbonosSinFlujo = (select SUM(AbonosSinflujo) from @tablaTitulos where ordenamiento2 in(17,18,19,24,25)), 
FlujoDelperiodo = (select SUM(FlujoDelperiodo) from @tablaTitulos where ordenamiento2 in(17,18,19,24,25))
where ordenamiento2=27

UPDATE @tablaTitulos 
Set AbonosSinFlujo=(select SUM(AbonosSinflujo) from @tablaTitulos where ordenamiento2 in(13,27,29)),
FlujoDelperiodo = (select SUM(FlujoDelperiodo) from @tablaTitulos where ordenamiento2 in(13,27,29))
where ordenamiento2=31

--

-- 

--Consulta final CON VACIOS

 if @MuestraVacios=1  
 begin
 select * from @tablaTitulos
 order by  ordenamiento2  
 end
 
 --Consulta final SIN VACIOS
 else  
 select * from @tablaTitulos
 where (AbonosSinFlujo <>0 OR FlujoDelperiodo <>0 )or AbonosSinFlujo is null or FlujoDelperiodo is null
  order by ordenamiento2 
 

END
GO
EXEC SP_FirmasReporte 'Analítico de la Deuda Pública y Otros Pasivos'
GO



