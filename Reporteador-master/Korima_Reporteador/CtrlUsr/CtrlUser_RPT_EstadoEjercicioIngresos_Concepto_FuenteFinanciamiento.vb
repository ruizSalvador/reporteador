Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento
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
        Dim reporte As New RPT_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@MesInicio", 0))
            SQLComando.Parameters.Add(New SqlParameter("@MesFin", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoIni.Time.Month))
            SQLComando.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoFin.Time.Month))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", ChkMuestraNulos.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Time.Year))

        If filterUnidadResponsable.Properties.KeyValue <> Nothing Then
            SQLComando.Parameters.Add(New SqlParameter("@FuenteFinanciamiento", filterUnidadResponsable.Properties.KeyValue))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@FuenteFinanciamiento", ""))
        End If
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRed.Checked))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Por Concepto/Fuente de Financiamiento' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Concepto / Fuente de Financiamiento"
            .lblRptNombreReporte.Text = "Estado sobre el Ejercicio de los Ingresos"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Periodo: del 1/1/" & filterEjercicio.Time.Year.ToString & " Al " & "31/12/" & filterEjercicio.Time.Year.ToString
            Else
                .lblRptDescripcionFiltrado.Text = "Periodo: del 1/" & filterPeriodoIni.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString & " Al " & DateTime.DaysInMonth(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month).ToString & "/" & filterPeriodoFin.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString
            End If
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Por Concepto/Fuente de Financiamiento' ", New SqlConnection(cnnString))
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
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl


        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento UNION Select '' as FUENTEFINANCIAMIENTO, '(Ingreso sin Clasificar)' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA, '' as Desactivar", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "DESCRIPCION"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
        filterUnidadResponsable.Properties.KeyValue = Nothing
    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento UNION Select '' as FUENTEFINANCIAMIENTO, '(Ingreso sin Clasificar)' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA, '' as Desactivar", " Order by DESCRIPCION ")
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "DESCRIPCION"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterUnidadResponsable_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.EditValueChanged

    End Sub
    Private Sub ChkAnual_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub
End Class