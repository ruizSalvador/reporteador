-- Actualiza tipo de gasto en cuentas autómaticas.
If not exists (Select * from C_TipoGasto where IDTIPOGASTO  = 4)
begin 
    INSERT [dbo].[C_TipoGasto] ([IDTIPOGASTO], [Clave], [NOMBRE], [DESCRIPCION]) VALUES (4, N'4', N'Pensiones y Jubilaciones', N'Son los gastos destinados para el pago a pensionistas y jubilados o a sus familiares, que cubren los gobiernos Federal, Estatal y Municipal, o bien el Instituto de Seguridad Social correspondiente.')
end

If not exists (Select * from C_TipoGasto where IDTIPOGASTO  = 5)
begin 
   INSERT [dbo].[C_TipoGasto] ([IDTIPOGASTO], [Clave], [NOMBRE], [DESCRIPCION]) VALUES (5, N'5', N'Participaciones', N'Son los gastos destinados a cubrir las participaciones para las entidades federativas y/o los municipios.')
end

update T_CuentasAutomaticas set CuentaFinal=4   where Condicion like '45%' or Condicion like '47%'
update T_CuentasAutomaticas set CuentaFinal=5   where Condicion like '81%' and tipo <> 'c'
update T_CuentasAutomaticas set CuentaFinal='NA'   where  tipo = 'T'



