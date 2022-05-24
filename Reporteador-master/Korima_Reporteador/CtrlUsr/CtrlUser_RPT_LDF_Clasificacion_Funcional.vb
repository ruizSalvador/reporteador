Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_LDF_Clasificacion_Funcional
    Dim TipoReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)

    Public reporte As RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Funcional_NoEtiquetadoPrincipal
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

        'reporte = New RPT_ClasifFuncionalFinalidadFuncion()
        reporte = New RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Funcional_NoEtiquetadoPrincipal()

        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@Tipo", 7))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado")

        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado"


        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        '--Codgio para Llenar el SubReporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando2 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando2.Parameters.Add(New SqlParameter("@Tipo", 7))

        Dim adapter2 As New SqlDataAdapter(SQLComando2)
        Dim ds2 As New DataSet()
        ds2.EnforceConstraints = False
        adapter2.Fill(ds2, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado")

        reporte.SubReporteEtiquetado.ReportSource.DataSource = ds2
        reporte.SubReporteEtiquetado.ReportSource.DataAdapter = adapter2
        reporte.SubReporteEtiquetado.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado"

        SQLComando2.Dispose()
        SQLConexion.Close()
        '---Fin de llenado del subreporte

        '--Codgio para Llenar el SubReporte Totales con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando3 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado", SQLConexion)
        SQLComando3.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando3.Parameters.Add(New SqlParameter("@Tipo", 7))

        Dim adapter3 As New SqlDataAdapter(SQLComando3)
        Dim ds3 As New DataSet()
        ds3.EnforceConstraints = False
        adapter3.Fill(ds3, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado")

        reporte.Totales.ReportSource.DataSource = ds3
        reporte.Totales.ReportSource.DataAdapter = adapter3
        reporte.Totales.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado"

        SQLComando3.Dispose()
        SQLConexion.Close()
        '---Fin de llenado del subreporte Totales

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = '" & "Balance Presupuestario" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"



        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        Dim primero As Date = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 1)
        Dim ultimo As Date = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 1)
        primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterEjercicio.EditValue), Month(filterPeriodoIni.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado Analítico del Ejercicio del Presupuesto de Egresos Detallado-LDF"
            .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .XrLabel1.Text = "(PESOS)"
            .lblTitulo.Text = "Clasificacion Funcional(Finalidad y Funcion)"
            '.lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Balance Presupuestario' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me
        'Dim ctrl As XRLabel
        'For Each prm As Parameter In reporte.Parameters
        '    ctrl = reporte.FindControl("lbl_" & prm.Name, False)
        '    AddHandler ctrl.PreviewClick, AddressOf CapturaNota
        '    AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        '    ctrl.Tag = prm
        'Next
        'ctrl = reporte.FindControl("lbl_prmTipo", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        'ctrl = reporte.FindControl("lbl_prmNaturaleza", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        'ctrl = reporte.FindControl("lbl_XrLabel18", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoIni.EditValue = Now
        filterPeriodoFin.EditValue = Now
        filterEjercicio.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Clasificacion Funcional(Finalidad y Funcion)"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Clasificacion Funcional(Finalidad y Funcion)"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Clasificacion Funcional(Finalidad y Funcion)"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub



    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("Aprobado")
        notas.Add("AmpRed")
        notas.Add("Modificado")
        notas.Add("Devengado")
        notas.Add("Pagado")
        notas.Add("Subejercicio")

        Dim excepciones As New List(Of String)()
        'excepciones.Add("12300")
        'excepciones.Add("12340")
        'excepciones.Add("12350")
        'excepciones.Add("12360")
        'excepciones.Add("12390")
        'excepciones.Add("12400")
        'excepciones.Add("12410")
        'excepciones.Add("12420")
        'excepciones.Add("12430")
        'excepciones.Add("12440")
        'excepciones.Add("12450")
        'excepciones.Add("12460")
        'excepciones.Add("12470")
        'excepciones.Add("12480")

        Dim frm As New Frm_Edit_NoteTable("Concepto", notas, ds, excepciones)
        frm.Text = "Clasificacion Funcional(Finalidad y Funcion)"
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Concepto") = dr("Concepto") Then
                        ds.Tables(0).Rows(j)("Aprobado") = dr("Aprobado")
                        ds.Tables(0).Rows(j)("AmpRed") = dr("AmpRed")
                        ds.Tables(0).Rows(j)("Modificado") = dr("Modificado")
                        ds.Tables(0).Rows(j)("Devengado") = dr("Devengado")
                        ds.Tables(0).Rows(j)("Pagado") = dr("Pagado")
                        ds.Tables(0).Rows(j)("Subejercicio") = dr("Subejercicio")
                        i += 1
                        Exit For
                    End If
                    i += 1
                Next
            Next
            reporte.CreateDocument()
        End If
    End Sub

    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub
End Class
