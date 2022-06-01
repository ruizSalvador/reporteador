/****** Object:  StoredProcedure [dbo].[SP_RPT_GastosDepartamento]    Script Date: 07/22/2014 11:45:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_GastosDepartamento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_GastosDepartamento]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_GastosDepartamento]    Script Date: 07/22/2014 11:45:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_GastosDepartamento]
 @FechaInicial Date,
 @FechaFinal  Date,
 @IdDepartamento int,
 @MostrarVacios bit
AS
BEGIN

DECLARE @tabla1 AS TABLE (
IdDepartamento int,
Departamento VARCHAR(MAX),
Total DECIMAL (18,2),
Tipo VARCHAR(MAX)--,
--Fecha date
)

DECLARE @tabla2 AS TABLE (
IdDepartamento int,
Departamento VARCHAR(MAX),
Factura DECIMAL (18,2),
GastoxComprobar DECIMAL (18,2),
Nomina DECIMAL (18,2)
)
DECLARE @tabla3 as table(
IdDepartamento int,
Departamento VARCHAR(MAX),
Factura DECIMAL (18,2),
GastoxComprobar DECIMAL (18,2),
Nomina DECIMAL (18,2),
Total DECIMAl (18,2)
)

--Se inserta en tabla1 los origenes de datos
INSERT INTO @tabla1 
--FACTURAS
SELECT C_Departamentos.IdDepartamento,
C_Departamentos.NombreDepartamento,
SUM(ISNULL(T_RecepcionFacturas.Total,0))AS Total,
'Facturas' AS Tipo 
from T_RecepcionFacturas 
LEFT JOIN T_OrdenServicio 
ON T_OrdenServicio.IdOrden=  T_RecepcionFacturas.IdOrden
LEFT JOIN T_Pedidos 
ON T_Pedidos.IdPedido= T_RecepcionFacturas.IdPedido
LEFT JOIN T_Consolidacion 
ON T_Consolidacion.IdConsolidacion=T_Pedidos.IdConsolidado 
LEFT JOIN D_ConsolidaSolicitudes 
ON D_ConsolidaSolicitudes.IdConsolidacion=T_Consolidacion.IdConsolidacion 
JOIN T_Solicitudes 
ON T_Solicitudes.IdSolicitud = T_pedidos.IdSolicitud  or T_Solicitudes.IdSolicitud = T_OrdenServicio.IdSolicitud or D_ConsolidaSolicitudes.IdSolicitud=T_Solicitudes.IdSolicitud 
JOIN C_Empleados 
ON C_Empleados.NumeroEmpleado=T_Solicitudes.NumeroEmpleado 
JOIN C_Departamentos 
ON C_Departamentos.IdDepartamento=C_Empleados.IdDepartamento 
Where T_RecepcionFacturas.Fecha between @FechaInicial and @FechaFinal and T_RecepcionFacturas.Estatus ='G'
GROUP BY C_Departamentos.NombreDepartamento,C_Departamentos.IdDepartamento 
UNION
--------------------------------------------------------
--GASTOS X COMPROBAR
SELECT C_Departamentos.IdDepartamento,
C_Departamentos.NombreDepartamento,
--SUM(ISNULL(T_Viaticos.Total,0))AS Total,
SUM(D_Viaticos.Importe+D_Viaticos.IVA) as Total,
'Gastos x Comprobar' AS Tipo--,
--T_Viaticos.Fecha as Fecha
FROM T_Viaticos 
JOIN C_Empleados
ON C_Empleados.NumeroEmpleado = T_Viaticos.NumeroEmpleado
JOIN C_Departamentos 
ON C_Departamentos.IdDepartamento=C_Empleados.IdDepartamento
JOIN D_Viaticos
ON T_Viaticos.IdViaticos=D_Viaticos.IdViatico  
Where T_Viaticos.Fecha between @FechaInicial and @FechaFinal and T_Viaticos.Estatus='A'
GROUP BY C_Departamentos.NombreDepartamento, C_Departamentos.IdDepartamento 
---------------------------------------------------------------
--NOMINA
UNION
SELECT 
C_Departamentos.IdDepartamento,
C_Departamentos.NombreDepartamento,
SUM (ISNULL(D_Nomina.Importe,0)) as Total,
'Nomina' as Tipo
FROM T_ImportaNomina 
JOIN D_Nomina
ON D_Nomina.IdNomina = T_ImportaNomina.IdNomina
JOIN D_NominaEmpleado
ON D_NominaEmpleado.IdRenglonNomina=D_Nomina.IdRenglonNomina 
JOIN C_Empleados
ON C_Empleados.NumeroEmpleado=D_NominaEmpleado.NumeroEmpleado 
JOIN C_Departamentos
ON C_Departamentos.IdDepartamento=C_Empleados.IdDepartamento
join C_ConceptosNomina
ON C_ConceptosNomina.IdConceptoNomina=D_Nomina.IdConceptoNomina 
where C_ConceptosNomina.Tipo<>'D'and T_ImportaNomina.IdPoliza >0
AND  T_ImportaNomina.FechaPago Between @FechaInicial and @FechaFinal
GROUP BY C_Departamentos.NombreDepartamento,C_Departamentos.IdDepartamento
---------------------------------------------------------------
--Se consultan TODOS o un departamento en especifico segun sea el filtro y se acomoda cada resultado en una columna diferente
If @IdDepartamento <>0 Begin
INSERT INTO @tabla2 
SELECT 
t.IdDepartamento,
t.Departamento,
CASE t.Tipo WHEN 'Facturas' THEN t.Total ELSE 0 END AS Factura,
CASE t.Tipo WHEN 'Gastos x Comprobar' THEN t.Total ELSE 0 END AS GastoxComprobar, 
CASE t.Tipo WHEN 'Nomina' THEN t.Total ELSE 0 END AS Nomina
FROM @tabla1 t
Where t.IdDepartamento =@IdDepartamento --and(t.Fecha BETWEEN @FechaInicial and @FechaFinal)
End
else
begin
INSERT INTO @tabla2 
SELECT 
t.IdDepartamento,
t.Departamento,
CASE t.Tipo WHEN 'Facturas' THEN t.Total ELSE 0 END AS Factura,
CASE t.Tipo WHEN 'Gastos x Comprobar' THEN t.Total ELSE 0 END AS GastoxComprobar, 
CASE t.Tipo WHEN 'Nomina' THEN t.Total ELSE 0 END  AS Nomina
FROM @tabla1 t
--Where t.Fecha BETWEEN @FechaInicial and @FechaFinal
end
-------------------------------------------------------------------
--Se agrupan y suman los resultados por departamento y se totalizan filas
INSERT INTO @tabla3
SELECT t2.IdDepartamento,
t2.Departamento,
SUM(t2.Factura)AS Factura, 
SUM(t2.GastoxComprobar) AS GastoxComprobar, 
SUM (t2.Nomina) AS Nomina,
SUM(t2.Factura)+SUM(t2.GastoxComprobar)+SUM(t2.Nomina) as Total
FROM @tabla2 t2 
WHERE Factura<>0 
OR GastoxComprobar <>0 
OR Nomina <>0 
GROUP BY Departamento, IdDepartamento 

---------------------------------------------------
--Se muestran los departamentos sin cantidades si el filtro lo indica
if @MostrarVacios =1 Begin
insert into @tabla3
select 
IdDepartamento as IdDepartamento,
NombreDepartamento as Departamento,
0 as Factura,
0 as GastoxComprobar,
0 as Nomina,
0 as Total
 from C_Departamentos  Where NombreDepartamento not in (Select t3.Departamento from @tabla3 t3)
 End
 -----------------------------------------------------------
 --Seleccion final ordenada alfabeticamente por departamento
 If @IdDepartamento <>0 Begin
 Select * from @tabla3  where IdDepartamento = @IdDepartamento order by Departamento 
 end
 else begin
 Select * from @tabla3 order by Departamento  
 end

END
GO

EXEC SP_FirmasReporte 'Gasto Devengado por Departamento'
GO


