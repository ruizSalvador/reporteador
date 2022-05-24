/*  
=======================================================================================================  
Autor:  Karim Zavala 
=======================================================================================================  
|Versión  |Fecha      |Responsable         |Descripción de Cambio   
-------------------------------------------------------------------------------------------------------  
| 1.0   |2018.01.29 |Karim Zavala |Creación de procedimiento.   
=======================================================================================================  
*/      
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_OrdenCompraTipoAsignacion] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_OrdenCompraTipoAsignacion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_OrdenCompraTipoAsignacion]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_OrdenCompraTipoAsignacion]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
Create PROCEDURE [dbo].[SP_RPT_K2_OrdenCompraTipoAsignacion]    
@Ejercicio smallint,    
@Periodo smallint,
@TipoAsignacion varchar(max)
AS    
BEGIN   

declare @tablaPedidos as table(Folio int,Fecha varchar(10),Ejercicio varchar(10),Periodo varchar(10),Tipo varchar(max),Estatus varchar(max),Monto decimal (15,2),Proveedor varchar (max),IdPedido  int)
declare @tablaServicios as table(Folio int,Fecha varchar(10),Ejercicio varchar(10),Periodo varchar(10),Tipo varchar(max),Estatus varchar(max),Monto decimal (15,2),Proveedor varchar (max),IdOrden  int)

declare @tablaDevangados as table(Folio int,Fecha varchar(10),EstatusTP_OS varchar(max),EstatusRF varchar(max),IdPedidoOrden varchar(max),IdOrden int,IdPedido int )
declare @tablaEjercidos as table(Folio int,Fecha varchar(10),EstatusTP_OS  varchar(max),EstatusRF varchar(max),EstatusSC varchar(max),IdPedidoOrden varchar(max),IdOrden int,IdPedido int,IdRecepcionServicios int )
declare @tablaPagados as table(Folio int,Fecha varchar(10),EstatusTP_OS  varchar(max),EstatusRF varchar(max),EstatusSC varchar(max),EstatusTC varchar(max),IdPedidoOrden varchar(max),IdOrden int,IdPedido int,IdRecepcionServicios int,IdSolicitudCheque int )

if @TipoAsignacion <> '' 
begin

insert into @tablaPedidos
SELECT Folio, CONVERT(VARCHAR(10), Fecha, 103),CONVERT(VARCHAR(10),YEAR(Fecha)) as Ejercicio ,CONVERT(VARCHAR(10),MONTH (Fecha) ) as Periodo ,CTC.Descripcion as Tipo, TP .Estatus as Estatus,TotalGral as Monto,CP.RazonSocial , TP.IdPedido as IdPedido
FROM T_Pedidos  TP
INNER JOIN C_Proveedores CP
ON TP.IdProveedor=CP.IdProveedor
INNER JOIN c_tiposcompra CTC
ON CTC.IdTipoCompra=TP.IdTipoCompra
WHERE TP.idTipoCompra = @TipoAsignacion and YEAR(Fecha)=@Ejercicio and MONTH (Fecha)=@Periodo and TP .Estatus <> 'C'

insert into @tablaServicios
SELECT Folio,CONVERT(VARCHAR(10), Fecha, 103),CONVERT(VARCHAR(10),YEAR(Fecha)) as Ejercicio ,CONVERT(VARCHAR(10),MONTH (Fecha) ) as Periodo ,CTC.Descripcion as Tipo, TOS .Estatus as Estatus,TotalGral as Monto,CP.RazonSocial ,TOS.IdOrden as IdOrden 
from T_OrdenServicio TOS
INNER JOIN C_Proveedores CP
ON TOS.IdProveedor=CP.IdProveedor
INNER JOIN c_tiposcompra CTC
ON CTC.IdTipoCompra=TOS.IdTipoCompra
WHERE TOS.idTipoCompra = @TipoAsignacion and YEAR(Fecha)=@Ejercicio and MONTH (Fecha)=@Periodo and TOS .Estatus <> 'C'
order by TOS.Folio

update @tablaPedidos set Estatus='Comprometido'
update @tablaServicios set Estatus='Comprometido'

