/****** Object:  StoredProcedure [dbo].[SP_Resultado_Ingresos]    Script Date: 26/03/2021 11:51:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Resultado_Ingresos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Resultado_Ingresos]
GO
                                        
/****** Object:  StoredProcedure [dbo].[SP_Resultado_Ingresos]    Script Date: 26/03/2021 11:51:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_Resultado_Ingresos                        
CREATE PROCEDURE [dbo].[SP_Resultado_Ingresos]
	
AS
BEGIN

DECLARE @Titulos TABLE ( Concepto char(200),
								A�oVigente decimal (18,2),
								A�o1 decimal (18,2),
								A�o2 decimal (18,2),
								A�o3 decimal (18,2),
								A�o4 decimal (18,2),
								A�o5 decimal (18,2),
								Negritas int,
								Clave int)

							---*Algunas claves se pusieron para control
INSERT INTO @Titulos VALUES ('1. INGRESOS DE LIBRE DISPOSICI�N  (1 = A+B+C+D+E+F+G+H+I+J+K+L)',0,0,0,0,0,0,1,25)
INSERT INTO @Titulos VALUES ('	A.IMPUESTOS',0,0,0,0,0,0,0,10000)
INSERT INTO @Titulos VALUES ('	B.CUOTAS Y APORTACIONES DE SEGURIDAD SOCIAL',0,0,0,0,0,0,0,20000)
INSERT INTO @Titulos VALUES ('	C.CONTRIBUCIONES DE MEJORA',0,0,0,0,0,0,0,30000)
INSERT INTO @Titulos VALUES ('	D.DERECHOS',0,0,0,0,0,0,0,40000)
INSERT INTO @Titulos VALUES ('	E.PRODUCTOS',0,0,0,0,0,0,0,50000)
INSERT INTO @Titulos VALUES ('	F.APROVECHAMIENTOS',0,0,0,0,0,0,0,60000)
INSERT INTO @Titulos VALUES ('	G.INGRESOS POR VENTA DE BIENES Y SERVICIOS',0,0,0,0,0,0,0,70000)
INSERT INTO @Titulos VALUES ('	H.PARTICIPACIONES',0,0,0,0,0,0,0,80000)
INSERT INTO @Titulos VALUES ('	I.INCENTIVOS DERIVADOS DE LA COLABORACION FISCAL',0,0,0,0,0,0,0,90000)
INSERT INTO @Titulos VALUES ('	J.TRANSFERENCIAS',0,0,0,0,0,0,0,11000)
INSERT INTO @Titulos VALUES ('	K.CONVENIOS',0,0,0,0,0,0,0,21000)
INSERT INTO @Titulos VALUES ('	L.OTROS INGRESOS DE LIBRE DISPOSICION',0,0,0,0,0,0,0,31000)
INSERT INTO @Titulos VALUES ('',0,0,0,0,0,0,0,41000)
INSERT INTO @Titulos VALUES ('2. TRANSFERENCIAS FEDERALES ETIQUETADAS ( 2= A+B+C+D+E)',0,0,0,0,0,0,1,26)
INSERT INTO @Titulos VALUES ('	A. APORTACIONES',0,0,0,0,0,0,0,51000)
INSERT INTO @Titulos VALUES ('	B. CONVENIO',0,0,0,0,0,0,0,61000)
INSERT INTO @Titulos VALUES ('	C. FONDOS DISTINTOS DE APORTACIONES',0,0,0,0,0,0,0,71000)
INSERT INTO @Titulos VALUES ('	D. TRANSFERENCIAS, SUBSIDIOS Y SUBVENCIONES, Y PENSIONES      Y JUBILACIONES',0,0,0,0,0,0,0,81000)
INSERT INTO @Titulos VALUES ('	E. OTRAS TRANSFERENCIAS FEDERALES ETIQUETADAS',0,0,0,0,0,0,0,91000)
INSERT INTO @Titulos VALUES ('',0,0,0,0,0,0,0,27)
INSERT INTO @Titulos VALUES ('3. INGRESOS DERIVADOS DE FINANCIAMIENTOS ( 3=A)',0,0,0,0,0,0,1,28)
INSERT INTO @Titulos VALUES ('	A. INGRESOS DERIVADOS DE FINANCIAMIENTOS',0,0,0,0,0,0,0,12000)
INSERT INTO @Titulos VALUES ('',0,0,0,0,0,0,0,29)
INSERT INTO @Titulos VALUES ('4. TOTAL DE INGRESOS PROYECTADOS ( 4 = 1 + 2 +3 )',0,0,0,0,0,0,1,30)
INSERT INTO @Titulos VALUES ('',0,0,0,0,0,0,0,31)
INSERT INTO @Titulos VALUES ('DATOS INFORMATIVOS',0,0,0,0,0,0,1,32)
INSERT INTO @Titulos VALUES ('	1. INGRESOS DERIVADOS DE FINANCIAMIENTOS CON FUENTE DE PAGO DE RECURSOS DE LIBRE DISPOSICION',0,0,0,0,0,0,0,22000)
INSERT INTO @Titulos VALUES ('	2. INGRESOS DERIVADOS DE FINANCIAMIENTOS CON FUENTE DE PAGO DE TRANSFERENCIAS FEDERALES ETIQUETADAS',0,0,0,0,0,0,0,32000)
INSERT INTO @Titulos VALUES ('	3. INGRESOS DERIVADOS DE FINANCIAMIENTO ( 3 = 1 + 2 )',0,0,0,0,0,0,0,42000)

Declare @EjercicioActual int = (Select YEAR(GETDATE()))
Declare @Ejercicio1 int = (Select YEAR(GETDATE())-1)
Declare @Ejercicio2 int = (Select YEAR(GETDATE())-2)
Declare @Ejercicio3 int = (Select YEAR(GETDATE())-3)
Declare @Ejercicio4 int = (Select YEAR(GETDATE())-4)
Declare @Ejercicio5 int = (Select YEAR(GETDATE())-5)


Declare @VaciadoActual as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado1 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado2 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado3 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado4 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)

Declare @Vaciado5 as TABLE(
Clave varchar(7),
Clasificacion varchar(255),
Total_Estimado decimal (15,2),
Total_Modificado decimal (15,2),
Total_Devengado decimal (15,2),
Total_Recaudado decimal (15,2),
Orden decimal (15,2),
AmpliacionesReducciones decimal(15,2),
Excedentes decimal (15,2),
Negritas int,
Tab int
)


Insert into @VaciadoActual
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @EjercicioActual

Insert into @Vaciado1
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @Ejercicio1

Insert into @Vaciado2
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @Ejercicio2

Insert into @Vaciado3
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @Ejercicio3

Insert into @Vaciado4
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @Ejercicio4

Insert into @Vaciado5
Exec SP_EstadoAnalitico_Ingresos_Detallado_Resultado 1,12,1, @Ejercicio5


UPDATE t set t.A�oVigente = ISNULL(va.Total_Devengado,0), t.A�o1 = ISNULL(v1.Total_Devengado,0), t.A�o2 = ISNULL(v2.Total_Devengado,0), t.A�o3 = ISNULL(v3.Total_Devengado,0),
t.A�o4 = ISNULL(v4.Total_Devengado,0), t.A�o5 = ISNULL(v5.Total_Devengado,0)
FROM @Titulos t, @VaciadoActual va,@Vaciado1 v1, @Vaciado2 v2, @Vaciado3 v3, @Vaciado4 v4, @Vaciado5 v5
Where t.Clave = va.Clave and t.Clave = v1.Clave and t.Clave = v2.Clave and t.Clave = v3.Clave and t.Clave = v4.Clave and t.Clave = v5.Clave

Update @Titulos set A�oVigente = (Select SUM(A�oVigente) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000)), 
					A�o1 = (Select SUM(A�o1) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000)),
					A�o2 = (Select SUM(A�o2) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000)),
					A�o3 = (Select SUM(A�o3) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000)),
					A�o4 = (Select SUM(A�o4) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000)),
					A�o5 = (Select SUM(A�o5) from @Titulos where Clave in (10000,20000,30000,40000,50000,60000,70000,80000,90000,11000,21000,31000))
					Where Clave = 25

Update @Titulos set A�oVigente = (Select SUM(A�oVigente) from @Titulos where Clave in (51000,61000,71000,81000,91000)), 
					A�o1 = (Select SUM(A�o1) from @Titulos where Clave in (51000,61000,71000,81000,91000)),
					A�o2 = (Select SUM(A�o2) from @Titulos where Clave in (51000,61000,71000,81000,91000)),
					A�o3 = (Select SUM(A�o3) from @Titulos where Clave in (51000,61000,71000,81000,91000)),
					A�o4 = (Select SUM(A�o4) from @Titulos where Clave in (51000,61000,71000,81000,91000)),
					A�o5 = (Select SUM(A�o5) from @Titulos where Clave in (51000,61000,71000,81000,91000))
					Where Clave = 26

Update @Titulos set A�oVigente = (Select SUM(A�oVigente) from @Titulos where Clave in (12000)), 
					A�o1 = (Select SUM(A�o1) from @Titulos where Clave in (12000)),
					A�o2 = (Select SUM(A�o2) from @Titulos where Clave in (12000)),
					A�o3 = (Select SUM(A�o3) from @Titulos where Clave in (12000)),
					A�o4 = (Select SUM(A�o4) from @Titulos where Clave in (12000)),
					A�o5 = (Select SUM(A�o5) from @Titulos where Clave in (12000))
					Where Clave = 28

Update @Titulos set A�oVigente = (Select SUM(A�oVigente) from @Titulos where Clave in (25,26,28)), 
					A�o1 = (Select SUM(A�o1) from @Titulos where Clave in (25,26,28)),
					A�o2 = (Select SUM(A�o2) from @Titulos where Clave in (25,26,28)),
					A�o3 = (Select SUM(A�o3) from @Titulos where Clave in (25,26,28)),
					A�o4 = (Select SUM(A�o4) from @Titulos where Clave in (25,26,28)),
					A�o5 = (Select SUM(A�o5) from @Titulos where Clave in (25,26,28))
					Where Clave = 30

SELECT  *  FROM @Titulos 	
END


EXEC SP_FirmasReporte 'Resultado Ingresos'
GO

Exec SP_CFG_LogScripts 'SP_Resultado_Ingresos','2.30.1'
GO