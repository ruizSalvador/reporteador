/****** Object:  StoredProcedure [dbo].[SP_RPT_ClasificacionFuncional_finalidadFuncion]    Script Date: 02/01/2017 10:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ClasificacionFuncional_finalidadFuncion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_ClasificacionFuncional_finalidadFuncion]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_ClasificacionFuncional_finalidadFuncion]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_ClasificacionFuncional_finalidadFuncion
CREATE PROCEDURE [dbo].[SP_RPT_ClasificacionFuncional_finalidadFuncion]

AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200), 
								Aprobado decimal (18,2), 
								AmpRed decimal(18,2),
								Modificado decimal (18,2), 
								Devengado decimal (18,2),
							    Pagado decimal (18,2), 
								Subejercicio decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('I. Gasto No Etiquetado (I = A+B+C+D)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES (' A. Gobierno ( A=a1+a2+a3+a4+a5+a6+a7+a8)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    LEGISLACION				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('	JUSTICIA			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COORDINACIÓN DE LA POLÍTICA DE GOBIERNO				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    RELACIONES EXTERIORES		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS FINANCIEROS Y HACENDARIOS			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SEGURIDAD NACIONAL				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS DE ORDEN PÚBLICO Y DE SEGURIDAD INTERIOR	     ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTROS SERVICIOS GENERALES				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (' B. Desarrollo Social ( B=b1+b2+b3+b4+b5+b6+b7)		     ',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    PROTECCIÓN AMBIENTAL				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    VIVIENDA Y SERVICIOS A LA COMUNIDAD				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SALUD				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    RECREACIÓN, CULTURA Y OTRAS MANIFESTACIONES SOCIALES	',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    EDUCACIÓN			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    PROTECCIÓN SOCIAL				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTROS ASUNTOS SOCIALES				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (' C. Desarrollo Economico (C=c1+c2+c3+c4+c5+c6+c7+c8+c9)    ',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS ECONÓMICOS, COMERCIALES Y LABORALES EN GENERAL',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    AGROPECUARIA, SILVICULTURA, PESCA Y CAZA			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COMBUSTIBLES Y ENERGÍA				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    MINERÍA, MANUFACTURAS Y CONSTRUCCIÓN				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TRANSPORTE				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COMUNICACIONES				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TURISMO  ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    CIENCIA, TECNOLOGÍA E INNOVACIÓN				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTRAS INDUSTRIAS Y OTROS ASUNTOS ECONÓMICOS			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (' D.Otras No Clasificadas en Funciones Anteriores (D=d1+d2+d3+d4)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    TRANSACCIONES DE LA DEUDA PÚBLICA / COSTO FINANCIERO  DE LA DEUDA',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TRANSFERENCIAS, PARTICIPACIONES Y APORTACIONES ENTRE DIFERENTES NIVELES Y ÓRDENES DE GOBIERNO',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SANEAMIENTO DEL SISTEMA FINANCIERO				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ADEUDOS DE EJERCICIOS FISCALES ANTERIORES',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('II. Gasto No Etiquetado (II = A+B+C+D)			',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES (' A. Gobierno ( A=a1+a2+a3+a4+a5+a6+a7+a8)			    ',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    LEGISLACION				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    JUSTICIA				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COORDINACIÓN DE LA POLÍTICA DE GOBIERNO			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    RELACIONES EXTERIORES				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS FINANCIEROS Y HACENDARIOS		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SEGURIDAD NACIONAL			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS DE ORDEN PÚBLICO Y DE SEGURIDAD INTERIOR	    ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTROS SERVICIOS GENERALES				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (' B. Desarrollo Social ( B=b1+b2+b3+b4+b5+b6+b7)		    ',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    PROTECCIÓN AMBIENTAL				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    VIVIENDA Y SERVICIOS A LA COMUNIDAD			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SALUD		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    RECREACIÓN, CULTURA Y OTRAS MANIFESTACIONES SOCIALES  ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    EDUCACIÓN				                             ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    PROTECCIÓN SOCIAL				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTROS ASUNTOS SOCIALES				' ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (' C. Desarrollo Economico (C=c1+c2+c3+c4+c5+c6+c7+c8+c9)   ',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    ASUNTOS ECONÓMICOS, COMERCIALES Y LABORALES EN GENERAL',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    AGROPECUARIA, SILVICULTURA, PESCA Y CAZA		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COMBUSTIBLES Y ENERGÍA			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    MINERÍA, MANUFACTURAS Y CONSTRUCCIÓN			    ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TRANSPORTE				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    COMUNICACIONES		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TURISMO			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    CIENCIA, TECNOLOGÍA E INNOVACIÓN				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    OTRAS INDUSTRIAS Y OTROS ASUNTOS ECONÓMICOS		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('  D.Otras No Clasificadas en Funciones Anteriores (D=d1+d2+d3+d4)				',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('    TRANSACCIONES DE LA DEUDA PÚBLICA / COSTO FINANCIERO DE LA DEUDA			',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    TRANSFERENCIAS, PARTICIPACIONES Y APORTACIONES ENTRE DIFERENTES NIVELES Y ÓRDENES DE GOBIERNO				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    SANEAMIENTO DEL SISTEMA FINANCIERO		',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('    ADEUDOS DE EJERCICIOS FISCALES ANTERIORES		    ',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('				',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('III. Total de Egresos (III= I + II )				    ',0,0,0,0,0,0,1)

SELECT  *  FROM @VariableTabla
END

EXEC SP_FirmasReporte 'Clasificacion Funcional(Finalidad y Funcion)'
GO

Exec SP_CFG_LogScripts 'SP_RPT_ClasificacionFuncional_finalidadFuncion'
GO
