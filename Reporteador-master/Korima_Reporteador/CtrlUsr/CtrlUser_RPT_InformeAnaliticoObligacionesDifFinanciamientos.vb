Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports DevExpress.XtraReports.UserDesigner

Public Class CtrlUser_RPT_InformeAnaliticoObligacionesDifFinanciamientos

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

        Dim reporte = New RPT_InformeAnaliticoObligacionesDifFinanciamientos()
        Dim printTool As New ReportPrintTool(reporte)

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        'Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        'Parametros IN

        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", 1))


        'If filterFuenteFinanciamiento.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", ""))

        'End If
        'SQLComando.Parameters.Add(New SqlParameter("@Trimestre", Trimeste()))
        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP
        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        'Dim segundo As DateTime = New DateTime()
        'If filterPeriodoFinal.SelectedText = "02" Then

        '    segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 28)
        'ElseIf filterPeriodoFinal.SelectedText = "04" Or filterPeriodoFinal.SelectedText = "06" Or filterPeriodoFinal.SelectedText = "09" Or filterPeriodoFinal.SelectedText = "11" Then
        '    segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 30)
        'ElseIf filterPeriodoFinal.SelectedText = "01" Or filterPeriodoFinal.SelectedText = "03" Or filterPeriodoFinal.SelectedText = "05" Or filterPeriodoFinal.SelectedText = "07" Or filterPeriodoFinal.SelectedText = "08" Or filterPeriodoFinal.SelectedText = "10" Or filterPeriodoFinal.SelectedText = "12" Then
        '    segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 31)
        'End If
        Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
        Dim ultimo As Date = New DateTime(TE_periodoAl.Time.Year, TE_periodoDe.Time.Month, 1)
        primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        '--- Llenar datos del ente
        With reporte

            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Informe Analitico de Obligaciones Diferentes de Financiamientos"
            '.lblFechaRango.Text = ""
            .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .lblTitulo.Text = "" '"Clasificación por Objeto del Gasto (Capitulo y Concepto)"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .lblMonto1.Text = "Monto pagado de la inversión al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .lblMonto2.Text = "Monto pagado de la inversión actualizado al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .lblSaldo.Text = "Saldo pendiente por pagar de la inversión al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            '.XrPictureBox1.Image = pRPTCFGDatosEntes.LogoEnte
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If

            '.lblRptTituloTipo.Text = "Concepto"
            '.lblRptnomClaves.Text = "Capítulo"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & "Informe Analitico de Obligaciones Diferentes de Financiamientos LDF" & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & "Informe Analitico de Obligaciones Diferentes de Financiamientos LDF" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        reporte = Nothing
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        TE_periodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
        TE_periodoAl.EditValue = Now

        '--Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


    End Sub



    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)


    End Sub

    Private Sub filterRamoDependencia_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub


    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub

    Private Sub filterFuenteFinanciamiento_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
End Class
