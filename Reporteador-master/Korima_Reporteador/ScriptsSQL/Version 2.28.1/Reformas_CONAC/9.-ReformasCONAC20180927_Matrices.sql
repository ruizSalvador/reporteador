-- Estructura
declare @Estructura1 as int
declare @Estructura2 as int
set @Estructura1= Convert(Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),1,1))
set @Estructura2= Convert (Int,SUBSTRING((SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'),3,1))
declare @CerosEstructura varchar(20)
set @CerosEstructura = REPLICATE('0',@Estructura2)

-- Reformas a Matriz de Conversión Ingresos Devengados CONAC 20180927, Validar si la BD tiene la misma estructura en Condición
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4142'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='42000' AND Condicion2='42999';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4152'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='51100' AND Condicion2='51199';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4159'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='51500' AND Condicion2='51599';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4161'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='61400' AND Condicion2='61499';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4166'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='61600' AND Condicion2='61699';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4167'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='61700' AND Condicion2='61799';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4222'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='92000' AND Condicion2='92999';
DELETE FROM T_CuentasAutomaticas WHERE Tipo='T' AND CuentaInicial='4224'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND Condicion='94000' AND Condicion2='94999';

UPDATE T_CuentasAutomaticas SET CuentaInicial='4118'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=678 WHERE Tipo='T' AND Condicion='19000' AND Condicion2='19999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4132'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=679 WHERE Tipo='T' AND Condicion='39000' AND Condicion2='39999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4145'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=680 WHERE Tipo='T' AND Condicion='49000' AND Condicion2='49999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4154'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=681 WHERE Tipo='T' AND Condicion='59000' AND Condicion2='59999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4166'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=1225 WHERE Tipo='T' AND Condicion='59000' AND Condicion2='59999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4171'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=1049 WHERE Tipo='T' AND Condicion='59000' AND Condicion2='59999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4172'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=1050 WHERE Tipo='T' AND Condicion='59000' AND Condicion2='59999';
UPDATE T_CuentasAutomaticas SET CuentaInicial='4173'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura, IdCuentaContablePadre=1051 WHERE Tipo='T' AND Condicion='59000' AND Condicion2='59999';

UPDATE T_CuentasAutomaticas SET Condicion='51000', Condicion2='51999' WHERE Tipo='T' AND CuentaInicial='4151'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND IdCuentaContablePadre=1039;
UPDATE T_CuentasAutomaticas SET Condicion='63000', Condicion2='63999' WHERE Tipo='T' AND CuentaInicial='4168'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND IdCuentaContablePadre=1048;
UPDATE T_CuentasAutomaticas SET Condicion='61900', Condicion2='61999' WHERE Tipo='T' AND CuentaInicial='4169'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura AND IdCuentaContablePadre=219;

INSERT INTO [dbo].[T_CuentasAutomaticas]
           ([Tipo],[IdTipoCuenta],[CuentaInicial],[CuentaFinal],[Posiciones],[IdCuentaContablePadre],[Condicion],[Condicion2])
     VALUES
 ('T',32,'4174'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,1052,'74000','74999')
,('T',32,'4175'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,682,'75000','75999')
,('T',32,'4176'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,683,'76000','76999')
,('T',32,'4177'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,684,'77000','77999')
,('T',32,'4178'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,685,'78000','78999')
,('T',32,'4399'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,1084,'79000','79999')
,('T',32,'4214'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,686,'84000','84999')
,('T',32,'4215'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,687,'85000','85999')
,('T',32,'4227'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,688,'97000','97999')
,('T',32,'1231'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,84,'62501','62501')
,('T',32,'1232'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,860,'62502','62502')
,('T',32,'1233'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,393,'62503','62503')
,('T',32,'1239'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,96,'62504','62504')
,('T',32,'1241'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,98,'62510','62519')
,('T',32,'1242'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,105,'62520','62529')
,('T',32,'1243'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,108,'62530','62539')
,('T',32,'1244'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,111,'62540','62549')
,('T',32,'1245'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,1224,'62550','62559')
,('T',32,'1246'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,116,'62560','62569')
,('T',32,'1247'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,892,'62580','62589')
,('T',32,'1248'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,893,'62570','62579')
,('T',32,'1251'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,124,'62591','62591')
,('T',32,'1252'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,905,'62592','62592')
,('T',32,'1253'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,909,'62595','62595')
,('T',32,'1254'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,126,'62597','62597')
,('T',32,'1259'+Replicate('0',@Estructura1-4)+'-'+@CerosEstructura,'NA',5,913,'62599','62599')
;