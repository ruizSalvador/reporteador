--Se verifica que exista el procedimiento almacenado  y se borra.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioV2]
GO

--Se crea el procedimiento almacenado
--Exec SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioV2 12,2019,0
CREATE PROCEDURE [dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioV2] 
 @mes int,
 @ejercicio int,
 @miles Bit
  
AS
BEGIN


DECLARE @valor decimal(15,3)
DECLARE @valor1 decimal(15,3)
DECLARE @valor2 decimal(15,3)
DECLARE @valor3 decimal(15,3)
DECLARE @sum decimal(15,3)
DECLARE @sum1 decimal(15,3)
DECLARE @sum2 decimal(15,3)
DECLARE @sum3 decimal(15,3)
DECLARE @Division int

if @miles=1 set @Division=1000
else set @Division = 1


-------------------------------------------------------------------------------------------------------------------------
--ANTERIORMENTE UNA VISTA, MODIFICADO A TABLA TEMPORAL
-------------------------------------------------------------------------------------------------------------------------
Declare @Vista as table(NumeroCuenta varchar(30),
						Nombrecuenta varchar(max),
						CargosSinFlujo decimal(15,2),
						AbonosSinFlujo decimal(15,2),
						TotalCargos decimal(15,2),
						TotalAbonos decimal(15,2),
						SaldoDeudor decimal(15,2),
						SaldoAcreedor decimal(15,2)
						,mes int,
						Year int)

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

INSERT INTO @Vista
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
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '32%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '325%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION

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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '311%'
and (T_SaldosInicialesCont.mes in (@mes))
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '312%'
and (T_SaldosInicialesCont.mes in (@mes) )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '313%' 
and (T_SaldosInicialesCont.mes in (@mes))
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '321%'
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '323%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and NumeroCuenta like '324%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X'
and NumeroCuenta like '33%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X'
and NumeroCuenta like '31%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X'
and NumeroCuenta like '40%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )

UNION
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X'
and NumeroCuenta like '50%' 
and (T_SaldosInicialesCont.mes=@mes )
And (T_SaldosInicialesCont.Year between @ejercicio-1 and @ejercicio )
------------------------------------------------------------------------------------------------------------------------

--Inserta en tabla de memoria todos los registros de la consulta para mas fácil manejo de la información
--Tabla del Ejercicio Actual 
DECLARE @ejActual TABLE (NoCuenta varchar (30), PatContribuido decimal(15,2), 
PatGenEAnt decimal(15,2), PatGenEjerc decimal(15,2), AjusCambioValor decimal(15,2))

--Tabla del Ejercicio Anterior 
DECLARE @ejAnterior TABLE (NoCuenta varchar (30), PatContribuido decimal(15,2), 
PatGenEAnt decimal(15,2), PatGenEjerc decimal(15,2), AjusCambioValor decimal(15,2))


Insert Into @ejActual
--PatContribuido
Select NumeroCuenta,TotalAbonos - TotalCargos,0,0,0  
From @Vista
Where mes=@mes and year=@ejercicio  and NumeroCuenta  In 
('31000-00000','31100-00000', '31200-00000', '31300-00000', 
'31000-000000','31100-000000', '31200-000000', '31300-000000',
'310000-00000','311000-00000', '312000-00000', '313000-00000', 
'310000-000000','311000-000000', '312000-000000', '313000-000000')
--PatGenEjerc
--Select * from @ejActual
Insert Into @ejActual
--Union All
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From @Vista
Where mes=@mes and year=@ejercicio and--NumeroCuenta Like '325%' Or 
NumeroCuenta In 
('31000-00000', 
'31000-000000',
'310000-000000',
'32000-00000','32100-00000', '32300-00000', '32400-00000','33000-00000',
'32000-000000','32100-000000', '32300-000000', '32400-000000','33000-000000',
'320000-00000','321000-00000', '323000-00000', '324000-00000','330000-00000',
'320000-000000','321000-000000', '323000-000000', '324000-000000','330000-000000'
)
--------------------------ADDED254-----------------------------------------------------------

