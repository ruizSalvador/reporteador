/****** Object:  StoredProcedure [dbo].[SP_Proyecciones_Ingresos]    Script Date: 02/01/2017 11:37:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Proyecciones_Ingresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Proyecciones_Ingresos]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Proyecciones_Ingresos]    Script Date: 02/01/2017 11:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_Proyecciones_Ingresos                        
CREATE PROCEDURE [dbo].[SP_Proyecciones_Ingresos]
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),
								AñoCuestion decimal (18,2),
								Año1 decimal (18,2),
								Año2 decimal (18,2),
								Año3 decimal (18,2),
								Año4 decimal (18,2),
								Año5 decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('1. INGRESOS DE LIBRE DISPOSICIÓN (1 = A+B+C+D+E+F+G+H+I+J+K+L)',null,null,null,null,null,null,1)
INSERT INTO @VariableTabla VALUES ('      A.IMPUESTOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      B.CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      C.CONTRIBUCIONES DE MEJORA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      D.DERECHOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      E.PRODUCTOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      F.APROVECHAMIENTOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      G.INGRESOS POR VENTA DE BIENES Y SERVICIOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      H.PARTICIPACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      I.INCENTIVOS DERIVADOS DE LA COLABORACION FISCAL',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      J.TRANSFERENCIAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      K.CONVENIOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      L.OTROS INGRESOS DE LIBRE DISPOSICION',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('2. TRANSFERENCIAS FEDERALES ETIQUETADAS ( 2= A+B+C+D+E)',null,null,null,null,null,null,1)
INSERT INTO @VariableTabla VALUES ('      A. APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      B. CONVENIO',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      C. FONDOS DISTINTOS DE APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      D. TRANSFERENCIAS, SUBSIDIOS Y SUBVENCIONES, Y PENSIONES Y JUBILACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      E. OTRAS TRANSFERENCIAS FEDERALES ETIQUETADAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('3. INGRESOS DERIVADOS DE FINANCIAMIENTOS ( 3=A)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('       A. INGRESOS DERIVADOS DE FINANCIAMIENTOS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('4. TOTAL DE INGRESOS PROYECTADOS ( 4 = 1 + 2 +3 )',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('DATOS INFORMATIVOS',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('      1. INGRESOS DERIVADOS DE FINANCIAMIENTOS CON FUENTE DE PAGO DE RECURSOS DE LIBRE DISPOSICION',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      2. INGRESOS DERIVADOS DE FINANCIAMIENTOS CON FUENTE DE PAGO DE TRANSFERENCIAS FEDERALES ETIQUETADAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('      3. INGRESOS DERIVADOS DE FINANCIAMIENTO ( 3 = 1 + 2 )',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)

SELECT  *  FROM @VariableTabla	
END


EXEC SP_FirmasReporte 'Proyecciones Ingresos'
GO

Exec SP_CFG_LogScripts 'SP_Proyecciones_Ingresos'
GO