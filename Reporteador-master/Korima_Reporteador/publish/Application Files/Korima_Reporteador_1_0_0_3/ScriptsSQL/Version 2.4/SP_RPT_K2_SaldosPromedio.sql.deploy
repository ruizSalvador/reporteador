/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_SaldosPromedios]    Script Date: 08/28/2013 17:06:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_SaldosPromedios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_SaldosPromedios]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_SaldosPromedios]    Script Date: 08/28/2013 17:06:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[SP_RPT_K2_SaldosPromedios]
 @mes int,
 @año int,
 @NumeroCuenta varchar(30)
 AS
 BEGIN
 
 Declare @tablaSinSumas as table (
		Fecha datetime
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,Dia int
      ,TipoCuenta varchar(1)
      )
       Declare @tablaSumas as table (
		Fecha datetime
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,Dia int
      ,TipoCuenta varchar(1)
      ,SaldoDiario decimal(15,2)
      )
             Declare @tablaVacios as table (
		Fecha datetime
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,Dia int
      ,TipoCuenta varchar(1)
      ,SaldoDiario decimal(15,2)
      )
      Declare @tablaCalculo1 as table (
		Fecha datetime
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,Dia int
      ,TipoCuenta varchar(1)
      ,SaldoDiario decimal(15,2)
      )
            Declare @tablaCalculo2 as table (
		Fecha datetime
      ,NumeroCuentaContable varchar (30)
      ,NombreCuentaContable varchar (255)
      ,ImporteCargo decimal (15,2)
      ,ImporteAbono decimal (15,2)
      ,SaldoFila decimal (19,2)
      ,SaldoInicial decimal(18,2)
      ,Mes smallint
      ,year smallint
      ,Dia int
      ,TipoCuenta varchar(1)
      ,SaldoDiario decimal(15,2)
      ,SaldoPromedio decimal(15,2)
      )
      insert into @tablaSinSumas 
      
      --Se llena la consulta origen de polizas con su cuenta contable
