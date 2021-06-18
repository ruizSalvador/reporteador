/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]    Script Date: 01/21/2014 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraRangos]
@Año int,
@Mes int,
@Miles bit,
@MostrarVacios bit,
@AñoAnterior int,
@MesAnterior int

AS
BEGIN--Procedimiento
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

declare @division int
if @miles=1 begin set @division=1000 end
else begin set @division=1 end


--CREO TABLA TEMPORAL DE Balanza de Comprobacion
DECLARE  @Tmp_BalanzaDeComprobacion TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				AñoAnt int,
				Saldo decimal(15,2),
				SaldoANT decimal(15,2)
				)

--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO AÑO ANTERIOR

DECLARE @Tmp_BalanzaDeComprobacionAnterior TABLE(
				IdCuentaContable bigint, 
				NumeroCuenta varchar(max),
				Mes int, 
				Year int,
				SaldoANT decimal(15,2)
				)

--Tabla de Resultados
DECLARE  @Resultado TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				AñoAnt int,
				Saldo decimal(15,2),
				SaldoANT decimal(15,2)
				)
				
--Tabla de Titulos 
DECLARE  @Titulos TABLE(
				NumeroCuenta varchar(max),
				NombreCuenta varchar(max),
				Mes int, 
				Year int, 
				NumeroCuentaAnt varchar(max), 
				MesAnt int,
				AñoAnt int,
				Nivel1 varchar(Max),
				Nivel2 varchar(Max),
				Saldo decimal(15,2),
				SaldoANT decimal(15,2),
				Orden1 int,
				Orden2 int, 
				Aplicacion decimal(15,2),
				Origen decimal(15,2)				 
				)


--LLENO TABLA EN MEMORIA DE SALDOS ANTERIORES

--*********************************KAZB************************************************************************************
if @MesAnterior=1 Begin
INSERT INTO @Tmp_BalanzaDeComprobacionAnterior 
SELECT     TOP (100) PERCENT C_Contable.IdCuentaContable, 
C_Contable.NumeroCuenta,
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo --- CargosSinFlujo + TotalAbonos - TotalCargos 
					   END AS SaldoANT 
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
						ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
						AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
						AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
						--AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
						and T_SaldosInicialesCont.Mes = 13 and
                      T_SaldosInicialesCont.Year = @AñoAnterior -1
ORDER BY C_Contable.NumeroCuenta
end
else begin
INSERT INTO @Tmp_BalanzaDeComprobacionAnterior 
SELECT     TOP (100) PERCENT C_Contable.IdCuentaContable, 
C_Contable.NumeroCuenta,
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo --- AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo --- CargosSinFlujo + TotalAbonos - TotalCargos 
					   END AS SaldoANT 
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
						ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
						AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
						AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
						--AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
						and T_SaldosInicialesCont.Mes = @MesAnterior and
                      T_SaldosInicialesCont.Year = @AñoAnterior 
ORDER BY C_Contable.NumeroCuenta
end

--select * from @Tmp_BalanzaDeComprobacionAnterior where NumeroCuenta='321000-000000'--kazb
--*************************************KAZB*********************************************************************************

--LLENO TABLA TEMPORTAL DE AFECTACION PRESUPUESTO
if @Mes=1 Begin
INSERT INTO @Tmp_BalanzaDeComprobacion 
						SELECT  TOP (100) PERCENT C_Contable.NumeroCuenta, 
						C_Contable.NombreCuenta, 
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,  
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, 
                      BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS AñoAnt, 
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS Saldo,
                        BalanzaDeComprobacionAnterior.SaldoANT
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
                      ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable 
                      LEFT OUTER JOIN @Tmp_BalanzaDeComprobacionAnterior  BalanzaDeComprobacionAnterior 
                      ON C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
						AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura)) 
						AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
						AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
						AND  (T_SaldosInicialesCont.Mes = 13
						  ) AND (T_SaldosInicialesCont.Year = @Año-1
						  ) AND LEFT(C_Contable.NumeroCuenta, 1)='1'
ORDER BY C_Contable.NumeroCuenta

