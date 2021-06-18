/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_PresupuestoEgresosDetallado]    Script Date: 02/01/2017 11:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnalitico_PresupuestoEgresosDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnalitico_PresupuestoEgresosDetallado]
GO                                     
/****** Object:  StoredProcedure [dbo].[SP_EstadoAnalitico_PresupuestoEgresosDetallado]    Script Date: 02/01/2017 11:31:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                        
CREATE PROCEDURE [dbo].[SP_EstadoAnalitico_PresupuestoEgresosDetallado]
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),
								Aprobado_d decimal (18,2),
								Ampliaciones_Reducciones decimal (18,2),
								Modificado decimal (18,2),
								Devengado decimal (18,2),
								Pagado decimal (18,2),
								Subejercicio_e decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('"I. Gasto No Etiquetado(I = A+B+C+D+E+F+G+H)"',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('A.Dependencia o Unidad Administrativa 1'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.Dependencia o Unidad Administrativa 2'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.Dependencia o Unidad Administrativa 3'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('D.Dependencia o Unidad Administrativa 4'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.Dependencia o Unidad Administrativa 5'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.Dependencia o Unidad Administrativa 6'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('G.Dependencia o Unidad Administrativa 7'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('H.Dependencia o Unidad Administrativa xx'     ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                             ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('"II. Gasto Etiquetado(II = A+B+C+D+E+F+G+H)"' ,0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('A.Dependencia o Unidad Administrativa 1'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.Dependencia o Unidad Administrativa 2'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.Dependencia o Unidad Administrativa 3'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('D.Dependencia o Unidad Administrativa 4'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.Dependencia o Unidad Administrativa 5'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.Dependencia o Unidad Administrativa 6'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('G.Dependencia o Unidad Administrativa 7'      ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('H.Dependencia o Unidad Administrativa xx'     ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (''                                             ,0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('III. Total de Egresos (III = I + II)'         ,0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES (''                                             ,0,0,0,0,0,0,0)


SELECT  *  FROM @VariableTabla 	
END

EXEC SP_FirmasReporte 'EstadoAnalitico_PresupuestoEgresosDetallado'
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnalitico_PresupuestoEgresosDetallado'
GO