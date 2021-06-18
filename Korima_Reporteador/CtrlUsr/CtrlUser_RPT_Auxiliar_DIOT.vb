Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Auxiliar_DIOT
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
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterMes.Time = Now
        FilterAño.Time = Now

        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With FilterProveedor.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by CLAVE ")
        '    .DisplayMember = "RazonSocial"
        '    .ValueMember = "IdProveedor"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With srchFilterCuenta.Properties
            .DataSource = ObjTempSQL3.List("", 0, "C_Proveedores", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Auxiliar_DIOT
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
        Dim SQLComando As New SqlCommand("SP_RPT_K2_Auxiliar_DIOT", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN

        SQLComando.Parameters.Add(New SqlParameter("@mes", filterMes.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterAño.Time.Year))
        If srchFilterCuenta.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdProv", srchFilterCuenta.EditValue))
        End If

        If srchFilterCuenta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdProv", 0))
        End If
        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_Auxiliar_DIOT")
        SQLComando.Dispose()
        SQLConexion.Close()
        '------------------------------
        'Dim adapter As SqlClient.SqlDataAdapter
        'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_EstadoOrigenTXT WHERE Mes= " + Mes + "AND Year=" + Año + " Order By CuentaContable ", cnnString)
        'Dim ds As New DataSet()
        'ds.EnforceConstraints = False
        'adapter.FillSchema(ds, SchemaType.Source, "VW_RPT_K2_EstadoOrigenTXT")
        'adapter.Fill(ds, "VW_RPT_K2_EstadoOrigenTXT")


        ds.EnforceConstraints = False
        'adapter.Fill(ds, "SP_RPT_K2_Comprobacion_DIOT")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_Auxiliar_DIOT"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Auxiliar DIOT por proveedor"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = MesLetra(filterMes.Text) + " del Año " + FilterAño.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Facturas Recibidas' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProveedor.GotFocus
        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With FilterProveedor.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by CLAVE ")
        '    .DisplayMember = "RazonSocial"
        '    .ValueMember = "IdProveedor"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With
    End Sub

    Private Sub srchFilterCuenta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchFilterCuenta.GotFocus

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With srchFilterCuenta.Properties
            .DataSource = ObjTempSQL3.List("", 0, "C_Proveedores", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterProveedor.Properties.DataSource = Nothing
        FilterProveedor.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton1_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton1.Click
        srchFilterCuenta.Properties.DataSource = Nothing
        srchFilterCuenta.Properties.NullText = ""
    End Sub
End Class