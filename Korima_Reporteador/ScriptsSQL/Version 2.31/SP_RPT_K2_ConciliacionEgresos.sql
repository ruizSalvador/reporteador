/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionEgresos]    Script Date: 12/01/2014 13:57:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ConciliacionEgresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ConciliacionEgresos]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ConciliacionEgresos]    Script Date: 12/01/2014 13:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Exec SP_RPT_K2_ConciliacionEgresos 1,4,2021
CREATE PROCEDURE [dbo].[SP_RPT_K2_ConciliacionEgresos]
@MesInicio int,
@MesFin int,
@Ejercicio int
AS
BEGIN
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)
declare @variable as decimal(18,4)


Declare @titulos as table(Numero varchar(max), Nombre varchar(max), Cargos decimal(18,4),Negritas bit, Tab bit,Orden decimal(15,2), Suma decimal (18,4))
insert into @titulos values ('825'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '1. Total de Egresos (Presupuestarios)',0,1,0,1,null)
insert into @titulos values ('', '',null,0,0,1.1,null)
insert into @titulos values ('', '2. Menos Egresos Presupuestarios No Contables',null,1,0,2,null)
insert into @titulos values ('23000', '2.1  Materias Primas y Materiales de Producción y Comercialización',0,0,1,3,null)
insert into @titulos values ('20000', '2.2  Materiales y Suministros',0,0,1,4,null)
insert into @titulos values ('51000', '2.3  Mobiliario y equipo de Administración',0,0,1,5,null)
insert into @titulos values ('52000', '2.4  Mobiliario y equipo educacional y recreativo',0,0,1,6,null)
insert into @titulos values ('53000', '2.5  Equipo e instrumental médico y de laboratorio',0,0,1,7,null)
insert into @titulos values ('54000', '2.6  Vehículos y equipos de transporte',0,0,1,8,null)
insert into @titulos values ('55000', '2.7  Equipo de Defensa y seguridad',0,0,1,9,null)
insert into @titulos values ('56000', '2.8  Maquinaria, otros equipo y herramientas',0,0,1,10,null)
insert into @titulos values ('57000', '2.9  Activos biológicos',0,0,1,11,null)
insert into @titulos values ('58000', '2.10  Bienes inmuebles',0,0,1,12,null)
insert into @titulos values ('59000', '2.11  Activos intangibles',0,0,1,13,null)
insert into @titulos values ('61000', '2.12  Obra Pública en Bienes de Dominio Público',0,0,1,14,null)
insert into @titulos values ('62000', '2.13  Obra pública en bienes propios',0,0,1,15,null)
insert into @titulos values ('72000', '2.14  Acciones y participaciones de capital',0,0,1,16,null)
insert into @titulos values ('73000', '2.15  Compra de títulos y valores',0,0,1,17,null)
insert into @titulos values ('74000', '2.16  Concesión de Préstamos',0,0,1,18,null)
insert into @titulos values ('75000', '2.17  Inversiones en fideicomisos, mandatos y otros análogos',0,0,1,19,null)
insert into @titulos values ('79000', '2.18  Provisiones para contingencias y otras erogaciones especiales',0,0,1,20,null)
insert into @titulos values ('91000', '2.19  Amortización de la deuda publica',0,0,1,21,null)
insert into @titulos values ('99000', '2.20  Adeudos de ejercicios fiscales anteriores (ADEFAS)',0,0,1,22,null)
insert into @titulos values ('', '2.21  Otros Egresos Presupuestales No Contables',0,0,1,23,null)
insert into @titulos values ('', '',null,0,0,23.1,null)

