

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]    Script Date: 10/06/2017 13:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]
GO

/****** Object:  StoredProcedure [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]    Script Date: 10/06/2013 13:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado 0, 1,12,2,2021,0,0,0
CREATE PROCEDURE  [dbo].[SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado]  

@MuestraCeros as int = 0,
@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
--@ClaveFF as varchar(10),
@IdArea as int,
@AprAnual as bit,
@AmpRedAnual bit

AS  
BEGIN  
  

-- declare @IdArea as int,  
--@AmpRedAnual int
 --select @IdArea=0
 --select @AmpRedAnual=1

--If @Tipo = 6
--	 begin
--	Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2),IdClaveFF int)  
--	Insert into @Anual6  
--	Select CN.IdConcepto  as Clave,   
--	sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red  
--	,(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
--	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG  
--	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
--	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
--	Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo  ,TS.IDFUENTEFINANCIAMIENTO
--	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

--	--Tabla de titulos   
--	Declare @Titulos as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
--	INSERT INTO @Titulos  
--	SELECT CG.IdCapitulo as IdClave,   
--	CG.Descripcion as Descripcion,   
--	CN.IdConcepto  as Clave,   
--	CN.Descripcion as Descripcion2,   
--	CN.IdCapitulo as IdClave2,   
--	0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado,   
--	0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio   ,0 as IdClaveFF
--	From  C_ConceptosNEP As CN, C_CapitulosNEP As CG  
--	WHERE CG.IdCapitulo = CN.IdCapitulo  


--	Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--	Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--	Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--	PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  

--	Insert into @rpt  
--	--VALORES ABSOLUTOS  
--	--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **  
--	Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,  
  
--	sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
   
--	sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--	sum(ISNULL(TP.Devengado,0)) as Devengado,   
--	sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--	sum(ISNULL(TP.Pagado,0)) as Pagado,   
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--	sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--	sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
--	(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--	sum(ISNULL(TP.Devengado,0))as SubEjercicio,
--	(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF  
--	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG 
--	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo  
--	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
--	Group by  CG.IdCapitulo,CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo,TS.IdFuenteFinanciamiento
--	Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo  

--	insert into @rpt  
--	select* from @Titulos t   
--	where t.Clave not in (select Clave from @rpt)  


--	 If @AmpRedAnual = 1  
--	  Begin  
--	   update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  and a.IdClaveFF=r.IdClaveFF
--		if @MuestraCeros = 0
--		begin
--		select * from @rpt where IdClaveFF in (11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--	   else
--	   begin 
--	   select * from @rpt where IdClaveFF in (0,11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--	   end
--	  End  
--	 --Else  
--	 -- Begin  
--	 --  update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave  
--	 --  select * from @rpt Order by  IdClave , Clave, IdClave2  
--	 -- End  
--	 end
IF @Tipo=6 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN 
Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual6
Select CN.IdConcepto  as Clave, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
and CFF.IdClave not in (25,26,27)
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

--Tabla de titulos 
Declare @Titulos as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rpt
--VALORES ABSOLUTOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Devengado,0))as SubEjercicio 

--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
and CFF.IdClave not in (25,26,27)
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt
select* from @Titulos t 
where t.Clave not in (select Clave from @rpt)

-----------------------------------------------------------------------------
Update @rpt set Descripcion = 'A. Servicios Personales (A=a1+a2+a3+a4+a5+a6+a7)' Where IdClave = 1000 OR IdClave = 10000
Update @rpt set Descripcion2 = ' a1) Remuneraciones al Personal de Carácter Permanente' Where  Clave = 1100 OR Clave = 11000
Update @rpt set Descripcion2 = ' a2) Remuneraciones al Personal de Carácter Transitorio' Where  Clave = 1200 OR Clave = 12000
Update @rpt set Descripcion2 = ' a3) Remuneraciones Adicionales y Especiales' Where  Clave = 1300 OR Clave = 13000
Update @rpt set Descripcion2 = ' a4) Seguridad Social' Where  Clave = 1400 OR Clave = 14000
Update @rpt set Descripcion2 = ' a5) Otras Prestaciones Sociales y Económicas' Where  Clave = 1500 OR Clave = 15000
Update @rpt set Descripcion2 = ' a6) Previsiones' Where  Clave = 1600 OR Clave = 16000
Update @rpt set Descripcion2 = ' a7) Pago de Estímulos a Servidores Públicos' Where  Clave = 1700 OR Clave = 17000

Update @rpt set Descripcion = 'B. Materiales y Suministros (B=b1+b2+b3+b4+b5+b6+b7+b8+b9)' Where IdClave = 2000 OR IdClave = 20000
Update @rpt set Descripcion2 = ' b1) Materiales de Administración, Emisión de Documentos y Artículos Oficiales' Where  Clave = 2100 OR Clave = 21000
Update @rpt set Descripcion2 = ' b2) Alimentos y Utensilios' Where  Clave = 2200 OR Clave = 22000
Update @rpt set Descripcion2 = ' b3) Materias Primas y Materiales de Producción y Comercialización' Where  Clave = 2300 OR Clave = 23000
Update @rpt set Descripcion2 = ' b4) Materiales y Artículos de Construcción y de Reparación' Where  Clave = 2400 OR Clave = 24000
Update @rpt set Descripcion2 = ' b5) Productos Químicos, Farmacéuticos y de Laboratorio' Where  Clave = 2500 OR Clave = 25000
Update @rpt set Descripcion2 = ' b6) Combustibles, Lubricantes y Aditivos' Where  Clave = 2600 OR Clave = 26000
Update @rpt set Descripcion2 = ' b7) Vestuario, Blancos, Prendas de Protección y Artículos Deportivos' Where  Clave = 2700 OR Clave = 27000
Update @rpt set Descripcion2 = ' b8) Materiales y Suministros Para Seguridad' Where  Clave = 2800 OR Clave = 28000
Update @rpt set Descripcion2 = ' b9) Herramientas, Refacciones y Accesorios Menores' Where  Clave = 2900 OR Clave = 29000

Update @rpt set Descripcion = 'C. Servicios Generales (C=c1+c2+c3+c4+c5+c6+c7+c8+c9)' Where IdClave = 3000 OR IdClave = 30000
Update @rpt set Descripcion2 = ' c1) Servicios Básicos' Where  Clave = 3100 OR Clave = 31000
Update @rpt set Descripcion2 = ' c2) Servicios de Arrendamiento' Where  Clave = 3200 OR Clave = 32000
Update @rpt set Descripcion2 = ' c3) Servicios Profesionales, Científicos, Técnicos y Otros Servicios' Where  Clave = 3300 OR Clave = 33000
Update @rpt set Descripcion2 = ' c4) Servicios Financieros, Bancarios y Comerciales' Where  Clave = 3400 OR Clave = 34000
Update @rpt set Descripcion2 = ' c5) Servicios de Instalación, Reparación, Mantenimiento y Conservación' Where  Clave = 3500 OR Clave = 35000
Update @rpt set Descripcion2 = ' c6) Servicios de Comunicación Social y Publicidad' Where  Clave = 3600 OR Clave = 36000
Update @rpt set Descripcion2 = ' c7) Servicios de Traslado y Viáticos' Where  Clave = 3700 OR Clave = 37000
Update @rpt set Descripcion2 = ' c8) Servicios Oficiales' Where  Clave = 3800 OR Clave = 38000
Update @rpt set Descripcion2 = ' c9) Otros Servicios Generales' Where  Clave = 3900 OR Clave = 39000

Update @rpt set Descripcion = 'D. Transferencias, Asignaciones, Subsidios y Otras Ayudas (D=d1+d2+d3+d4+d5+d6+d7+d8+d9)' Where IdClave = 4000 OR IdClave = 40000
Update @rpt set Descripcion2 = ' d1) Transferencias Internas y Asignaciones al Sector Público' Where  Clave = 4100 OR Clave = 41000
Update @rpt set Descripcion2 = ' d2) Transferencias al Resto del Sector Público' Where  Clave = 4200 OR Clave = 42000
Update @rpt set Descripcion2 = ' d3) Subsidios y Subvenciones' Where  Clave = 4300 OR Clave = 43000
Update @rpt set Descripcion2 = ' d4) Ayudas Sociales' Where  Clave = 4400 OR Clave = 44000
Update @rpt set Descripcion2 = ' d5) Pensiones y Jubilaciones' Where  Clave = 4500 OR Clave = 45000
Update @rpt set Descripcion2 = ' d6) Transferencias a Fideicomisos, Mandatos y Otros Análogos' Where  Clave = 4600 OR Clave = 46000
Update @rpt set Descripcion2 = ' d7) Transferencias a la Seguridad Social' Where  Clave = 4700 OR Clave = 47000
Update @rpt set Descripcion2 = ' d8) Donativos' Where  Clave = 4800 OR Clave = 48000 
Update @rpt set Descripcion2 = ' d9) Transferencias al Exterior' Where  Clave = 4900 OR Clave = 49000

Update @rpt set Descripcion = 'E. Bienes Muebles, Inmuebles e Intangibles (E=e1+e2+e3+e4+e5+e6+e7+e8+e9)' Where IdClave = 5000 OR IdClave = 50000
Update @rpt set Descripcion2 = ' e1) Mobiliario y Equipo de Administración' Where  Clave = 5100 OR Clave = 51000
Update @rpt set Descripcion2 = ' e2) Mobiliario y Equipo Educacional y Recreativo' Where  Clave = 5200 OR Clave = 52000
Update @rpt set Descripcion2 = ' e3) Equipo e Instrumental Médico y de Laboratorio' Where  Clave = 5300 OR Clave = 53000
Update @rpt set Descripcion2 = ' e4) Vehículos y Equipo de Transporte' Where  Clave = 5400 OR Clave = 54000
Update @rpt set Descripcion2 = ' e5) Equipo de Defensa y Seguridad' Where  Clave = 5500 OR Clave = 55000
Update @rpt set Descripcion2 = ' e6) Maquinaria, Otros Equipos y Herramientas' Where  Clave = 5600 OR Clave = 56000
Update @rpt set Descripcion2 = ' e7) Activos Biológicos' Where  Clave = 5700 OR Clave = 57000
Update @rpt set Descripcion2 = ' e8) Bienes Inmuebles' Where  Clave = 5800 OR Clave = 58000
Update @rpt set Descripcion2 = ' e9) Activos Intangibles' Where  Clave = 5900 OR Clave = 59000

Update @rpt set Descripcion = 'F. Inversión Pública (F=f1+f2+f3)' Where IdClave = 6000 OR IdClave = 60000
Update @rpt set Descripcion2 = ' f1) Obra Pública en Bienes de Dominio Público' Where  Clave = 6100 OR Clave = 61000
Update @rpt set Descripcion2 = ' f2) Obra Pública en Bienes Propios' Where  Clave = 6200 OR Clave = 62000
Update @rpt set Descripcion2 = ' f3) Proyectos Productivos y Acciones de Fomento' Where  Clave = 6300 OR Clave = 63000

Update @rpt set Descripcion = 'G. Inversiones Financieras y Otras Provisiones (G=g1+g2+g3+g4+g5+g6+g7)' Where IdClave = 7000 OR IdClave = 70000
Update @rpt set Descripcion2 = ' g1) Inversiones Para el Fomento de Actividades Productivas' Where  Clave = 7100 OR Clave = 71000
Update @rpt set Descripcion2 = ' g2) Acciones y Participaciones de Capital' Where  Clave = 7200 OR Clave = 72000
Update @rpt set Descripcion2 = ' g3) Compra de Títulos y Valores' Where  Clave = 7300 OR Clave = 73000
Update @rpt set Descripcion2 = ' g4) Concesión de Préstamos' Where  Clave = 7400 OR Clave = 74000
Update @rpt set Descripcion2 = ' g5) Inversiones en Fideicomisos, Mandatos y Otros Análogos Fideicomiso de Desastres Naturales (Informativo)' Where  Clave = 7500 OR Clave = 75000
Update @rpt set Descripcion2 = ' g6) Otras Inversiones Financieras' Where  Clave = 7600 OR Clave = 76000
Update @rpt set Descripcion2 = ' g7) Provisiones para Contingencias y Otras Erogaciones Especiales' Where  Clave = 7900 OR Clave = 79000

Update @rpt set Descripcion = 'H. Participaciones y Aportaciones (H=h1+h2+h3)' Where IdClave = 8000 OR IdClave = 80000
Update @rpt set Descripcion2 = ' h1) Participaciones' Where  Clave = 8100 OR Clave = 81000
Update @rpt set Descripcion2 = ' h2) Aportaciones' Where  Clave = 8300 OR Clave = 83000
Update @rpt set Descripcion2 = ' h3) Convenios' Where  Clave = 8500 OR Clave = 85000

Update @rpt set Descripcion = 'I. Deuda Pública (I=i1+i2+i3+i4+i5+i6+i7)' Where IdClave = 9000 OR IdClave = 90000
Update @rpt set Descripcion2 = ' i1) Amortización de la Deuda Pública' Where  Clave = 9100 OR Clave = 91000
Update @rpt set Descripcion2 = ' i2) Intereses de la Deuda Pública' Where  Clave = 9200 OR Clave = 92000
Update @rpt set Descripcion2 = ' i3) Comisiones de la Deuda Pública' Where  Clave = 9300 OR Clave = 93000
Update @rpt set Descripcion2 = ' i4) Gastos de la Deuda Pública' Where  Clave = 9400 OR Clave = 94000
Update @rpt set Descripcion2 = ' i5) Costo por Coberturas' Where  Clave = 9500 OR Clave = 95000
Update @rpt set Descripcion2 = ' i6) Apoyos Financieros' Where  Clave = 9600 OR Clave = 96000
Update @rpt set Descripcion2 = ' i7) Adeudos de Ejercicios Fiscales Anteriores (ADEFAS)' Where  Clave = 9900 OR Clave = 99000

-----------------------------------------------------------------------------

	If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual6 a, @rpt r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
	If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual6 a, @rpt r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
	select * from @rpt Order by  IdClave , Clave, IdClave2
END

Else if @Tipo=16 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual16 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual16
Select CN.IdConcepto  as Clave, sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  
--AND CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
and CFF.IdClave not in (25,26,27)
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo
--Tabla de titulos 
Declare @Titulos16 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos16
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt16 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rpt16
--VALORES RELATIVOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,


 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio


--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG, C_FuenteFinanciamiento CFF
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  

AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
and CFF.IdClave not in (25,26,27)
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt16
select* from @Titulos16 t 
where t.Clave not in (select Clave from @rpt16)


If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End
	Else
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt16 r Where a.Clave = r.Clave
			select * from @rpt16 Order by  IdClave , Clave, IdClave2
		End



END

--Else if @Tipo=2   
--BEGIN  
--declare @Anual2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
--Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
--Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
--Insert into @Anual2  
--Select CR.CLAVE, CR.Nombre,  
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
--sum(ISNULL(0,0)) as Comprometido,   
--sum(ISNULL(0,0)) as Devengado,   
--sum(ISNULL(0,0)) as Ejercido,  
--sum(ISNULL(0,0)) as Pagado,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0)))) - sum(ISNULL(0,0)) As PresDispComp,  
--sum(ISNULL(0,0)) - sum(ISNULL(0,0)) AS CompNoDev,  
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))- sum(ISNULL(0,0))  AS PresSinDev,  
--sum(ISNULL(0,0)) -  sum(ISNULL(0,0)) AS Deuda,  
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) -   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as Amp_Red,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))-  
--sum(ISNULL(0,0)) as SubEjercicio 
--, case FF.IdClave 
--		  when '11' then '11'
--          when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF 
--From T_SellosPresupuestales As TS 
--left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
--left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
--left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--Where (TP.Mes BETWEEN  1 AND 12) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
--group by FF.IdClave,CR.Clave,CR.Nombre
--Order By CR.CLAVE 
----VALORES ABSOLUTOS  
  
--declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
--Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
--Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
--Insert into @rptt  
--Select CR.CLAVE, CR.Nombre,  
--sum(ISNULL(0,0)) as Autorizado,   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaAmp,   
--(sum(ISNULL(0,0)) + sum(ISNULL(0,0))) as TransferenciaRed,   
--(sum(ISNULL(0,0)) + (sum(ISNULL(0,0)) + sum(ISNULL(0,0))) - (sum(ISNULL(0,0)) + sum(ISNULL(0,0))))as Modificado,  
--sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--sum(ISNULL(TP.Devengado,0)) as Devengado,   
--sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--sum(ISNULL(TP.Pagado,0)) as Pagado,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--sum(ISNULL(TP.Devengado,0)) as SubEjercicio 
--, case FF.IdClave 
--		  when '11' then '11'
--          when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF 
--From T_SellosPresupuestales As TS 
--left JOIN C_AreaResponsabilidad As CR  ON TS.IdAreaResp= CR.IdAreaResp 
--left JOIN T_PresupuestoNW As TP ON TS.IdSelloPresupuestal=TP.IdSelloPresupuestal
--left JOIN C_FuenteFinanciamiento As FF  ON TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--Where (TP.Mes BETWEEN  @Mes AND @Mes2) AND TP.[Year]=@Ejercicio AND TS.LYear=@Ejercicio AND TS.IdAreaResp  = CR.IdAreaResp 
--group by FF.IdClave,CR.Clave,CR.Nombre
--Order By CR.CLAVE 
  
--If @AmpRedAnual = 1  
-- Begin  
-- if @MuestraCeros = 0
-- begin
--  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
--  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
--  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @Anual2  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF
--   union 
--  Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @rptt  
--  where IdClaveFF in (11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF)as X
--  group by CLAVE,DESCRIPCION,IdClaveFF
--end
--else
--begin 
--  select CLAVE,DESCRIPCION,  sum(isnull(Autorizado,0)) as Autorizado, sum( isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF 
--  from (Select CLAVE,DESCRIPCION, sum( isnull(Autorizado,0)) as Autorizado, sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum( isnull(Devengado,0)) as Devengado,  sum( isnull(Ejercido,0)) as Ejercido,
--  sum( isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @Anual2  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF
--   union 
--   	Select CLAVE,DESCRIPCION,sum(isnull(Autorizado,0)) as Autorizado,sum(isnull(TransferenciaAmp,0)) as TransferenciaAmp,sum(isnull(TransferenciaRed,0)) as TransferenciaRed,
--  sum(isnull(Modificado,0)) as Modificado,sum(isnull(Comprometido,0)) as Comprometido,sum(isnull(Devengado,0)) as Devengado,  sum(isnull(Ejercido,0)) as Ejercido,
--  sum(isnull(Pagado,0) )as Pagado,sum(isnull(PresDispComp,0)) as PresDispComp,sum(isnull(CompNoDev,0))as CompNoDev,sum(isnull(PresSinDev,0)) as PresSinDev,
--  sum(isnull(Deuda,0))as Deuda,sum(isnull(Amp_Red,0)) as Amp_Red,sum(isnull(SubEjercicio,0) )as SubEjercicio,isnull(IdClaveFF,0) as IdClaveFF   
--  from @rptt  
--  where IdClaveFF in (0,11,12,13,14,15,16,17)
--  group by CLAVE,DESCRIPCION,IdClaveFF)as X
--  group by CLAVE,DESCRIPCION,IdClaveFF
--end
 
-- End  
--END  

Else if @Tipo=2 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
declare @Anual2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @Anual2
Select CR.CLAVE, CR.Nombre,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Devengado,0)) as SubEjercicio 

--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento --and CFF.IdClave not in (25,26,27)
			
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE
--VALORES ABSOLUTOS

declare @rptt as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rptt
Select CR.CLAVE, CR.Nombre,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Devengado,0)) as SubEjercicio 

From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento --and CFF.IdClave not in (25,26,27)
			
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
and CFF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

declare @Titulos2 as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos2
Select 
CR.CLAVE, CR.Nombre,
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			 Where LYear = @Ejercicio
Group by CR.IdAreaResp, CR.Clave, CR.Nombre

Insert into @Anual2 
select * from @Titulos2 t   
where t.Clave not in (select Clave from @Anual2)

--Select * from @rptt order by CLAVE


If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual2 a
		LEFT JOIN @rptt r
		ON a.CLAVE = r.CLAVE
		Order by CLAVE
	End
Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(r.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual2 a
		LEFT JOIN @rptt r
		ON a.CLAVE = r.CLAVE
		Order by CLAVE
	End
END

Else if @Tipo=12 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
declare @Anual12 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @Anual12
Select CR.CLAVE, CR.Nombre,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,   
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio

--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE
--VALORES RELATIVOS
--Consulta para Reporte Ramo o Dependencia Estado del Ejercicio del Presupuesto
declare @rptt12 as table(CLAVE varchar(100),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rptt12
Select CR.CLAVE, CR.Nombre,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio

--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			LEFT JOIN C_FuenteFinanciamiento As CFF ON CFF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento and CFF.IdClave not in (25,26,27)
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

declare @Titulos12 as table(CLAVE varchar(100),DESCRIPCION varchar(max),  
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),  
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos12
Select 
CR.CLAVE, CR.Nombre,
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 JOIN C_AreaResponsabilidad As CR ON CR.IdAreaResp = TS.IdAreaResp
			 Where LYear = @Ejercicio
Group by CR.IdAreaResp, CR.Clave, CR.Nombre

insert into @Anual12  
select* from @Titulos12 t   
where t.Clave not in (select Clave from @Anual12)

If @AprAnual = 1
	Begin
	Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual12 a
		LEFT JOIN @rptt12 r
		ON a.CLAVE = r.CLAVE
		Order by CLAVE
	End
	Else
	Begin
		Select  
		a.CLAVE,a.DESCRIPCION,
		isnull(a.Autorizado,0) as Autorizado, isnull(r.TransferenciaAmp,0) as TransferenciaAmp,isnull(r.TransferenciaRed,0) as TransferenciaRed,isnull(r.Modificado,0) as Modificado,isnull(r.Comprometido,0) as Comprometido,isnull(r.Devengado,0) as Devengado,
		isnull(r.Ejercido,0) as Ejercido,isnull(r.Pagado,0) as Pagado,isnull(r.PresDispComp,0) as PresDispComp,isnull(r.CompNoDev,0) as CompNoDev,isnull(r.PresSinDev,0) as PresSinDev,isnull(r.Deuda,0) as Deuda,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(a.Amp_Red,0)
		ELSE isnull(r.Amp_Red,0) 
		END as Amp_Red,
		isnull(r.SubEjercicio,0) as SubEjercicio 
		from @Anual12 a
		LEFT JOIN @rptt12 r
		ON a.CLAVE = r.CLAVE
		Order by CLAVE
	End
END

Else if @Tipo=7 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual7
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			 
LEFT JOIN C_Subfunciones CS ON TS.IdSubFuncion = CS.IdSubFuncion 		
LEFT JOIN C_funciones  CF ON CS.IdFuncion = CF.IdFuncion 
LEFT JOIN C_Finalidades CFS ON CF.IdFinalidad = CFS.IdFinalidad
LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio   
and FF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

Declare @Titulos7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos7
SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,
0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
FROM C_funciones As CF, C_Finalidades As CFS
WHERE CF.IdFinalidad = CFS.IdFinalidad 
GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad 

Declare @rpt7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

insert into @rpt7
--VALORES ABSOLUTOS 
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
 
sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
--sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Devengado,0)) as SubEjercicio 

From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal		 
LEFT JOIN C_Subfunciones CS ON TS.IdSubFuncion = CS.IdSubFuncion 		
LEFT JOIN C_funciones  CF ON CS.IdFuncion = CF.IdFuncion 
LEFT JOIN C_Finalidades CFS ON CF.IdFinalidad = CFS.IdFinalidad
LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio   
and FF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

insert into @rpt7
select* from @Titulos7 t 
where t.Clave not in (select Clave from @rpt7)

-----------------------------------------------------------------------------
Update @rpt7 set Descripcion = 'A. Gobierno (A=a1+a2+a3+a4+a5+a6+a7+a8)' Where IdClave = 1 
Update @rpt7 set Descripcion2 = ' a1) Legislación' Where  Clave = 11 
Update @rpt7 set Descripcion2 = ' a2) Justicia' Where  Clave = 12
Update @rpt7 set Descripcion2 = ' a3) Coordinación de la Política de Gobierno' Where  Clave = 13
Update @rpt7 set Descripcion2 = ' a4) Relaciones Exteriores' Where  Clave = 14
Update @rpt7 set Descripcion2 = ' a5) Asuntos Financieros y Hacendarios' Where  Clave = 15
Update @rpt7 set Descripcion2 = ' a6) Seguridad Nacional' Where  Clave = 16
Update @rpt7 set Descripcion2 = ' a7) Asuntos de Orden Público y de Seguridad Interior' Where  Clave = 17
Update @rpt7 set Descripcion2 = ' a8) Otros Servicios Generales' Where  Clave = 18

Update @rpt7 set Descripcion = 'B. Desarrollo Social (B=b1+b2+b3+b4+b5+b6+b7)' Where IdClave = 2 
Update @rpt7 set Descripcion2 = ' b1) Protección Ambiental' Where  Clave = 21 
Update @rpt7 set Descripcion2 = ' b2) Vivienda y Servicios a la Comunidad' Where  Clave = 22
Update @rpt7 set Descripcion2 = ' b3) Salud' Where  Clave = 23
Update @rpt7 set Descripcion2 = ' b4) Recreación, Cultura y Otras Manifestaciones Sociales' Where  Clave = 24
Update @rpt7 set Descripcion2 = ' b5) Educación' Where  Clave = 25
Update @rpt7 set Descripcion2 = ' b6) Protección Social' Where  Clave = 26
Update @rpt7 set Descripcion2 = ' b7) Otros Asuntos Sociales' Where  Clave = 27

Update @rpt7 set Descripcion = 'C. Desarrollo Económico (C=c1+c2+c3+c4+c5+c6+c7+c8+c9)' Where IdClave = 3 
Update @rpt7 set Descripcion2 = ' c1) Asuntos Económicos, Comerciales y Laborales en General' Where  Clave = 31 
Update @rpt7 set Descripcion2 = ' c2) Agropecuaria, Silvicultura, Pesca y Caza' Where  Clave = 32
Update @rpt7 set Descripcion2 = ' c3) Combustibles y Energía' Where  Clave = 33
Update @rpt7 set Descripcion2 = ' c4) Minería, Manufacturas y Construcción' Where  Clave = 34
Update @rpt7 set Descripcion2 = ' c5) Transporte' Where  Clave = 35
Update @rpt7 set Descripcion2 = ' c6) Comunicaciones' Where  Clave = 36
Update @rpt7 set Descripcion2 = ' c7) Turismo' Where  Clave = 37
Update @rpt7 set Descripcion2 = ' c8) Ciencia, Tecnología e Innovación' Where  Clave = 38
Update @rpt7 set Descripcion2 = ' c9) Otras Industrias y Otros Asuntos Económicos' Where  Clave = 39

Update @rpt7 set Descripcion = 'D. Otras No Clasificadas en Funciones Anteriores (D=d1+d2+d3+d4)' Where IdClave = 4
Update @rpt7 set Descripcion2 = ' d1) Transacciones de la Deuda Publica / Costo Financiero de la Deuda' Where  Clave = 41 
Update @rpt7 set Descripcion2 = ' d2) Transferencias, Participaciones y Aportaciones Entre Diferentes Niveles y Ordenes de Gobierno' Where  Clave = 42
Update @rpt7 set Descripcion2 = ' d3) Saneamiento del Sistema Financiero' Where  Clave = 43
Update @rpt7 set Descripcion2 = ' d4) Adeudos de Ejercicios Fiscales Anteriores' Where  Clave = 44

-------------------------------------------------------------------------------------



If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave
	End
If @AmpRedAnual = 1
	Begin
		update r set r.Amp_Red = a.Amp_Red FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave
	End
select * from @rpt7 Order by  IdClave , Clave, IdClave2
END

Else if @Tipo=17 --Cualquier modificción realizada en este reporte, favor de efectuarla también en su similar Presupuestal
BEGIN
Declare @Anual17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual17
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
 sum(ISNULL(TP.Autorizado,0)) as Autorizado,
 (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal		 
LEFT JOIN C_Subfunciones CS ON TS.IdSubFuncion = CS.IdSubFuncion 		
LEFT JOIN C_funciones  CF ON CS.IdFuncion = CF.IdFuncion 
LEFT JOIN C_Finalidades CFS ON CF.IdFinalidad = CFS.IdFinalidad
LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio   
and FF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad

declare @Titulos17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos17
SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,
0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
FROM C_funciones As CF, C_Finalidades As CFS
WHERE CF.IdFinalidad = CFS.IdFinalidad 
GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad 

Declare @rpt17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

insert into @rpt17
--VALORES RELATIVOS 
--Consulta para Clasificación Funcional del Ejercicio del Presupuesto  ***
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
sum(ISNULL(TP.Pagado,0)) As Pagado,
    
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As PresDispComp,
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(TP.Ejercido)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(TP.Pagado)) AS Deuda,

(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) )As SubEjercicio

From T_PresupuestoNW As TP JOIN T_SellosPresupuestales As TS ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal		 
LEFT JOIN C_Subfunciones CS ON TS.IdSubFuncion = CS.IdSubFuncion 		
LEFT JOIN C_funciones  CF ON CS.IdFuncion = CF.IdFuncion 
LEFT JOIN C_Finalidades CFS ON CF.IdFinalidad = CFS.IdFinalidad
LEFT JOIN C_FuenteFinanciamiento As FF ON FF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio   
and FF.IdClave not in (25,26,27)
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad

insert into @rpt17
select* from @Titulos17 t 
where t.Clave not in (select Clave from @rpt17)

-----------------------------------------------------------------------------
Update @rpt17 set Descripcion = 'A. Gobierno (A=a1+a2+a3+a4+a5+a6+a7+a8)' Where IdClave = 1 
Update @rpt17 set Descripcion2 = ' a1) Legislación' Where  Clave = 11 
Update @rpt17 set Descripcion2 = ' a2) Justicia' Where  Clave = 12
Update @rpt17 set Descripcion2 = ' a3) Coordinación de la Política de Gobierno' Where  Clave = 13
Update @rpt17 set Descripcion2 = ' a4) Relaciones Exteriores' Where  Clave = 14
Update @rpt17 set Descripcion2 = ' a5) Asuntos Financieros y Hacendarios' Where  Clave = 15
Update @rpt17 set Descripcion2 = ' a6) Seguridad Nacional' Where  Clave = 16
Update @rpt17 set Descripcion2 = ' a7) Asuntos de Orden Público y de Seguridad Interior' Where  Clave = 17
Update @rpt17 set Descripcion2 = ' a8) Otros Servicios Generales' Where  Clave = 18

Update @rpt17 set Descripcion = 'B. Desarrollo Social (B=b1+b2+b3+b4+b5+b6+b7)' Where IdClave = 2 
Update @rpt17 set Descripcion2 = ' b1) Protección Ambiental' Where  Clave = 21 
Update @rpt17 set Descripcion2 = ' b2) Vivienda y Servicios a la Comunidad' Where  Clave = 22
Update @rpt17 set Descripcion2 = ' b3) Salud' Where  Clave = 23
Update @rpt17 set Descripcion2 = ' b4) Recreación, Cultura y Otras Manifestaciones Sociales' Where  Clave = 24
Update @rpt17 set Descripcion2 = ' b5) Educación' Where  Clave = 25
Update @rpt17 set Descripcion2 = ' b6) Protección Social' Where  Clave = 26
Update @rpt17 set Descripcion2 = ' b7) Otros Asuntos Sociales' Where  Clave = 27

Update @rpt17 set Descripcion = 'C. Desarrollo Económico (C=c1+c2+c3+c4+c5+c6+c7+c8+c9)' Where IdClave = 3 
Update @rpt17 set Descripcion2 = ' c1) Asuntos Económicos, Comerciales y Laborales en General' Where  Clave = 31 
Update @rpt17 set Descripcion2 = ' c2) Agropecuaria, Silvicultura, Pesca y Caza' Where  Clave = 32
Update @rpt17 set Descripcion2 = ' c3) Combustibles y Energía' Where  Clave = 33
Update @rpt17 set Descripcion2 = ' c4) Minería, Manufacturas y Construcción' Where  Clave = 34
Update @rpt17 set Descripcion2 = ' c5) Transporte' Where  Clave = 35
Update @rpt17 set Descripcion2 = ' c6) Comunicaciones' Where  Clave = 36
Update @rpt17 set Descripcion2 = ' c7) Turismo' Where  Clave = 37
Update @rpt17 set Descripcion2 = ' c8) Ciencia, Tecnología e Innovación' Where  Clave = 38
Update @rpt17 set Descripcion2 = ' c9) Otras Industrias y Otros Asuntos Económicos' Where  Clave = 39

Update @rpt17 set Descripcion = 'D. Otras No Clasificadas en Funciones Anteriores (D=d1+d2+d3+d4)' Where IdClave = 4
Update @rpt17 set Descripcion2 = ' d1) Transacciones de la Deuda Publica / Costo Financiero de la Deuda' Where  Clave = 41 
Update @rpt17 set Descripcion2 = ' d2) Transferencias, Participaciones y Aportaciones Entre Diferentes Niveles y Ordenes de Gobierno' Where  Clave = 42
Update @rpt17 set Descripcion2 = ' d3) Saneamiento del Sistema Financiero' Where  Clave = 43
Update @rpt17 set Descripcion2 = ' d4) Adeudos de Ejercicios Fiscales Anteriores' Where  Clave = 44

If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
	End

If @AmpRedAnual = 1
	Begin
		update r set r.Amp_Red = a.Amp_Red FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
	End

--Else
--	Begin
--		update r set r.Autorizado = a.Autorizado FROM @Anual17 a, @rpt17 r Where a.Clave = r.Clave
--	End

select * from @rpt17 Order by  IdClave , Clave, IdClave2

END
	
--Else if @Tipo=7   
--BEGIN  
--Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  

--Declare @Anual7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2),IdClaveFF int,Modificado decimal(18,4))  


--Insert into @Anual7Aux  
--Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 
--       ,--(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF 
--	    case FF.IdClave 
--		     when '11' then '11'
--                  when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF
--	   ,(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado           
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS ,c_fuentefinanciamiento FF 
--where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
--AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad,FF.IdClave
--Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   

--insert into @Anual7 
--Select IdClave ,
--Descripcion ,
--Clave,
--Descripcion2 ,
--IdClave2, 
--sum(isnull(Autorizado,0)) , 
--sum(isnull(Amp_Red ,0)),
--IdClaveFF ,
--sum(isnull(Modificado,0))  
--from @Anual7Aux
--group by IdClave ,
--Descripcion ,
--Clave,
--Descripcion2 ,
--IdClave2,
--IdClaveFF 

  
--Declare @Titulos7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  
  
--INSERT INTO @Titulos7  
--SELECT CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--0 as Autorizado, 0 as TransferenciaAmp, 0 as TransferenciaRed, 0 as Modificado, 0 as Comprometido, 0 as Devengado, 0 as Ejercido,  
--0 as Pagado, 0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio  , 0 as IdClaveFF 
--FROM C_funciones As CF, C_Finalidades As CFS  
--WHERE CF.IdFinalidad = CFS.IdFinalidad   
--GROUP BY CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad   
--ORDER BY CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  
--Declare @rpt7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int)  

--Declare @rpt7Aux as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,  
--Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),  
--Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),  
--PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4),IdClaveFF int) 
  
--insert into @rpt7Aux  
----VALORES ABSOLUTOS   
----Consulta para Clasificación Funcional del Ejercicio del Presupuesto  **  
--Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2,   
--sum(ISNULL(TP.Autorizado,0)) as Autorizado,   
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp,   
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,  
--sum(ISNULL(TP.Comprometido,0)) as Comprometido,   
--sum(ISNULL(TP.Devengado,0)) as Devengado,   
--sum(ISNULL(TP.Ejercido,0)) as Ejercido,  
--sum(ISNULL(TP.Pagado,0)) as Pagado,   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,  
--sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,  
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))- sum(ISNULL(TP.Devengado,0))  AS PresSinDev,  
--sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,  
--(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -  
--(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,  
----(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
----(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
----sum(ISNULL(TP.Comprometido,0)) as SubEjercicio   
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-  
--sum(ISNULL(TP.Devengado,0)) as SubEjercicio   
--    ,case FF.IdClave 
--                  when '11' then '11'
--                  when '12' then '11'
--		  when '13' then '11'
--		  when '14' then '11'
--		  when '15' then '11'
--		  when '16' then '11'
--		  when '17' then '11'
--		  when '0' then '0'
--		  else '25'
--		  end as idclaveFF --(select IdClave from c_fuentefinanciamiento where idfuentefinanciamiento = TS.IDFUENTEFINANCIAMIENTO)  as IdClaveFF   
--From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS  ,C_FuenteFinanciamiento As FF 
--where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad   
--AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END  and  TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
--group by CF.Clave,CF.Nombre,FF.IdClave,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
--Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad   
  

--  insert into @rpt7
--   select IdClave,
--   Descripcion,
--   Clave ,
--   Descripcion2 ,
--   IdClave2 ,  
--   Sum(isnull(Autorizado,0)) ,
--    Sum(isnull(TransferenciaAmp,0)) ,
--    Sum(isnull(TransferenciaRed,0))  ,
--    Sum(isnull(Modificado,0))  ,
--    Sum(isnull(Comprometido,0)) ,  
--    Sum(isnull(Devengado,0))  ,
--    Sum(isnull(Ejercido,0))  ,
--    Sum(isnull(Pagado,0))  ,
--    Sum(isnull(PresDispComp,0))  ,
--    Sum(isnull(CompNoDev,0))  ,  
--    Sum(isnull(PresSinDev,0))  ,
--    Sum(isnull(Deuda,0))  ,
--    Sum(isnull(Amp_Red,0))  ,
--    Sum(isnull(SubEjercicio,0))  ,
--   IdClaveFF
--   from @rpt7Aux
--   group by IdClave,
--   Descripcion,
--   Clave ,
--   Descripcion2 ,
--   IdClave2 ,
--   IdClaveFF

--insert into @rpt7  
--select* from @Titulos7 t   
--where t.Clave not in (select Clave from @rpt7)  
  
--If @AmpRedAnual = 1  
-- Begin  
--	update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red,r.Modificado=(a.Autorizado+r.Amp_Red) FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave and a.IdClaveFF in (0,11,12,13,14,15,16,17)--and a.IdClaveFF = r.IdClaveFF
-- End  
----ELse  
---- Begin  
----  update r set r.Autorizado = a.Autorizado FROM @Anual7 a, @rpt7 r Where a.Clave = r.Clave  
---- End  
-- if @MuestraCeros = 0
--		begin
--		select * from @rpt7 where IdClaveFF in (11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--		else
--		begin 
--		select * from @rpt7 where IdClaveFF in (0,11,12,13,14,15,16,17) Order by  IdClave , Clave, IdClave2  
--		end
--END  
END  
GO

EXEC SP_FirmasReporte 'LDF Clasificación por Objeto Gasto(Capitulo y Concepto)'  
GO
EXEC SP_FirmasReporte 'LDF Clasificación Administrativa'  
GO
EXEC SP_FirmasReporte 'LDF Clasificación Funcional (Finalidad Y Función)'  
GO

Exec SP_CFG_LogScripts 'SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado','2.31'
GO
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado @Mes=9,@Mes2=9,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7
--exec SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado @Mes=0,@Mes2=0,@Ejercicio=2017,@MuestraCeros=1,@Tipo=7