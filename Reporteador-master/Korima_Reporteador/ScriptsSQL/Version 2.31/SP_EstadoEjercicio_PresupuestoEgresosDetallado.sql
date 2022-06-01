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
@Mes as int, @Mes2 as int, @Ejercicio int

AS
BEGIN

--Exec SP_EstadoEjercicio_PresupuestoEgresosDetallado 1,12,2020
DECLARE @VariableTabla TABLE ( Id int,
								Concepto char(200), 
								Aprobado decimal (18,2), 
								AmpRed decimal(18,2),
								Modificado decimal (18,2), 
								Devengado decimal (18,2),
							    Pagado decimal (18,2), 
								Subejercicio decimal (18,2),
								Negritas int)

INSERT INTO @VariableTabla VALUES (1,'I. Gasto No Etiquetado (I= A+B+C+D+E+F)',null,null,null,null,null,null,1)
INSERT INTO @VariableTabla VALUES (2,'A.Personal Administrativo y de Servicio Publico',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (3,'B.Magisterio',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (4,'C.Servicios de Salud',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (5,'c1)Personal Administrativo',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (6,'c2)Personal Medico, Paramedico y Afin',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (7,'D.Seguridad Publica',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (8,'E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas ( E = e1 + e2 )',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES (9,'e1)Nombre del Programa o Ley 1',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (10,'e2)Nombre del Programa o Ley 2',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (11,'F.Sentencias laborales definitivas',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (12,'',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES (13,'II. Gasto Etiquetado (I= A+B+C+D+E+F)',0,0,0,0,0,0,1)
INSERT INTO @VariableTabla VALUES (14,'A.Personal Administrativo y de Servicio Publico',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (15,'B.Magisterio',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (16,'C.Servicios de Salud',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (17,'c1)Personal Administrativo',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (18,'c2)Personal Medico, Paramedico y Afin',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (19,'DSeguridad Publica',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (20,'E.Gastos asociados a la implementacion de nuevas leyes federales o reformas a la mismas ( E = e1 + e2 )',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES (21,'e1)Nombre del Programa o Ley 1',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (22,'e2)Nombre del Programa o Ley 2',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (23,'F.Sentencias laborales definitivas',0,0,0,0,0,0,0)
INSERT INTO @VariableTabla VALUES (24,'',null,null,null,null,null,null,0)
INSERT INTO @VariableTabla VALUES (25,'III. Total del Gasto en Servicios Personales (III = I + II )',0,0,0,0,0,0,1)

	Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),  
	Amp_Red decimal(18,4),SubEjercicio decimal(18,4),ClaveFF int)  

	Insert into @rpt 

	Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,  
  
	sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
   
	sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,   
	sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
	sum(ISNULL(TP.Pagado,0)) as Pagado,    
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
	sum(ISNULL(TP.Devengado,0))as SubEjercicio,
	LEFT(CF.Clave,1)
	From T_PresupuestoNW As TP 
			LEFT JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio
	AND LEFT(CG.IdCapitulo,1) = 1
	Group by  CG.IdCapitulo,CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,TS.IdFuenteFinanciamiento, CF.Clave
	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo 

Update @VariableTabla set Aprobado = ISNULL((Select SUM(Autorizado) from @rpt Where ClaveFF = 1),0),
							AmpRed = ISNULL((Select SUM(Amp_Red) from @rpt Where ClaveFF = 1),0),
							Modificado = ISNULL((Select SUM(Modificado) from @rpt Where ClaveFF = 1),0),
							Devengado = ISNULL((Select SUM(Devengado) from @rpt Where ClaveFF = 1),0),
							Pagado = ISNULL((Select SUM(Pagado) from @rpt Where ClaveFF = 1),0),
							Subejercicio = ISNULL((Select SUM(Subejercicio) from @rpt Where ClaveFF = 1),0)
							Where Id = 2

Update @VariableTabla set Aprobado = ISNULL((Select SUM(Autorizado) from @rpt Where ClaveFF = 2),0),
							AmpRed = ISNULL((Select SUM(Amp_Red) from @rpt Where ClaveFF = 2),0),
							Modificado = ISNULL((Select SUM(Modificado) from @rpt Where ClaveFF = 2),0),
							Devengado = ISNULL((Select SUM(Devengado) from @rpt Where ClaveFF = 2),0),
							Pagado = ISNULL((Select SUM(Pagado) from @rpt Where ClaveFF = 2),0),
							Subejercicio = ISNULL((Select SUM(Subejercicio) from @rpt Where ClaveFF = 2),0)
							Where Id = 14

Update @VariableTabla set Aprobado = ISNULL((Select SUM(Aprobado) from @VariableTabla Where Id Between 2 and 7),0),
							AmpRed = ISNULL((Select SUM(AmpRed) from @VariableTabla  Where Id Between 2 and 7),0),
							Modificado = ISNULL((Select SUM(Modificado) from @VariableTabla  Where Id Between 2 and 7),0),
							Devengado = ISNULL((Select SUM(Devengado) from @VariableTabla Where Id Between 2 and 7),0),
							Pagado = ISNULL((Select SUM(Pagado) from @VariableTabla  Where Id Between 2 and 7),0),
							Subejercicio = ISNULL((Select SUM(Subejercicio) from @VariableTabla  Where Id Between 2 and 7),0)
							Where Id = 1

Update @VariableTabla set Aprobado = ISNULL((Select SUM(Aprobado) from @VariableTabla Where Id Between 14 and 23),0),
							AmpRed = ISNULL((Select SUM(AmpRed) from @VariableTabla  Where Id Between 14 and 23),0),
							Modificado = ISNULL((Select SUM(Modificado) from @VariableTabla  Where Id Between 14 and 23),0),
							Devengado = ISNULL((Select SUM(Devengado) from @VariableTabla Where Id Between 14 and 23),0),
							Pagado = ISNULL((Select SUM(Pagado) from @VariableTabla  Where Id Between 14 and 23),0),
							Subejercicio = ISNULL((Select SUM(Subejercicio) from @VariableTabla  Where Id Between 14 and 23),0)
							Where Id = 13

Update @VariableTabla set Aprobado = ISNULL((Select SUM(Aprobado) from @VariableTabla Where Id in (1,13)),0),
							AmpRed = ISNULL((Select SUM(AmpRed) from @VariableTabla Where Id in (1,13)),0),
							Modificado = ISNULL((Select SUM(Modificado) from @VariableTabla Where Id in (1,13)),0),
							Devengado = ISNULL((Select SUM(Devengado) from @VariableTabla Where Id in (1,13)),0),
							Pagado = ISNULL((Select SUM(Pagado) from @VariableTabla Where Id in (1,13)),0),
							Subejercicio = ISNULL((Select SUM(Subejercicio) from @VariableTabla Where Id in (1,13)),0)
							Where Id = 25

SELECT  * FROM @VariableTabla 	
END
GO

EXEC SP_FirmasReporte 'LDF Clasificación de servicios personales por categoría'
GO

Exec SP_CFG_LogScripts 'SP_EstadoEjercicio_PresupuestoEgresosDetallado','2.30.1'
GO