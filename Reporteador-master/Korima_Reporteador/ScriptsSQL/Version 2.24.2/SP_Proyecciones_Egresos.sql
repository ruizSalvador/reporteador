/****** Object:  StoredProcedure [dbo].[SP_Proyecciones_Egresos]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Proyecciones_Egresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Proyecciones_Egresos]
GO                                       
/****** Object:  StoredProcedure [dbo].[SP_Proyecciones_Egresos]    Script Date: 02/01/2017 11:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_Proyecciones_Egresos                        
CREATE PROCEDURE [dbo].[SP_Proyecciones_Egresos]
	
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

INSERT INTO @VariableTabla VALUES ('1. GASTO NO ETIQUETADO ( 1 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('A.      SERVICIOS PERSONALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.      MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.      SERVICIOS GENERALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('D.      TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.       BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.       INVERSION PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('G.      INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('H.      PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('I.        DEUDA PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('2. GASTO ETIQUETADO ( 2 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('A.      SERVICIOS PERSONALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.      MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.      SERVICIOS GENERALES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('D.      TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.       BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.       INVERSION PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('G.      INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('H.      PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('I.        DEUDA PUBLICA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('3. TOTAL DE EGRESOS PROYECTADOS ( 3 = 1+ 2 )',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)

SELECT  *  FROM @VariableTabla	
END

 

EXEC SP_FirmasReporte 'Proyecciones Egresos'
GO

Exec SP_CFG_LogScripts 'SP_Proyecciones_Egresos'
GO