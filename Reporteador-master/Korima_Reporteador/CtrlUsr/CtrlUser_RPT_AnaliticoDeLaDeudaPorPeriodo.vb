Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_AnaliticoDeLaDeudaPorPeriodo

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
        Dim reporte As New RPT_AnaliticoDeLaDeudaPorPeriodo
        Dim printTool As New DevExpress.XtraReports.UI.ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SP As String
        SP = "SP_RPT_AnaliticoDeLaDeudaPublicaPorPeriodo"
        reporte.XrLabel1.Visible = ChkMiles.Checked


        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN

        SQLComando.Parameters.Add(New SqlParameter("@mesInicio", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@mesFin", Month(filterSegMes.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraVacios", ChkMuestraNulos.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Miles", ChkMiles.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SP

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte


        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Analítico de la Deuda Pública y Otros Pasivos Por Periodo' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        Dim grupoOrdenamiento As New DevExpress.XtraReports.UI.GroupField("Ordenamiento")
        Dim grupoDeudaPublica As New DevExpress.XtraReports.UI.GroupField("DeudaPublica")

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre

            .lblRptNombreReporte.Text = "Estado Analítico de la Deuda y Otros Pasivos Por Periodo"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            Dim segundo As DateTime = New DateTime()
            If filterSegMes.SelectedText = "02" Then

                segundo = New DateTime(filterPeriodoAl.Time.Year, filterSegMes.Time.Month, 28)
            ElseIf filterSegMes.SelectedText = "04" Or filterSegMes.SelectedText = "06" Or filterSegMes.SelectedText = "09" Or filterSegMes.SelectedText = "11" Then
                segundo = New DateTime(filterPeriodoAl.Time.Year, filterSegMes.Time.Month, 30)
            ElseIf filterSegMes.SelectedText = "01" Or filterSegMes.SelectedText = "03" Or filterSegMes.SelectedText = "05" Or filterSegMes.SelectedText = "07" Or filterSegMes.SelectedText = "08" Or filterSegMes.SelectedText = "10" Or filterSegMes.SelectedText = "12" Then
                segundo = New DateTime(filterPeriodoAl.Time.Year, filterSegMes.Time.Month, 31)
            End If

            ' Dim segundo As Date = New DateTime(filterPeriodoAl.Time.Year, filterSegMes.Time.Month, 31)
            Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
            Dim ultimo As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
            .lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
            .lblRptDescripcionFiltrado.Text = "Del 01/" + filterPeriodoDe.Time.Month.ToString() + "/" + filterPeriodoAl.Time.Year.ToString() + " al " + segundo.ToString("dd/MM/yyyy") 'ultimo.ToString("dd/MM/yyyy") "Periodo: al " & ultimo.Day.ToString & " de " & MesLetra(Month(filterPeriodoDe.EditValue)) & " Del " & Year(filterPeriodoAl.EditValue).ToString
            .label16.Text = .label16.Text & " Periodo " & Month(filterPeriodoDe.EditValue).ToString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Analítico de la Deuda Pública y Otros Pasivos' ", New SqlConnection(cnnString))
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
        filterSegMes.EditValue = Now
    End Sub

    Private Sub LabelControl4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LabelControl4.Click

    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkMuestraNulos.CheckedChanged

    End Sub

    Private Sub filterPeriodoDe_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterPeriodoDe.EditValueChanged

    End Sub
End Class