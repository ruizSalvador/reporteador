Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls

Public Class Frm_PruebaReporte



    Private Sub PrintControl1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PrintControl1.Load

    End Sub

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Dim reporte As New RPT_Adquisiciones_OrdenCompraPartidaxxx()
        Dim printTool As New ReportPrintTool(reporte)

        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_C_Usuarios ", cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_C_Usuarios"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes


        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        reporte.XrLblNombre.Text = pRPTCFGDatosEntes.Nombre
        reporte.XrLblCiudad.Text = pRPTCFGDatosEntes.Ciudad
        reporte.XrLblRfc.Text = pRPTCFGDatosEntes.RFC
        reporte.XrPictureBox1.Image = pRPTCFGDatosEntes.LogoEnte

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()


    End Sub
End Class