--Pedido
	--Devengado
		insert into @tablaDevangados
		select TP.Folio,TP.Fecha,TP.Estatus as Estatus_TP,RF.Estatus as EstatusRF ,'Pedido',RF.IdOrden,RF.IdPedido 
		from @tablaPedidos TP inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and RF.Estatus='G'
	--Ejercido
		insert into @tablaEjercidos 
		select TP.Folio,TP.Fecha,TP.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC ,'Pedido',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios from @tablaPedidos TP
		inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and SC.Estatus='A'
	--Pagado
		insert into @tablaPagados 
		select TP.Folio,TP.Fecha,TP.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC,TC.Status as EstatusTC ,'Pedido',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios,TC.IdSolicitudCheque from @tablaPedidos TP
		inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		inner join T_Cheques TC
		on TC.IdSolicitudCheque=SC.IdSolicitudCheques
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and TC.Status = 'D' or (TC.Status = 'I' and TC.Entregado=1)

----Orden
	--Devengado
		insert into @tablaDevangados
		select TS.Folio,TS.Fecha,TS.Estatus as Estatus_TP,RF.Estatus as EstatusRF ,'Orden',RF.IdOrden,RF.IdPedido 
		from @tablaServicios TS inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and RF.Estatus in('R','G')
	--Ejercido
		insert into @tablaEjercidos 
		select TS.Folio,TS.Fecha,TS.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC ,'Orden',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios 
		from @tablaServicios TS
		inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and SC.Estatus='A'
	--Pagado
		insert into @tablaPagados 
		select TS.Folio,TS.Fecha,TS.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC,TC.Status as EstatusTC ,'Orden',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios,TC.IdSolicitudCheque 
		from @tablaServicios TS
		inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		inner join T_Cheques TC
		on TC.IdSolicitudCheque=SC.IdSolicitudCheques
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and TC.Status = 'D' or (TC.Status = 'I' and TC.Entregado=1)

--select * from @tablaPedidos
--select * from @tablaServicios
--select *from @tablaDevangados
--select *from @tablaEjercidos
--select *from @tablaPagados
end 

if @TipoAsignacion = '' 
begin
insert into @tablaPedidos
SELECT Folio, CONVERT(VARCHAR(10), Fecha, 103),CONVERT(VARCHAR(10),YEAR(Fecha)) as Ejercicio ,CONVERT(VARCHAR(10),MONTH (Fecha) ) as Periodo ,CTC.Descripcion as Tipo, TP .Estatus as Estatus,TotalGral as Monto,CP.RazonSocial , TP.IdPedido as IdPedido
FROM T_Pedidos  TP
INNER JOIN C_Proveedores CP
ON TP.IdProveedor=CP.IdProveedor
INNER JOIN c_tiposcompra CTC
ON CTC.IdTipoCompra=TP.IdTipoCompra
WHERE YEAR(Fecha)=@Ejercicio and MONTH (Fecha)=@Periodo and TP .Estatus <> 'C'

insert into @tablaServicios
SELECT Folio,CONVERT(VARCHAR(10), Fecha, 103),CONVERT(VARCHAR(10),YEAR(Fecha)) as Ejercicio ,CONVERT(VARCHAR(10),MONTH (Fecha) ) as Periodo ,CTC.Descripcion as Tipo, TP .Estatus as Estatus,TotalGral as Monto,CP.RazonSocial ,TP.IdOrden as IdOrden 
from T_OrdenServicio TP
INNER JOIN C_Proveedores CP
ON TP.IdProveedor=CP.IdProveedor
INNER JOIN c_tiposcompra CTC
ON CTC.IdTipoCompra=TP.IdTipoCompra
WHERE YEAR(Fecha)=@Ejercicio and MONTH (Fecha)=@Periodo and TP .Estatus <> 'C'
order by TP.Folio

update @tablaPedidos set Estatus='Comprometido'
update @tablaServicios set Estatus='Comprometido'

