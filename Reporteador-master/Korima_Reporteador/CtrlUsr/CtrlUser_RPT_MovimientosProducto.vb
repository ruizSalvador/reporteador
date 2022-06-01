Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_MovimientosProducto
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
        Dim reporte As New RPT_MovimientosProducto
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        Dim x As String = FilterAlmacen.Text
        Dim y As String = FilterAlmacen.EditValue

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_MovimientosProducto", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        SQLComando.Parameters.Add(New SqlParameter("@IdAlmacen", IIf(FilterAlmacen.Text = "", DBNull.Value, FilterAlmacen.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaIni", Convert.ToDateTime(filterPeriodoDe.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", Convert.ToDateTime(filterPeriodoAl.Text)))


        Dim win As String
        Dim win2 As String
        Dim win3 As String
        win = FilterAdqui.Text


        win2 = LisEntradas.Text


        win3 = ListaSalidas.Text


        Dim Dato As String
        Dim Dato2 As String
        Dato = FilterAdqui.Properties.KeyValue
        Dato = FilterAdqui.Properties.KeyValue

        Dato2 = FilterAdqui.Properties.NullText








        'If FilterAdqui.Text = "" Then
        ' SQLComando.Parameters.Add(New SqlParameter("@CodigoInterno", IIf(CodigoInterno.Text = "", DBNull.Value, CodigoInterno.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@CodigoInterno", IIf(CodigoInterno.Text = "", DBNull.Value, FilterAdqui.Text)))
        'Else
        ' SQLComando.Parameters.Add(New SqlParameter("@CodigoInterno", IIf(CodigoInterno.Text = "", DBNull.Value, FilterAdqui.EditValue)))

        ' SQLComando.Parameters.Add(New SqlParameter("@CodigoInterno", FilterAdqui.))

        SQLComando.Parameters.Add(New SqlParameter("@CodigoInterno", FilterAdqui.Text))
        SQLComando.Parameters.Add(New SqlParameter("@IdCodigoProducto", TextBoxIdProducto.Text))
        SQLComando.Parameters.Add(New SqlParameter("@IdGrupo", TextBoxGrupo.Text))
        SQLComando.Parameters.Add(New SqlParameter("@IdSubGrupo", TextBoxSubgrupo.Text))
        ' End If


        If RadioButtonEntradas.Checked = True Then

            If LisEntradas.Text = "" Then
                SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", "TodasLasEntradas"))
            Else
                SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", LisEntradas.Text))
            End If


        ElseIf RadioButtonSalidas.Checked = True Then

            If ListaSalidas.Text = "" Then
                SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", "TodasLasSalidas"))
            Else
                SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", ListaSalidas.Text))
            End If


        ElseIf RadioButtonAmbos.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", "0"))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@TipoMovimiento", IIf(CodigoInterno.Text = "", DBNull.Value, CodigoInterno.EditValue)))

        End If





        SQLComando.CommandTimeout = 0

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_MovimientosProducto")
        reporte.DataSource = ds

        Dim DescripcionProducto As String

        Try
            DescripcionProducto = ds.Tables(0).Rows(0)(7).ToString()
        Catch ex As Exception


        End Try

        ' DescripcionProducto = DescripcionProducto.Substring(0, 20)


        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_MovimientosProducto"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte



            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Movimientos por Producto"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = "Movimientos del: " & filterPeriodoDe.Text & " al: " & filterPeriodoAl.Text & " Código : " & TextBoxCodigoCambs.Text & " Id : " & TextBoxIdProducto.Text & " Grupo : " & TextBoxGrupo.Text & " Subgrupo : " & TextBoxSubgrupo.Text
            .XrLabel4.Text = ""
            '.lblRptDescripcionFiltrado.Text = "Movimientos del: " & filterPeriodoDe.Text & " al: " & filterPeriodoAl.Text

            .XrLabel1.Text = FilterAdqui.Text
            .XrLabel4.Text = FilterAlmacen.Text


            If ChekEntradas.Checked = True Then
                .XrLabel4.Text = "ENTRADA  " & " " & LisEntradas.Text & " " & FilterAlmacen.Text
            ElseIf ChecSalidas.Checked = True Then
                .XrLabel4.Text = "SALIDA " & " " & ListaSalidas.Text & " " & FilterAlmacen.Text
            ElseIf CheckAmbos.Checked = True Then
                .XrLabel4.Text = "Todos los movimientos" & " " & FilterAlmacen.Text

            End If

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            '.lblTitulo.Text = ""

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Movimientos por Producto' ", New SqlConnection(cnnString))
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




    Private Sub FilterAdqui_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAdqui.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterAdqui.Properties
            .DataSource = ObjTempSQL2.List("IdGrupo = 2", 0, " C_Maestro ", "Order by DescripcionGenerica ")
            .DisplayMember = "DescripcionGenerica"
            '.ValueMember = "IdCodigoProducto"
            .ValueMember = "DescripcionGenerica"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub




    ' Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
    'FilterAdqui.Properties.DataSource = Nothing
    ' FilterAdqui.Properties.NullText = ""
    '  FilterAdqui.EditValue = ""
    '   FilterAdqui.Text = ""
    'End Sub



    Private Sub lookUpEdit1_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, FilterAdqui.EditValueChanged
        'Dim editor As DevExpress.XtraEditors.LookUpEdit = CType(sender, DevExpress.XtraEditors.LookUpEdit)
        'Dim row As DataRowView = CType(editor.Properties.GetDataSourceRowByKeyValue(editor.EditValue), DataRowView)
        ' Dim row As DataRowView = CType(FilterAdqui.Properties.GetDataSourceRowByKeyValue(FilterAdqui.EditValue), DataRowView)
        'Dim value As Object = row("IdSubGrupo")
        Dim value As String
        ' Dim row = FilterAdqui.Properties.GetDataSourceRowByKeyValue(FilterAdqui.EditValue)
        'Dim row As Object
        'value = (row as DataRowView)["Description"].ToString()
        Dim rowView As DataRowView = FilterAdqui.Properties.GetDataSourceRowByKeyValue(FilterAdqui.EditValue)
        'value
        'rowView.r()

        Dim filtrado As String

        If FilterAdqui.Properties.KeyValue = "" Then
            filtrado = ""
        Else
            'filtrado = "IdCodigoProducto = " & FilterAdqui.Properties.KeyValue & " and DescripcionGenerica = " & "'" & FilterAdqui.Text & "'"
            filtrado = "DescripcionGenerica = " & "'" & FilterAdqui.Text & "'"
        End If


        ComboSubGrupo.Properties.DataSource = Nothing
        ComboSubGrupo.Properties.NullText = ""
        ComboSubGrupo.EditValue = ""
        ComboSubGrupo.Text = ""


        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ListaDescripcionProducto.Properties
            .DataSource = ObjTempSQL2.List(filtrado, 0, " C_Maestro ", "")
            .DisplayMember = "IdSubGrupo"
            .ValueMember = "IdGrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        'TextBoxSubgrupo.Text = ObjTempSQL2.List(filtrado, 0, " C_Maestro ", "")
        Dim DOC As DataTable





        If FilterAdqui.Properties.KeyValue Is Nothing Then
            'DOC = ""
        Else
            DOC = ObjTempSQL2.List(filtrado, 0, " C_Maestro ", "")
            TextBoxSubgrupo.Text = DOC.Rows(0)(1).ToString
            TextBoxIdProducto.Text = DOC.Rows(0)(2).ToString
            TextBoxGrupo.Text = DOC.Rows(0)(0).ToString

            TextBoxCodigoCambs.Text = DOC.Rows(0)(3).ToString



        End If

        'TextBoxSubgrupo.Text = ObjTempSQL2.List(filtrado, 0, " C_Maestro ", "").Rows.Item("IdSubGrupo").ToString






        'lookUpEdit1_EditValueChangedExtracted()

        'Me.ComboSubGrupo.Properties.GetDataSourceRowIndex(Me.ComboSubGrupo.Properties.Columns("IdSubGrupo"), "1")
        ' ComboSubGrupo.ItemIndex = 0

        ComboSubGrupo.Text = ComboSubGrupo.Properties.GetDataSourceValue(ComboSubGrupo.Properties.ValueMember, 0)
        ComboSubGrupo.EditValue = ComboSubGrupo.Properties.GetDataSourceValue(ComboSubGrupo.Properties.ValueMember, 1)
        ComboSubGrupo.EditValue = ComboSubGrupo.Properties.GetDataSourceValue(ComboSubGrupo.Properties.ValueMember, 2)

    End Sub






    Private Sub LisEntradas_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAdqui.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LisEntradas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 1", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub ListaSalidas_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAdqui.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ListaSalidas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub ComboPartida_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboPartida.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        ComboPartida.ItemIndex = 0
    End Sub

    Private Sub ComboGrupo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboGrupo.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboGrupo.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_grupos ", " Order by IdGrupo ")
            .DisplayMember = "NombreGrupo"
            .ValueMember = "IdGrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub




    '  Private Sub ComboListDescripcion_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboSubGrupo.GotFocus
    '     Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '      With ListaDescripcionProducto.Properties
    ' .DataSource = ObjTempSQL2.List("IdCodigoProducto = 25", 0, " C_Maestro ", " Order by DescripcionGenerica ")
    '  .DisplayMember = "IdSubGrupo"
    '   .ValueMember = "IdGrupo"
    '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '     .NullText = ""
    '      .ShowHeader = True
    '   End With
    'End Sub





    ' Private Sub LookEJEMPLO_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAdqui.GotFocus
    '     Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '      With LookEJEMPLO.Properties
    '         '  .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
    '   .DisplayMember = "DescripcionTipoMovimiento"
    '    .ValueMember = "IdTipoMovimiento"
    '     .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '      .NullText = ""
    '       .ShowHeader = True
    '    End With
    ' End Sub


    '   Private Sub 'lookUpEdit1_EditValueChangedExtracted()
    '       Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '        With ComboSubGrupo.Properties
    '.DataSource = ObjTempSQL2.List("IdCodigoProducto = " & FilterAdqui.Properties.KeyValue & " and DescripcionGenerica = " & "'" & FilterAdqui.Text & "'", 0, " C_Maestro ", "")

    '      .DataSource = ObjTempSQL2.List("IdCodigoProducto = 25", 0, " C_Maestro ", "")
    '       .DisplayMember = "IdSubGrupo"
    '        .ValueMember = "IdSubgrupo"
    '         .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '          .NullText = ""
    '           .ShowHeader = True


    '       End With
    '    End Sub


    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        FilterAlmacen.Properties.DataSource = Nothing
        FilterAlmacen.Properties.NullText = ""
        FilterAlmacen.EditValue = ""
        FilterAlmacen.Text = ""

        'LisEntradas.Properties.DataSource = Nothing
        'LisEntradas.Properties.NullText = ""
        'LisEntradas.EditValue = ""
        'LisEntradas.Text = ""
    End Sub

    Private Sub Entradas_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        'FilterAlmacen.Properties.DataSource = Nothing
        'FilterAlmacen.Properties.NullText = ""
        'FilterAlmacen.EditValue = ""
        ' FilterAlmacen.Text = ""

        LisEntradas.Properties.DataSource = Nothing
        LisEntradas.Properties.NullText = ""
        LisEntradas.EditValue = ""
        LisEntradas.Text = ""
    End Sub

    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        FilterAdqui.Properties.NullText = ""
        FilterAdqui.EditValue = ""
        FilterAdqui.Text = ""
        TextBoxIdProducto.Text = ""
        TextBoxGrupo.Text = ""
        TextBoxSubgrupo.Text = ""
        TextBoxCodigoCambs.Text = ""
        FilterAdqui.Properties.KeyValue = ""
        FilterAdqui.Properties.DataSource = ""
        FilterAdqui.Properties.KeyValue = Nothing
        FilterAdqui.Properties.DataSource = Nothing
      

    End Sub

    Private Sub SimpleButton6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click, SimpleButton10.Click
        LisEntradas.Properties.DataSource = Nothing
        LisEntradas.Properties.NullText = ""
        LisEntradas.EditValue = ""
        LisEntradas.Text = ""

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LisEntradas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 1", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


    End Sub


    Private Sub SimpleButton7_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton7.Click, SimpleButton5.Click
        ListaSalidas.Properties.DataSource = Nothing
        ListaSalidas.Properties.NullText = ""
        ListaSalidas.EditValue = ""
        ListaSalidas.Text = ""

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ListaSalidas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub


    Private Sub SimpleButton8_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton6.Click
        ComboPartida.Properties.DataSource = Nothing
        ComboPartida.Properties.NullText = ""
        ComboPartida.EditValue = ""
        ComboPartida.Text = ""
    End Sub



    Private Sub SimpleButton9_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton7.Click
        ComboGrupo.Properties.DataSource = Nothing
        ComboGrupo.Properties.NullText = ""
        ComboGrupo.EditValue = ""
        ComboGrupo.Text = ""
    End Sub

    Private Sub SimpleButton10_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton8.Click
        ComboSubGrupo.Properties.DataSource = Nothing
        ComboSubGrupo.Properties.NullText = ""
        ComboSubGrupo.EditValue = ""
        ComboSubGrupo.Text = ""
    End Sub

    Private Sub SimpleButton11_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton9.Click
        ListaDescripcionProducto.Properties.DataSource = Nothing
        ListaDescripcionProducto.Properties.NullText = ""
        ListaDescripcionProducto.EditValue = ""
        ListaDescripcionProducto.Text = ""
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

        ' With FilterAdqui.Properties
        '   .DataSource = ObjTempSQL2.List("", 0, " C_Maestro ", "WHERE CodigoCambs != ''")
        '    .DisplayMember = "CodigoCambs"
        '     .ValueMember = "IdCodigoProducto"
        '      .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '  .NullText = ""
        '   .ShowHeader = True
        'End With


        With FilterAdqui.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Maestro ", "Order by DescripcionGenerica ")
            .DisplayMember = "DescripcionGenerica"
            '.ValueMember = "IdCodigoProducto"
            .ValueMember = "DescripcionGenerica"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With



        'LisEntradas
        With LisEntradas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 1", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With ListaSalidas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With ComboPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With ComboGrupo.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_grupos ", " Order by IdGrupo ")
            .DisplayMember = "NombreGrupo"
            .ValueMember = "IdGrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        'With ComboSubGrupo.Properties
        '.DataSource = ObjTempSQL2.List("IdCodigoProducto = " & FilterAdqui.Properties.KeyValue & " and DescripcionGenerica = " & "'" & FilterAdqui.Text & "'", 0, " C_Maestro ", "")

        '.DataSource = ObjTempSQL2.List("IdCodigoProducto = 25", 0, " C_Maestro ", "")
        '.DisplayMember = "IdSubGrupo"
        '.ValueMember = "IdSubgrupo"
        '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '.NullText = ""
        '.ShowHeader = True


        ' End With


        '  With ComboSubGrupo.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, " C_subgrupos ", " Order by IdSubgrupo ")
        '     .DisplayMember = "NombreSubgrupo"
        '     .ValueMember = "IdSubgrupo"
        '  .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '   .NullText = ""
        '    .ShowHeader = True
        ' End With

        ' With (ComboSubGrupo.Properties)
        '.DataSource = ObjTempSQL2.List("IdCodigoProducto = " & FilterAdqui.Properties.KeyValue & " and DescripcionGenerica = " & "'" & FilterAdqui.Text & "'", 0, " C_Maestro ", "")

        '.DataSource = ObjTempSQL2.List("IdCodigoProducto = " & FilterAdqui.Properties.KeyValue & "and DescripcionGenerica = " & "'" & FilterAdqui.Text & "'", 0, " C_Maestro ", "")
        '.DisplayMember = "IdSubGrupo"
        '.ValueMember = "IdSubgrupo"
        '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '.NullText = ""
        '.ShowHeader = True


        'End With




        '    With ListaDescripcionProducto.Properties
        '
        ' .DataSource = ObjTempSQL2.List("IdCodigoProducto = 25", 0, " C_Maestro ", " Order by DescripcionGenerica ")
        '.DataSource = ObjTempSQL2.List("IdCodigoProducto = " & FilterAdqui.Properties.KeyValue, 0, " C_Maestro ", "")
        '.DisplayMember = "IdSubGrupo"
        '.ValueMember = "IdGrupo"
        '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '   .NullText = ""
        '    .ShowHeader = True
        ' End With

        '    With LookEJEMPLO.Properties
        '     .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
        '      .DisplayMember = "DescripcionTipoMovimiento"
        '       .ValueMember = "IdTipoMovimiento"
        '        .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '         .NullText = ""
        '          .ShowHeader = True
        '       End With





    End Sub



    ' Private Sub ComboSubClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
    '      Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '       With ComboSubClases.Properties
    ' .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
    '  .DisplayMember = "IdPartida"
    '   .ValueMember = "IdPartida"
    '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '     .NullText = ""
    '      .ShowHeader = True
    '   End With
    'End Sub

    'Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs)
    '   ComboSubClases.Properties.DataSource = Nothing
    '    ComboSubClases.Properties.NullText = ""
    ' End Sub

    ' Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs)
    '  ComboSubClases.Properties.DataSource = Nothing
    '   ComboSubClases.Properties.NullText = ""
    'End Sub


    Private Sub CheckEntradas_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChekEntradas.CheckedChanged, RadioButtonEntradas.CheckedChanged

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LisEntradas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 1", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With



        ListaSalidas.Enabled = False
        CheckAmbos.Enabled = False
        LisEntradas.Enabled = True

        ListaSalidas.Properties.DataSource = Nothing
        ListaSalidas.Properties.NullText = ""
        ListaSalidas.EditValue = ""
        ListaSalidas.Text = ""

        If LisEntradas.Enabled = False Then
            LisEntradas.Enabled = True
            CheckAmbos.Checked = False
            ChecSalidas.Checked = False
        End If

    End Sub


    Private Sub CheckSalidas_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChecSalidas.CheckStateChanged, RadioButtonSalidas.CheckedChanged

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ListaSalidas.Properties
            .DataSource = ObjTempSQL2.List("TipoMov = 2", 0, "C_TipoMovAlmacen", "ORDER BY IdTipoMovimiento")
            .DisplayMember = "DescripcionTipoMovimiento"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        ChekEntradas.Enabled = False
        CheckAmbos.Enabled = False
        LisEntradas.Enabled = False
        LisEntradas.Properties.DataSource = Nothing
        LisEntradas.Properties.NullText = ""
        LisEntradas.EditValue = ""
        LisEntradas.Text = ""


        If ListaSalidas.Enabled = False Then
            ListaSalidas.Enabled = True
            ChekEntradas.Checked = False
            CheckAmbos.Checked = False
        End If

    End Sub

    Private Sub CheckAmbos_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckAmbos.Click, CheckAmbos.CheckStateChanged, RadioButtonAmbos.CheckedChanged
        ChekEntradas.Enabled = False
        ListaSalidas.Enabled = False
        LisEntradas.Enabled = False


        If CheckAmbos.Enabled = False Then
            CheckAmbos.Enabled = True
            ChekEntradas.Checked = False
            ChecSalidas.Checked = False

        End If

    End Sub

    Private Sub TextEdit1_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles CodigoInterno.EditValueChanged

    End Sub

    Private Sub ListaSalidas_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles ListaSalidas.EditValueChanged

    End Sub
End Class