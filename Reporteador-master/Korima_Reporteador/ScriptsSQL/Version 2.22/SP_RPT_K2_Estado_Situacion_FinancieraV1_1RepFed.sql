/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed]    Script Date: 01/21/2014 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed]    Script Date: 01/21/2014 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed 2015,2015,4,4,0,1,1
CREATE PROCEDURE [dbo].[SP_RPT_K2_Estado_Situacion_FinancieraV1_1RepFed]
@Año int,
@Año2 int,
@Mes int,
@Mes2 int,
@Miles bit,
@Tipo int,
@Redondeo bit

AS
BEGIN--Procedimiento
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

Declare @Activo int,@Pasivo int,@Hacienda int
if @Tipo=1 begin
	set @Activo=1 
	set @Pasivo=0 
	set @Hacienda=0
end
else if @Tipo=2 begin
	set @Activo=0 
	set @Pasivo=2
	set @Hacienda=3
end if @Tipo =3 begin
	set @Activo=1 
	set @Pasivo=2
	set @Hacienda=3
end

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
				Orden2 int  
				)

---Resultado Final, agregado para redondeo
DECLARE  @ResultadoFinal TABLE(
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
				Orden2 int
				)
				
--Tabla de Totales 
DECLARE  @Totales TABLE(
				Saldo1000 decimal(15,2),
				SaldoANT1000 decimal(15,2), 
				Saldo2000_3000 decimal(15,2),
				SaldoANT2000_3000 decimal(15,2) 
				)

---Resultado Final, agregado para redondeo
DECLARE  @TotalesFinal TABLE(
				Saldo1000 decimal(15,2),
				SaldoANT1000 decimal(15,2), 
				Saldo2000_3000 decimal(15,2),
				SaldoANT2000_3000 decimal(15,2) 
				)

--LLENO TABLA EN MEMORIA DE SALDOS ANTERIORES

INSERT INTO @Tmp_BalanzaDeComprobacionAnterior 
SELECT     TOP (100) PERCENT C_Contable.IdCuentaContable, 
C_Contable.NumeroCuenta,
                      T_SaldosInicialesCont.Mes, 
                      T_SaldosInicialesCont.Year,
                      CASE C_Contable.TipoCuenta 
                      WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                      WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
                       ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END AS SaldoANT 
FROM         C_Contable INNER JOIN T_SaldosInicialesCont 
						ON C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
WHERE     (C_Contable.TipoCuenta <> 'X') 
						AND ((RIGHT(C_Contable.NumeroCuenta, @Estructura2) = @CerosEstructura )) 
						AND (LEFT(C_Contable.NumeroCuenta, 1) > '0') 
						--AND (LEFT(C_Contable.NumeroCuenta, 1) < '4') 
						and T_SaldosInicialesCont.Mes = @mes2 and
                      T_SaldosInicialesCont.Year = @Año2 
ORDER BY C_Contable.NumeroCuenta