Declare @CambiosHacienda as table(NumeroCuenta varchar(30),
						Nombrecuenta varchar(max),
						CargosSinFlujo decimal(15,2),
						AbonosSinFlujo decimal(15,2),
						TotalCargos decimal(15,2),
						TotalAbonos decimal(15,2),
						SaldoDeudor decimal(15,2),
						SaldoAcreedor decimal(15,2)
						,mes int,
						Year int)

Insert into @CambiosHacienda
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
          When 'I' Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor,
      T_SaldosInicialesCont.mes,
      T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
--and NumeroCuenta like '311%'
and NumeroCuenta In 
('31100-00000', '31200-00000', '31300-00000', 
 '31100-000000', '31200-000000', '31300-000000',
 '311000-00000', '312000-00000', '313000-00000',  
 '311000-000000', '312000-000000', '313000-000000'
)
and( T_SaldosInicialesCont.mes = @mes and  T_SaldosInicialesCont.Year = @ejercicio)


Insert Into @ejActual

Select NumeroCuenta, 0,0,(TotalAbonos - TotalCargos),0  
From @CambiosHacienda
Where  
NumeroCuenta In 
('31100-00000', '31200-00000', '31300-00000', 
 '31100-000000', '31200-000000', '31300-000000', 
 '311000-00000', '312000-00000', '313000-00000',
 '311000-000000', '312000-000000', '313000-000000'
)
--------------------------------------------------------------------------------------------------
--Union All
--Select * from @ejActual
Insert Into @ejActual
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From @Vista 
Where mes=@mes and year=@ejercicio and NumeroCuenta NOT In 
('32000-00000','32100-00000', '32300-00000', '32400-00000','33000-00000',
'32000-000000','32100-000000', '32300-000000', '32400-000000','33000-000000',
'320000-00000','321000-00000', '323000-00000', '324000-00000','330000-00000',
'320000-000000','321000-000000', '323000-000000', '324000-000000','330000-000000',
'31000-00000','31100-00000', '31200-00000', '31300-00000', 
'31000-000000','31100-000000', '31200-000000', '31300-000000', 
'310000-00000','311000-00000', '312000-00000', '313000-00000',
'310000-000000','311000-000000', '312000-000000', '313000-000000')

delete from @ejActual where NoCuenta in('50000-00000','50000-000000','500000-000000')

Insert Into @ejActual
Select NumeroCuenta, 0,0,SaldoDeudor,0  
From @Vista 
Where mes=@mes and year=@ejercicio and NumeroCuenta In 
('50000-00000','50000-000000','500000-00000','500000-000000')

Insert Into @ejAnterior
--PatContribuido
Select NumeroCuenta,TotalAbonos - TotalCargos,AbonosSinFlujo,0,0  
From @Vista
Where mes=@mes and year=@ejercicio-1  and NumeroCuenta  In 
('31000-00000','31100-00000', '31200-00000', '31300-00000', 
'31000-000000','31100-000000', '31200-000000', '31300-000000', 
'310000-00000','311000-00000', '312000-00000', '313000-00000',
'310000-000000','311000-000000', '312000-000000', '313000-000000')
--PatGenEjerc
Insert Into @ejAnterior
--Union All
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From @Vista
Where mes=@mes and year=@ejercicio-1 and (--NumeroCuenta Like '325%' Or 
NumeroCuenta In 
('31000-00000','31100-00000', '31200-00000', '31300-00000', 
'31000-000000','31100-000000', '31200-000000', '31300-000000', 
'310000-00000','311000-00000', '312000-00000', '313000-00000',
'310000-000000','311000-000000', '312000-000000', '313000-000000',
'32000-00000','32100-00000', '32300-00000', '32400-00000','33000-00000',
'32000-000000','32100-000000', '32300-000000', '32400-000000','33000-000000',
'320000-00000','321000-00000', '323000-00000', '324000-00000','330000-00000',
'320000-000000','321000-000000', '323000-000000', '324000-000000','330000-000000'))
--Union All
Insert Into @ejAnterior
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From @Vista 
Where mes=@mes and year=@ejercicio-1 and NumeroCuenta not in ('32000-00000','32100-00000', '32300-00000', '32400-00000','33000-00000',
'32000-000000','32100-000000', '32300-000000', '32400-000000','33000-000000',
'320000-00000','321000-00000', '323000-00000', '324000-00000','330000-00000',
'320000-000000','321000-000000', '323000-000000', '324000-000000','330000-000000',
'50000-00000','50000-000000','500000-00000','500000-000000')