SELECT
		T_Polizas.Fecha,
		C_Contable.NumeroCuenta AS NumeroCuentaContable,
		C_Contable.NombreCuenta AS NombreCuentaContable,
		isnull(D_Polizas.ImporteCargo,0) as ImporteCargo,
		isnull(D_Polizas.ImporteAbono,0)as ImporteAbono,
					Case C_Contable .TipoCuenta    
      When 'A' Then (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'C' Then (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'E' Then (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'G' Then (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      When 'I' Then (isnull(D_Polizas.ImporteCargo,0) - isnull(D_Polizas.ImporteAbono,0))
      Else (isnull(D_Polizas.ImporteAbono,0) - isnull(D_Polizas.ImporteCargo,0))
	End as SaldoFila,
 Case C_Contable .TipoCuenta  
          When 'A' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'C' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'E' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'G' Then T_SaldosInicialesCont.CargosSinFlujo 
          When 'I' Then T_SaldosInicialesCont.CargosSinFlujo 
          Else T_SaldosInicialesCont.AbonosSinFlujo 
      End as SaldoInicial,
      T_SaldosInicialesCont.Mes,
T_SaldosInicialesCont.year,
--C_Contable.TipoCuenta,
--ROW_NUMBER ()over (partition by NumeroCuenta order by NumeroCuenta,T_Polizas.Fecha) as Numero,
--T_Polizas.NoPoliza 
day(t_polizas.fecha) as Dia,
C_Contable .TipoCuenta 
FROM T_Polizas
JOIN
D_Polizas ON D_Polizas.IdPoliza= T_Polizas.IdPoliza
JOIN
C_Contable ON C_Contable.IdCuentaContable= D_Polizas.IdCuentaContable 
JOIN
T_SaldosInicialesCont ON C_Contable.IdCuentaContable= T_SaldosInicialesCont.IdCuentaContable
AND T_SaldosInicialesCont.Mes= T_Polizas.Periodo 
and T_SaldosInicialesCont.Year= T_Polizas.Ejercicio 
AND (T_SaldosInicialesCont.TotalAbonos <>0 or T_SaldosInicialesCont.TotalCargos<>0)
 where TipoCuenta <> 'X'
 and T_Polizas.NoPoliza>0
 and Mes >= @mes
		AND Mes <= @Mes
		AND [year] = @año
		--AND (NumeroCuenta = @NumeroCuenta OR substring(NumeroCuenta,1,LEN(@cuentaacumulable)) = @CuentaAcumulable)
		order by dia
		
-- se agurpan y suman los importes por dia
insert @tablaSumas
select 
Fecha,
NumeroCuentaContable,
NombreCuentaContable,
SUM(Importecargo) as cargo,
SUM(ImporteAbono) as abono,
SUM(SaldoFila) as saldofila,
SaldoInicial,
mes,
year,
dia,
TipoCuenta,
0 as SaldoDiario 
 from @tablaSinSumas 
 where NumeroCuentaContable =@NumeroCuenta 
 group by dia,
Fecha,
NumeroCuentaContable,
NombreCuentaContable,
SaldoInicial,
mes,
year,
TipoCuenta


-- se llena una tabla temporal con registros vacios para rellenar los dias faltantes en la tabla de resultados
declare @cont int
Declare @AñoTmp int
declare @MesTmp int
set @cont=1
set @AñoTmp=@Año
set @MesTmp=@Mes

-- Si el mes es 12, se suma un año y se regresa a enero para sacar la diferencia de dias entre el mes 12 y el mes 1 pero del siguiente año
if @mes=12 begin
	set @añoTmp= @año+1
	set @MesTmp=0
end

WHILE(@cont <= datediff(day,'1-'+convert(Varchar(max),@mes)+'-'+CONVERT(varchar(max),@año),'1-'+convert(Varchar(max),@mesTmp+1)+'-'+CONVERT(varchar(max),@AñoTmp)))BEGIN
INSERT into @tablaVacios 
SELECT TOP(1) convert(varchar(max),@cont)+'-'+convert(varchar(max),@mes)+'-'+convert(varchar(max),@año) as fecha,
numerocuentacontable,
NombreCuentaContable,
0 as ImporteCargo,
0 as Importeabono,
0 as saldofila,
saldoinicial,
mes,
year,
@cont as dia,
TipoCuenta,
0 as SaldoDiario
FROM @tablaSumas  

SET @cont=@cont+1

end

-- se llenan los dias faltantes en la tabla de sumas con registros en ceros
INSERT into @tablaSumas 
select * from @tablaVacios a where not exists  (select b.dia from @tablaSumas b where a.Dia=b.dia )

--Inserta el dia cero con el saldo inicial para el calculo
INSERT @tablaSumas 
SELECT TOP(1) fecha,
numerocuentacontable,
NombreCuentaContable,
0 as ImporteCargo,
0 as Importeabono,
saldoinicial as saldofila,
saldoinicial,
mes,
year,
0 as dia,
TipoCuenta,
0 as SaldoDiario
FROM @tablaSumas  

--se calcula el saldo diario
Insert into @tablaCalculo1 
select 
a.fecha,
a.numerocuentacontable,
a.NombreCuentaContable,
a.ImporteCargo,
a.Importeabono,
a.saldofila,
a.saldoinicial,
a.mes,
a.year,
a.dia,
a.TipoCuenta,
(Select SUM(b.SaldoFila) From @tablaSumas b  where b.Dia<= a.Dia )
as SaldoDiario
from @tablaSumas a order by dia

--se elimina el registro cero que se utilizo para el calculo
delete from @tablaCalculo1 where Dia=0

--se calcula el saldo promedio
INSERT @tablaCalculo2 
Select 
a.fecha,
a.numerocuentacontable,
a.NombreCuentaContable,
a.ImporteCargo,
a.Importeabono,
a.saldofila,
a.saldoinicial,
a.mes,
a.year,
a.dia,
a.TipoCuenta,
a.SaldoDiario,
((--Select a.SaldoInicial +
(Select SUM(C.SaldoDiario)From @tablaCalculo1 c where c.Dia<= a.dia))
/a.Dia) as SaldoPromedio
From @tablaCalculo1 a 

--retorna el resultado final del repote
	select * from @tablaCalculo2 order by NumeroCuentaContable,Dia



-- funcionalidad para emitir todas las cuentas contables, omitida por que el calculo tardaba mas de 10 minutos
--if @NumeroCuenta =''
--begin
--	declare @tablaCuentas as table (Numero int,	NumeroCuenta varchar(30))
--	declare @MaxRow int
--	declare @iter int
	
--	insert into @tablaCuentas 
--	select ROW_NUMBER()over(order by NumeroCuenta)as numero,NumeroCuenta  from C_Contable where Nivel>0 and Afectable=1

--	set @MaxRow=(select max(Numero)from @tablaCuentas)
	
--	set @iter= (select MIN(numero)from @tablaCuentas)

--	while @iter<=@MaxRow begin
--			declare @Cuenta varchar(30)
--			set @Cuenta=(select numerocuenta from @tablaCuentas where Numero=@iter )
--			insert @tablaCalculo3 
--			exec SP_RPT_K2_SaldosPromedios @Mes,@Año,@cuenta

--			set @iter=@iter+1
--		end

--select * from @tablaCalculo3 order by NumeroCuentaContable,Dia 
--end

END

GO

EXEC SP_FirmasReporte 'Saldos Promedio'
GO

