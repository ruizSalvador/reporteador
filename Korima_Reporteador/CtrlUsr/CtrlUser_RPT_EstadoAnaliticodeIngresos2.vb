Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoAnaliticodeIngresos2

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

    Function fuenteFinan() As String
        If filterUnidadResponsable.Properties.KeyValue = Nothing Then
            Return "Todos"
        Else
            Return filterUnidadResponsable.Properties.KeyValue
        End If
    End Function


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()
        Dim reporte As New RPT_EstadoAnaliticodeIngresos2
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoEjercicioIngresos_Rubro", SQLConexion)
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
        'SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRed.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", 0))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRed.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoEjercicioIngresos_Rubro")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoEjercicioIngresos_Rubro"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        'Estado Analitico de Ingresos
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado Analitico De Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado sobre el Ejercicio de los Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        'Estado Analitico de Ingresos'
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado Analitico de Ingresos' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)

        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

        'adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        'reporte.XrSubreport2.ReportSource.DataSource = dsC
        'reporte.XrSubreport2.ReportSource.DataAdapter = adapterC
        ' reporte.XrSubreport2.ReportSource.DataMember = "VW_RPT_K2_Firmas2"
        '-------------------------------------------------------------------------------------------------------------------------------------
        'Segundo reporte

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando2 As New SqlCommand("SP_Estados_E_Informes_Presupuestarios", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure


        If ChkAnual.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@MesInicio", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@MesFin", 0))
        Else
            SQLComando2.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoIni.Time.Month))
            SQLComando2.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoFin.Time.Month))
        End If
        SQLComando2.Parameters.Add(New SqlParameter("@MostrarVacios", ChkMuestraNulos.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Time.Year))
        If filterUnidadResponsable.Text <> "" Then
            SQLComando2.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", filterUnidadResponsable.EditValue))
        Else
            SQLComando2.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", ""))
        End If
        SQLComando2.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRed.Checked))



        Dim adapterC2 As New SqlDataAdapter(SQLComando2)
        Dim dsC2 As New DataSet()
        dsC2.EnforceConstraints = False

        adapterC2.Fill(dsC2, "SP_Estados_E_Informes_Presupuestarios")
        reporte.XrSubreport2.ReportSource.DataSource = dsC2
        reporte.XrSubreport2.ReportSource.DataAdapter = adapterC2
        reporte.XrSubreport2.ReportSource.DataMember = "SP_Estados_E_Informes_Presupuestarios"

        SQLComando2.Dispose()
        SQLConexion.Close()
        '----------------------------------------




        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            ' .lblTitulo.Text = "Rubro"
            .lblRptNombreReporte.Text = "Estado Analitico de Ingresos"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Del 1/1/" & filterEjercicio.Time.Year.ToString & " Al " & "31/12/" & filterEjercicio.Time.Year.ToString
            Else
                .lblRptDescripcionFiltrado.Text = "Del 1/" & filterPeriodoIni.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString & " Al " & DateTime.DaysInMonth(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month).ToString & "/" & filterPeriodoFin.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString
            End If

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado Analitico De Ingresos por Rubro' ", New SqlConnection(cnnString))
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
        fuenteFinan()
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl

        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento UNION Select '' as FUENTEFINANCIAMIENTO, '(Ingreso sin Clasificar)' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With



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