/****** Object:  StoredProcedure [dbo].[SP_Resultados_Egresos]    Script Date: 2021-04-06 17:19:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Resultados_Egresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Resultados_Egresos]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Resultados_Egresos]    Script Date: 2021-04-06 17:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --Exec  SP_Resultados_Egresos 0                   
CREATE PROCEDURE [dbo].[SP_Resultados_Egresos]

@IdArea int
	
AS
BEGIN

DECLARE @VariableTabla TABLE ( Concepto char(200),
								Año5 decimal (18,2),
								Año4 decimal (18,2),
								Año3 decimal (18,2),
								Año2 decimal (18,2),
								Año1 decimal (18,2),
								AñoVigente decimal (18,2),
								Negritas int,
								IdClave int,
								Tipo int)

INSERT INTO @VariableTabla VALUES ('1. GASTO NO ETIQUETADO ( 1 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1,1,1)
INSERT INTO @VariableTabla VALUES ('  A.SERVICIOS PERSONALES',0,0,0,0,0,0,0,1000,1)
INSERT INTO @VariableTabla VALUES ('  B.MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0,2000,1)
INSERT INTO @VariableTabla VALUES ('  C.SERVICIOS GENERALES',0,0,0,0,0,0,0,3000,1)
INSERT INTO @VariableTabla VALUES ('  D.TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0,4000,1)
INSERT INTO @VariableTabla VALUES ('  E.BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0,5000,1)
INSERT INTO @VariableTabla VALUES ('  F.INVERSION PUBLICA',0,0,0,0,0,0,0,6000,1)
INSERT INTO @VariableTabla VALUES ('  G.INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0,7000,1)
INSERT INTO @VariableTabla VALUES ('  H.PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0,8000,1)
INSERT INTO @VariableTabla VALUES ('  I.DEUDA PUBLICA',0,0,0,0,0,0,0,9000,1)
INSERT INTO @VariableTabla VALUES ('',0,0,0,0,0,0,0,7,1)
INSERT INTO @VariableTabla VALUES ('2. GASTO ETIQUETADO ( 2 = A+B+C+D+E+F+G+H+I)',0,0,0,0,0,0,1,2,2)
INSERT INTO @VariableTabla VALUES ('  A.SERVICIOS PERSONALES',0,0,0,0,0,0,0,1000,2)
INSERT INTO @VariableTabla VALUES ('  B.MATERIALES Y SUMINISTROS',0,0,0,0,0,0,0,2000,2)
INSERT INTO @VariableTabla VALUES ('  C.SERVICIOS GENERALES',0,0,0,0,0,0,0,3000,2)
INSERT INTO @VariableTabla VALUES ('  D.TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS',0,0,0,0,0,0,0,4000,2)
INSERT INTO @VariableTabla VALUES ('  E.BIENES MUEBLES, INMUEBLES E INTANGIBLES',0,0,0,0,0,0,0,5000,2)
INSERT INTO @VariableTabla VALUES ('  F.INVERSION PUBLICA',0,0,0,0,0,0,0,6000,2)
INSERT INTO @VariableTabla VALUES ('  G.INVERSIONES FINANCIERAS Y OTRAS PROVISIONES',0,0,0,0,0,0,0,7000,2)
INSERT INTO @VariableTabla VALUES ('  H.PARTICIPACIONES Y APORTACIONES',0,0,0,0,0,0,0,8000,2)
INSERT INTO @VariableTabla VALUES ('  I.DEUDA PUBLICA',0,0,0,0,0,0,0,9000,2)
INSERT INTO @VariableTabla VALUES ('',0,0,0,0,0,0,0,7,2)
INSERT INTO @VariableTabla VALUES ('3. TOTAL DE EGRESOS PROYECTADOS ( 3 = 1+ 2 )',0,0,0,0,0,0,1,3,3)

Declare @Titulos as table(IdClave int,Descripcion varchar(max), Devengado decimal(18,4))    
	INSERT INTO @Titulos  
	SELECT LEFT(CG.IdCapitulo,4) as IdClave,   CG.Descripcion as Descripcion,   0 as Devengado  
	From  C_ConceptosNEP As CN, C_CapitulosNEP As CG  WHERE CG.IdCapitulo = CN.IdCapitulo  
	Group by  CG.IdCapitulo, CG.Descripcion 
	
	Declare @rptA as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)
	Declare @rpt1 as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)
	Declare @rpt2 as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)
	Declare @rpt3 as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)
	Declare @rpt4 as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)
	Declare @rpt5 as table(IdClave int,Descripcion varchar(max),Devengado decimal(18,4), Tipo int)

--------------------------------------------------
--******No Etiquetado
	Insert into @rptA  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE()) AND Year=YEAR(GETDATE()) 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rptA  
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rptA  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE()) AND Year=YEAR(GETDATE()) 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rptA  select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

--------------------------------------------------
--******No Etiquetado
	Insert into @rpt1  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-1 AND Year=YEAR(GETDATE())-1 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rpt1  
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rpt1  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-1 AND Year=YEAR(GETDATE())-1 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rpt1  
	select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

--------------------------------------------------
--******No Etiquetado
	Insert into @rpt2  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-2 AND Year=YEAR(GETDATE())-2 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rpt2  
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rpt2  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-2 AND Year=YEAR(GETDATE())-2 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rpt2  
	select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

--------------------------------------------------
--******No Etiquetado
	Insert into @rpt3  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-3 AND Year=YEAR(GETDATE())-3 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rpt3  
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rpt3  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-3 AND Year=YEAR(GETDATE())-3 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rpt3  
	select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

--------------------------------------------------
--******No Etiquetado
	Insert into @rpt4  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-4 AND Year=YEAR(GETDATE())-4 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rpt4  
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rpt4  
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-4 AND Year=YEAR(GETDATE())-4 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rpt4  
	select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

--------------------------------------------------
--******No Etiquetado
	Insert into @rpt5 
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  1  
	From T_PresupuestoNW As TP  LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto  
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-5 AND Year=YEAR(GETDATE())-5 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto 
	AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave not in (25,26,27)  
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  Order by  CG.IdCapitulo     
	
	insert into @rpt5 
	select IdClave,Descripcion, Devengado,1 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 1)    
	
	--**Etiquetado  
	Insert into @rpt5 
	Select LEFT(CG.IdCapitulo,4) as IdClave, CG.Descripcion as Descripcion,   
	sum(ISNULL(TP.Devengado,0)) as Devengado,  2  
	From T_PresupuestoNW As TP  
	LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
	LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida  
	LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto 
	LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo  
	LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento  
	where (Mes BETWEEN  1 AND 12) AND LYear=YEAR(GETDATE())-5 AND Year=YEAR(GETDATE())-5 
	AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
	and CFF.IdClave in (25,26,27) 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
	Group by  CG.IdCapitulo, CG.Descripcion  
	Order by  CG.IdCapitulo     
	
	insert into @rpt5  
	select IdClave,Descripcion, Devengado,2 
	from @Titulos t   where t.IdClave not in (select IdClave from @rptA Where Tipo = 2)

--------------------------------

UPDATE t set t.AñoVigente = ISNULL(ra.Devengado,0), t.Año1 = ISNULL(r1.Devengado,0), t.Año2 = ISNULL(r2.Devengado,0), t.Año3 = ISNULL(r3.Devengado,0),
t.Año4 = ISNULL(r4.Devengado,0), t.Año5 = ISNULL(r5.Devengado,0)
FROM @VariableTabla t
LEFT JOIN @rptA ra ON t.IdClave = ra.IdClave and ra.Tipo =  t.Tipo 
LEFT JOIN @rpt1 r1 ON t.IdClave = r1.IdClave and r1.Tipo =  t.Tipo
LEFT JOIN @rpt2 r2 ON t.IdClave = r2.IdClave and r2.Tipo =  t.Tipo
LEFT JOIN @rpt3 r3 ON t.IdClave = r3.IdClave and r3.Tipo =  t.Tipo
LEFT JOIN @rpt4 r4 ON t.IdClave = r4.IdClave and r4.Tipo =  t.Tipo
LEFT JOIN @rpt5 r5 ON t.IdClave = r5.IdClave and r5.Tipo =  t.Tipo

Update @VariableTabla set AñoVigente = (Select SUM(AñoVigente) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1), 
					Año1 = (Select SUM(Año1) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1),
					Año2 = (Select SUM(Año2) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1),
					Año3 = (Select SUM(Año3) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1),
					Año4 = (Select SUM(Año4) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1),
					Año5 = (Select SUM(Año5) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 1)
					Where IdClave = 1

Update @VariableTabla set AñoVigente = (Select SUM(AñoVigente) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2), 
					Año1 = (Select SUM(Año1) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2),
					Año2 = (Select SUM(Año2) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2),
					Año3 = (Select SUM(Año3) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2),
					Año4 = (Select SUM(Año4) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2),
					Año5 = (Select SUM(Año5) from @VariableTabla where IdClave in (1000,2000,3000,4000,5000,6000,7000,8000,9000) and Tipo = 2)
					Where IdClave = 2

Update @VariableTabla set AñoVigente = (Select SUM(AñoVigente) from @VariableTabla where IdClave in (1,2)), 
					Año1 = (Select SUM(Año1) from @VariableTabla where IdClave in (1,2)),
					Año2 = (Select SUM(Año2) from @VariableTabla where IdClave in (1,2)),
					Año3 = (Select SUM(Año3) from @VariableTabla where IdClave in (1,2)),
					Año4 = (Select SUM(Año4) from @VariableTabla where IdClave in (1,2)),
					Año5 = (Select SUM(Año5) from @VariableTabla where IdClave in (1,2))
					Where IdClave = 3
 
SELECT  *  FROM @VariableTabla	
END
GO

EXEC SP_FirmasReporte 'LDF Resultados Egresos'
GO

Exec SP_CFG_LogScripts 'SP_Resultados_Egresos','2.31'
GO
