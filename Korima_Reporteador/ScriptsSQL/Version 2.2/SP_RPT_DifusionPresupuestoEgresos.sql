/****** Object:  StoredProcedure [dbo].[SP_DifusionPresupuestoEgresos]    Script Date: 03/26/2013 16:35:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DifusionPresupuestoEgresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_DifusionPresupuestoEgresos]
GO
/****** Object:  StoredProcedure [dbo].[SP_DifusionPresupuestoEgresos]    Script Date: 03/26/2013 16:35:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DifusionPresupuestoEgresos]
@Ejercicio  as int


AS 
BEGIN

Declare @Resultado as TABLE(
Clave varchar(8),
Descripcion varchar (255),
Mes int,
Monto decimal (15,2)
)

---------------------

INSERT INTO @Resultado 
Select C_CapitulosNEP.IdCapitulo , C_CapitulosNEP.Descripcion  , T_PresupuestoNW.Mes, sum(T_PresupuestoNW.Autorizado) As Monto
		from T_PresupuestoNW inner join T_SellosPresupuestales	
		On T_PresupuestoNW.IdSelloPresupuestal = T_SellosPresupuestales.IdSelloPresupuestal
		left  join C_PartidasPres
		on C_PartidasPres.IdPartida = T_SellosPresupuestales.IdPartida 
		right  join C_ConceptosNEP
		on C_PartidasPres.IdConcepto = C_ConceptosNEP.IdConcepto 
		left  join C_CapitulosNEP
		on C_ConceptosNEP.IdCapitulo  = C_CapitulosNEP.IdCapitulo 
		
		where T_PresupuestoNW.year = @Ejercicio and T_PresupuestoNW.Mes = 0 
		
		group by C_CapitulosNEP.IdCapitulo,C_CapitulosNEP.Descripcion,T_PresupuestoNW.Mes 
		order by C_CapitulosNEP.IdCapitulo

-------------------		

INSERT INTO @Resultado (Clave, Descripcion,Mes,Monto)
SELECT distinct cc.IdCapitulo,cc.Descripcion ,0,0
From C_CapitulosNEP  as cc
where  cc.Descripcion NOT IN( select Descripcion from @Resultado)		
	
-------------------
		
SELECT Clave, Descripcion,Mes,isnull(Monto,0)as Monto
from @Resultado
Order by clave

END
GO

EXEC SP_FirmasReporte 'Difusión a la Ciudadanía del Presupuesto de Egresos'
GO

UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1205)
GO
