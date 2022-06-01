
/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_Cuentas]    Script Date: 07/07/2015 11:35:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPT_K2_RelacionBienesPatrimonio_Cuentas]
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

DECLARE @totalBienes DECIMAL(15,2)

Select @totalBienes = SUM(Valor) from @tabla1 
Where Numero not in (select D_BajasActivos.NumeroEconomico from D_BajasActivos) 
 

Select SUM(saldos.TotalCargos) As Total, contable.NumeroCuenta, contable.nombreCuenta, @totalBienes as TotalBienes
 From C_Contable contable  
	INNER JOIN T_SaldosInicialesCont saldos
		ON contable.IdCuentaContable = saldos.IdCuentaContable 
    Where  TipoCuenta <> 'X' 
    and NumeroCuenta = '12350-00000' OR  NumeroCuenta = '12360-00000'
    and saldos.Year = @Ejercicio
    GROUP BY contable.NumeroCuenta, contable.nombreCuenta
