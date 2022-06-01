Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_CuentasPorPagar
    Dim Tipocuenta As String
    Dim Afectable As Integer
    Dim Mayor As String
    Dim Numerocuenta As String
    Dim NumerocuentaFin As String
    Dim NumerocuentaInicio As String
    Dim Padres As Boolean
    Dim Hijos As Boolean
    Dim Activo As Integer
    Function AsignaEstatus(Estatus As String) As String

        Select Case Estatus
            Case "Cancelado"
                Return "N"
            Case "Aprobado"
                Return "A"
            Case "Por pagar"
                Return "C"
            Case Else
                Return ""
        End Select


    End Function
    Function AsignaTipoProveedor(TipoProveedor As String) As String
        Select Case TipoProveedor
            Case "Contratista"
                Return "C"
            Case "Proveedor"
                Return "P"
            Case "Nombre"
                Return "V"
            Case Else
                Return ""
        End Select

    End Function


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_CuentasPorPagar
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_CuentasPorPagar", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicial", filterPeriodoDe.Text))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFinal", filterPeriodoAl.Text))
        SQLComando.Parameters.Add(New SqlParameter("@Beneficiario", FilterBeneficiario.Text))
        SQLComando.Parameters.Add(New SqlParameter("@TipoProveedor", AsignaTipoProveedor(CmbtTipoProveedor.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@Estatus", AsignaEstatus(CmbEstatus.Text)))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_CuentasPorPagar")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_CuentasPorPagar"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Control de Cuentas por Pagar"
            .lblRptNombreReporte.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "" ' "Periodo: al " & filterPeriodoDe.DateTime.Date.ToShortDateString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Control de Cuentas por Pagar' ", New SqlConnection(cnnString))
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
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterBeneficiario.Properties
            .DataSource = ObjTempSQL2.List("", 0, "VW_RPT_K2_Beneficiarios", " Order by Beneficiario ")
            .DisplayMember = "Beneficiario"
            .ValueMember = "Beneficiario"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterBeneficiario.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterBeneficiario.Properties
            .DataSource = ObjTempSQL2.List("", 0, "VW_RPT_K2_Beneficiarios", " Order by Beneficiario ")
            .DisplayMember = "Beneficiario"
            .ValueMember = "Beneficiario"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        FilterBeneficiario.Properties.DataSource = Nothing
        FilterBeneficiario.Properties.NullText = ""

    End Sub






End Class