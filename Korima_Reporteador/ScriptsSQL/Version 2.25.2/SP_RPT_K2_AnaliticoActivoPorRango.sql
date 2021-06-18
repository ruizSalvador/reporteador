 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoActivoPorRango] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AnaliticoActivoPorRango]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AnaliticoActivoPorRango]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoActivoPorRango]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
Create PROCEDURE [dbo].[SP_RPT_K2_AnaliticoActivoPorRango]  
@Miles Bit,  
@Totales Bit,  
@PeriodoFinal int,  
@Ejercicio int,  
@MostarSinSaldo bit,  
@PeriodoInicial int,  
@Redondeo bit  
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
  
--Tabla para el periodo FINAL  
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
  
--Tabla para el periodo INICIAL  
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
  
--Tabla para el periodo ACUMULADO  
declare @TablaAcumulado  table(  
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
  
--Tabla para el reporte  
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
  
--PERIODO FINAL INICIO  
insert @Tabla   
Select NumeroCuenta,   
Case C_Contable.Nivel  
when 0 then NombreCuenta  
when 1 then '  '+NombreCuenta   
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta))   
end as NombreCuenta,   
(CargosSinFlujo/@division) as CargosSinFlujo, (AbonosSinFlujo/@division)*-1 as AbonosSinFlujo, (TotalCargos/@division) as TotalCargos, (TotalAbonos/@division) as TotalAbonos,  
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
	  When '116' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1 
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1  
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division )*-1  
      else (CargosSinFlujo+TotalCargos-TotalAbonos)/@division  end   
      as SaldoFinal,  
      case substring(NumeroCuenta,1,3)  
	  When '116' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division )*-1  
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division )*-1  
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division)*-1  
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)/@division end   
       as FlujoDelperiodo,  
      t_saldosInicialescont.mes,  
      T_SaldosInicialesCont.Year  
        
             
From C_Contable, T_SaldosInicialesCont   
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable  
 And TipoCuenta <> 'X'  
AND  (NumeroCuenta like '1__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)  
and Mes = @PeriodoFinal and Year = @Ejercicio  
--PERIODO FINAL FIN  

--PERIODO INICIAL INICIO  
insert @TablaInicial   
Select NumeroCuenta,   
Case C_Contable.Nivel  
when 0 then NombreCuenta  
when 1 then '  '+NombreCuenta   
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta))   
end as NombreCuenta,   
(CargosSinFlujo/@division) as CargosSinFlujo, (AbonosSinFlujo/@division)*-1 as AbonosSinFlujo, (TotalCargos/@division) as TotalCargos, (TotalAbonos/@division) as TotalAbonos,  
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
	  When '116' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1 
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1  
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division )*-1  
      else (CargosSinFlujo+TotalCargos-TotalAbonos)/@division  end   
      as SaldoFinal,  
      case substring(NumeroCuenta,1,3)  
	  When '116' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division )*-1  
      When '126' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division )*-1  
      When '128' then (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division)*-1  
      else ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)/@division end   
       as FlujoDelperiodo,  
      t_saldosInicialescont.mes,  
      T_SaldosInicialesCont.Year  
        
             
From C_Contable, T_SaldosInicialesCont   
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable  
 And TipoCuenta <> 'X'  
