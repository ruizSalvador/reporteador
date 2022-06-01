-- Creación de Guías Contabilizadoras, Eventos y Cuentas derivadas de las reformas CONAC del 27-09-2018

declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

DELETE FROM C_GuiaContable WHERE Clave IN ('II.3.1','VI.2.1','VI.5.1','VI.5.3');
INSERT INTO [dbo].[C_GuiaContable]
           ([IdGuia],[IdTipoMovimiento],[Clave],[Nombre],[Fecha],[Hora],[Observaciones],[CONAC],[IdFirma1],[IdFirma2],[IdFirma3],[IdFirma4],[IdFirma5],[NombreCompleto1],[NombreCompleto2],[NombreCompleto3],[NombreCompleto4],[NombreCompleto5],[Puesto1],[Puesto2],[Puesto3],[Puesto4],[Puesto5])
     VALUES
 (48,NULL,'II.3.1','Otros Ingresos y Beneficios Varios',NULL,NULL,'CONAC 27-09-2018',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(49,NULL,'VI.2.1','Reestructuración de Deuda Pública',NULL,NULL,'CONAC 27-09-2018',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(50,NULL,'VI.5.1','Inversiones',NULL,NULL,'CONAC 27-09-2018',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(51,NULL,'VI.5.3','Inversiones de Participaciones y Aportaciones de Capital',NULL,NULL,'CONAC 27-09-2018',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;

DELETE FROM C_DocumentosFuente WHERE IdDocumentoFuente IN (107,108,109,110);
INSERT INTO [dbo].[C_DocumentosFuente]
           ([IdDocumentoFuente], [Nombre])
     VALUES
 (107,'Estado de cuenta o documento que ampare la operación') -- Para II.1.5 Ev11
,(108,'Autorización del reintegro, copia del cheque, transferencia bancaria o documento equivalente') -- Para II.1.5 Ev12, II.1.8 Ev12
,(109,'Acta o convenio de donación o documento equivalente') -- Para II.3.1 Ev1
,(110,'Estado de cuenta, transferencia bancaria o documento equivalente') -- Para VI.5.1 Ev1, Ev2, Ev3
;

DELETE FROM C_ConceptosGuia WHERE IdGuia=6 AND Numero IN ('11','12');
DELETE FROM C_ConceptosGuia WHERE IdGuia=48 AND Numero IN ('01','02');
DELETE FROM C_ConceptosGuia WHERE IdGuia=49 AND Numero IN ('01','02');
DELETE FROM C_ConceptosGuia WHERE IdGuia=50 AND Numero IN ('01','02','03');
DELETE FROM C_ConceptosGuia WHERE IdGuia=51 AND Numero IN ('01');
DECLARE @ConsecEv INT = (SELECT MAX (IdConcepto) FROM C_ConceptosGuia) 
INSERT INTO [dbo].[C_ConceptosGuia]
           ([IdConcepto],[IdGuia],[Numero],[Concepto],[Periodicidad],[IdDocumentoFuente],[CONAC],[IdTipoMovimiento],[Automatizado],[TipoMovimientoOperativoContable],[Orden],[CondicionRango1],[CondicionRango2],[Condicionante])
     VALUES
 (@ConsecEv+1,6,'11','Por el devengado por el reconocimiento de ingresos de intereses generados en las cuentas bancarias productivas de los entes públicos, en términos de las disposiciones aplicables','Eventual',107,1,127,NULL,NULL,0,'52000','52999',NULL) -- II.1.5 Ev11
,(@ConsecEv+2,6,'12','Por la autorización y el pago del reintegro a la Tesorería de ingresos de intereses generados en las cuentas bancarias productivas de los entes públicos, en términos de las disposiciones aplicables','Eventual',108,1,95,NULL,NULL,0,'52000','52999',NULL) -- II.1.5 Ev12
,(@ConsecEv+3,48,'01','Por el devengado por otros ingresos que generan recursos por donativos en efectivo, entre otros. 1','Eventual',109,1,5,NULL,NULL,0,'94000','94101',NULL) -- II.3.1 Ev1
,(@ConsecEv+4,48,'02','Por el cobro de otros ingresos que generan recursos. 1','Eventual',57,1,6,NULL,NULL,0,'94000','94101',NULL) -- II.3.1 Ev2
,(@ConsecEv+5,49,'01','De la variación a favor por la reestructuración de la deuda pública interna y/o externa','Frecuente',27,1,2,NULL,NULL,0,'01000','01999',NULL) -- VI.2.1 Ev1
,(@ConsecEv+6,49,'02','De la variación en contra por la reestructuración de la deuda pública interna y/o externa','Frecuente',27,1,7,NULL,NULL,0,'91000','91999',NULL) -- VI.2.1 Ev2
,(@ConsecEv+7,50,'01','Por el devengado y el pago por la contratación o incremento de inversiones financieras','Eventual',110,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- VI.5.1 Ev1 -- Jorge Ornelas determina que el tipo de póliza y rango deben quedar en blanco
,(@ConsecEv+8,50,'02','Por el cobro derivado de la recuperación de recursos al vencimiento de las inversiones financieras y sus intereses','Eventual',110,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- VI.5.1 Ev2 -- Jorge Ornelas determina que el tipo de póliza y rango deben quedar en blanco
,(@ConsecEv+9,50,'03','Por el cobro de los pasivos diferidos','Eventual',110,1,NULL,NULL,NULL,0,NULL,NULL,NULL) -- VI.5.1 Ev3 -- Jorge Ornelas determina que el tipo de póliza y rango deben quedar en blanco
,(@ConsecEv+10,51,'01','Por el devengado y el pago de participaciones y aportaciones de capital','Frecuente',14,1,195,NULL,NULL,0,'81000','83999',NULL) -- VI.5.3 Ev1
;


DECLARE @611 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=6 AND Numero='11');
DECLARE @612 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=6 AND Numero='12');
DECLARE @481 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=48 AND Numero='01');
DECLARE @482 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=48 AND Numero='02');
DECLARE @491 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=49 AND Numero='01');
DECLARE @492 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=49 AND Numero='02');
DECLARE @501 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=50 AND Numero='01');
DECLARE @502 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=50 AND Numero='02');
DECLARE @503 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=50 AND Numero='03');
DECLARE @511 INT =(SELECT IdConcepto FROM C_ConceptosGuia WHERE IdGuia=51 AND Numero='01');


