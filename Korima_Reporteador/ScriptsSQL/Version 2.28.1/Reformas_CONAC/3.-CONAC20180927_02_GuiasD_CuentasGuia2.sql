-- Cambios a Cuentas contables, para eventos ya existentes, de Guías Contabilizadoras de Kórima 2 derivados de las reformas CONAC del 27-09-2018
DELETE FROM D_CuentasGuia WHERE IdCuenta IN (1028, 1036, 1040, 1041, 1042, 214, 1047, 1053, 1054, 1062, 1064, 1646, 1078); -- Eliminación de cuentas contables derogadas

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DELETE FROM D_CuentasGuia WHERE Observaciones='CONAC20180927';
DECLARE @ConsecCtasG INT = (SELECT MAX (IdCuentasGuia) FROM D_CuentasGuia) 
INSERT INTO [dbo].[D_CuentasGuia]
           ([IdCuentasGuia],[IdConcepto],[IdCuenta],[Cuenta],[Numero],[TipoAfectacion],[TipoCuenta],[Observaciones])
     VALUES
-- II.1.1
 (@ConsecCtasG+1,18,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927') -- Ev3 
,(@ConsecCtasG+2,19,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+3,22,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev7
,(@ConsecCtasG+4,24,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev9
,(@ConsecCtasG+5,25,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+6,25,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+7,25,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+8,25,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+9,25,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Cargo','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+10,25,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+11,26,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev11
,(@ConsecCtasG+12,29,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev14
,(@ConsecCtasG+13,34,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev19
-- II.1.2
,(@ConsecCtasG+14,46,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+15,46,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+16,46,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+17,46,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Abono','Requerido','CONAC20180927')-- Ev10
-- II.1.3
,(@ConsecCtasG+18,60,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev3
,(@ConsecCtasG+19,61,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+20,64,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev7
,(@ConsecCtasG+21,66,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- Ev9
,(@ConsecCtasG+22,67,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+23,67,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+24,67,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+25,67,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+26,67,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+27,67,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Abono','Requerido','CONAC20180927')-- Ev10
-- II.1.4
,(@ConsecCtasG+28,70,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev3
,(@ConsecCtasG+29,71,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+30,74,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev7
,(@ConsecCtasG+31,76,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Cargo','Opcional','CONAC20180927')-- Ev9
,(@ConsecCtasG+32,77,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Cargo','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+33,77,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+34,78,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev11
,(@ConsecCtasG+35,81,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev14
,(@ConsecCtasG+36,84,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- Ev17
-- II.1.5 
,(@ConsecCtasG+37,89,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev3
,(@ConsecCtasG+38,90,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+39,93,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- Ev7
,(@ConsecCtasG+40,95,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- Ev9
,(@ConsecCtasG+41,96,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+42,96,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC20180927')-- Ev10
,(@ConsecCtasG+43,96,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+44,96,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+45,96,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+46,96,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Abono','Requerido','CONAC20180927')-- Ev10
-- II.1.6
,(@ConsecCtasG+47,106,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+48,106,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,3,'Abono','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+49,106,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Cargo','Requerido','CONAC20180927')-- Ev10
,(@ConsecCtasG+50,106,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,4,'Abono','Requerido','CONAC20180927')-- Ev10
-- II.1.7
,(@ConsecCtasG+51,107,682,'4175'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Abono','Opcional','CONAC20180927')-- Ev1
,(@ConsecCtasG+52,107,683,'4176'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Abono','Opcional','CONAC20180927')-- Ev1
,(@ConsecCtasG+53,107,684,'4177'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,7,'Abono','Opcional','CONAC20180927')-- Ev1
,(@ConsecCtasG+54,107,685,'4178'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Abono','Opcional','CONAC20180927')-- Ev1
,(@ConsecCtasG+55,107,160,'2117'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,9,'Abono','Requerido','CONAC20180927')-- Ev1
,(@ConsecCtasG+56,110,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+57,110,682,'4175'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Cargo','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+58,110,683,'4176'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Cargo','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+59,110,684,'4177'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,7,'Cargo','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+60,110,685,'4178'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Cargo','Opcional','CONAC20180927')-- Ev4
,(@ConsecCtasG+61,110,160,'2117'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,9,'Cargo','Requerido','CONAC20180927')-- EV4
-- II.2.1
,(@ConsecCtasG+62,133,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,6,'Cargo','Requerido','CONAC20180927')-- EV3
,(@ConsecCtasG+63,133,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,6,'Abono','Requerido','CONAC20180927')-- EV3
-- VI.1.1
,(@ConsecCtasG+64,327,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC20180927')-- EV3
,(@ConsecCtasG+65,327,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC20180927')-- EV3
,(@ConsecCtasG+66,327,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC20180927')-- EV3
,(@ConsecCtasG+67,327,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC20180927')-- EV3
,(@ConsecCtasG+68,328,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC20180927')-- EV4
,(@ConsecCtasG+69,328,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC20180927')-- EV4
,(@ConsecCtasG+70,328,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC20180927')-- EV4
,(@ConsecCtasG+71,328,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC20180927')-- EV4
,(@ConsecCtasG+72,329,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+73,329,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+74,329,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+75,329,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+76,338,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC20180927')-- EV13
,(@ConsecCtasG+77,338,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC20180927')-- EV13
,(@ConsecCtasG+78,338,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC20180927')-- EV13
,(@ConsecCtasG+79,338,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC20180927')-- EV13
,(@ConsecCtasG+80,394,981,'2232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- EV18
,(@ConsecCtasG+81,394,983,'2234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC20180927')-- EV18
,(@ConsecCtasG+82,396,980,'2231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- EV20
-- VI.3.1
,(@ConsecCtasG+83,345,691,'11261'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- EV3
,(@ConsecCtasG+84,345,692,'11262'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,3,'Cargo','Opcional','CONAC20180927')-- EV3
,(@ConsecCtasG+85,345,693,'11263'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,4,'Cargo','Opcional','CONAC20180927')-- EV3
,(@ConsecCtasG+86,347,691,'11261'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC20180927')-- EV5
,(@ConsecCtasG+87,347,692,'11262'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC20180927')-- EV5
,(@ConsecCtasG+88,347,693,'11263'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC20180927')-- EV5
,(@ConsecCtasG+89,347,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,9,'Cargo','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+90,347,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,9,'Abono','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+91,347,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,10,'Cargo','Requerido','CONAC20180927')-- EV5
,(@ConsecCtasG+92,347,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,10,'Abono','Requerido','CONAC20180927')-- EV5
-- VIII.1.1
,(@ConsecCtasG+93,368,678,'4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,8,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+94,368,679,'4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,16,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+95,368,680,'4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,20,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+96,368,681,'4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,23,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+97,368,682,'4175'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,35,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+98,368,683,'4176'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,36,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+99,368,684,'4177'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,37,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+100,368,685,'4178'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,38,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+101,368,686,'4214'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,42,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+102,368,687,'4215'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,43,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+103,368,688,'4227'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,47,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+104,368,689,'4397'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,55,'Cargo','Requerido','CONAC20180927')-- EV1
,(@ConsecCtasG+105,369,690,'5598'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,70,'Abono','Requerido','CONAC20180927')-- EV1
-- VI.5.2
,(@ConsecCtasG+106,352,694,'11213'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC20180927')-- EV1
,(@ConsecCtasG+107,352,1277,'12134'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,7,'Cargo','Opcional','CONAC20180927')-- EV1
,(@ConsecCtasG+108,352,1278,'12135'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,8,'Cargo','Opcional','CONAC20180927')-- EV1
,(@ConsecCtasG+109,352,1279,'12137'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,10,'Cargo','Opcional','CONAC20180927')-- EV1
,(@ConsecCtasG+110,352,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,13,'Abono','Requerido','CONAC20180927')-- EV1
;

-- Cambio de orden de cuentas dentro de eventos
-- II.1.2 
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=203;
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=204;
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=231;
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=232;
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=246;
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=247;
UPDATE D_CuentasGuia SET Numero=9 WHERE IdCuentasGuia=1024;
-- II.1.3
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (315,316); -- Ev3
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (335,336); -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (346,347); -- Ev9
-- II.1.4
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=368; -- Ev3
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=369; -- Ev3
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=377; -- Ev4
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=378; -- Ev4
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (400,401); -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=393; -- Ev7
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=394; -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (416,417); -- Ev9
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=410; -- Ev9
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=411; -- Ev9
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (426,427); -- Ev10
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (428,429); -- Ev10
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=439; -- Ev11
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=440; -- Ev11
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=455; -- Ev14
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=456; -- Ev14
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=471; -- Ev17
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=472; -- Ev17
-- II.1.5
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (522,523); -- Ev7
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (520,521); -- Ev7
UPDATE D_CuentasGuia SET Numero=4 WHERE IdCuentasGuia=524; -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (537,538); -- Ev9
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (535,536); -- Ev9
-- II.1.6
UPDATE D_CuentasGuia SET Numero=1 WHERE IdCuentasGuia=558; -- Ev3
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=561; -- Ev3
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=562; -- Ev3
UPDATE D_CuentasGuia SET Numero=4 WHERE IdCuentasGuia=563; -- Ev3
UPDATE D_CuentasGuia SET Numero=5 WHERE IdCuentasGuia=564; -- Ev3
UPDATE D_CuentasGuia SET Numero=6 WHERE IdCuentasGuia=566; -- Ev3
UPDATE D_CuentasGuia SET Numero=7 WHERE IdCuentasGuia=567; -- Ev3
UPDATE D_CuentasGuia SET Numero=1 WHERE IdCuentasGuia=573; -- Ev4
UPDATE D_CuentasGuia SET Numero=1 WHERE IdCuentasGuia=589; -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=590; -- Ev7
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=591; -- Ev7
UPDATE D_CuentasGuia SET Numero=4 WHERE IdCuentasGuia=592; -- Ev7
UPDATE D_CuentasGuia SET Numero=5 WHERE IdCuentasGuia=593; -- Ev7
UPDATE D_CuentasGuia SET Numero=6 WHERE IdCuentasGuia=595; -- Ev7
UPDATE D_CuentasGuia SET Numero=7 WHERE IdCuentasGuia=596; -- Ev7
UPDATE D_CuentasGuia SET Numero=8 WHERE IdCuentasGuia=598; -- Ev7
UPDATE D_CuentasGuia SET Numero=8 WHERE IdCuentasGuia=599; -- Ev7
UPDATE D_CuentasGuia SET Numero=9 WHERE IdCuentasGuia=600; -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=2312; -- Ev7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=2313; -- Ev7
UPDATE D_CuentasGuia SET Numero=1 WHERE IdCuentasGuia=605; -- Ev9
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=606; -- Ev9
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=616; -- Ev9
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia=617; -- Ev9
UPDATE D_CuentasGuia SET Numero=1 WHERE IdCuentasGuia IN (622,623); -- Ev10
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (626,627); -- Ev10
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (628,629); -- Ev10
UPDATE D_CuentasGuia SET Numero=4 WHERE IdCuentasGuia IN (630,631); -- Ev10
UPDATE D_CuentasGuia SET Numero=5 WHERE IdCuentasGuia IN (632,633); -- Ev10
UPDATE D_CuentasGuia SET Numero=6 WHERE IdCuentasGuia IN (636,637); -- Ev10
UPDATE D_CuentasGuia SET Numero=7 WHERE IdCuentasGuia IN (638,639); -- Ev10
-- II.1.7
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (662,663,664); -- Ev10
DELETE FROM D_CuentasGuia WHERE IdCuentasGuia IN (655,661,666); -- Eliminación de cuenta 2116 de II.1.7 Ev4
-- VI.1.1
UPDATE D_CuentasGuia SET IdCuenta=1195, Cuenta='724'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura, TipoCuenta='Opcional' WHERE IdCuentasGuia=1998; -- Ev11
UPDATE D_CuentasGuia SET IdCuenta=1197, Cuenta='726'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura WHERE IdCuentasGuia=1999; -- Ev11
UPDATE D_CuentasGuia SET IdCuenta=1196, Cuenta='725'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura, TipoCuenta='Opcional' WHERE IdCuentasGuia=2000; -- Ev11
UPDATE D_CuentasGuia SET IdCuenta=1197, Cuenta='726'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura, TipoCuenta='Requerido' WHERE IdCuentasGuia=2001; -- Ev12
UPDATE D_CuentasGuia SET IdCuenta=1195, Cuenta='724'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura, TipoCuenta='Opcional' WHERE IdCuentasGuia=2002; -- Ev12
UPDATE D_CuentasGuia SET IdCuenta=1196, Cuenta='725'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura, TipoCuenta='Opcional', TipoAfectacion='Abono' WHERE IdCuentasGuia=2003; -- Ev12
DELETE FROM D_CuentasGuia WHERE IdCuentasGuia=2004; -- Ev12
UPDATE D_CuentasGuia SET IdCuenta=17, Cuenta='1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2005; -- Ev13
UPDATE D_CuentasGuia SET IdCuenta=982, Cuenta='2233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2006; -- Ev13
DELETE FROM D_CuentasGuia WHERE IdCuentasGuia=2008; -- Ev13
UPDATE D_CuentasGuia SET IdCuenta=982, Cuenta='2233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2009; -- Ev14
UPDATE D_CuentasGuia SET IdCuenta=937, Cuenta='2131'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2010; -- Ev14
UPDATE D_CuentasGuia SET IdCuenta=983, Cuenta='2234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2011; -- Ev15
UPDATE D_CuentasGuia SET IdCuenta=950, Cuenta='2142'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2622; -- Ev18
UPDATE D_CuentasGuia SET IdCuenta=1080, Cuenta='4393'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=1, TipoCuenta='Opcional' WHERE IdCuentasGuia=2623; -- Ev18
UPDATE D_CuentasGuia SET IdCuenta=1162, Cuenta='5594'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=2624; -- Ev19
UPDATE D_CuentasGuia SET IdCuenta=950, Cuenta='2142'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=1, TipoCuenta='Opcional' WHERE IdCuentasGuia=2625; -- Ev19
UPDATE D_CuentasGuia SET IdCuenta=981, Cuenta='2233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=2, TipoCuenta='Opcional', TipoAfectacion='Abono' WHERE IdCuentasGuia=2626; -- Ev19
UPDATE D_CuentasGuia SET IdCuenta=983, Cuenta='2234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=3, TipoCuenta='Opcional' WHERE IdCuentasGuia=2627; -- Ev19
UPDATE D_CuentasGuia SET IdCuenta=949, Cuenta='2141'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, TipoCuenta='Opcional' WHERE IdCuentasGuia=2628; -- Ev20
UPDATE D_CuentasGuia SET IdCuenta=1081, Cuenta='4394'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=1 WHERE IdCuentasGuia=2629; -- Ev20
UPDATE D_CuentasGuia SET IdCuenta=1163, Cuenta='5595'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=1, TipoCuenta='Requerido'  WHERE IdCuentasGuia=2630; -- Ev21
UPDATE D_CuentasGuia SET IdCuenta=949, Cuenta='2141'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=1, TipoCuenta='Opcional' WHERE IdCuentasGuia=2631; -- Ev21
UPDATE D_CuentasGuia SET IdCuenta=980, Cuenta='2231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, Numero=2, TipoCuenta='Opcional', TipoAfectacion='Abono' WHERE IdCuentasGuia=2632; -- Ev21
DELETE FROM D_CuentasGuia WHERE IdCuentasGuia=2633; -- Ev21
-- VI.3.1
UPDATE D_CuentasGuia SET Numero=5 WHERE IdCuentasGuia=2028; -- Ev3
UPDATE D_CuentasGuia SET Numero=6 WHERE IdCuentasGuia=2029; -- Ev3
UPDATE D_CuentasGuia SET Numero=7 WHERE IdCuentasGuia=2030; -- Ev3
UPDATE D_CuentasGuia SET Numero=8 WHERE IdCuentasGuia=2031; -- Ev3
UPDATE D_CuentasGuia SET Numero=5 WHERE IdCuentasGuia=2039; -- Ev5
UPDATE D_CuentasGuia SET Numero=6 WHERE IdCuentasGuia=2040; -- Ev5
UPDATE D_CuentasGuia SET Numero=7 WHERE IdCuentasGuia=2041; -- Ev5
UPDATE D_CuentasGuia SET Numero=8 WHERE IdCuentasGuia=2042; -- Ev5
UPDATE D_CuentasGuia SET Numero=9 WHERE IdCuentasGuia=2043; -- Ev5
-- VII.1.1
UPDATE D_CuentasGuia SET Numero=9 WHERE IdCuentasGuia=2127; -- Ev1
UPDATE D_CuentasGuia SET Numero=10 WHERE IdCuentasGuia=2128; -- Ev1
UPDATE D_CuentasGuia SET Numero=11 WHERE IdCuentasGuia=2129; -- Ev1
UPDATE D_CuentasGuia SET Numero=12 WHERE IdCuentasGuia=2130; -- Ev1
UPDATE D_CuentasGuia SET Numero=13 WHERE IdCuentasGuia=2131; -- Ev1
UPDATE D_CuentasGuia SET Numero=14 WHERE IdCuentasGuia=2132; -- Ev1
UPDATE D_CuentasGuia SET Numero=15 WHERE IdCuentasGuia=2133; -- Ev1
UPDATE D_CuentasGuia SET Numero=17 WHERE IdCuentasGuia=2134; -- Ev1
UPDATE D_CuentasGuia SET Numero=18 WHERE IdCuentasGuia=2136; -- Ev1
UPDATE D_CuentasGuia SET Numero=19 WHERE IdCuentasGuia=2137; -- Ev1
UPDATE D_CuentasGuia SET Numero=21 WHERE IdCuentasGuia=2138; -- Ev1
UPDATE D_CuentasGuia SET Numero=22 WHERE IdCuentasGuia=2139; -- Ev1
UPDATE D_CuentasGuia SET Numero=24 WHERE IdCuentasGuia=2144; -- Ev1
UPDATE D_CuentasGuia SET Numero=25 WHERE IdCuentasGuia=2145; -- Ev1
UPDATE D_CuentasGuia SET Numero=26 WHERE IdCuentasGuia=2146; -- Ev1
UPDATE D_CuentasGuia SET Numero=27 WHERE IdCuentasGuia=2147; -- Ev1
UPDATE D_CuentasGuia SET Numero=28 WHERE IdCuentasGuia=2148; -- Ev1
UPDATE D_CuentasGuia SET Numero=29 WHERE IdCuentasGuia=2150; -- Ev1
UPDATE D_CuentasGuia SET Numero=30 WHERE IdCuentasGuia=2151; -- Ev1
UPDATE D_CuentasGuia SET Numero=31 WHERE IdCuentasGuia=2152; -- Ev1
UPDATE D_CuentasGuia SET Numero=32 WHERE IdCuentasGuia=2153; -- Ev1
UPDATE D_CuentasGuia SET Numero=33 WHERE IdCuentasGuia=2154; -- Ev1
UPDATE D_CuentasGuia SET Numero=34 WHERE IdCuentasGuia=2155; -- Ev1
UPDATE D_CuentasGuia SET Numero=39 WHERE IdCuentasGuia=2158; -- Ev1
UPDATE D_CuentasGuia SET Numero=40 WHERE IdCuentasGuia=2159; -- Ev1
UPDATE D_CuentasGuia SET Numero=41 WHERE IdCuentasGuia=2160; -- Ev1
UPDATE D_CuentasGuia SET Numero=44 WHERE IdCuentasGuia=2161; -- Ev1
UPDATE D_CuentasGuia SET Numero=46 WHERE IdCuentasGuia=2165; -- Ev1
UPDATE D_CuentasGuia SET Numero=50 WHERE IdCuentasGuia=2169; -- Ev1
UPDATE D_CuentasGuia SET Numero=51 WHERE IdCuentasGuia=2170; -- Ev1
UPDATE D_CuentasGuia SET Numero=52 WHERE IdCuentasGuia=2171; -- Ev1
UPDATE D_CuentasGuia SET Numero=53 WHERE IdCuentasGuia=2172; -- Ev1
UPDATE D_CuentasGuia SET Numero=54 WHERE IdCuentasGuia=2173; -- Ev1
UPDATE D_CuentasGuia SET Numero=56 WHERE IdCuentasGuia=2174; -- Ev1
UPDATE D_CuentasGuia SET Numero=71 WHERE IdCuentasGuia=2245; -- Ev2
-- VI.5.2
UPDATE D_CuentasGuia SET Numero=9 WHERE IdCuentasGuia=2070; -- Ev1
UPDATE D_CuentasGuia SET Numero=11 WHERE IdCuentasGuia=2072; -- Ev1
UPDATE D_CuentasGuia SET Numero=12 WHERE IdCuentasGuia=2617; -- Ev1
UPDATE D_CuentasGuia SET Numero=13 WHERE IdCuentasGuia IN (2074,2076,2077); -- Ev1