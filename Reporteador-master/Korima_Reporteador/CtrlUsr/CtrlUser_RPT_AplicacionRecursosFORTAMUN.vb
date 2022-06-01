Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_AplicacionRecursosFORTAMUN
    Dim MesInicio As Integer
    Dim MesFin As Integer
    Dim Periodotexto As String

    Sub AsignaPeriodo()
        If RB_Periodo1.Checked = True Then
            MesInicio = 1
            MesFin = 3
            Periodotexto = "Periodo: Enero a Marzo"
        End If
        If RB_Periodo2.Checked = True Then
            MesInicio = 4
            MesFin = 6
            Periodotexto = "Periodo: Abril a Junio"
        End If
        If RB_Periodo3.Checked = True Then
            MesInicio = 7
            MesFin = 9
            Periodotexto = "Periodo: Julio a Septiembre"
        End If
        If RB_Periodo4.Checked = True Then
            MesInicio = 10
            MesFin = 12
            Periodotexto = "Periodo: Octubre a Diciembre"
        End If
    End Sub


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If FilterCuentaAfectable.Text = "" Then
            ErrorProvider1.SetError(FilterCuentaAfectable, "Seleccione una cuenta afectable")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_AplicacionRecursosFORTAMUN
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        AsignaPeriodo()

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_AplicacionRecursosFORTAMUN", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@MesInicio", MesInicio))
        SQLComando.Parameters.Add(New SqlParameter("@MesFin", MesFin))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoDe.Text))
        SQLComando.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", FilterCuentaAfectable.EditValue))
        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_AplicacionRecursosFORTAMUN")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_AplicacionRecursosFORTAMUN"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Aplicación de recursos FORTAMUN' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Formato de infomación de aplicación de recursos del FORTAMUN " '+ FilterCuentaAfectable.Text
            .lblRptDescripcionFiltrado.Text = Periodotexto + " " + filterPeriodoDe.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Aplicación de recursos FORTAMUN' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.Time = DateTime.Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuentaAfectable.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCuentaAfectable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuentaAfectable.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuentaAfectable.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterCuentaAfectable.Properties.DataSource = Nothing
        FilterCuentaAfectable.Properties.NullText = ""
    End Sub


End Class