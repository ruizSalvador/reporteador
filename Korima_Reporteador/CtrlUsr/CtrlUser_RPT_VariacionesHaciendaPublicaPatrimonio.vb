Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonio
    


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        Dim Primer As String
        Dim Ultimo As String


        Primer = "01" & "/" & Format((CDate(filterPeriodoDe.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year
        Ultimo = Date.DaysInMonth((CDate(filterPeriodoAl.EditValue)).Year, (CDate(filterPeriodoDe.EditValue)).Month) & "/" & Format((CDate(filterPeriodoDe.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year


        Dim reporte As New RPT_VariacionesHaciendaPublicaPatrimonio()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SP As String

        If ChkMiles.Checked = True Then
            SP = "SP_RPT_K2_VariacionesHaciendaPublicaPatrimonio"
            reporte.XrLabel1.Visible = True
        Else
            SP = "SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioSinMiles"
            reporte.XrLabel1.Visible = False
        End If


        Dim conection As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo As New SqlParameter("mes", Month(filterPeriodoDe.EditValue))
        Dim command As New SqlCommand(SP, conection)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = SP

        '******* Firmas ******
        Dim adapterC As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Variaciones en la Hacienda Pública / Patrimonio' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Variaciones en la Hacienda Pública/Patrimonio"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "Del " & Primer & " al " & Ultimo
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Variaciones en la Hacienda Pública / Patrimonio' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now


    End Sub


End Class
