Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_LibroDiario
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
        If ValidaMesAnio() Then
            Dim reporte As New RPT_LibroDiario
            Dim printTool As New ReportPrintTool(reporte)

            '--- Armado de filtro
            Dim FiltroSQL As String = ""

            FiltroSQL &= "Where Fecha BETWEEN '" & filterPeriodoDe.Text & "' and '" & filterPeriodoAl.Text & "' and Folio <> 'E0' And Folio <> 'D0' And Folio <> 'I0'"

            'If filterProveedor.Text <> "" Then
            '    FiltroSQL &= " WHERE RazonSocial = '" & filterProveedor.Properties.KeyValue & "'"
            'End If

            'If CheckEdit1.Checked = False Then
            '    FiltroSQL &= " WHERE ((Recibido <> 0) or (Cancelado <> 0) or (Pedido <> 0))"
            'End If
            ''''''''''''''''''''''''''''''''
            Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
            Dim SQLComando As New SqlCommand("SELECT * FROM VW_RPT_K2_LibroDiario " & FiltroSQL & " ORDER BY IDPoliza, IdDpoliza ", SQLConexion)
            SQLComando.CommandType = CommandType.Text
            SQLComando.CommandTimeout = 0
            Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)
            ''''''''''''''''''''''''''''''''''

            'Dim adapter As SqlClient.SqlDataAdapter
            'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_LibroDiario " & FiltroSQL & " ORDER BY IDPoliza, IdDpoliza ", cnnString)
            Dim ds As New DataSet()
            ds.EnforceConstraints = False
            adapter.Fill(ds, "VW_RPT_K2_LibroDiario")
            'adapter.FillSchema(ds, SchemaType.Source)

            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "VW_RPT_K2_LibroDiario"

            Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
            Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
            pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
            '--- Llenar datos del ente
            With reporte
                .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre

                .lblRptNombreReporte.Text = "Libro Diario"
                .lblRptDescripcionFiltrado.Text = ""
                .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
                .lblRptDescripcionFiltrado.Text = "DEL " & filterPeriodoDe.DateTime.Day.ToString & " AL " & filterPeriodoAl.DateTime.Day.ToString & " DE " & MesLetra(filterPeriodoDe.DateTime.Month.ToString) & " DEL " & filterPeriodoDe.DateTime.Year.ToString
                .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Libro Diario' ", New SqlConnection(cnnString))
                cmd.CommandTimeout = 99999
                cmd.Connection.Open()
                Dim reader = cmd.ExecuteScalar()
                cmd.Connection.Close()
                .XrLblIso.Text = reader
            End With

            PrintControl1.PrintingSystem = reporte.PrintingSystem

            reporte.CreateDocument()
        Else
            ErrorProvider1.SetError(filterPeriodoAl, "El periodo tiene que ser del mismo mes y año.")
            SplitContainerControl1.Collapsed = False
        End If
        Me.Cursor = Cursors.Default
    End Sub
    Private Function ValidaMesAnio() As Boolean
        If filterPeriodoAl.DateTime.Month = filterPeriodoDe.DateTime.Month And filterPeriodoAl.DateTime.Year = filterPeriodoDe.DateTime.Year Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now

        '---Llenar listas
        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With filterProveedor.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
        '    .DisplayMember = "RazonSocial"
        '    .ValueMember = "RazonSocial" '"IdProveedor"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

    End Sub

    'Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
    '    filterProveedor.Properties.DataSource = Nothing
    '    filterProveedor.Properties.NullText = ""
    '    CheckEdit1.Enabled = True
    '    CheckEdit1.Checked = True
    'End Sub

    'Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs)

    '    Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '    With filterProveedor.Properties
    '        .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
    '        .DisplayMember = "RazonSocial"
    '        .ValueMember = "RazonSocial" '"IdProveedor"
    '        .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '        .NullText = ""
    '        .ShowHeader = True
    '    End With
    'End Sub

    'Private Sub filterProveedor_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
    '    CheckEdit1.Enabled = False
    '    CheckEdit1.Checked = True
    'End Sub


End Class