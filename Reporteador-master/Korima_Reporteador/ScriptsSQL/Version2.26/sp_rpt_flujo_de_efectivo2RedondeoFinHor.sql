
/****** Object:  StoredProcedure [dbo].[sp_rpt_flujo_de_efectivo2RedondeoFinHor]    Script Date: 12/03/2012 17:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_rpt_flujo_de_efectivo2RedondeoFinHor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo2RedondeoFinHor]
GO

-- Exec sp_rpt_flujo_de_efectivo2RedondeoFinHor 2015,4,4,2015,0,1,1,2
CREATE PROCEDURE [dbo].[sp_rpt_flujo_de_efectivo2RedondeoFinHor]
@ejercicio int, @periodo int, @PeriodoFin int,@ejercicio2 int, @miles Bit, @MostrarVacios bit, @Redondeo bit, @Tipo int
AS


DECLARE @Division int
if @miles=1 set @Division=1000
else set @Division = 1


					
DECLARE @report TABLE (
	nombre varchar(255), 
	SaldoActual decimal (15,2) , 
	SaldoAnterior decimal (15,2), 
	negritas tinyint, 
	secciongroup char(1), 
	orden decimal(15,2))

DECLARE @report2 TABLE (
	nombre varchar(255), 
	SaldoActual decimal (15,2) , 
	SaldoAnterior decimal (15,2), 
	negritas tinyint, 
	secciongroup char(1), 
	orden decimal(15,2))

DECLARE @report3 TABLE (
	nombre varchar(255), 
	SaldoActual decimal (15,2) , 
	SaldoAnterior decimal (15,2), 
	negritas tinyint, 
	secciongroup char(1), 
	orden decimal(15,2))
	


Insert Into @report
Exec sp_rpt_flujo_de_efectivoRedondeo @ejercicio, @periodo, @miles, @MostrarVacios,@Redondeo

Insert into @report2
Exec sp_rpt_flujo_de_efectivoRedondeo @ejercicio2, @PeriodoFin, @miles, @MostrarVacios,@Redondeo

Insert Into @report3
Select 
	Uno.nombre, 
	Uno.SaldoActual, 
	Dos.SaldoActual as SaldoAnterior, 
	Uno.negritas, 
	Uno.secciongroup, 
	Uno.orden 
From @report Uno
inner Join @report2 Dos
On Uno.orden = Dos.orden where Uno.nombre= Dos.nombre


If @Tipo = 1
	Begin
		Update @report3 set orden = 38.5 Where nombre = 'Flujos de efectivo de las actividades de inversión'
		Select Top(35)* From @report3 Where orden Between 0 and 38
	End

If @Tipo =2
	Begin
		--Update @report3 set orden = 1 Where nombre = 'Flujos netos de efectivo por actividades de gestión'
		Delete Top(42) @report3
		Select Top(24)* From @report3 -- Where orden Between 38 and 60
	End

If @TIpo = 3
	Begin
		Select * From @report3
	End
--if @MostrarVacios=1 
--begin
--	if @Redondeo=1
--	begin
--	Select UPPER(LEFT(nombre,1))+LOWER(SUBSTRING(nombre,2,LEN(nombre))) as nombre, Round((ISNULL(SaldoActual,0)/@Division),0) as SaldoActual, Round((ISNULL(SaldoAnterior,0)/@Division),0) as SaldoAnterior,
--	negritas, secciongroup, orden from @report3 Order by orden
--	end
--	else
--	begin
--	Select UPPER(LEFT(nombre,1))+LOWER(SUBSTRING(nombre,2,LEN(nombre))) as nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
--	negritas, secciongroup, orden from @report3 Order by orden
--	end
--end
--Else 
--begin
--	if @Redondeo=1
--	begin
--		Select UPPER(LEFT(nombre,1))+LOWER(SUBSTRING(nombre,2,LEN(nombre))) as nombre, Round((ISNULL(SaldoActual,0)/@Division),0) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
--		negritas, secciongroup, orden from @report3  Where (SaldoActual<>0 or SaldoAnterior <>0) or negritas in(1,3)  Order by orden
--	end
--	else
--	begin
--		Select UPPER(LEFT(nombre,1))+LOWER(SUBSTRING(nombre,2,LEN(nombre))) as nombre, (ISNULL(SaldoActual,0)/@Division) as SaldoActual, (ISNULL(SaldoAnterior,0)/@Division) as SaldoAnterior,
--		negritas, secciongroup, orden from @report3  Where (SaldoActual<>0 or SaldoAnterior <>0) or negritas in(1,3)  Order by orden
--	end
--End


GO

EXEC SP_FirmasReporte 'Estado de Flujos de Efectivo'
GO

UPDATE C_Menu SET Utilizar = 1 WHERE IdMenu = 1078
GO

--exec sp_rpt_flujo_de_efectivo2RedondeoFinHor @ejercicio=2017,@periodo=1,@PeriodoFin=9,@ejercicio2=2017,@Tipo=3,@miles=0,@MostrarVacios=1,@Redondeo=0