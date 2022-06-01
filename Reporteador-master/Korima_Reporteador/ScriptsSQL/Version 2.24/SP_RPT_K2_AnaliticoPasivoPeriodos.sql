/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoPasivoPeriodos]    Script Date: 10/28/2014 13:47:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AnaliticoPasivoPeriodos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AnaliticoPasivoPeriodos]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoPasivoPeriodos]    Script Date: 10/28/2014 13:47:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_K2_AnaliticoPasivoPeriodos 0,0,1,3,2016,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_AnaliticoPasivoPeriodos]
@Miles Bit,
@Totales Bit,
--@MostrarVacios Bit,
@Periodo int,
@Periodo2 int,
@Ejercicio int,
@MostarSinSaldo bit
AS


--Manejo de miles de pesos
Declare @Division int
IF @Miles= 1 set @Division =1000
else Set @Division=1

--Tipos de estructura 5-5 , 5-6 , 6-6
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

declare @Tabla  table(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(18,4),
AbonosSinFlujo decimal(18,4),
TotalCargos decimal(18,4),
TotalAbonos decimal(18,4),
SaldoDeudor decimal(18,4),
SaldoAcreedor decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4),
mes int,
year int)

declare @TablaAcumulada  table(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(18,4),
AbonosSinFlujo decimal(18,4),
TotalCargos decimal(18,4),
TotalAbonos decimal(18,4),
SaldoDeudor decimal(18,4),
SaldoAcreedor decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4),
mes int,
year int)


declare @TablaInicial  table(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(18,4),
AbonosSinFlujo decimal(18,4),
TotalCargos decimal(18,4),
TotalAbonos decimal(18,4),
SaldoDeudor decimal(18,4),
SaldoAcreedor decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4),
mes int,
year int)


declare @Reporte  table(
NumeroCuenta varchar(max),
NombreCuenta varchar(max),
CargosSinFlujo decimal(18,4),
AbonosSinFlujo decimal(18,4),
TotalCargos decimal(18,4),
TotalAbonos decimal(18,4),
SaldoDeudor decimal(18,4),
SaldoAcreedor decimal(18,4),
SaldoFinal decimal(18,4),
FlujoDelperiodo decimal(18,4),
mes int,
year int)



insert @Tabla 
Select NumeroCuenta, 
Case C_Contable.Nivel
when 0 then NombreCuenta
when 1 then '  '+NombreCuenta 
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta)) 
end as NombreCuenta, 
(CargosSinFlujo/@division) as CargosSinFlujo, (AbonosSinFlujo/@division) as AbonosSinFlujo, (TotalCargos/@division) as TotalCargos, (TotalAbonos/@division) as TotalAbonos,
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
	  ((AbonosSinFlujo+TotalAbonos-TotalCargos))/@division as SaldoFinal, 
      ((AbonosSinFlujo+TotalAbonos-TotalCargos)-AbonosSinFlujo)/@division as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year
      
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 And TipoCuenta <> 'X'
AND  (NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
and Mes = @Periodo2 and Year = @Ejercicio
--------------------------------------------------------------------------------------------
insert @TablaAcumulada 
Select NumeroCuenta, 
Case C_Contable.Nivel
when 0 then NombreCuenta
when 1 then '  '+NombreCuenta 
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta)) 
end as NombreCuenta, 
(SUM(CargosSinFlujo)/@division) as CargosSinFlujo, (SUM(AbonosSinFlujo)/@division) as AbonosSinFlujo, (SUM(TotalCargos)/@division) as TotalCargos, (SUM(TotalAbonos)/@division) as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
          When 'C' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
          When 'E' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
          When 'G' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
          When 'I' Then SUM(CargosSinFlujo) - SUM(AbonosSinFlujo) + SUM(TotalCargos) - SUM(TotalAbonos)
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
          When 'I' Then 0
          Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo)  + SUM(TotalAbonos) - SUM(TotalCargos) 
      End as SaldoAcreedor,
	  ((SUM(AbonosSinFlujo)+SUM(TotalAbonos)-SUM(TotalCargos)))/@division as SaldoFinal, 
      (((SUM(AbonosSinFlujo)+SUM(TotalAbonos)-SUM(TotalCargos)))-SUM(AbonosSinFlujo))/@division as FlujoDelperiodo,
       @Periodo2 as mes,
      T_SaldosInicialesCont.Year
      
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 And TipoCuenta <> 'X'
AND  (NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
and (T_SaldosInicialesCont.Mes between @Periodo and @Periodo2) and Year = @Ejercicio
GROUP BY NumeroCuenta,NombreCuenta,Nivel,Year,TipoCuenta


insert @TablaInicial 
Select NumeroCuenta, 
Case C_Contable.Nivel
when 0 then NombreCuenta
when 1 then '  '+NombreCuenta 
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta)) 
end as NombreCuenta, 
(CargosSinFlujo/@division) as CargosSinFlujo, (AbonosSinFlujo/@division) as AbonosSinFlujo, (TotalCargos/@division) as TotalCargos, (TotalAbonos/@division) as TotalAbonos,
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
	  ((AbonosSinFlujo+TotalAbonos-TotalCargos))/@division as SaldoFinal, 
      ((AbonosSinFlujo+TotalAbonos-TotalCargos)-AbonosSinFlujo)/@division as FlujoDelperiodo,
      t_saldosInicialescont.mes,
      T_SaldosInicialesCont.Year
      
           
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
 And TipoCuenta <> 'X'
