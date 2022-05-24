/****** Object:  StoredProcedure [dbo].[sp_rpt_flujo_de_efectivo6-62]    Script Date: 07/25/2013 11:41:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_rpt_flujo_de_efectivo6-62]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo6-62]
GO

/****** Object:  StoredProcedure [dbo].[sp_rpt_flujo_de_efectivo6-62]    Script Date: 07/25/2013 11:41:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo6-62]
@ejercicio int, @periodo int,@PeriodoFin int, @miles Bit, @MostrarVacios bit
AS

DECLARE @Division int
if @miles=1 set @Division=1000
else set @Division = 1



/*DECLARE @ejercicio int
DECLARE @periodo int
SET @ejercicio = 2012
SET @periodo = 1*/

--Inserta en tabla de memoria todos los registros de la consulta para mas fácil manejo de la información
--Tabla del Ejercicio Actual 
DECLARE @eActual TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
--Tabla del Ejercicio Anterior
DECLARE @eAnterior TABLE (nocuenta varchar (30), nombre varchar(255), cSinFlujo decimal(15,2), aSinFlujo decimal(15,2),
						TotalCargos decimal(15,2), TotalAbonos decimal(15,2), SaldoDeudor decimal(15,2), SaldoAcreedor decimal(15,2))
--Tabla de resultado a regresar						
DECLARE @report TABLE (nombre varchar(255), SaldoActual decimal, SaldoAnterior decimal, negritas tinyint, secciongroup char(1), orden int)

Insert Into @eActual
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
      End as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select * From T_SaldosInicialesCont Where (Mes between  @periodo and @periodo) And [Year] = @ejercicio) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Order By NumeroCuenta

Insert Into @eAnterior
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
      End as SaldoAcreedor
From C_Contable LEFT JOIN 
(Select * From T_SaldosInicialesCont Where (Mes between @periodo and @Periodo ) And [Year] = @ejercicio - 1) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' 
Order By NumeroCuenta

--CAMBIOS PARA 6-6 INICIO
--Se eliminan cuentas de ultimo nivel en @eActual
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eActual where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'
--Se eliminan cuentas de ultimo nivel en @eAnterior
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____0_' and SUBSTRING(nocuenta,1,6) not like '____00'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____1_' and SUBSTRING(nocuenta,1,6) not like '____10'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____2_' and SUBSTRING(nocuenta,1,6) not like '____20'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____3_' and SUBSTRING(nocuenta,1,6) not like '____30'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____4_' and SUBSTRING(nocuenta,1,6) not like '____40'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____5_' and SUBSTRING(nocuenta,1,6) not like '____50'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____6_' and SUBSTRING(nocuenta,1,6) not like '____60'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____7_' and SUBSTRING(nocuenta,1,6) not like '____70'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____8_' and SUBSTRING(nocuenta,1,6) not like '____80'
delete from @eAnterior where SUBSTRING(nocuenta,1,6) like '____9_' and SUBSTRING(nocuenta,1,6) not like '____90'
--CAMBIOS PARA 6-6 FIN

