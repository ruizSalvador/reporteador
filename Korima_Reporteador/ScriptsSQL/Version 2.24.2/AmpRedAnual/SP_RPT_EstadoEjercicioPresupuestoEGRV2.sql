/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGRV2]    Script Date: 11/26/2012 15:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_EstadoEjercicioPresupuestoEGRV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGRV2]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGRV2]    Script Date: 11/26/2012 15:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RPT_EstadoEjercicioPresupuestoEGRV2 1,12,4,2016
CREATE PROCEDURE [dbo].[SP_RPT_EstadoEjercicioPresupuestoEGRV2] 

@Mes  as int, 
@Mes2 as int,  
@Tipo as int,
@Ejercicio as int,
@AmpRedAnual as int
AS
BEGIN

declare @tablatitulos as table (CLAVE varchar(2),DESCRIPCION varchar(max), Nivel int,Negritas int, orden int)
insert into @tablatitulos values('','Programas',0,1,1)
insert into @tablatitulos values('','Subsidios: Sector Social y Privado o Entidades Federativas y Municipios',1,1,2)
insert into @tablatitulos values('S','Sujetos a Reglas de Operación',2,0,3)
insert into @tablatitulos values('U','Otros Subsidios',2,0,4)
insert into @tablatitulos values('','Desempeño de las Funciones',1,1,5)
insert into @tablatitulos values('E','Prestación de Servicios Públicos',2,0,6)
insert into @tablatitulos values('B','Provisión de Bienes Públicos',2,0,7)
insert into @tablatitulos values('P','Planeación, seguimiento y evaluación de políticas públicas.',2,0,8)
insert into @tablatitulos values('F','Promoción y fomento',2,0,9)
insert into @tablatitulos values('G','Regulación y supervisión',2,0,10)
insert into @tablatitulos values('A','Funciones de las Fuerzas Armadas (Únicamente Gobierno Federal)',2,0,11)
insert into @tablatitulos values('R','Específicos',2,0,12)
insert into @tablatitulos values('K','Proyectos de Inversión',2,0,13)
insert into @tablatitulos values('','Administrativos y de Apoyo',1,1,14)
insert into @tablatitulos values('M','Apoyo al proceso presupuestario y para mejorar la eficiencia institucional',2,0,15)
insert into @tablatitulos values('O','Apoyo a la función pública y al mejoramiento de la gestión',2,0,16)
insert into @tablatitulos values('W','Operaciones ajenas',2,0,17)
insert into @tablatitulos values('','Compromisos',1,1,18)
insert into @tablatitulos values('L','Obligaciones de cumplimiento de resolución jurisdiccional',2,0,19)
insert into @tablatitulos values('N','Desatres Naturales',2,0,20)
insert into @tablatitulos values('','Obligaciones',1,1,21)
insert into @tablatitulos values('J','Pensiones y jubilaciones',2,0,22)
insert into @tablatitulos values('T','Aportaciones a la seguridad social',2,0,23)
insert into @tablatitulos values('Y','Aportaciones a fondos de estabilización',2,0,24)
insert into @tablatitulos values('Z','Aportaciones a fondos de inversión y reestructura de pensiones',2,0,25)
insert into @tablatitulos values('','Programas de Gasto Federalizado (Gobierno Federal)',1,1,26)
insert into @tablatitulos values('I','Gastos Federalizado',2,0,27)
insert into @tablatitulos values('C','Participaciones a entidades federativas y municipios',0,1,28)
insert into @tablatitulos values('D','Costo Financiero, deuda o apoyos a deudores y ahorradores de la banca',0,1,29)
insert into @tablatitulos values('H','Adeudos de ejercicios fiscales anteriores',0,1,30)
update @tablatitulos set DESCRIPCION='   '+DESCRIPCION where Nivel=1
update @tablatitulos set DESCRIPCION='      '+DESCRIPCION where Nivel=2

declare @reprte as table(Autorizado decimal(18,4),Modificado  decimal(18,4),Devengado  decimal(18,4),
Pagado  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),Clave varchar(10))

declare @res as table(
CLAVE varchar(2),DESCRIPCION varchar(max),
Autorizado decimal(18,4),Modificado  decimal(18,4),Devengado  decimal(18,4),
Pagado  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),
Nivel int,Negritas int, orden int
)

declare @resAnual as table(
CLAVE varchar(2),DESCRIPCION varchar(max),
Autorizado decimal(18,4),Modificado  decimal(18,4),Devengado  decimal(18,4),
Pagado  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),
Nivel int,Negritas int, orden int
)

