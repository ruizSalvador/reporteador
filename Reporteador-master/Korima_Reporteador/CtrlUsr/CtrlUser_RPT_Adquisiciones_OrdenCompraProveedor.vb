Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Adquisiciones_OrdenCompraProveedor

    Private Sub SimpleButton1_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton1.Click
        Dim reporte As New RPT_Adquisiciones_OrdenCompraProveedor()
        Dim printTool As New ReportPrintTool(reporte)


        '--- Armado de filtro
        Dim FiltroSQL As String = ""

 

        If filterProveedor.Text <> "" Then
            FiltroSQL &= "   Where RazonSocial = '" & filterProveedor.Text & "'"
        End If


        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor  " & FiltroSQL, cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Adquisiciones_OrdenesCompra_Proveedor"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de Ordenes de Compra por Proveedor"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblRptDescripcionFiltrado.Text = "Periodo del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Reporte de Ordenes de Compra por Proveedor' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With




        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(sender As Object, e As System.EventArgs) Handles Me.Load
       


        '---Llenar listas

       
 


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