insert into @titulos values ('', '3. Más gastos contables no presupuestarios',null,1,0,24,null)
insert into @titulos values ('551'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.1 Estimaciones, depreciaciones, deterioros, obsolescencia y amortizaciones',null,0,1,25,null)
insert into @titulos values ('552'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.2 Provisiones',null,0,1,26,null)
insert into @titulos values ('553'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.3 Disminución de inventarios',null,0,1,27,null)
insert into @titulos values ('554'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.4 Aumento por insuficiencia de estimaciones por pérdida o deterioro u obsolescencia',null,0,1,28,null)
insert into @titulos values ('555'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.5 Aumento por insuficiencia de provisiones',null,0,1,29,null)
insert into @titulos values ('559'+REPLICATE('0',@Estructura1-3)+'-'+@CerosEstructura, '3.6 Otros Gastos',null,0,1,30,null)
insert into @titulos values (''+REPLICATE('0',@Estructura1-4)+'-'+@CerosEstructura, '3.7 Otros Gastos Contables No Presupuestales',0,0,1,31,null)
insert into @titulos values ('', '',null,0,0,31.1,null)
insert into @titulos values ('', '4. Total de Gasto Contable',null,1,0,32,null)

declare @valores as table (Cuenta varchar(max),Mes int, ejercicio int, TotalCargos decimal(18,4))
insert into @valores 
select c_contable.NumeroCuenta,0,--T_SaldosInicialesCont.Mes,
 0,--T_SaldosInicialesCont.Year,
 isnull(SUM(T_SaldosInicialesCont.TotalCargos),0) 
 from T_SaldosInicialesCont 
join c_contable on C_Contable.IdCuentaContable=T_SaldosInicialesCont.IdCuentaContable 
 where (T_SaldosInicialesCont.Mes between @MesInicio and @MesFin) and T_SaldosInicialesCont.Year =@Ejercicio
 group by NumeroCuenta

update @titulos set t.Cargos = isnull(v.TotalCargos,0) from @titulos t  join @valores v on v.Cuenta=t.numero
----------------------------------------------------------------------------------------

--Tabla de titulos 
Declare @TitulosCOG as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int,Devengado decimal(18,4))

INSERT INTO @TitulosCOG
SELECT CG.IdCapitulo as IdClave, 
CG.Descripcion as Descripcion, 
CN.IdConcepto  as Clave, 
CN.Descripcion as Descripcion2, 
CN.IdCapitulo as IdClave2, 
0 as Devengado
From  C_ConceptosNEP As CN, C_CapitulosNEP As CG
WHERE CG.IdCapitulo = CN.IdCapitulo

Declare @rpt as table(IdClave int,Descripcion varchar(max),Clave int,Descripcion2 Varchar(max),IdClave2 int, Devengado decimal(18,4))
Insert into @rpt
--VALORES ABSOLUTOS
--Consulta para Capítulo del Gasto del Ejercicio del Presupuesto **
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, CN.IdCapitulo as IdClave2,  --CG.IdCapitulo, CG.Descripcion,  CN.IdCapitulo, CN.IdConcepto, CN.Descripcion,  CP.IdPartida,
sum(ISNULL(TP.Devengado,0)) as Devengado 

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS , C_ConceptosNEP As CN, C_PartidasPres As CP, C_CapitulosNEP As CG
where (Mes BETWEEN  @MesInicio AND @MesFin) AND LYear=@Ejercicio AND Year=@Ejercicio 
AND  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal AND CP.IdPartida = TS.IdPartida AND CN.IdConcepto = CP.IdConcepto AND CG.IdCapitulo = CN.IdCapitulo
--AND TS.IdAreaResp = CASE WHEN @IdArea = 0 THEN TS.IdAreaResp ELSE @IdArea END
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  CG.IdCapitulo , CN.IdConcepto, CN.IdCapitulo

insert into @rpt
select* from @TitulosCOG t 
where t.Clave not in (select Clave from @rpt)

----------------------------------------------------------------------------------------


update @titulos set t.Cargos = isnull(v.Devengado,0) from @titulos t  join @rpt v on LEFT(v.Clave,4) = CAST(Substring(t.numero,1,4) as int) Where t.Orden >= 3 and t.Orden <=22


Update @titulos Set Cargos = isnull(
	(Select SUM(totalcargos) from T_SaldosInicialesCont inner join
	C_Contable On T_SaldosInicialesCont.IdCuentaContable = C_Contable.IdCuentaContable
	Where (NumeroCuenta like '82500-99%' or NumeroCuenta like '82500-99%')
	and (T_SaldosInicialesCont.Mes between @MesInicio and @Mesfin and year = @ejercicio)) ,0)
where Orden = 18
--------

Update @titulos set Cargos = (Select SUM(isnull(Devengado,0)) from @rpt) Where Orden=1 --isnull(Cargos,0) where Orden=1
--update @titulos set Cargos=null where Orden=1
Update @titulos Set Cargos = (Select ISNULL(SUM(Devengado),0) from @rpt Where LEFT(Clave,4) in (2100, 2200, 2400, 2500, 2600, 2700, 2800, 2900)) Where Orden = 4
Update @titulos set Cargos=(select SUM(isnull(cargos,0)) from @titulos where Orden between 3 and 23 ) where orden=2
Update @titulos set Cargos=(select SUM(isnull(cargos,0)) from @titulos where Orden between 25 and 31) where orden=24
Update @titulos set Cargos=
((select SUM(isnull(Cargos,0)) from @titulos where orden in (1)) -
(select SUM(isnull(Cargos,0)) from @titulos where orden in (2))) +
(select SUM(isnull(Cargos,0)) from @titulos where orden in (24))
where orden=32

Update @titulos set nombre='     '+nombre from @titulos where Tab=1
 

select * from @titulos 

END

GO

EXEC SP_FirmasReporte 'Conciliacion entre los Egresos Presupuestarios y Gastos Contables'
GO