AND  (NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
and Mes = @Periodo and Year = @Ejercicio




Insert into @Reporte 
select 
Inicial.NumeroCuenta,
Inicial.NombreCuenta,
Inicial.CargosSinflujo,
Inicial.AbonosSinFlujo,
Acumulado.TotalCargos,
Acumulado.TotalAbonos,
Final.SaldoDeudor,
Final.SaldoAcreedor,
0 as SaldoFinal,
0 as FlujoDelPeriodo,
Final.Mes,
Final.year
from 
@TablaInicial Inicial
JOIN @Tabla Final
ON Inicial.NumeroCuenta=Final.NumeroCuenta 
JOIN @TablaAcumulada Acumulado
ON Inicial.NumeroCuenta=Acumulado.Numerocuenta
--------------------------------------------------------------------------------------------------
--If @MostarSinSaldo=0 DELETE FROM @Tabla where (CargosSinFlujo = 0 OR TotalCargos = 0 OR TotalAbonos = 0 OR SaldoFinal = 0 OR FlujoDelperiodo = 0)

--if @MostrarVacios=1 begin
insert @Reporte
SELECT NumeroCuenta, NombreCuenta,
0 as CargosSinflujo,
0 as AbonosSinFlujos,
0 as TotalCargos,
0 as TotalAbonos,
0 as SaldoDeudor,
0 as SaldoAcreedor,
0 as SaldoFinal,
0 as FlujoDelPeriodo,
@Periodo as Mes,
@Ejercicio as year
from C_Contable Where NumeroCuenta not in (Select NumeroCuenta from @Tabla ) and 
(NumeroCuenta like '2__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
--end


update @Reporte set SaldoFinal= ((AbonosSinFlujo+TotalAbonos-TotalCargos)/@division)
----
update @Reporte set FlujoDelperiodo = (((AbonosSinFlujo+TotalAbonos-TotalCargos)-AbonosSinFlujo)/@division )





if @Totales=1 Begin
if @MostarSinSaldo=1
SELECT * from @Reporte where NumeroCuenta ='2'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura ORDER BY NumeroCuenta
else
SELECT * from @Reporte where NumeroCuenta ='2'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura AND  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
end
else begin 
if @MostarSinSaldo=1
SELECT * from @Reporte ORDER BY NumeroCuenta
else 
SELECT * from @Reporte where  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
end

     
GO
