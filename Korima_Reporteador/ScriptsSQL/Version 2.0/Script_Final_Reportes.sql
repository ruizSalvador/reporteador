

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FormatoCadena'))
-- deletes function
    DROP FUNCTION FormatoCadena;
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Saldo_Cuenta'))
-- deletes function
    DROP FUNCTION Saldo_Cuenta;
GO
-- determines if function exists in database
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'RPT_Balanza_Comprobacio_Anterior'))
-- deletes function
    DROP FUNCTION RPT_Balanza_Comprobacio_Anterior;
GO

/*
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Prueba]'))
DROP VIEW [dbo].[View_Prueba]
GO


CREATE VIEW [dbo].[View_Prueba]
AS
SELECT     TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt, RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt, RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.Year AS A?oAnt, 1 AS Agrupador
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      dbo.RPT_Balanza_Comprobacio_Anterior(01, 2012 - 1) AS RPT_Balanza_Comprobacio_Anterior_1 ON 
                      dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND (dbo.T_SaldosInicialesCont.Mes = 01) AND (dbo.T_SaldosInicialesCont.Year = 2012) AND 
                      ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000') OR(RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') AND (LEFT(dbo.C_Contable.NumeroCuenta, 2) < '54')
ORDER BY dbo.C_Contable.NumeroCuenta

GO
*/

/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPORTE_Balanza_De_Comprobacion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion]
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion_Totalizado]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPORTE_Balanza_De_Comprobacion_Totalizado]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion_Totalizado]
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_Actividades]    Script Date: 07/05/2012 14:18:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[REPORTE_Estado_De_Actividades]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[REPORTE_Estado_De_Actividades]
GO



--///////////////RPT_Balanza_Comprobacio_Anterior
/****** Object:  UserDefinedFunction [dbo].[RPT_Balanza_Comprobacio_Anterior]    Script Date: 10/08/2012 13:00:46 ******/

CREATE FUNCTION [dbo].[RPT_Balanza_Comprobacio_Anterior]
                 ( @mes int,@A?o int)
RETURNS table
AS
RETURN (
SELECT     TOP (100) PERCENT dbo.C_Contable.IdCuentaContable, dbo.C_Contable.NumeroCuenta,
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor,dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000') OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @a?o 
ORDER BY dbo.C_Contable.NumeroCuenta
       )

GO
--///////////////FIN RPT_Balanza_Comprobacio_Anterior


--/////////FormatoCadena
/****** Object:  UserDefinedFunction [dbo].[FormatoCadena]    Script Date: 10/08/2012 13:06:46 ******/


CREATE FUNCTION [dbo].[FormatoCadena](@CadenaBruta varchar(max),@NumeroCuenta varchar(max))
returns varchar(MAX)
begin

declare @ValorPosicion as bigint
declare @Cadena varchar(max)
declare @CadenaA varchar(max)
declare @CadenaB varchar(max)
declare @SaltoLinea varchar(max)
declare @CadenaFinalA as varchar(max)
declare @CadenaFinalB as varchar(max)
declare @CadenaFinal as varchar(max)
declare @Tama?oCadenaDos as bigint
declare @Tama?oCadenaDerecha as bigint
declare @PosicionComodin as bigint
declare @Sangria as varchar(max)
 
 set @Cadena= left(@CadenaBruta,60)
 set @Tama?oCadenaDos = len(@CadenaBruta)
  --Funcion para Sangrias
	 set @Sangria= CASE len(LEFT(@NumeroCuenta,5)) - len(replace(LEFT(@NumeroCuenta, 5), 0, '')) 
                      WHEN '4' THEN '    ' WHEN '3' THEN '          ' WHEN '2' THEN '              ' WHEN '1' THEN '                  ' WHEN '0' THEN '                      ' END 
	 --Termina Funcion

 set @CadenaFinal=@Sangria + @CadenaBruta
 
if @Tama?oCadenaDos>60
begin
	  set @CadenaA=replace(@Cadena,' ','#')
	 
	 set @CadenaB=reverse(@CadenaA)
	 set @PosicionComodin=patindex('%#%',@CadenaB)
	 set @valorPosicion= 60-@PosicionComodin
	 set @CadenaFinalA=left(@Cadena,@ValorPosicion)
	 set @Tama?oCadenaDerecha = @Tama?oCadenaDos-@ValorPosicion
	 set @CadenaFinalB=right(@CadenaBruta,@Tama?oCadenaDerecha)
	 
	 set @CadenaFinal =@Sangria + @CadenaFinalA + char(13) + @Sangria + @CadenaFinalB
	 	
end
return (@CadenaFinal)

end

GO

--/////////FIN FormatoCadena


--//////////Saldo_Cuenta


CREATE FUNCTION [dbo].[Saldo_Cuenta](@Cuenta varchar(max),@mes int,@a?o int)
returns  decimal(15,2)
begin
 
 declare @Resultado decimal(15,2)
 declare @SaldoDeudor decimal(15,2)
 declare @SaldoAcreedor decimal(15,2)
 Declare @TipoCuenta int
 
		SELECT @SaldoDeudor=CASE C_Contable.TipoCuenta 
		WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
		WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
		WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
		WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
        WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos 
        ELSE 0 END  , 
               @SaldoAcreedor= CASE C_Contable.TipoCuenta 
        WHEN 'A' THEN 0 
        WHEN 'C' THEN 0 
        WHEN 'E' THEN 0 
        WHEN 'G' THEN 0 
        WHEN 'I' THEN 0 
        ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos END  
         FROM   dbo.C_Contable INNER JOIN
                dbo.T_SaldosInicialesCont 
                ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
         WHERE  (dbo.C_Contable.TipoCuenta <> 'X') 
         AND dbo.C_Contable.NumeroCuenta = @Cuenta  and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @a?o   
                      
   SET @TipoCuenta= left(@Cuenta,1)                      
                           
   SET @Resultado=Case @TipoCuenta 
   When '5' then @SaldoDeudor 
   When '4' then @SaldoAcreedor 
   When '3' then @SaldoAcreedor 
   when '2' then @SaldoAcreedor 
   when '1' then @SaldoDeudor 
   end  
   
   if (substring(@cuenta,1,3)='126') or (substring(@cuenta,1,3)='128' or substring(@cuenta,1,3)='116')
   set @Resultado = isnull(@saldoAcreedor,0)
                  
                       
return isnull(@Resultado,0)

end

GO

--//////////FIN Saldo_Cuenta


--/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion]    Script Date: 11/22/2012 16:11:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion]

 @Mes int,
 @A?o int,
 @Tipo int

AS
BEGIN
	
	Declare @Reporte int
	Declare @SSaldo decimal(15,2)
	Declare @SSaldoAnt Decimal(15,2)
	Declare @SSaldo5 decimal(15,2)
	Declare @SSaldoAnt5 decimal(15,2)
	Declare @Var11610 decimal(15,2)
	Declare @Var11620 decimal(15,2)
	Declare @Var11621 decimal(15,2)
	DEclare @Var11622 decimal(15,2)
	Declare @Var11623 decimal(15,2)
	Declare @Var11624 decimal(15,2)
	Declare @Var11625 decimal(15,2)
	Declare @Var12810 decimal(15,2)
	Declare @Var12820 decimal(15,2)
	Declare @Var12830 decimal(15,2)
	Declare @Var12840 decimal(15,2)
	Declare @Var12890 decimal(15,2)
	Declare @Var12600_00000 decimal(15,2)
	Declare @Var12610_00000 decimal(15,2)
	Declare @Var12610_01000 decimal(15,2)
	DEclare @Var12610_02000 decimal(15,2)
	Declare @Var12610_03000 decimal(15,2)
	Declare @Var12610_04000 decimal(15,2)
	Declare @Var12620_00000 decimal(15,2)
	--Declare @Var12620_01000 decimal(15,2)
	--Declare @Var12620_02000 decimal(15,2)
	--Declare @Var12620_03000 decimal(15,2)
	--Declare @Var12620_04000 decimal(15,2)
	--Declare @Var12620_05000 decimal(15,2)
	--Declare @Var12620_06000 decimal(15,2)
	--Declare @Var12620_07000 decimal(15,2)
	--Declare @Var12620_08000 decimal(15,2)
	--Declare @Var12620_09000 decimal(15,2)
	Declare @Var12630 decimal(15,2)
	Declare @Var12630_01000 decimal(15,2)
	Declare @Var12630_02000 decimal(15,2)
	Declare @Var12630_03000 decimal(15,2)
	Declare @Var12630_04000 decimal(15,2)
	Declare @Var12630_05000 decimal(15,2)
	Declare @Var12630_06000 decimal(15,2)
	Declare @Var12630_07000 decimal(15,2)
	Declare @Var12630_08000 decimal(15,2)
	Declare @Var12630_09000 decimal(15,2)
	Declare @Var12630_10000 decimal(15,2)
	Declare @Var12630_11000 decimal(15,2)
	Declare @Var12630_12000 decimal(15,2)
	Declare @Var12630_13000 decimal(15,2)
	Declare @Var12630_14000 decimal(15,2)
	Declare @Var12630_15000 decimal(15,2)
	Declare @Var12630_16000 decimal(15,2)
	Declare @Var12630_17000 decimal(15,2)
	Declare @Var12630_18000 decimal(15,2)
	Declare @Var12630_19000 decimal(15,2)
	Declare @Var12630_20000 decimal(15,2)
	Declare @Var12630_21000 decimal(15,2)
	Declare @Var12630_22000 decimal(15,2)
	Declare @Var12630_23000 decimal(15,2)
	Declare @Var12630_24000 decimal(15,2)
	Declare @Var12630_25000 decimal(15,2)
	Declare @Var12640_00000 decimal(15,2)
	Declare @Var12640_01000 decimal(15,2)
	Declare @Var12640_02000 decimal(15,2)
	Declare @Var12640_03000 decimal(15,2)
	Declare @Var12640_04000 decimal(15,2)
	Declare @Var12640_05000 decimal(15,2)
	Declare @Var12640_06000 decimal(15,2)
	Declare @Var12640_07000 decimal(15,2)
	Declare @Var12640_08000 decimal(15,2)
	Declare @Var12640_09000 decimal(15,2)
	Declare @Var12650 decimal(15,2)
	Declare @Var12650_01000 decimal(15,2)
	Declare @Var12650_02000 decimal(15,2)
	Declare @Var12650_03000 decimal(15,2)
	Declare @Var12650_04000 decimal(15,2)
	Declare @Var12650_05000 decimal(15,2)
	Declare @Var12650_06000 decimal(15,2)
	Declare @Var12650_07000 decimal(15,2)
	Declare @Var12650_08000 decimal(15,2)
	Declare @Var12650_09000 decimal(15,2)
	
	Declare @Var22310 decimal(15,2)
	Declare @Var22320 decimal(15,2)
	
	Declare @Var11310 decimal(15,2)
	Declare @Var11320 decimal(15,2)
	Declare @Var11330 decimal(15,2)
	Declare @Var11340 decimal(15,2)
	Declare @Var11390 decimal(15,2)
	Declare @Var11300TOT decimal(15,2)
	
	Declare @Var11610Ant decimal(15,2)
	Declare @Var11620Ant decimal(15,2)
	Declare @Var11621Ant decimal(15,2)
	DEclare @Var11622Ant decimal(15,2)
	Declare @Var11623Ant decimal(15,2)
	Declare @Var11624Ant decimal(15,2)
	Declare @Var11625Ant decimal(15,2)
	Declare @Var12810Ant decimal(15,2)
	Declare @Var12820Ant decimal(15,2)
	Declare @Var12830Ant decimal(15,2)
	Declare @Var12840Ant decimal(15,2)
	Declare @Var12890Ant decimal(15,2)
	Declare @Var12600_00000Ant decimal(15,2)
	Declare @Var12610_00000Ant decimal(15,2)
	Declare @Var12610_01000Ant decimal(15,2)
	DEclare @Var12610_02000Ant decimal(15,2)
	Declare @Var12610_03000Ant decimal(15,2)
	Declare @Var12610_04000Ant decimal(15,2)
	Declare @Var12620_00000Ant decimal(15,2)
	--Declare @Var12620_01000Ant decimal(15,2)
	--Declare @Var12620_02000Ant decimal(15,2)
	--Declare @Var12620_03000Ant decimal(15,2)
	--Declare @Var12620_04000Ant decimal(15,2)
	--Declare @Var12620_05000Ant decimal(15,2)
	--Declare @Var12620_06000Ant decimal(15,2)
	--Declare @Var12620_07000Ant decimal(15,2)
	--Declare @Var12620_08000Ant decimal(15,2)
	--Declare @Var12620_09000Ant decimal(15,2)
	Declare @Var12630Ant decimal(15,2)
	Declare @Var12630_01000Ant decimal(15,2)
	Declare @Var12630_02000Ant decimal(15,2)
	Declare @Var12630_03000Ant decimal(15,2)
	Declare @Var12630_04000Ant decimal(15,2)
	Declare @Var12630_05000Ant decimal(15,2)
	Declare @Var12630_06000Ant decimal(15,2)
	Declare @Var12630_07000Ant decimal(15,2)
	Declare @Var12630_08000Ant decimal(15,2)
	Declare @Var12630_09000Ant decimal(15,2)
	Declare @Var12630_10000Ant decimal(15,2)
	Declare @Var12630_11000Ant decimal(15,2)
	Declare @Var12630_12000Ant decimal(15,2)
	Declare @Var12630_13000Ant decimal(15,2)
	Declare @Var12630_14000Ant decimal(15,2)
	Declare @Var12630_15000Ant decimal(15,2)
	Declare @Var12630_16000Ant decimal(15,2)
	Declare @Var12630_17000Ant decimal(15,2)
	Declare @Var12630_18000Ant decimal(15,2)
	Declare @Var12630_19000Ant decimal(15,2)
	Declare @Var12630_20000Ant decimal(15,2)
	Declare @Var12630_21000Ant decimal(15,2)
	Declare @Var12630_22000Ant decimal(15,2)
	Declare @Var12630_23000Ant decimal(15,2)
	Declare @Var12630_24000Ant decimal(15,2)
	Declare @Var12630_25000Ant decimal(15,2)
	DEclare @Var12640_00000Ant decimal(15,2)
	Declare @Var12640_01000Ant decimal(15,2)
	Declare @Var12640_02000Ant decimal(15,2)
	Declare @Var12640_03000Ant decimal(15,2)
	Declare @Var12640_04000Ant decimal(15,2)
	Declare @Var12640_05000Ant decimal(15,2)
	Declare @Var12640_06000Ant decimal(15,2)
	Declare @Var12640_07000Ant decimal(15,2)
	Declare @Var12640_08000Ant decimal(15,2)
	Declare @Var12640_09000Ant decimal(15,2)
	Declare @Var12650Ant decimal(15,2)
	Declare @Var12650_01000Ant decimal(15,2)
	Declare @Var12650_02000Ant decimal(15,2)
	Declare @Var12650_03000Ant decimal(15,2)
	Declare @Var12650_04000Ant decimal(15,2)
	Declare @Var12650_05000Ant decimal(15,2)
	Declare @Var12650_06000Ant decimal(15,2)
	Declare @Var12650_07000Ant decimal(15,2)
	Declare @Var12650_08000Ant decimal(15,2)
	Declare @Var12650_09000Ant decimal(15,2)
	
	Declare @Var22310Ant decimal(15,2)
	Declare @Var22320Ant decimal(15,2)
	
	Declare @Var11310Ant decimal(15,2)
	Declare @Var11320Ant decimal(15,2)
	Declare @Var11330Ant decimal(15,2)
	Declare @Var11340Ant decimal(15,2)
	Declare @Var11390Ant decimal(15,2)
	

--PROCEDIMIENTO FINAL
--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO
DECLARE  @Tmp_BalanzaDeComprobacion TABLE(NumeroCuenta varchar(max),NombreCuenta varchar(max),CargosSinFlujo decimal(15,2),AbonosSinFlujo decimal(15,2),TotalCargos decimal(15,2),TotalAbonos decimal(15,2),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),TipoCuenta int,  MaskNumeroCuenta varchar(max),Total int, Mes int, Year int, MaskNombreCuenta varchar(max),NumeroCuentaAnt varchar(max), SaldoDeudorAnt decimal(15,2),SaldoAcreedorAnt decimal(15,2),MesAnt int,A?oAnt int,Agrupador int  )


