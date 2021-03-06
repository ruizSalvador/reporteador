/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]    Script Date: 11/26/2012 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]
GO
/******** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_EstadoEjercicioPresupuestoEGR 1,9,1,2019,'',0,0,0,0,0,0,0
CREATE PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGR] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@ClaveFF as varchar(10),
@IdArea as int,
@AprAnual as bit,
@AmpRedAnual bit,
@IdSello int,
@IdSelloFin int,
@IdPartida int,
@IdCapitulo int


AS
BEGIN


If @Tipo=1 
BEGIN
--VALORES ABSOLUTOS and cf.CLAVE = @ClaveFF
--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
declare @Todo1 as table(IdSelloPresupuestal int, Sello varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

declare @Anual1 as table(IdSelloPresupuestal int, Sello varchar(max), Autorizado decimal(18,2), Amp_Red decimal(18,2))

	If @ClaveFF <> ''
	Begin
	--*****************************************************
		Insert into @Anual1
			Select TP.IdSelloPresupuestal, TS.Sello,
			sum(ISNULL(TP.Autorizado,0)) as Autorizado,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
			From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
			where  (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
			AND CF.CLAVE = @ClaveFF

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal

		--*****************************************************
		If @AprAnual = 0
		Begin
		Insert into @Todo1
			Select TP.IdSelloPresupuestal , TS.Sello, 

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
			(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
			sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

			From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
			where  (Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
			AND CF.CLAVE = @ClaveFF

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal

	    Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0))-ISNULL(T.Comprometido,0)
		ELSE (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0))-ISNULL(T.Comprometido,0) 
		END as SubEjercicio 
		--(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
	end
	ELSE
	begin--Con anual
		
			Insert into @Todo1
			Select TP.IdSelloPresupuestal , TS.Sello, 

			ISNULL(TP.Autorizado,0) as Autorizado, 
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
			(ISNULL(TP.Autorizado,0) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

			sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
			sum(ISNULL(TP.Devengado,0)) as Devengado, 
			sum(ISNULL(TP.Ejercido,0)) as Ejercido,
			sum(ISNULL(TP.Pagado,0)) as Pagado,


			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
			sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
			(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
			sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
			(ISNULL(TP.Autorizado,0) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

			From T_PresupuestoNW As TP 
			Left JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
			where  (Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
			AND CF.CLAVE = @ClaveFF

			group by TP.IdSelloPresupuestal, TS.Sello, TP.Autorizado
			Order By TP.IdSelloPresupuestal

		Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0))-ISNULL(T.Comprometido,0)
		ELSE (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0))-ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		--(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal


		end
	End
	Else
	Begin
	--*********************************************************
			Insert into @Anual1
			Select TP.IdSelloPresupuestal, TS.Sello,
			sum(ISNULL(TP.Autorizado,0)) as Autorizado,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
			From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
			where  (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			and isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			and isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal
			--*********************************************************
		If @AprAnual = 0
		Begin
		
		Insert into @Todo1		
		  Select TP.IdSelloPresupuestal , TS.Sello, 

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
			(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
			sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

			From T_PresupuestoNW As TP, T_SellosPresupuestales As TS 
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
			where  (Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			and isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			and isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal

			Select A.IdSelloPresupuestal, A.Sello,
			ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
			--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
			CASE @AmpRedAnual
			WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
			ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
			END as Modificado,
			ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
			ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
			--ISNULL(T.Amp_Red,0) as Amp_Red, 
			CASE @AmpRedAnual
			WHEN 1 THEN isnull(A.Amp_Red,0)
			ELSE isnull(T.Amp_Red,0) 
			END as Amp_Red,
			CASE @AmpRedAnual
			WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0))-ISNULL(T.Comprometido,0)
			ELSE (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0))-ISNULL(T.Comprometido,0) 
			END as SubEjercicio 
			--(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
			FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
			Order By A.IdSelloPresupuestal
	    End
		Else  --- Considerando Anual aprobado 
			Begin 
			
			Insert into @Todo1
			Select TP.IdSelloPresupuestal , TS.Sello, 
			sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) as Modificado,

			sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
			sum(ISNULL(TP.Devengado,0)) as Devengado, 
			sum(ISNULL(TP.Ejercido,0)) as Ejercido,
			sum(ISNULL(TP.Pagado,0)) as Pagado,


			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
			sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
			(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
			sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,			
			--ISNULL(A.Amp_Red,0) as Amp_Red,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

			From T_PresupuestoNW As TP 
			Left JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento			
			where  (TP.Mes BETWEEN @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			and isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
			and isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
			AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
			AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal

				Select A.IdSelloPresupuestal, A.Sello,
				ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
				--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
				CASE @AmpRedAnual
			WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
			ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
			END as Modificado,
				ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
				ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
				--ISNULL(T.Amp_Red,0) as Amp_Red, 
				CASE @AmpRedAnual
				WHEN 1 THEN isnull(A.Amp_Red,0)
				ELSE isnull(T.Amp_Red,0) 
				END as Amp_Red,
				CASE @AmpRedAnual
			WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0))-ISNULL(T.Comprometido,0)
			ELSE (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0))-ISNULL(T.Comprometido,0) 
			END as SubEjercicio
				--(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
				FROM @Anual1 A LEFT JOIN @Todo1 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
				Order By A.IdSelloPresupuestal

			End
	End
END


Else if @Tipo=2 
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

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
	End
END

    
Else if @Tipo=3 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Fuente Financiamiento Estado del Ejercicio del Presupuesto
Declare @rpt3 as table(Clave varchar(200), Descripcion varchar(max),
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Declare @Anual3 as table(Clave varchar(200), Descripcion varchar(max),
Autorizado decimal(18,4), Amp_Red decimal(18,2))

Insert into @rpt3
	Select CF.CLAVE,CF.DESCRIPCION,
	
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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE 

	
	Insert into @Anual3
	Select CF.CLAVE,CF.DESCRIPCION,
	
	sum(ISNULL(TP.Autorizado,0)) as Autorizado,
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE
	 
	
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
		from @Anual3 a
		LEFT JOIN @rpt3 r
		ON a.CLAVE = r.CLAVE
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
		from @Anual3 a
		LEFT JOIN @rpt3 r
		ON a.CLAVE = r.CLAVE
	End
END

Else if @Tipo=4 
BEGIN
declare @Anual4 as table(CLAVE varchar(2),Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual4
Select CE.CLAVE,
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes = 0)  AND LYear=@Ejercicio  AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 

declare @tablatitulos as table (CLAVE varchar(2),DESCRIPCION varchar(max))
insert into @tablatitulos values('1','Gasto Corriente')
insert into @tablatitulos values('2','Gasto de Capital')
insert into @tablatitulos values('3','Amortización de la Deuda y Disminución de Pasivos')
insert into @tablatitulos values('4','Pensiones y Jubilaciones')
insert into @tablatitulos values('5','Participaciones')
declare @reprte as table(CLAVE varchar(2),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

insert into @reprte
--VALORES ABSOLUTOS
--Consulta para Clasificación Económica Estado del Ejercicio del Presupuesto
Select CE.CLAVE,CE.NOMBRE as DESCRIPCION,

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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio  AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 
insert into @reprte 
select t.clave,t.descripcion,0,0,0,0,0,0,0,0,0,0,0,0,0,0
from @tablatitulos t
where t.CLAVE not in (select CLAVE from @reprte)

If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual4 a, @reprte r Where a.Clave = r.Clave
		--select * from @reprte
End

If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual4 a, @reprte r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
End

select * from @reprte
END

Else if @Tipo=5 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Clasificación Geográfica del Ejercicio del Presupuesto
Select  CC.Clave, CC.Descripcion,

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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ClasificadorGeograficoPresupuestal As CC
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CC.Clave,CC.Descripcion
Order By CC.Clave
END

Else if @Tipo=6
BEGIN 
Declare @Anual6 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual6
Select CN.IdConcepto  as Clave, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt
select* from @Titulos t 
where t.Clave not in (select Clave from @rpt)

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


Else if @Tipo=7 
BEGIN
Declare @Anual7 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual7
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes = 0)	 AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
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


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2)	 AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

insert into @rpt7
select* from @Titulos7 t 
where t.Clave not in (select Clave from @rpt7)

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
 
Else if @Tipo=8  
BEGIN
--VALORES ABSOLUTOS
--Consulta para Clasificación Funcional y SubFunción del Ejercicio del Presupuesto **
Declare @rpt8 as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Declare @Anual8 as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Autorizado decimal(18,4))

Declare @Anual8Amp as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Amp_Red decimal(18,4))

Insert into @rpt8
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave,CFS.IdFinalidad

If @AprAnual = 1
	Begin
	Insert into @Anual8
	Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	sum(ISNULL(TP.Autorizado,0)) as Autorizado

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
	where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
	AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave,CFS.IdFinalidad

		update r set r.Autorizado = a.Autorizado FROM @Anual8 a JOIN @rpt8 r ON a.IdClave = r.IdClave and a.IdComp2 = r.IdComp2 and a.IdComp2a = r.IdComp2a and a.IdComp3 = r.IdComp3 and a.IdClave2 = r.IdClave2 and a.IdClave3 = r.IdClave3
	End

	If @AmpRedAnual = 1
	Begin
	Insert into @Anual8Amp	
	Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
	where (Mes = 0)  AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
	AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave,CFS.IdFinalidad

		update r set r.Amp_Red = a.Amp_Red FROM @Anual8Amp a JOIN @rpt8 r ON a.IdClave = r.IdClave and a.IdComp2 = r.IdComp2 and a.IdComp2a = r.IdComp2a and a.IdComp3 = r.IdComp3 and a.IdClave2 = r.IdClave2 and a.IdClave3 = r.IdClave3
	End


select * from @rpt8 Order by  IdClave2 , IdClave3, IdClave
END


Else if @Tipo=9 
BEGIN 
--VALORES ABSOLUTOS 
--Consulta para Clasificación Económica y Capítulo del Gasto del Ejercicio del Presupuesto **
Declare @rpt9 as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))


Declare @Anual9 as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Autorizado decimal(18,4))
Declare @Anual9Amp as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Amp_Red decimal(18,4))


Insert into @rpt9
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   

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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END

Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo 

If @AprAnual = 1
	Begin
	Insert into @Anual9
	Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   
	sum(ISNULL(TP.Autorizado,0)) as Autorizado 

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
	AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
	Order by CE.Clave, CG.IdCapitulo 

	update r set r.Autorizado = a.Autorizado FROM @Anual9 a, @rpt9 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

If @AmpRedAnual = 1
	Begin
	Insert into @Anual9Amp
	Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
	AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
	Order by CE.Clave, CG.IdCapitulo 

	update r set r.Amp_Red = a.Amp_Red FROM @Anual9Amp a, @rpt9 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

select * from @rpt9 Order by Clave, IdCapitulo

END

Else if @Tipo=10 
BEGIN
--VALORES ABSOLUTOS
Declare @Anual10 as table(ClavePartida int,DescripcionPartida varchar(max), DESCRIPCION Varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp decimal(18,2),
TransferenciaRed decimal(18,2), Amp_Red decimal(18,2))

declare @Todo as table(ClavePartida int, DescripcionPartida varchar(max), DESCRIPCION varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

Insert into @Anual10
Select CPG.IdPartidaGenerica as ClavePartida, CPG.DescripcionPartida , CF.DESCRIPCION,
		CF.IDFUENTEFINANCIAMIENTO,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto

	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, 	CF.IDFUENTEFINANCIAMIENTO
	Order By  CPG.IdPartidaGenerica  , CPG.DescripcionPartida ,cf.DESCRIPCION

--Consulta para Partida Genérica y Fuente del Gasto del Ejercicio del Presupuesto
If @ClaveFF <> '' 
begin
Insert into @Todo
Select CPG.IdPartidaGenerica as ClavePartida , CPG.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,	
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
(sum(ISNULL(TP.Autorizado,0)) + ((sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))as Modificado,
 
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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By  CPG.IdPartidaGenerica  , CPG.DescripcionPartida ,cf.DESCRIPCION

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		When 1 Then (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		End as SubEjercicio
		FROM @Anual10 A LEFT JOIN @Todo T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		When 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		End as SubEjercicio
		FROM @Anual10 A LEFT JOIN @Todo T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
end
else if @ClaveFF = 0
begin
Insert into @Todo
Select CPG.IdPartidaGenerica as ClavePartida , CPG.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
--(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
(sum(ISNULL(TP.Autorizado,0)) + ((sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))))as Modificado,
 
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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, 	CF.IDFUENTEFINANCIAMIENTO
	Order By  CPG.IdPartidaGenerica  , CPG.DescripcionPartida ,cf.DESCRIPCION

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual 
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		END as SubEjercicio
		FROM @Anual10 A LEFT JOIN @Todo T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		--Select * from @Todo Order By ClavePartida, DescripcionPartida, DESCRIPCION
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		FROM @Anual10 A LEFT JOIN @Todo T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
end	
END

Else if @Tipo=22 
BEGIN
--VALORES ABSOLUTOS
--Consulta para Partida Específica y Fuente del Gasto del Ejercicio del Presupuesto

declare @Todo22 as table(ClavePartida int, DescripcionPartida varchar(max), Descripcion varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

declare @Anual22 as table(ClavePartida int, DescripcionPartida varchar(max), Descripcion varchar(max), IDFUENTEFINANCIAMIENTO int,Autorizado decimal(18,2), Amp_Red decimal(18,2))


If @ClaveFF <> '' 
begin
Insert into @Anual22
Select CP.IdPartida as ClavePartida , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
 
	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By  CP.IdPartida  , CP.DescripcionPartida ,cf.DESCRIPCION

Insert into @Todo22
Select CP.IdPartida as ClavePartida , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and cf.CLAVE = @ClaveFF and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By  CP.IdPartida  , CP.DescripcionPartida ,cf.DESCRIPCION

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual 
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		END as SubEjercicio
		FROM @Anual22 A LEFT JOIN @Todo22 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		FROM @Anual22 A LEFT JOIN @Todo22 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
end
else if @ClaveFF = 0
begin
Insert into @Anual22
Select CP.IdPartida as ClavePartida , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By  CP.IdPartida  , CP.DescripcionPartida ,cf.DESCRIPCION
--end	

Insert into @Todo22
Select CP.IdPartida as ClavePartida , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
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
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio 


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By  CP.IdPartida  , CP.DescripcionPartida ,cf.DESCRIPCION

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual 
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		END as SubEjercicio
		FROM @Anual22 A LEFT JOIN @Todo22 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		FROM @Anual22 A LEFT JOIN @Todo22 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
end	

	

END



--***********************************--VALORES RELATIVOS--*******************************--

If @Tipo=11 
BEGIN
--VALORES RELATIVOS

	declare @Anual11 as table(IdSelloPresupuestal int, Sello varchar(max),
	Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4), Amp_Red decimal(18,2))

	declare @Todo11 as table(IdSelloPresupuestal int, Sello varchar(max),
	Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
	Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

--Consulta para Reporte General Estado del Ejercicio del Presupuesto 
	If @ClaveFF <> ''
	Begin
	--******************************************************************************************
		Insert into @Anual11
		Select TP.IdSelloPresupuestal, TS.Sello, 
		sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

		From T_PresupuestoNW As TP
		LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
		LEFT JOIN @Anual11 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal 
		LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
		LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
		LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
		LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
		where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
		AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
		ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
		AND CF.CLAVE = @ClaveFF
		group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
		Order By TP.IdSelloPresupuestal
		--******************************************************************************************
		IF @AprAnual = 0
		Begin
		Insert into @Todo11
		Select TP.IdSelloPresupuestal, TS.Sello, 


		sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


		sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
		sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
		sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
		sum(ISNULL(TP.Pagado,0)) As Pagado,


		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
		(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) AS CompNoDev,
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
		(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0))) AS Deuda,
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
		sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


		From T_PresupuestoNW As TP, T_SellosPresupuestales As TS
		LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
		LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
		LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
		LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
		where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
		AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
		ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
		AND CF.CLAVE = @ClaveFF
		group by TP.IdSelloPresupuestal, TS.Sello
		Order By TP.IdSelloPresupuestal

		 Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		(ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual11 A LEFT JOIN @Todo11 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
		End
		ELSE--Con anual
		Begin
		
		Insert into @Todo11
		Select TP.IdSelloPresupuestal, TS.Sello, 

		sum(ISNULL(TP.Autorizado,0)) as Autorizado,  
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


		sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
		sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
		sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
		sum(ISNULL(TP.Pagado,0)) As Pagado,


		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
		(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) AS CompNoDev,
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
		(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0))) AS Deuda,
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
		(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As SubEjercicio

		From T_PresupuestoNW As TP
		LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
		LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
		LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
		LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
		LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
		where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
		AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
		ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
		AND CF.CLAVE = @ClaveFF
		group by TP.IdSelloPresupuestal, TS.Sello
		Order By TP.IdSelloPresupuestal

		 Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual11 A LEFT JOIN @Todo11 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
		End
	End
	Else
	Begin
	--*******************************************************************************
		Insert into @Anual11
		Select TP.IdSelloPresupuestal, Ts.Sello,
		sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
		(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
		(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
		(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

		From T_PresupuestoNW As TP, T_SellosPresupuestales As TS
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
			where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal
		--*******************************************************************************
		IF @AprAnual = 0
		Begin
		Insert into @Todo11
		Select TP.IdSelloPresupuestal, TS.Sello, 

			sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


			sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
			sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
			sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
			sum(ISNULL(TP.Pagado,0)) As Pagado,


			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
			(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) AS CompNoDev,
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
			(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0))) AS Deuda,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


			From T_PresupuestoNW As TP, T_SellosPresupuestales As TS
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
			where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello
			Order By TP.IdSelloPresupuestal

			 Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		(ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual11 A LEFT JOIN @Todo11 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
		End
		ELSE
		Begin--Con anual
		

		Insert into @Todo11
			Select TP.IdSelloPresupuestal, TS.Sello, 

			ISNULL(A.Autorizado,0) as Autorizado, 
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
			(ISNULL(A.Autorizado,0) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,


			sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As Comprometido,
			sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
			sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0)) As Ejercido,
			sum(ISNULL(TP.Pagado,0)) As Pagado,


			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - ((sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)))) As PresDispComp,
			(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) AS CompNoDev,
			(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - (sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)))  AS PresSinDev,
			(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) -  (sum(ISNULL(TP.Ejercido,0)) - sum(ISNULL(TP.Pagado,0))) AS Deuda,
			(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
			(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
			(ISNULL(A.Autorizado,0) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
			(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As SubEjercicio


			From T_PresupuestoNW As TP
			LEFT JOIN T_SellosPresupuestales As TS  ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			LEFT JOIN @Anual11 as A  ON A.IdSelloPresupuestal = TP.IdSelloPresupuestal
			LEFT JOIN C_PartidasPres As CP ON CP.IdPartida = TS.IdPartida
			LEFT JOIN C_ConceptosNEP As CN ON CN.IdConcepto = CP.IdConcepto
			LEFT JOIN C_CapitulosNEP As CG ON CG.IdCapitulo = CN.IdCapitulo
			LEFT JOIN C_FuenteFinanciamiento As CF ON CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento 
			where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
			AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
			ANd isnull(TP.IdSelloPresupuestal,0) >= case when @IdSello = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSello end  
		ANd isnull(TP.IdSelloPresupuestal,0) <= case when @IdSelloFin = 0 then isnull(TP.IdSelloPresupuestal,0) else @IdSelloFin end
		AND TS.IdPartida = CASE WHEN @IdPartida = 0 THEN TS.IdPartida ELSE @IdPartida END
		AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END

			group by TP.IdSelloPresupuestal, TS.Sello, A.Autorizado
			Order By TP.IdSelloPresupuestal

	 --   Select A.IdSelloPresupuestal, A.Sello,
		--ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		--ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		--ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, ISNULL(T.Amp_Red,0) as Amp_Red, 
		--(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		--FROM @Anual11 A LEFT JOIN @Todo11 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		--Order By A.IdSelloPresupuestal

		 Select A.IdSelloPresupuestal, A.Sello,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual11 A LEFT JOIN @Todo11 T ON A.IdSelloPresupuestal = T.IdSelloPresupuestal
		Order By A.IdSelloPresupuestal
		End
	End
END

Else if @Tipo=12
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
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  1 AND 12) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
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

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_AreaResponsabilidad As CR
where  (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CR.IdAreaResp = TS.IdAreaResp
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CR.CLAVE, CR.Nombre 
Order By CR.CLAVE

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
	End
END

Else if @Tipo=13
BEGIN
--VALORES RELATIVOS
--Consulta para Fuente Financiamiento Estado del Ejercicio del Presupuesto
Declare @rpt13 as table(Clave varchar(200), Descripcion varchar(max),
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Declare @Anual13 as table(Clave varchar(200), Descripcion varchar(max),
Autorizado decimal(18,4), Amp_Red decimal(18,2))

Insert into @rpt13
	Select CF.CLAVE,CF.DESCRIPCION,
	
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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE 

	Insert into @Anual13
		Select CF.CLAVE,CF.DESCRIPCION,	
	sum(ISNULL(TP.Autorizado,0)) as Autorizado,
	(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CF.CLAVE,CF.DESCRIPCION
	Order By CF.CLAVE 
	 
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
		from @Anual13 a
		LEFT JOIN @rpt13 r
		ON a.CLAVE = r.CLAVE
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
		from @Anual13 a
		LEFT JOIN @rpt13 r
		ON a.CLAVE = r.CLAVE
	End

END	
	
Else if @Tipo=14 
BEGIN
declare @Anual14 as table(CLAVE varchar(2),Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual14
Select CE.CLAVE, sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 	

declare @tablatitulos2 as table (CLAVE varchar(2),DESCRIPCION varchar(max))
insert into @tablatitulos2 values('1','Gasto Corriente')
insert into @tablatitulos2 values('2','Gasto de Capital')
insert into @tablatitulos2 values('3','Amortización de la Deuda y Disminución de Pasivos')
insert into @tablatitulos2 values('4','Pensiones y Jubilaciones')
insert into @tablatitulos2 values('5','Participaciones')
declare @reprte2 as table(CLAVE varchar(2),DESCRIPCION varchar(max),
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

insert into @reprte2
--VALORES RELATIVOS
--Consulta para Clasificación Económica Estado del Ejercicio del Presupuesto
Select CE.CLAVE,CE.NOMBRE as DESCRIPCION,


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


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CE.CLAVE, CE.NOMBRE
Order By CE.CLAVE 	

--Select * from @reprte2

insert into @reprte2 
select t.clave,t.descripcion,0,0,0,0,0,0,0,0,0,0,0,0,0,0
from @tablatitulos2 t
where t.CLAVE not in (select CLAVE from @reprte2)

--Select * from @reprte2
If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual14 a, @reprte2 r Where a.Clave = r.Clave			
		End

If @AprAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual14 a, @reprte2 r Where a.Clave = r.Clave
		select * from @reprte2 
	End
Else
	Begin
		update r set r.Autorizado = a.Autorizado FROM @Anual14 a, @reprte2 r Where a.Clave = r.Clave
		select * from @reprte2 
	End

	
END

Else if @Tipo=15 
BEGIN
--VALORES RELATIVOS
--Consulta para Clasificación Geográfica del Ejercicio del Presupuesto
Select  CC.Clave, CC.Descripcion,


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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ClasificadorGeograficoPresupuestal As CC
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio  AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CC.IdClasificadorGeografico = TS.IdClasificadorGeografico
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CC.Clave,CC.Descripcion
Order By CC.Clave
END

Else if @Tipo=16 
BEGIN
Declare @Anual16 as table(Clave int, Autorizado decimal(18,4), Amp_Red decimal (18,2))
Insert into @Anual16
Select CN.IdConcepto  as Clave, sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo
--Tabla de titulos 
Declare @Titulos2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

INSERT INTO @Titulos2
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Autorizado, 0 as TransferenciaAmp,  0 as TransferenciaRed, 0 as Modificado,0 as Comprometido, 0 as Devengado, 0 as Ejercido,0 as Pagado, 
0 As PresDispComp, 0 AS CompNoDev, 0 AS PresSinDev, 0 AS Deuda, 0 as Amp_Red, 0 as SubEjercicio 
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt2 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))
Insert into @rpt2
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


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio  AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt2
select* from @Titulos2 t 
where t.Clave not in (select Clave from @rpt2)


If @AmpRedAnual = 1
		Begin
			update r set r.Amp_Red = a.Amp_Red FROM @Anual16 a, @rpt2 r Where a.Clave = r.Clave
			--select * from @rpt Order by  IdClave , Clave, IdClave2
		End
If @AprAnual = 1
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt2 r Where a.Clave = r.Clave
			select * from @rpt2 Order by  IdClave , Clave, IdClave2
		End
	Else
		Begin
			update r set r.Autorizado = a.Autorizado FROM @Anual16 a, @rpt r Where a.Clave = r.Clave
			select * from @rpt2 Order by  IdClave , Clave, IdClave2
		End



END
	
	
Else if @Tipo=17 
BEGIN
Declare @Anual17 as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Autorizado decimal(18,4), Amp_Red decimal(18,2))
Insert into @Anual17
Select CFS.Clave as IdClave,  CFS.Nombre as Descripcion, CF.Clave as Clave, CF.Nombre as Descripcion2 , CFS.IdFinalidad as IdClave2, 
 sum(ISNULL(TP.Autorizado,0)) as Autorizado,
 (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
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


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND TS.IdSubFuncion = CS.IdSubFuncion AND  CS.IdFuncion = CF.IdFuncion AND CF.IdFinalidad = CFS.IdFinalidad 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CF.Clave,CF.Nombre,  CFS.Clave, CFS.Nombre,CFS.IdFinalidad 
Order By CF.Clave,  CFS.Clave,CFS.IdFinalidad 

insert into @rpt17
select* from @Titulos17 t 
where t.Clave not in (select Clave from @rpt17)


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

Else if @Tipo=18 
BEGIN
--VALORES RELATIVOS
--Consulta para Clasificación Funcional y SubFunción del Ejercicio del Presupuesto **
Declare @rpt18 as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Declare @Anual18 as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Autorizado decimal(18,4))

Declare @Anual18Amp as table(IdClave int,Descripcion varchar(max), IdClave2 varchar(200), Descripcion2 Varchar(max), IdComp2 int, IdComp2a int, IdClave3 varchar(200), Descripcion3 Varchar(max), IdComp3 int,
Amp_Red decimal(18,4))

Insert into @rpt18
Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion 
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
Order By CF.Clave, CS.Clave, CF.IdFinalidad

If @AprAnual = 1
	Begin
	Insert into @Anual18
		 Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	 sum(ISNULL(TP.Autorizado,0)) as Autorizado

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
	AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave, CF.IdFinalidad

	update r set r.Autorizado = a.Autorizado FROM @Anual18 a JOIN @rpt18 r ON a.IdClave = r.IdClave and a.IdComp2 = r.IdComp2 and a.IdComp2a = r.IdComp2a and a.IdComp3 = r.IdComp3 and a.IdClave2 = r.IdClave2 and a.IdClave3 = r.IdClave3
	End

	If @AmpRedAnual = 1
	Begin
	Insert into @Anual18Amp	
	Select CFS.IdFinalidad as IdClave, CFS.Nombre as Descripcion, CF.Clave as IdClave2,  CF.Nombre as Descripcion2, CF.IdFinalidad as IdComp2, cf.IdFuncion as IdComp2a, CS.Clave as IdClave3, CS.Nombre  as Descripcion3, cs.IdFuncion as IdComp3,

	 (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
	(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red 

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_funciones As CF, C_Subfunciones As CS, C_Finalidades As CFS
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CS.IdSubFuncion = TS.IdSubFuncion 
	AND CF.IdFinalidad = CFS.IdFinalidad AND CF.IdFuncion = CS.IdFuncion 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CFS.IdFinalidad, CFS.Nombre, CF.Clave, CF.Nombre, CF.IdFinalidad , CS.Clave, CS.Nombre, cs.IdFuncion, cf.IdFuncion 
	Order By CF.Clave, CS.Clave, CF.IdFinalidad

	update r set r.Amp_Red = a.Amp_Red FROM @Anual18Amp a JOIN @rpt18 r ON a.IdClave = r.IdClave and a.IdComp2 = r.IdComp2 and a.IdComp2a = r.IdComp2a and a.IdComp3 = r.IdComp3 and a.IdClave2 = r.IdClave2 and a.IdClave3 = r.IdClave3
	End

 select * from @rpt18 Order by  IdClave2 , IdClave3, IdClave

END

Else if @Tipo=19 
BEGIN
--VALORES RELATIVOS 
--Consulta para Clasificación Económica y Capitulo del Gasto del Ejercicio del Presupuesto **

Declare @rpt19 as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Declare @Anual19 as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Autorizado decimal(18,4))
Declare @Anual19Amp as table(Clave varchar(200), IdCapitulo int, Descripcion varchar(max),
Amp_Red decimal(18,4))

Insert into @rpt19
Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   

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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END

Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
Order by CE.Clave, CG.IdCapitulo  

If @AprAnual = 1
	Begin
	Insert into @Anual19
		Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   

	 sum(ISNULL(TP.Autorizado,0)) as Autorizado

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
	AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END

	Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
	Order by CE.Clave, CG.IdCapitulo 

	update r set r.Autorizado = a.Autorizado FROM @Anual19 a, @rpt19 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

If @AmpRedAnual = 1
	Begin
	Insert into @Anual19
		Select  CE.Clave, CG.IdCapitulo, CG.Descripcion,   

	 (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_TipoGasto As CE, C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CE.IDTIPOGASTO = TS.IdTipoGasto  AND CP.IdPartida = TS.IdPartida 
	AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END

	Group by CG.IdCapitulo, CG.Descripcion, CE.Clave 
	Order by CE.Clave, CG.IdCapitulo 

	update r set r.Autorizado = a.Autorizado FROM @Anual19 a, @rpt19 r Where a.Clave = r.Clave and a.IdCapitulo = r.IdCapitulo
	End

 select * from @rpt19 Order by Clave, IdCapitulo

END

Else if @Tipo=20
BEGIN
--VALORES RELATIVOS
Declare @Anual20 as table(ClavePartida int,DescripcionPartida varchar(max), DESCRIPCION Varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp decimal(18,2),
TransferenciaRed decimal(18,2), Amp_Red decimal(18,2))

declare @Todo20 as table(ClavePartida int, DescripcionPartida varchar(max), DESCRIPCION varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))
--Consulta para Partida Genérica y Fuente del Gasto del Ejercicio del Presupuesto

Insert into @Anual20
Select CPG.IdPartidaGenerica as ClavePartida  , CPG.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) -
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CPG.IdPartidaGenerica  , CPG.DescripcionPartida 

if @ClaveFF <> ''
begin
Insert into @Todo20
Select CPG.IdPartidaGenerica as ClavePartida  , CPG.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

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
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  cf.CLAVE = @ClaveFF and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CPG.IdPartidaGenerica  , CPG.DescripcionPartida

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual20 A LEFT JOIN @Todo20 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual20 A LEFT JOIN @Todo20 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
		end
	
end
else if @ClaveFF = 0
begin
Insert into @Todo20
Select CPG.IdPartidaGenerica as ClavePartida  , CPG.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

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
(sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0))) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG, C_CapitulosNEP As CG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CG.IdCapitulo = CN.IdCapitulo
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	AND CG.IdCapitulo = CASE WHEN @IdCapitulo = 0 THEN CG.IdCapitulo ELSE @IdCapitulo END
	group by CPG.IdPartidaGenerica  , CPG.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CPG.IdPartidaGenerica  , CPG.DescripcionPartida

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado,
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red, 
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual20 A LEFT JOIN @Todo20 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		--Select * from @Todo Order By ClavePartida, DescripcionPartida, DESCRIPCION
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		--ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) as Modificado, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		--ISNULL(T.Amp_Red,0) as Amp_Red, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		(ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) as SubEjercicio
		FROM @Anual20 A LEFT JOIN @Todo20 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End

end

END

Else if @Tipo=23
BEGIN
--VALORES RELATIVOS
--Consulta para Partida Específica y Fuente del Gasto del Ejercicio del Presupuesto

declare @Todo23 as table(ClavePartida int, DescripcionPartida varchar(max), Descripcion varchar(max), IDFUENTEFINANCIAMIENTO int,
Autorizado decimal(18,4), TransferenciaAmp  decimal(18,4),TransferenciaRed  decimal(18,4),Modificado  decimal(18,4),Comprometido  decimal(18,4),Devengado  decimal(18,4),
Ejercido  decimal(18,4),Pagado  decimal(18,4),PresDispComp  decimal(18,4),CompNoDev  decimal(18,4),PresSinDev  decimal(18,4),Deuda  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4))

declare @Anual23 as table(ClavePartida int, DescripcionPartida varchar(max), Descripcion varchar(max), IDFUENTEFINANCIAMIENTO int,Autorizado decimal(18,2), Amp_Red decimal(18,2))

if @ClaveFF <> ''
begin
Insert Into @Todo23
Select CP.IdPartida as ClavePartida  , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  cf.CLAVE = @ClaveFF and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CP.IdPartida  , CP.DescripcionPartida

	Insert Into @Anual23
	Select CP.IdPartida as ClavePartida  , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,
 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and  cf.CLAVE = @ClaveFF and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto 
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CP.IdPartida  , CP.DescripcionPartida

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual 
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		END as SubEjercicio
		FROM @Anual23 A LEFT JOIN @Todo23 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		FROM @Anual23 A LEFT JOIN @Todo23 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End

end
else if @ClaveFF = 0
begin
Insert Into @Todo23
Select CP.IdPartida as ClavePartida  , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

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
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) As SubEjercicio


	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CP.IdPartida  , CP.DescripcionPartida

	Insert Into @Anual23
	Select CP.IdPartida as ClavePartida  , CP.DescripcionPartida , CF.DESCRIPCION,
	CF.IDFUENTEFINANCIAMIENTO,

 sum(ISNULL(TP.Autorizado,0)) as Autorizado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red

	From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_FuenteFinanciamiento As CF, C_ConceptosNEP as CN, C_PartidasPres as CP , C_PartidasGenericasPres AS CPG
	where (Mes = 0) AND LYear=@Ejercicio AND Year=@Ejercicio and TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND  TS.IdPartida  = CP.IdPartida  AND cP.IdConcepto  = CN.IdConcepto and CPG.IdPartidaGenerica =CP.IdPartidaGenerica 
	AND CF.IDFUENTEFINANCIAMIENTO = TS.IdFuenteFinanciamiento AND CN.IdConcepto = CPG.IdConcepto
	AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END 
	group by CP.IdPartida  , CP.DescripcionPartida , CF.DESCRIPCION, CF.IDFUENTEFINANCIAMIENTO
	Order By CP.IdPartida  , CP.DescripcionPartida

	If @AprAnual = 1
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(A.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado, 
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual 
		WHEN 1 THEN (ISNULL(A.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(A.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0)
		END as SubEjercicio
		FROM @Anual23 A LEFT JOIN @Todo23 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
	Else
	Begin
		Select A.ClavePartida, A.DescripcionPartida, A.DESCRIPCION, A.IDFUENTEFINANCIAMIENTO,
		ISNULL(T.Autorizado,0) as Autorizado, ISNULL(T.TransferenciaAmp,0) as TransferenciaAmp, ISNULL(T.TransferenciaRed,0) as TransferenciaRed, 
		CASE @AmpRedAnual
		WHEN 1 THEN ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)
		ELSE ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0) 
		END as Modificado,
		ISNULL(T.Comprometido,0) as Comprometido, ISNULL(T.Devengado,0) as Devengado,
		ISNULL(T.Ejercido,0) as Ejercido, ISNULL(T.Pagado,0) as Pagado, ISNULL(T.PresDispComp,0) as PresDispComp, ISNULL(T.CompNoDev,0) as CompNoDev, ISNULL(T.PresSinDev,0) as PresSinDev, ISNULL(T.Deuda,0) as Deuda, 
		CASE @AmpRedAnual
		WHEN 1 THEN isnull(A.Amp_Red,0)
		ELSE isnull(T.Amp_Red,0) 
		END as Amp_Red,
		CASE @AmpRedAnual
		WHEN 1 THEN (ISNULL(T.Autorizado,0) + ISNULL(A.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		Else (ISNULL(T.Autorizado,0) + ISNULL(T.Amp_Red,0)) - ISNULL(T.Comprometido,0) 
		END as SubEjercicio
		FROM @Anual23 A LEFT JOIN @Todo23 T ON A.ClavePartida = T.ClavePartida
		AND A.IDFUENTEFINANCIAMIENTO = T.IDFUENTEFINANCIAMIENTO
	End
end

END
--------------------------------------------------------------------------------------------
----------------DM---------------------------------------------------------------------------
Else if @Tipo=21
BEGIN 

--Tabla de titulos 
Declare @TitulosDM as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
AutorizadoAnual decimal(18,4),AutorizadoMes decimal(18,4), EjercidoMes decimal(18,4), EjercidoAcumulado decimal(18,4),PorEjercerAcumulado decimal(18,4))

INSERT INTO @TitulosDM
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as AutorizadoAnual, 0 as AutorizadoMes, 0 as EjercidoMes, 0 as EjercidoAcumulado, 0 as PorEjercerAcumulado
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rptDM as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
AutorizadoAnual decimal(18,4),AutorizadoMes decimal(18,4), EjercidoMes decimal(18,4), EjercidoAcumulado decimal(18,4),PorEjercerAcumulado decimal(18,4))

Insert into @rptDM
--Consulta para obtener el Presupuesto Autorizado Anual **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
sum(ISNULL(TP.Autorizado,0)) as AutorizadoAnual, 
0 as AutorizadoMes, 
0 as EjercidoMes,
0 as EjercidoAcumulado,
0 as PorEjercerAcumulado
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = 0 ) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

Insert into @rptDM
--Consulta para obtener el Presupuesto Autorizado Mensual y el Ejercido Mensual**
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
0 as AutorizadoAnual, 
sum(ISNULL(TP.Autorizado,0)) as AutorizadoMes, 
sum(ISNULL(TP.Ejercido,0)) as EjercidoMes,
0 as EjercidoAcumulado,
0 as PorEjercerAcumulado
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = @Mes ) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo



Insert into @rptDM
--Consulta para obtener el Presupuesto Ejercido Acumulado**
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
0 as AutorizadoAnual, 
0 as AutorizadoMes, 
0 as EjercidoMes,
sum(ISNULL(TP.Ejercido,0)) as EjercidoAcumulado,
0 as PorEjercerAcumulado
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  1 AND @Mes) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo


insert into @rptDM
select *
from @TitulosDM t 
where t.Clave not in (select Clave from @rptDM)

select IdClave,Descripcion,Clave,Descripcion2,IdClave2,SUM(AutorizadoAnual) as AutorizadoAnual,SUM(AutorizadoMes) as AutorizadoMes ,
SUM(EjercidoMes) as EjercidoMes,SUM(EjercidoAcumulado) as EjercidoAcumulado,(SUM(AutorizadoAnual)-SUM(EjercidoAcumulado)) as PorEjercerAcumulado 
from @rptDM 
Group BY IdClave,Descripcion,Clave,Descripcion2,IdClave2
Order by  IdClave , Clave, IdClave2
END

-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
 
END

GO




Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación General'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Ramo o Dependencia'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Fuente Financiamiento'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Económica'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Geográfica'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Capítulo del Gasto'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Funcional'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Funcional-Subfunción'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Económica y Capítulo de Gasto'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Partida Genérica y Fuente de Financiamiento'
GO
Exec SP_FirmasReporte 'Ejercicio del Presupuesto Clasificación Administrativa'
GO
Exec SP_FirmasReporte 'Control Presupuestal del Egreso'
GO
--Exec SP_CFG_LogScripts 'SP_RPT_EstadoEjercicioPresupuestoEGR','2.29'
--GO


--Exec SP_RPT_EstadoEjercicioPresupuestoEGR 6,1,21,2015,''

