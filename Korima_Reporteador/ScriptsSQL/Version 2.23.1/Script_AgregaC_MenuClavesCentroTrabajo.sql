If not exists (Select * from C_Menu where NombreMenu = 'FONE CCT')
begin 

 Declare @LastId int;
 Set @LastId = (Select top 1 IdMenu from C_Menu Order By IdMenu Desc);
 Set @LastId = @LastId + 1

 Insert into C_Menu values(@LastId,'FONE CCT','FONE CCT',966,3,0,1,'BrowseC_ClavesCentroTrabajo',4,'KsRh.dll','',10,1,0,'',@LastId,0,0,0,1,0)
end

If not exists (Select * from C_MenuUsuarios where Nombre = 'FONE CCT')
begin 

 Declare @LastId2 int;
 Set @LastId2 = (Select top 1 IdMenu from C_MenuUsuarios Order By IdMenu Desc);
 Set @LastId2 = @LastId2 + 1

 Insert into C_MenuUsuarios values(@LastId2,'FONE CCT','FONE CCT',966,3,0,1,'BrowseC_ClavesCentroTrabajo',1,1,4,'KsRh.dll','',10,0,'','','','','','','','')
end

