
/****** Object:  StoredProcedure [dbo].[SP_SUB_NOTA_FIOPoGFFed]    Script Date: 01/23/2015 15:02:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SUB_NOTA_FIOPoGFFed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_SUB_NOTA_FIOPoGFFed]
GO

/****** Object:  StoredProcedure [dbo].[SP_SUB_NOTA_FIOPoGFFed]    Script Date: 01/23/2015 15:02:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_SUB_NOTA_FIOPoGFFed]
@Mes as int,
@Mes2 as int,
@Ejercicio as int

AS
BEGIN


DECLARE @Tmp_MovimientosPresupuesto AS TABLE(
Id int,
Aprobado decimal(15,2),
Estimado decimal (15,2),
Ampliaciones decimal(15,2),
Reducciones decimal (15,2),
Modificado decimal (15,2),
Trasferencias decimal(15,2)
)
DECLARE @Tmp_AfectacionPresupuesto AS TABLE(
Id int,
Comprometido decimal(15,2),
Devengado decimal(15,2),
Recaudado decimal(15,2),
Ejercido decimal (15,2),
Pagado decimal(15,2)
)
Declare @Resultado1 as TABLE(
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Clave varchar(7),
IdClasificacionGI smallint,
IdClasificacionGIPadre smallint,
Grupo1 varchar(7),
Grupo2 varchar(7)
)
--
--Declare @Rubro as TABLE(
--Clave varchar(7),
--Clasificacion varchar(255),	
--Total_Estimado decimal (15,2),
--Total_Modificado decimal (15,2),
--Total_Devengado decimal (15,2),
--Total_Recaudado decimal (15,2),
--PorRecaudar decimal (15,2),
--PorcModificado decimal (15,2),
--PorcDevengado decimal (15,2),
--PorcRecaudado decimal (15,2),
--ResModificado decimal (15,2),
--ResDevengado decimal (15,2),
--ResRecaudado decimal (15,2),
--Orden tinyint
--)
--

Declare @Rubro as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas bit,
Tab int
)


Insert into @Rubro
Exec SP_EstadoEjercicioIngresos_Rubro 1,@Mes2,1,@Ejercicio



Insert Into @Tmp_MovimientosPresupuesto (Id, Estimado, Ampliaciones, Reducciones )
SELECT IdPartidaGIDestino as Id, [A] as [Estimado], [M] AS [Ampliaciones], [R] as [Reducciones]
From (
	Select  Sum(Importe) as Tot_Importe, TipoMovimiento, IdPartidaGIDestino
	From T_MovimientosPresupuesto 
	Where IdPartidaGIDestino > 0 And MedDestino  between 1 and @Mes2   and ejercidio=@Ejercicio 
	Group By TipoMovimiento, IdPartidaGIDestino ) p
Pivot (
	Sum( Tot_Importe ) 
	For TipoMovimiento In ([A], [M], [R])
) as PivotTable
Where IdPartidaGIDestino > 0 
Order By IdPartidaGIDestino
--
Update @Tmp_MovimientosPresupuesto Set Estimado = 0 Where IsNull( Estimado, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Ampliaciones = 0 Where IsNull( Ampliaciones, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Reducciones = 0 Where IsNull( Reducciones, 1 ) = 1
--
Update @Tmp_MovimientosPresupuesto Set Modificado = Estimado + Ampliaciones - Reducciones
--
Insert Into @Tmp_AfectacionPresupuesto (Id, Devengado, Recaudado)
SELECT  IdPartidaGI, [D] as [Devengado], [K] AS [Recaudado]
From (
	Select Sum(Importe) as Tot_Importe, TipoAfectacion, IdPartidaGI
	From T_AfectacionPresupuesto 
	Where Importe <> 0 And 
	Mes between 1 and @Mes2  and Periodo = @Ejercicio  And IdPartidaGI > 0 
	Group By IdPartidaGI, TipoAfectacion ) p
Pivot (
Sum( Tot_Importe ) 
For TipoAfectacion In ([D], [K] )
) as PivotTable
Where IdPartidaGI > 0 
Order By IdPartidaGI
--
Update @Tmp_AfectacionPresupuesto Set Devengado = 0 Where IsNull( Devengado, 1 ) = 1
--
Update @Tmp_AfectacionPresupuesto Set Recaudado = 0 Where IsNull( Recaudado, 1 ) = 1
--
INSERT INTO @Resultado1 
SELECT     C_ClasificacionGasto_2.Descripcion AS Clasificacion,
					  SUM(MovimientosPresupuesto.Estimado) AS Total_Estimado, 
					  SUM(MovimientosPresupuesto.Modificado) AS Total_Modificado,
                      SUM(AfectacionPresupuesto.Devengado) AS Total_Devengado, 
                      SUM(AfectacionPresupuesto.Recaudado) AS Total_Recaudado,
                      C_ClasificacionGasto_2.Clave,
                      C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,1) as Grupo1,
                      SUBSTRING(C_ClasificacionGasto_2.Clave,1,2) as Grupo2 
FROM         @Tmp_MovimientosPresupuesto MovimientosPresupuesto  LEFT OUTER JOIN
                      C_PartidasGastosIngresos 
                      ON MovimientosPresupuesto.Id = C_PartidasGastosIngresos.IdPartidaGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto 
                      ON C_PartidasGastosIngresos.IdClasificacionGI = C_ClasificacionGasto.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_1 
                      ON C_ClasificacionGasto.IdClasificacionGIPadre = C_ClasificacionGasto_1.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_2 
                      ON C_ClasificacionGasto_1.IdClasificacionGIPadre = C_ClasificacionGasto_2.IdClasificacionGI 
                      LEFT OUTER JOIN
                      C_ClasificacionGasto AS C_ClasificacionGasto_3 
                      ON C_ClasificacionGasto_2.IdClasificacionGIPadre = C_ClasificacionGasto_3.IdClasificacionGI 
                      LEFT OUTER JOIN
                      @Tmp_AfectacionPresupuesto AfectacionPresupuesto  
                      ON C_PartidasGastosIngresos.IdPartidaGI = AfectacionPresupuesto.Id
GROUP BY C_ClasificacionGasto_2.Descripcion, C_ClasificacionGasto_2.Clave,C_ClasificacionGasto_3.IdClasificacionGI,
                      C_ClasificacionGasto_3.IdClasificacionGIPadre
                      
ORDER BY C_ClasificacionGasto_2.Clave
--
INSERT INTO @Resultado1 (Clave,
Clasificacion,
Total_Estimado,
Total_Modificado,
Total_Devengado,
Total_Recaudado)
Select 
Clave,
Clasificacion,
isnull(Total_Estimado,0),
isnull(Total_Modificado,0),
isnull(Total_Devengado,0),
isnull(Total_Recaudado,0)
From @Rubro 
--
UPDATE @Resultado1 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado1 set Grupo2= SUBSTRING(Clave,1,2)

INSERT INTO @Resultado1 (Clave, Clasificacion,IdClasificacionGI,IdClasificacionGIPadre,Grupo1,Grupo2)
SELECT distinct gast.Clave,gast.Descripcion,gast.IdClasificacionGI,gast.IdClasificacionGIPadre,SUBSTRING(gast.Clave,1,1) as Grupo1,
SUBSTRING(gast.Clave,1,2) as Grupo2  
From C_ClasificacionGasto as gast
where gast.Nivel=3 and gast.Descripcion NOT IN( select clasificacion from @Resultado1)
--
INSERT INTO @Resultado1 (Clave, Clasificacion)
SELECT distinct gast.Clave,gast.Descripcion From C_ClasificacionGasto as gast
where gast.Nivel=2 and gast.Descripcion NOT IN( select clasificacion from @Resultado1)

UPDATE @Resultado1 set Grupo1= SUBSTRING(Clave,1,1)
UPDATE @Resultado1 set Grupo2= SUBSTRING(Clave,1,2)
UPDATE @Resultado1 set Grupo1= '0' where LEN(Clave)=4
UPDATE @Resultado1 set Grupo2= '0' +SUBSTRING(clave,1,1) where LEN(clave)=4
--
Delete from @Resultado1 where Clave not like '__000' and LEN(Clave)=5
Delete from @Resultado1 where Clave not like '__00' and LEN(Clave)=4
--
INSERT INTO @Resultado1 (Grupo1,Grupo2,Clasificacion,
Total_Recaudado)
Select 'I' as Grupo1, '' as Grupo2, 'INGRESOS CORRIENTES' as clasificacion,
(Select SUM (Total_Recaudado) from @Resultado1 where Clave in ('10000','20000','30000','40000','70000','80000','90000')) as Total_Recaudado
--
INSERT INTO @Resultado1 (Grupo1,Grupo2,Clasificacion,
Total_Recaudado)
Select 'II' as Grupo1, '' as Grupo2, 'INGRESOS DE CAPITAL' as clasificacion,

(Select SUM (Total_Recaudado) from @Resultado1 where Clave in ('50000','60000')) as Total_Recaudado
--
INSERT INTO @Resultado1 (Grupo1,Grupo2,Clasificacion,
Total_Recaudado)
Select 'III' as Grupo1, '' as Grupo2, 'FINANCIAMIENTO' as clasificacion,

(Select SUM (Total_Recaudado) from @Resultado1 where Clave in ('0000')) as Total_Recaudado
--
INSERT INTO @Resultado1 (Grupo1,Grupo2,Clasificacion,
Total_Recaudado)
Select '' as Grupo1, 'III.I' as Grupo2, 'Fuentes financieras' as clasificacion,

(Select SUM (Total_Recaudado) from @Resultado1 where Clave in ('0000')) as Total_Recaudado


--SELECT 
--Clave,
--Clasificacion,
--isnull(Total_Recaudado,0) as Total_Recaudado,
--(case  
--when Grupo1='5' then 9.6
--when Grupo1='6' then 9.7
--when len(clave)= 4 then 10  
--when len(clave)=5 then Grupo1 
--when len(Clave)=3  then 2
--when Grupo1='I' then 0.5 
--when Grupo1='II' then 9.5
--when Grupo1='III' then 9.8
--when Grupo2='III.I' then 9.9
--end)as Orden,
--IdClasificacionGI,
--IdClasificacionGIPadre,
--Grupo1,
--Grupo2 
--from @Resultado
--Order by Orden,clave

end 
---------------

DECLARE @Trimestres TABLE (IdClave varchar (10),Descripcion varchar (150), Clave varchar (10),Descripcion2 varchar (150),  Monto decimal(15,2), Trimestre int)
----------------
Insert Into @Trimestres
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, 
   
sum(isnull(TP.Ejercido,0)) as Monto,1


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  1 AND 3) AND Year=@Ejercicio  and  cg.IdCapitulo = 9000 and cn.IdConcepto in (9100,9200,9300,9400,9500)  
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
--Order by  Cn.IdConcepto 

union all

Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, 
   
sum(isnull(TP.Ejercido,0)) as Monto,2


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  4 AND 6) AND Year=@Ejercicio  and  cg.IdCapitulo = 9000 and cn.IdConcepto in (9100,9200,9300,9400,9500)  
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
--Order by  Cn.IdConcepto 

union all
Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, 
   
sum(isnull(TP.Ejercido,0)) as Monto,3

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  7 AND 9) AND Year=@Ejercicio  and  cg.IdCapitulo = 9000 and cn.IdConcepto in (9100,9200,9300,9400,9500)  
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
--Order by  Cn.IdConcepto 

union all

Select CG.IdCapitulo as IdClave, CG.Descripcion as Descripcion, CN.IdConcepto  as Clave, CN.Descripcion as Descripcion2, 
   
sum(isnull(TP.Ejercido,0)) as Monto,4


From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join C_RamoPresupuestal  CR 
on CR.IDRAMOPRESUPUESTAL = TS.IdRamoPresupuestal 
inner join C_PartidasPres CP
on CP.IdPartida = TS.IdPartida
left join C_ConceptosNEP CN
on CN.IdConcepto = CP.IdConcepto
left join C_CapitulosNEP CG
on CG.IdCapitulo = CN.IdCapitulo

where  (Mes BETWEEN  10 AND 12) AND Year=@Ejercicio  and  cg.IdCapitulo = 9000 and cn.IdConcepto in (9100,9200,9300,9400,9500)  
Group by  CG.IdCapitulo, CG.Descripcion, CN.IdConcepto, CN.Descripcion, CN.IdCapitulo
Order by  Cn.IdConcepto 



---------------

DECLARE @Resultado TABLE (Descripcion varchar (150), Monto decimal(15,2), Trimestre int)

Insert Into @Resultado
Select  NombreCuenta, 
      Case C_Contable.TipoCuenta 
          When 'A' Then 0
          When 'C' Then 0
          When 'E' Then 0
          When 'G' Then 0
        When 'I'  Then 0
          Else AbonosSinFlujo - CargosSinFlujo + TotalAbonos - TotalCargos 
      End as SaldoAcreedor
      ,0
      --T_SaldosInicialesCont.mes,
      --T_SaldosInicialesCont.Year
From C_Contable, T_SaldosInicialesCont 
Where  C_Contable.IdCuentaContable = T_SaldosInicialesCont.IdCuentaContable
And TipoCuenta <> 'X' 
and (NumeroCuenta = '22300-00000' or NumeroCuenta = '22300-000000' or NumeroCuenta = '223000-000000')
and Mes =12 and YEAR=@Ejercicio - 1 
--------------------

Update @Resultado  Set Descripcion =  'Deuda Pública Bruta Total al 31 de Diciembre del Año ' + CAST(@ejercicio - 1 as varchar(5))

--------------

Insert Into @Resultado
Select '(-) Amortización 1', sum(Monto), 1 from @Trimestres 
where Trimestre = 1

-------------

Declare @c decimal(15,2)
Select @c = (Select sum(Monto) from @Resultado  where Trimestre = 0) - (Select sum(Monto) from @Trimestres where Trimestre = 1)

Insert Into @Resultado
Select 'Deuda Pública Bruta Total descontando la amortización 1', @c, 1 from @Resultado
where trimestre = 0 


-------------
Insert Into @Resultado
Select '(-) Amortización 2', sum(Monto), 2 from @Trimestres
where Trimestre = 2


-------------

Declare @e decimal(15,2)
Select @e = @c - (Select sum(Monto) from @Trimestres where Trimestre = 2)

Insert Into @Resultado
Select 'Deuda Pública Bruta Total descontando la amortización 2', @e, 2 from @Resultado
where trimestre = 0 


-------------

Insert Into @Resultado
Select '(-) Amortización 3', sum(Monto), 3 from @Trimestres 
where Trimestre = 3

-------------

Declare @g decimal(15,2)
Select @g = @e - (Select sum(Monto) from @Trimestres where Trimestre = 3)

Insert Into @Resultado
Select 'Deuda Pública Bruta Total descontando la amortización 3', @g, 3 from @Resultado
where trimestre = 0 

-------------

Insert Into @Resultado
Select '(-) Amortización 4', sum(Monto), 4 from @Trimestres 
where Trimestre = 4

-------------

Declare @i decimal(15,2)
Select @i = @g - (Select sum(Monto) from @Trimestres where Trimestre = 4)

Insert Into @Resultado
Select 'Deuda Pública Bruta Total descontando la amortización 4', @i, 4 from @Resultado
where trimestre = 0 



---------------
--Select Descripcion, isnull(Monto,0) as Monto, Trimestre from @Resultado 

----------------------
DECLARE @ResultadoFinal TABLE (Descripcion varchar (150), Monto decimal(15,2), Trimestre varchar (50))


Insert Into @ResultadoFinal
SELECT 'Ingresos Propios',sum(Total_Recaudado) as Monto,0
from @Resultado1
where  Clave in('0000','81000') or Clave like '1%' or Clave like '2%' or Clave like '3%' or Clave like '4%' 
or Clave like '5%' or Clave like '6%' or Clave like '7%'

----------------------------
If ( @Mes2=3)
begin
Insert into @ResultadoFinal 
Select 'Saldo de la Deuda Pública', Monto, 1 from @Resultado  
where Trimestre = 1 and Descripcion <> '(-) Amortización 1'
end 
----------------------------
If ( @Mes2=6)
begin
Insert into @ResultadoFinal 
Select 'Saldo de la Deuda Pública', Monto , 2 from @Resultado  
where Trimestre = 2 and Descripcion <> '(-) Amortización 2'
end
----------------------------
If ( @Mes2=9)
begin
Insert into @ResultadoFinal 
Select 'Saldo de la Deuda Pública',  Monto, 3 from @Resultado  
where Trimestre = 3 and Descripcion <> '(-) Amortización 3'
end
----------------------------
If (@Mes2=12)
begin
Insert into @ResultadoFinal 
Select 'Saldo de la Deuda Pública', Monto, 4 from @Resultado  
where Trimestre = 4 and Descripcion <> '(-) Amortización 4'
end


------------------------
Declare @j decimal(15,2)
Select @j =isnull((Select ISNULL(Monto,0) from @ResultadoFinal where Trimestre = 0),0)

Declare @trim int
Select @trim = (case 
when @Mes2 = 3  then  1
when @Mes2 = 6  then  2
when @Mes2 = 9  then  3
when @Mes2 = 12  then  4
end)

If @j > 0
begin
Declare @l decimal(15,2)
Select @l = ((Select ISNULL(Monto,0) from @ResultadoFinal where Trimestre = @trim)*100)/@j
end
else If @j = 0
begin
Select @l = 0
end

Insert into @ResultadoFinal 
Select 'Porcentaje', @l, 5 from @ResultadoFinal  
where Trimestre = 0


---------------------
Update @ResultadoFinal  Set Trimestre = (case 
when Trimestre = 1  then 'Enero a Marzo'
when Trimestre = 2  then 'Abril a Junio'
when Trimestre = 3  then 'Julio a Septiembre'
when Trimestre = 4  then 'Octubre a Diciembre'
when Trimestre = 5  then '%'
end)


----------------------
Select Descripcion, ISNULL(Monto,0) as Monto, Trimestre from @ResultadoFinal


GO


