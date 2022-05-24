 /****** Object:  StoredProcedure [dbo].[SP_RPT_K2_DIOT_V2]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_DIOT_V2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_DIOT_V2] 
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_DIOT_V2]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

-- Exec SP_RPT_K2_DIOT_V2 9,2020
CREATE Procedure [dbo].[SP_RPT_K2_DIOT_V2]  
@mes as int, @Ejercicio as int  
AS 
---------------------------------------------------------ACT 16%-------------------------------- 
Declare @Campo8 as table (IdProveedor int,Importe Decimal(18,0)) 
--OC 
insert into @Campo8   
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99)  
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL 
--OC-A
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido    
INNER JOIN T_Cheques  
ON T_Cheques.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo   
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99)  
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL 

--OC-C
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
WHERE (D_Pedidos.PorcIva Between 15.01 and 16.99) 
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio) 
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL
--OS
SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva Between 15.01 and 16.99)
Group by T_Ord.IdProveedor

UNION ALL

--OS-A

SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo   
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva Between 15.01 and 16.99)
Group by T_Ord.IdProveedor

UNION ALL
--OS-C
SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')  
AND (D_Ord.PorcIva Between 15.01 and 16.99)
Group by T_Ord.IdProveedor

UNION ALL

SELECT D_Viaticos.IdProveedor, 
D_Viaticos.Importe from T_Viaticos 
inner join D_Viaticos On
T_Viaticos.IdViaticos = D_Viaticos.IdViatico
Where (MONTH(T_Viaticos.Fecha)=@mes and YEAR(T_Viaticos.Fecha)=@Ejercicio)  
And D_Viaticos.IVA_PORC = 16 AND T_Viaticos.Estatus = 'A'
 
 ---------  
Declare @_Campo8 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo8   
select c8.IdProveedor, SUM (c8.Importe) from @campo8 as c8 group by c8.IdProveedor   
----------------------------------------  
---------------------------------------------------------ACT 8%-------------------------------- 
--OC
Declare @Campo13_1 as table (IdProveedor int, Importe Decimal(18,0))  
insert into @Campo13_1

SELECT T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
FROM D_Pedidos INNER JOIN T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido INNER JOIN T_RecepcionFacturas 
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido INNER JOIN T_SolicitudCheques 
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques 
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99)
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.idproveedor, T_Cheques.ImporteCheque

UNION ALL 

--OC-A
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido     
INNER JOIN T_Cheques  
ON T_Cheques.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo   
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99)  
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL 

--OC-C
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
WHERE (D_Pedidos.PorcIva Between 7.01 and 8.99) 
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio) 
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL
--OS
SELECT T_Ord.IdProveedor,
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecFac.IdPoliza = TPol.IdPoliza
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva Between 7.01 and 8.99)
Group by T_Ord.IdProveedor

UNION ALL

--OS-A

SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo   
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva Between 7.01 and 8.99)
Group by T_Ord.IdProveedor

UNION ALL
--OS-C
SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
--MONTH(T_Ord.Fecha) = @mes AND YEAR(T_Ord.Fecha) = @Ejercicio 
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')  
AND (D_Ord.PorcIva Between 7.01 and 8.99)
Group by T_Ord.IdProveedor

UNION ALL 

SELECT D_Viaticos.IdProveedor, D_Viaticos.Importe 
FROM T_Viaticos INNER JOIN D_Viaticos ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio) 
AND D_Viaticos.IVA_PORC = 8 AND T_Viaticos.Estatus = 'A'


Declare @_Campo13_1 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo13_1   
select c13_1.IdProveedor, SUM (c13_1.Importe) from @Campo13_1 as c13_1 group by c13_1.IdProveedor
-------------------------------------------------------
---------------------------------------------------------IMP 16%-------------------------------- 

  
--------------------------------------  
---------------------------------------------------------ACT 0%-------------------------------- 

Declare @Campo19 as table (IdProveedor int,Importe Decimal(18,0)) 
--OC 
insert into @Campo19   
select T_Pedidos.IdProveedor ,  
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral))  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
--where d_pedidos.TipoIva = 2  
where (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
group by T_Pedidos.idproveedor
  
UNION ALL

--OC-A
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido     
INNER JOIN T_Cheques  
ON T_Cheques.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo   
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)  
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL 

--OC-C
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 2)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio) 
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL

--OS  
select T_OrdenServicio.IdProveedor ,  
SUM((D_OrdenServicio.Importe)*((T_Cheques.Importecheque)/T_OrdenServicio.TotalGral)) 
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
 --where D_OrdenServicio.TipoIva = 2  
where  (D_OrdenServicio.PorcIva = 0 and D_OrdenServicio.TipoIVA = 2)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
 group by T_OrdenServicio.idproveedor  
 -----------------
 UNION ALL

--OS-A

SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo   
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 2)
Group by T_Ord.IdProveedor

UNION ALL
--OS-C
SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')  
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 2)
Group by T_Ord.IdProveedor

UNION ALL

SELECT D_Viaticos.IdProveedor, D_Viaticos.Importe 
FROM T_Viaticos INNER JOIN D_Viaticos ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio) 
AND (D_Viaticos.IVA_PORC = 0 and D_Viaticos.IdTipoIVA = 2) AND T_Viaticos.Estatus = 'A'

Declare @_Campo19 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo19   
select c19.IdProveedor, SUM (c19.Importe) from @campo19 as c19 group by c19.IdProveedor   
--------------------------------------  
---------------------------------------------------------ACT Exentos%-------------------------------- 

Declare @Campo20 as table (IdProveedor int,Importe Decimal(18,0)) 
--OC 
insert into @Campo20  
select T_Pedidos.IdProveedor ,  
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) --* isnull(T_Pedidos.TipodeCambio,0))  
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3) 
AND T_Pedidos.TipodeCambio = 0  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
group by T_Pedidos.idproveedor  

UNION  ALL

--OC-A
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido     
INNER JOIN T_Cheques  
ON T_Cheques.IdSolicitudCheque =T_Pedidos.IdSolicitudChequesAnticipo   
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3) 
AND T_Pedidos.TipodeCambio=0  
--AND (MONTH(T_Pedidos.Fecha)=@mes and YEAR(T_Pedidos.Fecha)=@Ejercicio)  
AND (MONTH(T_Cheques.Fecha)=@mes and YEAR(T_Cheques.Fecha)=@Ejercicio)  
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL 

--OC-C
select T_Pedidos.IdProveedor, 
SUM((D_Pedidos.Importe)*((T_Cheques.Importecheque)/T_Pedidos.TotalGral)) as 'SubTotal'
from d_pedidos join   
T_Pedidos   
ON T_Pedidos.IdPedido = d_pedidos.IdPedido   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdPedido=T_Pedidos.IdPedido  
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
WHERE (D_Pedidos.PorcIva = 0 and D_Pedidos.TipoIVA = 3) 
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio) 
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')
GROUP BY T_Pedidos.IdProveedor,t_Cheques.ImporteCheque

UNION ALL

--OS
select T_OrdenServicio.IdProveedor ,  
SUM((D_OrdenServicio.Importe)*((T_Cheques.Importecheque)/T_OrdenServicio.TotalGral))
from D_OrdenServicio join   
T_OrdenServicio   
ON T_OrdenServicio.IdOrden = D_OrdenServicio.IdOrden   
JOIN T_RecepcionFacturas   
ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
JOIN T_SolicitudCheques   
ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques 
INNER JOIN T_Polizas TPol
ON T_RecepcionFacturas.IdPoliza = TPol.IdPoliza
 where (D_OrdenServicio.PorcIva = 0 and D_OrdenServicio.TipoIVA = 3)
 AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)  
AND (MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
 AND T_OrdenServicio.TipodeCambio = 0  
 group by T_OrdenServicio.idproveedor  
 ------  

  UNION ALL

--OS-A

SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden 
INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque =T_Ord.IdSolicitudChequesAnticipo   
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador = 0 AND T_Cheques.Status in ('D','I')
AND T_Cheques.IdCheques  not in (Select distinct IdChequesAgrupador from T_Cheques where MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)    
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 3)
Group by T_Ord.IdProveedor

UNION ALL
--OS-C
SELECT T_Ord.IdProveedor, 
SUM((D_Ord.Importe)*((T_Cheques.Importecheque)/T_Ord.TotalGral)) as 'SubTotal'
FROM T_OrdenServicio T_Ord INNER JOIN D_OrdenServicio D_Ord
ON T_Ord.IdOrden = D_Ord.IdOrden INNER JOIN T_RecepcionFacturas T_RecFac
ON T_Ord.IdOrden = T_RecFac.IdOrden INNER JOIN T_SolicitudCheques T_SolCheq
ON T_SolCheq.IdRecepcionServicios = T_RecFac.IdRecepcionServicios INNER JOIN T_Cheques   
ON T_Cheques.IdSolicitudCheque = T_SolCheq.IdSolicitudCheques 
WHERE -- T_Ord.IVA > 0  AND T_Ord.TipodeCambio = 0 AND
(MONTH(T_Cheques.Fecha) = @mes and YEAR(T_Cheques.Fecha) = @Ejercicio)
AND T_Cheques.IdChequesAgrupador <> 0 
AND T_Cheques.Status in ('L')  
AND (D_Ord.PorcIva = 0 and D_Ord.TipoIVA = 3)
Group by T_Ord.IdProveedor

UNION ALL

SELECT D_Viaticos.IdProveedor, D_Viaticos.Importe 
FROM T_Viaticos INNER JOIN D_Viaticos ON T_Viaticos.IdViaticos = D_Viaticos.IdViatico
Where (MONTH(T_Viaticos.Fecha) = @mes AND YEAR(T_Viaticos.Fecha) = @Ejercicio) 
AND (D_Viaticos.IVA_PORC = 0 and D_Viaticos.IdTipoIVA = 3) AND T_Viaticos.Estatus = 'A'
Declare @_Campo20 as table (IdProveedor int,Importe Decimal(18,0))  
insert into @_Campo20   
select c20.IdProveedor, SUM (c20.Importe) from @campo20 as c20 group by c20.IdProveedor   
--------------------------------------  
---------------------------------------------------------IVA RETENIDO-------------------------------- 

--Declare @Campo21 as table (IdProveedor int,Importe Decimal(18,0))  
--insert into @Campo21  
--select T_OrdenServicio.IdProveedor ,  
--sum (R_RetencionesOrden.Importe)  
--from R_RetencionesOrden join   
--T_OrdenServicio   
--ON T_OrdenServicio.IdOrden = R_RetencionesOrden.IdOrden   
--JOIN T_RecepcionFacturas   
--ON T_RecepcionFacturas.IdOrden =T_OrdenServicio.IdOrden   
--JOIN T_SolicitudCheques   
--ON T_SolicitudCheques.IdRecepcionServicios = T_RecepcionFacturas.IdRecepcionServicios   
--JOIN T_Cheques   
--ON T_Cheques.IdSolicitudCheque =T_SolicitudCheques.IdSolicitudCheques   
--JOIN C_Deducciones  
--ON C_Deducciones.DEDUCCION = R_RetencionesOrden.IdRetencion  
-- where (MONTH(T_OrdenServicio.Fecha)=@mes AND YEAR(T_OrdenServicio.Fecha)=@Ejercicio)  
-- AND T_OrdenServicio.TipodeCambio=0  
-- AND C_Deducciones.IvaRet = 1  
-- group by T_OrdenServicio.idproveedor  
--------------------------------------  
---------------------------------------------------------IVA DEV Y DESC-------------------------------- 

--Declare @Campo22 as table (IdProveedor INT,Importe DECIMAL(18,2))  
--INSERT INTO @Campo22  
--SELECT T_NotaCredito.IdProveedor ,  
--SUM (T_NotaCredito.IVA)  
--FROM T_NotaCredito 
--WHERE MONTH(Fecha) = @mes AND YEAR(Fecha) = @Ejercicio
--GROUP BY T_NotaCredito.idproveedor  
-----------------------------------  


select   
case  NacionalExtanjero  
 when 'N' then '04'  
 when 'E' then '05'  
 when 'G' then '15'  
 else '04'  
end as 'TIPO TERCERO',  
85 as 'TIPO OPERACIÓN',  
RFC as 'RFC',  
ISNULL(Opt_05,'') as 'ID FISCAL',  
ISNULL(Tecnico,'') as 'NOMBRE EXTRANJERO',   
ISNULL(C_PaisesDIOT.Clave,'') as 'PAIS RESID',  
ISNULL(C_PaisesDIOT.Nacionalidad,'') as 'NACIONALIDAD',  
ISNULL(convert(varchar(max),SUM(C8.Importe)),0) as 'VALOR ACT 16%',  
0 as 'VALOR ACT 15%',  
0 as 'IVA NO ACRED 16%',  
0 as 'VALOR ACT 11%',  
0 as 'VALOR ACT 10%',
ISNULL(CONVERT(varchar(max),SUM(C13_1.Importe)),0) as 'VALOR ACT 8%',  
0 as 'IVA NO ACRED 11%',  
0 as 'IVA NO ACRED 8%',
--isnull(convert(varchar(max),sum(C14.Importe)),0)  as 'VALOR IMP 16%',
0  as 'VALOR IMP 16%',   
0 as 'IVA NO ACRED IMP 16%',  
0 as 'VALOR IMP 11%',  
0 as 'IVA NO ARED IMP 11%',  
0 as 'VALOR IMP EXENTOS',
--isnull(convert(varchar(max),sum(C18.Importe)),0)  as Campo18, 
ISNULL(CONVERT(varchar(max),SUM(C19.Importe)),0)  as 'VALOR ACT 0%',  
ISNULL(CONVERT(varchar(max),SUM(C20.Importe)),0)  as 'VALOR ACT EXENTOS',  
--isnull(convert(varchar(max),sum(C21.Importe)),0)  as 'IVA RETENIDO', 
0  as 'IVA RETENIDO',  
--ISNULL(CONVERT(varchar(max),sum(C22.Importe)),0)  as 'IVA DEV Y DESC' 
0  as 'IVA DEV Y DESC'  
FROM C_Proveedores  
LEFT OUTER JOIN C_PaisesDIOT  
ON C_PaisesDIOT.Clave=c_proveedores.Cargo   
full JOIN @_Campo8 as C8  
ON C8.IdProveedor=C_Proveedores.IdProveedor  
full JOIN @_Campo13_1 as C13_1
ON C_Proveedores.IdProveedor = C13_1.IdProveedor   
full JOIN @_Campo19 as C19  
on C19.IdProveedor=C_Proveedores.IdProveedor   
full JOIN @_Campo20 as C20  
on C20.IdProveedor=C_Proveedores.IdProveedor   
--full JOIN @Campo22 as C22  
--ON C22.IdProveedor=C_Proveedores.IdProveedor   
WHERE TipoProveedor in ('P', 'C') and  RFC <>'' and C8.Importe > 0 or C13_1.Importe > 0 or C19.Importe > 0 or C20.Importe > 0   
--WHERE TipoProveedor in ('P', 'C') and  RFC <>'' and C8.Importe > 0 or C13_1.Importe > 0 or C18.Importe > 0 or C19.Importe > 0 or C20.Importe > 0 or C21.Importe > 0 or C22.Importe > 0  

group by NacionalExtanjero,C_proveedores.RFC,  
Opt_05,c_proveedores.Tecnico,C_PaisesDIOT.Clave,  
C_PaisesDIOT.Nacionalidad   
order by rfc  
  
GO


