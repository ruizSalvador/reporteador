-- Inserta campo para ruta para imagen en etiqueta.

IF NOT EXISTS (SELECT * FROM T_ParametrosContables where nombreparametro='RUTA IMAGEN ETIQUETA CODIGO BARRAS')
BEGIN

DECLARE @LastId INT;
SET @LastId = (SELECT TOP 1 IDNUMEROPARAMETRO FROM T_ParametrosContables ORDER BY IDNUMEROPARAMETRO DESC);
SET @LastId = @LastId + 1

INSERT [dbo].[T_ParametrosContables] ([IDNUMEROPARAMETRO], [CLASIFICACION], [IdClaseParametro], [NOMBREPARAMETRO], [TIPO], [IDCATALOGO], [Valor], [Descripcion])
VALUES (@LastId, N'', 11, N'RUTA IMAGEN ETIQUETA CODIGO BARRAS', 5, 0, N'', N'RUTA IMAGEN ETIQUETA CODIGO BARRAS')

END
GO

EXEC SP_CFG_LogScripts 'Script_Inserta_Registro_Imagen_Etiqueta_FacturaKor', '2.29'
GO