/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal_Devengado]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Control_Presupuestal_Devengado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Control_Presupuestal_Devengado]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Control_Presupuestal_Devengado]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_Control_Presupuestal_Devengado 2,2019
CREATE PROCEDURE [dbo].[SP_RPT_Control_Presupuestal_Devengado]

@Mes  as int, 
@Ejercicio as int

AS

--------------------------------------------------------
--Tabla de titulos 
Declare @TitulosDM as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
AutorizadoAnual decimal(18,4),AutorizadoMes decimal(18,4), DevengadoMes decimal(18,4), DevengadoAcumulado decimal(18,4),PorEjercerAcumulado decimal(18,4))

INSERT INTO @TitulosDM
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as AutorizadoAnual, 0 as AutorizadoMes, 0 as DevengadoMes, 0 as DevengadoAcumulado, 0 as PorEjercerAcumulado
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rptDM as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,
AutorizadoAnual decimal(18,4),AutorizadoMes decimal(18,4), DevengadoMes decimal(18,4), DevengadoAcumulado decimal(18,4),PorEjercerAcumulado decimal(18,4))

Insert into @rptDM
--Consulta para obtener el Presupuesto Autorizado Anual **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
sum(ISNULL(TP.Autorizado,0)) as AutorizadoAnual, 
0 as AutorizadoMes, 
0 as DevengadoMes,
0 as DevengadoAcumulado,
0 as PorEjercerAcumulado
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = 0 ) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

Insert into @rptDM
--Consulta para obtener el Presupuesto Autorizado Mensual y el Devengado Mensual**
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
0 as AutorizadoAnual, 
sum(ISNULL(TP.Autorizado,0)) as AutorizadoMes, 
sum(ISNULL(TP.Devengado,0)) as DevengadoMes,
0 as DevengadoAcumulado,
0 as PorEjercerAcumulado
From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes = @Mes ) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--where (Mes BETWEEN  @Mes AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo



Insert into @rptDM
--Consulta para obtener el Presupuesto Devengado Acumulado**
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
0 as AutorizadoAnual, 
0 as AutorizadoMes, 
0 as DevengadoMes,
sum(ISNULL(TP.Devengado,0)) as DevengadoAcumulado,
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
SUM(DevengadoMes) as DevengadoMes,SUM(DevengadoAcumulado) as DevengadoAcumulado,(SUM(AutorizadoAnual)-SUM(DevengadoAcumulado)) as PorDevengarAcumulado 
from @rptDM 
Group BY IdClave,Descripcion,Clave,Descripcion2,IdClave2
Order by  IdClave , Clave, IdClave2


GO

EXEC SP_FirmasReporte 'Control Presupuestal del Egreso-Devengado'
GO

Exec SP_CFG_LogScripts 'SP_RPT_Control_Presupuestal_Devengado','2.29'
GO