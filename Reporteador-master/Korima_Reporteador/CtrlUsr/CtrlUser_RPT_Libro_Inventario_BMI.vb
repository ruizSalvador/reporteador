Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Libro_Inventario_BMI
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
        ErrorProvider1.Clear()

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Libro_Inventario_BMI
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        ErrorProvider1.Clear()







        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@TipoBien", FilterCuenta.Text.Trim))
        SQLComando.Parameters.Add(New SqlParameter("@EjercicioInicio", filterPeriodoAl.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@mesInicio", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@EjercicioFin", filterEjercAl.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@mesFin", FilterPerAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@EstatusBien", cmbEstatusBien.Text.Trim))

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_Libro_Inventario_Bienes_Muebles_Inmuebles"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Libro de Inventarios de Bienes Muebles e Inmuebles' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        With reporte.XrSubreport1.ReportSource
            .DataSource = dsC
            .DataAdapter = adapterC
            .DataMember = "VW_RPT_K2_Firmas2"
        End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        Dim FirstDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))
        Dim lastDay As DateTime = (New DateTime(Year(filterEjercAl.EditValue), Month(FilterPerAl.EditValue), 1))
        total = 0
  
        With reporte

            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Libro de Inventarios de Bienes"
            .lblTitulo.Text = "Muebles e Inmuebles"
            'If filterPeriodoAl.Time.Year = Now.Year Then
            '.lblRptDescripcionFiltrado.Text = "Al " + lastDay.AddMonths(1).AddDays(-1).Day.ToString + " de " + MesLetra(filterPeriodoDe.Time.Month) + " de " + filterPeriodoAl.Text
            '.lblRptDescripcionFiltrado.Text = "Del " + FirstDay.AddMonths(1).AddDays(-1.ToString("dd/MM/yyyy") + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy") 'segundo.ToString("dd/MM/yyyy")
            '.lblRptDescripcionFiltrado.Text = "De " + filterPeriodoDe.Time.Month.ToString + "-" + filterPeriodoAl.Time.Year.ToString + " Al " + FilterPerAl.Time.Month.ToString + "-" + filterEjercAl.Time.Year.ToString
            .lblRptDescripcionFiltrado.Text = "Del 1/" + filterPeriodoDe.Text + "/" + filterPeriodoAl.Text + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy")


            'Else
            '.lblRptDescripcionFiltrado.Text = "Al "31 de Diciembre" de " + filterPeriodoAl.Text  '"Movimientos del Ejercicio " + filterPeriodoAl.Text + " Período " + filterPeriodoDe.Text
            'End If

            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Libro de Inventarios de Bienes Muebles e Inmuebles' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoBien ", " Order by IdTipoBien ")
            .DisplayMember = "DescripcionTipoBien"
            .ValueMember = "IdTipoBien"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.Time = Now
        filterPeriodoAl.Time = Now
        FilterPerAl.Time = Now
        filterEjercAl.Time = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoBien ", " Order by IdTipoBien ")
            .DisplayMember = "DescripcionTipoBien"
            .ValueMember = "IdTipoBien"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterCuenta.EditValueChanged
        '
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        cmbEstatusBien.Text = Nothing
    End Sub

    Private Sub filterPeriodoDe_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterPeriodoDe.EditValueChanged

    End Sub

    Private Sub LabelControl4_Click(sender As System.Object, e As System.EventArgs) Handles LabelControl4.Click

    End Sub

    Private Sub TimeEdit2_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterEjercAl.EditValueChanged

    End Sub
End Class