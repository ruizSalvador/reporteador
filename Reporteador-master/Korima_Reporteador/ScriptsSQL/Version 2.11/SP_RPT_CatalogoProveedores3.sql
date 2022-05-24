/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores3]    Script Date: 09/01/2015 19:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_CatalogoProveedores3]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_CatalogoProveedores3]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_CatalogoProveedores3]    Script Date: 09/01/2015 19:25:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_RPT_CatalogoProveedores3]
@FechaInicio as Datetime,
@FechaFin as Datetime,
@Proveedor1 as int=0,
@Proveedor2 as int=0
--@Proveedor1 as varchar (max),
--@Proveedor2 as varchar (max)


AS 
BEGIN

Declare @Resultado as TABLE(
Idproveedor varchar(8),
Beneficiario varchar (255),
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
[12] decimal (15,2),
[13] decimal (15,2)
)

DECLARE @tabla as table (
	idproveedor int,
	Beneficiario varchar(100),
	anio int,
	jan decimal(11,2),
	feb decimal(11,2),
	mar decimal(11,2),
	apr decimal(11,2),
	may decimal(11,2),
	jun decimal(11,2),
	jul decimal(11,2),
	aug decimal(11,2),
	sep decimal(11,2),
	oct decimal(11,2),
	nov decimal(11,2),
	dec decimal(11,2),
	Totales decimal(11,2)
)

if @Proveedor1 <>0 and @Proveedor2 <>0 begin
	INSERT INTO @Resultado 
	Select IdProveedor ,Beneficiario,
	 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13]
	From (

			SELECT
			   T_cheques.IdProveedor as IdProveedor,Beneficiario , year(Fecha ) as anio, month(Fecha)as mes,
				Importecheque as Amount
			FROM T_cheques
			inner join C_Proveedores
			on C_Proveedores.idproveedor = T_Cheques.IdProveedor 
			where fecha between @FechaInicio and @FechaFin
			and  T_cheques.idproveedor between @Proveedor1 and @Proveedor2
			and (T_cheques.status = 'D' or T_cheques.status = 'I')
			and tipoProveedor ='P'
		 ) as PivotTable
		PIVOT 
		( 
			sum(Amount) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
		)
	 AS PivotTable
	Order by IdProveedor
end

if @Proveedor1 = 0 and @Proveedor2 = 0 begin
	INSERT INTO @Resultado 
	Select IdProveedor ,Beneficiario,
	 [0] ,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13]
	From (

			SELECT
			   T_cheques.IdProveedor as IdProveedor,Beneficiario , year(Fecha ) as anio, month(Fecha)as mes,
				Importecheque as Amount
			FROM T_cheques
			inner join C_Proveedores
			on C_Proveedores.idproveedor = T_Cheques.IdProveedor 
			where fecha between @FechaInicio and @FechaFin
			and (T_cheques.status = 'D' or T_cheques.status = 'I')
			and tipoProveedor ='P'
		 ) as PivotTable
		PIVOT 
		( 
			sum(Amount) For Mes In ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
		)
	 AS PivotTable
	Order by IdProveedor
end

	-------------------------

	insert into @tabla
	SELECT Idproveedor,Beneficiario,isnull([0],0) as [0],isnull([1],0) as [1],isnull([2],0) as [2],isnull([3],0) as [3],isnull([4],0) as [4],
	isnull([5],0) as [5],isnull([6],0) as [6],isnull([7],0) as [7],isnull([8],0) as [8],isnull([9],0) as [9],isnull([10],0) as [10],
	isnull([11],0) as [11],isnull([12],0) as [12],isnull([1],0) + isnull([2],0) + isnull([3],0) + isnull([4],0) + isnull([5],0) + isnull([6],0) + isnull([7],0) + isnull([8],0) + isnull([9],0) + isnull([10],0) + isnull([11],0) + isnull([12],0)
	from @Resultado

	select * from @tabla


END 




GO



--EXEC [SP_RPT_CatalogoProveedores3] '20150101','20150901',0,0