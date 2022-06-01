/****** Object:  StoredProcedure [dbo].[SP_ConsultaActivos]    Script Date: 03/14/2013 14:25:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ConsultaActivos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_ConsultaActivos]
GO
/****** Object:  StoredProcedure [dbo].[SP_ConsultaActivos]    Script Date: 03/14/2013 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec SP_ConsultaActivos
CREATE PROCEDURE [dbo].[SP_ConsultaActivos]

AS
BEGIN

Declare @Resultado as table (
NumeroCuenta varchar(100), 
NombreCuenta varchar(MAX),
CargosSinFlujo decimal (18,4), 
AbonosSinFlujo Decimal(18,4),
TotalCargos Decimal(18,4),
TotalAbonos Decimal(18,4),
SaldoDeudor  Decimal(18,4),
SaldoAcreedor  Decimal(18,4),
Afectable int,
Financiero int,
CuentaNumero bigint)

Declare @Activos as table (
NumeroEconomico varchar(100), 
Descripcion varchar(MAX),
Cantidad smallint, 
Recurso smallint,
Programa varchar(4),
FechaAdq Datetime,
Proveedor  varchar(100),
Factura  varchar(100),
Marca varchar(100),
Modelo varchar(100),
NoSerie varchar(100),
EstadodelBien varchar(100),
Ubicacion varchar(100),
Resguardante varchar (100),
CostoAdquisicion Decimal(18,4),
SaldoDepreciado Decimal(18,4),
SaldoBruto Decimal(18,4),
TotalCosto Decimal(18,4),
TotalDepreciado Decimal(18,4),
TotalBruto Decimal(18,4))

Declare @mesBal as int
Declare @yearBal as int
set @mesBal = (SELECT MONTH(GETDATE()))
set @yearBal = (SELECT YEAR(GETDATE()))

Insert into @Resultado
Exec SP_RPT_K2_BalanzaAcumulada @mesBal, @mesBal, @yearBal,1,0,0,0,0,0,'','',0,0

declare @cmd as varchar(max)
SET @cmd ='SELECT  ta.NumeroEconomico,
		Descripcion,
		''1'' AS Cantidad,
		''1'' AS Recurso,
		''N/A'' AS Programa,
		FechaUA AS FechaAdq,
		(select prov.RazonSocial from C_Proveedores prov where prov.IdProveedor = ta.IdProveedor) AS Proveedor,
		Factura,
		Marca,
		Modelo,
		NoSerie,
		EstadodelBien = CASE   EstadodelBien
						  WHEN ''B'' THEN ''Bueno''
						  WHEN ''R'' THEN ''Regular'' 
						  WHEN ''M''  THEN ''Malo''
						  WHEN ''N'' THEN ''Nuevo''  
	   
						  WHEN ''A'' THEN ''Activo'' 
						  WHEN ''D'' THEN ''Donado'' 
						  WHEN ''C'' THEN ''Baja'' 
						  WHEN ''P'' THEN ''Pendiente de baja'' 
						  WHEN ''L'' THEN ''No localizado'' 
						END   ,
		cuf.Ubicacion AS Ubicacion,
		(select  cemp.Nombres+'' ''+cemp.ApellidoPaterno+'' ''+cemp.ApellidoMaterno) AS Resguardante,		
		ISNULL(CostoAdquisicion,0) as CostoAdquisicion,
		ISNULL(D_Depreciaciones.Costo,0) as SaldoDepreciado,
		ISNULL(CostoAdquisicion,0)-ISNULL(D_Depreciaciones.Costo,0) as SaldoBruto,
		0 as TotalCosto,
		0 as TotalDepreciado,
		0 as TotalBruto		
FROM T_Activos ta
LEFT JOIN
	D_Resguardos dres ON ta.NumeroEconomico = dres.NumeroEconomico and dres.estatus = ''A''
LEFT JOIN
	C_UbicacionesFisicas cuf ON cuf.IdUbicacion = dres.IdUbicacion
 LEFT JOIN
 T_Resguardos tres ON dres.FolioResguardo = tres.FolioResguardo
LEFT JOIN
	C_Empleados cemp ON cemp.NumeroEmpleado = tres.NumeroEmpleadoDestino
LEFT JOIN D_Depreciaciones
	On D_Depreciaciones.NumeroEconomico = ta.NumeroEconomico 
LEFT JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= ta.FolioAlta 
LEFT JOIN C_Proveedores ON ta.IdProveedor = C_Proveedores.idproveedor 
	Where T_AltaActivos.Importe>0 and ta.Estatus <> ''B'''

if  exists (Select top 1 IdDepreciacion from t_Depreciaciones order by IdDepreciacion desc) 
set @cmd += ' and  IdDepreciacion in (
    Select top 1 IdDepreciacion from t_Depreciaciones order by IdDepreciacion desc)'
	Else set @cmd += ' and 1=1'
	Insert into @Activos
exec (@cmd) 

Update @Activos set TotalBruto = (Select SaldoDeudor from @Resultado where CuentaNumero like '1200%')
Update @Activos set TotalDepreciado = (Select SaldoAcreedor from @Resultado where CuentaNumero like '1260%')
Update @Activos set TotalCosto = TotalBruto + TotalDepreciado

	Select * from  @Activos order by NumeroEconomico
END

go 
exec SP_ConsultaActivos