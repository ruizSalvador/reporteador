-- CAMBIOS A LAS TABLAS DE KÓRIMA 2 DERIVADOS DE LAS REFORMAS CONAC 27-09-2018 A LA GUÍA CONTABILIZADORA II.1.8

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

-- Cambio de nombre de guía
UPDATE C_GuiaContable SET Nombre='Participaciones, Aportaciones, Convenios, Incentivos derivados de la colaboración fiscal, Fondos distintos de aportaciones, Transferencias, Asignaciones, Subsidios y Subvenciones, y Pensiones y Jubilaciones' WHERE Clave='II.1.8'
-- eliminación de eventos y sus cuentas
DELETE FROM C_ConceptosGuia WHERE IdConcepto IN (127, 128); -- Antes Ev: 17, 18
DELETE FROM D_CuentasGuia WHERE IdConcepto IN (127, 128); -- Antes Ev: 17, 18

-- Cambios en nombres de eventos
UPDATE C_ConceptosGuia SET Concepto='Por el cobro del primer pago de participaciones en las Entidades Federativas y en los Municipios, previo a la recepción de la constancia de participaciones o documento equivalente' WHERE IdGuia=9 AND Numero='01';
UPDATE C_ConceptosGuia SET Concepto='Por los ingresos participables recaudados por las Entidades Federativas' WHERE IdGuia=9 AND Numero='02';
UPDATE C_ConceptosGuia SET Concepto='Por la aplicación de ingresos participables recaudados por las Entidades Federativas, una vez recibidas las constancias de participaciones o documento equivalente', IdDocumentoFuente=19 WHERE IdGuia=9 AND Numero='03';
UPDATE C_ConceptosGuia SET Concepto='Por el devengado de ingresos por la diferencia positiva resultante del ajuste a las participaciones, derivado de las constancias de participaciones o documento equivalente. 1', IdDocumentoFuente=111, Periodicidad='Eventual' WHERE IdGuia=9 AND Numero='04';
UPDATE C_ConceptosGuia SET Concepto='Por el cobro de la diferencia positiva resultante del ajuste a las participaciones, derivado de las constancias de participaciones o documento equivalente. 1' WHERE IdGuia=9 AND Numero='05';
UPDATE C_ConceptosGuia SET Concepto='Por la devolución de la diferencia negativa resultante del ajuste a las participaciones, derivado de la aplicación de la constancia de participaciones o documento equivalente', IdDocumentoFuente=111 WHERE IdGuia=9 AND Numero='06';
UPDATE C_ConceptosGuia SET Numero='08', Concepto='Por el devengado de ingresos de aportaciones. 1' WHERE IdConcepto=117; -- Antes era Ev7
UPDATE C_ConceptosGuia SET Numero='09', Concepto='Por el cobro de ingresos de aportaciones. 1' WHERE IdConcepto=118; -- Antes era Ev8
UPDATE C_ConceptosGuia SET Numero='10', Concepto='Por la autorización de la devolución de ingresos de aportaciones. 1', IdDocumentoFuente=113 WHERE IdConcepto=119; -- Antes era Ev9a
UPDATE C_ConceptosGuia SET Numero='13', Concepto='Por el devengado de ingresos de convenios. 1' WHERE IdConcepto=120; -- Antes era Ev10
UPDATE C_ConceptosGuia SET Numero='14', Concepto='Por el cobro de ingresos de convenios. 1' WHERE IdConcepto=121; -- Antes era Ev11
UPDATE C_ConceptosGuia SET Numero='15', Concepto='Por la autorización de la devolución de ingresos de convenios. 1', IdDocumentoFuente=113 WHERE IdConcepto=122; -- Antes era Ev12
UPDATE C_ConceptosGuia SET Numero='21', Concepto='Por el devengado y el cobro de ingresos de transferencias y asignaciones', IdDocumentoFuente=114 WHERE IdConcepto=123; -- Antes era Ev13
UPDATE C_ConceptosGuia SET Numero='22', Concepto='Por la autorización de la devolución de ingresos de transferencias y asignaciones. 1', IdDocumentoFuente=113 WHERE IdConcepto=124; -- Antes era Ev14
UPDATE C_ConceptosGuia SET Numero='25', Concepto='Por el devengado y el cobro de ingresos de subsidios y subvenciones', IdDocumentoFuente=114 WHERE IdConcepto=125; -- Antes era Ev15
UPDATE C_ConceptosGuia SET Numero='26', Concepto='Por la autorización de la devolución de ingresos de subsidios y subvenciones. 1', IdDocumentoFuente=113 WHERE IdConcepto=126; -- Antes era Ev16a
UPDATE C_ConceptosGuia SET Numero='29', Concepto='Por el devengado y el cobro de ingresos para pensiones y jubilaciones', IdDocumentoFuente=114 WHERE IdConcepto=129; -- Antes era Ev19
UPDATE C_ConceptosGuia SET Numero='30', Concepto='Por la autorización y el pago del reintegro a la Tesorería de ingresos de pensiones y jubilaciones, en términos de las disposiciones aplicables', IdDocumentoFuente=108 WHERE IdConcepto=130; -- Antes era Ev20