--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO A?O ANTERIOR

DECLARE @Tmp_BalanzaDeComprobacionAnterior TABLE(IdCuentaContable bigint, NumeroCuenta varchar(max),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),  Mes int, Year int)

--LLENO TABLA EN MEMORIA DE SALDOS ANTERIORES

INSERT INTO @Tmp_BalanzaDeComprobacionAnterior SELECT     TOP (100) PERCENT dbo.C_Contable.IdCuentaContable, dbo.C_Contable.NumeroCuenta,
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor,dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000') OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @A?o-1 
ORDER BY dbo.C_Contable.NumeroCuenta

--LLENO TABLA TEMPORTAL DE AFECTACION PRESUPUESTO
IF @Tipo=1

INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'C' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos
                       - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'E' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'G' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos
                       WHEN 'I' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE dbo.T_SaldosInicialesCont.AbonosSinFlujo - dbo.T_SaldosInicialesCont.CargosSinFlujo + dbo.T_SaldosInicialesCont.TotalAbonos
                       - dbo.T_SaldosInicialesCont.TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, BalanzaDeComprobacionAnterior.SaldoDeudor AS SaldoDeudorAnt, 
                      BalanzaDeComprobacionAnterior.SaldoAcreedor AS SaldoAcreedorAnt, BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS A?oAnt, 1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      @Tmp_BalanzaDeComprobacionAnterior  BalanzaDeComprobacionAnterior ON 
                      dbo.C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')or (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000')) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) AND (dbo.T_SaldosInicialesCont.Year = @A?o) AND LEFT(dbo.C_Contable.NumeroCuenta, 1)='1'
ORDER BY dbo.C_Contable.NumeroCuenta

ELSE
BEGIN
INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'C' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos
                       - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'E' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'G' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos
                       WHEN 'I' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE dbo.T_SaldosInicialesCont.AbonosSinFlujo - dbo.T_SaldosInicialesCont.CargosSinFlujo + dbo.T_SaldosInicialesCont.TotalAbonos
                       - dbo.T_SaldosInicialesCont.TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, BalanzaDeComprobacionAnterior.SaldoDeudor AS SaldoDeudorAnt, 
                      BalanzaDeComprobacionAnterior.SaldoAcreedor AS SaldoAcreedorAnt, BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS A?oAnt,1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      @Tmp_BalanzaDeComprobacionAnterior BalanzaDeComprobacionAnterior ON 
                      dbo.C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) AND (dbo.T_SaldosInicialesCont.Year = @A?o) AND LEFT(dbo.C_Contable.NumeroCuenta, 1)<>'1'
ORDER BY dbo.C_Contable.NumeroCuenta

END

select @SSaldo = dbo.Saldo_Cuenta('40000-00000',@Mes,@A?o)
if @SSaldo =0 begin select @SSaldo = dbo.Saldo_Cuenta('40000-000000',@Mes,@A?o)end
select @SSaldoAnt = dbo.Saldo_Cuenta('40000-00000',@Mes,@A?o-1)
if @SSaldoAnt =0 begin select @SSaldoAnt= dbo.Saldo_Cuenta('40000-000000',@Mes,@A?o-1)end
select @SSaldo5 = dbo.Saldo_Cuenta('50000-00000',@Mes,@A?o)
if @SSaldo5 =0 begin select @SSaldo5= dbo.Saldo_Cuenta('50000-000000',@Mes,@A?o) end
select @SSaldoAnt5 = dbo.Saldo_Cuenta('50000-00000' ,@Mes , @A?o-1)
if @SSaldoAnt5 =0 begin select @SSaldoAnt5 = dbo.Saldo_Cuenta('50000-000000' ,@Mes , @A?o-1)end

select  @Var11610 =dbo.Saldo_Cuenta('11610-00000',@Mes,@A?o)
if @Var11610 =0 begin select @Var11610 = dbo.Saldo_Cuenta('11610-000000',@Mes,@A?o)end
select @Var11620 =dbo.Saldo_Cuenta('11620-00000',@Mes,@A?o)
if @Var11620 =0 begin select @Var11620 = dbo.Saldo_Cuenta('11620-000000',@Mes,@A?o)end
select @Var11621 =dbo.Saldo_Cuenta('11621-00000',@Mes,@A?o)
if @Var11621 =0 begin select @Var11621 = dbo.Saldo_Cuenta('11621-000000',@Mes,@A?o)end
select @Var11622=dbo.Saldo_Cuenta('11622-00000',@Mes,@A?o)
if @Var11622 =0 begin select @Var11622 = dbo.Saldo_Cuenta('11622-000000',@Mes,@A?o)end
select @Var11623 = dbo.Saldo_Cuenta('11623-00000',@Mes,@A?o)
if @Var11623 =0 begin select @Var11623 = dbo.Saldo_Cuenta('11623-000000',@Mes,@A?o)end
select @Var11624=dbo.Saldo_Cuenta('11624-00000',@Mes,@A?o)
if @Var11624 =0 begin select @Var11624 = dbo.Saldo_Cuenta('11624-000000',@Mes,@A?o)end
select @Var11625 = dbo.Saldo_Cuenta('11625-00000',@Mes,@A?o)
if @Var11625 =0 begin select @Var11625 = dbo.Saldo_Cuenta('11625-000000',@Mes,@A?o)end
select @Var12810 = dbo.Saldo_Cuenta('12810-00000',@Mes,@A?o)
if @Var12810 =0 begin select @Var12810 = dbo.Saldo_Cuenta('12810-000000',@Mes,@A?o)end
select @Var12820=dbo.Saldo_Cuenta('12820-00000',@Mes,@A?o)
if @Var12820 =0 begin select @Var12820 = dbo.Saldo_Cuenta('12820-000000',@Mes,@A?o)end
select @Var12830=dbo.Saldo_Cuenta('12830-00000',@Mes,@A?o)
if @Var12830 =0 begin select @Var12830 = dbo.Saldo_Cuenta('12830-000000',@Mes,@A?o)end
select @Var12840 = dbo.Saldo_Cuenta('12840-00000',@Mes,@A?o)
if @Var12840 =0 begin select @Var12840 = dbo.Saldo_Cuenta('12840-000000',@Mes,@A?o)end
select @Var12890 = dbo.Saldo_Cuenta('12890-00000',@Mes,@A?o)
if @Var12890 =0 begin select @Var12890 = dbo.Saldo_Cuenta('12890-000000',@Mes,@A?o)end
select @Var12600_00000 = dbo.Saldo_Cuenta('12600-00000',@Mes,@A?o)
if @Var12600_00000 =0 begin select @Var12600_00000 = dbo.Saldo_Cuenta('12600-000000',@Mes,@A?o)end
select @Var12610_00000 = dbo.Saldo_Cuenta('12610-00000',@Mes,@A?o)
if @Var12610_00000 =0 begin select @Var12610_00000 = dbo.Saldo_Cuenta('12610-000000',@Mes,@A?o)end
select @Var12610_01000 = dbo.Saldo_Cuenta('12610-01000',@Mes,@A?o)
if @Var12610_01000 =0 begin select @Var12610_01000 = dbo.Saldo_Cuenta('12610-010000',@Mes,@A?o)end
select @Var12610_02000 = dbo.Saldo_Cuenta('12610-02000',@Mes,@A?o)
if @Var12610_02000 =0 begin select @Var12610_02000 = dbo.Saldo_Cuenta('12610-020000',@Mes,@A?o)end
select @Var12610_03000 = dbo.Saldo_Cuenta('12610-03000',@Mes,@A?o)
if @Var12610_03000 =0 begin select @Var12610_03000 = dbo.Saldo_Cuenta('12610-030000',@Mes,@A?o)end 
select @Var12610_04000 = dbo.Saldo_Cuenta('12610-04000',@Mes,@A?o) 
if @Var12610_04000 =0 begin select @Var12610_04000 = dbo.Saldo_Cuenta('12610-040000',@Mes,@A?o)end
select @Var12620_00000 = dbo.Saldo_Cuenta('12620-00000',@Mes,@A?o)
if @Var12620_00000 =0 begin select @Var12620_00000 = dbo.Saldo_Cuenta('12620-000000',@Mes,@A?o)end
select @Var12630 = dbo.Saldo_Cuenta('12630-00000',@Mes,@A?o)
if @Var12630 =0 begin select @Var12630 = dbo.Saldo_Cuenta('12630-000000',@Mes,@A?o)end


select @Var12630_01000  = dbo.Saldo_Cuenta('12630-01000',@Mes,@A?o)
if @Var12630_01000  =0 begin select @Var12630_01000  = dbo.Saldo_Cuenta('12630-010000',@Mes,@A?o)end
select @Var12630_02000  = dbo.Saldo_Cuenta('12630-02000',@Mes,@A?o)
if @Var12630_02000  =0 begin select @Var12630_02000  = dbo.Saldo_Cuenta('12630-020000',@Mes,@A?o)end
select @Var12630_03000  = dbo.Saldo_Cuenta('12630-03000',@Mes,@A?o)
if @Var12630_03000  =0 begin select @Var12630_03000  = dbo.Saldo_Cuenta('12630-030000',@Mes,@A?o)end
select @Var12630_04000  = dbo.Saldo_Cuenta('12630-04000',@Mes,@A?o)
if @Var12630_04000  =0 begin select @Var12630_04000  = dbo.Saldo_Cuenta('12630-040000',@Mes,@A?o)end
select @Var12630_05000  = dbo.Saldo_Cuenta('12630-05000',@Mes,@A?o)
if @Var12630_05000  =0 begin select @Var12630_05000  = dbo.Saldo_Cuenta('12630-050000',@Mes,@A?o)end
select @Var12630_06000  = dbo.Saldo_Cuenta('12630-06000',@Mes,@A?o)
if @Var12630_06000  =0 begin select @Var12630_06000  = dbo.Saldo_Cuenta('12630-060000',@Mes,@A?o)end
select @Var12630_07000  = dbo.Saldo_Cuenta('12630-07000',@Mes,@A?o)
if @Var12630_07000  =0 begin select @Var12630_07000  = dbo.Saldo_Cuenta('12630-070000',@Mes,@A?o)end
select @Var12630_08000  = dbo.Saldo_Cuenta('12630-08000',@Mes,@A?o)
if @Var12630_08000  =0 begin select @Var12630_08000  = dbo.Saldo_Cuenta('12630-080000',@Mes,@A?o)end
select @Var12630_09000  = dbo.Saldo_Cuenta('12630-09000',@Mes,@A?o)
if @Var12630_09000  =0 begin select @Var12630_09000  = dbo.Saldo_Cuenta('12630-090000',@Mes,@A?o)end
select @Var12630_10000  = dbo.Saldo_Cuenta('12630-10000',@Mes,@A?o)
if @Var12630_10000  =0 begin select @Var12630_10000  = dbo.Saldo_Cuenta('12630-100000',@Mes,@A?o)end
select @Var12630_11000  = dbo.Saldo_Cuenta('12630-11000',@Mes,@A?o)
if @Var12630_11000  =0 begin select @Var12630_11000  = dbo.Saldo_Cuenta('12630-110000',@Mes,@A?o)end
select @Var12630_12000  = dbo.Saldo_Cuenta('12630-12000',@Mes,@A?o)
if @Var12630_12000  =0 begin select @Var12630_12000  = dbo.Saldo_Cuenta('12630-120000',@Mes,@A?o)end
select @Var12630_13000  = dbo.Saldo_Cuenta('12630-13000',@Mes,@A?o)
if @Var12630_13000  =0 begin select @Var12630_13000  = dbo.Saldo_Cuenta('12630-130000',@Mes,@A?o)end
select @Var12630_14000  = dbo.Saldo_Cuenta('12630-14000',@Mes,@A?o)
if @Var12630_14000  =0 begin select @Var12630_14000  = dbo.Saldo_Cuenta('12630-140000',@Mes,@A?o)end
select @Var12630_15000  = dbo.Saldo_Cuenta('12630-15000',@Mes,@A?o)
if @Var12630_15000  =0 begin select @Var12630_15000  = dbo.Saldo_Cuenta('12630-150000',@Mes,@A?o)end
select @Var12630_16000  = dbo.Saldo_Cuenta('12630-16000',@Mes,@A?o)
if @Var12630_16000  =0 begin select @Var12630_16000  = dbo.Saldo_Cuenta('12630-160000',@Mes,@A?o)end
select @Var12630_17000  = dbo.Saldo_Cuenta('12630-17000',@Mes,@A?o)
if @Var12630_17000  =0 begin select @Var12630_17000  = dbo.Saldo_Cuenta('12630-170000',@Mes,@A?o)end
select @Var12630_18000  = dbo.Saldo_Cuenta('12630-18000',@Mes,@A?o)
if @Var12630_18000  =0 begin select @Var12630_18000  = dbo.Saldo_Cuenta('12630-180000',@Mes,@A?o)end
select @Var12630_19000  = dbo.Saldo_Cuenta('12630-19000',@Mes,@A?o)
if @Var12630_19000  =0 begin select @Var12630_19000  = dbo.Saldo_Cuenta('12630-190000',@Mes,@A?o)end
select @Var12630_20000  = dbo.Saldo_Cuenta('12630-20000',@Mes,@A?o)
if @Var12630_20000  =0 begin select @Var12630_20000  = dbo.Saldo_Cuenta('12630-200000',@Mes,@A?o)end
select @Var12630_21000  = dbo.Saldo_Cuenta('12630-21000',@Mes,@A?o)
if @Var12630_21000  =0 begin select @Var12630_21000  = dbo.Saldo_Cuenta('12630-210000',@Mes,@A?o)end
select @Var12630_22000  = dbo.Saldo_Cuenta('12630-22000',@Mes,@A?o)
if @Var12630_22000  =0 begin select @Var12630_22000  = dbo.Saldo_Cuenta('12630-220000',@Mes,@A?o)end
select @Var12630_23000  = dbo.Saldo_Cuenta('12630-23000',@Mes,@A?o)
if @Var12630_23000  =0 begin select @Var12630_23000  = dbo.Saldo_Cuenta('12630-230000',@Mes,@A?o)end
select @Var12630_24000  = dbo.Saldo_Cuenta('12630-24000',@Mes,@A?o)
if @Var12630_24000  =0 begin select @Var12630_24000  = dbo.Saldo_Cuenta('12630-240000',@Mes,@A?o)end
select @Var12630_25000  = dbo.Saldo_Cuenta('12630-25000',@Mes,@A?o)
if @Var12630_25000  =0 begin select @Var12630_25000  = dbo.Saldo_Cuenta('12630-250000',@Mes,@A?o)end



select @Var12640_00000 = dbo.Saldo_Cuenta('12640-00000',@Mes,@A?o) 
if @Var12640_00000 =0 begin select @Var12640_00000 = dbo.Saldo_Cuenta('12640-000000',@Mes,@A?o)end

select @Var12640_01000 = dbo.Saldo_Cuenta('12640-01000',@Mes,@A?o) 
if @Var12640_01000 =0 begin select @Var12640_01000 = dbo.Saldo_Cuenta('12640-010000',@Mes,@A?o)end
select @Var12640_02000 = dbo.Saldo_Cuenta('12640-02000',@Mes,@A?o) 
if @Var12640_02000 =0 begin select @Var12640_02000 = dbo.Saldo_Cuenta('12640-020000',@Mes,@A?o)end
select @Var12640_03000 = dbo.Saldo_Cuenta('12640-03000',@Mes,@A?o) 
if @Var12640_03000 =0 begin select @Var12640_03000 = dbo.Saldo_Cuenta('12640-030000',@Mes,@A?o)end
select @Var12640_04000 = dbo.Saldo_Cuenta('12640-04000',@Mes,@A?o) 
if @Var12640_04000 =0 begin select @Var12640_04000 = dbo.Saldo_Cuenta('12640-040000',@Mes,@A?o)end
select @Var12640_05000 = dbo.Saldo_Cuenta('12640-05000',@Mes,@A?o) 
if @Var12640_05000 =0 begin select @Var12640_05000 = dbo.Saldo_Cuenta('12640-050000',@Mes,@A?o)end
select @Var12640_06000 = dbo.Saldo_Cuenta('12640-06000',@Mes,@A?o) 
if @Var12640_06000 =0 begin select @Var12640_06000 = dbo.Saldo_Cuenta('12640-060000',@Mes,@A?o)end
select @Var12640_07000 = dbo.Saldo_Cuenta('12640-07000',@Mes,@A?o) 
if @Var12640_07000 =0 begin select @Var12640_07000 = dbo.Saldo_Cuenta('12640-070000',@Mes,@A?o)end
select @Var12640_08000 = dbo.Saldo_Cuenta('12640-08000',@Mes,@A?o) 
if @Var12640_08000 =0 begin select @Var12640_08000 = dbo.Saldo_Cuenta('12640-080000',@Mes,@A?o)end
select @Var12640_09000 = dbo.Saldo_Cuenta('12640-09000',@Mes,@A?o) 
if @Var12640_09000 =0 begin select @Var12640_09000 = dbo.Saldo_Cuenta('12640-090000',@Mes,@A?o)end


