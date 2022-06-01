Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Adquisiciones_OrdenComprasYServiciosDependecias

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Adquisiciones_OrdenComprayServiciosDependecia()
        Dim printTool As New ReportPrintTool(reporte)


        '--- Armado de filtro
        Dim FiltroSQL As String = ""


        FiltroSQL &= "   Pedidosdetalle_fecha BETWEEN '" & filterPeriodoDe.Text & "' and '" & filterPeriodoAl.Text & "'"

        If filterUnidadResponsableInicial.Text <> "" Then
            FiltroSQL &= " AND UnidadResponsable_Clave > = '" & filterUnidadResponsableInicial.Properties.KeyValue & "'"
        End If
        If filterUnidadResponsableFinal.Text <> "" Then
            FiltroSQL &= " AND UnidadResponsable_Clave < = '" & filterUnidadResponsableFinal.Properties.KeyValue & "'"
        End If

        'If filterPartidaInicial.Text <> "" Then
        '    FiltroSQL &= " AND PartPres_Clave = '" & filterPartidaInicial.Properties.KeyValue & "'"
        'End If


        'If filterProveedor.Text <> "" Then
        '    FiltroSQL &= " AND Proveedores_ID = '" & filterProveedor.Properties.KeyValue & "'"
        'End If


        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia Where " & FiltroSQL & " ORDER BY UnidadResponsable_Clave, PedidosDetalle_Fecha, Folio, ClavePartida ", cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Adquisiciones_OrdenesServicioYCompra_Dependencia"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "OC/OS Por Unidad Reponsable "
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Período del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='OC/OS Por Unidad Reponsable' ", New SqlConnection(cnnString))
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
        With filterUnidadResponsableInicial.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsableFinal.Properties
            .DataSource = ObjTempSQL3.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartidaInicial.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With




    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsableInicial.Properties.DataSource = Nothing
        filterUnidadResponsableInicial.Properties.NullText = ""
    End Sub

    Private Sub filterUnidadResponsable_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterUnidadResponsableInicial.EditValueChanged

    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsableInicial.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsableInicial.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterPartidaInicial.EditValueChanged

    End Sub

    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartidaInicial.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartidaInicial.Properties
            .DataSource = ObjTempSQL1.List("", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        filterPartidaInicial.Properties.DataSource = Nothing
        filterPartidaInicial.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub


    Private Sub SimpleButton4_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterUnidadResponsableFinal.Properties.DataSource = Nothing
        filterUnidadResponsableFinal.Properties.NullText = ""
    End Sub

    Private Sub filterUnidadResponsableFinal_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterUnidadResponsableFinal.EditValueChanged

    End Sub

    Private Sub filterUnidadResponsableFinal_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsableFinal.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsableFinal.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
End Class