DELETE FROM D_CuentasGuia WHERE IdConcepto IN (@611, @612, @481, @482, @491, @492, @501, @502, @503, @511);
DECLARE @ConsecCtasG INT = (SELECT MAX (IdCuentasGuia) FROM D_CuentasGuia) 
INSERT INTO [dbo].[D_CuentasGuia]
           ([IdCuentasGuia],[IdConcepto],[IdCuenta],[Cuenta],[Numero],[TipoAfectacion],[TipoCuenta],[Observaciones])
     VALUES
-- II.1.5
 (@ConsecCtasG+1,@611,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+2,@611,1039,'4151'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+3,@611,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+4,@611,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+5,@611,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+6,@611,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev11 
,(@ConsecCtasG+7,@612,1039,'4151'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev12
,(@ConsecCtasG+8,@612,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev12
,(@ConsecCtasG+9,@612,186,'322'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev12
,(@ConsecCtasG+10,@612,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev12
,(@ConsecCtasG+11,@612,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev12 
,(@ConsecCtasG+12,@612,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido',NULL) -- Ev12
,(@ConsecCtasG+13,@612,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev12
,(@ConsecCtasG+14,@612,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Requerido',NULL) -- Ev12
,(@ConsecCtasG+15,@612,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev12
,(@ConsecCtasG+16,@612,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional',NULL) -- Ev12
-- II.3.1
,(@ConsecCtasG+17,@481,44,'1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+18,@481,1084,'4399'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+19,@481,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+20,@481,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+21,@482,14,'1111'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev2
,(@ConsecCtasG+22,@482,44,'1122'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev2
,(@ConsecCtasG+23,@482,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev2
,(@ConsecCtasG+24,@482,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev2
,(@ConsecCtasG+25,@482,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev2
-- VI.2.1
,(@ConsecCtasG+26,@491,949,'2141'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+27,@491,689,'4397'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+28,@491,950,'2142'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+29,@491,980,'2231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+30,@491,981,'2232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+31,@491,982,'2233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+32,@491,983,'2234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+33,@492,690,'5598'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev2
,(@ConsecCtasG+34,@492,949,'2141'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+35,@492,950,'2142'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+36,@492,980,'2231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+37,@492,981,'2232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,4,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+38,@492,982,'2233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+39,@492,983,'2234'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Abono','Opcional',NULL) -- Ev2
-- VI.5.1
,(@ConsecCtasG+40,@501,35,'1114'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+41,@501,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+42,@501,796,'1121'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+43,@501,833,'1211'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+44,@501,834,'12111'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,4,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+45,@501,835,'12112'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,5,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+46,@501,836,'1212'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+47,@501,837,'12121'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,7,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+48,@501,838,'12122'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,8,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+49,@501,839,'12123'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,9,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+50,@501,840,'12129'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,10,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+51,@501,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,11,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+52,@501,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,11,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+53,@502,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev2
,(@ConsecCtasG+54,@502,35,'1114'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+55,@502,796,'1121'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+56,@502,833,'1211'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+57,@502,834,'12111'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,4,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+58,@502,835,'12112'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,5,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+59,@502,836,'1212'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,6,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+60,@502,837,'12121'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,7,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+61,@502,838,'12122'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,8,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+62,@502,839,'12123'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,9,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+63,@502,840,'12129'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,10,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+64,@502,224,'4311'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,11,'Abono','Opcional',NULL) -- Ev2
,(@ConsecCtasG+65,@502,1213,'812'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,11,'Cargo','Requerido',NULL) -- Ev2
,(@ConsecCtasG+66,@502,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,11,'Abono','Requerido',NULL) -- Ev2
,(@ConsecCtasG+67,@502,1215,'814'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,12,'Cargo','Requerido',NULL) -- Ev2
,(@ConsecCtasG+68,@502,1216,'815'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,12,'Abono','Requerido',NULL) -- Ev2
,(@ConsecCtasG+69,@503,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev3
,(@ConsecCtasG+70,@503,951,'2151'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Opcional',NULL) -- Ev3
,(@ConsecCtasG+71,@503,952,'2152'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,2,'Abono','Opcional',NULL) -- Ev3
,(@ConsecCtasG+72,@503,953,'2159'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,3,'Abono','Opcional',NULL) -- Ev3
-- VI.5.3
,(@ConsecCtasG+73,@511,847,'1214'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+74,@511,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+75,@511,1221,'825'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+76,@511,1220,'824'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,1,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+77,@511,848,'12141'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,2,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+78,@511,1222,'826'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+79,@511,1221,'825'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,2,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+80,@511,849,'12142'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,5,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+81,@511,850,'12143'+Replicate('0',@Estructura1-5)+'-'+@CerosEstructura,4,'Cargo','Opcional',NULL) -- Ev1

,(@ConsecCtasG+82,@511,165,'2119'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Cargo','Opcional',NULL) -- Ev1
,(@ConsecCtasG+83,@511,17,'1112'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,5,'Abono','Requerido',NULL) -- Ev1
,(@ConsecCtasG+84,@511,1223,'827'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,5,'Cargo','Requerido',NULL) -- Ev1
,(@ConsecCtasG+85,@511,1222,'826'+Replicate('0',@Estructura1-3)+'-'+@CerosEstructura,5,'Abono','Requerido',NULL) -- Ev1
;


-- Eliminación de la Guía Contabilizadora que antes de las reformas CONAC era el evento 'V.2.4'
DELETE FROM C_GuiaContable WHERE IdGuia=33;
DELETE FROM C_ConceptosGuia WHERE IdGuia=33;
DELETE FROM D_CuentasGuia WHERE IdConcepto IN (322,323,324);
