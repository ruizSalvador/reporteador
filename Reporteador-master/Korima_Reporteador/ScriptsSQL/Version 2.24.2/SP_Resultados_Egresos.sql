/****** Object:  StoredProcedure [dbo].[SP_Resultados_Egresos]    Script Date: 02/01/2017 11:51:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Resultados_Egresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Resultados_Egresos]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Resultados_Egresos]    Script Date: 02/01/2017 11:51:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --Exec  SP_Resultados_Egresos                     
CREATE PROCEDURE [dbo].[SP_Resultados_Egresos]
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),
								Año5 decimal (18,2),
								Año4 decimal (18,2),
								Año3 decimal (18,2),
								Año2 decimal (18,2),
								Año1 decimal (18,2),
								AñoVigente decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('1. GASTO NO ETIQUETADO ( 1 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('  A.SERVICIOS PERSONALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  B.MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  C.SERVICIOS GENERALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  D.TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  E.BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  F.INVERSION PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  G.INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  H.PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  I.DEUDA PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('2. GASTO ETIQUETADO ( 2 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('  A.SERVICIOS PERSONALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  B.MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  C.SERVICIOS GENERALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  D.TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  E.BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  F.INVERSION PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  G.INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  H.PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  I.DEUDA PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('3. TOTAL DE EGRESOS PROYECTADOS ( 3 = 1+ 2 )',0,0,0,0,0,0,1)


SELECT  *  FROM @VariableTabla	
END

EXEC SP_FirmasReporte 'Resultados Egresos'
GO

Exec SP_CFG_LogScripts 'SP_Resultados_Egresos'
GO