select @Var12650 = dbo.Saldo_Cuenta('12650-00000',@Mes,@A?o)
if @Var12650 =0 begin select @Var12650 = dbo.Saldo_Cuenta('12650-000000',@Mes,@A?o)end

select @Var12650_01000 = dbo.Saldo_Cuenta('12650-01000',@Mes,@A?o) 
if @Var12650_01000 =0 begin select @Var12650_01000 = dbo.Saldo_Cuenta('12650-010000',@Mes,@A?o)end
select @Var12650_02000 = dbo.Saldo_Cuenta('12650-02000',@Mes,@A?o) 
if @Var12650_02000 =0 begin select @Var12650_02000 = dbo.Saldo_Cuenta('12650-020000',@Mes,@A?o)end
select @Var12650_03000 = dbo.Saldo_Cuenta('12650-03000',@Mes,@A?o) 
if @Var12650_03000 =0 begin select @Var12650_03000 = dbo.Saldo_Cuenta('12650-030000',@Mes,@A?o)end
select @Var12650_04000 = dbo.Saldo_Cuenta('12650-04000',@Mes,@A?o) 
if @Var12650_04000 =0 begin select @Var12650_04000 = dbo.Saldo_Cuenta('12650-040000',@Mes,@A?o)end
select @Var12650_05000 = dbo.Saldo_Cuenta('12650-05000',@Mes,@A?o) 
if @Var12650_05000 =0 begin select @Var12650_05000 = dbo.Saldo_Cuenta('12650-050000',@Mes,@A?o)end
select @Var12650_06000 = dbo.Saldo_Cuenta('12650-06000',@Mes,@A?o) 
if @Var12650_06000 =0 begin select @Var12650_06000 = dbo.Saldo_Cuenta('12650-060000',@Mes,@A?o)end
select @Var12650_07000 = dbo.Saldo_Cuenta('12650-07000',@Mes,@A?o) 
if @Var12650_07000 =0 begin select @Var12650_07000 = dbo.Saldo_Cuenta('12650-070000',@Mes,@A?o)end
select @Var12650_08000 = dbo.Saldo_Cuenta('12650-08000',@Mes,@A?o) 
if @Var12650_08000 =0 begin select @Var12650_08000 = dbo.Saldo_Cuenta('12650-080000',@Mes,@A?o)end
select @Var12650_09000 = dbo.Saldo_Cuenta('12650-09000',@Mes,@A?o) 
if @Var12650_09000 =0 begin select @Var12650_09000 = dbo.Saldo_Cuenta('12650-090000',@Mes,@A?o)end


	
select @Var22310 = dbo.Saldo_Cuenta('22310-00000',@Mes,@A?o)
if @Var22310 =0 begin select @Var22310 = dbo.Saldo_Cuenta('22310-000000',@Mes,@A?o)end
select @Var22320 = dbo.Saldo_Cuenta('22320-00000',@Mes,@A?o)
if @Var22320 =0 begin select @Var22320 = dbo.Saldo_Cuenta('22320-000000',@Mes,@A?o)end

select @Var11310 = dbo.Saldo_Cuenta ('11310-00000', @Mes,@A?o)
if @Var11310 =0 begin select @Var11310 = dbo.Saldo_Cuenta('11310-000000',@Mes,@A?o)end
select @Var11320 = dbo.Saldo_Cuenta ('11320-00000', @Mes,@A?o)
if @Var11320 =0 begin select @Var11320 = dbo.Saldo_Cuenta('11320-000000',@Mes,@A?o)end
select @Var11330 = dbo.Saldo_Cuenta ('11330-00000', @Mes,@A?o)
if @Var11330 =0 begin select @Var11330 = dbo.Saldo_Cuenta('11330-000000',@Mes,@A?o)end
select @Var11340 = dbo.Saldo_Cuenta ('11340-00000', @Mes,@A?o)
if @Var11340 =0 begin select @Var11340 = dbo.Saldo_Cuenta('11340-000000',@Mes,@A?o)end
select @Var11390 = dbo.Saldo_Cuenta ('11390-00000', @Mes,@A?o)
if @Var11390 =0 begin select @Var11390 = dbo.Saldo_Cuenta('11340-000000',@Mes,@A?o)end

select @Var11610Ant =dbo.Saldo_Cuenta('11610-00000',@Mes,@A?o-1)
if @Var11610Ant =0 begin select @Var11610Ant = dbo.Saldo_Cuenta('11610-000000',@Mes,@A?o-1) End
select @Var11620Ant =dbo.Saldo_Cuenta('11620-00000',@Mes,@A?o-1)
if @Var11620Ant =0 begin select @Var11620Ant = dbo.Saldo_Cuenta('11620-000000',@Mes,@A?o-1) End
select @Var11621Ant =dbo.Saldo_Cuenta('11621-00000',@Mes,@A?o-1)
if @Var11621Ant =0 begin select @Var11621Ant = dbo.Saldo_Cuenta('11621-000000',@Mes,@A?o-1) End
select @Var11622Ant=dbo.Saldo_Cuenta('11622-00000',@Mes,@A?o-1)
if @Var11622Ant =0 begin select @Var11622Ant = dbo.Saldo_Cuenta('11622-000000',@Mes,@A?o-1) End
select @Var11623Ant = dbo.Saldo_Cuenta('11623-00000',@Mes,@A?o-1)
if @Var11623Ant =0 begin select @Var11623Ant = dbo.Saldo_Cuenta('11623-000000',@Mes,@A?o-1) End
select @Var11624Ant=dbo.Saldo_Cuenta('11624-00000',@Mes,@A?o-1)
if @Var11624Ant =0 begin select @Var11624Ant = dbo.Saldo_Cuenta('11624-000000',@Mes,@A?o-1) End
select @Var11625Ant = dbo.Saldo_Cuenta('11625-00000',@Mes,@A?o-1)
if @Var11625Ant =0 begin select @Var11625Ant = dbo.Saldo_Cuenta('11625-000000',@Mes,@A?o-1) End
select @Var12810Ant = dbo.Saldo_Cuenta('12810-00000',@Mes,@A?o-1)
if @Var12810Ant =0 begin select @Var12810Ant = dbo.Saldo_Cuenta('12810-000000',@Mes,@A?o-1) End
select @Var12820Ant=dbo.Saldo_Cuenta('12820-00000',@Mes,@A?o-1)
if @Var12820Ant =0 begin select @Var12820Ant = dbo.Saldo_Cuenta('12820-000000',@Mes,@A?o-1) End
select @Var12830Ant=dbo.Saldo_Cuenta('12830-00000',@Mes,@A?o-1)
if @Var12830Ant =0 begin select @Var12830Ant = dbo.Saldo_Cuenta('12830-000000',@Mes,@A?o-1) End
select @Var12840Ant = dbo.Saldo_Cuenta('12840-00000',@Mes,@A?o-1)
if @Var12840Ant =0 begin select @Var12840Ant = dbo.Saldo_Cuenta('12840-000000',@Mes,@A?o-1) End
select @Var12890Ant = dbo.Saldo_Cuenta('12890-00000',@Mes,@A?o-1)
if @Var12890Ant =0 begin select @Var12890Ant = dbo.Saldo_Cuenta('12890-000000',@Mes,@A?o-1) End

select @Var12600_00000Ant = dbo.Saldo_Cuenta('12600-00000',@Mes,@A?o-1)
if @Var12600_00000Ant =0 begin select @Var12600_00000Ant = dbo.Saldo_Cuenta('12600-000000',@Mes,@A?o)end
select @Var12610_00000Ant = dbo.Saldo_Cuenta('12610-00000',@Mes,@A?o-1)
if @Var12610_00000Ant =0 begin select @Var12610_00000Ant = dbo.Saldo_Cuenta('12610-000000',@Mes,@A?o)end

select @Var12610_01000Ant = dbo.Saldo_Cuenta('12610-01000',@Mes,@A?o-1)
if @Var12610_01000Ant =0 begin select @Var12610_01000Ant = dbo.Saldo_Cuenta('12610-010000',@Mes,@A?o-1) End
select @Var12610_02000Ant = dbo.Saldo_Cuenta('12610-02000',@Mes,@A?o-1)
if @Var12610_02000Ant =0 begin select @Var12610_02000Ant = dbo.Saldo_Cuenta('12610-020000',@Mes,@A?o-1) End 
select @Var12610_03000Ant = dbo.Saldo_Cuenta('12610-03000',@Mes,@A?o-1)
if @Var12610_03000Ant =0 begin select @Var12610_03000Ant = dbo.Saldo_Cuenta('12610-030000',@Mes,@A?o-1) End 
select @Var12610_04000Ant = dbo.Saldo_Cuenta('12610-04000',@Mes,@A?o-1)
if @Var12610_04000Ant =0 begin select @Var12610_04000Ant = dbo.Saldo_Cuenta('12610-040000',@Mes,@A?o-1) End 
select @Var12620_00000Ant = dbo.Saldo_Cuenta('12620-00000',@Mes,@A?o-1)
if @Var12620_00000Ant =0 begin select @Var12620_00000Ant = dbo.Saldo_Cuenta('12620-000000',@Mes,@A?o-1) End 
select @Var12630Ant = dbo.Saldo_Cuenta('12630-00000',@Mes,@A?o-1)
if @Var12630Ant =0 begin select @Var12630Ant = dbo.Saldo_Cuenta('12630-000000',@Mes,@A?o-1) End

select @Var12630_01000Ant  = dbo.Saldo_Cuenta('12630-01000',@Mes,@A?o-1)
if @Var12630_01000Ant  =0 begin select @Var12630_01000Ant  = dbo.Saldo_Cuenta('12630-010000',@Mes,@A?o)end
select @Var12630_02000Ant  = dbo.Saldo_Cuenta('12630-02000',@Mes,@A?o-1)
if @Var12630_02000Ant  =0 begin select @Var12630_02000Ant  = dbo.Saldo_Cuenta('12630-020000',@Mes,@A?o)end
select @Var12630_03000Ant  = dbo.Saldo_Cuenta('12630-03000',@Mes,@A?o-1)
if @Var12630_03000Ant  =0 begin select @Var12630_03000Ant  = dbo.Saldo_Cuenta('12630-030000',@Mes,@A?o)end
select @Var12630_04000Ant  = dbo.Saldo_Cuenta('12630-04000',@Mes,@A?o-1)
if @Var12630_04000Ant  =0 begin select @Var12630_04000Ant  = dbo.Saldo_Cuenta('12630-040000',@Mes,@A?o)end
select @Var12630_05000Ant  = dbo.Saldo_Cuenta('12630-05000',@Mes,@A?o-1)
if @Var12630_05000Ant  =0 begin select @Var12630_05000Ant  = dbo.Saldo_Cuenta('12630-050000',@Mes,@A?o)end
select @Var12630_06000Ant  = dbo.Saldo_Cuenta('12630-06000',@Mes,@A?o-1)
if @Var12630_06000Ant  =0 begin select @Var12630_06000Ant  = dbo.Saldo_Cuenta('12630-060000',@Mes,@A?o)end
select @Var12630_07000Ant  = dbo.Saldo_Cuenta('12630-07000',@Mes,@A?o-1)
if @Var12630_07000Ant  =0 begin select @Var12630_07000Ant  = dbo.Saldo_Cuenta('12630-070000',@Mes,@A?o)end
select @Var12630_08000Ant  = dbo.Saldo_Cuenta('12630-08000',@Mes,@A?o-1)
if @Var12630_08000Ant  =0 begin select @Var12630_08000Ant  = dbo.Saldo_Cuenta('12630-080000',@Mes,@A?o)end
select @Var12630_09000Ant  = dbo.Saldo_Cuenta('12630-09000',@Mes,@A?o-1)
if @Var12630_09000Ant  =0 begin select @Var12630_09000Ant  = dbo.Saldo_Cuenta('12630-090000',@Mes,@A?o)end
select @Var12630_10000Ant  = dbo.Saldo_Cuenta('12630-10000',@Mes,@A?o-1)
if @Var12630_10000Ant  =0 begin select @Var12630_10000Ant  = dbo.Saldo_Cuenta('12630-100000',@Mes,@A?o)end
select @Var12630_11000Ant  = dbo.Saldo_Cuenta('12630-11000',@Mes,@A?o-1)
if @Var12630_11000Ant  =0 begin select @Var12630_11000Ant  = dbo.Saldo_Cuenta('12630-110000',@Mes,@A?o)end
select @Var12630_12000Ant  = dbo.Saldo_Cuenta('12630-12000',@Mes,@A?o-1)
if @Var12630_12000Ant  =0 begin select @Var12630_12000Ant  = dbo.Saldo_Cuenta('12630-120000',@Mes,@A?o)end
select @Var12630_13000Ant  = dbo.Saldo_Cuenta('12630-13000',@Mes,@A?o-1)
if @Var12630_13000Ant  =0 begin select @Var12630_13000Ant  = dbo.Saldo_Cuenta('12630-130000',@Mes,@A?o)end
select @Var12630_14000Ant  = dbo.Saldo_Cuenta('12630-14000',@Mes,@A?o-1)
if @Var12630_14000Ant  =0 begin select @Var12630_14000Ant  = dbo.Saldo_Cuenta('12630-140000',@Mes,@A?o)end
select @Var12630_15000Ant  = dbo.Saldo_Cuenta('12630-15000',@Mes,@A?o-1)
if @Var12630_15000Ant  =0 begin select @Var12630_15000Ant  = dbo.Saldo_Cuenta('12630-150000',@Mes,@A?o)end
select @Var12630_16000Ant  = dbo.Saldo_Cuenta('12630-16000',@Mes,@A?o-1)
if @Var12630_16000Ant  =0 begin select @Var12630_16000Ant  = dbo.Saldo_Cuenta('12630-160000',@Mes,@A?o)end
select @Var12630_17000Ant  = dbo.Saldo_Cuenta('12630-17000',@Mes,@A?o-1)
if @Var12630_17000Ant  =0 begin select @Var12630_17000Ant  = dbo.Saldo_Cuenta('12630-170000',@Mes,@A?o)end
select @Var12630_18000Ant  = dbo.Saldo_Cuenta('12630-18000',@Mes,@A?o-1)
if @Var12630_18000Ant  =0 begin select @Var12630_18000Ant  = dbo.Saldo_Cuenta('12630-180000',@Mes,@A?o)end
select @Var12630_19000Ant  = dbo.Saldo_Cuenta('12630-19000',@Mes,@A?o-1)
if @Var12630_19000Ant  =0 begin select @Var12630_19000Ant  = dbo.Saldo_Cuenta('12630-190000',@Mes,@A?o)end
select @Var12630_20000Ant  = dbo.Saldo_Cuenta('12630-20000',@Mes,@A?o-1)
if @Var12630_20000Ant  =0 begin select @Var12630_20000Ant  = dbo.Saldo_Cuenta('12630-200000',@Mes,@A?o)end
select @Var12630_21000Ant  = dbo.Saldo_Cuenta('12630-21000',@Mes,@A?o-1)
if @Var12630_21000Ant  =0 begin select @Var12630_21000Ant  = dbo.Saldo_Cuenta('12630-210000',@Mes,@A?o)end
select @Var12630_22000Ant  = dbo.Saldo_Cuenta('12630-22000',@Mes,@A?o-1)
if @Var12630_22000Ant  =0 begin select @Var12630_22000Ant  = dbo.Saldo_Cuenta('12630-220000',@Mes,@A?o)end
select @Var12630_23000Ant  = dbo.Saldo_Cuenta('12630-23000',@Mes,@A?o-1)
if @Var12630_23000Ant  =0 begin select @Var12630_23000Ant  = dbo.Saldo_Cuenta('12630-230000',@Mes,@A?o)end
select @Var12630_24000Ant  = dbo.Saldo_Cuenta('12630-24000',@Mes,@A?o-1)
if @Var12630_24000Ant  =0 begin select @Var12630_24000Ant  = dbo.Saldo_Cuenta('12630-240000',@Mes,@A?o)end
select @Var12630_25000Ant  = dbo.Saldo_Cuenta('12630-25000',@Mes,@A?o-1)
if @Var12630_25000Ant  =0 begin select @Var12630_25000Ant  = dbo.Saldo_Cuenta('12630-250000',@Mes,@A?o)end


