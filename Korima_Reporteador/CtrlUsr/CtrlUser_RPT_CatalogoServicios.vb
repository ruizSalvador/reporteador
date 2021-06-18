Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_CatalogoServicios

    Function AsignaTipo(Tipo As String) As Integer
        Select Case Tipo
            Case "Servicios"
                Return 3
            Case "Honorarios"
                Return 4
            Case "Obra"
                Return 5
            Case "Deuda"
                Return 6
            Case "Subsidios"
                Return 7
            Case Else
                Return 0
        End Select

    End Function

    Function AsignaOrden() As String
        If RbDescripcion.Checked = True Then
            Return "DescripcionTipoServicio"
        End If
        If RbPartida.Checked = True Then
            Return "IdPartida"
        End If
    End Function

    Function AsignaPartida(Partida As String) As Integer
        If Partida = "" Then
            Return 0
        Else
            Return Convert.ToInt32(Partida)
        End If
    End Function


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If PartidaDe.Text = "" And PartidaAl.Text <> "" Then
            ErrorProvider1.SetError(PartidaDe, "Debe indicar el rango.")
            Exit Sub
        End If
        If PartidaAl.Text = "" And PartidaDe.Text <> "" Then
            ErrorProvider1.SetError(PartidaAl, "Debe indicar el rango.")
            Exit Sub
        End If

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_CatalogoServicios
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_CatalogoServicios", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@PartidaInicial", AsignaPartida(PartidaDe.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@PartidaFinal", AsignaPartida(PartidaAl.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@Tipo", AsignaTipo(CmbtTipoProveedor.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@Orden", AsignaOrden()))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_CatalogoServicios")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_CatalogoServicios"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Catálogo de servicios registrados en el sistema"
            .lblRptNombreReporte.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "Al día " + Date.Now.ToString("dd/MM/yyyy")
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Catálogo de servicios registrados en el sistema' ", New SqlConnection(cnnString))
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
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With PartidaDe.Properties
            .DataSource = ObjTempSQL2.List("", 0, "VW_RPT_K2_PartidasServicios", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With PartidaAl.Properties
            .DataSource = ObjTempSQL1.List("", 0, "VW_RPT_K2_PartidasServicios", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub PartidaDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles PartidaDe.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With PartidaDe.Properties
            .DataSource = ObjTempSQL2.List("", 0, "VW_RPT_K2_PartidasServicios", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub PartidaAl_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles PartidaAl.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With PartidaAl.Properties
            .DataSource = ObjTempSQL2.List("", 0, "VW_RPT_K2_PartidasServicios", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        PartidaDe.Properties.DataSource = Nothing
        PartidaDe.Properties.NullText = ""

    End Sub
    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        PartidaAl.Properties.DataSource = Nothing
        PartidaAl.Properties.NullText = ""
    End Sub
End Class