/****** Object:  StoredProcedure [dbo].[SP_CalendarioPresupuestoEgresos]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CalendarioPresupuestoEgresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_CalendarioPresupuestoEgresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_CalendarioPresupuestoEgresos]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_CalendarioPresupuestoEgresos]
@Ejercicio  as int


AS 
BEGIN

Declare @Resultado as TABLE(
IdClave varchar(8),
Descripcion1 varchar (255),
Clave varchar (8),
Descripcion varchar (255),
[0] decimal (15,2),
[1] decimal (15,2),
[2] decimal (15,2),
[3] decimal (15,2),
[4] decimal (15,2),
[5] decimal (15,2),
[6] decimal (15,2),
[7] decimal (15,2),
[8] decimal (15,2),
[9] decimal (15,2),
[10] decimal (15,2),
[11] decimal (15,2),
[12] decimal (15,2)
)

INSERT INTO @Resultado 
Select IdCapitulo As IdClave, PartidaTransferencia As Descripcion1, IdConcepto As Clave,  Descripcion As Descripcion,
 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
From (
		Select C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.PartidaTransferencia , C_ConceptosNEP.IdConcepto,  C_ConceptosNEP.Descripcion, T_PresupuestoNW.Mes, isnull(T_PresupuestoNW.Autorizado,0) As Aprobado
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		where T_PresupuestoNW.year = @Ejercicio 
		
	 ) as p
	PIVOT 
	( 
		sum(Aprobado) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	)
 AS PivotTable

Order by IdClave

-------------------------

INSERT INTO @Resultado (IdClave,Clave, Descripcion,[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
SELECT distinct cc.IdCapitulo, cc.IdConcepto ,cc.Descripcion ,0,0,0,0,0,0,0,0,0,0,0,0,0
From C_ConceptosNEP  as cc
where  cc.Descripcion NOT IN( select Descripcion from @Resultado)



---------------
Update @Resultado  Set Descripcion1 = (case 
when IdClave = 1000 then 'SERVICIOS PERSONALES'  
when IdClave = 2000 then 'MATERIALES Y SUMINISTROS' 
when IdClave = 3000 then 'SERVICIOS GENERALES'
when IdClave = 4000 then 'TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y OTRAS AYUDAS' 
when IdClave = 5000 then 'BIENES MUEBLES, INMUEBLES E INTANGIBLES' 
when IdClave = 6000 then 'INVERSION PUBLICA' 
when IdClave = 7000 then 'INVERSIONES FINANCIERAS Y OTRAS PROVISIONES' 
when IdClave = 8000 then 'PARTICIPACIONES Y APORTACIONES'
when IdClave = 9000 then 'DEUDA PUBLICA' 
 end)
------------------

SELECT IdClave,Descripcion1,Clave, Descripcion,isnull([0],0) as [0],isnull([1],0) as [1],isnull([2],0) as [2],isnull([3],0) as [3],isnull([4],0) as [4],
isnull([5],0) as [5],isnull([6],0) as [6],isnull([7],0) as [7],isnull([8],0) as [8],isnull([9],0) as [9],isnull([10],0) as [10],
isnull([11],0) as [11],isnull([12],0) as [12]
from @Resultado
Order by clave



END 


GO


EXEC SP_FirmasReporte 'Calendario de Egresos Base Mensual'
GO



UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1201)
GO