AND  (NumeroCuenta like '1__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)  
and Mes = @PeriodoInicial and Year = @Ejercicio  
--PERIODO INICIAL FIN  

--PERIODO ACUMULADO INICIO  
insert @TablaAcumulado   
Select NumeroCuenta,   
Case C_Contable.Nivel  
when 0 then NombreCuenta  
when 1 then '  '+NombreCuenta   
when 2 then '    '+substring( NombreCuenta,1,1)+SUBSTRING(lower(Nombrecuenta),2,len(Nombrecuenta))   
end as NombreCuenta,   
(SUM(CargosSinFlujo)/@division) as CargosSinFlujo, (SUM(AbonosSinFlujo)/@division)*-1 as AbonosSinFlujo, (SUM(TotalCargos)/@division) as TotalCargos, (SUM(TotalAbonos)/@division) as TotalAbonos,  
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
          When 'G' Then 0            When 'I' Then 0  
          Else SUM(AbonosSinFlujo) - SUM(CargosSinFlujo)  + SUM(TotalAbonos) - SUM(TotalCargos)   
      End as SaldoAcreedor,  
      case substring(NumeroCuenta,1,3)  
	  When '116' then ((SUM(AbonosSinFlujo)-SUM(TotalCargos+TotalAbonos))/@division)*-1 
      When '126' then ((SUM(AbonosSinFlujo)-SUM(TotalCargos+TotalAbonos))/@division)*-1  
      when '128' then ((SUM(AbonosSinFlujo)-SUM(TotalCargos)+SUM(TotalAbonos))/@division )*-1  
      else (SUM(CargosSinFlujo+TotalCargos)-SUM(TotalAbonos))/@division  end   
      as SaldoFinal,  
      case substring(NumeroCuenta,1,3)  
	  When '116' then (((SUM(AbonosSinFlujo)-SUM(TotalCargos)+SUM(TotalAbonos))-SUM(AbonosSinFlujo))/@division )*-1 
      When '126' then (((SUM(AbonosSinFlujo)-SUM(TotalCargos)+SUM(TotalAbonos))-SUM(AbonosSinFlujo))/@division )*-1  
      When '128' then (((SUM(AbonosSinFlujo)-SUM(TotalCargos)+SUM(TotalAbonos))-SUM(AbonosSinFlujo))/@division)*-1  
      else ((SUM(CargosSinFlujo)+SUM(TotalCargos)-SUM(TotalAbonos))-SUM(cargossinflujo))/@division end   
       as FlujoDelperiodo,  
      @PeriodoFinal as Mes,  
      T_SaldosInicialesCont.Year  
        
             
From C_Contable, T_SaldosInicialesCont   
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable  
 And TipoCuenta <> 'X'  
AND  (NumeroCuenta like '1__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)  
and (T_SaldosInicialesCont.Mes between @PeriodoInicial and @PeriodoFinal) and Year = @Ejercicio  
GROUP BY NumeroCuenta,NombreCuenta,Nivel,Year,TipoCuenta  
--PERIODO ACUMULADO FIN  

-- se llena la tabla final con toda la informacion de los tres periodos INICIO  
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
JOIN @TablaAcumulado Acumulado  
ON Inicial.NumeroCuenta=Acumulado.Numerocuenta  
--FIN  
-- se recalculan los saldos  
--update @Reporte set SaldoFinal= ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1  
update @Reporte set SaldoFinal= ((AbonosSinFlujo+TotalCargos-TotalAbonos)/@division)  
where substring(NumeroCuenta,1,3) in ('116','126','128')  
  
update @Reporte set SaldoFinal= (CargosSinFlujo+TotalCargos-TotalAbonos)/@division  
where substring(NumeroCuenta,1,3) not in ('116','126','128')  
----  
update @Reporte set FlujoDelperiodo = (((AbonosSinFlujo-TotalCargos+TotalAbonos)-AbonosSinFlujo)/@division )*-1  
where substring(NumeroCuenta,1,3) in ('116','126','128')  
  
update @Reporte set FlujoDelPeriodo= ((CargosSinFlujo+TotalCargos-TotalAbonos)-cargossinflujo)/@division  
 where substring(NumeroCuenta,1,3) not in ('116','126','128')  
  
  
--PARA MOSTRAR CUENTAS SIN SALDO  
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
@PeriodoFinal as Mes,  
@Ejercicio as year  
from C_Contable Where NumeroCuenta not in (Select NumeroCuenta from @Tabla ) and   
(NumeroCuenta like '1__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)  
  
  
if @Totales=1  
 Begin  
   if @MostarSinSaldo=1   
   begin  
    if @Redondeo=1   
    begin  
     SELECT  NumeroCuenta, NombreCuenta,  
      Round(CargosSinflujo,0) as CargosSinFlujo,  
     Round(AbonosSinFlujo,0) as AbonosSinFlujo,  
     Round(TotalCargos,0) as TotalCargos,  
     Round(TotalAbonos,0) as TotalAbonos,  
     Round(SaldoDeudor,0) as SaldoDeudor,  
     Round(SaldoAcreedor,0) as SaldoAcreedor,  
     Round(SaldoFinal,0) as SaldoFinal,  
     Round(FlujoDelPeriodo,0) as FlujoDelPeriodo,  
     Mes,  
     year from @Reporte where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura ORDER BY NumeroCuenta  
     end  
    else  
     select * from @Reporte where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura ORDER BY NumeroCuenta  
    end  
   
   else begin  
   if @Redondeo=1 begin  
   SELECT  NumeroCuenta, NombreCuenta,  
    Round(CargosSinflujo,0) as CargosSinFlujo,  
   Round(AbonosSinFlujo,0) as AbonosSinFlujo,  
   Round(TotalCargos,0) as TotalCargos,  
   Round(TotalAbonos,0) as TotalAbonos,  
   Round(SaldoDeudor,0) as SaldoDeudor,  
   Round(SaldoAcreedor,0) as SaldoAcreedor,  
   Round(SaldoFinal,0) as SaldoFinal,  
   Round(FlujoDelPeriodo,0) as FlujoDelPeriodo,  
   Mes,  
   year from @Reporte where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura AND  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta end  
 else  
  select *from @Reporte where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura AND  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta  
 end  
 end  
else begin   
 if @MostarSinSaldo=1 begin  
   if @Redondeo=1 begin  
    SELECT  NumeroCuenta, NombreCuenta,  
     Round(CargosSinflujo,0) as CargosSinFlujo,  
    Round(AbonosSinFlujo,0) as AbonosSinFlujo,  
    Round(TotalCargos,0) as TotalCargos,  
    Round(TotalAbonos,0) as TotalAbonos,  
    Round(SaldoDeudor,0) as SaldoDeudor,  
    Round(SaldoAcreedor,0) as SaldoAcreedor,  
    Round(SaldoFinal,0) as SaldoFinal,  
    Round(FlujoDelPeriodo,0) as FlujoDelPeriodo,  
    Mes,  
    year from @Reporte ORDER BY NumeroCuenta end  
   else  
    Select * from @Reporte ORDER BY NumeroCuenta  
  end  
 else begin  
  if @Redondeo=1 begin  
    SELECT  NumeroCuenta, NombreCuenta,  
     Round(CargosSinflujo,0) as CargosSinFlujo,  
    Round(AbonosSinFlujo,0) as AbonosSinFlujo,  
    Round(TotalCargos,0) as TotalCargos,  
    Round(TotalAbonos,0) as TotalAbonos,  
    Round(SaldoDeudor,0) as SaldoDeudor,  
    Round(SaldoAcreedor,0) as SaldoAcreedor,  
    Round(SaldoFinal,0) as SaldoFinal,  
    Round(FlujoDelPeriodo,0) as FlujoDelPeriodo,  
    Mes,  
    year from @Reporte where  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta end  
  else  
   Select * from @Reporte where  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta  
 end  
end  
   
 --if @Redondeo=1 begin  
 -- select   
 --  NumeroCuenta, NombreCuenta,  
 --  Round(CargosSinflujo,0) as CargosSinFlujo,  
 -- Round(AbonosSinFlujo,0) as AbonosSinFlujo,  
 -- Round(TotalCargos,0) as TotalCargos,  
 -- Round(TotalAbonos,0) as TotalAbonos,  
 -- Round(SaldoDeudor,0) as SaldoDeudor,  
 -- Round(SaldoAcreedor,0) as SaldoAcreedor,  
 -- Round(SaldoFinal,0) as SaldoFinal,  
 -- Round(FlujoDelPeriodo,0) as FlujoDelPeriodo,  
 -- Mes,  
 -- year  
 -- from @Reporte  
 -- end  
 -- else   
 -- select * from @Reporte  
  
   
  --go
  --exec SP_RPT_K2_AnaliticoActivoPorRango @Miles=0,@Totales=0,@PeriodoFinal=6,@Ejercicio=2017,@MostarSinSaldo=1,@PeriodoInicial=1,@Redondeo=0