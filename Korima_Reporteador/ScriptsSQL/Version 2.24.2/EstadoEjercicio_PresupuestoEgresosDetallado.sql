/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]    Script Date: 02/01/2017 11:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]    Script Date: 09/05/2013 13:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                        
CREATE PROCEDURE [dbo].[SP_EstadoEjercicio_PresupuestoEgresosDetallado]


	
AS
BEGIN



DECLARE @VariableTabla TABLE ( Concepto char(200))

INSERT INTO @VariableTabla VALUES ('I. Gasto No Etiquetado (I= A+B+C+D+E+F)')
INSERT INTO @VariableTabla VALUES ('A.Personal Administrativo y de Servicio Publico')
INSERT INTO @VariableTabla VALUES ('B.Magisterio')
INSERT INTO @VariableTabla VALUES ('C.Servicios de Salud')
INSERT INTO @VariableTabla VALUES ('c1)Personal Administrativo')
INSERT INTO @VariableTabla VALUES ('c2)Personal Medico, Paramedico y Afin')
INSERT INTO @VariableTabla VALUES ('DSeguridad Publica')
INSERT INTO @VariableTabla VALUES ('"E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas"')
INSERT INTO @VariableTabla VALUES ('( E = e1 + e2 )')
INSERT INTO @VariableTabla VALUES ('e1)Nombre del Programa o Ley 1')
INSERT INTO @VariableTabla VALUES ('e2)Nombre del Programa o Ley 2')
INSERT INTO @VariableTabla VALUES ('F.Sentencias laborales definitivas')
INSERT INTO @VariableTabla VALUES ('')
INSERT INTO @VariableTabla VALUES ('II. Gasto No Etiquetado (I= A+B+C+D+E+F)')
INSERT INTO @VariableTabla VALUES ('A.Personal Administrativo y de Servicio Publico')
INSERT INTO @VariableTabla VALUES ('B.Magisterio')
INSERT INTO @VariableTabla VALUES ('C.Servicios de Salud')
INSERT INTO @VariableTabla VALUES ('c1)Personal Administrativo')
INSERT INTO @VariableTabla VALUES ('c2)Personal Medico, Paramedico y Afin')
INSERT INTO @VariableTabla VALUES ('DSeguridad Publica')
INSERT INTO @VariableTabla VALUES ('"E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas"')
INSERT INTO @VariableTabla VALUES ('( E = e1 + e2 )')
INSERT INTO @VariableTabla VALUES ('e1)Nombre del Programa o Ley 1')
INSERT INTO @VariableTabla VALUES ('e2)Nombre del Programa o Ley 2')
INSERT INTO @VariableTabla VALUES ('F.Sentencias laborales definitivas')
INSERT INTO @VariableTabla VALUES ('')
INSERT INTO @VariableTabla VALUES ('III. Total del Gasto en Servicios Personales')
INSERT INTO @VariableTabla VALUES ('(III = I + II )')
INSERT INTO @VariableTabla VALUES ('')


SELECT  Concepto  FROM @VariableTabla 
	
END

EXEC SP_FirmasReporte 'EstadoEjercicio_PresupuestoEgresosDetallado'
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicio_PresupuestoEgresosDetallado'
GO