--Pedido
	--Devengado
		insert into @tablaDevangados
		select TP.Folio,TP.Fecha,TP.Estatus as Estatus_TP,RF.Estatus as EstatusRF ,'Pedido',RF.IdOrden,RF.IdPedido 
		from @tablaPedidos TP inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and RF.Estatus='G'
	--Ejercido
		insert into @tablaEjercidos 
		select TP.Folio,TP.Fecha,TP.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC ,'Pedido',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios from @tablaPedidos TP
		inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and SC.Estatus='A'
	--Pagado
		insert into @tablaPagados 
		select TP.Folio,TP.Fecha,TP.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC,TC.Status as EstatusTC ,'Pedido',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios,TC.IdSolicitudCheque from @tablaPedidos TP
		inner join T_RecepcionFacturas RF
		on TP.IdPedido=RF.IdPedido
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		inner join T_Cheques TC
		on TC.IdSolicitudCheque=SC.IdSolicitudCheques
		WHERE  TP.Ejercicio = @Ejercicio  and TP.Periodo =@Periodo and TC.Status = 'D' or (TC.Status = 'I' and TC.Entregado=1)

----Orden
	--Devengado
		insert into @tablaDevangados
		select TS.Folio,TS.Fecha,TS.Estatus as Estatus_TP,RF.Estatus as EstatusRF ,'Orden',RF.IdOrden,RF.IdPedido 
		from @tablaServicios TS inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and RF.Estatus in('R','G')
	--Ejercido
		insert into @tablaEjercidos 
		select TS.Folio,TS.Fecha,TS.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC ,'Orden',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios 
		from @tablaServicios TS
		inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and SC.Estatus='A'
	--Pagado
		insert into @tablaPagados 
		select TS.Folio,TS.Fecha,TS.Estatus as EstatusTP,RF.Estatus as EstatusRF,SC.Estatus as EstatusSC,TC.Status as EstatusTC ,'Orden',RF.IdOrden,RF.IdPedido,SC.IdRecepcionServicios,TC.IdSolicitudCheque 
		from @tablaServicios TS
		inner join T_RecepcionFacturas RF
		on TS.IdOrden=RF.IdOrden
		inner join T_SolicitudCheques SC
		on SC.IdRecepcionServicios=RF.IdRecepcionServicios
		inner join T_Cheques TC
		on TC.IdSolicitudCheque=SC.IdSolicitudCheques
		WHERE  TS.Ejercicio = @Ejercicio  and TS.Periodo =@Periodo and TC.Status = 'D' or (TC.Status = 'I' and TC.Entregado=1)

--select * from @tablaPedidos
--select * from @tablaServicios
--select *from @tablaDevangados
--select *from @tablaEjercidos
--select *from @tablaPagados
end

--Pedido
	--Actualiza Estatus Devegado
		update @tablaPedidos set Estatus='Devengado' where IdPedido in (select IdPedido from @tablaDevangados)
	--Actualiza Estatus Ejercido
		update @tablaPedidos set Estatus='Ejercido' where IdPedido in (select IdPedido from @tablaEjercidos)
	--Actualiza Estatus Pagado
		update @tablaPedidos set Estatus='Pagado' where IdPedido in (select IdPedido from @tablaPagados)

--Orden
	--Actualiza Estatus Devegado
		update @tablaServicios set Estatus='Devengado' where IdOrden in (select IdOrden from @tablaDevangados)
	--Actualiza Estatus Ejercido
		update @tablaServicios set Estatus='Ejercido' where IdOrden in (select IdOrden from @tablaEjercidos)
	--Actualiza Estatus Pagado
		update @tablaServicios set Estatus='Pagado' where IdOrden in (select IdOrden from @tablaPagados)

select * from @tablaPedidos
union
select * from @tablaServicios
END

go
--exec SP_RPT_K2_OrdenCompraTipoAsignacion 2017,12,4
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=1,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=2,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=3,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=4,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=5,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=6,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=7,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=8,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=9,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=10,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=11,@Ejercicio=2017,@TipoAsignacion=N''
--exec SP_RPT_K2_OrdenCompraTipoAsignacion @Periodo=12,@Ejercicio=2017,@TipoAsignacion=N''