Insert Into @report
Select 'FLUJOS DE EFECTIVO DE LAS ACTIVIDADES DE GESTIÓN',NULL, NULL, 3, 'X', 0
Union All
Select 'ORIGEN',SUM(a.SaldoAcreedor), SUM(b.SaldoAcreedor), 1, 'A', 1
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4110','4130','4140','4150','4160','4172','4190','4210','4220','4300')
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',2
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) = '4110'
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',3
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4130')
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',4
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4140')
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',5
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4150')
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',6
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4160')
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',7
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4172')
Union All
Select 'OTRAS CONTRIBUCIONES CAUSADAS EN EJERCICIOS ANTERIORES', a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',8
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4190')
-- A 1
Union All
Select '',null,null,3,'X',9
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 1, 'X',9
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4210')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',10
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4211')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',11
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4212')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',12
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4213')
-- A 2
Union All
Select '',null,null,3,'X',13
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 1, 'X',13
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4220')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',14
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4221')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',15
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4222')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',16
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4223')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',17
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4224')
Union All
Select '    ' + a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 0, 'X',18
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4225')
-- A 3
Union All
Select '',null,null,3,'X',19
Union All
Select a.nombre, a.SaldoAcreedor, b.SaldoAcreedor, 1, 'X',19
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('4300')
-- A 4
Union All
Select '',null,null,3,'X',19
Union All
Select 'APLICACIÓN', sum(a.SaldoDeudor), sum(b.SaldoDeudor), 1, 'B',20
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5110','5120','5130','5200','5300')
Union All
Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',21
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5110')
Union All
Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',22
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5120')
Union All
Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',23
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5130')
-- B 1
Union All
Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 2, 'X',24
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5200')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',25
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5210')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',26
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5220')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',27
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5230')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',28
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5240')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',29
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5250')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',30
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5260')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',31
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5270')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',32
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5280')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',33
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5290')
-- B 2
Union All
Select A.nombre, a.SaldoDeudor, b.SaldoDeudor, 2, 'X',34
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5300')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',35
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5310')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',36
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5320')
Union All
Select '    ' + A.nombre, a.SaldoDeudor, b.SaldoDeudor, 0, 'X',37
FROM @eActual a inner join @eAnterior b on a.nocuenta = b.nocuenta
Where SUBSTRING(a.nocuenta,1,4) IN ('5330')
-- B 3
Insert Into @report
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE OPERACIÓN' , 
(Select SaldoActual From @report Where secciongroup = 'A') -
(Select SaldoActual From @report Where secciongroup = 'B'),
(Select SaldoAnterior From @report Where secciongroup = 'A') -
(Select SaldoAnterior From @report Where secciongroup = 'B'), 1, 'X', 38
Union All
Select '',null,null,3,'X',38
Union All
Select 'FLUJOS DE EFECTIVO DE LAS ACTIVIDADES DE INVERSIÓN',null,null,3,'X',38
Union All
Select 'CONTRIBUCIONES DE CAPITAL', 
(Select TotalAbonos from @eActual Where SUBSTRING(nocuenta ,1,4) = '3110'),
(Select TotalAbonos from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '3110'), 0, 'X',40
Union All
Select 'VENTA DE ACTIVOS FISICOS', 
(Select TotalAbonos from @eActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524', '523')),
(Select SUM(TotalAbonos) from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('524', '523')), 0, 'X',41
Union All
Select 'OTROS', 
(Select TotalAbonos from @eActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '525'),
(Select TotalAbonos from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '525'), 0, 'X',42
Insert Into @report
Select 'ORIGEN', 
SUM(SaldoActual), SUM(SaldoAnterior), 1, 'C', 39 
from @report Where orden in (40,41,42)
-- C
Union All
Select '',null,null,3,'X',42
Union All
Select 'BIENES INMUEBLES Y MUEBLES',
(Select SUM(TotalCargos) from @eActual
Where SUBSTRING(nocuenta ,1,4) In ('8270') And(
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('581', '582', '583', '625', --'6231','6232', '6233', '6234',
'511', '512', '515', '521', '522', '523', '529', '519', '531', '532', '541', '542', '543', '544', '545', '549', '551', 
'561', '562', '563', '564', '565', '566', '567', '569', '513', '514', '571', '572', '573', '574', '575', '576', '577', 
'578', '579', '591', '592', '593', '594', '595', '596', '597', '598', '599')Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('6231','6232', '6233', '6234', --Movidas
'0581', '0582', '0583', '0625', --'06231','06232', '06233', '06234',
'0511', '0512', '0515', '0521', '0522', '0523', '0529', '0519', '0531', '0532', '0541', '0542', '0543', '0544', '0545', '0549', '0551', 
'0561', '0562', '0563', '0564', '0565', '0566', '0567', '0569', '0513', '0514', '0571', '0572', '0573', '0574', '0575', '0576', '0577', 
'0578', '0579', '0591', '0592', '0593', '0594', '0595', '0596', '0597', '0598', '0599') Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,5) In ('06231','06232', '06233', '06234') --Movidas
)),
(Select SUM(TotalCargos) from @eAnterior
Where SUBSTRING(nocuenta ,1,4) In ('8270') And(
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('581', '582', '583', '625', --'6231','6232', '6233', '6234',
'511', '512', '515', '521', '522', '523', '529', '519', '531', '532', '541', '542', '543', '544', '545', '549', '551', 
'561', '562', '563', '564', '565', '566', '567', '569', '513', '514', '571', '572', '573', '574', '575', '576', '577', 
'578', '579', '591', '592', '593', '594', '595', '596', '597', '598', '599') 
Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) In ('6231','6232', '6233', '6234', --Movidas
'0581', '0582', '0583', '0625', --'06231','06232', '06233', '06234',
'0511', '0512', '0515', '0521', '0522', '0523', '0529', '0519', '0531', '0532', '0541', '0542', '0543', '0544', '0545', '0549', '0551', 
'0561', '0562', '0563', '0564', '0565', '0566', '0567', '0569', '0513', '0514', '0571', '0572', '0573', '0574', '0575', '0576', '0577', 
'0578', '0579', '0591', '0592', '0593', '0594', '0595', '0596', '0597', '0598', '0599')Or
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,5) In ('06231','06232', '06233', '06234')--Movidas
)), 0, 'X', 44
Union All
Select 'CONSTRUCCIONES EN PROCESO (OBRA PÚBLICA)',
(Select SUM(TotalAbonos) from @eActual
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('621', '622', '624')),
(Select SUM(TotalAbonos) from @eAnterior
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) In ('621', '622', '624')), 0, 'X', 45
Union All
Select 'OTROS',
(Select SUM(TotalAbonos) from @eActual
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '589'),
(Select SUM(TotalAbonos) from @eAnterior
Where SUBSTRING(nocuenta ,1,4) In ('8270') And
SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) = '589'), 0, 'X', 46
Insert Into @report
Select 'APLICACIÓN', SUM(SaldoActual), SUM(SaldoAnterior), 1, 'D', 43 
From @report Where orden In (44,45,46)
-- D
Union All
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE INVERSIÓN',
((Select SUM(SaldoActual) from @report Where orden in (40,41,42))-
(select SUM(SaldoActual) From @report Where orden In (44,45,46))), 
((select SUM(SaldoAnterior) from @report Where orden in (40,41,42) )-
(select SUM(SaldoAnterior) from @report Where orden In (44,45,46))), 1, 'X', 47
--(Select SaldoActual From @report Where secciongroup = 'C') - 
--(Select SaldoActual From @report Where secciongroup = 'D'),
--(Select SaldoAnterior From @report Where secciongroup = 'C') - 
--(Select SaldoAnterior From @report Where secciongroup = 'D'), 1, 'X', 47

