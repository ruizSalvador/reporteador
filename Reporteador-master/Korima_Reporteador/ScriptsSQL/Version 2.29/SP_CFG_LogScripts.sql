/****** Object:  StoredProcedure [dbo].[SP_CFG_LogScripts]    Script Date: 17/10/2016 09:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CFG_LogScripts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_CFG_LogScripts]
GO
/****** Object:  StoredProcedure [dbo].[SP_CFG_LogScripts]    Script Date: 17/10/2016 09:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CFG_LogScripts]
@SP_Name varchar(255),
@version varchar(10)

AS
BEGIN
	 INSERT INTO 
	 CFG_LogScripts 
	 VALUES (@SP_Name,GETDATE(),@version)
END
GO	

Exec SP_CFG_LogScripts 'SP_CFG_LogScripts','2.29'
GO	

