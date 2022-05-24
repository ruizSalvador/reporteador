/****** Object:  StoredProcedure [dbo].[SP_NOTA_FEDGFR]    Script Date: 03/21/2013 13:01:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTA_FEDGFR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_NOTA_FEDGFR]
GO

/****** Object:  StoredProcedure [dbo].[SP_NOTA_FEDGFR]    Script Date: 03/21/2013 13:01:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_NOTA_FEDGFR]

AS
BEGIN
DECLARE @Tabla1 as table (
id int,
Nota1 text,
Nota2 text,
Nota3 text,
Nota4 text,
Nota5 text
)

declare @index int

set @index = 1

while @index < 10 
Begin
	insert into @Tabla1  values(@index, convert(varchar(10),@index) +' Click aqui...',convert(varchar(10),@index) +' Click aqui...',convert(varchar(10),@index) +' Click aqui...',convert(varchar(10),@index) +' Click aqui...',convert(varchar(10),@index) +' Click aqui...')
	set @index = @index + 1 
End


SELECT
*
FROM  @Tabla1
 

END





GO