Union All
Select '',null,null,3,'X',47
Union All
Select 'FLUJO DE EFECTIVO DE LAS ACTIVIDADES DE FINANCIAMIENTO',null,null,3,'X',47
Union All
Select '    INTERNO',
(Select SUM(TotalAbonos) from @eActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '01'),
(Select SUM(TotalAbonos) from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '01'), 0, 'X' ,50
Union All
Select '    EXTERNO',
(Select SUM(TotalAbonos) from @eActual Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '02'),
(Select SUM(TotalAbonos) from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8150'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,2) = '02'), 0, 'X' ,51
Insert Into @report
Select 'ENDEUDAMIENTO NETO', SUM(SaldoActual), SUM(SaldoAnterior), 2, 'X', 49
From @report Where orden In (50,51)
--CAMBIOS PARA 6-6 INICIO
Union All
Select 'INCREMENTO DE OTROS PASIVOS',
(Select SUM(TotalAbonos) From @eActual 
Where SUBSTRING(nocuenta ,1,6) In ('211000', '212000', '215000','216000', '217000', 
'219000', '221000', '221000', '224000', '225000', '226000')),
(Select SUM(TotalAbonos) From @eAnterior 
Where SUBSTRING(nocuenta ,1,6) In ('211000', '212000', '215000','216000', '217000', 
'219000', '221000', '221000', '224000', '225000', '226000')), 0, 'X', 52
Union All
Select 'DISMINUCIÓN DE ACTIVOS FINANCIEROS',
(Select SUM(TotalAbonos) From @eActual 
--Where SUBSTRING(nocuenta ,1,5) In ('11220', '11230', '11240','11290', '11300', 
--'11400', '11500', '12100', '12200')),
Where nocuenta In ('112200-000000', '112300-000000', '112400-000000','112900-000000', '113000-000000', 
'114000-000000', '115000-000000', '121000-000000', '122000-000000'
)),
(Select SUM(TotalAbonos) From @eAnterior 
Where nocuenta In ('112200-000000', '112300-000000', '112400-000000','112900-000000', '113000-000000', 
'114000-000000', '115000-000000', '121000-000000', '122000-000000'
)), 0, 'X', 53

Insert Into @report


Select 'ORIGEN',
SUM(SaldoActual), SUM(SaldoAnterior), 1, 'E', 48
From @report Where orden In(49,52,53)

-- E
Union All
Select '',null,null,3,'X',53
Union All
Select 'INCREMENTO DE ACTIVOS FINANCIEROS',
(Select SUM(TotalCargos) From @eActual 
Where nocuenta In ('112200-000000', '112300-000000', '112400-000000','112900-000000', '113000-000000', 
'114000-000000', '115000-000000', '121000-000000', '122000-000000'
)),
(Select SUM(TotalCargos) From @eAnterior
Where SUBSTRING(nocuenta ,1,5) In ('112200-000000', '112300-000000', '112400-000000','112900-000000', '113000-000000', 
'114000-000000', '115000-000000', '121000-000000', '122000-000000'
)), 0, 'X', 55
--CAMBIOS PARA 6-6 FIN

