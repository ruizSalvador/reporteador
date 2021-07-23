Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_InformeEstudiosActuarialesLDF

    Public reporte As RPT_InformeEstudiosActuarialesLDF
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New RPT_InformeEstudiosActuarialesLDF()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim command As New SqlCommand("SP_Informes_Actuarias", conection)
        command.CommandType = CommandType.StoredProcedure
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_Informes_Actuarias")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_Informes_Actuarias"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = '" & "LDF Informes sobre estudio de Actuarias" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
        Dim ultimo As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe2.Time.Month, 1)
        primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Informe sobre Estudios Actuariales-LDF"
            '.lblRptDescripcionFiltrado.Text = "(PESOS)"
            '.lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            '.lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            '.lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            '.lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.XrLabel1.Text = "(CIFRAS NOMINALES)"
            '.lblTitulo.Text = ""
            '.lblSubtitulo.Text = ""
            '.XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='LDF Informes sobre estudio de Actuarias' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoDe2.EditValue = Now
        filterPeriodoAl.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Resultados de Egresos"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Resultados de Egresos"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Resultados de Egresos"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub



    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("Pensiones_y_Jubilaciones")
        notas.Add("Salud")
        notas.Add("Riesgos_de_trabajo")
        notas.Add("Invalidez_y_vida")
        notas.Add("Otras_prestaciones_sociales")


        Dim excepciones As New List(Of String)()

        Dim frm As New Frm_Edit_NoteTable("Concepto", notas, ds, excepciones)
        frm.Text = "Informe Estudios Actuariales"
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Concepto") = dr("Concepto") Then
                        ds.Tables(0).Rows(j)("Pensiones_y_Jubilaciones") = dr("Pensiones_y_Jubilaciones")
                        ds.Tables(0).Rows(j)("Salud") = dr("Salud")
                        ds.Tables(0).Rows(j)("Riesgos_de_trabajo") = dr("Riesgos_de_trabajo")
                        ds.Tables(0).Rows(j)("Invalidez_y_vida") = dr("Invalidez_y_vida")
                        ds.Tables(0).Rows(j)("Otras_prestaciones_sociales") = dr("Otras_prestaciones_sociales")
                        i += 1
                        Exit For
                    End If
                    i += 1
                Next
            Next
            reporte.CreateDocument()
        End If
    End Sub
End Class
