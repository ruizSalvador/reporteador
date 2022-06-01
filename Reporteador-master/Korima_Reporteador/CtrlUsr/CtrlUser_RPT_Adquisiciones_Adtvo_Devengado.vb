Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Adquisiciones_Adtvo_Devengado

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
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()
        Dim reporte As New RPT_Adquisiciones_Adtvo_Devengado
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("RPT_SP_Adquisiciones_Adtvo_Devengado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo1", Month(filterPeriodoIni.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo2", Month(filterPeriodoFin.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@TipoMov", IIf(cbTipoMov.Text = "", 0, Convert.ToInt32(cbTipoMov.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", IIf(cbCapitulo.Text = "", 0, Convert.ToInt32(cbCapitulo.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@IdPartida", IIf(cbPartida.Text = "", 0, Convert.ToInt32(cbPartida.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@IdProv", IIf(cbProveedor.Text = "", 0, Convert.ToInt32(cbProveedor.EditValue))))
        SQLComando.CommandTimeout = 0

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "RPT_SP_Adquisiciones_Adtvo_Devengado")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "RPT_SP_Adquisiciones_Adtvo_Devengado"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Catalogo de Sellos Presupuestales' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        ' adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Analítico de la Deuda Pública y Otros Pasivos' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)

        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        'reporte.XrSubreport1.ReportSource.DataSource = dsC
        'reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        'reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Layout Devengado Contable"
            .lblRptNombreReporte.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario


            .lblRptDescripcionFiltrado.Text = "Ejercicio: " & filterEjercicio.Time.Year.ToString

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Por Rubro/Tipo' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_FichaTecnicaIndicadorProyectoInstitucional_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now
        filterEjercicio.EditValue = Now
        'FechaIni.DateTime = Now
        'FechaFin.DateTime = Now


        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With cbTipoMov.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoMovPolizas ", " Order by IdTipoMovimiento ASC ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With cbCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With cbPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With cbProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub


    Private Sub cbTipoMov_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbTipoMov.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With cbTipoMov.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoMovPolizas ", " Order by IdTipoMovimiento ASC ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With



    End Sub

    Private Sub cbCapitulo_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbCapitulo.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With cbCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub

    Private Sub cbPartida_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbPartida.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With cbPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "IdPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub

    Private Sub cbProveedor_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbProveedor.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With cbProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub

    Private Sub ChkAnual_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkAnual.CheckedChanged
        'If ChkAnual.Checked = True Then
        '    filterPeriodoFin.Enabled = False
        '    filterPeriodoIni.Enabled = False
        'Else
        '    filterPeriodoFin.Enabled = True
        '    filterPeriodoIni.Enabled = True
        'End If
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        cbTipoMov.Properties.DataSource = Nothing
        cbTipoMov.Properties.NullText = ""
        cbTipoMov.Properties.ValueMember = ""

    End Sub

    Private Sub btnClearCap_Click(sender As System.Object, e As System.EventArgs) Handles btnClearCap.Click
        cbCapitulo.Properties.DataSource = Nothing
        cbCapitulo.Properties.NullText = ""
        cbCapitulo.Properties.ValueMember = ""
    End Sub

    Private Sub btnClearPartida_Click(sender As System.Object, e As System.EventArgs) Handles btnClearPartida.Click
        cbPartida.Properties.DataSource = Nothing
        cbPartida.Properties.NullText = ""
        cbPartida.Properties.ValueMember = ""
    End Sub

    Private Sub btnClearProveedor_Click(sender As System.Object, e As System.EventArgs) Handles btnClearProveedor.Click
        cbProveedor.Properties.DataSource = Nothing
        cbProveedor.Properties.NullText = ""
        cbProveedor.Properties.ValueMember = ""
    End Sub
End Class