select @Var12640_00000Ant = dbo.Saldo_Cuenta('12640-00000',@Mes,@A?o-1)
if @Var12640_00000Ant =0 begin select @Var12640_00000Ant = dbo.Saldo_Cuenta('12640-000000',@Mes,@A?o-1) End

select @Var12640_01000Ant = dbo.Saldo_Cuenta('12640-01000',@Mes,@A?o-1) 
if @Var12640_01000Ant =0 begin select @Var12640_01000Ant = dbo.Saldo_Cuenta('12640-010000',@Mes,@A?o)end
select @Var12640_02000Ant = dbo.Saldo_Cuenta('12640-02000',@Mes,@A?o-1) 
if @Var12640_02000Ant =0 begin select @Var12640_02000Ant = dbo.Saldo_Cuenta('12640-020000',@Mes,@A?o)end
select @Var12640_03000Ant = dbo.Saldo_Cuenta('12640-03000',@Mes,@A?o-1) 
if @Var12640_03000Ant =0 begin select @Var12640_03000Ant = dbo.Saldo_Cuenta('12640-030000',@Mes,@A?o)end
select @Var12640_04000Ant = dbo.Saldo_Cuenta('12640-04000',@Mes,@A?o-1) 
if @Var12640_04000Ant =0 begin select @Var12640_04000Ant = dbo.Saldo_Cuenta('12640-040000',@Mes,@A?o)end
select @Var12640_05000Ant = dbo.Saldo_Cuenta('12640-05000',@Mes,@A?o-1) 
if @Var12640_05000Ant =0 begin select @Var12640_05000Ant = dbo.Saldo_Cuenta('12640-050000',@Mes,@A?o)end
select @Var12640_06000Ant = dbo.Saldo_Cuenta('12640-06000',@Mes,@A?o-1) 
if @Var12640_06000Ant =0 begin select @Var12640_06000Ant = dbo.Saldo_Cuenta('12640-060000',@Mes,@A?o)end
select @Var12640_07000Ant = dbo.Saldo_Cuenta('12640-07000',@Mes,@A?o-1) 
if @Var12640_07000Ant =0 begin select @Var12640_07000Ant = dbo.Saldo_Cuenta('12640-070000',@Mes,@A?o)end
select @Var12640_08000Ant = dbo.Saldo_Cuenta('12640-08000',@Mes,@A?o-1) 
if @Var12640_08000Ant =0 begin select @Var12640_08000Ant = dbo.Saldo_Cuenta('12640-080000',@Mes,@A?o)end
select @Var12640_09000Ant = dbo.Saldo_Cuenta('12640-09000',@Mes,@A?o-1) 
if @Var12640_09000Ant =0 begin select @Var12640_09000Ant = dbo.Saldo_Cuenta('12640-090000',@Mes,@A?o)end
 
select @Var12650Ant = dbo.Saldo_Cuenta('12650-00000',@Mes,@A?o-1)
if @Var12650Ant =0 begin select @Var12650Ant = dbo.Saldo_Cuenta('12650-000000',@Mes,@A?o-1) End

select @Var12650_01000Ant = dbo.Saldo_Cuenta('12650-01000',@Mes,@A?o-1) 
if @Var12650_01000Ant =0 begin select @Var12650_01000Ant = dbo.Saldo_Cuenta('12650-010000',@Mes,@A?o)end
select @Var12650_02000Ant = dbo.Saldo_Cuenta('12650-02000',@Mes,@A?o-1) 
if @Var12650_02000Ant =0 begin select @Var12650_02000Ant = dbo.Saldo_Cuenta('12650-020000',@Mes,@A?o)end
select @Var12650_03000Ant = dbo.Saldo_Cuenta('12650-03000',@Mes,@A?o-1) 
if @Var12650_03000Ant =0 begin select @Var12650_03000Ant = dbo.Saldo_Cuenta('12650-030000',@Mes,@A?o)end
select @Var12650_04000Ant = dbo.Saldo_Cuenta('12650-04000',@Mes,@A?o-1) 
if @Var12650_04000Ant =0 begin select @Var12650_04000Ant = dbo.Saldo_Cuenta('12650-040000',@Mes,@A?o)end
select @Var12650_05000Ant = dbo.Saldo_Cuenta('12650-05000',@Mes,@A?o-1) 
if @Var12650_05000Ant =0 begin select @Var12650_05000Ant = dbo.Saldo_Cuenta('12650-050000',@Mes,@A?o)end
select @Var12650_06000Ant = dbo.Saldo_Cuenta('12650-06000',@Mes,@A?o-1) 
if @Var12650_06000Ant =0 begin select @Var12650_06000Ant = dbo.Saldo_Cuenta('12650-060000',@Mes,@A?o)end
select @Var12650_07000Ant = dbo.Saldo_Cuenta('12650-07000',@Mes,@A?o-1) 
if @Var12650_07000Ant =0 begin select @Var12650_07000Ant = dbo.Saldo_Cuenta('12650-070000',@Mes,@A?o)end
select @Var12650_08000Ant = dbo.Saldo_Cuenta('12650-08000',@Mes,@A?o-1) 
if @Var12650_08000Ant =0 begin select @Var12650_08000Ant = dbo.Saldo_Cuenta('12650-080000',@Mes,@A?o)end
select @Var12650_09000Ant = dbo.Saldo_Cuenta('12650-09000',@Mes,@A?o-1) 
if @Var12650_09000Ant =0 begin select @Var12650_09000Ant = dbo.Saldo_Cuenta('12650-090000',@Mes,@A?o)end
	
select @Var22310Ant = dbo.Saldo_Cuenta('22310-00000',@Mes,@A?o-1)
if @Var22310Ant =0 begin select @Var22310Ant = dbo.Saldo_Cuenta('22310-000000',@Mes,@A?o-1) End
select @Var22320Ant = dbo.Saldo_Cuenta('22320-00000',@Mes,@A?o-1)
if @Var22320Ant =0 begin select @Var22320Ant = dbo.Saldo_Cuenta('22320-000000',@Mes,@A?o-1) End

select @Var11310Ant = dbo.Saldo_Cuenta ('11310-00000', @Mes,@A?o-1)
if @Var11310Ant =0 begin select @Var11310Ant = dbo.Saldo_Cuenta('11310-000000',@Mes,@A?o-1) End
select @Var11320Ant = dbo.Saldo_Cuenta ('11320-00000', @Mes,@A?o-1)
if @Var11320Ant =0 begin select @Var11320Ant = dbo.Saldo_Cuenta('11320-000000',@Mes,@A?o-1) End
select @Var11330Ant = dbo.Saldo_Cuenta ('11330-00000', @Mes,@A?o-1)
if @Var11330Ant =0 begin select @Var11330Ant = dbo.Saldo_Cuenta('11330-000000',@Mes,@A?o-1) End
select @Var11340Ant = dbo.Saldo_Cuenta ('11340-00000', @Mes,@A?o-1)
if @Var11340Ant =0 begin select @Var11340Ant = dbo.Saldo_Cuenta('11340-000000',@Mes,@A?o-1) End
select @Var11390Ant = dbo.Saldo_Cuenta ('11390-00000', @Mes,@A?o-1)
if @Var11390Ant =0 begin select @Var11390Ant = dbo.Saldo_Cuenta('11390-000000',@Mes,@A?o-1) End


UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor= SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt= SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5 where MaskNumeroCuenta='32100'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='32000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='30000'
--INICIAN UPDATES PARA LAS CUENTAS A MODIFICAR
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11220-00000' or NumeroCuenta='11220-000000' 
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11200-00000' or NumeroCuenta='11200-000000'--Misma afectacion a Cuenta padre

--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11220-00000' or NumeroCuenta= '11220-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11620 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11620Ant  where NumeroCuenta='11400-00000' or NumeroCuenta= '11400-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11621 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11621Ant  where NumeroCuenta='11410-00000' or NumeroCuenta= '11410-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11622 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11622Ant  where NumeroCuenta='11420-00000' or NumeroCuenta= '11420-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11623 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11623Ant  where NumeroCuenta='11430-00000' or NumeroCuenta= '11430-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11624 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11624Ant  where NumeroCuenta='11440-00000' or NumeroCuenta= '11440-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11625 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11625Ant  where NumeroCuenta='11450-00000' or NumeroCuenta= '11450-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12810 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12810Ant  where NumeroCuenta='12210-00000' or NumeroCuenta= '12210-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12820 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12820Ant  where NumeroCuenta='12220-00000' or NumeroCuenta= '12220-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12830 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12830Ant  where NumeroCuenta='12230-00000' or NumeroCuenta= '12230-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12840 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12840Ant  where NumeroCuenta='12240-00000' or NumeroCuenta= '12240-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12890 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12890Ant  where NumeroCuenta='12290-00000' or NumeroCuenta= '12290-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12810+@Var12820+@Var12830+@Var12840+@Var12890) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12810Ant+@Var12820Ant+@Var12830Ant+@Var12840Ant+@Var12890Ant)  where NumeroCuenta='12200-00000' or NumeroCuenta= '12200-000000'--Misma afectacion a cuenta padre

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_01000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_01000Ant  where NumeroCuenta='12310-00000' or NumeroCuenta= '12310-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_02000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_02000Ant  where NumeroCuenta='12320-00000' or NumeroCuenta= '12320-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_03000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_03000Ant  where NumeroCuenta='12330-00000' or NumeroCuenta= '12330-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12620_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12620_00000Ant  where NumeroCuenta='12340-00000' or NumeroCuenta= '12340-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_04000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_04000Ant  where NumeroCuenta='12390-00000' or NumeroCuenta= '12390-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12610_01000+@Var12610_02000+@Var12610_03000+@Var12620_00000+@Var12610_04000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12610_01000Ant+@Var12610_02000Ant+@Var12610_03000Ant+@Var12620_00000Ant+@Var12610_04000Ant)  where NumeroCuenta='12300-00000' or NumeroCuenta= '12300-000000'--mimos movimientos a su cuenta padre

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630Ant)  where NumeroCuenta='12400-00000' or NumeroCuenta= '12400-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_01000+@Var12630_02000+@Var12630_03000+@Var12630_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_01000Ant+@Var12630_02000Ant+@Var12630_03000Ant+@Var12630_04000Ant)  where NumeroCuenta='12410-00000' or NumeroCuenta= '12410-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_05000+@Var12630_06000+@Var12630_07000+@Var12630_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_05000Ant+@Var12630_06000Ant+@Var12630_07000Ant+@Var12630_08000Ant)  where NumeroCuenta='12420-00000' or NumeroCuenta= '12420-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_09000+@Var12630_10000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_09000Ant+@Var12630_10000Ant)  where NumeroCuenta='12430-00000' or NumeroCuenta= '12430-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_11000+@Var12630_12000+@Var12630_13000+@Var12630_14000+@Var12630_15000+@Var12630_16000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_11000Ant+@Var12630_12000Ant+@Var12630_13000Ant+@Var12630_14000Ant+@Var12630_15000Ant+@Var12630_16000Ant)  where NumeroCuenta='12440-00000' or NumeroCuenta= '12440-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630_17000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630_17000Ant  where NumeroCuenta='12450-00000' or NumeroCuenta= '12450-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_18000+@Var12630_19000+@Var12630_20000+@Var12630_21000+@Var12630_22000+@Var12630_23000+@Var12630_24000+@Var12630_25000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_18000Ant+@Var12630_19000Ant+@Var12630_20000Ant+@Var12630_21000Ant+@Var12630_22000Ant+@Var12630_23000Ant+@Var12630_24000Ant+@Var12630_25000Ant)  where NumeroCuenta='12460-00000' or NumeroCuenta= '12460-000000'
--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630Ant  where NumeroCuenta='12470-00000' or NumeroCuenta= '12470-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12640_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12640_00000Ant  where NumeroCuenta='12480-00000' or NumeroCuenta= '12480-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650Ant  where NumeroCuenta='12500-00000' or NumeroCuenta= '12500-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_01000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_01000Ant  where NumeroCuenta='12510-00000' or NumeroCuenta= '12510-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_02000+@Var12650_03000+@Var12650_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_02000Ant+@Var12650_03000Ant+@Var12650_04000Ant)  where NumeroCuenta='12520-00000' or NumeroCuenta= '12520-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_05000+@Var12650_06000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_05000Ant+@Var12650_06000Ant)  where NumeroCuenta='12530-00000' or NumeroCuenta= '12530-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_07000+@Var12650_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_07000Ant+@Var12650_08000Ant)  where NumeroCuenta='12540-00000' or NumeroCuenta= '12540-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_09000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_09000  where NumeroCuenta='12590-00000' or NumeroCuenta= '12590-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22310 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22310Ant  where NumeroCuenta='22330-00000' or NumeroCuenta= '22330-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22320 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22320Ant  where NumeroCuenta='22340-00000' or NumeroCuenta= '22340-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set MaskNombreCuenta='                  DEUDA P?BLICA INTERNA'  where NumeroCuenta='22330-00000' or NumeroCuenta='22330-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set MaskNombreCuenta='                  DEUDA P?BLICA EXTERNA'  where NumeroCuenta='22340-00000' or NumeroCuenta='22340-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='22310-00000' or NumeroCuenta='22310-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='22320-00000' or NumeroCuenta='22320-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=@Var11310 + @Var11320 + @Var11330 + @Var11340 + @Var11390, SaldoDeudorAnt= @Var11310Ant + @Var11320Ant + @Var11330Ant + @Var11340Ant + @Var11390Ant  where NumeroCuenta='11310-00000' or NumeroCuenta='11310-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set MaskNombreCuenta='                  ANTCIPOS A CORTO PLAZO'  where NumeroCuenta='11310-00000' or NumeroCuenta='11310-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='11320-00000' or NumeroCuenta= '11320-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='11330-00000' or NumeroCuenta= '11330-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='11340-00000' or NumeroCuenta= '11340-000000'
DELETE from @Tmp_BalanzaDeComprobacion where NumeroCuenta='11390-00000' or NumeroCuenta= '11390-000000'
--total activo circulante
INSERT INTO @Tmp_BalanzaDeComprobacion select top(1)
 '1199A-00000' as NumeroCuenta,
 '' as NombreCuenta,
 cargossinflujo,
 abonossinflujo,
 TotalCargos,
 TotalAbonos,
 SaldoDeudor,
 saldoAcreedor,
tipocuenta,
 '' as MaskNumeroCuenta,
 1 as total,
 Mes,
 Year,
 '          Total Activo Circulante' as MaskNombreCuenta,
 '' as numerocuentaant,
  saldodeudorAnt,
  SaldoAcreedorAnt,
  MesAnt,
  A?oAnt,
  agrupador
  from @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta= '11000'
  --Activo No circulante
INSERT INTO @Tmp_BalanzaDeComprobacion select top(1)
 '1299A-00000' as NumeroCuenta,
 '' as NombreCuenta,
 cargossinflujo,
 abonossinflujo,
 TotalCargos,
 TotalAbonos,
 SaldoDeudor,
 saldoAcreedor,
tipocuenta,
 '' as MaskNumeroCuenta,
 1 as total,
 Mes,
 Year,
 '          Total Activo No Circulante' as MaskNombreCuenta,
 '1299A' as numerocuentaant,
  saldodeudorAnt,
  SaldoAcreedorAnt,
  MesAnt,
  A?oAnt,
  agrupador
  from @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta= '12000'  
