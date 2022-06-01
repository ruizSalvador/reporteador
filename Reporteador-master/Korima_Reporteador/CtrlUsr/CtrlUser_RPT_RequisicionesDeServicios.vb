Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_RequisicionesDeServicios

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If FilterProv.Text = "" Then
            ErrorProvider1.SetError(FilterProv, "Debe colocar un Folio")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_RequisicionesDeServicios
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
        Dim SQLComando As New SqlCommand("SP_RPT_RequisicionesDeServicios", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(FilterYear.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Folio", FilterProv.EditValue))
       
        SQLComando.CommandTimeout = 9999999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_RequisicionesDeServicios")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_RequisicionesDeServicios"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Reporte Requisiciones de Servicios' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        With reporte.XrSubreport1.ReportSource
            .DataSource = dsC
            .DataAdapter = adapterC
            .DataMember = "VW_RPT_K2_Firmas2"
        End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Requisiciones de Servicios"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = "" '"Servicios del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Reporte Requisiciones de Servicios' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProv.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List(" Periodo = " & FilterYear.Text, 0, " T_Solicitudes ", " Order by Folio ")
            .DisplayMember = "Folio"
            .ValueMember = "Folio"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub FilterAdqui_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterAdqui.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterAdqui.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TiposCompra ", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        FilterPeriodoAl.DateTime = Now
        FilterYear.EditValue = Now

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List(" Periodo = " & FilterYear.Text, 0, " T_Solicitudes ", " Order by Folio ")
            .DisplayMember = "Folio"
            .ValueMember = "Folio"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With FilterAdqui.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TiposCompra ", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        FilterProv.ItemIndex = 0
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterProv.Properties.DataSource = Nothing
        FilterProv.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterProv.EditValueChanged
        '
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        FilterAdqui.Properties.DataSource = Nothing
        FilterAdqui.Properties.NullText = ""
    End Sub
End Class