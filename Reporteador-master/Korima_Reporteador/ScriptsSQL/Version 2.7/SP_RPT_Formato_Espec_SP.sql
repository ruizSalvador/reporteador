

/****** Object:  StoredProcedure [dbo].[SP_RPT_Formato_Espec_SP]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Formato_Espec_SP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_Formato_Espec_SP]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_Formato_Espec_SP]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_Formato_Espec_SP]

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
	Ano int,
	Entidad varchar (max),
	Nombre varchar (max),
	Capitulo int,
	DesCapitulo Varchar (max), 
	Concepto int,
	DesConcepto varchar(max),
	PGenerica int,
	DesPG varchar(max),
	PEspecifica int, 
	DesPE varchar(max),
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
	Ano int,
	Entidad varchar (max),
	Nombre varchar(max),
	Capitulo int,
	DesCapitulo Varchar (max),
	Concepto int,
	DesConcepto varchar(max),
	PGenerica int,
	DesPG varchar(max),
	PEspecifica int, 
	DesPE varchar(max),
	--Recursos varchar(5),
	ModificadoF decimal (15,2),
	ModificadoE decimal (15,2),
	ComprometidoF decimal (15,2),
	ComprometidoE decimal (15,2), 
	DevengadoF decimal (15,2),
	DevengadoE decimal (15,2),
	EjercidoF decimal (15,2),
	EjercidoE decimal (15,2),
	PagadoF decimal (15,2),
	PagadoE decimal (15,2),
	M1 decimal (15,2),
	M2 decimal (15,2),
	M3 decimal (15,2),
	M4 decimal (15,2),
	M5 decimal (15,2),
	M6 decimal (15,2),
	M7 decimal (15,2),
	M8 decimal (15,2)
	)

--Tabla de Capitulos, Conceptos y Partidas
insert into @T_Capitulos
select cap.IdCapitulo as Capitulo, cap.Descripcion as DesCapitulo, cons.IdConcepto as Concepto, 
       cons.Descripcion as DesConcepto, gen.IdPartidaGenerica as PartidasGenerica, 
       gen.DescripcionPartida as DesPartidasGenerica, par.IdPartida as Partida, par.DescripcionPartida as DesPartida
from C_CapitulosNEP as cap
inner join C_ConceptosNEP as cons on cons.IdCapitulo = cap.IdCapitulo
inner join C_PartidasGenericasPres as gen on gen.IdConcepto = cons.IdConcepto
Inner Join C_PartidasPres as par on par.IdPartidaGenerica = gen.IdPartidaGenerica

--Tabla de Datos
if @FuenteFinanciamiento = ''
begin
Insert Into @T_Datos
select vista.Prog as programa, year as Ano, Ente.EntidadFederativa as Entidad, C_EP_Ramo.Nombre, CCP.Capitulo, CCP.DesCapitulo,  
CCP.Concepto as Concepto,CCP.DesConcepto as DesConcepto, CCP.PartidasGenerica as PGenerica, CCP.DesPartidasGenerica as DesPG, 
CCP.Partida as PEspecifica, CCP.DesPartida as DesPE, FF.TIPOORIGENRECURSO as Recursos,Modificado, 
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from RPT_CFG_DatosEntes as Ente, 
t_presupuestoNW
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
order by Nombre
end

else

Insert Into @T_Datos
select vista.Prog as programa, year as Ano, Ente.EntidadFederativa as Entidad, C_EP_Ramo.Nombre, CCP.Capitulo, CCP.DesCapitulo,  
CCP.Concepto as Concepto,CCP.DesConcepto as DesConcepto, CCP.PartidasGenerica as PGenerica, CCP.DesPartidasGenerica as DesPG, 
CCP.Partida as PEspecifica, CCP.DesPartida as DesPE, FF.TIPOORIGENRECURSO as Recursos,Modificado,  
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from RPT_CFG_DatosEntes as Ente, 
t_presupuestoNW
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
select vista.Prog as programa, year as Ano, Ente.EntidadFederativa as Entidad, C_EP_Ramo.Nombre, CCP.Capitulo, CCP.DesCapitulo,  
CCP.Concepto as Concepto,CCP.DesConcepto as DesConcepto, CCP.PartidasGenerica as PGenerica, CCP.DesPartidasGenerica as DesPG, 
CCP.Partida as PEspecifica, CCP.DesPartida as DesPE, FF.TIPOORIGENRECURSO as Recursos,Modificado,  
Comprometido, Devengado, Ejercido, Pagado, IdSubfuncion 
from RPT_CFG_DatosEntes as Ente, 
t_presupuestoNW
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
select distinct Programa as Programa, Ano as Ano, Entidad as Entidad, Nombre as Nombre, Capitulo as Capitulo, DesCapitulo as DesCapitulo, 
Concepto as Concepto, DesConcepto as DesConcepto, PGenerica as PGenerica, DesPG as DesPG, PEspecifica as PEspecifica, DesPE as DesPE,0 as ModificadoF, 0 as ModificadoE,
0 as ComprometidoF, 0 as ComprometidoE, 0 as DevengadoF, 0 as DevengadoE, 0 as EjercidoF, 0 as EjercidoE, 0 as PagadoF, 0 as PagadoE,
0 as M1, 0 as M2, 0 as M3, 0 as M4, 0 as M5, 0 as M6, 0 as M7, 0 as M8
from @T_Datos


--Completa Datos Finales
--Modificado
update @t_Final set ModificadoE = S.Modificado
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'E'
update @t_Final set ModificadoF = S.Modificado
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'F'
update @T_Final set ModificadoE = 0 where ModificadoE is null
update @T_Final set ModificadoF = 0 where ModificadoF is null
--Comprometido
update @t_Final set ComprometidoE = S.Comprometido 
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'E'
update @t_Final set ComprometidoF = S.Comprometido 
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'F'
update @T_Final set ComprometidoE = 0 where ComprometidoE is null
update @T_Final set ComprometidoF = 0 where ComprometidoF is null
--Devengado
update @t_Final set DevengadoE = S.Devengado 
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'E'
update @t_Final set DevengadoF = S.Devengado  
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'F'
update @T_Final set DevengadoE = 0 where DevengadoE is null
update @T_Final set DevengadoF = 0 where DevengadoF is null
--Ejercido
update @t_Final set EjercidoE = S.Ejercido  
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'E'
update @t_Final set EjercidoF = S.Ejercido  
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'F'
update @T_Final set EjercidoE = 0 where EjercidoE is null
update @T_Final set EjercidoF = 0 where EjercidoF is null
--Pagado
update @t_Final set PagadoE = S.Pagado  
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'E'
update @t_Final set PagadoF = S.Pagado   
from @T_Final as F join @T_Datos as S on F.Capitulo = S.Capitulo and F.Programa = S.Programa and F.PGenerica = S.PGenerica and F.PEspecifica = S.PEspecifica
where S.recursos = 'F'
update @T_Final set PagadoE = 0 where PagadoE is null
update @T_Final set PagadoF = 0 where PagadoF is null

--select * from @T_sumas
--select * from @T_Datos
select * from @T_Final 


GO

EXEC SP_FirmasReporte 'Formato Específico de Aplicación de Recursos a Seguridad Pública'
GO

--SP_RPT_Formato_Espec_SP 2,2,2014,''
