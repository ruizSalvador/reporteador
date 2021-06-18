Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient



Public Class CtrlUser_RPT_AuxiliarPresupuestal

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        'ErrorProvider1.Clear()
        'If (FilterSello.Text.Trim = "" Or FilterSelloAl.Text.Trim = "") Then
        '    If (FilterSello.Text.Trim = "") Then ErrorProvider1.SetError(FilterSello, "Debe Indicar el rango de sellos presupuestales")
        '    If (FilterSelloAl.Text.Trim = "") Then ErrorProvider1.SetError(FilterSelloAl, "Debe Indicar el rango de sellos presupuestales")
        '    Exit Sub
        'End If

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SP As String = ""
        'Dim SPTotales As String = ""
        Dim reporte As New RPT_AuxiliarPresupuestal
        'SPTotales = "SP_RPT_K2_AuxiliarPresupuestal"
        SP = "SP_RPT_K2_AuxiliarPresupuestal"

        Dim printTool As New ReportPrintTool(reporte)
        '--Agregado para SP
        Dim SQLConexion As SqlConnection



        ''--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.CommandTimeout = 0
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@MesInicio", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MesFin", Month(TimeEdit1.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@IdSello", IIf(FilterSello.Text = "", 0, Convert.ToInt32(FilterSello.Text))))
        'SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", IIf(FilterSelloAl.Text = "", 0, Convert.ToInt32(FilterSelloAl.Text))))
        If FilterSello.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdSello", Convert.ToInt32(FilterSello.Text)))
        End If

        If FilterSello.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdSello", 0))
        End If
        If FilterSelloAl.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", Convert.ToInt32(FilterSelloAl.Text)))
        End If

        If FilterSelloAl.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", 0))
        End If
        SQLComando.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", IIf(LUE_FuenteFinanciamiento.Text = "", DBNull.Value, LUE_FuenteFinanciamiento.EditValue)))
        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", Convert.ToInt32(filterPartida.Text)))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", 0))
        End If

        If filterPartida2.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartidaFin", Convert.ToInt32(filterPartida2.Text)))
        End If

        If filterPartida2.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartidaFin", 0))
        End If

        If FilterCapitulo.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", Convert.ToInt32(FilterCapitulo.Text)))
        End If

        If FilterCapitulo.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", 0))
        End If

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SP
        SQLComando.Dispose()
        SQLConexion.Close()

        'Firmas 
        'Dim adapterD As SqlClient.SqlDataAdapter
        'adapterD = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Auxiliar Presupuestal' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        'Dim dsD As New DataSet()
        'dsD.EnforceConstraints = False
        'adapterD.Fill(dsD, "VW_RPT_K2_Firmas")
        'reporte.XrSubreport3.ReportSource.DataSource = dsD
        'reporte.XrSubreport3.ReportSource.DataAdapter = adapterD
        'reporte.XrSubreport3.ReportSource.DataMember = "VW_RPT_K2_Firmas"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .XrLabel1.Text = LUE_FuenteFinanciamiento.Text
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Auxiliar Presupuestal"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Ejercicio " & filterPeriodoAl.Text & " Periodo del " & filterPeriodoDe.Text & " al " & TimeEdit1.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='AuxiliarPresupuestal' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With


        PaintingControl.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
        TimeEdit1.EditValue = Now

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterSello.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & filterPeriodoAl.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With FilterSelloAl.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & filterPeriodoAl.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With LUE_FuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterPartida2.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterSello.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterSello.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & filterPeriodoAl.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterSelloAl_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterSelloAl.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterSelloAl.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & filterPeriodoAl.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub LUE_FuenteFinanciamiento_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LUE_FuenteFinanciamiento.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LUE_FuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida2.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida2.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCapitulo_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCapitulo.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        FilterSello.Properties.DataSource = Nothing
        FilterSello.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterSelloAl.Properties.DataSource = Nothing
        FilterSelloAl.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        LUE_FuenteFinanciamiento.Properties.DataSource = Nothing
        LUE_FuenteFinanciamiento.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton6.Click
        filterPartida2.Properties.DataSource = Nothing
        filterPartida2.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton7.Click
        FilterCapitulo.Properties.DataSource = Nothing
        FilterCapitulo.Properties.NullText = ""
    End Sub
End Class