-- Nuevos eventos
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='07' AND Concepto LIKE 'Por la devolución de la diferencia negativa%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='11' AND Concepto LIKE 'Por el pago de la devolución de i%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='12' AND Concepto LIKE 'Por la autorización y el pago del rein%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='16' AND Concepto LIKE 'Por el pago de la devolución de ingr%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='17' AND Concepto LIKE 'Por la autorización y el pago del reintegro a la Tesorería%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='18' AND Concepto LIKE 'Por el devengado de ingresos de fondos distintos de aportaciones%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='19' AND Concepto LIKE 'Por el cobro de ingresos de fondos distintos de aportacioness%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='20' AND Concepto LIKE 'Por la autorización y el pago del reintegro a la Tesorería%';
DELETE FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero IN ('23','24','27','28','31','32');
DECLARE @ConsecEv INT = (SELECT MAX (IdConcepto) FROM C_ConceptosGuia) 
INSERT INTO [dbo].[C_ConceptosGuia]
           ([IdConcepto],[IdGuia],[Numero],[Concepto],[Periodicidad],[IdDocumentoFuente],[CONAC],[IdTipoMovimiento],[Automatizado],[TipoMovimientoOperativoContable],[Orden],[CondicionRango1],[CondicionRango2],[Condicionante])
     VALUES
 (@ConsecEv+1,9,'07','Por la devolución de la diferencia negativa resultante del ajuste a la recaudación de ingresos participables, derivado de la aplicación de la constancia de participaciones o documento equivalente','Eventual',112,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev7
,(@ConsecEv+2,9,'11','Por el pago de la devolución de ingresos de aportaciones. 1','Eventual',4,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev11
,(@ConsecEv+3,9,'12','Por la autorización y el pago del reintegro a la Tesorería de ingresos de aportaciones, en términos de las disposiciones aplicables','Eventual',108,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev12
,(@ConsecEv+4,9,'16','Por el pago de la devolución de ingresos de convenios. 1','Eventual',4,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev16
,(@ConsecEv+5,9,'17','Por la autorización y el pago del reintegro a la Tesorería de ingresos de convenios, en términos de las disposiciones aplicables','Eventual',108,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev17
,(@ConsecEv+6,9,'18','Por el devengado de ingresos de fondos distintos de aportaciones, como Fondo para Entidades Federativas y Mpos Productores de Hidrocarburos, y Fondo para el Desarrollo Regional Sustentable de Estados y Mpos Mineros (Fondo Minero), entre otros. 1','Frecuente',36,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev18
,(@ConsecEv+7,9,'19','Por el cobro de ingresos de fondos distintos de aportaciones. 1','Frecuente',49,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev19
,(@ConsecEv+8,9,'20','Por la autorización y el pago del reintegro a la Tesorería de ingresos de fondos distintos de aportaciones, en términos de las disposiciones aplicables','Eventual',108,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev20
,(@ConsecEv+9,9,'23','Por el pago de la devolución de ingresos de transferencias y asignaciones. 1','Eventual',4,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev23
,(@ConsecEv+10,9,'24','Por la autorización y el pago del reintegro a la Tesorería de ingresos de transferencias y asignaciones, en términos de las disposiciones aplicables','Eventual',108,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev24
,(@ConsecEv+11,9,'27','Por el pago de la devolución de ingresos de subsidios y subvenciones. 1','Eventual',4,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev27
,(@ConsecEv+12,9,'28','Por la autorización y el pago del reintegro a la Tesorería de ingresos de subsidios y subvenciones, en términos de las disposiciones aplicables','Eventual',108,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev28
,(@ConsecEv+13,9,'31','Por el devengado de ingresos de transferencias del Fondo Mexicano del Petróleo para la Estabilización y el Desarrollo. 1','Frecuente',36,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev31
,(@ConsecEv+14,9,'32','Por el cobro de ingresos de transferencias del Fondo Mexicano del Petróleo para la Estabilización y el Desarrollo. 1','Frecuente',49,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- II.1.8 Ev32

DELETE FROM C_DocumentosFuente WHERE IdDocumentoFuente IN (111,112,113,114);
INSERT INTO [dbo].[C_DocumentosFuente]
           ([IdDocumentoFuente], [Nombre])
     VALUES
 (111,'Constancia de participaciones, oficio de autorización de la devolución o documento equivalente')
,(112,'Oficio de autorización de la devolución, constancia de compensación de participaciones, liquidación o documento equivalente')
,(113,'Autorización de la devolución o documento equivalente')
,(114,'Recibo de cobro, estado de cuenta, transferencia bancaria o documento equivalente')
;

-- Cambio de cuentas dentro de eventos ya existentes 
DECLARE @911 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='11');
DECLARE @916 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='16');
DECLARE @923 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='23');
DECLARE @927 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='24');

UPDATE D_CuentasGuia SET IdCuenta=966, Cuenta='2192'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=669; -- Ev3
UPDATE D_CuentasGuia SET IdCuenta=686, Cuenta='4214'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=670; -- Ev3
DELETE FROM D_CuentasGuia WHERE IdCuentasGuia IN (679,680,681,682); -- Ev4
UPDATE D_CuentasGuia SET IdCuenta=17, Cuenta='1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=683; -- Ev5
UPDATE D_CuentasGuia SET IdCuenta=44, Cuenta='1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura WHERE IdCuentasGuia=684; -- Ev5
UPDATE D_CuentasGuia SET IdCuenta=1216, Cuenta='815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura WHERE IdCuentasGuia=686; -- Ev5
UPDATE D_CuentasGuia SET IdCuenta=1058, Cuenta='4211'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, TipoCuenta='Opcional' WHERE IdCuentasGuia=687; -- Ev6
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (688,689,690); -- Ev6
UPDATE D_CuentasGuia SET TipoCuenta='Opcional' WHERE IdCuentasGuia=688; -- Ev6
UPDATE D_CuentasGuia SET IdConcepto=@911, Numero=1 WHERE IdCuentasGuia IN (703,704,705,706); -- Ev11
UPDATE D_CuentasGuia SET Numero=2, TipoCuenta='Opcional' WHERE IdCuentasGuia=704; -- Ev11
UPDATE D_CuentasGuia SET IdConcepto=@916, Numero=1 WHERE IdCuentasGuia IN (719,720,721,722); -- Ev16
UPDATE D_CuentasGuia SET TipoCuenta='Requerido' WHERE IdCuentasGuia=724; -- Ev21
UPDATE D_CuentasGuia SET Numero=2 WHERE IdCuentasGuia IN (730,731); -- Ev21
UPDATE D_CuentasGuia SET IdConcepto=@923, Numero=1 WHERE IdCuentasGuia IN (737,738,739,740); -- Ev23
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (745,746); -- Ev25
UPDATE D_CuentasGuia SET IdConcepto=@927, Numero=1 WHERE IdCuentasGuia IN (753,754,755,756); -- Ev27
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia IN (777,778); -- Ev29
UPDATE D_CuentasGuia SET TipoCuenta='Opcional' WHERE IdCuentasGuia=781; -- Ev30
UPDATE D_CuentasGuia SET Numero=3 WHERE IdCuentasGuia=785; -- Ev30
UPDATE D_CuentasGuia SET Numero=4 WHERE IdCuentasGuia=786; -- Ev30




-- Cuentas nuevas
DECLARE @907 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='07' AND Concepto LIKE 'Por la devolución de la diferencia negativa%');
DECLARE @912 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='12' AND Concepto LIKE 'Por la autorización y el pago del rein%');
DECLARE @917 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='17' AND Concepto LIKE 'Por la autorización y el pago del reintegro a la Tesorería%');
DECLARE @918 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='18' AND Concepto LIKE 'Por el devengado de ingresos de fondos distintos de aportaciones%');
DECLARE @919 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='19' AND Concepto LIKE 'Por el cobro de ingresos de fondos distintos de aportacioness%');
DECLARE @920 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='20' AND Concepto LIKE 'Por la autorización y el pago del reintegro a la Tesorería%');
DECLARE @924 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='24'); 
DECLARE @928 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='28'); 
DECLARE @931 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='31'); 
DECLARE @932 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=9 AND Numero='32'); 


