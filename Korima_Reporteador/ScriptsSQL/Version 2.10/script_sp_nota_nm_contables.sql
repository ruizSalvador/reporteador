/****** Object:  StoredProcedure [dbo].[sp_nota_nm_contables]    Script Date: 01/04/2013 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_nota_nm_contables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_nota_nm_contables]
GO
/****** Object:  StoredProcedure [dbo].[sp_nota_nm_contables]    Script Date: 01/04/2013 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_nota_nm_contables]
@ejercicio int, 
@periodo int

AS

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DECLARE @tablaRpt TABLE(Cuenta varchar(30), Nombre varchar(255), Monto decimal(15,2),Nota1 text)

INSERT INTO @tablaRpt
Select NumeroCuenta as Cuenta, NombreCuenta as Nombre, 0,SUBSTRING(NumeroCuenta,1,5) +  '...Click para editar...'
FROM C_Contable
WHERE TipoCuenta <> 'X' And NumeroCuenta like '7%'

Order By NumeroCuenta

UPDATE @tablaRpt SET Monto = (isnull(CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos,0)/1000)     
FROM C_Contable INNER JOIN @tablaRpt a ON C_Contable.NumeroCuenta = a.Cuenta
INNER JOIN T_SaldosInicialesCont Saldos On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
WHERE Mes = @periodo  And [Year] = @ejercicio

UPDATE @tablaRpt SET Nota1 = 'Instrumentos prestados a formadores de mercado e instrumentos de crédito recibidos en garantía de los formadores de mercado u otros.'
FROM @tablaRpt
WHERE Cuenta='7'+REPLICATE('0',@Estructura1-1)+'-'+@CerosEstructura 
--WHERE Cuenta='70000-00000'

UPDATE @tablaRpt SET Nota1 = 'Monto, Tasa y Vencimiento'
FROM @tablaRpt
WHERE Cuenta='72'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura 
--WHERE Cuenta='72000-00000'

UPDATE @tablaRpt SET Nota1 = 'Datos de Avales y Garantias'
FROM @tablaRpt
WHERE Cuenta='73'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura 
--WHERE Cuenta='73000-00000'

UPDATE @tablaRpt SET Nota1 = 'Civiles, penales, fiscales, agrarios, administrativos, ambientales, laborales, mercantiles y procedimientos arbitrales.'
FROM @tablaRpt
WHERE Cuenta='74'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura 
--WHERE Cuenta='74000-00000'

UPDATE @tablaRpt SET Nota1 = 'Datos de Contratos'
FROM @tablaRpt
WHERE Cuenta='75'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura 
--WHERE Cuenta='75000-00000'

UPDATE @tablaRpt SET Nota1 = 'Datos de Contratos y Concesiones'
FROM @tablaRpt
WHERE Cuenta='76'+REPLICATE('0',@Estructura1-2)+'-'+@CerosEstructura 
--WHERE Cuenta='76000-00000'

SELECT SUBSTRING(Cuenta,1,5) as Cuenta, Nombre, Monto ,Nota1 FROM @tablaRpt

GO

update C_Menu set Utilizar = 1 Where IdMenu In(1181,1182)
update C_Menu set IdPadre = 1181 Where IdMenu = 1182
GO

Exec SP_FirmasReporte 'Notas al Estado de Situación Financiera_NotasdeMemoria_contables'
GO