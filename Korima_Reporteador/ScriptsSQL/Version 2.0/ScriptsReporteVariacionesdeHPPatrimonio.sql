--Se verifica que exista la vista y se borra.
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonio]'))
DROP VIEW [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonio]
GO
--Se verifica que exista la vista y se borra.
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioAnt]'))
DROP VIEW [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioAnt]
GO
--Se verifica que exista la vista y se borra.
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles]'))
DROP VIEW [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles]
GO

--Se crea la vista detalles
CREATE View [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles] AS
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
and NumeroCuenta like '325%' 
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
and NumeroCuenta like '311%'
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
and NumeroCuenta like '312%'
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
and NumeroCuenta like '33%' 
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
and NumeroCuenta like '31%' 
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
and NumeroCuenta like '40%' 

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
and NumeroCuenta like '50%' 

GO

--Se verifica que exista el procedimiento almacenado  y se borra.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonio]
GO

--Se crea el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_RPT_K2_VariacionesHaciendaPublicaPatrimonio] 
 @mes int,
  @ejercicio int
  
  
AS
BEGIN


DECLARE @valor decimal(15,2)
DECLARE @valor1 decimal(15,2)
DECLARE @valor2 decimal(15,2)
DECLARE @valor3 decimal(15,2)
DECLARE @sum decimal(15,2)
DECLARE @sum1 decimal(15,2)
DECLARE @sum2 decimal(15,2)
DECLARE @sum3 decimal(15,2)

--Inserta en tabla de memoria todos los registros de la consulta para mas fácil manejo de la información
--Tabla del Ejercicio Actual 
DECLARE @ejActual TABLE (NoCuenta varchar (30), PatContribuido decimal(15,2), 
PatGenEAnt decimal(15,2), PatGenEjerc decimal(15,2), AjusCambioValor decimal(15,2))


Insert Into @ejActual
--PatContribuido
Select NumeroCuenta,TotalAbonos - TotalCargos,0,0,0  
From [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles] 
Where mes=@mes and year=@ejercicio  and NumeroCuenta  In 
('31100-00000', '31200-00000', '31300-00000', '31100-000000', '31200-000000', '31300-000000', '311000-000000', '312000-000000', '313000-000000')
--PatGenEjerc
Union All
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles] 
Where mes=@mes and year=@ejercicio and NumeroCuenta Like '325%' Or NumeroCuenta In 
('32100-00000', '32300-00000', '32400-00000','32100-000000', '32300-000000', '32400-000000','321000-000000', '323000-000000', '324000-000000')
Union All
Select NumeroCuenta, 0,0,SaldoAcreedor,0  
From [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles] 
Where mes=@mes and year=@ejercicio and NumeroCuenta IN ('40000-00000','40000-000000','400000-000000')
Union All
Select NumeroCuenta, 0,0,SaldoDeudor,0  
From [dbo].[VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles] 
Where mes=@mes and year=@ejercicio and NumeroCuenta IN ('50000-00000','50000-000000','500000-000000')


--Tabla de resultado a regresar						
DECLARE @eReport TABLE (Nombre varchar(255), PatContribuido decimal(15,2), PatGenEAnt decimal(15,2), PatGenEjerc decimal(15,2), 
AjusCambioValor decimal(15,2),Sumatoria decimal(15,2),negritas bit, secciongrupo char(1), orden int)

DECLARE @v decimal(15,2)
DECLARE @v1 decimal(15,2)
DECLARE @v2 decimal(15,2)
DECLARE @v3 decimal(15,2)

Select @v1 = (Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '3210' And mes = 1 And [Year] = @ejercicio)
Select @v2 = (Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '4000' And mes = 1 And [Year] = @ejercicio)
Select @v3 = (Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '5000' And mes = 1 And [Year] = @ejercicio)
Select @v = @v1 + @v2 - @v3


Insert Into @eReport
Select 'Hacienda Pública/Patrimonio Neto al Final del Ejercicio Anterior ' +   CAST(@ejercicio - 1 as varchar(5)),
(Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '3100' And mes = 1 And [Year] = @ejercicio),
(Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '3200' And mes = 1 And [Year] = @ejercicio) - @v, 0,
(Select SUM(AbonosSinFlujo) From VW_RPT_K2_VariacionesHaciendaPublicaPatrimonioDetalles
Where SUBSTRING(NumeroCuenta,1,4) = '3300' And mes = 1 And [Year] = @ejercicio), 0, 1, 'A', 1


