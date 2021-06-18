/****** Object:  StoredProcedure [dbo].[SP_Conciliacion_AhorroDeshorro]    Script Date: 07/22/2013 15:45:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Conciliacion_AhorroDeshorro]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Conciliacion_AhorroDeshorro]
GO

/****** Object:  StoredProcedure [dbo].[SP_Conciliacion_AhorroDeshorro]    Script Date: 07/22/2013 15:45:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Conciliacion_AhorroDeshorro]

AS
DECLARE @Tabla AS Table(
Nota1 varchar(max) null,
Descripcion Varchar (max) null,
Nota2 varchar(max)null,
Nota3 Varchar(max) null,
Numero Varchar(max)
) 
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Ahorro/Desahorro antes de rubros extraordinarios', N'',N'',N'1.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Movimientos de partidas (o rubros) que no afectan al efectivo', N'',N'',N'2.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Depreciación', N'',N'',N'3.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Amortización', N'',N'',N'4.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Incrementos en las provisiones', N'',N'',N'5.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Incremento en inversiones producido por revaluación', N'',N'',N'6.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Ganancia/pérdida en venta de propiedad, planta y equipo', N'',N'',N'7.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Incremento en cuentas por cobrar', N'',N'',N'8.')
INSERT INTO @Tabla (Nota1, Descripcion, Nota2,Nota3,Numero) VALUES (N'', N'Partidas extraordinarias', N'',N'',N'9.')



UPDATE @Tabla set Nota1 = (Select Numero + ' Click Aqui...')
UPDATE @Tabla set Nota2 =(Select Numero + ' Click Aqui...') 
UPDATE @Tabla set Nota3 =(Select Numero + ' Click Aqui...') 

Select * from @Tabla

GO

EXEC SP_FirmasReporte 'Conciliación Ahorro Desahorro'
GO


