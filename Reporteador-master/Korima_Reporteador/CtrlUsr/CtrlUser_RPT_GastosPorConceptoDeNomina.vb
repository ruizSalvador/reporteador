Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_GastosPorConceptoDeNomina
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
        ErrorProvider1.Clear()

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_GastosPorConceptoDeNomina
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
        Dim SQLComando As New SqlCommand("SP_ConceptosNomina", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Desc_Concepto", FilterConcepto.Text.Trim))
        SQLComando.Parameters.Add(New SqlParameter("@SaldoMayor", chkSaldoMayor.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@IdUR", IIf(FilterUR.Text = "", 0, Convert.ToInt32(FilterUR.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@IdFF", IIf(FilterFF.Text = "", 0, Convert.ToInt32(FilterFF.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@IdProg", IIf(FilterPrograma.Text = "", 0, Convert.ToInt32(FilterPrograma.EditValue))))


        SQLComando.CommandTimeout = 999999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_ConceptosNomina")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_ConceptosNomina"

        'Firmas 
        'Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Reporte de gastos por concepto de nómina' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        'Dim dsC As New DataSet()
        'dsC.EnforceConstraints = False
        'adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        'With reporte.XrSubreport1.ReportSource
        '    .DataSource = dsC
        '    .DataAdapter = adapterC
        '    .DataMember = "VW_RPT_K2_Firmas"
        'End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        'Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de gastos por concepto de nómina"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = ""

            .LabelEjercicio.Text = filterEjercicio.Time.Year
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            'Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Libro de Inventarios de Bienes Muebles e Inmuebles' ", New SqlConnection(cnnString))
            'cmd.Connection.Open()
            'Dim reader = cmd.ExecuteScalar()
            'cmd.Connection.Close()
            '.XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterConcepto.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterConcepto.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_ConceptosNomina ", " Order by ClaveArchivo ")
            .DisplayMember = "Descripcion"
            .ValueMember = "ClaveArchivo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterUR_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterUR.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterUR.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_AreaResponsabilidad ", " Order by IdAreaResp ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterFF_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterFF.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterFF.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_FuenteFinanciamiento ", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterPrograma_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterPrograma.GotFocus
        Dim ObjTempSQL5 As New clsRPT_CFG_DatosEntesCtrl
        With FilterPrograma.Properties
            .DataSource = ObjTempSQL5.List("Ejercicio=" & Year(filterEjercicio.EditValue), 0, "C_EP_Ramo", " Order by CLAVE ")
            .DisplayMember = "Clave"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterEjercicio.Time = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterConcepto.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_ConceptosNomina ", " Order by ClaveArchivo ")
            .DisplayMember = "DescripcionTipoBien"
            .ValueMember = "IdTipoBien"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With FilterUR.Properties
            .DataSource = ObjTempSQL3.List("", 0, " C_AreaResponsabilidad ", " Order by IdAreaResp ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL4 As New clsRPT_CFG_DatosEntesCtrl
        With FilterFF.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_FuenteFinanciamiento ", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL5 As New clsRPT_CFG_DatosEntesCtrl
        With FilterPrograma.Properties
            .DataSource = ObjTempSQL5.List("Ejercicio=" & Year(filterEjercicio.EditValue), 0, "C_EP_Ramo", " Order by CLAVE ")
            .DisplayMember = "Clave"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterConcepto.Properties.DataSource = Nothing
        FilterConcepto.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        FilterUR.Properties.DataSource = Nothing
        FilterUR.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        FilterFF.Properties.DataSource = Nothing
        FilterFF.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        FilterPrograma.Properties.DataSource = Nothing
        FilterPrograma.Properties.NullText = ""
    End Sub
End Class