Update @eReport Set Sumatoria = PatContribuido + PatGenEAnt + PatGenEjerc + AjusCambioValor
Select @sum =  PatContribuido  from @eReport
Select @sum1 =  PatGenEAnt  from @eReport
Select @sum2 =  PatGenEjerc  from @eReport
Select @sum3 =  AjusCambioValor  from @eReport



Select @valor = sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN('32510-00000','32520-00000','32510-000000','32520-000000','325100-000000','325200-000000')
Insert Into @eReport
Select 'Rectificaciones de Resultados de Ejercicios Anteriores',null, null, null,null,null,  1, 'B', 2
Union All
Select 'Cambios en Políticas Contables y Cambios por Errores Contables', null, null, 
@valor ,null, @valor, 0, 'B',3
Union All
Select 'Patrimonio Neto Inicial Ajustado del Ejercicio ',null, null, null,null, null, 1, 'C', 4

Select @valor = sum(PatContribuido) FROM @ejActual Where NoCuenta IN('31100-00000','31200-00000','31100-000000','31200-000000','311000-000000','312000-000000')
Insert Into @eReport
Select 'Actualizaciones y Donaciones de Capital', @valor, null,null,null, 0, 0, 'C',5

Select @valor = PatContribuido FROM @ejActual Where NoCuenta in ( '31300-00000','31300-000000','313000-000000') 
Insert Into @eReport
Select 'Actualización de la Hacienda Pública/Patrimonio',@valor, null,  null,null, 0, 0, 'C',6

Update @eReport Set Sumatoria = (Select SUM(PatContribuido) From @eReport Where orden In (5,6))
Where orden = 6

Select @valor = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32300-00000','32300-000000','323000-000000')
Insert Into @eReport
Select 'Variaciones de la Hacienda Pública/Patrimonio Neto del Ejercicio ',null, null, null,null, null, 1, 'D', 7
Union All
Select 'Ganancia/Pérdida por Revalúos', null, null, @valor,null, 0, 0, 'D', 8

Select @valor = PatGenEjerc FROM @ejActual Where NoCuenta IN ( '32400-00000', '32400-000000', '324000-000000')
Insert Into @eReport
Select 'Reservas', null, null, @valor,null, 0, 0, 'D',9


Select @valor1 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '32100-00000','32100-000000','321000-000000'))
Select @valor2 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '40000-00000','40000-000000','400000-000000'))
Select @valor3 = (Select sum(PatGenEjerc) FROM @ejActual Where NoCuenta IN ( '50000-00000','50000-000000','500000-000000'))
Select @valor = @valor1 + @valor2 - @valor3

Insert Into @eReport
Select 'Resultados del Ejercicio: Ahorro/Desahorro', null, null, @valor,null, 0,0, 'D',10

Update @eReport Set Sumatoria = (Select SUM(PatGenEjerc) From @eReport Where orden IN (8,9,10))
Where orden = 10

Insert Into @eReport
Select 'Otras Variaciones de la Hacienda Pública/patrimonio neto',null, null, null,null,null,  0, 'D', 11

Insert Into @eReport
Select 'Saldo Neto en la Hacienda Pública/Patrimonio ' + CAST(@ejercicio as varchar(5)), isnull(SUM(PatContribuido),0) + @sum , @sum1, isnull(SUM(PatGenEjerc),0) + @sum2, @sum3, 
(isnull(SUM(PatContribuido),0) + @sum + @sum1 + isnull(SUM(PatGenEjerc),0) + @sum2  + @sum3), 1, 'E', 12
From @eReport Where secciongrupo != 'A'


Select 
	Nombre, 
	isnull(PatContribuido,0)/1000 as PatContribuido,
	isnull(PatGenEAnt,0)/1000 as PatGenEAnt,  
	isnull(PatGenEjerc,0)/1000 as PatGenEjerc, 
	isnull(AjusCambioValor,0)/1000 as AjusCambioValor,
	isnull(Sumatoria,0)/1000 as Sumatoria,
	negritas, 
	secciongrupo, 
	orden
from @eReport 
Order by orden


END

GO




Exec SP_FirmasReporte 'Variaciones en la Hacienda Pública / Patrimonio'
GO