DELETE FROM D_CuentasGuia WHERE Observaciones='CONAC180927';
DECLARE @ConsecCtasG INT = (SELECT MAX (IdCuentasGuia) FROM D_CuentasGuia) 
INSERT INTO [dbo].[D_CuentasGuia]
           ([IdCuentasGuia],[IdConcepto],[IdCuenta],[Cuenta],[Numero],[TipoAfectacion],[TipoCuenta],[Observaciones])
     VALUES
 (@ConsecCtasG+1,111,1058,'4211'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- EV1
,(@ConsecCtasG+2,111,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- EV1
,(@ConsecCtasG+3,111,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- EV1
,(@ConsecCtasG+4,111,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- EV1
,(@ConsecCtasG+5,111,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- EV1
,(@ConsecCtasG+6,116,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional','CONAC180927')-- EV6
,(@ConsecCtasG+7,116,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- EV6
,(@ConsecCtasG+8,116,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- EV6
,(@ConsecCtasG+9,116,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- EV6
,(@ConsecCtasG+10,@907,966,'2192'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV7
,(@ConsecCtasG+11,@907,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional','CONAC180927')-- Nuevo EV7
,(@ConsecCtasG+12,@907,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional','CONAC180927')-- Nuevo EV7
,(@ConsecCtasG+13,@911,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional','CONAC180927')-- Nuevo EV11
,(@ConsecCtasG+14,@912,1059,'4212'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+15,@912,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+16,@912,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+17,@912,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+18,@912,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+19,@912,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+20,@912,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+21,@912,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+22,@912,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+23,@912,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC180927')-- Nuevo EV12
,(@ConsecCtasG+24,@917,1060,'4213'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+25,@917,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+26,@917,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+27,@917,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+28,@917,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+29,@917,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+30,@917,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+31,@917,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+32,@917,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+33,@917,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC180927')-- Nuevo EV17
,(@ConsecCtasG+34,@918,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV18
,(@ConsecCtasG+35,@918,687,'4215'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV18
,(@ConsecCtasG+36,@918,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV18
,(@ConsecCtasG+37,@918,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV18
,(@ConsecCtasG+38,@919,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV19
,(@ConsecCtasG+39,@919,44,'1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV19
,(@ConsecCtasG+40,@919,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV19
,(@ConsecCtasG+41,@919,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV19
,(@ConsecCtasG+42,@920,687,'4215'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+43,@920,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+44,@920,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+45,@920,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+46,@920,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+47,@920,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+48,@920,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+49,@920,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+50,@920,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+51,@920,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC180927')-- Nuevo EV20
,(@ConsecCtasG+52,@924,1061,'4221'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+53,@924,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+54,@924,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+55,@924,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+56,@924,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+57,@924,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+58,@924,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+59,@924,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+60,@924,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+61,@924,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC180927')-- Nuevo EV24
,(@ConsecCtasG+62,@928,1063,'4223'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+63,@928,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+64,@928,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+65,@928,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+66,@928,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+67,@928,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+68,@928,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+69,@928,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+70,@928,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+71,@928,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional','CONAC180927')-- Nuevo EV28
,(@ConsecCtasG+72,130,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional','CONAC180927')-- Nuevo EV30
,(@ConsecCtasG+73,130,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional','CONAC180927')-- Nuevo EV30
,(@ConsecCtasG+74,@931,44,'1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV31
,(@ConsecCtasG+75,@931,688,'4227'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV31
,(@ConsecCtasG+76,@931,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV31
,(@ConsecCtasG+77,@931,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV31
,(@ConsecCtasG+78,@932,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV32
,(@ConsecCtasG+79,@932,44,'1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV32
,(@ConsecCtasG+80,@932,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido','CONAC180927')-- Nuevo EV32
,(@ConsecCtasG+81,@932,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido','CONAC180927')-- Nuevo EV32

-- Asignación de tipos de póliza y rangos (determinados por Jorge Ornelas)
UPDATE C_ConceptosGuia SET IdTipoMovimiento=6,  CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='01';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=5,  CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='03';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=5,  CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='04';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=6,  CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='05';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='06';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='81000',CondicionRango2='81999' WHERE IdGuia=9 AND Numero='07';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='82000',CondicionRango2='82999' WHERE IdGuia=9 AND Numero='10';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='82000',CondicionRango2='82999' WHERE IdGuia=9 AND Numero='11';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='82000',CondicionRango2='82999' WHERE IdGuia=9 AND Numero='12';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='83000',CondicionRango2='83999' WHERE IdGuia=9 AND Numero='15';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='83000',CondicionRango2='83999' WHERE IdGuia=9 AND Numero='16';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='83000',CondicionRango2='83999' WHERE IdGuia=9 AND Numero='17';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=47, CondicionRango1='82300',CondicionRango2='82399' WHERE IdGuia=9 AND Numero='18';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=6,  CondicionRango1='82300',CondicionRango2='82399' WHERE IdGuia=9 AND Numero='19';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='82300',CondicionRango2='82399' WHERE IdGuia=9 AND Numero='20';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='91000',CondicionRango2='93999' WHERE IdGuia=9 AND Numero='23';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='91000',CondicionRango2='93999' WHERE IdGuia=9 AND Numero='24';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='92000',CondicionRango2='93999' WHERE IdGuia=9 AND Numero='27';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=95, CondicionRango1='92000',CondicionRango2='93999' WHERE IdGuia=9 AND Numero='28';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=47, CondicionRango1='96000',CondicionRango2='96999' WHERE IdGuia=9 AND Numero='31';
UPDATE C_ConceptosGuia SET IdTipoMovimiento=6,  CondicionRango1='96000',CondicionRango2='96999' WHERE IdGuia=9 AND Numero='32';



/*
Eventos
1 ok
2 ok
3 ok
4 ok
5 ok
6 ok
7 ok  NUEVA
8 ok  Antes ERA 7
9 ok  Antes era 8
10 ok Antes era 9a
11 ok Antes era 9b
12 ok Nueva
13 ok Antes era 10
14 ok Antes era 11
15 ok Antes era 12a
16 ok Antes era 12b
17 ok Nueva
18 ok Nueva
19 ok Nueva
20 ok Nueva
21 ok Antes era 13
22 ok Antes era 14a
23 ok Antes era 14b
24 ok Nueva
25 ok Antes era 15
26 ok Antes era 16a
27 ok Antes era 16b
28 ok Nueva
29 ok Antes era 19
30 ok Antes era 20
31 ok Nueva
32 ok Nueva
*/





