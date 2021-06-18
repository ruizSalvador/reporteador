/****** Object:  StoredProcedure [dbo].[SP_ConceptosNomina]    Script Date: 11/12/2017 13:23:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ConceptosNomina]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_ConceptosNomina]
GO
/****** Object:  StoredProcedure [dbo].[SP_ConceptosNomina]    Script Date: 11/12/2017 13:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_ConceptosNomina '',1,2020,0,0,200
CREATE PROCEDURE [dbo].[SP_ConceptosNomina]
@Desc_Concepto varchar(max),
@SaldoMayor int,
@Ejercicio int,
@IdUR int,
@IdFF int,
@IdProg int


AS
BEGIN

Declare @Result as table (
IdNomina int ,
IdConceptoNomina int,
importe decimal(18,2),
Periodo varchar(max),
Ejercicio int,
Fecha date,
ClaveArchivo varchar(max),
Descripcion varchar(max)
)

Declare @Result2 as table (
IdNomina int ,
IdConceptoNomina int,
importe decimal(18,2),
Periodo varchar(max),
Ejercicio int,
Fecha date,
ClaveArchivo varchar(max),
Descripcion varchar(max),
DetalleImporte decimal(18,2)
)

Declare @FinalResult as table (
ClaveArchivo varchar(max),
Descripcion varchar(max),
Ejercicio int,
Enero Decimal (18,2),
Febrero Decimal (18,2),
Marzo  Decimal (18,2),
Abril Decimal (18,2),
Mayo Decimal (18,2),
Junio Decimal (18,2),
Julio Decimal (18,2),
Agosto Decimal (18,2),
Septiembre Decimal (18,2),
Octubre Decimal (18,2),
Noviembre Decimal (18,2),
Diciembre Decimal (18,2),
TotalGeneral Decimal (18,2)
)

Declare @FinalResult2 as table (
ClaveArchivo varchar(max),
Descripcion varchar(max),
Ejercicio int,
Enero Decimal (18,2),
Febrero Decimal (18,2),
Marzo  Decimal (18,2),
Abril Decimal (18,2),
Mayo Decimal (18,2),
Junio Decimal (18,2),
Julio Decimal (18,2),
Agosto Decimal (18,2),
Septiembre Decimal (18,2),
Octubre Decimal (18,2),
Noviembre Decimal (18,2),
Diciembre Decimal (18,2),
TotalGeneral Decimal (18,2)
)
If @IdProg = 0
BEGIN

Insert into @Result
select DN.IdNomina,DN.IdConceptoNomina, DN.importe,
Case 
when MONTH ( tip.FechaPago )=1 then 'Enero'
when MONTH ( tip.FechaPago )=2 then 'Febrero'
when MONTH ( tip.FechaPago )=3 then 'Marzo'
when MONTH ( tip.FechaPago )=4 then 'Abril'
when MONTH ( tip.FechaPago )=5 then 'Mayo'
when MONTH ( tip.FechaPago )=6 then 'Junio'
when MONTH ( tip.FechaPago )=7 then 'Julio'
when MONTH ( tip.FechaPago )=8 then 'Agosto'
when MONTH ( tip.FechaPago )=9 then 'Septienbre'
when MONTH ( tip.FechaPago )=10 then 'Octubre'
when MONTH ( tip.FechaPago )=11 then 'Noviembre'
when MONTH ( tip.FechaPago )=12 then 'Diciembre'
end as Periodo,
YEAR(tip.FechaPago) as Ejercicio,tip.FechaPago,CCN.ClaveArchivo, CCN.Descripcion
from D_Nomina DN
left join T_ImportaNomina TIP on TIP.IdNomina=DN.IdNomina
left join C_ConceptosNomina CCN on CCN.IdConceptoNomina= DN.IdConceptoNomina
Where DN.IdAreaResp = CASE WHEN @IdUR = 0 THEN DN.IdAreaResp else @IdUR END
AND CCN.IDFUENTEFINANCIAMIENTO = CASE WHEN @IdFF = 0 THEN CCN.IDFUENTEFINANCIAMIENTO else @IdFF END


Insert into @FinalResult
select ClaveArchivo,Descripcion,Ejercicio,isnull(Enero,0),isnull(Febrero,0),isnull(Marzo,0),isnull(Abril,0),isnull(Mayo,0),isnull(Junio,0),isnull(Julio,0),isnull(Agosto,0),isnull(Septiembre,0),isnull(Octubre,0),isnull(Noviembre,0),isnull(Diciembre,0)
,SUM(isnull(Enero,0)+isnull(Febrero,0)+isnull(Marzo,0)+isnull(Abril,0)+isnull(Mayo,0)+isnull(Junio,0)+isnull(Julio,0)+isnull(Agosto,0)+isnull(Septiembre,0)+isnull(Octubre,0)+isnull(Noviembre,0)+isnull(Diciembre,0)) AS TotalGeneral
from (
select  ClaveArchivo,Descripcion,importe,Periodo,Ejercicio from @Result
)s
pivot(
  sum(importe)
  for Periodo in (Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre) 
) p
group by ClaveArchivo,Descripcion,Ejercicio,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre
order by Ejercicio


 if @Desc_Concepto <> '' and @SaldoMayor= 1 begin 
 select * from @FinalResult where Ejercicio=@Ejercicio and Descripcion=@Desc_Concepto and TotalGeneral > 0
 end
  else if @Desc_Concepto <> '' and @SaldoMayor= 0 begin 
 select * from @FinalResult where Ejercicio=@Ejercicio and Descripcion=@Desc_Concepto 
 end
  if @Desc_Concepto = '' and @SaldoMayor= 1 begin 
 select * from @FinalResult where Ejercicio=@Ejercicio  and TotalGeneral > 0
 end
  if @Desc_Concepto ='' and @SaldoMayor = 0 begin 
 select * from @FinalResult where Ejercicio=@Ejercicio 
 end

END
 --------------------------------------------------------------------------------
 ELSE
BEGIN
	Insert into @Result2
	select distinct DN.IdNomina,DN.IdConceptoNomina, DN.importe,
	Case 
	when MONTH ( tip.FechaPago )=1 then 'Enero'
	when MONTH ( tip.FechaPago )=2 then 'Febrero'
	when MONTH ( tip.FechaPago )=3 then 'Marzo'
	when MONTH ( tip.FechaPago )=4 then 'Abril'
	when MONTH ( tip.FechaPago )=5 then 'Mayo'
	when MONTH ( tip.FechaPago )=6 then 'Junio'
	when MONTH ( tip.FechaPago )=7 then 'Julio'
	when MONTH ( tip.FechaPago )=8 then 'Agosto'
	when MONTH ( tip.FechaPago )=9 then 'Septienbre'
	when MONTH ( tip.FechaPago )=10 then 'Octubre'
	when MONTH ( tip.FechaPago )=11 then 'Noviembre'
	when MONTH ( tip.FechaPago )=12 then 'Diciembre'
	end as Periodo,
	YEAR(tip.FechaPago) as Ejercicio,tip.FechaPago,CCN.ClaveArchivo, CCN.Descripcion
	,DNE.Importe
	from D_Nomina DN
	Join D_NominaEmpleado DNE on DN.IdRenglonNomina = DNE.IdRenglonNomina
	Join T_EmpPlaza TEP on DNE.NumeroEmpleado = TEP.IdEmpleado
	JOIN C_Plazas CP on CP.IdPlaza = TEP.IdPlaza
    join T_ImportaNomina TIP on TIP.IdNomina=DN.IdNomina
	join C_ConceptosNomina CCN on CCN.IdConceptoNomina= DN.IdConceptoNomina
	Where IdProyecto = @IdProg
	AND DN.IdAreaResp = CASE WHEN @IdUR = 0 THEN DN.IdAreaResp else @IdUR END
	AND CCN.IDFUENTEFINANCIAMIENTO = CASE WHEN @IdFF = 0 THEN CCN.IDFUENTEFINANCIAMIENTO else @IdFF END

Insert into @FinalResult2
select ClaveArchivo,Descripcion,Ejercicio,isnull(Enero,0),isnull(Febrero,0),isnull(Marzo,0),isnull(Abril,0),isnull(Mayo,0),isnull(Junio,0),isnull(Julio,0),isnull(Agosto,0),isnull(Septiembre,0),isnull(Octubre,0),isnull(Noviembre,0),isnull(Diciembre,0)
,SUM(isnull(Enero,0)+isnull(Febrero,0)+isnull(Marzo,0)+isnull(Abril,0)+isnull(Mayo,0)+isnull(Junio,0)+isnull(Julio,0)+isnull(Agosto,0)+isnull(Septiembre,0)+isnull(Octubre,0)+isnull(Noviembre,0)+isnull(Diciembre,0)) AS TotalGeneral
from (
select  ClaveArchivo,Descripcion,DetalleImporte,Periodo,Ejercicio from @Result2
)s
pivot(
  sum(DetalleImporte)
  for Periodo in (Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre) 
) p
group by ClaveArchivo,Descripcion,Ejercicio,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre
order by Ejercicio

 if @Desc_Concepto <> '' and @SaldoMayor= 1 begin 
 select * from @FinalResult2 where Ejercicio=@Ejercicio and Descripcion=@Desc_Concepto and TotalGeneral > 0
 end
  else if @Desc_Concepto <> '' and @SaldoMayor= 0 begin 
 select * from @FinalResult2 where Ejercicio=@Ejercicio and Descripcion=@Desc_Concepto 
 end
  if @Desc_Concepto = '' and @SaldoMayor= 1 begin 
 select * from @FinalResult2 where Ejercicio=@Ejercicio  and TotalGeneral > 0
 end
  if @Desc_Concepto ='' and @SaldoMayor = 0 begin 
 select * from @FinalResult2 where Ejercicio=@Ejercicio 
 end

END

END
GO 


Exec SP_CFG_LogScripts 'SP_ConceptosNomina','2.30.1'
GO