--total Pasivo circulante
INSERT INTO @Tmp_BalanzaDeComprobacion select top(1)
 '2199A-00000' as NumeroCuenta,
 '' as NombreCuenta,
 cargossinflujo,
 abonossinflujo,
 TotalCargos,
 TotalAbonos,
 SaldoDeudor,
 saldoAcreedor,
tipocuenta,
 '' as MaskNumeroCuenta,
 1 as total,
 Mes,
 Year,
 '          Total Pasivo Circulante' as MaskNombreCuenta,
 '' as numerocuentaant,
  saldodeudorAnt,
  SaldoAcreedorAnt,
  MesAnt,
  A?oAnt,
  agrupador
  from @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta= '21000'
--total Pasivo No circulante
INSERT INTO @Tmp_BalanzaDeComprobacion select top(1)
 '2299A-00000' as NumeroCuenta,
 '' as NombreCuenta,
 cargossinflujo,
 abonossinflujo,
 TotalCargos,
 TotalAbonos,
 SaldoDeudor,
 saldoAcreedor,
tipocuenta,
 '' as MaskNumeroCuenta,
 1 as total,
 Mes,
 Year,
 '          Total Pasivo No Circulante' as MaskNombreCuenta,
 '' as numerocuentaant,
  saldodeudorAnt,
  SaldoAcreedorAnt,
  MesAnt,
  A?oAnt,
  agrupador
  from @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta= '22000'
  
SELECT
NumeroCuenta,
NombreCuenta,
(CargosSinFlujo/1000) as CargosSinFlujo,
(AbonosSinFlujo/1000) as AbonosSinFlujo,
(TotalCargos/1000) as TotalCargos,
(TotalAbonos/1000) as TotalAbonos,
Isnull((SaldoDeudor/1000),0) as SaldoDeudor,
(SaldoAcreedor/1000) as SaldoAcreedor,
TipoCuenta,  
MaskNumeroCuenta,
Total, 
Mes, 
Year, 
MaskNombreCuenta,
NumeroCuentaAnt, 
isnull((SaldoDeudorAnt/1000),0) as SaldoDeudorAnt,
(SaldoAcreedorAnt/1000) as SaldoAcreedorAnt,
MesAnt,
A?oAnt,
Agrupador 
FROM @Tmp_BalanzaDeComprobacion
order by NumeroCuenta
--FIN DE PROCEDIMIENTO
END

--//////////FIN REPORTE_Balanza_De_Comprobacion

GO


--//////////REPORTE_Balanza_De_Comprobacion_Totalizado

