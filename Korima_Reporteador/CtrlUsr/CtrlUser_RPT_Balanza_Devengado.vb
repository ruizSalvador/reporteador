Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Balanza_Devengado

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
        Dim reporte As New RPT_Balanza_Devengado
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("RPT_SP_Balanza_Devengado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaIni", dtFechaIni.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", dtFechaFin.DateTime.Date))
        'SQLComando.Parameters.Add(New SqlParameter("@Proyecto", filterProyecto.Properties.KeyValue))
        SQLComando.CommandTimeout = 0

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "RPT_SP_Balanza_Devengado")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "RPT_SP_Balanza_Devengado"

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
            .lblTitulo.Text = "Layout Devengado"
            .lblRptNombreReporte.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            ' Cambiar en tiempo de ejecución las etiquetas - '@PRodriguez 20200122 B1226
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

        filterEjercicio.Time = Now
        filterEjercicio.EditValue = Now
        dtFechaIni.DateTime = Now
        dtFechaFin.DateTime = Now

        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With filterProyecto.Properties
        '    .DataSource = ObjTempSQL2.List(" Ejercicio =" & Year(filterEjercicio.EditValue), 0, "VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR", " Order by Id ")
        '    .DisplayMember = "Proyecto"
        '    .ValueMember = "Id"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

        ' Se cambia el filtro - @PRodriguez 202002 B1226
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProyecto.Properties
            .DataSource = ObjTempSQL2.List(" Ejercicio =" & Year(filterEjercicio.EditValue), 0, "VW_RPT_FichaTecnicaIndicadorProyectoInstitucional", "Order by Clave ASC")
            .DisplayMember = "Clave"
            .ValueMember = "ID"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


    End Sub


    Private Sub filterEstructuraProgramatica_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterProyecto.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With filterProyecto.Properties
        '    .DataSource = ObjTempSQL2.List("Ejercicio=" & Year(filterEjercicio.EditValue), 0, "VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR", " Order by Id ")
        '    .DisplayMember = "Proyecto"
        '    .ValueMember = "Id"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

        ' Se cambia el filtro - @PRodriguez 202002 B1226
        With filterProyecto.Properties
            .DataSource = ObjTempSQL2.List("Ejercicio=" & Year(filterEjercicio.EditValue), 0, "VW_RPT_FichaTecnicaIndicadorProyectoInstitucional", " Order by Clave ASC")
            .DisplayMember = "Clave"
            .ValueMember = "ID"
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
        filterProyecto.Properties.DataSource = Nothing
        filterProyecto.Properties.NullText = ""
        filterProyecto.Properties.ValueMember = ""

    End Sub
End Class