/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_CDP]    Script Date: 12/12/2012 16:57:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_ESF_CDP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_ESF_CDP]
GO


/****** Object:  StoredProcedure [dbo].[SP_NOTA_ESF_CDP]    Script Date: 12/12/2012 16:57:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_NOTA_ESF_CDP]
@Mes Int,
@Año Int
AS
BEGIN
DECLARE @Tabla1 as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
MasDe365 decimal(15,2),
Nota1 decimal(15,2),
Nota2 decimal(15,2),
Nota3 decimal(15,2),
Negritas bit
)
DECLARE @Tabla2 as table (
NumeroCuenta varchar(30), 
NombreCuenta varchar(255), 
CargosSinFlujo decimal(15,2), 
AbonosSinFlujo decimal(15,2), 
TotalCargos decimal(15,2), 
TotalAbonos decimal (15,2),
SaldoDeudor decimal(15,2),
SaldoAcreedor decimal(15,2),
MasDe365 decimal(15,2),
Nota1 decimal(15,2),
Nota2 decimal(15,2),
Nota3 decimal(15,2),
Negritas bit
)

INSERT INTO @Tabla2
Select NumeroCuenta, NombreCuenta, CargosSinFlujo, AbonosSinFlujo, (TotalCargos/1000) as TotalCargos, 
(TotalAbonos/1000) as TotalAbonos,
      Case C_Contable.TipoCuenta 
          When 'A' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/1000
          When 'C' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/1000
          When 'E' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/1000
          When 'G' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/1000
          When 'I' Then (CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos)/1000
          Else 0
      End as SaldoDeudor,
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
                    When 'I'  Then 0
          Else (AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos)/1000
      End as SaldoAcreedor,
      null as MasDe365,
      0,--substring(NumeroCuenta,1,5)+' Click aqui...' as Nota1,
      0,--substring(NumeroCuenta,1,5)+' Click aqui...' as Nota2,
      0,--substring(NumeroCuenta,1,5)+' Click aqui...' as Nota3,
      0 as Negritas
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And Mes = @Mes And [Year] = @Año And TipoCuenta <> 'X' AND
(NumeroCuenta like '211%' or NumeroCuenta like '212%'or NumeroCuenta like '221%'or NumeroCuenta like '222%')
Order By NumeroCuenta 
--5 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '21100-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21110-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21120-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21130-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21140-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21150-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21160-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21170-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21180-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21190-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta, Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '21200-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21210-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21220-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21290-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '22100-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22110-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22120-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '22200-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22210-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22220-00000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22290-00000'
--
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21100-00000')
WHERE NumeroCuenta='21100-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21110-00000')
WHERE NumeroCuenta='21110-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21120-00000')
WHERE NumeroCuenta='21120-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21130-00000')
WHERE NumeroCuenta='21130-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21140-00000')
WHERE NumeroCuenta='21140-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21150-00000')
WHERE NumeroCuenta='21150-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21160-00000')
WHERE NumeroCuenta='21160-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21170-00000')
WHERE NumeroCuenta='21170-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21180-00000')
WHERE NumeroCuenta='21180-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21190-00000')
WHERE NumeroCuenta='21190-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21200-00000')
WHERE NumeroCuenta='21200-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21210-00000')
WHERE NumeroCuenta='21210-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21220-00000')
WHERE NumeroCuenta='21220-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21290-00000')
WHERE NumeroCuenta='21290-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22100-00000')
WHERE NumeroCuenta='22100-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22110-00000')
WHERE NumeroCuenta='22110-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22120-00000')
WHERE NumeroCuenta='22120-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22200-00000')
WHERE NumeroCuenta='22200-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22210-00000')
WHERE NumeroCuenta='22210-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22220-00000')
WHERE NumeroCuenta='22220-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22290-00000')
WHERE NumeroCuenta='22290-00000'
--
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22100-00000')
WHERE NumeroCuenta='22100-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22110-00000')
WHERE NumeroCuenta='22110-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22120-00000')
WHERE NumeroCuenta='22120-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22220-00000')
WHERE NumeroCuenta='22200-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22210-00000')
WHERE NumeroCuenta='22210-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22220-00000')
WHERE NumeroCuenta='22220-00000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22290-00000')
WHERE NumeroCuenta='22290-00000'
--5 Digitos FIN
--6 Digitos INICIO
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '21100-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21110-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21120-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21130-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21140-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21150-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21160-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21170-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21180-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21190-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '21200-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21210-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21220-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '21290-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22100-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22110-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22120-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta,Negritas )
SELECT NumeroCuenta,NombreCuenta, 1 as Negritas from C_Contable Where NumeroCuenta= '22200-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22210-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22220-000000'
INSERT @Tabla1 (NumeroCuenta,NombreCuenta )
SELECT NumeroCuenta,NombreCuenta from C_Contable Where NumeroCuenta= '22290-000000'
--
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21100-000000')
WHERE NumeroCuenta='21100-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21110-000000')
WHERE NumeroCuenta='21110-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21120-000000')
WHERE NumeroCuenta='21120-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21130-000000')
WHERE NumeroCuenta='21130-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21140-000000')
WHERE NumeroCuenta='21140-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21150-000000')
WHERE NumeroCuenta='21150-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21160-000000')
WHERE NumeroCuenta='21160-00000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21170-000000')
WHERE NumeroCuenta='21170-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21180-000000')
WHERE NumeroCuenta='21180-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21190-000000')
WHERE NumeroCuenta='21190-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21200-000000')
WHERE NumeroCuenta='21200-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21210-000000')
WHERE NumeroCuenta='21210-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21220-000000')
WHERE NumeroCuenta='21220-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='21290-000000')
WHERE NumeroCuenta='21290-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22100-000000')
WHERE NumeroCuenta='22100-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22110-000000')
WHERE NumeroCuenta='22110-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22120-000000')
WHERE NumeroCuenta='22120-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22200-000000')
WHERE NumeroCuenta='22200-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22210-000000')
WHERE NumeroCuenta='22210-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22220-000000')
WHERE NumeroCuenta='22220-000000'
UPDATE @Tabla1 SET SaldoDeudor =(SELECT t2.SaldoDeudor from @Tabla2 as t2 where t2.NumeroCuenta ='22290-000000')
WHERE NumeroCuenta='22290-000000'

--
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22100-000000')
WHERE NumeroCuenta='22100-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22110-000000')
WHERE NumeroCuenta='22110-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22120-000000')
WHERE NumeroCuenta='22120-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22220-000000')
WHERE NumeroCuenta='22200-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22210-000000')
WHERE NumeroCuenta='22210-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22220-000000')
WHERE NumeroCuenta='22220-000000'
UPDATE @Tabla1 SET MasDe365 =(SELECT t1.SaldoDeudor from @Tabla1 as t1 where t1.NumeroCuenta ='22290-000000')
WHERE NumeroCuenta='22290-000000'
--6 Digitos FIN
INSERT INTO @Tabla1 (NumeroCuenta,NombreCuenta,SaldoDeudor, MasDe365,Negritas )
SELECT 'TOTAL' as NumeroCuenta,'TOTAL' as NombreCuenta, (Select SUM(SaldoDeudor) from @Tabla2 Where NumeroCuenta = '21100-00000' or NumeroCuenta = '21100-000000' or
NumeroCuenta= '21200-00000' or NumeroCuenta = '21200-000000' or
NumeroCuenta= '22100-00000' or NumeroCuenta = '22100-000000' or
NumeroCuenta= '22200-00000' or NumeroCuenta = '22200-000000') as SaldoDeudor,
(Select SUM(SaldoDeudor) From @Tabla2 Where NumeroCuenta = '22100-00000' or NumeroCuenta='22100-000000' or
NumeroCuenta='22200-00000' or NumeroCuenta='22200-000000') as MasDe365, 1 as Negritas
--Update @Tabla1 Set Nota1= NumeroCuenta +' Click Aqui...', Nota2= NumeroCuenta  + ' Click Aqui...', Nota3= NumeroCuenta  + ' Click Aqui...' 
Update @Tabla1 Set Nota1= 0, Nota2= 0, Nota3= 0 
Where Numerocuenta like '211%' or NumeroCuenta  Like '212%' or NumeroCuenta ='TOTAL'


SELECT
NumeroCuenta, 
NombreCuenta, 
CargosSinFlujo, 
AbonosSinFlujo, 
TotalCargos, 
TotalAbonos,
isnull(SaldoDeudor,0) as SaldoDeudor,
SaldoAcreedor,
MasDe365,
Nota1,
Nota2,
Nota3,
Negritas
FROM  @Tabla1

ORDER BY NumeroCuenta 
END


GO

UPDATE C_Menu set utilizar=1 where idmenu in (1081,1095,1096)
GO

EXEC SP_FirmasReporte 'Notas al Estado de Situacion Financiera Cuentas y Documentos por Pagar'
GO
