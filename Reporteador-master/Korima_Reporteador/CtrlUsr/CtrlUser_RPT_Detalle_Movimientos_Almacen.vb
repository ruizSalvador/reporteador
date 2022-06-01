Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Detalle_Movimientos_Almacen
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

    Public Function GetReport() As Object
        Dim rpt As XtraReport

        If cbTipoMov.Text = "Entradas" Then
            rpt = New RPT_Detalle_Movimientos_Almacen_Entradas()
        ElseIf cbTipoMov.Text = "Salidas" Then
            rpt = New RPT_Detalle_Movimientos_Almacen_Salidas()
        ElseIf cbTipoMov.Text = "Ajuste al costo" Then
            rpt = New RPT_Detalle_Movimientos_Almacen_Ajustes()
        End If

        Return rpt

    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte = New Object()
        reporte = GetReport()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        Dim x As String = FilterAlmacen.Text
        Dim y As String = FilterAlmacen.EditValue

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_Detalle_Movimientos_Almacen", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure


        SQLComando.Parameters.Add(New SqlParameter("@FechaIni", Convert.ToDateTime(filterPeriodoDe.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", Convert.ToDateTime(filterPeriodoAl.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@IdAlmacen", IIf(FilterAlmacen.Text = "", DBNull.Value, FilterAlmacen.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@TipoMov", filterPeriodoAl.Text))
        If cbTipoMov.Text = "Entradas" Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoMov", "E"))
        ElseIf cbTipoMov.Text = "Salidas" Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoMov", "S"))
        ElseIf cbTipoMov.Text = "Ajuste al costo" Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoMov", "A"))
        End If


        If nupFolio1.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Folio1", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@Folio1", Convert.ToInt32(nupFolio1.Text)))
        End If

        If nupFolio2.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Folio2", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@Folio2", Convert.ToInt32(nupFolio2.Text)))
        End If

        'SQLComando.Parameters.Add(New SqlParameter("@Folio1", IIf(cbFolio1.Text = "", DBNull.Value, Convert.ToInt32(cbFolio1.Text))))
        'SQLComando.Parameters.Add(New SqlParameter("@Folio2", IIf(cbFolio2.Text = "", DBNull.Value, Convert.ToInt32(cbFolio2.Text))))

        SQLComando.CommandTimeout = 0

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_Detalle_Movimientos_Almacen")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_Detalle_Movimientos_Almacen"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Detalle de Movimientos de Almacén" 'cbTipoMov.Text & " de Almacén"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "Movimientos del: " & filterPeriodoDe.Text & " al: " & filterPeriodoAl.Text
            .XrLabel1.Text = FilterAlmacen.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .lblTitulo.Text = "Tipo de Movimiento: " & cbTipoMov.Text

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Detalle de Movimientos de Almacén' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now
        FilterAlmacen.EditValue = ""
        cbTipoMov.SelectedIndex = 0

        '--Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterAlmacen.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Almacenes", " Order by IdAlmacen ")
            .DisplayMember = "Almacen"
            .ValueMember = "IdAlmacen"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        FilterAlmacen.ItemIndex = 0

    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        FilterAlmacen.Properties.DataSource = Nothing
        FilterAlmacen.Properties.NullText = ""
        FilterAlmacen.EditValue = ""
        FilterAlmacen.Text = ""
    End Sub

    Private Sub FilterAlmacen_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAlmacen.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterAlmacen.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Almacenes", " Order by IdAlmacen ")
            .DisplayMember = "Almacen"
            .ValueMember = "IdAlmacen"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboSubClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboSubClases.GotFocus
        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With ComboSubClases.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
        '    .DisplayMember = "IdPartida"
        '    .ValueMember = "IdPartida"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs)
        ComboSubClases.Properties.DataSource = Nothing
        ComboSubClases.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton7.Click
        ComboSubClases.Properties.DataSource = Nothing
        ComboSubClases.Properties.NullText = ""
    End Sub

    Private Sub btnClearFolios_Click(sender As System.Object, e As System.EventArgs) Handles btnClearFolios.Click
        nupFolio1.Value = 0
        nupFolio2.Value = 0
    End Sub
End Class