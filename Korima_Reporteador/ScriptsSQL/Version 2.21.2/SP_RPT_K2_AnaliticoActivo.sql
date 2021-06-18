/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoActivo]    Script Date: 10/28/2014 13:47:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_AnaliticoActivo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_AnaliticoActivo]
GO


/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_AnaliticoActivo]    Script Date: 10/28/2014 13:47:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_AnaliticoActivo]
@Miles Bit,
@Totales Bit,
--@MostrarVacios Bit,
@Periodo int,
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
      When '126' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division)*-1
      when '128' then ((AbonosSinFlujo-TotalCargos+TotalAbonos)/@division )*-1
      else (CargosSinFlujo+TotalCargos-TotalAbonos)/@division  end 
      as SaldoFinal,
      case substring(NumeroCuenta,1,3)
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
and Mes = @Periodo and Year = @Ejercicio

--If @MostarSinSaldo=0 DELETE FROM @Tabla where (CargosSinFlujo = 0 OR TotalCargos = 0 OR TotalAbonos = 0 OR SaldoFinal = 0 OR FlujoDelperiodo = 0)

--if @MostrarVacios=1 begin
insert @Tabla 
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
(NumeroCuenta like '1__'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura)
--end


if @Totales=1 Begin
if @MostarSinSaldo=1
SELECT * from @Tabla where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura ORDER BY NumeroCuenta
else
SELECT * from @Tabla where NumeroCuenta ='1'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura AND  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
end
else begin 
if @MostarSinSaldo=1
SELECT * from @Tabla ORDER BY NumeroCuenta
else 
SELECT * from @Tabla where  (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0) ORDER BY NumeroCuenta
end
    
GO
EXEC SP_FirmasReporte 'Analitico del activo'
GO