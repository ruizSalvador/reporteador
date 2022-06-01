/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_TablaDinamica]    Script Date: 10/16/2013 17:01:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_K2_TablaDinamica]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_K2_TablaDinamica]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_K2_TablaDinamica]    Script Date: 10/16/2013 17:01:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RPT_K2_TablaDinamica] 
@Columnas INT,
@Renglones INT
AS
DECLARE @Tabla VARCHAR(MAX)
DECLARE @Insert VARCHAR(MAX)
DECLARE @InsertGrp VARCHAR(MAX)

SET @Tabla ='DECLARE @tmp Table(C1 VARCHAR(MAX)'
SET @Insert ='INSERT INTO @Tmp VALUES ('''''
SET @InsertGrp=''

--Por default en 1 columnas y renglones
IF @Columnas<=0 BEGIN
	SET @Columnas=1
END
IF @Renglones<=0 BEGIN
	SET @Renglones=1
END

--Crea la tabla segun las columnas indicadas
DECLARE @ContCol INT
SET @ContCol =2

WHILE @ContCol <= @Columnas BEGIN
	SET @Tabla = @Tabla +' ,C'+CONVERT(VARCHAR(MAX),@ContCol)+' VARCHAR(MAX)'
	SET @ContCol=@ContCol+1
END
Set @Tabla=@Tabla +')'


--Crea el insert segun las columnas indicadas
DECLARE @ContIns1 INT
SET @ContIns1  =2
WHILE @ContIns1 <= @Columnas BEGIN
	SET @Insert= @Insert+ ' ,'''''
	SET @ContIns1=@ContIns1+1
END
SET @Insert =@Insert+') '


--Replica el Insert el Numero de renglones indicados
DECLARE @ContIns2 INT
SET @ContIns2  =1
WHILE @ContIns2<= @Renglones BEGIN
	SET @InsertGrp = @InsertGrp+ @Insert 
	SET @ContIns2=@ContIns2+1
END

--Ejecuta la consulta
EXEC (@Tabla+' '+ @InsertGrp + 'SELECT * FROM @Tmp')

GO

EXEC SP_FirmasReporte 'Auxiliar Sujeto a Inventario de Bienes Arqueológicos, Artísticos e Históricos'

GO
