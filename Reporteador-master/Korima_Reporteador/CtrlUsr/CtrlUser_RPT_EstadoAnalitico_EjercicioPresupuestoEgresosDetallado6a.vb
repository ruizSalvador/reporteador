﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado6a

    Private Function MesLetra(ByVal Mes As Integer) As String
        Select Case Mes
            Case 1
                Return "Enero"
            Case 2
                Return "Febrero"
            Case 3
                Return "Marzo"
            Case 4
                Return "Abril"
            Case 5
                Return "Mayo"
            Case 6
                Return "Junio"
            Case 7
                Return "Julio"
            Case 8
                Return "Agosto"
            Case 9
                Return "Septiembre"
            Case 10
                Return "Octubre"
            Case 11
                Return "Noviembre"
            Case 12
                Return "Diciembre"
            Case Else
                Return ""
        End Select
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()
        'Dim reporte As New RPT_EstadoEjercicioIngresos_Rubro
        Dim reporte As New RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado6a

        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        'If ChkAnual.Checked = True Then
        'SQLComando.Parameters.Add(New SqlParameter("@MesInicio", 0))
        'SQLComando.Parameters.Add(New SqlParameter("@MesFin", 0))

        'Else
        '  SQLComando.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoIni.Time.Month))
        '   SQLComando.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoFin.Time.Month))
        'End If
        'SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", ChkMuestraNulos.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Time.Year))



        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado")
        'adapter.Fill(ds, "SP_EstadoEjercicio_PresupuestoEgresosDetallado")

        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado"
        'reporte.DataMember = "SP_EstadoEjercicio_PresupuestoEgresosDetallado"


        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado Analitico De Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado sobre el Ejercicio de los Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Clasificacion por Objeto del Gasto(Capitulo y Concepto)"
            .lblRptNombreReporte.Text = "Estado Analitico del Ejercicio del Presupuesto de Egresos Detallado -LDF"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            Dim segundo As DateTime = New DateTime()
            If filterPeriodoFin.SelectedText = "02" Then

                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 28)
            ElseIf filterPeriodoFin.SelectedText = "04" Or filterPeriodoFin.SelectedText = "06" Or filterPeriodoFin.SelectedText = "09" Or filterPeriodoFin.SelectedText = "11" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 30)
            ElseIf filterPeriodoFin.SelectedText = "01" Or filterPeriodoFin.SelectedText = "03" Or filterPeriodoFin.SelectedText = "05" Or filterPeriodoFin.SelectedText = "07" Or filterPeriodoFin.SelectedText = "08" Or filterPeriodoFin.SelectedText = "10" Or filterPeriodoFin.SelectedText = "12" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 31)
            End If

            Dim primero As DateTime = New DateTime()
            If filterPeriodoIni.SelectedText = "02" Then

                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 28)
            ElseIf filterPeriodoIni.SelectedText = "04" Or filterPeriodoIni.SelectedText = "06" Or filterPeriodoIni.SelectedText = "09" Or filterPeriodoIni.SelectedText = "11" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 30)
            ElseIf filterPeriodoIni.SelectedText = "01" Or filterPeriodoIni.SelectedText = "03" Or filterPeriodoIni.SelectedText = "05" Or filterPeriodoIni.SelectedText = "07" Or filterPeriodoIni.SelectedText = "08" Or filterPeriodoIni.SelectedText = "10" Or filterPeriodoIni.SelectedText = "12" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 31)
            End If

            Dim ultimo As Date = New DateTime(filterPeriodoFin.Time.Year, filterPeriodoFin.Time.Month, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Del 1 de Enero" & filterEjercicio.Time.Year.ToString & " Al " & "31 de diciembre" & filterEjercicio.Time.Year.ToString
            Else
                ' .lblRptDescripcionFiltrado.Text = "Del 1 de Enero Al " & DateTime.DaysInMonth(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month).ToString & " de " & filterPeriodoFin.Time.Month.ToString & " de " & filterEjercicio.Time.Year.ToString
                .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " Al " + ultimo.Day.ToString + " del " + MesLetra(segundo.Month) + " del " & filterEjercicio.Time.Year.ToString
            End If

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado Analitico De Ingresos por Rubro' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now
    End Sub

    Private Sub ChkAnual_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub
End Class