delete from @ejAnterior where NoCuenta in('50000-00000','50000-000000','500000-00000','500000-000000')


Insert Into @ejAnterior 
Select NumeroCuenta, 0,0,SaldoDeudor,0  
From @Vista 
Where mes=@mes and year=@ejercicio-1 and NumeroCuenta In 
('50000-00000','50000-000000','500000-00000','500000-000000')


--Tabla de resultado a regresar						
DECLARE @eReport TABLE (Nombre varchar(255), PatContribuido decimal(15,2), PatGenEAnt decimal(15,2), PatGenEjerc decimal(15,2), 
AjusCambioValor decimal(15,2),Sumatoria decimal(15,2),negritas bit, secciongrupo char(1), orden int)

DECLARE @v decimal(15,2)
DECLARE @v1 decimal(15,2)

Select @v1 = (Select SUM(AbonosSinFlujo) From @Vista
Where SUBSTRING(NumeroCuenta,1,4) = '3210' And mes = 1 And [Year] = @ejercicio)
Select @v = @v1



--Update @eReport Set Sumatoria = PatContribuido + PatGenEAnt + PatGenEjerc + AjusCambioValor
--Select @sum =  PatContribuido  from @eReport
--Select @sum1 =  PatGenEAnt  from @eReport
--Select @sum2 =  PatGenEjerc  from @eReport
--Select @sum3 =  AjusCambioValor  from @eReport

--------------------ANTERIOR-----------------------------

--Select @valor = sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
--select @valor1= sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
--set @valor = ISNULL(@valor,0)/@Division
--set @valor1 = ISNULL(@valor1,0)/@Division


--Titulos
--Insert Into @eReport
--Select 'Rectificaciones de Resultados de Ejercicios Anteriores',null, @valor1, @valor,null,@valor1+@valor,  1, 'B', 13

--Union All
--Select '',null, null, null,null, null, 0, 'X', 2

--Union All
--Titulos FIN

--seccion 311 312 313 ANTERIOR
--Select @valor = sum(PatGenEAnt ) FROM @ejAnterior Where NoCuenta IN('31100-00000','31100-000000','311000-00000','311000-000000')
Select  @valor = PatGenEjerc  FROM @ejAnterior Where NoCuenta IN('31100-00000','31100-000000','311000-00000','311000-000000')
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Aportaciones', @valor, null,null,null, @valor, 0, 'C',2


