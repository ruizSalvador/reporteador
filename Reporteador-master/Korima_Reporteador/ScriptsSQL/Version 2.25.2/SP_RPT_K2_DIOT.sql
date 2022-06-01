
 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_DIOT]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_DIOT] ') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_DIOT] 
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_DIOT]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
--Exec SP_RPT_K2_DIOT 2,2016  
create Procedure [dbo].[SP_RPT_K2_DIOT]  
@mes as int, @Ejercicio as int  
AS  
Declare @Campo8 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo8   
select T_Pedidos.IdProveedor, (T_Cheques.ImporteCheque/1.16)  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
where d_pedidos.PorcIva=16  
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')  
  
--group by T_Pedidos.idproveedor, T_Pedidos.Total, T_Pedidos.IdPedido  
UNION ALL 
--select T_OrdenServicio.IdProveedor ,  
--sum (T_RecepcionFacturas.SubTotal)  
select T_OrdenServicio.IdProveedor,(T_Cheques.ImporteCheque/1.16) 
from --D_OrdenServicio join   
T_OrdenServicio   
--ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques  
 where T_OrdenServicio.IVA>0  AND 
 T_OrdenServicio.TipodeCambio=0 
  AND(MONTH(T_Cheques.Fecha)=@mes AND YEAR(T_Cheques.Fecha)=@Ejercicio)  
 AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')  
 --and T_OrdenServicio.IdProveedor = 148  
 --group by T_OrdenServicio.idproveedor, T_OrdenServicio.Total, T_OrdenServicio.IdOrden  
 ---------  
Declare @_Campo8 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo8   
select c8.IdProveedor, SUM (c8.Importe) from @campo8 as c8 group by c8.IdProveedor   
 ---------------------------------------  
