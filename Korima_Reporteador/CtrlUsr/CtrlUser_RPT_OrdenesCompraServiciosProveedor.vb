Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_OrdenesCompraServiciosProveedor

    Dim Estatus As String = ""
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_OrdenesCompraServiciosProveedor
        Dim printTool As New ReportPrintTool(reporte)
        ErrorProvider1.Clear()
        If (filterProveedor1.Text <> "" Or filterProveedor2.Text = "") Then
            If (filterProveedor1.Text = "" Or filterProveedor2.Text <> "") Then
                '--- Armado de filtro
                Dim FiltroSQL As String = ""

                FiltroSQL &= "Where Fecha BETWEEN '" & Convert.ToDateTime(filterPeriodoDe.Text) & "' and '" & Convert.ToDateTime(filterPeriodoAl.Text) & "'"

                If filterProveedor1.Text <> "" Then
                    FiltroSQL &= " AND (IdProveedor BETWEEN " & filterProveedor1.EditValue & " AND " & filterProveedor2.EditValue & ")"
                End If

                If CheckEdit1.Checked = False Then
                    FiltroSQL &= " AND (Total <> 0 )"
                End If

                If cbEstatus.Text <> "" And cbEstatus.Text <> "Todas" Then
                    FiltroSQL &= " AND (Estatus = '" & AsignaEstatus() & "')"
                End If

                If cbAdjudicacion.Text <> "" Then
                    FiltroSQL &= " AND IdTipoCompra in (" & Convert.ToInt32(cbAdjudicacion.EditValue) & ")"
                End If

                Dim adapter As SqlClient.SqlDataAdapter
                adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Adquisiciones_OrdenesCompra_Servicios_Proveedor " & FiltroSQL, cnnString)

                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.FillSchema(ds, SchemaType.Source)
                reporte.DataSource = ds

                reporte.DataAdapter = adapter
                reporte.DataMember = "VW_RPT_K2_Adquisiciones_OrdenesCompra_Servicios_Proveedor"


                Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
                Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
                pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
                '--- Llenar datos del ente
                With reporte
                    .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
                    .lblRptNombreReporte.Text = "OC/OS Concentrado Por Proveedor"

                    .lblRptDescripcionFiltrado.Text = ""
                    .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                    .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                    .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                    .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                    .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                    .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
                    .lblRptDescripcionFiltrado.Text = "Periodo del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
                    .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
                    Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='OC/OS Concentrado Por Proveedor' ", New SqlConnection(cnnString))
                    cmd.Connection.Open()
                    Dim reader = cmd.ExecuteScalar()
                    cmd.Connection.Close()
                    .XrLblIso.Text = reader

                End With

                PrintControl1.PrintingSystem = reporte.PrintingSystem
                reporte.CreateDocument()
            Else
                ErrorProvider1.SetError(filterProveedor2, "Seleccione un valor")
                SplitContainerControl1.Collapsed = False
            End If
        Else
            ErrorProvider1.SetError(filterProveedor1, "Seleccione un valor")
            SplitContainerControl1.Collapsed = False
        End If
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now
        cbEstatus.SelectedIndex = 0

        '---Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor1.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        With filterProveedor2.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
            
        End With

        With cbAdjudicacion.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_TiposCompra", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True

        End With

    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterProveedor1.Properties.DataSource = Nothing
        filterProveedor1.Properties.NullText = ""
        CheckEdit1.Enabled = True
        CheckEdit1.Checked = True
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor1.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor1.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub cbAdjudicacion_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles cbAdjudicacion.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With cbAdjudicacion.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_TiposCompra", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterProveedor2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor2.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor2.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterProveedor_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterProveedor1.EditValueChanged
        CheckEdit1.Enabled = False
        CheckEdit1.Checked = True
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterProveedor2.Properties.DataSource = Nothing
        filterProveedor2.Properties.NullText = ""
        CheckEdit1.Enabled = True
        CheckEdit1.Checked = True
    End Sub

    Private Sub filterProveedor2_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterProveedor2.EditValueChanged
        CheckEdit1.Enabled = False
        CheckEdit1.Checked = True
    End Sub

    Function AsignaEstatus()
        'Cheques
        'If 1 = 1 Then
        Select Case cbEstatus.Text

            Case "Vigentes"
                Estatus = "Pedido' OR Estatus = 'Recibido"
            Case "Canceladas"
                Estatus = "Cancelado"
            Case Else
                Estatus = ""
        End Select

        Return Estatus
    End Function

    Private Sub sbAdjudicacion_Click(sender As System.Object, e As System.EventArgs) Handles sbAdjudicacion.Click
        cbAdjudicacion.Properties.DataSource = Nothing
        cbAdjudicacion.Properties.NullText = ""
    End Sub
End Class

