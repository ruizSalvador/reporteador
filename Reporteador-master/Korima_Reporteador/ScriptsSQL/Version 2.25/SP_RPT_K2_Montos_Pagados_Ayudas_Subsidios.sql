
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios]    Script Date: 10/24/2013 12:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios]
GO

--Exec SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios 4,2016
CREATE PROCEDURE [dbo].[SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios]
@Trimestre int,
@Ejercicio Int
AS

DECLARE @Tabla Table(
ConceptoPago varchar(max), 
RazonSocial Varchar(max),
Notas1 Varchar(max),
Notas2 Varchar(max),
Notas3 Varchar(max),
Beneficiario Varchar(max),
CURP varchar(max),
RFC varchar(max), 
Importe decimal(15,2),
Sector varchar (20))

DECLARE @Tabla2 Table(
ConceptoPago varchar(max), 
RazonSocial Varchar(max),
Notas1 Varchar(max),
Notas2 Varchar(max),
Notas3 Varchar(max),
Beneficiario Varchar(max),
CURP varchar(max),
RFC varchar(max), 
Importe decimal(15,2),
Sector varchar (20))


DECLARE @MesInicio Int
DECLARE @MesFin Int

IF @Trimestre=1 BEGIN SET @MesInicio=1 SET @MesFin=3 END
IF @Trimestre=2 BEGIN SET @MesInicio=4 SET @MesFin=6 END
IF @Trimestre=3 BEGIN SET @MesInicio=7 SET @MesFin=9 END
IF @Trimestre=4 BEGIN SET @MesInicio=10 SET @MesFin=12 END

INSERT INTO @Tabla
SELECT	DISTINCT
C_PartidasPres.ClavePartida  + ' ' +  C_PartidasPres.DescripcionPartida,
C_Proveedores.RazonSocial as AyudaA,
''as Notas1,
''as Notas2,
''as Notas3,
--CONVERT(Nvarchar(max), Row_number() OVER(ORDER BY C_Proveedores.RazonSocial))+' Click aqui...'as Notas1,
--CONVERT(Nvarchar(max), Row_number() OVER(ORDER BY C_Proveedores.RazonSocial))+' Click aqui...'as Notas2,
T_Cheques.Beneficiario,
C_Proveedores.CURP,
C_Proveedores.RFC,
T_Solicitudcheques.Importe,
'' as Sector
FROM T_Cheques

--LEFT OUTER 
JOIN T_SolicitudCheques ON T_SolicitudCheques.IdSolicitudCheques =T_Cheques.IdSolicitudCheque 
--LEFT OUTER 
JOIN T_RecepcionFacturas ON T_RecepcionFacturas.IdRecepcionServicios=T_SolicitudCheques.IdRecepcionServicios 
JOIN D_RecepcionFacturas ON D_RecepcionFacturas.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios
JOIN T_SellosPresupuestales ON T_SellosPresupuestales.IdSelloPresupuestal = D_RecepcionFacturas.IdSelloPresupuestal
JOIN C_PartidasPres ON C_PartidasPres.IdPartida  = T_SellosPresupuestales.IdPartida
--LEFT OUTER 
JOIN T_OrdenServicio ON T_OrdenServicio.IdOrden = T_RecepcionFacturas.IdOrden
--LEFT OUTER 
JOIN C_Proveedores ON C_Proveedores.IdProveedor = T_OrdenServicio.IdProveedor 

WHERE --T_Cheques.IdTipoMovimiento=166 and T_OrdenServicio.IdTipoOrdenServicio=7
--AND 
T_SellosPresupuestales.Idpartida between 4300 and 4499
AND YEAR(T_Cheques.Fecha)=@Ejercicio and (MONTH (T_Cheques.Fecha)Between @MesInicio and @MesFin )
and (T_Cheques.Status='D' or(T_Cheques.Status='I' and T_Cheques.Entregado =1) )
Order BY C_Proveedores.RazonSocial
 
INSERT INTO @Tabla2
Select Distinct
CAST(TB.Concepto as varchar(7)) + ' ' + CP.DescripcionPartida as ConceptoPago,
TB.AyudaA as AyudaA,
TB.Subsidio  as Notas1,
'' as Notas2,
'' as Notas3,
TB.Beneficiario,
TB.CURP,
TB.RFC,
TB.MontoSubsidio as Importe,
'' as Sector
FROM T_BajaActivos TB
INNER JOIN C_TipoMovimiento  CT On TB.IdTipoMovimiento = CT.IdTipoMovimiento
LEFT JOIN C_PartidasPres CP On TB.Concepto = CP.IdPartida
Where YEAR(TB.FechaBaja)= @Ejercicio and (MONTH (TB.FechaBaja) Between @MesInicio and @MesFin ) AND CT.AyudasySubsidios = 1

SELECT ConceptoPago, 
RazonSocial ,
'' as Notas1,
'' as Notas2,
'' as Notas3,
Beneficiario,
CURP,
RFC, 
Importe,
Sector
From @Tabla 

UNION

SELECT ConceptoPago, 
RazonSocial ,
Notas1 as Notas1,
'' as Notas2,
'' as Notas3,
Beneficiario,
CURP,
RFC, 
Importe,
CASE WHEN RazonSocial = 1 THEN 'Social' 
ELSE 'Económico' END as Sector
From @Tabla2 

Order BY RazonSocial
GO

EXEC SP_FirmasReporte 'Montos pagados por ayudas y subsidios'
GO

Exec SP_CFG_LogScripts 'SP_RPT_K2_Montos_Pagados_Ayudas_Subsidios'
GO
