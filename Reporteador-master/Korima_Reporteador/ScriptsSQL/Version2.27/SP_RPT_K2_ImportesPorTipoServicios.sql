/*  
=======================================================================================================  
Autor:  Karim Zavala 
=======================================================================================================  
|Versión  |Fecha      |Responsable         |Descripción de Cambio   
-------------------------------------------------------------------------------------------------------  
| 1.0   |2018.02.23 |Karim Zavala |Creación de procedimiento.   
=======================================================================================================  
*/      
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ImportesPorTipoServicios] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_ImportesPorTipoServicios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_ImportesPorTipoServicios]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_ImportesPorTipoServicios]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
Create PROCEDURE [dbo].[SP_RPT_K2_ImportesPorTipoServicios]    
@Ejercicio smallint,    
@Mes1 smallint,
@Mes2 smallint,
@TipoServicio varchar(max)
AS    
BEGIN   

declare @tablaPedidos as table(Folio int,Fecha varchar(10),Ejercicio varchar(10),Periodo varchar(10),Tipo varchar(max),Estatus varchar(max),Monto decimal (15,2),Proveedor varchar (max),IdPedido  int)

if @TipoServicio <> '' 
begin

Select DOS .IdTipoServicio,
	   CTS.DescripcionTipoServicio, 
       CTS.IdPartida, 
	   TOS.Fecha, 
	   DOS.Cantidad, 
	   DOS.CostoUnitario, 
	   DOS.IVA ,
	   MONTH(TOS.Fecha) AS Mes,
	   YEAR(TOS.Fecha) as Ejercicio
from C_TipoServicios CTS
inner join D_OrdenServicio DOS on CTS.IdTipoServicio = DOS.IdTipoServicio  
inner join T_OrdenServicio TOS on DOS.IdOrden = TOS.IdOrden 
WHERE MONTH(TOS.Fecha)  BETWEEN @Mes1 AND @Mes2 and YEAR(TOS.Fecha)=@Ejercicio
and DOS.IdTipoServicio =@TipoServicio; 
end 

if @TipoServicio = '' 
Select DOS .IdTipoServicio,
       CTS.DescripcionTipoServicio, 
       CTS.IdPartida, 
	   TOS.Fecha, 
	   DOS.Cantidad, 
	   DOS.CostoUnitario, 
	   DOS.IVA ,
	   MONTH(TOS.Fecha) AS Mes,
	   YEAR(TOS.Fecha) as Ejercicio
	   
from C_TipoServicios CTS
inner join D_OrdenServicio DOS on CTS.IdTipoServicio = DOS.IdTipoServicio  
inner join T_OrdenServicio TOS on DOS.IdOrden = TOS.IdOrden 
WHERE MONTH(TOS.Fecha)  BETWEEN @Mes1 AND @Mes2 and YEAR(TOS.Fecha)=@Ejercicio
end

go
--exec SP_RPT_K2_ImportesPorTipoServicios @Mes1=1,@Mes2=2,@Ejercicio=2017,@TipoServicio=9951
--exec SP_RPT_K2_ImportesPorTipoServicios @Mes1=1,@Mes2=2,@Ejercicio=2017,@TipoServicio=N''
