
/****** Object:  StoredProcedure [dbo].[SP_RPT_Formato_Gral_SP]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Formato_Gral_SP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Formato_Gral_SP]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Formato_Gral_SP]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_Formato_Gral_SP]

@PeriodoDel int,
@PeriodoAl int,
@Ejercicio int, 
@FuenteFinanciamiento varchar(max)

AS

--Estructura tabla de Capitulos, Conceptos y Partidas
DECLARE @T_Capitulos AS TABLE(
	Capitulo int,
	DesCapitulo varchar(max),
	Concepto int,
	DesConcepto varchar(max),
	PartidasGenerica int,
	DesPartidasGenerica varchar(max),
	Partida int, 
	DesPartida varchar(max)
	)
	
--Estructura Tabla de Datos
DECLARE @T_Datos AS TABLE(
	programa varchar (max),
	Nombre varchar (max),
	Capitulo int,
	DesCapitulo Varchar (max),  
	Recursos varchar(5),
	Modificado decimal (15,2),
	Comprometido decimal (15,2),
	Devengado decimal (15,2),
	Ejercido decimal(15,2),
	Pagado decimal (15,2),
	IdSubfuncion int
	)

--Estructura Tabla Final
DECLARE @T_Final AS TABLE(
	Programa varchar (max),
	Nombre varchar(max),
	Capitulo int,
	DesCapitulo Varchar (max), 
	ModificadoF decimal (15,2),
	ModificadoE decimal (15,2),
	ComprometidoF decimal (15,2),
	ComprometidoE decimal (15,2), 
	DevengadoF decimal (15,2),
	DevengadoE decimal (15,2),
	EjercidoF decimal (15,2),
	EjercidoE decimal (15,2),
	PagadoF decimal (15,2),
	PagadoE decimal (15,2)
	)

--Estructura Tabla Sumas
DECLARE @T_sumas AS TABLE(
	Programa varchar(max),
	Capitulo Int,
	recursos varchar (1),
	S_Modificado decimal(15,2),
	S_Comprometido decimal(15,2),
	S_Devengado decimal(15,2),
	S_Ejercido decimal(15,2),
	S_Pagado decimal(15,2)
	)


--Tabla de Capitulos, Conceptos y Partidas
insert into @T_Capitulos
select cap.IdCapitulo as Capitulo, cap.Descripcion as DesCapitulo, cons.IdConcepto as Concepto, 
       cons.Descripcion as DesConcepto, gen.IdPartidaGenerica as PartidasGenerica, 
       gen.DescripcionPartida as DesPartidasGenerica, par.IdPartida as Partida, par.DescripcionPartida as DesPartida
from C_CapitulosNEP as cap
inner join C_ConceptosNEP as cons on cons.IdCapitulo = cap.IdCapitulo
inner join C_PartidasGenericasPres as gen on gen.IdConcepto = cons.IdConcepto
inner Join C_PartidasPres as par on par.IdPartidaGenerica = gen.IdPartidaGenerica

--Tabla de Datos
if @FuenteFinanciamiento = ''
begin
Insert Into @T_Datos
select vista.Prog as programa, vista.NombreAI as Nombre, CCP.Capitulo, CCP.DesCapitulo,  
FF.TIPOORIGENRECURSO as Recursos,Modificado, 
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from t_presupuestoNW
inner join T_SellosPresupuestales as sellos
on t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
inner join C_FuenteFinanciamiento as FF
on sellos.IdFuenteFinanciamiento = FF.IdFuenteFinanciamiento
inner join C_EP_Ramo
on sellos.IdProyecto = C_EP_Ramo.Id
inner join @T_Capitulos as CCP
on sellos.IdPartida = CCP.Partida
inner join VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR as vista
on C_EP_Ramo.Id = vista.Id
where IdSubfuncion in (22,24,25)
and (t_presupuestoNW.mes between @PeriodoDel and @PeriodoAl) and t_presupuestoNW.year = @Ejercicio
order by Nombre
end

else

Insert Into @T_Datos
select vista.Prog as programa, vista.NombreAI as Nombre, CCP.Capitulo, CCP.DesCapitulo,  
FF.TIPOORIGENRECURSO as Recursos,Modificado, 
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from t_presupuestoNW
inner join T_SellosPresupuestales as sellos
on t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
inner join C_FuenteFinanciamiento as FF
on sellos.IdFuenteFinanciamiento = FF.IdFuenteFinanciamiento
inner join C_EP_Ramo
on sellos.IdProyecto = C_EP_Ramo.Id
inner join @T_Capitulos as CCP
on sellos.IdPartida = CCP.Partida
inner join VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR as vista
on C_EP_Ramo.Nombre = vista.Proyecto
where IdSubfuncion in (22,24,25)
and (t_presupuestoNW.mes between @PeriodoDel and @PeriodoAl) and t_presupuestoNW.year = @Ejercicio
and FF.DESCRIPCION = @FuenteFinanciamiento
union
select vista.Prog as programa, vista.NombreAI as Nombre, CCP.Capitulo, CCP.DesCapitulo,  
FF.TIPOORIGENRECURSO as Recursos,Modificado, 
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from t_presupuestoNW
inner join T_SellosPresupuestales as sellos
on t_presupuestoNW.IdSelloPresupuestal = sellos.IdSelloPresupuestal
inner join C_FuenteFinanciamiento as FF
on sellos.IdFuenteFinanciamiento = FF.IdFuenteFinanciamiento
inner join C_EP_Ramo
on sellos.IdProyecto = C_EP_Ramo.Id
inner join @T_Capitulos as CCP
on sellos.IdPartida = CCP.Partida
inner join VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR as vista
on C_EP_Ramo.Nombre = vista.Proyecto
where IdSubfuncion in (22,24,25)
and (t_presupuestoNW.mes between @PeriodoDel and @PeriodoAl) and t_presupuestoNW.year = @Ejercicio
and FF.TIPOORIGENRECURSO <> 'F'
order by Nombre

--Tabla Final
--Insertar Programa
Insert into @T_Final
select distinct(Programa) as Programa, Nombre as Nombre, Capitulo as Capitulo, DesCapitulo as DesCapitulo, /*recursos as recursos,*/ 0 as ModificadoF, 0 as ModificadoE,
0 as ComprometidoF, 0 as ComprometidoE, 0 as DevengadoF, 0 as DevengadoE, 0 as EjercidoF, 0 as EjercidoE, 0 as PagadoF, 0 as PagadoE
from @T_Datos
Group by programa, nombre, capitulo, DesCapitulo
--Sumatorias
Insert Into @T_sumas
select programa, capitulo, recursos, 
sum(modificado) as S_Modificado, sum(Comprometido) as S_Comprometido,
sum(Devengado ) as S_Devengado, sum(Ejercido) as S_Ejercido, sum(Pagado) as S_Pagado
from @T_Datos 
Group by programa, capitulo, Recursos 

