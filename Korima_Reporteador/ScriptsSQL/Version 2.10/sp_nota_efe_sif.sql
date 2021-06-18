Update C_Menu Set Utilizar = 1 Where IdMenu in (1107, 1106, 1081)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_efe_sif]') AND type in (N'P'))
DROP PROCEDURE sp_nota_efe_sif
GO

CREATE PROCEDURE sp_nota_efe_sif
@ejercicio int, @periodo int
AS

--Tipos de estructura 5-5 , 5-6 , 6-6
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DECLARE @tablaRpt TABLE(
Cuenta varchar(30), 
Nombre varchar(255), 
SaldoInicial decimal(15,2), 
SaldoFinal decimal(15,2), 
SaldoInicialAnt decimal(15,2), 
SaldoFinalAnt decimal(15,2), 
anio int)

DECLARE @total decimal(15,2)

Declare @Titulos table(Numero varchar(5), DescripcionCuenta varchar(max))
Insert @Titulos values('11120', 'EFECTIVO EN BANCOS/TESORERÍA')
Insert @Titulos values('11130', 'EFECTIVO EN BANCOS/DEPENDENCIAS Y OTROS')
Insert @Titulos values('11140', 'INVERSIONES TEMPORALES (hasta 3 meses)')
Insert @Titulos values('11150', 'FONDOS CON AFECTACIÓN ESPECÍFICA')
Insert @Titulos values('11160', 'DEPÓSITOS DE FONDOS DE TERCEROS Y OTROS')
Insert @Titulos values('11190', 'TOTAL DE EFECTIVO Y EQUIVALENTES')

Insert Into @tablaRpt 
Select NumeroCuenta, NombreCuenta, 0, 0, 0, 0, @ejercicio   
From C_Contable

--'111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura
Where NumeroCuenta In ('1111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura) 
Order By NumeroCuenta
--Where NumeroCuenta In ('11100-00000','11110-00000','11120-00000','11130-00000','11140-00000','11150-00000','11160-00000','11190-00000','11100-000000','11110-000000','11120-000000','11130-000000','11140-000000','11150-000000','11160-000000','11190-000000') Order By NumeroCuenta

Update @tablaRpt 
Set SaldoInicial = b.CargosSinFlujo, SaldoFinal = b.CargosSinFlujo - b.AbonosSinFlujo + b.TotalCargos - b.TotalAbonos
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio

Update @tablaRpt 
Set SaldoInicialAnt = b.CargosSinFlujo, SaldoFinalAnt = b.CargosSinFlujo - b.AbonosSinFlujo + b.TotalCargos - b.TotalAbonos
From T_SaldosInicialesCont b INNER JOIN C_Contable c ON b.IdCuentaContable = c.IdCuentaContable
INNER JOIN @tablaRpt a ON a.Cuenta = c.NumeroCuenta
Where Mes = @periodo And [Year] = @ejercicio -1 

--Actualizacion de saldos version 2.10 INICIO
UPDATE @tablaRpt  
set SaldoInicial=(Select SUM(SaldoInicial) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinal=(Select SUM(SaldoFinal) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoInicialAnt=(Select SUM(SaldoInicialAnt) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinalAnt=(Select SUM(SaldoFinalAnt) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1111'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura))									 									 							
Where Cuenta = '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura
--
UPDATE @tablaRpt  
set SaldoInicial=(Select SUM(SaldoInicial) FROM @tablaRpt 
					Where Cuenta in( '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinal=(Select SUM(SaldoFinal) FROM @tablaRpt 
					Where Cuenta in( '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoInicialAnt=(Select SUM(SaldoInicialAnt) FROM @tablaRpt 
					Where Cuenta in( '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinalAnt=(Select SUM(SaldoFinalAnt) FROM @tablaRpt 
					Where Cuenta in( '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura))									 									 							
Where Cuenta = '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura
--
UPDATE @tablaRpt  
set SaldoInicial=(Select SUM(SaldoInicial) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinal=(Select SUM(SaldoFinal) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoInicialAnt=(Select SUM(SaldoInicialAnt) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)),
SaldoFinalAnt=(Select SUM(SaldoFinalAnt) FROM @tablaRpt 
					Where Cuenta in( '1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
									 '1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
									 '1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura))									 									 							
Where Cuenta = '1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura
--
UPDATE @tablaRpt SET T.Nombre=TT.DescripcionCuenta FROM @tablaRpt T JOIN @Titulos TT  on SUBSTRING(T.Cuenta,1,5)=TT.Numero
--FIN

Select SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, SaldoInicial/1000 as SaldoInicial,
SaldoFinal/1000 as SaldoFinal, SaldoInicialAnt/1000 as SaldoInicialAnt, SaldoFinalAnt/1000 as SaldoFinalAnt,anio 
From @tablaRpt 
Where Cuenta IN (
'1112'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, 
'1113'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1114'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1115'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1116'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura,
'1119'+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura)
Order by Cuenta


GO

Exec SP_FirmasReporte 'Efectivo y Equivalentes - Saldo Inicial y Final'
GO