/****** Object:  StoredProcedure [dbo].[REPORTE_Balanza_De_Comprobacion_Totalizado]    Script Date: 10/08/2012 12:30:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[REPORTE_Balanza_De_Comprobacion_Totalizado]

 @Mes int,
 @A?o int

AS
BEGIN

Declare @Reporte int
	Declare @SSaldo decimal(15,2)
	Declare @SSaldoAnt Decimal(15,2)
	Declare @SSaldo5 decimal(15,2)
	Declare @SSaldoAnt5 decimal(15,2)
	Declare @Var11610 decimal(15,2)
	Declare @Var11620 decimal(15,2)
	Declare @Var11621 decimal(15,2)
	DEclare @Var11622 decimal(15,2)
	Declare @Var11623 decimal(15,2)
	Declare @Var11624 decimal(15,2)
	Declare @Var11625 decimal(15,2)
	Declare @Var12810 decimal(15,2)
	Declare @Var12820 decimal(15,2)
	Declare @Var12830 decimal(15,2)
	Declare @Var12840 decimal(15,2)
	Declare @Var12890 decimal(15,2)
	Declare @Var12600_00000 decimal(15,2)
	Declare @Var12610_00000 decimal(15,2)
	Declare @Var12610_01000 decimal(15,2)
	DEclare @Var12610_02000 decimal(15,2)
	Declare @Var12610_03000 decimal(15,2)
	Declare @Var12610_04000 decimal(15,2)
	Declare @Var12620_00000 decimal(15,2)
	Declare @Var12630 decimal(15,2)
	Declare @Var12630_01000 decimal(15,2)
	Declare @Var12630_02000 decimal(15,2)
	Declare @Var12630_03000 decimal(15,2)
	Declare @Var12630_04000 decimal(15,2)
	Declare @Var12630_05000 decimal(15,2)
	Declare @Var12630_06000 decimal(15,2)
	Declare @Var12630_07000 decimal(15,2)
	Declare @Var12630_08000 decimal(15,2)
	Declare @Var12630_09000 decimal(15,2)
	Declare @Var12630_10000 decimal(15,2)
	Declare @Var12630_11000 decimal(15,2)
	Declare @Var12630_12000 decimal(15,2)
	Declare @Var12630_13000 decimal(15,2)
	Declare @Var12630_14000 decimal(15,2)
	Declare @Var12630_15000 decimal(15,2)
	Declare @Var12630_16000 decimal(15,2)
	Declare @Var12630_17000 decimal(15,2)
	Declare @Var12630_18000 decimal(15,2)
	Declare @Var12630_19000 decimal(15,2)
	Declare @Var12630_20000 decimal(15,2)
	Declare @Var12630_21000 decimal(15,2)
	Declare @Var12630_22000 decimal(15,2)
	Declare @Var12630_23000 decimal(15,2)
	Declare @Var12630_24000 decimal(15,2)
	Declare @Var12630_25000 decimal(15,2)
	DEclare @Var12640_00000 decimal(15,2)
	Declare @Var12640_01000 decimal(15,2)
	Declare @Var12640_02000 decimal(15,2)
	Declare @Var12640_03000 decimal(15,2)
	Declare @Var12640_04000 decimal(15,2)
	Declare @Var12640_05000 decimal(15,2)
	Declare @Var12640_06000 decimal(15,2)
	Declare @Var12640_07000 decimal(15,2)
	Declare @Var12640_08000 decimal(15,2)
	Declare @Var12640_09000 decimal(15,2)
	Declare @Var12650 decimal(15,2)
	Declare @Var12650_01000 decimal(15,2)
	Declare @Var12650_02000 decimal(15,2)
	Declare @Var12650_03000 decimal(15,2)
	Declare @Var12650_04000 decimal(15,2)
	Declare @Var12650_05000 decimal(15,2)
	Declare @Var12650_06000 decimal(15,2)
	Declare @Var12650_07000 decimal(15,2)
	Declare @Var12650_08000 decimal(15,2)
	Declare @Var12650_09000 decimal(15,2)
	
	Declare @Var22310 decimal(15,2)
	Declare @Var22320 decimal(15,2)
	
	Declare @Var11610Ant decimal(15,2)
	Declare @Var11620Ant decimal(15,2)
	Declare @Var11621Ant decimal(15,2)
	DEclare @Var11622Ant decimal(15,2)
	Declare @Var11623Ant decimal(15,2)
	Declare @Var11624Ant decimal(15,2)
	Declare @Var11625Ant decimal(15,2)
	Declare @Var12810Ant decimal(15,2)
	Declare @Var12820Ant decimal(15,2)
	Declare @Var12830Ant decimal(15,2)
	Declare @Var12840Ant decimal(15,2)
	Declare @Var12890Ant decimal(15,2)
	Declare @Var12600_00000Ant decimal(15,2)
	Declare @Var12610_00000Ant decimal(15,2)
	Declare @Var12610_01000Ant decimal(15,2)
	DEclare @Var12610_02000Ant decimal(15,2)
	Declare @Var12610_03000Ant decimal(15,2)
	Declare @Var12610_04000Ant decimal(15,2)
	DEclare @Var12620_00000Ant decimal(15,2)
	Declare @Var12630Ant decimal(15,2)
	Declare @Var12630_01000Ant decimal(15,2)
	Declare @Var12630_02000Ant decimal(15,2)
	Declare @Var12630_03000Ant decimal(15,2)
	Declare @Var12630_04000Ant decimal(15,2)
	Declare @Var12630_05000Ant decimal(15,2)
	Declare @Var12630_06000Ant decimal(15,2)
	Declare @Var12630_07000Ant decimal(15,2)
	Declare @Var12630_08000Ant decimal(15,2)
	Declare @Var12630_09000Ant decimal(15,2)
	Declare @Var12630_10000Ant decimal(15,2)
	Declare @Var12630_11000Ant decimal(15,2)
	Declare @Var12630_12000Ant decimal(15,2)
	Declare @Var12630_13000Ant decimal(15,2)
	Declare @Var12630_14000Ant decimal(15,2)
	Declare @Var12630_15000Ant decimal(15,2)
	Declare @Var12630_16000Ant decimal(15,2)
	Declare @Var12630_17000Ant decimal(15,2)
	Declare @Var12630_18000Ant decimal(15,2)
	Declare @Var12630_19000Ant decimal(15,2)
	Declare @Var12630_20000Ant decimal(15,2)
	Declare @Var12630_21000Ant decimal(15,2)
	Declare @Var12630_22000Ant decimal(15,2)
	Declare @Var12630_23000Ant decimal(15,2)
	Declare @Var12630_24000Ant decimal(15,2)
	Declare @Var12630_25000Ant decimal(15,2)
	DEclare @Var12640_00000Ant decimal(15,2)
	Declare @Var12640_01000Ant decimal(15,2)
	Declare @Var12640_02000Ant decimal(15,2)
	Declare @Var12640_03000Ant decimal(15,2)
	Declare @Var12640_04000Ant decimal(15,2)
	Declare @Var12640_05000Ant decimal(15,2)
	Declare @Var12640_06000Ant decimal(15,2)
	Declare @Var12640_07000Ant decimal(15,2)
	Declare @Var12640_08000Ant decimal(15,2)
	Declare @Var12640_09000Ant decimal(15,2)
	Declare @Var12650Ant decimal(15,2)
	Declare @Var12650_01000Ant decimal(15,2)
	Declare @Var12650_02000Ant decimal(15,2)
	Declare @Var12650_03000Ant decimal(15,2)
	Declare @Var12650_04000Ant decimal(15,2)
	Declare @Var12650_05000Ant decimal(15,2)
	Declare @Var12650_06000Ant decimal(15,2)
	Declare @Var12650_07000Ant decimal(15,2)
	Declare @Var12650_08000Ant decimal(15,2)
	Declare @Var12650_09000Ant decimal(15,2)
	
	Declare @Var22310Ant decimal(15,2)
	Declare @Var22320Ant decimal(15,2)
	

--PROCEDIMIENTO FINAL
--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO
DECLARE  @Tmp_BalanzaDeComprobacion TABLE(NumeroCuenta varchar(max),NombreCuenta varchar(max),CargosSinFlujo decimal(15,2),AbonosSinFlujo decimal(15,2),TotalCargos decimal(15,2),TotalAbonos decimal(15,2),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),TipoCuenta int,  MaskNumeroCuenta varchar(max),Total int, Mes int, Year int, MaskNombreCuenta varchar(max),NumeroCuentaAnt varchar(max), SaldoDeudorAnt decimal(15,2),SaldoAcreedorAnt decimal(15,2),MesAnt int,A?oAnt int,Agrupador int  )


--CREO TABLA TEMPORAL DE AFECTACION PRESUPUESTO A?O ANTERIOR

DECLARE @Tmp_BalanzaDeComprobacionAnterior TABLE(IdCuentaContable bigint, NumeroCuenta varchar(max),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),  Mes int, Year int)

--LLENO TABLA EN MEMORIA DE SALDOS ANTERIORES

INSERT INTO @Tmp_BalanzaDeComprobacionAnterior SELECT     TOP (100) PERCENT dbo.C_Contable.IdCuentaContable, dbo.C_Contable.NumeroCuenta,
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor,dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')or(RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') and dbo.T_SaldosInicialesCont.Mes = @mes and
                      dbo.T_SaldosInicialesCont.Year = @A?o-1 
ORDER BY dbo.C_Contable.NumeroCuenta

--LLENO TABLA TEMPORTAL DE AFECTACION PRESUPUESTO

INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'C' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos
                       - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'E' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos WHEN 'G' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos
                       WHEN 'I' THEN dbo.T_SaldosInicialesCont.CargosSinFlujo - dbo.T_SaldosInicialesCont.AbonosSinFlujo + dbo.T_SaldosInicialesCont.TotalCargos - dbo.T_SaldosInicialesCont.TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE dbo.T_SaldosInicialesCont.AbonosSinFlujo - dbo.T_SaldosInicialesCont.CargosSinFlujo + dbo.T_SaldosInicialesCont.TotalAbonos
                       - dbo.T_SaldosInicialesCont.TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      BalanzaDeComprobacionAnterior.NumeroCuenta AS NumeroCuentaAnt, BalanzaDeComprobacionAnterior.SaldoDeudor AS SaldoDeudorAnt, 
                      BalanzaDeComprobacionAnterior.SaldoAcreedor AS SaldoAcreedorAnt, BalanzaDeComprobacionAnterior.Mes AS MesAnt, 
                      BalanzaDeComprobacionAnterior.Year AS A?oAnt,1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      @Tmp_BalanzaDeComprobacionAnterior BalanzaDeComprobacionAnterior ON 
                      dbo.C_Contable.IdCuentaContable = BalanzaDeComprobacionAnterior.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND 
                      ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '0') AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '4') AND 
                      (LEN(REPLACE(REPLACE(dbo.C_Contable.NumeroCuenta, '0', ''), '-', '')) = 1) AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) AND (dbo.T_SaldosInicialesCont.Year = @A?o)
ORDER BY dbo.C_Contable.NumeroCuenta



select @SSaldo = dbo.Saldo_Cuenta('40000-00000',@Mes,@A?o)
if @SSaldo =0 begin select @SSaldo = dbo.Saldo_Cuenta('40000-000000',@Mes,@A?o)end
select @SSaldoAnt = dbo.Saldo_Cuenta('40000-00000',@Mes,@A?o-1)
if @SSaldoAnt =0 begin select @SSaldoAnt= dbo.Saldo_Cuenta('40000-000000',@Mes,@A?o-1)end
select @SSaldo5 = dbo.Saldo_Cuenta('50000-00000',@Mes,@A?o)
if @SSaldo5 =0 begin select @SSaldo5= dbo.Saldo_Cuenta('50000-000000',@Mes,@A?o) end
select @SSaldoAnt5 = dbo.Saldo_Cuenta('50000-00000' ,@Mes , @A?o-1)
if @SSaldoAnt5 =0 begin select @SSaldoAnt5 = dbo.Saldo_Cuenta('50000-000000' ,@Mes , @A?o-1)end

select  @Var11610 =dbo.Saldo_Cuenta('11610-00000',@Mes,@A?o)
if @Var11610 =0 begin select @Var11610 = dbo.Saldo_Cuenta('11610-000000',@Mes,@A?o)end
select @Var11620 =dbo.Saldo_Cuenta('11620-00000',@Mes,@A?o)
if @Var11620 =0 begin select @Var11620 = dbo.Saldo_Cuenta('11620-000000',@Mes,@A?o)end
select @Var11621 =dbo.Saldo_Cuenta('11621-00000',@Mes,@A?o)
if @Var11621 =0 begin select @Var11621 = dbo.Saldo_Cuenta('11621-000000',@Mes,@A?o)end
select @Var11622=dbo.Saldo_Cuenta('11622-00000',@Mes,@A?o)
if @Var11622 =0 begin select @Var11622 = dbo.Saldo_Cuenta('11622-000000',@Mes,@A?o)end
select @Var11623 = dbo.Saldo_Cuenta('11623-00000',@Mes,@A?o)
if @Var11623 =0 begin select @Var11623 = dbo.Saldo_Cuenta('11623-000000',@Mes,@A?o)end
select @Var11624=dbo.Saldo_Cuenta('11624-00000',@Mes,@A?o)
if @Var11624 =0 begin select @Var11624 = dbo.Saldo_Cuenta('11624-000000',@Mes,@A?o)end
select @Var11625 = dbo.Saldo_Cuenta('11625-00000',@Mes,@A?o)
if @Var11625 =0 begin select @Var11625 = dbo.Saldo_Cuenta('11625-000000',@Mes,@A?o)end
select @Var12810 = dbo.Saldo_Cuenta('12810-00000',@Mes,@A?o)
if @Var12810 =0 begin select @Var12810 = dbo.Saldo_Cuenta('12810-000000',@Mes,@A?o)end
select @Var12820=dbo.Saldo_Cuenta('12820-00000',@Mes,@A?o)
if @Var12820 =0 begin select @Var12820 = dbo.Saldo_Cuenta('12820-000000',@Mes,@A?o)end
select @Var12830=dbo.Saldo_Cuenta('12830-00000',@Mes,@A?o)
if @Var12830 =0 begin select @Var12830 = dbo.Saldo_Cuenta('12830-000000',@Mes,@A?o)end
select @Var12840 = dbo.Saldo_Cuenta('12840-00000',@Mes,@A?o)
if @Var12840 =0 begin select @Var12840 = dbo.Saldo_Cuenta('12840-000000',@Mes,@A?o)end
select @Var12890 = dbo.Saldo_Cuenta('12890-00000',@Mes,@A?o)
if @Var12890 =0 begin select @Var12890 = dbo.Saldo_Cuenta('12890-000000',@Mes,@A?o)end
select @Var12600_00000 = dbo.Saldo_Cuenta('12600-00000',@Mes,@A?o)
if @Var12600_00000 =0 begin select @Var12600_00000 = dbo.Saldo_Cuenta('12600-000000',@Mes,@A?o)end
select @Var12610_00000 = dbo.Saldo_Cuenta('12610-00000',@Mes,@A?o)
if @Var12610_00000 =0 begin select @Var12610_00000 = dbo.Saldo_Cuenta('12610-000000',@Mes,@A?o)end
select @Var12610_01000 = dbo.Saldo_Cuenta('12610-01000',@Mes,@A?o)
if @Var12610_01000 =0 begin select @Var12610_01000 = dbo.Saldo_Cuenta('12610-010000',@Mes,@A?o)end
select @Var12610_02000 = dbo.Saldo_Cuenta('12610-02000',@Mes,@A?o)
if @Var12610_02000 =0 begin select @Var12610_02000 = dbo.Saldo_Cuenta('12610-020000',@Mes,@A?o)end
select @Var12610_03000 = dbo.Saldo_Cuenta('12610-03000',@Mes,@A?o)
if @Var12610_03000 =0 begin select @Var12610_03000 = dbo.Saldo_Cuenta('12610-030000',@Mes,@A?o)end 
select @Var12610_04000 = dbo.Saldo_Cuenta('12610-04000',@Mes,@A?o) 
if @Var12610_04000 =0 begin select @Var12610_04000 = dbo.Saldo_Cuenta('12610-040000',@Mes,@A?o)end
select @Var12620_00000 = dbo.Saldo_Cuenta('12620-00000',@Mes,@A?o)
if @Var12620_00000 =0 begin select @Var12620_00000 = dbo.Saldo_Cuenta('12620-000000',@Mes,@A?o)end
select @Var12630 = dbo.Saldo_Cuenta('12630-00000',@Mes,@A?o)

select @Var12630_01000  = dbo.Saldo_Cuenta('12630-01000',@Mes,@A?o)
if @Var12630_01000  =0 begin select @Var12630_01000  = dbo.Saldo_Cuenta('12630-010000',@Mes,@A?o)end
select @Var12630_02000  = dbo.Saldo_Cuenta('12630-02000',@Mes,@A?o)
if @Var12630_02000  =0 begin select @Var12630_02000  = dbo.Saldo_Cuenta('12630-020000',@Mes,@A?o)end
select @Var12630_03000  = dbo.Saldo_Cuenta('12630-03000',@Mes,@A?o)
if @Var12630_03000  =0 begin select @Var12630_03000  = dbo.Saldo_Cuenta('12630-030000',@Mes,@A?o)end
select @Var12630_04000  = dbo.Saldo_Cuenta('12630-04000',@Mes,@A?o)
if @Var12630_04000  =0 begin select @Var12630_04000  = dbo.Saldo_Cuenta('12630-040000',@Mes,@A?o)end
select @Var12630_05000  = dbo.Saldo_Cuenta('12630-05000',@Mes,@A?o)
if @Var12630_05000  =0 begin select @Var12630_05000  = dbo.Saldo_Cuenta('12630-050000',@Mes,@A?o)end
select @Var12630_06000  = dbo.Saldo_Cuenta('12630-06000',@Mes,@A?o)
if @Var12630_06000  =0 begin select @Var12630_06000  = dbo.Saldo_Cuenta('12630-060000',@Mes,@A?o)end
select @Var12630_07000  = dbo.Saldo_Cuenta('12630-07000',@Mes,@A?o)
if @Var12630_07000  =0 begin select @Var12630_07000  = dbo.Saldo_Cuenta('12630-070000',@Mes,@A?o)end
select @Var12630_08000  = dbo.Saldo_Cuenta('12630-08000',@Mes,@A?o)
if @Var12630_08000  =0 begin select @Var12630_08000  = dbo.Saldo_Cuenta('12630-080000',@Mes,@A?o)end
select @Var12630_09000  = dbo.Saldo_Cuenta('12630-09000',@Mes,@A?o)
if @Var12630_09000  =0 begin select @Var12630_09000  = dbo.Saldo_Cuenta('12630-090000',@Mes,@A?o)end
select @Var12630_10000  = dbo.Saldo_Cuenta('12630-10000',@Mes,@A?o)
if @Var12630_10000  =0 begin select @Var12630_10000  = dbo.Saldo_Cuenta('12630-100000',@Mes,@A?o)end
select @Var12630_11000  = dbo.Saldo_Cuenta('12630-11000',@Mes,@A?o)
if @Var12630_11000  =0 begin select @Var12630_11000  = dbo.Saldo_Cuenta('12630-110000',@Mes,@A?o)end
select @Var12630_12000  = dbo.Saldo_Cuenta('12630-12000',@Mes,@A?o)
if @Var12630_12000  =0 begin select @Var12630_12000  = dbo.Saldo_Cuenta('12630-120000',@Mes,@A?o)end
select @Var12630_13000  = dbo.Saldo_Cuenta('12630-13000',@Mes,@A?o)
if @Var12630_13000  =0 begin select @Var12630_13000  = dbo.Saldo_Cuenta('12630-130000',@Mes,@A?o)end
select @Var12630_14000  = dbo.Saldo_Cuenta('12630-14000',@Mes,@A?o)
if @Var12630_14000  =0 begin select @Var12630_14000  = dbo.Saldo_Cuenta('12630-140000',@Mes,@A?o)end
select @Var12630_15000  = dbo.Saldo_Cuenta('12630-15000',@Mes,@A?o)
if @Var12630_15000  =0 begin select @Var12630_15000  = dbo.Saldo_Cuenta('12630-150000',@Mes,@A?o)end
select @Var12630_16000  = dbo.Saldo_Cuenta('12630-16000',@Mes,@A?o)
if @Var12630_16000  =0 begin select @Var12630_16000  = dbo.Saldo_Cuenta('12630-160000',@Mes,@A?o)end
select @Var12630_17000  = dbo.Saldo_Cuenta('12630-17000',@Mes,@A?o)
if @Var12630_17000  =0 begin select @Var12630_17000  = dbo.Saldo_Cuenta('12630-170000',@Mes,@A?o)end
select @Var12630_18000  = dbo.Saldo_Cuenta('12630-18000',@Mes,@A?o)
if @Var12630_18000  =0 begin select @Var12630_18000  = dbo.Saldo_Cuenta('12630-180000',@Mes,@A?o)end
select @Var12630_19000  = dbo.Saldo_Cuenta('12630-19000',@Mes,@A?o)
if @Var12630_19000  =0 begin select @Var12630_19000  = dbo.Saldo_Cuenta('12630-190000',@Mes,@A?o)end
select @Var12630_20000  = dbo.Saldo_Cuenta('12630-20000',@Mes,@A?o)
if @Var12630_20000  =0 begin select @Var12630_20000  = dbo.Saldo_Cuenta('12630-200000',@Mes,@A?o)end
select @Var12630_21000  = dbo.Saldo_Cuenta('12630-21000',@Mes,@A?o)
if @Var12630_21000  =0 begin select @Var12630_21000  = dbo.Saldo_Cuenta('12630-210000',@Mes,@A?o)end
select @Var12630_22000  = dbo.Saldo_Cuenta('12630-22000',@Mes,@A?o)
if @Var12630_22000  =0 begin select @Var12630_22000  = dbo.Saldo_Cuenta('12630-220000',@Mes,@A?o)end
select @Var12630_23000  = dbo.Saldo_Cuenta('12630-23000',@Mes,@A?o)
if @Var12630_23000  =0 begin select @Var12630_23000  = dbo.Saldo_Cuenta('12630-230000',@Mes,@A?o)end
select @Var12630_24000  = dbo.Saldo_Cuenta('12630-24000',@Mes,@A?o)
if @Var12630_24000  =0 begin select @Var12630_24000  = dbo.Saldo_Cuenta('12630-240000',@Mes,@A?o)end
select @Var12630_25000  = dbo.Saldo_Cuenta('12630-25000',@Mes,@A?o)
if @Var12630_25000  =0 begin select @Var12630_25000  = dbo.Saldo_Cuenta('12630-250000',@Mes,@A?o)end

if @Var12630 =0 begin select @Var12630 = dbo.Saldo_Cuenta('12630-000000',@Mes,@A?o)end
select @Var12640_00000 = dbo.Saldo_Cuenta('12640-00000',@Mes,@A?o) 
if @Var12640_00000 =0 begin select @Var12640_00000 = dbo.Saldo_Cuenta('12640-000000',@Mes,@A?o)end

select @Var12640_01000 = dbo.Saldo_Cuenta('12640-01000',@Mes,@A?o) 
if @Var12640_01000 =0 begin select @Var12640_01000 = dbo.Saldo_Cuenta('12640-010000',@Mes,@A?o)end
select @Var12640_02000 = dbo.Saldo_Cuenta('12640-02000',@Mes,@A?o) 
if @Var12640_02000 =0 begin select @Var12640_02000 = dbo.Saldo_Cuenta('12640-020000',@Mes,@A?o)end
select @Var12640_03000 = dbo.Saldo_Cuenta('12640-03000',@Mes,@A?o) 
if @Var12640_03000 =0 begin select @Var12640_03000 = dbo.Saldo_Cuenta('12640-030000',@Mes,@A?o)end
select @Var12640_04000 = dbo.Saldo_Cuenta('12640-04000',@Mes,@A?o) 
if @Var12640_04000 =0 begin select @Var12640_04000 = dbo.Saldo_Cuenta('12640-040000',@Mes,@A?o)end
select @Var12640_05000 = dbo.Saldo_Cuenta('12640-05000',@Mes,@A?o) 
if @Var12640_05000 =0 begin select @Var12640_05000 = dbo.Saldo_Cuenta('12640-050000',@Mes,@A?o)end
select @Var12640_06000 = dbo.Saldo_Cuenta('12640-06000',@Mes,@A?o) 
if @Var12640_06000 =0 begin select @Var12640_06000 = dbo.Saldo_Cuenta('12640-060000',@Mes,@A?o)end
select @Var12640_07000 = dbo.Saldo_Cuenta('12640-07000',@Mes,@A?o) 
if @Var12640_07000 =0 begin select @Var12640_07000 = dbo.Saldo_Cuenta('12640-070000',@Mes,@A?o)end
select @Var12640_08000 = dbo.Saldo_Cuenta('12640-08000',@Mes,@A?o) 
if @Var12640_08000 =0 begin select @Var12640_08000 = dbo.Saldo_Cuenta('12640-080000',@Mes,@A?o)end
select @Var12640_09000 = dbo.Saldo_Cuenta('12640-09000',@Mes,@A?o) 
if @Var12640_09000 =0 begin select @Var12640_09000 = dbo.Saldo_Cuenta('12640-090000',@Mes,@A?o)end

select @Var12650 = dbo.Saldo_Cuenta('12650-00000',@Mes,@A?o)
if @Var12650 =0 begin select @Var12650 = dbo.Saldo_Cuenta('12650-000000',@Mes,@A?o)end

select @Var12650_01000 = dbo.Saldo_Cuenta('12650-01000',@Mes,@A?o) 
if @Var12650_01000 =0 begin select @Var12650_01000 = dbo.Saldo_Cuenta('12650-010000',@Mes,@A?o)end
select @Var12650_02000 = dbo.Saldo_Cuenta('12650-02000',@Mes,@A?o) 
if @Var12650_02000 =0 begin select @Var12650_02000 = dbo.Saldo_Cuenta('12650-020000',@Mes,@A?o)end
select @Var12650_03000 = dbo.Saldo_Cuenta('12650-03000',@Mes,@A?o) 
if @Var12650_03000 =0 begin select @Var12650_03000 = dbo.Saldo_Cuenta('12650-030000',@Mes,@A?o)end
select @Var12650_04000 = dbo.Saldo_Cuenta('12650-04000',@Mes,@A?o) 
if @Var12650_04000 =0 begin select @Var12650_04000 = dbo.Saldo_Cuenta('12650-040000',@Mes,@A?o)end
select @Var12650_05000 = dbo.Saldo_Cuenta('12650-05000',@Mes,@A?o) 
if @Var12650_05000 =0 begin select @Var12650_05000 = dbo.Saldo_Cuenta('12650-050000',@Mes,@A?o)end
select @Var12650_06000 = dbo.Saldo_Cuenta('12650-06000',@Mes,@A?o) 
if @Var12650_06000 =0 begin select @Var12650_06000 = dbo.Saldo_Cuenta('12650-060000',@Mes,@A?o)end
select @Var12650_07000 = dbo.Saldo_Cuenta('12650-07000',@Mes,@A?o) 
if @Var12650_07000 =0 begin select @Var12650_07000 = dbo.Saldo_Cuenta('12650-070000',@Mes,@A?o)end
select @Var12650_08000 = dbo.Saldo_Cuenta('12650-08000',@Mes,@A?o) 
if @Var12650_08000 =0 begin select @Var12650_08000 = dbo.Saldo_Cuenta('12650-080000',@Mes,@A?o)end
select @Var12650_09000 = dbo.Saldo_Cuenta('12650-09000',@Mes,@A?o) 
if @Var12650_09000 =0 begin select @Var12650_09000 = dbo.Saldo_Cuenta('12650-090000',@Mes,@A?o)end
	
select @Var22310 = dbo.Saldo_Cuenta('22310-00000',@Mes,@A?o)
if @Var22310 =0 begin select @Var22310 = dbo.Saldo_Cuenta('22310-000000',@Mes,@A?o)end
select @Var22320 = dbo.Saldo_Cuenta('22320-00000',@Mes,@A?o)
if @Var22320 =0 begin select @Var22320 = dbo.Saldo_Cuenta('22320-000000',@Mes,@A?o)end


select @Var11610Ant =dbo.Saldo_Cuenta('11610-00000',@Mes,@A?o-1)
if @Var11610Ant =0 begin select @Var11610Ant = dbo.Saldo_Cuenta('11610-000000',@Mes,@A?o-1) End
select @Var11620Ant =dbo.Saldo_Cuenta('11620-00000',@Mes,@A?o-1)
if @Var11620Ant =0 begin select @Var11620Ant = dbo.Saldo_Cuenta('11620-000000',@Mes,@A?o-1) End
select @Var11621Ant =dbo.Saldo_Cuenta('11621-00000',@Mes,@A?o-1)
if @Var11621Ant =0 begin select @Var11621Ant = dbo.Saldo_Cuenta('11621-000000',@Mes,@A?o-1) End
select @Var11622Ant=dbo.Saldo_Cuenta('11622-00000',@Mes,@A?o-1)
if @Var11622Ant =0 begin select @Var11622Ant = dbo.Saldo_Cuenta('11622-000000',@Mes,@A?o-1) End
select @Var11623Ant = dbo.Saldo_Cuenta('11623-00000',@Mes,@A?o-1)
if @Var11623Ant =0 begin select @Var11623Ant = dbo.Saldo_Cuenta('11623-000000',@Mes,@A?o-1) End
select @Var11624Ant=dbo.Saldo_Cuenta('11624-00000',@Mes,@A?o-1)
if @Var11624Ant =0 begin select @Var11624Ant = dbo.Saldo_Cuenta('11624-000000',@Mes,@A?o-1) End
select @Var11625Ant = dbo.Saldo_Cuenta('11625-00000',@Mes,@A?o-1)
if @Var11625Ant =0 begin select @Var11625Ant = dbo.Saldo_Cuenta('11625-000000',@Mes,@A?o-1) End
select @Var12810Ant = dbo.Saldo_Cuenta('12810-00000',@Mes,@A?o-1)
if @Var12810Ant =0 begin select @Var12810Ant = dbo.Saldo_Cuenta('12810-000000',@Mes,@A?o-1) End
select @Var12820Ant=dbo.Saldo_Cuenta('12820-00000',@Mes,@A?o-1)
if @Var12820Ant =0 begin select @Var12820Ant = dbo.Saldo_Cuenta('12820-000000',@Mes,@A?o-1) End
select @Var12830Ant=dbo.Saldo_Cuenta('12830-00000',@Mes,@A?o-1)
if @Var12830Ant =0 begin select @Var12830Ant = dbo.Saldo_Cuenta('12830-000000',@Mes,@A?o-1) End
select @Var12840Ant = dbo.Saldo_Cuenta('12840-00000',@Mes,@A?o-1)
if @Var12840Ant =0 begin select @Var12840Ant = dbo.Saldo_Cuenta('12840-000000',@Mes,@A?o-1) End
select @Var12890Ant = dbo.Saldo_Cuenta('12890-00000',@Mes,@A?o-1)
if @Var12890Ant =0 begin select @Var12890Ant = dbo.Saldo_Cuenta('12890-000000',@Mes,@A?o-1) End
select @Var12600_00000Ant = dbo.Saldo_Cuenta('12600-00000',@Mes,@A?o-1)
if @Var12600_00000Ant =0 begin select @Var12600_00000Ant = dbo.Saldo_Cuenta('12600-000000',@Mes,@A?o)end
select @Var12610_00000Ant = dbo.Saldo_Cuenta('12610-00000',@Mes,@A?o-1)
if @Var12610_00000Ant =0 begin select @Var12610_00000Ant = dbo.Saldo_Cuenta('12610-000000',@Mes,@A?o)end

select @Var12610_01000Ant = dbo.Saldo_Cuenta('12610-01000',@Mes,@A?o-1)
if @Var12610_01000Ant =0 begin select @Var12610_01000Ant = dbo.Saldo_Cuenta('12610-010000',@Mes,@A?o-1) End
select @Var12610_02000Ant = dbo.Saldo_Cuenta('12610-02000',@Mes,@A?o-1)
if @Var12610_02000Ant =0 begin select @Var12610_02000Ant = dbo.Saldo_Cuenta('12610-020000',@Mes,@A?o-1) End 
select @Var12610_03000Ant = dbo.Saldo_Cuenta('12610-03000',@Mes,@A?o-1)
if @Var12610_03000Ant =0 begin select @Var12610_03000Ant = dbo.Saldo_Cuenta('12610-030000',@Mes,@A?o-1) End 
select @Var12610_04000Ant = dbo.Saldo_Cuenta('12610-04000',@Mes,@A?o-1)
if @Var12610_04000Ant =0 begin select @Var12610_04000Ant = dbo.Saldo_Cuenta('12610-040000',@Mes,@A?o-1) End 

select @Var12620_00000Ant = dbo.Saldo_Cuenta('12620-00000',@Mes,@A?o-1)
if @Var12620_00000Ant =0 begin select @Var12620_00000Ant = dbo.Saldo_Cuenta('12620-000000',@Mes,@A?o-1) End 
select @Var12630Ant = dbo.Saldo_Cuenta('12630-00000',@Mes,@A?o-1)
if @Var12630Ant =0 begin select @Var12630Ant = dbo.Saldo_Cuenta('12630-000000',@Mes,@A?o-1) End

select @Var12630_01000Ant  = dbo.Saldo_Cuenta('12630-01000',@Mes,@A?o-1)
if @Var12630_01000Ant  =0 begin select @Var12630_01000Ant  = dbo.Saldo_Cuenta('12630-010000',@Mes,@A?o)end
select @Var12630_02000Ant  = dbo.Saldo_Cuenta('12630-02000',@Mes,@A?o-1)
if @Var12630_02000Ant  =0 begin select @Var12630_02000Ant  = dbo.Saldo_Cuenta('12630-020000',@Mes,@A?o)end
select @Var12630_03000Ant  = dbo.Saldo_Cuenta('12630-03000',@Mes,@A?o-1)
if @Var12630_03000Ant  =0 begin select @Var12630_03000Ant  = dbo.Saldo_Cuenta('12630-030000',@Mes,@A?o)end
select @Var12630_04000Ant  = dbo.Saldo_Cuenta('12630-04000',@Mes,@A?o-1)
if @Var12630_04000Ant  =0 begin select @Var12630_04000Ant  = dbo.Saldo_Cuenta('12630-040000',@Mes,@A?o)end
select @Var12630_05000Ant  = dbo.Saldo_Cuenta('12630-05000',@Mes,@A?o-1)
if @Var12630_05000Ant  =0 begin select @Var12630_05000Ant  = dbo.Saldo_Cuenta('12630-050000',@Mes,@A?o)end
select @Var12630_06000Ant  = dbo.Saldo_Cuenta('12630-06000',@Mes,@A?o-1)
if @Var12630_06000Ant  =0 begin select @Var12630_06000Ant  = dbo.Saldo_Cuenta('12630-060000',@Mes,@A?o)end
select @Var12630_07000Ant  = dbo.Saldo_Cuenta('12630-07000',@Mes,@A?o-1)
if @Var12630_07000Ant  =0 begin select @Var12630_07000Ant  = dbo.Saldo_Cuenta('12630-070000',@Mes,@A?o)end
select @Var12630_08000Ant  = dbo.Saldo_Cuenta('12630-08000',@Mes,@A?o-1)
if @Var12630_08000Ant  =0 begin select @Var12630_08000Ant  = dbo.Saldo_Cuenta('12630-080000',@Mes,@A?o)end
select @Var12630_09000Ant  = dbo.Saldo_Cuenta('12630-09000',@Mes,@A?o-1)
if @Var12630_09000Ant  =0 begin select @Var12630_09000Ant  = dbo.Saldo_Cuenta('12630-090000',@Mes,@A?o)end
select @Var12630_10000Ant  = dbo.Saldo_Cuenta('12630-10000',@Mes,@A?o-1)
if @Var12630_10000Ant  =0 begin select @Var12630_10000Ant  = dbo.Saldo_Cuenta('12630-100000',@Mes,@A?o)end
select @Var12630_11000Ant  = dbo.Saldo_Cuenta('12630-11000',@Mes,@A?o-1)
if @Var12630_11000Ant  =0 begin select @Var12630_11000Ant  = dbo.Saldo_Cuenta('12630-110000',@Mes,@A?o)end
select @Var12630_12000Ant  = dbo.Saldo_Cuenta('12630-12000',@Mes,@A?o-1)
if @Var12630_12000Ant  =0 begin select @Var12630_12000Ant  = dbo.Saldo_Cuenta('12630-120000',@Mes,@A?o)end
select @Var12630_13000Ant  = dbo.Saldo_Cuenta('12630-13000',@Mes,@A?o-1)
if @Var12630_13000Ant  =0 begin select @Var12630_13000Ant  = dbo.Saldo_Cuenta('12630-130000',@Mes,@A?o)end
select @Var12630_14000Ant  = dbo.Saldo_Cuenta('12630-14000',@Mes,@A?o-1)
if @Var12630_14000Ant  =0 begin select @Var12630_14000Ant  = dbo.Saldo_Cuenta('12630-140000',@Mes,@A?o)end
select @Var12630_15000Ant  = dbo.Saldo_Cuenta('12630-15000',@Mes,@A?o-1)
if @Var12630_15000Ant  =0 begin select @Var12630_15000Ant  = dbo.Saldo_Cuenta('12630-150000',@Mes,@A?o)end
select @Var12630_16000Ant  = dbo.Saldo_Cuenta('12630-16000',@Mes,@A?o-1)
if @Var12630_16000Ant  =0 begin select @Var12630_16000Ant  = dbo.Saldo_Cuenta('12630-160000',@Mes,@A?o)end
select @Var12630_17000Ant  = dbo.Saldo_Cuenta('12630-17000',@Mes,@A?o-1)
if @Var12630_17000Ant  =0 begin select @Var12630_17000Ant  = dbo.Saldo_Cuenta('12630-170000',@Mes,@A?o)end
select @Var12630_18000Ant  = dbo.Saldo_Cuenta('12630-18000',@Mes,@A?o-1)
if @Var12630_18000Ant  =0 begin select @Var12630_18000Ant  = dbo.Saldo_Cuenta('12630-180000',@Mes,@A?o)end
select @Var12630_19000Ant  = dbo.Saldo_Cuenta('12630-19000',@Mes,@A?o-1)
if @Var12630_19000Ant  =0 begin select @Var12630_19000Ant  = dbo.Saldo_Cuenta('12630-190000',@Mes,@A?o)end
select @Var12630_20000Ant  = dbo.Saldo_Cuenta('12630-20000',@Mes,@A?o-1)
if @Var12630_20000Ant  =0 begin select @Var12630_20000Ant  = dbo.Saldo_Cuenta('12630-200000',@Mes,@A?o)end
select @Var12630_21000Ant  = dbo.Saldo_Cuenta('12630-21000',@Mes,@A?o-1)
if @Var12630_21000Ant  =0 begin select @Var12630_21000Ant  = dbo.Saldo_Cuenta('12630-210000',@Mes,@A?o)end
select @Var12630_22000Ant  = dbo.Saldo_Cuenta('12630-22000',@Mes,@A?o-1)
if @Var12630_22000Ant  =0 begin select @Var12630_22000Ant  = dbo.Saldo_Cuenta('12630-220000',@Mes,@A?o)end
select @Var12630_23000Ant  = dbo.Saldo_Cuenta('12630-23000',@Mes,@A?o-1)
if @Var12630_23000Ant  =0 begin select @Var12630_23000Ant  = dbo.Saldo_Cuenta('12630-230000',@Mes,@A?o)end
select @Var12630_24000Ant  = dbo.Saldo_Cuenta('12630-24000',@Mes,@A?o-1)
if @Var12630_24000Ant  =0 begin select @Var12630_24000Ant  = dbo.Saldo_Cuenta('12630-240000',@Mes,@A?o)end
select @Var12630_25000Ant  = dbo.Saldo_Cuenta('12630-25000',@Mes,@A?o-1)
if @Var12630_25000Ant  =0 begin select @Var12630_25000Ant  = dbo.Saldo_Cuenta('12630-250000',@Mes,@A?o)end

select @Var12640_00000Ant = dbo.Saldo_Cuenta('12640-00000',@Mes,@A?o-1)
if @Var12640_00000Ant =0 begin select @Var12640_00000Ant = dbo.Saldo_Cuenta('12640-000000',@Mes,@A?o-1) End 

select @Var12640_01000Ant = dbo.Saldo_Cuenta('12640-01000',@Mes,@A?o-1) 
if @Var12640_01000Ant =0 begin select @Var12640_01000Ant = dbo.Saldo_Cuenta('12640-010000',@Mes,@A?o)end
select @Var12640_02000Ant = dbo.Saldo_Cuenta('12640-02000',@Mes,@A?o-1) 
if @Var12640_02000Ant =0 begin select @Var12640_02000Ant = dbo.Saldo_Cuenta('12640-020000',@Mes,@A?o)end
select @Var12640_03000Ant = dbo.Saldo_Cuenta('12640-03000',@Mes,@A?o-1) 
if @Var12640_03000Ant =0 begin select @Var12640_03000Ant = dbo.Saldo_Cuenta('12640-030000',@Mes,@A?o)end
select @Var12640_04000Ant = dbo.Saldo_Cuenta('12640-04000',@Mes,@A?o-1) 
if @Var12640_04000Ant =0 begin select @Var12640_04000Ant = dbo.Saldo_Cuenta('12640-040000',@Mes,@A?o)end
select @Var12640_05000Ant = dbo.Saldo_Cuenta('12640-05000',@Mes,@A?o-1) 
if @Var12640_05000Ant =0 begin select @Var12640_05000Ant = dbo.Saldo_Cuenta('12640-050000',@Mes,@A?o)end
select @Var12640_06000Ant = dbo.Saldo_Cuenta('12640-06000',@Mes,@A?o-1) 
if @Var12640_06000Ant =0 begin select @Var12640_06000Ant = dbo.Saldo_Cuenta('12640-060000',@Mes,@A?o)end
select @Var12640_07000Ant = dbo.Saldo_Cuenta('12640-07000',@Mes,@A?o-1) 
if @Var12640_07000Ant =0 begin select @Var12640_07000Ant = dbo.Saldo_Cuenta('12640-070000',@Mes,@A?o)end
select @Var12640_08000Ant = dbo.Saldo_Cuenta('12640-08000',@Mes,@A?o-1) 
if @Var12640_08000Ant =0 begin select @Var12640_08000Ant = dbo.Saldo_Cuenta('12640-080000',@Mes,@A?o)end
select @Var12640_09000Ant = dbo.Saldo_Cuenta('12640-09000',@Mes,@A?o-1) 
if @Var12640_09000Ant =0 begin select @Var12640_09000Ant = dbo.Saldo_Cuenta('12640-090000',@Mes,@A?o)end

select @Var12650Ant = dbo.Saldo_Cuenta('12650-00000',@Mes,@A?o-1)
if @Var12650Ant =0 begin select @Var12650Ant = dbo.Saldo_Cuenta('12650-000000',@Mes,@A?o-1) End

select @Var12650_01000Ant = dbo.Saldo_Cuenta('12650-01000',@Mes,@A?o-1) 
if @Var12650_01000Ant =0 begin select @Var12650_01000Ant = dbo.Saldo_Cuenta('12650-010000',@Mes,@A?o)end
select @Var12650_02000Ant = dbo.Saldo_Cuenta('12650-02000',@Mes,@A?o-1) 
if @Var12650_02000Ant =0 begin select @Var12650_02000Ant = dbo.Saldo_Cuenta('12650-020000',@Mes,@A?o)end
select @Var12650_03000Ant = dbo.Saldo_Cuenta('12650-03000',@Mes,@A?o-1) 
if @Var12650_03000Ant =0 begin select @Var12650_03000Ant = dbo.Saldo_Cuenta('12650-030000',@Mes,@A?o)end
select @Var12650_04000Ant = dbo.Saldo_Cuenta('12650-04000',@Mes,@A?o-1) 
if @Var12650_04000Ant =0 begin select @Var12650_04000Ant = dbo.Saldo_Cuenta('12650-040000',@Mes,@A?o)end
select @Var12650_05000Ant = dbo.Saldo_Cuenta('12650-05000',@Mes,@A?o-1) 
if @Var12650_05000Ant =0 begin select @Var12650_05000Ant = dbo.Saldo_Cuenta('12650-050000',@Mes,@A?o)end
select @Var12650_06000Ant = dbo.Saldo_Cuenta('12650-06000',@Mes,@A?o-1) 
if @Var12650_06000Ant =0 begin select @Var12650_06000Ant = dbo.Saldo_Cuenta('12650-060000',@Mes,@A?o)end
select @Var12650_07000Ant = dbo.Saldo_Cuenta('12650-07000',@Mes,@A?o-1) 
if @Var12650_07000Ant =0 begin select @Var12650_07000Ant = dbo.Saldo_Cuenta('12650-070000',@Mes,@A?o)end
select @Var12650_08000Ant = dbo.Saldo_Cuenta('12650-08000',@Mes,@A?o-1) 
if @Var12650_08000Ant =0 begin select @Var12650_08000Ant = dbo.Saldo_Cuenta('12650-080000',@Mes,@A?o)end
select @Var12650_09000Ant = dbo.Saldo_Cuenta('12650-09000',@Mes,@A?o-1) 
if @Var12650_09000Ant =0 begin select @Var12650_09000Ant = dbo.Saldo_Cuenta('12650-090000',@Mes,@A?o)end
	
select @Var22310Ant = dbo.Saldo_Cuenta('22310-00000',@Mes,@A?o-1)
if @Var22310Ant =0 begin select @Var22310Ant = dbo.Saldo_Cuenta('22310-000000',@Mes,@A?o-1) End
select @Var22320Ant = dbo.Saldo_Cuenta('22320-00000',@Mes,@A?o-1)
if @Var22320Ant =0 begin select @Var22320Ant = dbo.Saldo_Cuenta('22320-000000',@Mes,@A?o-1) End



UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor= SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt= SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5 where MaskNumeroCuenta='32100'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='32000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor + @SSaldo - @SSaldo5 , SaldoAcreedorAnt=SaldoAcreedorAnt + @SSaldoAnt - @SSaldoAnt5  where MaskNumeroCuenta='30000'
--INICIAN UPDATES PARA LAS CUENTAS A MODIFICAR
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11220-00000' or NumeroCuenta = '11220-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11200-00000' or NumeroCuenta='11200-000000'--Misma afectacion a Cuenta padre

--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11610 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11610Ant  where NumeroCuenta='11220-00000' or NumeroCuenta = '11220-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11620 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11620Ant  where NumeroCuenta='11400-00000' or NumeroCuenta = '11400-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11621 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11621Ant  where NumeroCuenta='11410-00000' or NumeroCuenta = '11410-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11622 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11622Ant  where NumeroCuenta='11420-00000' or NumeroCuenta = '11420-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11623 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11623Ant  where NumeroCuenta='11430-00000' or NumeroCuenta = '11430-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11624 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11624Ant  where NumeroCuenta='11440-00000' or NumeroCuenta = '11440-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var11625 , SaldoDeudorAnt=SaldoDeudorAnt - @Var11625Ant  where NumeroCuenta='11450-00000' or NumeroCuenta = '11450-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12810 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12810Ant  where NumeroCuenta='12210-00000' or NumeroCuenta = '12210-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12820 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12820Ant  where NumeroCuenta='12220-00000' or NumeroCuenta = '12220-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12830 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12830Ant  where NumeroCuenta='12230-00000' or NumeroCuenta = '12230-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12840 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12840Ant  where NumeroCuenta='12240-00000' or NumeroCuenta = '12240-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12890 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12890Ant  where NumeroCuenta='12290-00000' or NumeroCuenta = '12290-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_01000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_01000Ant  where NumeroCuenta='12310-00000' or NumeroCuenta= '12310-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_02000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_02000Ant  where NumeroCuenta='12320-00000' or NumeroCuenta= '12320-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_03000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_03000Ant  where NumeroCuenta='12330-00000' or NumeroCuenta= '12330-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12620_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12620_00000Ant  where NumeroCuenta='12340-00000' or NumeroCuenta= '12340-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12610_04000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12610_04000Ant  where NumeroCuenta='12390-00000' or NumeroCuenta= '12390-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12610_01000+@Var12610_02000+@Var12610_03000+@Var12620_00000+@Var12610_04000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12610_01000Ant+@Var12610_02000Ant+@Var12610_03000Ant+@Var12620_00000Ant+@Var12610_04000Ant)  where NumeroCuenta='12300-00000' or NumeroCuenta= '12300-000000'--mimos movimientos a su cuenta padre

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630Ant)  where NumeroCuenta='12400-00000' or NumeroCuenta= '12400-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_01000+@Var12630_02000+@Var12630_03000+@Var12630_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_01000Ant+@Var12630_02000Ant+@Var12630_03000Ant+@Var12630_04000Ant)  where NumeroCuenta='12410-00000' or NumeroCuenta= '12410-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_05000+@Var12630_06000+@Var12630_07000+@Var12630_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_05000Ant+@Var12630_06000Ant+@Var12630_07000Ant+@Var12630_08000Ant)  where NumeroCuenta='12420-00000' or NumeroCuenta= '12420-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_09000+@Var12630_10000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_09000Ant+@Var12630_10000Ant)  where NumeroCuenta='12430-00000' or NumeroCuenta= '12430-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_11000+@Var12630_12000+@Var12630_13000+@Var12630_14000+@Var12630_15000+@Var12630_16000), SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_11000Ant+@Var12630_12000Ant+@Var12630_13000Ant+@Var12630_14000Ant+@Var12630_15000Ant+@Var12630_16000Ant)  where NumeroCuenta='12440-00000' or NumeroCuenta= '12440-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630_17000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630_17000Ant  where NumeroCuenta='12450-00000' or NumeroCuenta= '12450-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12630_18000+@Var12630_19000+@Var12630_20000+@Var12630_21000+@Var12630_22000+@Var12630_23000+@Var12630_24000+@Var12630_25000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12630_18000Ant+@Var12630_19000Ant+@Var12630_20000Ant+@Var12630_21000Ant+@Var12630_22000Ant+@Var12630_23000Ant+@Var12630_24000Ant+@Var12630_25000Ant)  where NumeroCuenta='12460-00000' or NumeroCuenta= '12460-000000'
--UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12630 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12630Ant  where NumeroCuenta='12470-00000' or NumeroCuenta= '12470-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12640_00000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12640_00000Ant  where NumeroCuenta='12480-00000' or NumeroCuenta= '12480-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650Ant  where NumeroCuenta='12500-00000' or NumeroCuenta= '12500-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_01000  , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_01000Ant  where NumeroCuenta='12510-00000' or NumeroCuenta= '12510-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_02000+@Var12650_03000+@Var12650_04000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_02000Ant+@Var12650_03000Ant+@Var12650_04000Ant)  where NumeroCuenta='12520-00000' or NumeroCuenta= '12520-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_05000+@Var12650_06000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_05000Ant+@Var12650_06000Ant)  where NumeroCuenta='12530-00000' or NumeroCuenta= '12530-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - (@Var12650_07000+@Var12650_08000) , SaldoDeudorAnt=SaldoDeudorAnt - (@Var12650_07000Ant+@Var12650_08000Ant)  where NumeroCuenta='12540-00000' or NumeroCuenta= '12540-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoDeudor=SaldoDeudor - @Var12650_09000 , SaldoDeudorAnt=SaldoDeudorAnt - @Var12650_09000  where NumeroCuenta='12590-00000' or NumeroCuenta= '12590-000000'

UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22310 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22310Ant  where NumeroCuenta='22330-00000' or NumeroCuenta = '22330-000000'
UPDATE @Tmp_BalanzaDeComprobacion Set SaldoAcreedor=SaldoAcreedor - @Var22320 , SaldoAcreedorAnt=SaldoAcreedorAnt - @Var22320Ant  where NumeroCuenta='22340-00000' or NumeroCuenta = '22340-000000'


SELECT     
SUM(SaldoDeudor/1000) AS SaldoDeudor, 
SUM(SaldoAcreedor/1000) AS SaldoAcreedor, 
ISNULL(SUM(SaldoDeudorAnt/1000),0) AS SaldoDeudorAnt, 
ISNULL(SUM(SaldoAcreedorAnt/1000),0) AS SaldoAcreedorAnt
FROM          @Tmp_BalanzaDeComprobacion


--FIN DE PROCEDIMIENTO

END

--//////////FIN REPORTE_Balanza_De_Comprobacion_Totalizado
GO

--//////////REPORTE_Estado_De_Actividades

/****** Object:  StoredProcedure [dbo].[REPORTE_Estado_De_Actividades]    Script Date: 10/08/2012 13:10:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[REPORTE_Estado_De_Actividades]

 @Mes int,
 @A?o int
 
AS
BEGIN
	
	Declare @Reporte int
	Declare @SSaldo decimal(15,2)
	Declare @SSaldoAnt Decimal(15,2)
	Declare @SSaldo5 decimal(15,2)
	Declare @SSaldoAnt5 decimal(15,2)
	Declare @433ACR decimal(15,2)
	Declare @433ACRAnt decimal(15,2)
	Declare @434ACR decimal(15,2)
	Declare @434ACRAnt decimal(15,2)
	Declare @551ACR decimal(15,2)
	Declare @551ACRAnt decimal(15,2)
	Declare @552ACR decimal(15,2)
	Declare @552ACRAnt decimal(15,2)
	Declare @554ACR decimal(15,2)
	Declare @554ACRAnt decimal(15,2)
	Declare @555ACR decimal(15,2)
	Declare @555ACRAnt decimal(15,2)

	Declare @433DEU decimal(15,2)
	Declare @433DEUAnt decimal(15,2)
	Declare @434DEU decimal(15,2)
	Declare @434DEUAnt decimal(15,2)
	Declare @551DEU decimal(15,2)
	Declare @551DEUAnt decimal(15,2)
	Declare @552DEU decimal(15,2)
	Declare @552DEUAnt decimal(15,2)
	Declare @554DEU decimal(15,2)
	Declare @554DEUAnt decimal(15,2)
	Declare @555DEU decimal(15,2)
	Declare @555DEUAnt decimal(15,2)
--PROCEDIMIENTO FINAL

Declare @Tmp_BalanzaDeComprobacion TABLE(NumeroCuenta varchar(max),NombreCuenta varchar(max),CargosSinFlujo decimal(15,2),AbonosSinFlujo decimal(15,2),TotalCargos decimal(15,2),TotalAbonos decimal(15,2),SaldoDeudor decimal(15,2),SaldoAcreedor decimal(15,2),TipoCuenta int,  MaskNumeroCuenta varchar(max),Total int, Mes int, Year int, MaskNombreCuenta varchar(max),NumeroCuentaAnt varchar(max), SaldoDeudorAnt decimal(15,2),SaldoAcreedorAnt decimal(15,2),MesAnt int,A?oAnt int,Agrupador int  )

INSERT INTO @Tmp_BalanzaDeComprobacion SELECT  TOP (100) PERCENT dbo.C_Contable.NumeroCuenta, dbo.C_Contable.NombreCuenta, dbo.T_SaldosInicialesCont.CargosSinFlujo, 
                      dbo.T_SaldosInicialesCont.AbonosSinFlujo, dbo.T_SaldosInicialesCont.TotalCargos, dbo.T_SaldosInicialesCont.TotalAbonos, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'C' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos
                       - TotalAbonos WHEN 'E' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos WHEN 'G' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos
                       WHEN 'I' THEN CargosSinFlujo - AbonosSinFlujo + TotalCargos - TotalAbonos ELSE 0 END AS SaldoDeudor, 
                      CASE C_Contable.TipoCuenta WHEN 'A' THEN 0 WHEN 'C' THEN 0 WHEN 'E' THEN 0 WHEN 'G' THEN 0 WHEN 'I' THEN 0 ELSE AbonosSinFlujo - CargosSinFlujo + TotalAbonos
                       - TotalCargos END AS SaldoAcreedor, LEFT(dbo.C_Contable.NumeroCuenta, 1) AS TipoCuenta, LEFT(dbo.C_Contable.NumeroCuenta, 5) AS MaskNumeroCuenta, 
                      LEN(LEFT(dbo.C_Contable.NumeroCuenta, 5)) - LEN(REPLACE(LEFT(dbo.C_Contable.NumeroCuenta, 5), 0, '')) AS Total, dbo.T_SaldosInicialesCont.Mes, 
                      dbo.T_SaldosInicialesCont.Year, dbo.FormatoCadena(dbo.C_Contable.NombreCuenta, dbo.C_Contable.NumeroCuenta) AS MaskNombreCuenta, 
                      RPT_Balanza_Comprobacio_Anterior_1.NumeroCuenta AS NumeroCuentaAnt, RPT_Balanza_Comprobacio_Anterior_1.SaldoDeudor AS SaldoDeudorAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.SaldoAcreedor AS SaldoAcreedorAnt, RPT_Balanza_Comprobacio_Anterior_1.Mes AS MesAnt, 
                      RPT_Balanza_Comprobacio_Anterior_1.Year AS A?oAnt, 1 as Agrupador 
FROM         dbo.C_Contable INNER JOIN
                      dbo.T_SaldosInicialesCont ON dbo.C_Contable.IdCuentaContable = dbo.T_SaldosInicialesCont.IdCuentaContable LEFT OUTER JOIN
                      dbo.RPT_Balanza_Comprobacio_Anterior(@Mes , @A?o - 1) AS RPT_Balanza_Comprobacio_Anterior_1 ON 
                      dbo.C_Contable.IdCuentaContable = RPT_Balanza_Comprobacio_Anterior_1.IdCuentaContable
WHERE     (dbo.C_Contable.TipoCuenta <> 'X') AND ((RIGHT(dbo.C_Contable.NumeroCuenta, 5) = '00000')OR (RIGHT(dbo.C_Contable.NumeroCuenta, 6) = '000000') ) AND (LEFT(dbo.C_Contable.NumeroCuenta, 1) > '3') AND 
                      (LEFT(dbo.C_Contable.NumeroCuenta, 1) < '6') AND  (dbo.T_SaldosInicialesCont.Mes = @Mes) AND (dbo.T_SaldosInicialesCont.Year = @A?o) 
ORDER BY dbo.C_Contable.NumeroCuenta
--Acreedor
Select @433ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43300')
Select @434ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43400')
select @551ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55100')
select @552ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55200')
select @554ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55400')
select @555ACR = (select top(1) saldoacreedor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55500')
--AcreedorAnt
Select @433ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43300')
Select @434ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43400')
select @551ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55100')
select @552ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55200')
select @554ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55400')
select @555ACRAnt = (select top(1) SaldoAcreedorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55500')
--Deudor
Select @433DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43300')
Select @434DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43400')
select @551DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55100')
select @552DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55200')
select @554DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55400')
select @555DEU = (select top(1) SaldoDeudor from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55500')
--DeudorAnt
Select @433DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43300')
Select @434DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='43400')
select @551DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55100')
select @552DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55200')
select @554DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55400')
select @555DEUAnt = (select top(1) SaldoDeudorAnt from @Tmp_BalanzaDeComprobacion where Mes= @Mes and Year = @A?o and MaskNumeroCuenta='55500')

UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta ='              DISMINUCI?N DEL EXCESO DE ESTIMACIONES POR P?RDIDA O DETERIORO U OBSOLESCENCIA Y PROVISIONES', saldoacreedor = saldoacreedor+@434ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@434ACRAnt,
	SaldoDeudor=SaldoDeudor+@434DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @434DEUAnt where MaskNumeroCuenta = '43300'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              ESTIMACIONES, DEPRECIACIONES, DETERIOROS, OBSOLESCENCIAS, AMORTIZACIONES Y PROVISIONES', saldoacreedor = saldoacreedor+@552ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@552ACRAnt,
	SaldoDeudor=SaldoDeudor+@552DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @552DEUAnt where MaskNumeroCuenta = '55100'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = '              AUMENTO POR INSUFICIENCIA DE ESTIMACIONES POR P?RDIDA, DETERIORO U OBSOLESCENCIA Y PROVISIONES',saldoacreedor = saldoacreedor+@554ACR, SaldoAcreedorAnt= SaldoAcreedorAnt+@554ACRAnt,
	SaldoDeudor=SaldoDeudor+@554DEU , SaldoDeudorAnt=SaldoDeudorAnt+ @554DEUAnt where MaskNumeroCuenta = '55400'
UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+'*' where MaskNumeroCuenta='41500'
--UPDATE @Tmp_BalanzaDeComprobacion set MaskNombreCuenta = MaskNombreCuenta+' [Resultado Integral de Financiamiento (RIF)]'where MaskNumeroCuenta='55900'
	
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '43400'
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '55200'
DELETE FROM  @Tmp_BalanzaDeComprobacion where MaskNumeroCuenta = '55500'

SELECT 
NumeroCuenta,
NombreCuenta,
(CargosSinFlujo/1000) as CargosSinFlujo,
(AbonosSinFlujo/1000) as AbonosSinFlujo,
(TotalCargos/1000) as TotalCargos,
(TotalAbonos/1000) as TotalAbonos,
(SaldoDeudor/1000) as SaldoDeudor,
(SaldoAcreedor/1000) as SaldoAcreedor,
TipoCuenta,  
MaskNumeroCuenta,
Total, 
Mes, 
Year, 
MaskNombreCuenta,
NumeroCuentaAnt, 
(SaldoDeudorAnt/1000) as SaldoDeudorAnt,
(SaldoAcreedorAnt/1000) as SaldoDeudorAnt,
MesAnt,
A?oAnt,
Agrupador
FROM @Tmp_BalanzaDeComprobacion
--FIN DE PROCEDIMIENTO

END

--//////////FIN REPORTE_Estado_De_Actividades

GO

EXEC SP_FirmasReporte 'Estado de actividades'
GO
EXEC SP_FirmasReporte 'Estado de situacion financiera'
GO