--Completa Datos Finales  
--Modificado  
update @t_Final set ModificadoE = S.S_Modificado  
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('S','E')  
update @t_Final set ModificadoF = S.S_Modificado  
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('R','F','T') 
update @T_Final set ModificadoE = 0 where ModificadoE is null  
update @T_Final set ModificadoF = 0 where ModificadoF is null  
--Comprometido  
update @t_Final set ComprometidoE = S.S_Comprometido   
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('S','E')  
update @t_Final set ComprometidoF = S.S_Comprometido   
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('R','F','T')  
update @T_Final set ComprometidoE = 0 where ComprometidoE is null  
update @T_Final set ComprometidoF = 0 where ComprometidoF is null  
--Devengado  
update @t_Final set DevengadoE = S.S_Devengado   
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('S','E')   
update @t_Final set DevengadoF = S.S_Devengado    
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('R','F','T') 
update @T_Final set DevengadoE = 0 where DevengadoE is null  
update @T_Final set DevengadoF = 0 where DevengadoF is null  
--Ejercido  
update @t_Final set EjercidoE = S.S_Ejercido    
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('S','E')   
update @t_Final set EjercidoF = S.S_Ejercido    
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('R','F','T')  
update @T_Final set EjercidoE = 0 where EjercidoE is null  
update @T_Final set EjercidoF = 0 where EjercidoF is null  
--Pagado  
update @t_Final set PagadoE = S.S_Pagado    
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('S','E')   
update @t_Final set PagadoF = S.S_Pagado     
from @T_Final as F join @T_sumas as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa --and F.recursos = S.Recursos  
where S.recursos in('R','F','T') 
update @T_Final set PagadoE = 0 where PagadoE is null  
update @T_Final set PagadoF = 0 where PagadoF is null  
  
--select * from @T_sumas  
--select * from @T_Datos  
select * from @T_Final   

--go
--exec SP_RPT_Formato_Gral_SP @PeriodoDel=0,@PeriodoAl=0,@Ejercicio=N'2017',@FuenteFinanciamiento=N'Recursos Estatales'
