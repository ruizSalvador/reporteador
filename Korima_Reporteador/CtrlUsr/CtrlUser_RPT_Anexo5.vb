Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Anexo5
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
        Dim reporte As Object

        If FilterCapitulo.EditValue = 2000 Or FilterCapitulo.EditValue = 3000 Or FilterCapitulo.EditValue = 5000 Or FilterCapitulo.EditValue = 6000 Then

            reporte = New RPT_Anexo5_1
        ElseIf FilterCapitulo.EditValue = 1000 Or FilterCapitulo.EditValue = 4000 Then
            reporte = New RPT_Anexo5_2
        Else : reporte = New RPT_Anexo5_3
        End If

        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        Dim x As String = FilterFF.Text
        Dim y As String = FilterFF.EditValue

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("RPT_SP_Anexo5", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        SQLComando.Parameters.Add(New SqlParameter("@Fecha1", Convert.ToDateTime(filterPeriodoDe.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@Fecha2", Convert.ToDateTime(filterPeriodoAl.Text)))
        'SQLComando.Parameters.Add(New SqlParameter("@IdFF", IIf(FilterFF.Text = "", 0, Convert.ToInt32(FilterFF.EditValue))))
        If FilterFF.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdFF", Convert.ToInt32(FilterFF.EditValue)))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@IdFF", 0))
        End If
        If FilterCapitulo.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", Convert.ToInt32(FilterCapitulo.EditValue)))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", 0))
        End If


            SQLComando.CommandTimeout = 0

            Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

            Dim ds As New DataSet()
            ds.EnforceConstraints = False
            adapter.Fill(ds, "RPT_SP_Anexo5")
            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "RPT_SP_Anexo5"

            'Firmas 
            Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Anexo 5' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
            Dim dsC As New DataSet()
            dsC.EnforceConstraints = False
            adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
            reporte.Firmas.ReportSource.DataSource = dsC
            reporte.Firmas.ReportSource.DataAdapter = adapterC
            reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

            Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
            Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
            pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
            '--- Llenar datos del ente
            Dim total As Double
            total = 0
            With reporte
                .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "PARTICIPACIONES FEDERALES A MUNICIPIOS (PARTICIPACIONES A MUN)"
                .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
                .lblRptDescripcionFiltrado.Text = "Movimientos del: " & filterPeriodoDe.Text & " al: " & filterPeriodoAl.Text
                '.lblSubtitulo.Text = FilterCuenta.Text
                .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
                .lblTitulo.Text = ""

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Anexo 5' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now
        FilterFF.EditValue = ""

        '--Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterFF.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        FilterFF.Properties.DataSource = Nothing
        FilterFF.Properties.NullText = ""
        FilterFF.EditValue = ""
        FilterFF.Text = ""
    End Sub

    Private Sub FilterFF_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterFF.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterFF.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCapitulo_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCapitulo.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCuentaAfectable_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        FilterFF.Enabled = False
        SimpleButton4.Enabled = False
    End Sub

    Private Sub btnFF_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub btnCap_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCap.Click
        FilterCapitulo.Properties.DataSource = Nothing
        FilterCapitulo.Properties.NullText = ""
        FilterCapitulo.EditValue = ""
        FilterCapitulo.Text = ""
    End Sub
End Class