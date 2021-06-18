
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonio]    Script Date: 10/25/2013 17:14:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_RelacionBienesPatrimonio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonio]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonio]    Script Date: 10/25/2013 17:14:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonio]
@Ejercicio int 
AS
Declare @tabla1 as table (NumeroEconomico varchar(max), Numero int, Descripcion varchar(max),Valor decimal(15,2))
Declare @tabla2 as table (NumeroEconomico varchar(max), Descripcion varchar(max),Valor decimal(15,2))

insert @tabla1 
select 
cast(case
         When T_Activos.Etiqueta <> '' then T_Activos.Etiqueta               
		 else convert(varchar (max), T_Activos.NumeroEconomico) end as varchar (max)) as NumeroEconomico,
T_Activos.NumeroEconomico as Numero,
T_Activos.Descripcion,
isnull(T_Activos.CostoAdquisicion,0)
from T_Activos
JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= T_Activos.FolioAlta 
Where T_AltaActivos.Importe>0 and (year(T_Activos.FechaUA) < @Ejercicio or year(T_Activos.FechaUA) = @Ejercicio)


insert @tabla2
select 
d_depreciaciones.NumeroEconomico,
''as descripcion,
isnull(d_depreciaciones.costo,0)
from d_depreciaciones
JOIN T_Depreciaciones ON T_Depreciaciones.IdDepreciacion = D_Depreciaciones.IdDepreciacion
where T_Depreciaciones.Ano =@Ejercicio
and T_Depreciaciones.Mes=(Select MAX(T_Depreciaciones.Mes) from T_Depreciaciones where T_Depreciaciones.Ano=@Ejercicio)

update @tabla1  set Valor= T.Valor-T2.Valor 
FROM @Tabla1 T JOIN @tabla2 T2 ON T.Numero=T2.NumeroEconomico

Select NumeroEconomico,Descripcion,Valor from @tabla1 order by NumeroEconomico 


--Select --distinct
--T_Activos.NumeroEconomico,
--T_Activos.Descripcion,
--isnull(T_Activos.CostoAdquisicion,0)- isnull(d_depreciaciones.costo,0) as Valor
--from T_Activos
--LEFT outer JOIN d_depreciaciones ON T_Activos.NumeroEconomico= d_depreciaciones.NumeroEconomico 
--LEFT outer JOIN T_Depreciaciones ON T_Depreciaciones.IdDepreciacion = D_Depreciaciones.IdDepreciacion
--LEFT outer JOIN T_AltaActivos ON T_AltaActivos.FolioAlta= T_Activos.FolioAlta 
--where T_Depreciaciones.Ano =@Ejercicio 
--and T_Depreciaciones.Mes=(Select MAX(T_Depreciaciones.Mes) from T_Depreciaciones where T_Depreciaciones.Ano=@Ejercicio) 
--and T_AltaActivos.Importe>0

GO

EXEC SP_FirmasReporte 'Relación de Bienes Muebles e Inmuebles'
GO



 