Union All
Select '    INTERNO',
(Select SUM(TotalCargos) from @eActual Where SUBSTRING(nocuenta ,1,4) = '8270'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('911', '912', '913')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0911', '0912', '0913')),
(Select SUM(TotalCargos) from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8270'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('911', '912', '913')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0911', '0912', '0913')), 0, 'X' ,57
Union All
Select '    EXTERNO',
(Select SUM(TotalCargos) from @eActual Where SUBSTRING(nocuenta ,1,4) = '8270'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('914', '915', '916', '917', '918')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0914', '0915', '0916', '0917', '0918')),
(Select SUM(TotalCargos) from @eAnterior Where SUBSTRING(nocuenta ,1,4) = '8270'
And SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,3) IN ('914', '915', '916', '917', '918')
Or SUBSTRING(nocuenta ,CHARINDEX('-', nocuenta) + 1 ,4) IN ('0914', '0915', '0916', '0917', '0918')), 0, 'X' ,58
Insert Into @report
Select 'SERVICIOS DE LA DEUDA', SUM(SaldoActual), SUM(SaldoAnterior), 2, 'X', 56
From @report Where orden In (57, 58)
Union All

--CAMBIOS PARA 6-6 INICIO
Select 'DISMUNICIÓN DE OTROS PASIVOS',
(Select SUM(TotalCargos) From @eActual 
Where SUBSTRING(nocuenta ,1,6) In ('211000', '212000', '215000','216000', '217000', 
'219000', '221000', '221000', '224000', '225000', '226000')),
(Select SUM(TotalCargos) From @eAnterior
Where SUBSTRING(nocuenta ,1,6) In ('211000', '212000', '215000','216000', '217000', 
'219000', '221000', '221000', '224000', '225000', '226000')), 0, 'X', 59
--CAMBIOS PARA 6-6 FIN

Insert Into @report
Select 'APLICACIÓN', SUM(SaldoActual), SUM(SaldoAnterior), 1, 'F', 54
From @report Where orden In (55, 56, 59)
-- F
Insert Into @report
Select 'FLUJOS NETOS DE EFECTIVO POR ACTIVIDADES DE FINANCIAMIENTO',
(Select SaldoActual From @report Where secciongroup = 'E') - 
(Select SaldoActual From @report Where secciongroup = 'F'),
(Select SaldoAnterior From @report Where secciongroup = 'E') - 
(Select SaldoAnterior From @report Where secciongroup = 'F'), 1, 'X', 60
Union All
Select '',null,null,3,'X',60
Union All
Select '',null,null,3,'X',60
Union All
Select 'INCREMENTO/DISMUNICIÓN NETA EN EL EFECTIVO Y EQUIVALENTES AL EFECTIVO',
--((Select SaldoActual From @report Where secciongroup = 'A') - 
--(Select SaldoActual From @report Where secciongroup = 'B')) -
--(((Select SaldoActual From @report Where secciongroup = 'C') - 
--(Select SaldoActual From @report Where secciongroup = 'D')) +
--((Select SaldoActual From @report Where secciongroup = 'E') -
--(Select SaldoActual From @report Where secciongroup = 'F'))),
--((Select SaldoAnterior From @report Where secciongroup = 'A') - 
--(Select SaldoAnterior From @report Where secciongroup = 'B')) -
--(((Select SaldoAnterior From @report Where secciongroup = 'C') - 
--(Select SaldoAnterior From @report Where secciongroup = 'D')) +
--((Select SaldoAnterior From @report Where secciongroup = 'E') -
--(Select SaldoAnterior From @report Where secciongroup = 'F'))), 
((Select SaldoDeudor From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110')
-(Select cSinFlujo From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110')),
((Select SaldoDeudor From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')
-(Select cSinFlujo From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110')),1, 'X', 61
Union All
Select 'EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL INICIO DEL PERIODO*',
(Select cSinFlujo From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110'),
(Select cSinFlujo From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110'), 1, 'X', 62
Union All
Select 'EFECTIVO Y EQUIVALENTES AL EFECTIVO SALDO AL FINAL DEL PERIODO*',
(Select SaldoDeudor From @eActual Where SUBSTRING(nocuenta ,1,4) = '1110'),
(Select SaldoDeudor From @eAnterior Where SUBSTRING(nocuenta ,1,4) = '1110'), 1, 'X', 63


Select nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
negritas, secciongroup, orden from @report Order by orden


GO


