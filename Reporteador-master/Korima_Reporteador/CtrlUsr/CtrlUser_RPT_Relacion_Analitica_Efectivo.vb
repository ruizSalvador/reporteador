Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.Drawing.Imaging

Public Class CtrlUser_RPT_Relacion_Analitica_Efectivo

    Dim reporte As RPT_Relacion_Analitica_Efectivo

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
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        'Dim reporte = New Object()

        '--Agregado para SP
        Dim SQLConexion As SqlConnection
        Dim SP As String = "SP_RPT_Relacion_Analitica_Efectivo_ISAF"
        reporte = New RPT_Relacion_Analitica_Efectivo()

        Dim printTool As New ReportPrintTool(reporte)
        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@MesInicio", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MesFin", Month(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoEjerc.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@Miles", CheckBox1.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", CheckBox2.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))

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
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Relacion Analitica del Efectivo ISAF' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
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
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoEjerc.EditValue), Month(filterPeriodoDe.EditValue), 1))


        With reporte
            .XrLabel5.Visible = CheckBox1.Checked
            .XrPageBreak1.Visible = CheckBox2.Checked
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Relación Analítica del Efectivo"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Periodo de " & MesLetra(filterPeriodoDe.EditValue.Month) & " del " & filterPeriodoDe.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoAl.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString
            '.lblFechaRango.Text = "Del 01/01/" + filterPeriodoEjerc.Time.Year.ToString + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy") '"Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            '.XrLabel2.Text = filterPeriodoEjerc.Text
            '.XrLabel3.Text = Convert.ToInt16(filterPeriodoEjerc.Text) - 1
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Relacion Analitica del Efectivo ISAF' ", New SqlConnection(cnnString))
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
        'filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
        filterPeriodoEjerc.EditValue = Now
    End Sub
End Class
