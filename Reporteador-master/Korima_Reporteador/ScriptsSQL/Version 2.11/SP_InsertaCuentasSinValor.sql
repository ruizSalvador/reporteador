/****** Object:  StoredProcedure [dbo].[SP_InsertaCuentasSinValor]    Script Date: 04/13/2015 17:57:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertaCuentasSinValor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_InsertaCuentasSinValor]
GO

/****** Object:  StoredProcedure [dbo].[SP_InsertaCuentasSinValor]    Script Date: 04/13/2015 17:57:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertaCuentasSinValor] (@Mes INT, @Ejercicio INT)
AS
 BEGIN
 --Variable de tabla temporal
   DECLARE @Tabla TABLE(IdCuenta INT)
   
   --Se insertan en la tabla temporal los id de cuentas contables no encontrados en el año de la fecha y el mes 13.
   INSERT INTO @Tabla 
   SELECT IdCuentaContable FROM  C_Contable 
   WHERE IdCuentaContable NOT IN (SELECT IdCuentaContable FROM T_SaldosInicialesCont WHERE [Year]=@Ejercicio AND Mes=@Mes)
   
   --Se Inserta en saldos iniciales los id de cuentas que no existian en el mes 13 y en el año de la fecha con valores en cero.
   INSERT INTO T_SaldosInicialesCont (IdCuentaContable,[Year],Mes,TotalCargos ,TotalAbonos ,CargosSinFlujo ,AbonosSinFlujo )
   SELECT T.IdCuenta,@ejercicio,@mes,0,0,0,0 FROM @Tabla T
 END
 
GO