INSERT INTO @Tmp_BalanzaDeComprobacion 
					SELECT  TOP (100) PERCENT C_Contable.NumeroCuenta, 
					C_Contable.NombreCuenta, 
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,  
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, 
                      BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS AñoAnt,
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS Saldo,
                       BalanzaDeComprobacionAnterior.SaldoANT
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
                      ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable 
                      LEFT OUTER JOIN @Tmp_BalanzaDeComprobacionAnterior BalanzaDeComprobacionAnterior ON 
                      C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
					AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura)) 
					AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
					--AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
					AND  (T_SaldosInicialesCont.Mes = 13) 
					AND (T_SaldosInicialesCont.Year = @Año-1) 
					AND LEFT(C_Contable.NumeroCuenta, 1)<>'1'
ORDER BY C_Contable.NumeroCuenta
end
else begin
INSERT INTO @Tmp_BalanzaDeComprobacion 
						SELECT  TOP (100) PERCENT C_Contable.NumeroCuenta, 
						C_Contable.NombreCuenta, 
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,  
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, 
                      BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS AñoAnt, 
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS Saldo,
                        BalanzaDeComprobacionAnterior.SaldoANT
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
                      ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable 
                      LEFT OUTER JOIN @Tmp_BalanzaDeComprobacionAnterior  BalanzaDeComprobacionAnterior 
                      ON C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
						AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura)) 
						AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
						AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
						AND  (T_SaldosInicialesCont.Mes = @Mes
						  ) AND (T_SaldosInicialesCont.Year = @Año
						  ) AND LEFT(C_Contable.NumeroCuenta, 1)='1'
ORDER BY C_Contable.NumeroCuenta

INSERT INTO @Tmp_BalanzaDeComprobacion 
					SELECT  TOP (100) PERCENT C_Contable.NumeroCuenta, 
					C_Contable.NombreCuenta, 
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,  
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, 
                      BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS AñoAnt,
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS Saldo,
                       BalanzaDeComprobacionAnterior.SaldoANT
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
                      ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable 
                      LEFT OUTER JOIN @Tmp_BalanzaDeComprobacionAnterior BalanzaDeComprobacionAnterior ON 
                      C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
					AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura)) 
					AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
					--AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
					AND  (T_SaldosInicialesCont.Mes = @Mes) 
					AND (T_SaldosInicialesCont.Year = @Año) 
					AND LEFT(C_Contable.NumeroCuenta, 1)<>'1'
ORDER BY C_Contable.NumeroCuenta
end


--select * from @Tmp_BalanzaDeComprobacion where NumeroCuenta='321000-000000'--kazb

