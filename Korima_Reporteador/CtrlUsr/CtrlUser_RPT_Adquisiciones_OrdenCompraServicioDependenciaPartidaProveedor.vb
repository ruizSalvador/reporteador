Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Adquisiciones_OrdenCompraServicioDependenciaPartidaProveedor

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Adquisiciones_OrdenCompraServicioDependenciaPartidaProveedor()
        Dim printTool As New ReportPrintTool(reporte)

        '#If DEBUG Then
        '        MdlIdUsuario = 1
        '#End If

        '--- Armado de filtro
        Dim FiltroSQL As String = ""

        If CheckBoxFechasPorReq.Checked = True Then
            FiltroSQL &= "   RequisicionDetalle_Fecha BETWEEN convert(datetime,'" & filterPeriodoDe.Text & "', 103) and convert(datetime,'" & filterPeriodoAl.Text & "', 103)"
        Else
            FiltroSQL &= "   Pedidosdetalle_fecha BETWEEN convert(datetime,'" & filterPeriodoDe.Text & "', 103) and convert(datetime,'" & filterPeriodoAl.Text & "', 103)"
        End If
        If filterUnidadResponsable.Text <> "" Then
            FiltroSQL &= " AND UnidadResponsable_Clave = '" & filterUnidadResponsable.EditValue & "'"
        End If

        If filterPartida1.Text <> "" Then
            FiltroSQL &= " AND PartPres_Clave BETWEEN '" & filterPartida1.EditValue & "' AND '" & filterPartida2.EditValue & "'"
        End If


        If filterProveedor.Text <> "" Then
            FiltroSQL &= " AND Proveedores_ID = '" & filterProveedor.EditValue & "'"
        End If

        If GetFiltrarXUR(MdlIdUsuario) = True Then
            FiltroSQL &= " AND cast(UnidadResponsable_Clave as int) = '" & GetIdUR(MdlIdUsuario) & "'"
        End If

        If TextBoxFolio.Text <> "" Then
            FiltroSQL &= " AND FolioRequisicion = " & TextBoxFolio.Text
        End If

      

        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor Where " & FiltroSQL, cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor"
        reporte.DataMember = "RPT_K2_Adquisiciones_OrdenesCompraServicioDependenciaPartidaProveedor"
        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "OC/OS Por Unidad Responsable/ Partida/proveedor"
            .lblRptEnteCiudad.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Periodo del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='OC/OS Por Unidad Responsable/ Partida/proveedor' ", New SqlConnection(cnnString))
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



        '---Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With




        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida1.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida2.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        'Salvador Ruiz 31052022
        'comente las líneas de Debug
        '#If DEBUG Then
        '        MdlIdUsuario = 2
        '#End If
        If GetFiltrarXUR(MdlIdUsuario) = True Then
            filterUnidadResponsable.Enabled = False
            SimpleButton2.Enabled = False
        End If

    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub

    Private Sub filterUnidadResponsable_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.EditValueChanged

    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterPartida1.EditValueChanged

    End Sub

    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida1.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida1.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterPartida2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida2.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida2.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        filterPartida1.Properties.DataSource = Nothing
        filterPartida1.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterProveedor.Properties.DataSource = Nothing
        filterProveedor.Properties.NullText = ""
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton5.Click
        filterPartida2.Properties.DataSource = Nothing
        filterPartida2.Properties.NullText = ""
    End Sub

    Private Sub LimpiaFolio_Click(sender As System.Object, e As System.EventArgs) Handles LimpiaFolio.Click
        TextBoxFolio.Text = ""
    End Sub

    Private Sub TextBoxFolio_KeyPress(sender As System.Object, e As System.Windows.Forms.KeyPressEventArgs) Handles TextBoxFolio.KeyPress
        If Char.IsDigit(e.KeyChar) Then
            e.Handled = False
        ElseIf Char.IsControl(e.KeyChar) Then
            e.Handled = False
        Else
            e.Handled = True
        End If
    End Sub
End Class
