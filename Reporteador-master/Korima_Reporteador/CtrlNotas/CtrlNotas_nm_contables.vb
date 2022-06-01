Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient



Public Class CtrlNotas_nm_contables
    Dim reporte As NOTA_nm_contables
    Public notas1 As New Dictionary(Of String, String)



    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New NOTA_nm_contables()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection2 As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo As New SqlParameter("periodo", Month(filterPeriodoDe.EditValue))
        Dim prmMiles As New SqlParameter("Miles", chkMiles.Checked)
        Dim command As New SqlCommand("sp_nota_nm_contables", conection2)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        command.Parameters.Add(prmMiles)
        Dim adapter2 As New SqlDataAdapter(command)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapter2.Fill(dsB, "sp_nota_nm_contables")
        reporte.DataSource = dsB

        reporte.DataAdapter = adapter2
        reporte.DataMember = "sp_nota_nm_contables"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Notas Contables' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Notas de Memoria"
            .lblRptDescripcionFiltrado.Text = "Al " & lastDay.AddMonths(1).AddDays(-1)
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            If chkMiles.Checked = True Then
                .XrLabel1.Text = "(En miles de pesos)"
            Else
                .XrLabel1.Text = ""
            End If
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = "Notas Contables"
            '.lblSubtitulo.Text = "Notas Contables"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Notas Contables' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me

        Dim ctrl As XRLabel
        For Each prm As Parameter In reporte.Parameters
            ctrl = reporte.FindControl("lbl_" & prm.Name, False)
            AddHandler ctrl.PreviewClick, AddressOf CapturaNota
            AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
            ctrl.Tag = prm
        Next
        ctrl = reporte.FindControl("XrLabel2", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp

        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub


End Class
