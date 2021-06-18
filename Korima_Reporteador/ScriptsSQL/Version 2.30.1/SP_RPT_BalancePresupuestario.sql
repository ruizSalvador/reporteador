/****** Object:  StoredProcedure [dbo].[SP_RPT_BalancePresupuestario]    Script Date: 01/21/2021 16:04:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_BalancePresupuestario]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_RPT_BalancePresupuestario]
GO

/****** Object:  StoredProcedure [dbo].[SP_RPT_BalancePresupuestario]    Script Date: 01/21/2021 16:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SP_RPT_BalancePresupuestario 1,12,2020,0
CREATE PROCEDURE [dbo].[SP_RPT_BalancePresupuestario]

@Mes1 int,
@Mes2 int,
@Ejercicio int,
@miles bit

AS
BEGIN

Declare @Division int
IF @Miles= 1 set @Division =1000
else Set @Division=1

DECLARE  @Titulos as TABLE(
				Concepto varchar(max),
				Estimado Decimal(18,2),
				Devengado Decimal(18,2), 
				Recaudado Decimal(18,2), 
				Negritas int,
				Grupo int,
				Orden int 
				)


Declare @DataING as Table (IdPartida int, 
Clave varchar (100), 
IdClaveFF int,
Estimado decimal(18,2), 
Ampliaciones decimal (18,2),
 Reducciones decimal (18,2), 
 Modificado decimal (18,2),
 Devengado decimal (18,2),
 Recaudado decimal (18,2),  
 PorRecaudar decimal (18,2))

 Declare @DataEGR as table(IdSello int,Sello varchar(max), Partida varchar (100), Concepto varchar (100), IdClaveFF int, 
Autorizado decimal(18,4),TransferenciaAmp decimal(18,4),TransferenciaRed decimal(18,4),Modificado decimal(18,4),Comprometido decimal(18,4),
Devengado decimal(18,4),Ejercido decimal(18,4),Pagado decimal(18,4),PresDispComp decimal(18,4),CompNoDev decimal(18,4),
PresSinDev decimal(18,4),Deuda decimal(18,4),Amp_Red decimal(18,4),SubEjercicio decimal(18,4))

Insert into @DataEGR
Select TP.IdSelloPresupuestal, TS.Sello, CP.IdPartida as Partida, CP.IdConcepto as Concepto,   FF.IdClave as IdClaveFF ,

sum(ISNULL(TP.Autorizado,0)) as Autorizado, 
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) as TransferenciaAmp, 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as TransferenciaRed, 
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))as Modificado,

sum(ISNULL(TP.Comprometido,0)) as Comprometido, 
sum(ISNULL(TP.Devengado,0)) as Devengado, 
sum(ISNULL(TP.Ejercido,0)) as Ejercido,
sum(ISNULL(TP.Pagado,0)) as Pagado,

(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Comprometido,0)) As PresDispComp,
sum(ISNULL(TP.Comprometido,0)) - sum(ISNULL(TP.Devengado,0)) AS CompNoDev,
(sum(ISNULL(TP.Autorizado,0)) +  (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0)))) - sum(ISNULL(TP.Devengado,0))  AS PresSinDev,
sum(ISNULL(TP.Devengado,0)) -  sum(ISNULL(TP.Ejercido,0)) AS Deuda,
(sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - 
(sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))) as Amp_Red,
(sum(ISNULL(TP.Autorizado,0)) + (sum(ISNULL(TP.Ampliaciones,0)) + sum(ISNULL(TP.TransferenciaAmp,0))) - (sum(ISNULL(TP.Reducciones,0)) + sum(ISNULL(TP.TransferenciaRed,0))))-
sum(ISNULL(TP.Comprometido,0)) as SubEjercicio  

From T_PresupuestoNW As TP, T_SellosPresupuestales As TS, C_PartidasPres As CP   ,c_fuentefinanciamiento FF
where  (Mes BETWEEN @Mes1 AND @Mes2) AND LYear=@Ejercicio AND Year=@Ejercicio and  TP.IdSelloPresupuestal = TS.IdSelloPresupuestal  
and CP.IdPartida = TS.IdPartida   and TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
group by TP.IdSelloPresupuestal, TS.Sello, CP.IdPartida, CP.IdConcepto  ,FF.IdClave
Order By TP.IdSelloPresupuestal  
  
  --select 'EGR ',* from @DataEGR --kazb
  
 Insert into @DataING  
Select TP.IdPartida  , TS.Clave as Clave,  FF.IdClave as IdClaveFF ,
  sum(ISNULL(TP.Estimado,0)) as Estimado,   
  sum(ISNULL(TP.Ampliaciones ,0)) as Ampliaciones,   
  sum(ISNULL(TP.Reducciones ,0)) as Reducciones,   
  sum(ISNULL(TP.Modificado ,0)) as Modificado,  
  sum(ISNULL(TP.Devengado ,0)) as Devengado,  
  sum(ISNULL(TP.Recaudado ,0)) as Recaudado,    
  sum(ISNULL(TP.PorRecaudar  ,0)) as PorRecaudar  
     
  From T_PresupuestoFlujo  As TP, C_PartidasGastosIngresos  As TS   ,c_fuentefinanciamiento FF
  Where TP.IdPartida  = TS.IdPartidaGI  and TS.IdFuenteFinanciamiento = FF.IDFUENTEFINANCIAMIENTO
  and (Mes BETWEEN @Mes1 AND @Mes2) AND TP.Ejercicio =@Ejercicio  
  group by TP.IdPartida, TS.Clave,FF.IdClave--,Devengado, Recaudado  
  Order By TP.IdPartida  
  
  --select 'ING ',* from @DataING --kazb
  
INSERT INTO @Titulos  values ('A. Ingresos Totales ( A = A1+A2+A3)',7,8,9,1,1,1)  
INSERT INTO @Titulos  values ('   A1.Ingresos de Libre Disposición',0,0,0,0,1,2)  
INSERT INTO @Titulos  values ('   A2. Transferencias Federales Etiquetadas',0,0,0,0,1,3)  
INSERT INTO @Titulos  values ('   A3. Financiamiento Neto',0,0,0,0,1,4)  
INSERT INTO @Titulos  values ('B. Egresos Presupuestarios (B = B1+B2)',0,0,0,1,1,5)  
INSERT INTO @Titulos  values ('   B1. Gasto No Etiquetado (sin incluir Amortización de la Deuda Pública)',0,0,0,0,1,6)  
INSERT INTO @Titulos  values ('   B2. Gasto Etiquetado (sin incluir Amortización de la Deuda Pública)',0,0,0,0,1,7)  
INSERT INTO @Titulos  values ('C.Remanentes del Ejercicio Anterior ( C = C1 + C 2)',0,0,0,1,1,8)  
INSERT INTO @Titulos  values ('   C1. Remanentes de Ingresos de Libre Disposición aplicados en el periodo',0,0,0,0,1,9)  
INSERT INTO @Titulos  values ('   C2. Remanentes de Transferencias Federales Etiquetadas Aplicados en el periodo',0,0,0,0,1,10)  
INSERT INTO @Titulos  values ('I. Balance Presupuestario (I = A-B + C ))',0,0,0,1,1,11)  
INSERT INTO @Titulos  values ('II. Balance Presupuestario sin Financiamiento Neto (II= I - A3)',0,0,0,1,1,12)  
INSERT INTO @Titulos  values ('III. Balance Presupuestario sin Financiamiento Neto y sin Remanentes del Ejercicio Anterior (III= II - C)',0,0,0,1,1,13)  
  
INSERT INTO @Titulos  values ('E. Intereses,Comisiones y Gastos de la Deuda ( E = E1 + E2 )',0,0,0,1,2,14)  
INSERT INTO @Titulos  values ('   E1. Intereses, Comisiones y gastos de la Deuda con Gasto No Etiquetado',0,0,0,0,2,15)  
INSERT INTO @Titulos  values ('   E2. Intereses, Comisiones y gastos de la Deuda con Gasto Etiquetado',0,0,0,0,2,16)  
INSERT INTO @Titulos  values ('IV. Balance Primario ( IV = III + E )',0,0,0,1,2,17)  
  
INSERT INTO @Titulos  values ('F. Financiamiento ( F = F1 + F2 )',0,0,0,1,3,18)  
INSERT INTO @Titulos  values ('   F1. Financiamiento con Fuente de Pago de Ingresos de Libre Disposición',0,0,0,0,3,19)  
INSERT INTO @Titulos  values ('   F2. Financiemiento con Fuente de Pago de Transferencias Federales Etiquetadas',0,0,0,0,3,20)  
INSERT INTO @Titulos  values ('G. Amortización de la Deuda ( G = G1 + G2 )',0,0,0,1,3,21)  
INSERT INTO @Titulos  values ('   G1. Amortización de la Deuda Pública con Gasto No Etiquetado',0,0,0,0,3,22)  
INSERT INTO @Titulos  values ('   G2. Amortización de la Deuda Pública con Gasto Etiquetado',0,0,0,0,3,23)  
INSERT INTO @Titulos  values ('A3. Financiamiento Neto ( A3 = F - G )',0,0,0,1,3,24)  
  
INSERT INTO @Titulos  values ('A1. Ingresos de Libre Disposición',0,0,0,1,4,25)  
INSERT INTO @Titulos  values ('A3.1 Financiamiento Neto con Fuente de Pago de Ingresos de Libre Dispocisión (A3.1 = F1-G1)',0,0,0,1,4,26)  
INSERT INTO @Titulos  values ('   F1. Financiamiento con Fuente de Pago de Ingresos de Libre Disposición',0,0,0,0,4,27)  
INSERT INTO @Titulos  values ('   G1. Amortización de la Deuda Pública con Gasto No Etiquetado',0,0,0,0,4,28)  
INSERT INTO @Titulos  values ('B1. Gasto No Etiquetado (sin incluir Amortización de la Deuda Pública)',0,0,0,1,4,29)  
INSERT INTO @Titulos  values ('C1. Remanentes de Ingresos de Libre Disposición Aplicados en el Periodo',0,0,0,1,4,30)  
INSERT INTO @Titulos  values ('V. Balance Presupuestario de Recursos Disponibles ( V= A1+A3.1 - B1+C1 )',0,0,0,1,4,31)  
INSERT INTO @Titulos  values ('VI. Balance Presupuestario de Recursos Disponibles sin Financiamiento Neto (VI = V - A3.1)',0,0,0,1,4,32)  
  
INSERT INTO @Titulos  values ('A2. Transferencias Federales Etiquetadas',0,0,0,1,5,33)  
INSERT INTO @Titulos  values ('A3.2 Financiamiento Neto con Fuente de Pago de Trasferencias Federales Etiquetadas (A3.2 = F2 - G2 )',0,0,0,1,5,34)  
INSERT INTO @Titulos  values ('   F2. Financiamiento con Fuente de Pago de Transferencias Federales Etiquetadas',0,0,0,0,5,35)  
INSERT INTO @Titulos  values ('   G2. Amortización de la Deuda Pública con Gasto Etiquetado',0,0,0,0,5,36)  
INSERT INTO @Titulos  values ('B2. Gasto Etiquetado (sin incluir Amortización de la Deuda Pública)',0,0,0,1,5,37)  
INSERT INTO @Titulos  values ('C2. Remanentes de Transferencias Federales Etiquetadas aplicados en el Periodo',0,0,0,1,5,38)  
INSERT INTO @Titulos  values ('VII. Balance Presupuestario de Recuros Etiquetados ( VII = A2 + A3.2 - B 2 + C2 )',0,0,0,1,5,39)  
INSERT INTO @Titulos  values ('VIII. Balance Presupuestario de Recursos Etiquetados sin Financiamiento Neto ( VIII = VII - A3.2)',0,0,0,1,5,40)  
  

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9')),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9')),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9')),0)  
    Where Orden in (2,25)  

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @DataING where SUBSTRING(Clave,6,1) in ('8')),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('8')),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('8')),0)  
    Where Orden in (3,33)  
  
Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @DataING where SUBSTRING(Clave,6,1) in ('0')),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('0')),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('0')),0)  
    Where Orden = 4  
  
  --KAZB 
	Update @Titulos set Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9') and IdClaveFF in (11,12,13,14,15,16,17)),0)  ,  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9') and IdClaveFF in (11,12,13,14,15,16,17)),0)
    Where Orden in (2) 
	Update @Titulos set Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('1','2','3','4','5','6','7','9') and IdClaveFF in (25,26,27)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('8') and IdClaveFF in (25,26,27)),0)   
    Where Orden in (3,33) 
	Update @Titulos set Devengado = ISNULL((Select SUM(Devengado) from @DataING where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in (11,12,13,14,15,16,17)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @DataING where SUBSTRING(Clave,6,1) in ('0') and IdClaveFF in (11,12,13,14,15,16,17)),0) 
    Where Orden in (4) 

 --   select '@DataEGR',* from @DataEGR
	--select '@Titulos',* from @Titulos
declare @AutorizadoEGR as decimal (18,2) = (Select SUM(Autorizado) from @DataEGR where IdClaveFF in(11,12,13,14,15,16,17)and SUBSTRING(Partida,1,1) in ('1','2','3','4','5','6','7'))  
declare @DevengadoEGR as decimal (18,2) = (Select SUM(Devengado) from @DataEGR where IdClaveFF in(11,12,13,14,15,16,17)and SUBSTRING(Partida,1,1) in ('1','2','3','4','5','6','7'))  
declare @RecaudadoEGR as decimal (18,2) = (Select SUM(Pagado) from @DataEGR where IdClaveFF in(11,12,13,14,15,16,17)and SUBSTRING(Partida,1,1) in ('1','2','3','4','5','6','7'))  
  
declare @Autorizado8EGR as decimal (18,2) = (Select SUM(Autorizado) from @DataEGR where IdClaveFF in(25,26,27) and SUBSTRING(Partida,1,1) in ('8'))  
declare @Devengado8EGR as decimal (18,2) = (Select SUM(Devengado) from @DataEGR where IdClaveFF in(25,26,27) and SUBSTRING(Partida,1,1) in ('8'))  
declare @Recaudado8EGR as decimal (18,2) = (Select SUM(Pagado) from @DataEGR where IdClaveFF in(25,26,27) and SUBSTRING(Partida,1,1) in ('8'))  

  
Update @Titulos set Estimado = ISNULL(@AutorizadoEGR,0),  
    Devengado = ISNULL(@DevengadoEGR,0),  
    Recaudado  = ISNULL(@RecaudadoEGR,0)  
    Where Orden in (6,29)  
  
Update @Titulos set Estimado = ISNULL(@Autorizado8EGR,0),  
    Devengado = ISNULL(@Devengado8EGR,0),  
    Recaudado  = ISNULL(@Recaudado8EGR,0)  
    Where Orden in (7,37)  
	--KAZB

	declare @DevengadoEGR2 as decimal (18,2) = (Select SUM(Devengado) from @DataEGR where SUBSTRING(Partida,1,1) in ('1','2','3','4','5','6','7') and IdClaveFF in (11,12,13,14,15,16,17))  
	declare @RecaudadoEGR2 as decimal (18,2) = (Select SUM(Pagado) from @DataEGR where SUBSTRING(Partida,1,1) in ('1','2','3','4','5','6','7') and IdClaveFF in (11,12,13,14,15,16,17))  
	Update @Titulos set Devengado = ISNULL(@DevengadoEGR2,0),  
    Recaudado  = ISNULL(@RecaudadoEGR2,0)  
    Where Orden in (6,29) 
  
  declare @Devengado8EGR2 as decimal (18,2) = (Select SUM(Devengado) from @DataEGR where SUBSTRING(Partida,1,1) in ('8') and IdClaveFF in (25,26,27)) 
  declare @Recaudado8EGR2 as decimal (18,2) = (Select SUM(Pagado) from @DataEGR where SUBSTRING(Partida,1,1) in ('8') and IdClaveFF in (25,26,27))   
   Update @Titulos set Devengado = ISNULL(@Devengado8EGR2,0),  
    Recaudado  = ISNULL(@Recaudado8EGR2,0)   
    Where Orden in (7,37)  
  --KAZB

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (2,3,4)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (2,3,4)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (2,3,4)),0)  
    Where Orden = 1  
  
Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (6,7)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (6,7)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (6,7)),0)  
    Where Orden = 5  

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (1)) - (Select SUM(Estimado) from @Titulos where orden in (5)) + (Select SUM(Estimado) from @Titulos where orden in (8)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (1)) - (Select SUM(Devengado) from @Titulos where orden in (5)) + (Select SUM(Devengado) from @Titulos where orden in (8)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (1)) - (Select SUM(Recaudado) from @Titulos where orden in (5)) + (Select SUM(Recaudado) from @Titulos where orden in (8)),0)  
    Where Orden = 11

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (11)) - (Select SUM(Estimado) from @Titulos where orden in (4)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (11)) - (Select SUM(Devengado) from @Titulos where orden in (4)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (11)) - (Select SUM(Recaudado) from @Titulos where orden in (4)),0)  
    Where Orden = 12

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (11)) - (Select SUM(Estimado) from @Titulos where orden in (4)) - (Select SUM(Estimado) from @Titulos where orden in (8)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (11)) - (Select SUM(Devengado) from @Titulos where orden in (4)) - (Select SUM(Estimado) from @Titulos where orden in (8)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (11)) - (Select SUM(Recaudado) from @Titulos where orden in (4)) - - (Select SUM(Estimado) from @Titulos where orden in (8)),0)  
    Where Orden = 13

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (25)) + (Select SUM(Estimado) from @Titulos where orden in (26)) - (Select SUM(Estimado) from @Titulos where orden in (29)) + (Select SUM(Estimado) from @Titulos where orden in (30)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (25)) + (Select SUM(Devengado) from @Titulos where orden in (26)) - (Select SUM(Devengado) from @Titulos where orden in (29)) + (Select SUM(Devengado) from @Titulos where orden in (30)),0),   
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (25)) + (Select SUM(Recaudado) from @Titulos where orden in (26)) - (Select SUM(Recaudado) from @Titulos where orden in (29)) + (Select SUM(Recaudado) from @Titulos where orden in (30)),0)  
    Where Orden = 31

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (25)) - (Select SUM(Estimado) from @Titulos where orden in (29)) + (Select SUM(Estimado) from @Titulos where orden in (30)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (25)) - (Select SUM(Devengado) from @Titulos where orden in (29)) + (Select SUM(Devengado) from @Titulos where orden in (30)),0),   
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (25)) - (Select SUM(Recaudado) from @Titulos where orden in (29)) + (Select SUM(Recaudado) from @Titulos where orden in (30)),0)  
    Where Orden = 32

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (7)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (7)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (7)),0)  
    Where Orden = 37

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (10)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (10)),0),  
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (10)),0)  
    Where Orden = 38 

Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (33)) + (Select SUM(Estimado) from @Titulos where orden in (34)) - (Select SUM(Estimado) from @Titulos where orden in (37)) + (Select SUM(Estimado) from @Titulos where orden in (38)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (33)) + (Select SUM(Devengado) from @Titulos where orden in (34)) - (Select SUM(Devengado) from @Titulos where orden in (37)) + (Select SUM(Devengado) from @Titulos where orden in (38)),0),   
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (33)) + (Select SUM(Recaudado) from @Titulos where orden in (34)) - (Select SUM(Recaudado) from @Titulos where orden in (37)) + (Select SUM(Recaudado) from @Titulos where orden in (38)),0)  
    Where Orden = 39
  
Update @Titulos set Estimado = ISNULL((Select SUM(Estimado) from @Titulos where orden in (33)) - (Select SUM(Estimado) from @Titulos where orden in (37)) + (Select SUM(Estimado) from @Titulos where orden in (38)),0),  
    Devengado = ISNULL((Select SUM(Devengado) from @Titulos where orden in (33)) - (Select SUM(Devengado) from @Titulos where orden in (37)) + (Select SUM(Devengado) from @Titulos where orden in (38)),0),   
    Recaudado  = ISNULL((Select SUM(Recaudado) from @Titulos where orden in (33)) - (Select SUM(Recaudado) from @Titulos where orden in (37)) + (Select SUM(Recaudado) from @Titulos where orden in (38)),0)  
    Where Orden = 40

 Select Concepto,  
   CAST(Estimado/@Division as decimal (18,2)) as Estimado,  
   CAST(Devengado/@Division as decimal (18,2)) as Devengado,   
   CAST(Recaudado/@Division as decimal (18,2)) as Recaudado,   
   Negritas,  
   Grupo,  
   Orden  from @Titulos  
END  
  
EXEC SP_FirmasReporte 'Balance Presupuestario'  

go 

--Exec SP_RPT_BalancePresupuestario @Ejercicio=2020,@Mes1=1,@Mes2=11,@miles=0