Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonioPorRangoV2



    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        Dim Primer As String
        Dim Ultimo As String

        Primer = "01" & "/" & Format((CDate(TEPeriodoInicio.EditValue)).Month, "0#") & "/" & (CDate(TEEjercicioInicio.EditValue)).Year
        Ultimo = Date.DaysInMonth((CDate(filterPeriodoAl.EditValue)).Year, (CDate(filterPeriodoDe.EditValue)).Month) & "/" & Format((CDate(filterPeriodoDe.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year


        Dim reporte As New RPT_VariacionesHaciendaPublicaPatrimonioV2()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SP As String

        SP = "SP_RPT_K2_VariacionesHaciendaPublicaPatrimonioPorRangoV2"

        Dim conection As New SqlConnection(cnnString)
        Dim prmEjercicio2 As New SqlParameter("ejercicio2", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo2 As New SqlParameter("mes2", Month(filterPeriodoDe.EditValue))
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(TEEjercicioInicio.EditValue))
        Dim prmPeriodo As New SqlParameter("mes", Month(TEPeriodoInicio.EditValue))
        Dim prmMiles As New SqlParameter("miles", ChkMiles.Checked)
        Dim command As New SqlCommand(SP, conection)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio2)
        command.Parameters.Add(prmPeriodo2)
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        command.Parameters.Add(prmMiles)
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = SP

        '******* Firmas ******
        Dim adapterC As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado de Variación en la Hacienda Pública Por Periodos' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
            .XrLabel1.Visible = ChkMiles.Checked
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Variación en la Hacienda Pública"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "Del " & Primer & " al " & Ultimo
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado de Variación en la Hacienda Pública Por Periodos' ", New SqlConnection(cnnString))
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
        TEEjercicioInicio.EditValue = Now
        TEPeriodoInicio.EditValue = Now


    End Sub


End Class