declare @Anual as table(Autorizado decimal(18,4),Modificado  decimal(18,4),Devengado  decimal(18,4),
Pagado  decimal(18,4),Amp_Red  decimal(18,4),SubEjercicio decimal(18,4),Clave varchar(10))
if @Tipo=4 
BEGIN

Insert into @Anual
Select 
SUM(ISNULL(TP.Autorizado,0)) AS Autorizado, 
(SUM(ISNULL(TP.Autorizado,0)) + ((SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0)))))AS Modificado,
SUM(ISNULL(TP.Devengado,0)) AS Devengado, 
SUM(ISNULL(TP.Pagado,0)) AS Pagado, 
(SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))) AS Amp_Red,
(SUM(ISNULL(TP.Autorizado,0)) + (SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))))-
SUM(ISNULL(TP.Devengado,0)) AS SubEjercicio,
C_SubProgramaPresupuestal.Clave 
FROM T_PresupuestoNW AS TP 
JOIN T_SellosPresupuestales TS 
ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
JOIN c_ep_ramo
ON c_ep_ramo.Id = TS.IdProyecto 
JOIN C_SubProgramaPresupuestal 
ON c_ep_ramo.IdProgPres=C_SubProgramaPresupuestal.IdProgPres
AND c_ep_ramo.IdSubProgPres = C_SubProgramaPresupuestal.IdSubProgPres
WHERE (Mes = 0)  AND LYear=@ejercicio  AND Year=@ejercicio 
AND C_EP_Ramo.Nivel=5
GROUP BY C_SubProgramaPresupuestal.Clave
 


insert into @reprte
--VALORES ABSOLUTOS
Select 
(Select Autorizado From @Anual where Clave = C_SubProgramaPresupuestal.Clave) AS Autorizado, 
(SUM(ISNULL(TP.Autorizado,0)) + ((SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0)))))AS Modificado,
SUM(ISNULL(TP.Devengado,0)) AS Devengado, 
SUM(ISNULL(TP.Pagado,0)) AS Pagado, 
(SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))) AS Amp_Red,
(SUM(ISNULL(TP.Autorizado,0)) + (SUM(ISNULL(TP.Ampliaciones,0)) + SUM(ISNULL(TP.TransferenciaAmp,0))) - (SUM(ISNULL(TP.Reducciones,0)) + SUM(ISNULL(TP.TransferenciaRed,0))))-
SUM(ISNULL(TP.Devengado,0)) AS SubEjercicio,
C_SubProgramaPresupuestal.Clave 
FROM T_PresupuestoNW AS TP 
JOIN T_SellosPresupuestales TS 
ON  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal 
JOIN c_ep_ramo
ON c_ep_ramo.Id = TS.IdProyecto 
JOIN C_SubProgramaPresupuestal 
ON c_ep_ramo.IdProgPres=C_SubProgramaPresupuestal.IdProgPres
AND c_ep_ramo.IdSubProgPres = C_SubProgramaPresupuestal.IdSubProgPres
WHERE (Mes BETWEEN  @Mes AND @mes2)  AND LYear=@ejercicio  AND Year=@ejercicio 
AND C_EP_Ramo.Nivel=5
GROUP BY C_SubProgramaPresupuestal.Clave
 
--insert into @reprte 
--select t.clave,t.descripcion,0,0,0,0,0,0,0,0,0,0,0,0,0,0
--from @tablatitulos t
--where t.CLAVE not in (select CLAVE from @reprte)

--select * from @reprte 
END

Else if @Tipo=14 
BEGIN

Insert into @Anual
Select 
 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
 --autorizado+(amplicaciones+ transferencias) -(reducciones+transferencias)
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Pagado,0)) As Pagado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio,
C_SubProgramaPresupuestal.Clave

From T_PresupuestoNW As TP
JOIN  T_SellosPresupuestales As TS 
ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
JOIN c_ep_ramo
ON c_ep_ramo.Id = TS.IdProyecto 
JOIN C_SubProgramaPresupuestal 
ON c_ep_ramo.IdProgPres=C_SubProgramaPresupuestal.IdProgPres
AND c_ep_ramo.IdSubProgPres = C_SubProgramaPresupuestal.IdSubProgPres
where (Mes = 0) 
AND LYear=@ejercicio AND Year=@ejercicio 
AND C_EP_Ramo.Nivel=5 
group by C_SubProgramaPresupuestal.Clave 

