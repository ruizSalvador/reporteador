/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]    Script Date: 02/01/2017 11:41:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]    Script Date: 02/01/2017 11:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                        
CREATE PROCEDURE [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]	
AS
BEGIN

--Exec SP_EstadoEjercicio_PresupuestoEgresosDetallado
DECLARE @VariableTabla TABLE ( Concepto char(200), 
								Aprobado decimal (18,2), 
								AmpRed decimal(18,2),
								Modificado decimal (18,2), 
								Devengado decimal (18,2),
							    Pagado decimal (18,2), 
								Subejercicio decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES ('I. Gasto No Etiquetado (I= A+B+C+D+E+F)',null,null,null,null,null,null,1)
INSERT INTO @VariableTabla VALUES ('A.Personal Administrativo y de Servicio Publico',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.Magisterio',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.Servicios de Salud',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('c1)Personal Administrativo',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('c2)Personal Medico, Paramedico y Afin',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('D.Seguridad Publica',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas ( E = e1 + e2 )',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('e1)Nombre del Programa o Ley 1',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('e2)Nombre del Programa o Ley 2',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.Sentencias laborales definitivas',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('II. Gasto No Etiquetado (I= A+B+C+D+E+F)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES ('A.Personal Administrativo y de Servicio Publico',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('B.Magisterio',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('C.Servicios de Salud',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('c1)Personal Administrativo',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('c2)Personal Medico, Paramedico y Afin',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('DSeguridad Publica',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas ( E = e1 + e2 )',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('e1)Nombre del Programa o Ley 1',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('e2)Nombre del Programa o Ley 2',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('F.Sentencias laborales definitivas',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES ('',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES ('III. Total del Gasto en Servicios Personales (III = I + II )',0,0,0,0,0,0,1)


SELECT  * FROM @VariableTabla 	
END



EXEC SP_FirmasReporte 'Estado Ejercicio Presupuesto EgresosDetallado'
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicio_PresupuestoEgresosDetallado'
GO