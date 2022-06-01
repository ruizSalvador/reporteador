Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Adquisiciones_OrdenCompraPartida

    Private Sub SimpleButton1_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton1.Click
        Dim reporte As New RPT_Adquisiciones_OrdenCompraPartida()
        Dim printTool As New ReportPrintTool(reporte)


        '--- Armado de filtro
        Dim FiltroSQL As String = ""


        FiltroSQL &= "   Pedidosdetalle_fecha BETWEEN '" & filterPeriodoDe.Text & "' and '" & filterPeriodoAl.Text & "'"

        If filterUnidadResponsable.Text <> "" Then
            FiltroSQL &= " AND UnidadResponsable_Clave = '" & filterUnidadResponsable.EditValue & "'"
        End If

        If filterPartida.Text <> "" Then
            FiltroSQL &= " AND PartPres_Clave = '" & filterPartida.EditValue & "'"
        End If


        If filterProveedor.Text <> "" Then
            FiltroSQL &= " AND Proveedores_ID = '" & filterProveedor.EditValue & "'"
        End If


        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Adquisiciones_OrdenesCompra Where " & FiltroSQL, cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Adquisiciones_OrdenesCompra"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de Ordenes de Compra por Unidad Responsable, Partida y Proveedor"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Período del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Reporte de Ordenes de Compra por Unidad Responsable, Partida y Proveedor' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With




        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(sender As Object, e As System.EventArgs) Handles Me.Load
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
        With filterPartida.Properties
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

    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
     End Sub

    Private Sub filterUnidadResponsable_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterUnidadResponsable.EditValueChanged

    End Sub

    Private Sub filterUnidadResponsable_GotFocus(sender As Object, e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
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

    Private Sub filterPartida_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterPartida.EditValueChanged

    End Sub

    Private Sub filterPartida_GotFocus(sender As Object, e As System.EventArgs) Handles filterPartida.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        filterProveedor.Properties.DataSource = Nothing
        filterProveedor.Properties.NullText = ""
    End Sub
 
    Private Sub filterProveedor_GotFocus(sender As Object, e As System.EventArgs) Handles filterProveedor.GotFocus

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
End Class