Select @valor = sum(PatGenEAnt ) FROM @ejAnterior Where NoCuenta IN('31200-00000','31200-000000','312000-00000','312000-000000')
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Donaciones de Capital', @valor, null,null,null, @valor, 0, 'C',3
--Select @valor = PatGenEjerc FROM @ejAnterior Where NoCuenta = '330000-00000'
Select @valor = ISNULL((Select AbonosSinFlujo from @Vista where NumeroCuenta in ('313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and [Year] = @Ejercicio-1),0)
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Actualización de la Hacienda Pública/Patrimonio',@valor, null,  null,null, @valor, 0, 'C',4

Set @valor= (Select isnull(sum(PatContribuido),0) from @eReport where orden in(2,3,4))
Insert Into @eReport
Select 'Hacienda Pública / Patrimonio Contribuido Neto de '+convert(varchar(10),@Ejercicio-1),@valor, null, null,null, @valor, 1, 'C', 1

Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 5
--seccion 311 312 313 FIN

--Seccion 321 322 323 324 ANTERIOR

Select @valor1 = (Select sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN ( '32100-00000','32100-000000','321000-00000','321000-000000'))
Select @valor2 = (Select sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN ( '40000-00000','40000-000000','400000-00000','400000-000000'))
Select @valor3 = (Select sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN ( '50000-00000','50000-000000','500000-00000','500000-000000'))
set @valor1 = ISNULL(@valor1,0)/@Division
set @valor2 = ISNULL(@valor2,0)/@Division
set @valor3 = ISNULL(@valor3,0)/@Division
Select @valor = @valor1 + @valor2 - @valor3
select @valor1 =(select SUM(AjusCambioValor) FROM @ejAnterior Where NoCuenta in('33000-00000','33000-000000','330000-00000','330000-000000'))
set @valor1 = ISNULL(@valor1,0)/@Division
declare @ADContrario as decimal(18,2)
set @ADContrario = -@valor--Se agrega para las Variaciones
Insert Into @eReport
Select 'Resultados del Ejercicio (Ahorro/Desahorro)', null, null, @valor, @valor1, @valor+@valor1,0, 'D',7

Select @valor = PatGenEjerc FROM @ejAnterior Where NoCuenta IN ( '32200-00000','32200-000000','322000-00000','322000-000000')
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Resultados de Ejercicios Anteriores ',null, @valor, null,null, @valor, 0, 'D', 8


Select @valor = PatGenEjerc FROM @ejAnterior  Where NoCuenta IN ( '32300-00000', '32300-000000', '323000-00000','323000-000000')
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Revalúos', null, @valor, null,null, @valor, 0, 'D',9

Select @valor = PatGenEjerc FROM @ejAnterior Where NoCuenta IN ( '32400-00000', '32400-000000', '324000-00000','324000-000000')
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Reservas', null, @valor, null,null, @valor, 0, 'D',10

Select @valor = sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
select @valor1= sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
set @valor = ISNULL(@valor,0)/@Division
set @valor1 = ISNULL(@valor1,0)/@Division
Insert Into @eReport
Select 'Rectificaciones de Resultados de Ejercicios Anteriores',null, @valor1, null,null,@valor1,  0, 'D', 11

select @valor = (Select isnull(sum(PatGenEAnt),0) from @eReport where orden in(8,9,10,11))
Select @valor1 = (Select isnull(sum(Patgenejerc),0) from @eReport where orden in(7))
Insert Into @eReport
Select 'Hacienda Pública / Patrimonio Generado Neto de '+convert(varchar(10),@Ejercicio-1),null, @valor,@valor1,null,@valor+@valor1,  1, 'D', 6

Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 12


--Select @valor = PatGenEjerc FROM @ejAnterior Where NoCuenta IN ('331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Select @valor = (Select ISNULL(SaldoAcreedor,0) from @Vista where NumeroCuenta in ('331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and [Year] = @Ejercicio-1)
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Resultado por Posición Monetaria', null,null , null,@valor, @valor, 0, 'E',14
--Select @valor = PatGenEjerc FROM @ejAnterior Where NoCuenta IN ('332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)
Select @valor = (Select ISNULL(SaldoAcreedor,0) from @Vista where NumeroCuenta in ('332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and [Year] = @Ejercicio-1)
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Resultado por Tenencia de Activos no Monetarios', null,null , null,@valor, @valor, 0, 'E',15

Select @valor2 = (Select isnull(SUM(AjusCambioValor),0) from @eReport where orden in(14,15))
Insert Into @eReport
Select 'Exceso o Insuficiencia en la Actualización de la Hacienda Pública / Patrimonio Neto de '+convert(varchar(10),@Ejercicio-1),null, null, null,@valor2,@valor2,  1, 'E', 13


Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 16



--Select @valor = PatContribuido FROM @ejAnterior Where NoCuenta IN ( '31000-00000', '31000-000000', '310000-000000')
--Select @valor1 = PatGenEAnt FROM @ejAnterior Where NoCuenta IN ( '32000-00000', '32000-000000', '320000-000000')
--select @valor2 =AjusCambioValor FROM @ejAnterior Where NoCuenta in('33000-00000','33000-000000','330000-000000')
Select @valor= (Select SUM(isnull(PatContribuido,0)) from @eReport where orden in(2,3,4))
select @valor1 = (Select SUM(isnull(PatGenEAnt,0)) from @eReport where orden in(8,9,10,11))
Select @valor2 = (Select SUM(isnull(AjusCambioValor,0)) from @eReport where orden in(14,15))
Declare @valor4 as decimal(15,4)
select @valor4 =(Select SUM (isnull(Patgenejerc,0)) from @eReport where orden in (7))

Insert Into @eReport
Select 'Hacienda Pública/Patrimonio Neto Final de '+convert(varchar(10),@Ejercicio-1), @valor,@valor1, @valor4 , @valor2, @valor+@valor1+@valor2+@valor4, 1, 'D', 17
--Select @valor

Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 18
--Seccion 321 322 323 324 FIN

---------------------------ACTUAL---------------------------
--Select * from @Vista
--seccion 311 312 313 ACTUAL

--Select @valor = sum(PatGenEjerc ) FROM @ejActual Where NoCuenta IN('31100-00000','31100-000000','311000-000000')
Select @valor = (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes AND YEAR =@EJERCICIO) - (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('311'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio - 1 )
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Aportaciones', @valor, null,null,null, @valor, 0, 'C',21

--Select @valor = sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('31200-00000','31200-000000','312000-000000')
Select @valor = (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes  AND YEAR =@EJERCICIO) - (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('312'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio-1 )
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Donaciones de Capital', @valor, null,null,null, @valor, 0, 'C',22

--Select @valor = sum(PatGenEjerc) FROM @ejActual Where NoCuenta in ('31300-00000','31300-000000','313000-000000')
Select @valor = (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes AND YEAR =@EJERCICIO) - (Select SaldoAcreedor FROM @Vista Where NumeroCuenta IN('313'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio -1)
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Actualización de la Hacienda Pública/Patrimonio',@valor, null,  null,null, @valor, 0, 'C',23

Select @valor= (Select SUM(isnull(PatContribuido,0)) from @eReport where orden in(21,23,22))
Insert Into @eReport
Select 'Cambios en la Hacienda Pública/Patrimonio Contribuido Neto de '+convert(varchar(10),@Ejercicio),@valor, null, null,null,@valor,  1, 'X', 20

--Update @eReport Set Sumatoria = (Select SUM(PatContribuido) From @eReport Where orden In (5,6))
--Where orden = 6
Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 24
--seccion 311 312 313 FIN

--Seccion 321 322 323 324 ACTUAL
Select @valor1 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '32100-00000','32100-000000','321000-00000','321000-000000'))
Select @valor2 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '40000-00000','40000-000000','400000-00000','400000-000000'))
Select @valor3 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '50000-00000','50000-000000','500000-00000','500000-000000'))
set @valor1 = ISNULL(@valor1,0)/@Division
set @valor2 = ISNULL(@valor2,0)/@Division
set @valor3 = ISNULL(@valor3,0)/@Division
Select @valor = @valor1 + @valor2 - @valor3
select @valor1 =(select SUM(AjusCambioValor) FROM @ejActual Where NoCuenta in('33000-00000','33000-000000','330000-00000','330000-000000'))
set @valor1 = ISNULL(@valor1,0)/@Division
Insert Into @eReport
Select 'Resultados del Ejercicio (Ahorro/Desahorro)', null, null, @valor,@valor1, @valor+@valor1,0, 'D',26

declare @valREA decimal(18,2)
Select @valor = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32200-00000','32200-000000','322000-00000','322000-000000')
Select @valREA = (Select PatGenEjerc FROM @ejActual Where NoCuenta IN ( '322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) - (Select PatGenEjerc FROM @ejAnterior Where NoCuenta IN ( '322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
--Select @valREA = (Select PatGenEjerc FROM @ejActual Where NoCuenta IN('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes AND YEAR =@EJERCICIO) - (Select PatGenEjerc FROM @ejAnterior Where NumeroCuenta IN('322'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio -1)
set @valor = ISNULL(@valor,0)/@Division
set @valREA = ISNULL(@valREA,0)/@Division
Insert Into @eReport
Select 'Resultados de Ejercicios Anteriores ',null, @valREA, @ADContrario, null, ISNULL(@valREA+@ADContrario,0), 0, 'D', 27


--Select @valor = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32300-00000', '32300-000000', '323000-00000','323000-000000')
Select @valor = (Select PatGenEjerc FROM @ejActual Where NoCuenta IN ( '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) - (Select PatGenEjerc FROM @ejAnterior Where NoCuenta IN ( '323'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Revalúos', null, null, @valor,null, @valor, 0, 'D',28

--Union All

--Select @valor = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32400-00000', '32400-000000', '324000-00000','324000-000000')
Select @valor = (Select PatGenEjerc FROM @ejActual Where NoCuenta IN ( '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura)) - (Select PatGenEjerc FROM @ejAnterior Where NoCuenta IN ( '324'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
set @valor = ISNULL(@valor,0)/@Division
Insert Into @eReport
Select 'Reservas', null, null, @valor,null, @valor, 0, 'D',29
--Select * from @eReport
--select @valor = (Select SUM(isnull(PatGenEAnt,0)) from @eReport where orden in(27))
--select @valor1 =(Select SUM (isnull(Patgenejerc,0)) from @eReport where orden in (26,27,28,29)) + (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
--Insert Into @eReport
--Select 'Variaciones de la Hacienda Pública/Patrimonio Generado Neto de '+convert(varchar(10),@Ejercicio),null, @valor, @valor1,null,@valor+@valor1,  1, 'X', 25

--Seccion 321 322 323 324 FIN
Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 31

Select @valor1 = sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
select @valor= sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
Declare @RectRes as decimal(18,2)
Select @RectRes = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))-(Select sum(PatGenEjerc) FROM @ejAnterior Where NoCuenta IN('325'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura))
set @valor = ISNULL(@valor,0)/@Division
set @valor1 = ISNULL(@valor1,0)/@Division
set @RectRes = ISNULL(@RectRes,0)/@Division
Insert Into @eReport
Select 'Rectificaciones de Resultados de Ejercicios Anteriores',null, null, @RectRes,null,@RectRes,  0, 'B', 30

select @valor = (Select SUM(isnull(PatGenEAnt,0)) from @eReport where orden in(27))
select @valor1 =(Select SUM (isnull(Patgenejerc,0)) from @eReport where orden in (26,27,28,29,30))
Insert Into @eReport
Select 'Variaciones de la Hacienda Pública/Patrimonio Generado Neto de '+convert(varchar(10),@Ejercicio),null, @valor, @valor1,null,@valor+@valor1,  1, 'X', 25



--Select @valor1 = sum(ajuscambiovalor) FROM @ejActual Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
--select @valor= sum(ajuscambiovalor) FROM @ejAnterior Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
Select @valor = (Select ISNULL(SaldoAcreedor,0) FROM @Vista Where NumeroCuenta IN('331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes AND YEAR =@EJERCICIO) - (Select ISNULL(SaldoAcreedor,0) FROM @Vista Where NumeroCuenta IN('331'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio -1)
set @valor = ISNULL(@valor,0)/@Division
set @valor1 = ISNULL(@valor1,0)/@Division
Insert Into @eReport
Select 'Resultado por Posición Monetaria',null, null,null ,@valor,@valor,  0, 'B', 33
--Select 'Resultado por Posición Monetaria',null, null,null ,@valor1-@valor,@valor1,  0, 'B', 33

--Select @valor1 = sum(ajuscambiovalor) FROM @ejActual Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
--select @valor= sum(ajuscambiovalor) FROM @ejAnterior Where NoCuenta IN('32500-00000','32500-000000','325000-00000','325000-000000')
Select @valor = (Select ISNULL(SaldoAcreedor,0) FROM @Vista Where NumeroCuenta IN('332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @mes AND YEAR =@EJERCICIO) - (Select ISNULL(SaldoAcreedor,0) FROM @Vista Where NumeroCuenta IN('332'+Replicate('0',@Estructura1-3)+'-'+@cerosEstructura) and mes = @MES AND YEAR = @Ejercicio -1)
set @valor = ISNULL(@valor,0)/@Division
set @valor1 = ISNULL(@valor1,0)/@Division
Insert Into @eReport
--Select 'Resultado por Tenencia de Activos no Monetarios',null, null,null ,@valor1-@valor,@valor1,  0, 'B', 34
Select 'Resultado por Tenencia de Activos no Monetarios',null, null,null ,@valor,@valor,  0, 'B', 34

Select @valor2 = (Select SUM(AjusCambioValor) from @eReport where orden in(33,34))
Insert Into @eReport
Select 'Cambios en el Exceso o Insuficiencia en la Actualización de la Hacienda Pública / Patrimonio Neto de '+convert(varchar(10),@Ejercicio),null, null, null,@valor2,@valor2,  1, 'X', 32


--Select @valor = PatContribuido FROM @ejActual Where NoCuenta IN ( '31000-00000', '31000-000000', '310000-000000')
--set @valor = ISNULL(@valor,0)/@Division
--Select @valor1 = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32000-00000', '32000-000000', '320000-000000')
--set @valor1 = ISNULL(@valor,0)/@Division
--Select @valor2 = AjusCambioValor FROM @ejActual Where NoCuenta IN ( '33000-00000', '33000-000000', '330000-000000')
--set @valor2 = ISNULL(@valor,0)/@Division
Select @valor= (Select SUM(PatContribuido) from @eReport where orden in(17,20))
select @valor1 = (Select SUM(PatGenEjerc) from @eReport where orden in(17,25))
Select @valor2 = (Select SUM(AjusCambioValor) from @eReport where orden in(17,32))
Select @valor4 = PatGenEjerc FROM @ejAnterior Where NoCuenta = '330000-00000'
Declare @valorx as decimal(18,2)
Select @valorx = (Select SUM(PatGenEAnt) from @eReport where orden in(17,25))
Declare @valorHacienda as decimal(18,2)
Set @valorHacienda= (Select SUM(isnull(PatContribuido,0)) from @eReport where orden in(4,5,6))
--Select @valorHacienda
Insert Into @eReport
Select '',null, null, null,null,null,  0, 'X', 35

Insert Into @eReport
Select 'Hacienda Pública / Patrimonio Neto Final de ' + CAST(@ejercicio as varchar(5)), @valor,@valorx, @valor1 , @valor2, @valor+@valor1+@valor2+@valorx, 1, 'E', 36

--select *from @ejActual
--select *from @ejAnterior
--select * from @Vista 

Select 
	Nombre, 
	PatContribuido,
	PatGenEAnt,  
	PatGenEjerc, 
	AjusCambioValor,
	Sumatoria,
	negritas, 
	secciongrupo, 
	orden
from @eReport 
Order by orden



END
GO

EXEC SP_FirmasReporte 'Estado de Variación en la Hacienda Pública'
GO

Exec SP_CFG_LogScripts 'SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioV2','2.29'
GO


