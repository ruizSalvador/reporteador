UPDATE C_PartidasGenericasPres SET DescripcionPartida='Otras inversiones en fideicomisos',Definicion= 'Asignaciones  destinadas  para  construir  o  incrementar  otros  fideicomisos no clasificados en  las  partidas anteriores, con fines de política económica.'
WHERE ClavePartida=759

IF EXISTS (Select ClavePartida from C_PartidasGenericasPres  WHERE ClavePartida=469)begin
Update C_PartidasGenericasPres set DescripcionPartida='Otras transferencias a fideicomisos', Definicion ='Asignaciones  internas,  que  no  suponen  la  contraprestación  de  bienes  o  servicios,  destinadas  a  otros fideicomisos  no  clasificados  en  las  partidas  anteriores,  con  el  objeto  de  financiar  parte  de  los  gastos inherentes a sus funciones.' where ClavePartida = 469
end
else begin
INSERT INTO C_PartidasGenericasPres VALUES(4600,4690,'Otras transferencias a fideicomisos',469,'Asignaciones  internas,  que  no  suponen  la  contraprestación  de  bienes  o  servicios,  destinadas  a  otros fideicomisos  no  clasificados  en  las  partidas  anteriores,  con  el  objeto  de  financiar  parte  de  los  gastos inherentes a sus funciones.',1)
end

