/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasBancariasProductivas]    Script Date: 08/05/2013 09:18:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_CuentasBancariasProductivas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_CuentasBancariasProductivas]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_CuentasBancariasProductivas]    Script Date: 08/05/2013 09:18:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_CuentasBancariasProductivas]
@Cheques bit,
@Inversion bit,
@Virtual bit,
@FondoRevolvente bit,
@Cancelada bit
AS BEGIN

Declare @tabla table(
Descripcion varchar(150),
NombreBanco varchar(30),
CuentaBancaria varchar(15),
Tipo varchar(100)
)
IF @Cheques=1 BEGIN
INSERT INTO @tabla 
SELECT 
C_FuenteFinanciamiento.DESCRIPCION,
C_Bancos.NombreBanco, 
C_CuentasBancarias.CuentaBancaria,
CASE 
WHEN ChequesInversion = 'A' THEN 'Cuenta Cheques' 
WHEN ChequesInversion = 'I' THEN 'Cuenta Inversión' 
WHEN ChequesInversion = 'V' THEN 'Cuenta Virtual' 
WHEN ChequesInversion = 'F' THEN 'Cuenta Fondo Revolvente' 
WHEN ChequesInversion = 'N' THEN 'Cuenta Cancelada' 
END AS Tipo
FROM C_FuenteFinanciamiento
JOIN C_CuentasBancarias
ON C_CuentasBancarias.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IdFuenteFinanciamiento
JOIN C_Bancos
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco 

WHERE ChequesInversion='A'
END--Cheques

IF @Inversion=1 BEGIN
INSERT INTO @tabla 
SELECT 
C_FuenteFinanciamiento.DESCRIPCION,
C_Bancos.NombreBanco, 
C_CuentasBancarias.CuentaBancaria,
CASE 
WHEN ChequesInversion = 'A' THEN 'Cuenta Cheques' 
WHEN ChequesInversion = 'I' THEN 'Cuenta Inversión' 
WHEN ChequesInversion = 'V' THEN 'Cuenta Virtual' 
WHEN ChequesInversion = 'F' THEN 'Cuenta Fondo Revolvente' 
WHEN ChequesInversion = 'N' THEN 'Cuenta Cancelada' 
END AS Tipo
FROM C_FuenteFinanciamiento
JOIN C_CuentasBancarias
ON C_CuentasBancarias.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IdFuenteFinanciamiento
JOIN C_Bancos
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco 

WHERE ChequesInversion='I'
END--Inversion

IF @Virtual=1 BEGIN
INSERT INTO @tabla 
SELECT 
C_FuenteFinanciamiento.DESCRIPCION,
C_Bancos.NombreBanco, 
C_CuentasBancarias.CuentaBancaria,
CASE 
WHEN ChequesInversion = 'A' THEN 'Cuenta Cheques' 
WHEN ChequesInversion = 'I' THEN 'Cuenta Inversión' 
WHEN ChequesInversion = 'V' THEN 'Cuenta Virtual' 
WHEN ChequesInversion = 'F' THEN 'Cuenta Fondo Revolvente' 
WHEN ChequesInversion = 'N' THEN 'Cuenta Cancelada' 
END AS Tipo
FROM C_FuenteFinanciamiento
JOIN C_CuentasBancarias
ON C_CuentasBancarias.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IdFuenteFinanciamiento
JOIN C_Bancos
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco 

WHERE ChequesInversion='V'
END--Virtual

IF @FondoRevolvente=1 BEGIN
INSERT INTO @tabla 
SELECT 
C_FuenteFinanciamiento.DESCRIPCION,
C_Bancos.NombreBanco, 
C_CuentasBancarias.CuentaBancaria,
CASE 
WHEN ChequesInversion = 'A' THEN 'Cuenta Cheques' 
WHEN ChequesInversion = 'I' THEN 'Cuenta Inversión' 
WHEN ChequesInversion = 'V' THEN 'Cuenta Virtual' 
WHEN ChequesInversion = 'F' THEN 'Cuenta Fondo Revolvente' 
WHEN ChequesInversion = 'N' THEN 'Cuenta Cancelada' 
END AS Tipo
FROM C_FuenteFinanciamiento
JOIN C_CuentasBancarias
ON C_CuentasBancarias.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IdFuenteFinanciamiento
JOIN C_Bancos
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco 

WHERE ChequesInversion='F'
END--FondoRevolvente

IF @Cancelada=1 BEGIN
INSERT INTO @tabla 
SELECT 
C_FuenteFinanciamiento.DESCRIPCION,
C_Bancos.NombreBanco, 
C_CuentasBancarias.CuentaBancaria,
CASE 
WHEN ChequesInversion = 'A' THEN 'Cuenta Cheques' 
WHEN ChequesInversion = 'I' THEN 'Cuenta Inversión' 
WHEN ChequesInversion = 'V' THEN 'Cuenta Virtual' 
WHEN ChequesInversion = 'F' THEN 'Cuenta Fondo Revolvente' 
WHEN ChequesInversion = 'N' THEN 'Cuenta Cancelada' 
END AS Tipo
FROM C_FuenteFinanciamiento
JOIN C_CuentasBancarias
ON C_CuentasBancarias.IdFuenteFinanciamiento=C_FuenteFinanciamiento.IdFuenteFinanciamiento
JOIN C_Bancos
ON C_Bancos.IdBanco=C_CuentasBancarias.IdBanco 

WHERE ChequesInversion='N'
END--Cancelada

SELECT * 
FROM @tabla 
ORDER BY NombreBanco,CuentaBancaria 

END
GO

EXEC SP_FirmasReporte 'Relación de cuentas bancarias productivas específicas'
GO
Exec SP_CFG_LogScripts 'SP_RPT_K2_CuentasBancariasProductivas'
GO