Declare @4000_5000 decimal(15,2)
Declare @4000_5000Ant decimal(15,2)

 set @4000_5000 =(select isnull(Saldo,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '400'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)-
					(select isnull(Saldo,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '500'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)
--select @4000_5000
 set @4000_5000Ant =(select isnull(SaldoANT,0) from @Tmp_BalanzaDeComprobacion   where NumeroCuenta = '400'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)-
					(select isnull(SaldoANT,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '500'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)
--select @4000_5000Ant


--Segun la estructura se llena la tabla sólo de valores de de tercer nivel
if @Estructura1 =5 BEGIN
DELETE @Tmp_BalanzaDeComprobacion Where Substring(NumeroCuenta,2,4)='0000'
DELETE @Tmp_BalanzaDeComprobacion Where Substring(NumeroCuenta,3,3)='000'
Insert Into @Resultado select * from @Tmp_BalanzaDeComprobacion where substring(NumeroCuenta,4,LEN(NumeroCuenta)) = '00-'+@CerosEstructura 
END

if @Estructura1 =6 BEGIN 
DELETE @Tmp_BalanzaDeComprobacion Where Substring(NumeroCuenta,2,5)='00000'
DELETE @Tmp_BalanzaDeComprobacion Where Substring(NumeroCuenta,3,4)='0000'
Insert Into @Resultado select * from @Tmp_BalanzaDeComprobacion where substring(NumeroCuenta,4,LEN(NumeroCuenta)) = '000-'+@CerosEstructura 
END

--Se llena la tabla de titulos, orden y grupos
INSERT INTO @Titulos  values ('111'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Efectivo y Equivalentes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('112'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('113'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Bienes o Servicios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('114'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inventarios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('115'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Almacenes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('116'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)
INSERT INTO @Titulos  values ('119'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo circulante',0,0,1,1,0,0)

INSERT INTO @Titulos  values ('121'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inversiones Financieras a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('122'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('123'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Inmuebles, Infraestructura y Construcciones en Proceso' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('124'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Muebles' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('125'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Intangibles' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('126'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Depreciación, Deterioro y Amortización Acumulada de Bienes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('127'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Diferidos' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('128'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos no Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)
INSERT INTO @Titulos  values ('129'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos no Circulantes' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'ACTIVO','Activo No Circulante',0,0,1,2,0,0)

INSERT INTO @Titulos  values ('211'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('212'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('213'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Porción a Corto Plazo de la Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('214'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Titulos y Valores a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('215'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('216'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('217'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)
INSERT INTO @Titulos  values ('219'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Pasivos a Corto Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo Circulante',0,0,2,3,0,0)

INSERT INTO @Titulos  values ('221'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)
INSERT INTO @Titulos  values ('222'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)
INSERT INTO @Titulos  values ('223'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)
INSERT INTO @Titulos  values ('224'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)
INSERT INTO @Titulos  values ('225'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)
INSERT INTO @Titulos  values ('226'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Largo Plazo' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'PASIVO','Pasivo No Circulante',0,0,2,4,0,0)

INSERT INTO @Titulos  values ('311'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Aportaciones' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5,0,0)
INSERT INTO @Titulos  values ('312'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Donaciones de Capital' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5,0,0)
INSERT INTO @Titulos  values ('313'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Actualización de la Hacienda Pública/Patrimonio' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5,0,0)

INSERT INTO @Titulos  values ('321'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados del Ejercicio (Ahorro/Desahorro)' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6,0,0)
INSERT INTO @Titulos  values ('322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6,0,0)
INSERT INTO @Titulos  values ('323'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Revalúos' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6,0,0)
INSERT INTO @Titulos  values ('324'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Reservas' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6,0,0)
INSERT INTO @Titulos  values ('325'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Rectificaciones de Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6,0,0)

INSERT INTO @Titulos  values ('331'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Posición Monetaria' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,3,7,0,0)
INSERT INTO @Titulos  values ('332'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Tenencia de Activos no Monetarios' ,@Mes,@Año,'',@MesAnterior,@AñoAnterior,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,3,7,0,0)

--Se actualizan saldos de cada cuenta en la tabla de titulos para mostrar cuentas qe no tengan saldo
update @Titulos 
set a.Saldo=isnull(b.Saldo,0), a.SaldoANT=isnull(b.SaldoAnt,0), a.NumeroCuentaAnt=b.NumeroCuentaAnt 
from @titulos a
join @Resultado b
 on a.numerocuenta=b.numerocuenta

update @Titulos set Saldo= Saldo+isnull(@4000_5000,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
update @Titulos set SaldoANT = SaldoANT+isnull(@4000_5000Ant,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 

if @MostrarVacios=1 
Begin

    --BR 
      update @Titulos set Aplicacion = case when (isnull(Saldo,0)> isnull(SaldoANT,0)and (Nivel1='ACTIVO')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  when (isnull(Saldo,0)< isnull(SaldoANT,0) and (Nivel1='PASIVO' or Nivel1='Hacienda Pública/Patrimonio')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  end 
	  
      update @Titulos set Origen = case when (isnull(SaldoANT,0)>isnull(Saldo,0)and (Nivel1='ACTIVO')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  when (isnull(SaldoANT,0)<isnull(Saldo,0)and (Nivel1='PASIVO' or Nivel1='Hacienda Pública/Patrimonio')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)
	  end  
	  
    --BR agregué
	update @Titulos set Origen = case when (isnull(Saldo,0)> isnull(SaldoANT,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end where NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
	update @Titulos set Aplicacion = case when (isnull(SaldoANT,0)>isnull(Saldo,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end	where NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 		
	     
		 		  declare @aux1 decimal(18,2)
		  select @aux1=(select Aplicacion from @Titulos where Nivel1='ACTIVO' and NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura   )
		  update @Titulos set Origen = @aux1 , Aplicacion=null where Nivel1='ACTIVO' and NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura  

		 declare @aux2 decimal(18,2)
		  select @aux2=(select Origen from @Titulos where Nivel1='ACTIVO' and NumeroCuenta='116'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura  )
		    update @Titulos set Origen = null , Aplicacion=@aux2 where Nivel1='ACTIVO' and NumeroCuenta='116'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura    
end

if @MostrarVacios=0 
Begin
    -- BR lo comenté
	--update @Titulos set Aplicacion = case when (isnull(Saldo,0)> isnull(SaldoANT,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end
	--update @Titulos set Origen = 	case when (isnull(SaldoANT,0)>isnull(Saldo,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end	

    --BR lo agregué 
      update @Titulos set Aplicacion = case when (isnull(Saldo,0)> isnull(SaldoANT,0)and (Nivel1='ACTIVO')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  when (isnull(Saldo,0)< isnull(SaldoANT,0) and (Nivel1='PASIVO' or Nivel1='Hacienda Pública/Patrimonio')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  end 
	  
      update @Titulos set Origen = case when (isnull(SaldoANT,0)>isnull(Saldo,0)and (Nivel1='ACTIVO')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division) 
	  when (isnull(SaldoANT,0)<isnull(Saldo,0)and (Nivel1='PASIVO' or Nivel1='Hacienda Pública/Patrimonio')) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)
	  end  
	-- BR lo agregué  	
	update @Titulos set Origen = case when (isnull(Saldo,0)> isnull(SaldoANT,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end where NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
	update @Titulos set Aplicacion = case when (isnull(SaldoANT,0)>isnull(Saldo,0)) then ABS(isnull(Saldo,0)/@division-isnull(SaldoANT,0)/@division)end	where NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 		

	 declare @aux3 decimal(18,2)
    select @aux3=(select Aplicacion from @Titulos where Nivel1='ACTIVO' and NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura   )
	update @Titulos set Origen = @aux3 , Aplicacion=null where Nivel1='ACTIVO' and NumeroCuenta='126'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura  

    declare @aux4 decimal(18,2)
    select @aux4=(select Origen from @Titulos where Nivel1='ACTIVO' and NumeroCuenta='116'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura  )
	update @Titulos set Origen = null , Aplicacion=@aux4 where Nivel1='ACTIVO' and NumeroCuenta='116'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
end

if @MostrarVacios=1 Begin
--Seleccion Final
	select 
	NumeroCuenta ,
	NombreCuenta ,
	Mes , 
	Year , 
	NumeroCuentaAnt , 
	MesAnt ,
	AñoAnt ,
	Upper(Nivel1) as Nivel1,
	Nivel2 ,
	ABS(isnull(Saldo,0)/@division) as Saldo ,
	ABS(isnull(SaldoANT,0)/@division) as SaldoAnt ,
	Orden1 ,
	Orden2,  
	Aplicacion,
	Origen   
	
	from @titulos
	End
	Else Begin
		select 
	NumeroCuenta ,
	NombreCuenta ,
	Mes , 
	Year , 
	NumeroCuentaAnt , 
	MesAnt ,
	AñoAnt ,
	Upper(Nivel1) as Nivel1 ,
	Nivel2 ,
	ABS(isnull(Saldo,0)/@division) as Saldo ,
	ABS(isnull(SaldoANT,0)/@division) as SaldoAnt ,
	Orden1 ,
	Orden2,  
	Aplicacion,
	Origen 
	
	from @titulos
	Where (isnull(Saldo,0)-isnull(SaldoANT,0)) <>0
	
	End

END --procedimiento

GO

EXEC SP_FirmasReporte 'Estado de Cambios en la Situación Financiera por Periodos'
GO

--exec SP_RPT_K2_Estado_Situacion_FinancieraRangos @Año=2017,@Mes=7,@Miles=0,@MostrarVacios=1,@AñoAnterior=2017,@MesAnterior=1
--exec SP_RPT_K2_Estado_Situacion_FinancieraRangos @Año=2017,@Mes=7,@Miles=0,@MostrarVacios=1,@AñoAnterior=2017,@MesAnterior=2