/****** Object:  StoredProcedure [dbo].[SP_RPT_FormatoProgramaRecursosOrdendeGob]    Script Date: 03/22/2013 10:23:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_FormatoProgramaRecursosOrdendeGob]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_FormatoProgramaRecursosOrdendeGob]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_FormatoProgramaRecursosOrdendeGob]    Script Date: 03/22/2013 10:23:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_FormatoProgramaRecursosOrdendeGob] 

@Mes  as int,   
@Mes2  as int,
@Ejercicio as int


AS
BEGIN

--------------------Genero la tabla temporal
Declare @Resultado as TABLE(
Clave varchar(8),
Programa varchar (255),
RamoFed varchar (255),
MontoFed decimal (15,2),
RamoEst varchar (255),
MontoEst decimal (15,2),
RamoMpal varchar (255),
MontoMpal decimal (15,2),
RamoOtros varchar (255),
MontoOtros decimal (15,2),
MontoTotal decimal (15,2)
)


--------------------Inserto Programa y montoFederal
INSERT INTO @Resultado (Clave,Programa, MontoFed)
SELECT  cepr.id, cepr.nombre,
 sum(isnull(TP.Pagado,0)) as MontoFed
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto 
left join C_FuenteFinanciamiento cff
on cff.IDFUENTEFINANCIAMIENTO  = ts.IdFuenteFinanciamiento  
  

Where   (Mes BETWEEN  @Mes AND @Mes2) AND Year=@Ejercicio   AND CEPR.Nivel = '5' and cff.TIPOORIGENRECURSO = 'F' and TP.Pagado <> 0
GROUP BY CEPR.Clave, CEPR.Nombre, cff.CLAVE , cff.DESCRIPCION ,cff.TIPOORIGENRECURSO,cepr.id
ORDER BY CEPR.Nombre

-------------------Inserto Programa y montoEstatal
INSERT INTO @Resultado (Clave,Programa, MontoEst)

SELECT  cepr.id,cepr.nombre,  

sum(isnull(TP.Pagado,0)) as MontoEst
                
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto 
left join C_FuenteFinanciamiento cff
on cff.IDFUENTEFINANCIAMIENTO  = ts.IdFuenteFinanciamiento  


Where   (Mes BETWEEN  @Mes AND @Mes2) AND Year=@Ejercicio   AND CEPR.Nivel = '5' and cff.TIPOORIGENRECURSO = 'E' and TP.Pagado <> 0
GROUP BY CEPR.Clave, CEPR.Nombre, cff.CLAVE , cff.DESCRIPCION ,cff.TIPOORIGENRECURSO,cepr.id
ORDER BY CEPR.Nombre

--------------------Inserto Programa y montoMunicipal
INSERT INTO @Resultado (Clave,Programa, MontoMpal)

SELECT cepr.id, cepr.nombre, 
sum(isnull(TP.Pagado,0)) as MontoMpal

From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto  
left join C_FuenteFinanciamiento cff
on cff.IDFUENTEFINANCIAMIENTO  = ts.IdFuenteFinanciamiento  


Where   (Mes BETWEEN  @Mes AND @Mes2) AND Year=@Ejercicio   AND CEPR.Nivel = '5' and cff.TIPOORIGENRECURSO = 'M' and TP.Pagado <> 0
GROUP BY CEPR.Clave, CEPR.Nombre, cff.CLAVE , cff.DESCRIPCION ,cff.TIPOORIGENRECURSO,cepr.id
ORDER BY CEPR.Nombre

-------------------Inserto Programa y montoOtros
INSERT INTO @Resultado (Clave,Programa,  MontoOtros)
SELECT cepr.clave, cepr.nombre,
sum(isnull(TP.Pagado,0)) as MontoOtros
                
From T_PresupuestoNW  TP
inner join T_SellosPresupuestales TS 
on TP.IdSelloPresupuestal = TS.IdSelloPresupuestal
inner join   C_EP_Ramo  CEPR 
on CEPR.Id = TS.IdProyecto  
left join C_FuenteFinanciamiento cff
on cff.IDFUENTEFINANCIAMIENTO  = ts.IdFuenteFinanciamiento  


Where   (Mes BETWEEN  @Mes AND @Mes2) AND Year=@Ejercicio   AND CEPR.Nivel = '5' and cff.TIPOORIGENRECURSO in ('A','D','P','O') and TP.Pagado <> 0
GROUP BY CEPR.Clave, CEPR.Nombre, cff.CLAVE , cff.DESCRIPCION ,cff.TIPOORIGENRECURSO,cepr.clave
ORDER BY CEPR.Nombre

----------------Actualizo MontoTotal
Update @Resultado  Set MontoTotal =   isnull(MontoFed,0) + isnull(MontoEst,0) + isnull(MontoMpal,0) + isnull(MontoOtros,0)
 

-----------------Despliego resultados
Select Clave, Programa,RamoFed, isnull(MontoFed,0) as MontoFed, RamoEst, isnull(MontoEst,0) as MontoEst, RamoMpal, isnull(MontoMpal,0) as MontoMpal, RamoOtros, isnull(MontoOtros,0) as MontoOtros, isnull(MontoTotal,0) as MontoTotal
from @Resultado 


END

GO

EXEC SP_FirmasReporte 'Formato de Programas con Recursos Concurrente por Orden de Gobierno'
GO

UPDATE C_Menu SET Utilizar=1 WHERE IdMenu in(1202)
GO