insert into @reprte
--VALORES RELATIVOS
Select 
 sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
 --autorizado+(amplicaciones+ transferencias) -(reducciones+transferencias)
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,
sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0)) As Devengado,
sum(ISNULL(TP.Pagado,0)) As Pagado,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
(sum(ISNULL(TP.Devengado,0)) - sum(ISNULL(TP.Ejercido,0))) As SubEjercicio,
C_SubProgramaPresupuestal.Clave

From T_PresupuestoNW As TP
JOIN  T_SellosPresupuestales As TS 
ON TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
JOIN c_ep_ramo
ON c_ep_ramo.Id = TS.IdProyecto 
JOIN C_SubProgramaPresupuestal 
ON c_ep_ramo.IdProgPres=C_SubProgramaPresupuestal.IdProgPres
AND c_ep_ramo.IdSubProgPres = C_SubProgramaPresupuestal.IdSubProgPres
where (Mes BETWEEN  @mes AND @mes2) 
AND LYear=@ejercicio AND Year=@ejercicio 
AND C_EP_Ramo.Nivel=5 
group by C_SubProgramaPresupuestal.Clave 
	
--insert into @reprte 
--select t.clave,t.descripcion,0,0,0,0,0,0,0,0,0,0,0,0,0,0
--from @tablatitulos t
--where t.CLAVE not in (select CLAVE from @reprte)

--select * from @reprte 
END


insert into @res
select t.clave,t.DESCRIPCION,
isnull(r.Autorizado,0)as Autorizado,
isnull(r.Modificado,0)as Modificado,
isnull(r.Devengado,0)as Devengado,
isnull(r.Pagado,0) as Pagado,
isnull(r.amp_red,0)as Amp_Red,
isnull(r.SubEjercicio,0) as SubEjercicio,
t.Nivel,t.Negritas,t.orden  
from @tablatitulos t
LEFT OUTER JOIN @reprte r
on r.Clave=t.CLAVE 
order by t.orden
-------------------------------------------------------------------------------------------
insert into @resAnual
select t.clave,t.DESCRIPCION,
isnull(r.Autorizado,0)as Autorizado,
isnull(r.Modificado,0)as Modificado,
isnull(r.Devengado,0)as Devengado,
isnull(r.Pagado,0) as Pagado,
isnull(r.amp_red,0)as Amp_Red,
isnull(r.SubEjercicio,0) as SubEjercicio,
t.Nivel,t.Negritas,t.orden  
from @tablatitulos t
LEFT OUTER JOIN @Anual r
on r.Clave=t.CLAVE 
order by t.orden

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(3,4)) where orden=2
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(3,4)) where orden=2 
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(3,4)) where orden=2 
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(3,4)) where orden=2
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(3,4)) where orden=2 
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(3,4)) where orden=2

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(6,7,8,9,10,11,12,13)) where orden=5
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(6,7,8,9,10,11,12,13)) where orden=5

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(15,16,17))where orden=14
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(15,16,17)) where orden=14
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(15,16,17)) where orden=14
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(15,16,17)) where orden=14
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(15,16,17)) where orden=14
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(15,16,17))  where orden=14

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(19,20))where orden=18
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(19,20))where orden=18 
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(19,20)) where orden=18
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(19,20)) where orden=18
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(19,20))where orden=18 
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(19,20))  where orden=18

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(22,23,24,25))where orden=21
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(22,23,24,25)) where orden=21
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(22,23,24,25))where orden=21 
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(22,23,24,25)) where orden=21
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(22,23,24,25)) where orden=21
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(22,23,24,25)) where orden=21

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(27))where orden=26
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(27)) where orden=26
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(27)) where orden=26
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(27)) where orden=26
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(27)) where orden=26
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(27)) where orden=26

