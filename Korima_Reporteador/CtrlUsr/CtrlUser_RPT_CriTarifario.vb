Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_CriTarifario

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If filterPeriodoDe.DateTime.Year <> filterPeriodoAl.DateTime.Year Then
            ErrorProvider1.SetError(filterPeriodoAl, "El periodo de tiempo tiene que pertenecer al mismo ejercicio")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_CriTarifario
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
        Dim SQLComando As New SqlCommand("SP_RPT_CriTarifario", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
        If ComboBox1.Text = "Por Recaudar" Then
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", 1))
        End If
        If ComboBox1.Text = "Recaudados" Then
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", 2))
        End If
        If ComboBox1.Text = "Devoluciones y Compensaciones" Then
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", 3))
        End If
        If ComboBox1.Text = "Todos" Then
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", 4))
        End If
        If ComboBox1.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", 0))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@TarifarioInicio", IIf(FilterDelTarifario.Properties.KeyValue Is Nothing, 1, FilterDelTarifario.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@TarifarioFin", IIf(FilterAlTarifario.Properties.KeyValue Is Nothing, 9999, FilterAlTarifario.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MostrarCancelados", ChkMuestraCancelado.Checked))

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_CriTarifario")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_CriTarifario"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte


            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte Tarifario de Ingresos por Cri-Tarifario"
            .lblTitulo.Text = "Ingresos: " + ComboBox1.Text
            .lblRptDescripcionFiltrado.Text = "Movimientos del:  " + filterPeriodoDe.Text + "   al:  " + filterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Tarifario Ingresos' ", New SqlConnection(cnnString))
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
        ComboBox1.Text = "Todos"
        FilterDelTarifario.Properties.NullText = ""
        FilterAlTarifario.Properties.NullText = ""
    End Sub
    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        ComboBox1.SelectedIndex = -1
    End Sub


    Private Sub filterDelTarifario_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterDelTarifario.GotFocus
        '
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With FilterDelTarifario.Properties
            .DataSource = ObjTempSQL.List("YEAR(FechaVigencia) =" & Year(filterPeriodoDe.EditValue), 0, "T_Tarifario", " Order by IdTarifa ")
            .DisplayMember = "DecripcionTarifario"
            .ValueMember = "IdTarifa"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterAlTarifario_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAlTarifario.GotFocus
        '
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With FilterAlTarifario.Properties
            .DataSource = ObjTempSQL.List("YEAR(FechaVigencia) =" & Year(filterPeriodoDe.EditValue), 0, "T_Tarifario", " Order by IdTarifa ")
            .DisplayMember = "DecripcionTarifario"
            .ValueMember = "IdTarifa"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        FilterDelTarifario.Properties.DataSource = Nothing
        FilterDelTarifario.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        FilterAlTarifario.Properties.DataSource = Nothing
        FilterAlTarifario.Properties.NullText = ""
    End Sub


    Private Sub ChkMuestraNulos_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkMuestraCancelado.CheckedChanged

    End Sub

    Private Sub filterPeriodoDe_TextChanged(sender As System.Object, e As System.EventArgs) Handles filterPeriodoDe.TextChanged
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With FilterDelTarifario.Properties
            .DataSource = ObjTempSQL.List("YEAR(FechaVigencia) =" & Year(filterPeriodoDe.EditValue), 0, "T_Tarifario", " Order by IdTarifa ")
            .DisplayMember = "DecripcionTarifario"
            .ValueMember = "IdTarifa"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        ' Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With FilterAlTarifario.Properties
            .DataSource = ObjTempSQL.List("YEAR(FechaVigencia) =" & Year(filterPeriodoDe.EditValue), 0, "T_Tarifario", " Order by IdTarifa ")
            .DisplayMember = "DecripcionTarifario"
            .ValueMember = "IdTarifa"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
End Class