Declare @Campo14 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo14   
select T_Pedidos.IdProveedor ,  
sum (isnull(d_pedidos.Importe,0) * isnull(T_Pedidos.TipodeCambio,0))  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
where d_pedidos.PorcIva=16  
AND T_Pedidos.TipodeCambio<>0  
AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
group by T_Pedidos.idproveedor  
UNION  
select T_OrdenServicio.IdProveedor ,  
sum (isnull(D_OrdenServicio.Importe,0) * isnull(T_OrdenServicio.TipodeCambio,0) )  
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
 where D_OrdenServicio.PorcIva=16  
 AND T_OrdenServicio.TipodeCambio<>0  
 AND(MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
 group by T_OrdenServicio.idproveedor  
 Declare @_Campo14 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo14   
select c14.IdProveedor, SUM (c14.Importe) from @campo14 as c14 group by c14.IdProveedor   
--------------------------------------  
Declare @Campo18 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo18  
select T_Pedidos.IdProveedor ,  
sum (isnull(d_pedidos.Importe,0) * isnull(T_Pedidos.TipodeCambio,0))  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
where d_pedidos.PorcIva=0  
AND T_Pedidos.TipodeCambio<>0  
AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
group by T_Pedidos.idproveedor  
UNION  
select T_OrdenServicio.IdProveedor ,  
sum (isnull(D_OrdenServicio.Importe,0) * isnull(T_OrdenServicio.TipodeCambio,0) )  
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
AND(MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
where D_OrdenServicio.PorcIva=0  
AND T_OrdenServicio.TipodeCambio<>0  
group by T_OrdenServicio.idproveedor  
------  
Declare @_Campo18 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo18   
select c18.IdProveedor, SUM (c18.Importe) from @campo18 as c18 group by c18.IdProveedor   
--------------------------------------  
Declare @Campo19 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo19   
select T_Pedidos.IdProveedor ,  
sum (d_pedidos.Importe)  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
where d_pedidos.TipoIva = 2  
AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
group by T_Pedidos.idproveedor  
UNION  
select T_OrdenServicio.IdProveedor ,  
sum (D_OrdenServicio.Importe)  
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
 where D_OrdenServicio.TipoIva = 2  
 AND(MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
 group by T_OrdenServicio.idproveedor  
 ------  
Declare @_Campo19 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo19   
select c19.IdProveedor, SUM (c19.Importe) from @campo19 as c19 group by c19.IdProveedor   
--------------------------------------  
Declare @Campo20 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo20  
select T_Pedidos.IdProveedor ,  
sum (isnull(d_pedidos.Importe,0)) --* isnull(T_Pedidos.TipodeCambio,0))  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
where d_pedidos.TipoIva = 3  
AND T_Pedidos.TipodeCambio = 0  
AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
group by T_Pedidos.idproveedor  
UNION  
select T_OrdenServicio.IdProveedor ,  
sum (isnull(D_OrdenServicio.Importe,0) * isnull(T_OrdenServicio.TipodeCambio,0) )  
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
 where D_OrdenServicio.TipoIva = 3  
 AND(MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
 AND T_OrdenServicio.TipodeCambio = 0  
 group by T_OrdenServicio.idproveedor  
 ------  
Declare @_Campo20 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo20   
select c20.IdProveedor, SUM (c20.Importe) from @campo20 as c20 group by c20.IdProveedor   
--------------------------------------  
Declare @Campo21 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @Campo21  
select T_OrdenServicio.IdProveedor ,  
sum (R_RetencionesOrden.Importe)  
from R_RetencionesOrden join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = R_RetencionesOrden.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
JOIN C_Deducciones  
ON C_Deducciones.DEDUCCION = R_RetencionesOrden.IdRetencion  
 where (MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
 AND T_OrdenServicio.TipodeCambio=0  
 AND C_Deducciones.IvaRet = 1  
 group by T_OrdenServicio.idproveedor  
--------------------------------------  
Declare @Campo22 as table (IdProveedor INT,Importe DECIMAL(18,0))  
INSERT INTO @Campo22  
SELECT T_NotaCredito.IdProveedor ,  
SUM (T_NotaCredito.IVA)  
FROM T_NotaCredito  
GROUP BY T_NotaCredito.idproveedor  
-----------------------------------  
select   
case  NacionalExtanjero  
 when 'N' then '04'  
 when 'E' then '05'  
 when 'G' then '15'  
 else '04'  
end as Campo1 ,  
85 as Campo2,  
RFC as Campo3,  
isnull(Opt_05,'') as Campo4,  
isnull(Tecnico,'') as Campo5,   
isnull(C_PaisesDIOT.Clave,'') as Campo6,  
isnull(C_PaisesDIOT.Nacionalidad,'') as Campo7,  
isnull(convert(varchar(max),sum(C8.Importe)),0)  as Campo8,  
0 as Campo9,  
0 as Campo10,  
0 as Campo11,  
0 as Campo12,  
0 as Campo13,  
isnull(convert(varchar(max),sum(C14.Importe)),'')  as Campo14,  
0 as Campo15,  
0 as Campo16,  
0 as Campo17,  
isnull(convert(varchar(max),sum(C18.Importe)),0)  as Campo18,  
isnull(convert(varchar(max),sum(C19.Importe)),0)  as Campo19,  
isnull(convert(varchar(max),sum(C20.Importe)),0)  as Campo20,  
isnull(convert(varchar(max),sum(C21.Importe)),0)  as Campo21,  
isnull(convert(varchar(max),sum(C22.Importe)),0)  as Campo22  
FROM c_proveedores  
LEFT OUTER JOIN C_PaisesDIOT  
ON C_PaisesDIOT.Clave=c_proveedores.Cargo   
LEFT OUTER JOIN @_Campo8 as C8  
on C8.IdProveedor=C_Proveedores.IdProveedor   
LEFT OUTER JOIN @_Campo14 as C14  
on C14.IdProveedor=C_Proveedores.IdProveedor   
LEFT OUTER JOIN @_Campo18 as C18  
on C18.IdProveedor=C_Proveedores.IdProveedor   
LEFT OUTER JOIN @_Campo19 as C19  
on C19.IdProveedor=C_Proveedores.IdProveedor   
LEFT OUTER JOIN @_Campo20 as C20  
on C20.IdProveedor=C_Proveedores.IdProveedor  
 left outer JOIN @Campo21 as C21  
ON C21.IdProveedor=C_Proveedores.IdProveedor   
LEFT OUTER JOIN @Campo22 as C22  
ON C22.IdProveedor=C_Proveedores.IdProveedor  
where TipoProveedor='P' and RFC <>'' and C8.Importe > 0 or C18.Importe > 0 or C19.Importe > 0 or C20.Importe > 0 or C21.Importe > 0 or C22.Importe > 0  
group by NacionalExtanjero,c_proveedores.RFC,  
Opt_05,c_proveedores.Tecnico,C_PaisesDIOT.Clave,  
C_PaisesDIOT.Nacionalidad   
order by rfc  
  