update @resAnual set Autorizado=(select SUM(autorizado) from @resAnual where orden in(2,5,14,18,21,26))where orden=1
update @resAnual set Modificado=(select SUM(Modificado) from @resAnual where orden in(2,5,14,18,21,26))where orden=1 
update @resAnual set Devengado=(select SUM(Devengado) from @resAnual where orden in(2,5,14,18,21,26)) where orden=1
update @resAnual set Pagado=(select SUM(Pagado) from @resAnual where orden in(2,5,14,18,21,26)) where orden=1
update @resAnual set Amp_Red=(select SUM(Amp_Red) from @resAnual where orden in(2,5,14,18,21,26)) where orden=1
update @resAnual set SubEjercicio=(select SUM(SubEjercicio) from @resAnual where orden in(2,5,14,18,21,26)) where orden=1
--
update @resAnual set Modificado=Autorizado+Amp_Red 
update @resAnual set SubEjercicio = Modificado -Devengado 
----------------------------------------------------------------------------------------------
update @res set Autorizado=(select SUM(autorizado) from @res where orden in(3,4)) where orden=2
update @res set Modificado=(select SUM(Modificado) from @res where orden in(3,4)) where orden=2 
update @res set Devengado=(select SUM(Devengado) from @res where orden in(3,4)) where orden=2 
update @res set Pagado=(select SUM(Pagado) from @res where orden in(3,4)) where orden=2
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(3,4)) where orden=2 
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(3,4)) where orden=2

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(6,7,8,9,10,11,12,13)) where orden=5
update @res set Modificado=(select SUM(Modificado) from @res where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @res set Devengado=(select SUM(Devengado) from @res where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @res set Pagado=(select SUM(Pagado) from @res where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(6,7,8,9,10,11,12,13))  where orden=5
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(6,7,8,9,10,11,12,13)) where orden=5

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(15,16,17))where orden=14
update @res set Modificado=(select SUM(Modificado) from @res where orden in(15,16,17)) where orden=14
update @res set Devengado=(select SUM(Devengado) from @res where orden in(15,16,17)) where orden=14
update @res set Pagado=(select SUM(Pagado) from @res where orden in(15,16,17)) where orden=14
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(15,16,17)) where orden=14
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(15,16,17))  where orden=14

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(19,20))where orden=18
update @res set Modificado=(select SUM(Modificado) from @res where orden in(19,20))where orden=18 
update @res set Devengado=(select SUM(Devengado) from @res where orden in(19,20)) where orden=18
update @res set Pagado=(select SUM(Pagado) from @res where orden in(19,20)) where orden=18
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(19,20))where orden=18 
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(19,20))  where orden=18

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(22,23,24,25))where orden=21
update @res set Modificado=(select SUM(Modificado) from @res where orden in(22,23,24,25)) where orden=21
update @res set Devengado=(select SUM(Devengado) from @res where orden in(22,23,24,25))where orden=21 
update @res set Pagado=(select SUM(Pagado) from @res where orden in(22,23,24,25)) where orden=21
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(22,23,24,25)) where orden=21
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(22,23,24,25)) where orden=21

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(27))where orden=26
update @res set Modificado=(select SUM(Modificado) from @res where orden in(27)) where orden=26
update @res set Devengado=(select SUM(Devengado) from @res where orden in(27)) where orden=26
update @res set Pagado=(select SUM(Pagado) from @res where orden in(27)) where orden=26
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(27)) where orden=26
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(27)) where orden=26

update @res set Autorizado=(select SUM(autorizado) from @res where orden in(2,5,14,18,21,26))where orden=1
update @res set Modificado=(select SUM(Modificado) from @res where orden in(2,5,14,18,21,26))where orden=1 
update @res set Devengado=(select SUM(Devengado) from @res where orden in(2,5,14,18,21,26)) where orden=1
update @res set Pagado=(select SUM(Pagado) from @res where orden in(2,5,14,18,21,26)) where orden=1
update @res set Amp_Red=(select SUM(Amp_Red) from @res where orden in(2,5,14,18,21,26)) where orden=1
update @res set SubEjercicio=(select SUM(SubEjercicio) from @res where orden in(2,5,14,18,21,26)) where orden=1
--
update @res set Modificado=Autorizado+Amp_Red 
update @res set SubEjercicio = Modificado -Devengado 

--Select * from @res
--Select * from @resAnual

If @AmpRedAnual = 1
	Begin
		update r set r.Autorizado = a.Autorizado, r.Amp_Red = a.Amp_Red FROM @resAnual a, @res r Where a.Orden = r.Orden
	End
Else
	Begin
		update r set r.Autorizado = a.Autorizado FROM @resAnual a, @res r Where a.Orden = r.Orden
	End

insert into @res 
select '','Total del Gasto',Sum(Autorizado), sum(Modificado), SUM (Devengado), SUM(Pagado), SUM(Amp_Red),SUM(SubEjercicio),0,1,31 from @res where orden in(1,28,29,30)

select * from @res
END

Exec SP_CFG_LogScripts 'SP_RPT_EstadoEjercicioPresupuestoEGRV2'
GO