--LLENO TABLA TEMPORTAL DE AFECTACION PRESUPUESTO

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
 Declare @4000_5000 decimal(15,2)
 Declare @4000_5000Ant decimal(15,2)
 set @4000_5000 =(select isnull(Saldo,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '400'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)-
					(select isnull(Saldo,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '500'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)

 set @4000_5000Ant =(select isnull(SaldoANT,0) from @Tmp_BalanzaDeComprobacion   where NumeroCuenta = '400'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)-
					(select isnull(SaldoANT,0) from @Tmp_BalanzaDeComprobacion  where NumeroCuenta = '500'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura)


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
INSERT INTO @Titulos  values ('111'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Efectivo y Equivalentes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
INSERT INTO @Titulos  values ('112'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
INSERT INTO @Titulos  values ('113'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Bienes o Servicios' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
INSERT INTO @Titulos  values ('114'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inventarios' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
INSERT INTO @Titulos  values ('115'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Almacenes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
INSERT INTO @Titulos  values ('116'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos Circulantes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)
--INSERT INTO @Titulos  values ('1161'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',null,null,1,1)
INSERT INTO @Titulos  values ('119'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos Circulantes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',0,0,1,1)

INSERT INTO @Titulos  values ('121'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Inversiones Financieras a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('122'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Derechos a Recibir Efectivo o Equivalentes a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('123'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Inmuebles, Infraestructura y Construcciones en Proceso' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('124'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Bienes Muebles' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('125'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Intangibles' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('126'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Depreciación, Deterioro y Amortización Acumulada de Bienes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('127'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Activos Diferidos' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('128'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Estimación por Pérdida o Deterioro de Activos no Circulantes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)
INSERT INTO @Titulos  values ('129'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Activos no Circulantes' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',0,0,1,2)

INSERT INTO @Titulos  values ('211'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('212'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('213'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Porción a Corto Plazo de la Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('214'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Titulos y Valores a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('215'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('216'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('217'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)
INSERT INTO @Titulos  values ('219'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Otros Pasivos a Corto Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo Circulante',0,0,2,3)

INSERT INTO @Titulos  values ('221'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Cuentas por Pagar a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)
INSERT INTO @Titulos  values ('222'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Documentos por Pagar a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)
INSERT INTO @Titulos  values ('223'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Deuda Pública a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)
INSERT INTO @Titulos  values ('224'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Pasivos Diferidos a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)
INSERT INTO @Titulos  values ('225'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Fondos y Bienes de Terceros en Garantía y/o Administración a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)
INSERT INTO @Titulos  values ('226'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Provisiones a Largo Plazo' ,@Mes,@Año,'',@mes,@Año-1,'Pasivo','Pasivo No Circulante',0,0,2,4)

INSERT INTO @Titulos  values ('311'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Aportaciones' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5)
INSERT INTO @Titulos  values ('312'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Donaciones de Capital' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5)
INSERT INTO @Titulos  values ('313'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Actualización de la Hacienda Pública/Patrimonio' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Contribuido',0,0,3,5)

INSERT INTO @Titulos  values ('321'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados del Ejercicio (Ahorro/Desahorro)' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6)
INSERT INTO @Titulos  values ('322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6)
INSERT INTO @Titulos  values ('323'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Revalúos' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6)
INSERT INTO @Titulos  values ('324'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Reservas' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6)
INSERT INTO @Titulos  values ('325'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Rectificaciones de Resultados de Ejercicios Anteriores' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Hacienda Pública/Patrimonio Generado',0,0,3,6)

INSERT INTO @Titulos  values ('331'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Posición Monetaria' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,3,7)
INSERT INTO @Titulos  values ('332'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Resultado por Tenencia de Activos no Monetarios' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,3,7)
--INSERT INTO @Titulos  values ('333'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio' ,@Mes,@Año,'',@mes,@Año-1,'Hacienda Pública/Patrimonio','Exceso o Insuficiencia en la Actualización de la Hacienda Pública/Patrimonio',0,0,3,7)

--Se actualizan saldos de cada cuenta en la tabla de titulos para mostrar cuentas qe no tengan saldo
update @Titulos 
set a.Saldo=isnull(b.Saldo,0), a.SaldoANT=isnull(b.SaldoAnt,0), a.NumeroCuentaAnt=b.NumeroCuentaAnt 
from @titulos a
join @Resultado b
 on a.numerocuenta=b.numerocuenta
 
 ---
 
update @Titulos set Saldo= Saldo+isnull(@4000_5000,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 
update @Titulos set SaldoANT = SaldoANT+isnull(@4000_5000Ant,0) where NumeroCuenta='321'+REPLicate('0',@Estructura1-3)+'-'+@CerosEstructura 

--Se multimican por -1 los sados de las cuentas 11600, 12600 y 12800 , para que cuadren
Update @titulos set Saldo =Saldo*-1, SaldoANT =SaldoANT *-1 where (NumeroCuenta  like '116%' or NumeroCuenta like '126%' or NumeroCuenta like '128%') and (Saldo>0 or SaldoANT>0)

insert into @Totales values((Select SUM(saldo) from @Titulos where Orden1=1),(Select SUM(saldoAnt) from @Titulos where Orden1=1),
							(Select SUM(saldo) from @Titulos where Orden1=2 or Orden1=3),(Select SUM(saldoAnt) from @Titulos where Orden1=2 or Orden1=3))

INSERT INTO @Titulos  values ('1191'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'CuentaCuadre' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo Circulante',
(Select SUM(isnull(saldo,0))*2 from @titulos where (NumeroCuenta  like '116%')),
(Select SUM(isnull(SaldoANT,0))*2 from @titulos where (NumeroCuenta  like '116%')),
1,1)

INSERT INTO @Titulos  values ('130'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,'CuentaCuadre' ,@Mes,@Año,'',@mes,@Año-1,'Activo','Activo No Circulante',
(Select SUM(isnull(saldo,0))*2 from @titulos where ( NumeroCuenta like '126%' or NumeroCuenta like '128%')),
(Select SUM(isnull(SaldoANT,0))*2 from @titulos where (NumeroCuenta like '126%' or NumeroCuenta like '128%')),
1,2)

--Se multimican por -1 los sados de las cuentas 11600, 12600 y 12800 , para que cuadren
Update @titulos set Saldo =Saldo*-1, SaldoANT =SaldoANT *-1 where NumeroCuenta  like '116%' or NumeroCuenta like '126%' or NumeroCuenta like '128%'
Update @titulos set AñoAnt = @Año2
--Seleccion Final
-- Si son TOTALES sólo muestra los saldos de las cuentas
if @Tipo=3 begin
	if @Miles=1begin
	insert into @TotalesFinal
		Select Saldo1000/1000 as Saldo1000, 
		SaldoANT1000/1000 as SaldoANT1000, 
		Saldo2000_3000/1000 as Saldo2000_3000,
		SaldoANT2000_3000/1000 as SaldoANT2000_3000  
		from @Totales 
	end 
	else begin
	insert into @TotalesFinal
		select * from @Totales 
	end
	if @Redondeo=1 begin
	Select Round(Saldo1000,0) as Saldo1000, 
		Round(SaldoANT1000,0) as SaldoANT1000, 
		Round(Saldo2000_3000,0) as Saldo2000_3000,
		Round(SaldoANT2000_3000,0) as SaldoANT2000_3000  
		from @Totales 
	end
	else begin
	select * from @Totales 
	end

end 
--Si NO son totales, regresa una consulta con saldos de las cuentas
Else Begin

	if @Miles=1 begin
	insert into @ResultadoFinal
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
		Saldo/1000 as Saldo ,
		SaldoANT/1000 as SaldoAnt ,
		Orden1 ,
		Orden2   
		from @titulos
		where Orden1 in(@Activo,@Pasivo, @Hacienda )
		end
	else begin
	insert into @ResultadoFinal
			select * from @titulos where Orden1 in(@Activo,@Pasivo, @Hacienda )
	end

	if @Redondeo=1 begin
	select NumeroCuenta,NombreCuenta,Mes,Year,NumeroCuentaAnt,MesAnt,AñoAnt,Upper(Nivel1)Nivel1,Nivel2,
	round(Saldo,0) as Saldo,
	Round(SaldoAnt,0) as SaldoAnt,
	Orden1,Orden2
	from @ResultadoFinal
	end
	else begin
	select NumeroCuenta,NombreCuenta,Mes,Year,NumeroCuentaAnt,MesAnt,AñoAnt,Upper(Nivel1)Nivel1,Nivel2,
	Saldo,
	SaldoAnt,
	Orden1,Orden2 
	
	from @ResultadoFinal
	end
End
END --procedimiento

GO

EXEC SP_FirmasReporte 'Estado de situacion financiera'
GO


