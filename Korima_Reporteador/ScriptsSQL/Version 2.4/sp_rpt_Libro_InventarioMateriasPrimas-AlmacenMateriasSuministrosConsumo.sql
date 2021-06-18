
/****** Object:  StoredProcedure [dbo].[sp_rpt_Libro_InventarioMateriasPrimas-AlmacenMateriasSuministrosConsumo]    Script Date: 10/09/2013 18:01:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_rpt_Libro_InventarioMateriasPrimas-AlmacenMateriasSuministrosConsumo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_rpt_Libro_InventarioMateriasPrimas-AlmacenMateriasSuministrosConsumo]
GO

/****** Object:  StoredProcedure [dbo].[sp_rpt_Libro_InventarioMateriasPrimas-AlmacenMateriasSuministrosConsumo]    Script Date: 10/09/2013 18:01:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_rpt_Libro_InventarioMateriasPrimas-AlmacenMateriasSuministrosConsumo]
@ejercicio int, @periodo int, @Tipo int
AS


DECLARE @Tabla as table (
NumeroCuenta Varchar(max), 
NombreCuenta varchar(max),
Notas1 varchar(max),
Notas2 varchar(max),
Notas3 varchar(max),
Monto decimal(15,2))
-- InventarioMateriasPrimas
if @tipo=1 begin
insert into @Tabla 
Select NumeroCuenta, NombreCuenta,
'' as Notas1, 
'' as Notas2,
'' as Notas3,
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas1, 
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas2,
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas3,
      Case C_Contable.TipoCuenta 
          When 'A' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'C' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'E' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'G' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'I' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          Else isnull(AbonosSinFlujo,0) - isnull(CargosSinFlujo,0) + isnull(TotalAbonos,0) - isnull(TotalCargos,0) 
      End as Monto
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = @Periodo And [Year] = @Ejercicio) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' and NumeroCuenta
-- 5-5
In('11441-00000','11442-00000','11443-00000','11444-00000','11445-00000','11446-00000','11447-00000','11449-00000'
-- 5-6
,'11441-000000','11442-000000','11443-000000','11444-000000','11445-000000','11446-000000','11447-000000','11449-000000'
-- 6-6
,'114410-000000','114420-000000','114430-000000','114440-000000','114450-000000','114460-000000','114470-000000','114490-000000')
Order By NumeroCuenta

end

--AlmacenMateriasSuministrosConsumo
if @Tipo =2 begin
insert into @Tabla 
Select NumeroCuenta, NombreCuenta,
'' as Notas1, 
'' as Notas2,
'' as Notas3,
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas1, 
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas2,
--Substring(NumeroCuenta,1,5)+ ' Click aqui...' as Notas3,
      Case C_Contable.TipoCuenta 
          When 'A' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'C' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'E' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'G' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          When 'I' Then isnull(CargosSinFlujo,0) - isnull(AbonosSinFlujo,0) + isnull(TotalCargos,0) - isnull(TotalAbonos,0)
          Else isnull(AbonosSinFlujo,0) - isnull(CargosSinFlujo,0) + isnull(TotalAbonos,0) - isnull(TotalCargos,0) 
      End as Monto
From C_Contable LEFT JOIN 
(Select IdCuentaContable,Year,Mes,isnull(TotalCargos,0)as TotalCargos,isnull(TotalAbonos,0)as TotalAbonos,isnull(CargosSinFlujo,0)as CargosSinFlujo,isnull(AbonosSinFlujo,0)as AbonosSinFlujo 
From T_SaldosInicialesCont Where Mes = @Periodo And [Year] = @Ejercicio) Saldos
On C_Contable.IdCuentaContable = Saldos.IdCuentaContable
Where TipoCuenta <> 'X' and NumeroCuenta
-- 5-5
In('11511-00000','11512-00000','11513-00000','11514-00000','11515-00000','11516-00000','11517-00000','11518-00000'
-- 5-6
,'11511-000000','11512-000000','11513-000000','11514-000000','11515-000000','11516-000000','11517-000000','11519-000000'
-- 6-6
,'115110-000000','115120-000000','115130-000000','115140-000000','115150-000000','115160-000000','115170-000000','115190-000000')
Order By NumeroCuenta

end

select * from @Tabla 

GO

EXEC SP_FirmasReporte 'Libro de Almacén de Materias y Suministros de Consumo'
GO
EXEC SP_FirmasReporte 'Libro de Inventarios de Materias Primas, Materiales y Suministros para Producción y Comercialización'
GO
