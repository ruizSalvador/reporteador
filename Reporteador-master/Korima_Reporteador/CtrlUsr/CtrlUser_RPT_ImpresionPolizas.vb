Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_ImpresionPolizas


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

        Dim reporte = New RPT_ImpresionPolizas()
        Dim printTool As New ReportPrintTool(reporte)

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_ImpresionPolizas", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        Dim tipo As String = ""
        If (cmbTipoPoliza.Text = "Diario") Then
            tipo = "D"
        End If
        If (cmbTipoPoliza.Text = "Ingresos") Then
            tipo = "I"
        End If
        If (cmbTipoPoliza.Text = "Egresos") Then
            tipo = "E"
        End If
        '--- Parametros IN

        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo", Month(filterPeriodoInicio.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo2", Month(filterPeriodoFinal.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@TipoPoliza", tipo))
        SQLComando.Parameters.Add(New SqlParameter("@FolioDel", Convert.ToInt32(nmrDel.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@FolioAl", Convert.ToInt32(nmrAl.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@IdTipoMov", IIf(cbTipoMov.Text = "", 0, Convert.ToInt32(cbTipoMov.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@ConClave", chkClave.Checked))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_ImpresionPolizas")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_ImpresionPolizas"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        Dim segundo As DateTime = New DateTime()
        If filterPeriodoFinal.SelectedText = "02" Then

            segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 28)
        ElseIf filterPeriodoFinal.SelectedText = "04" Or filterPeriodoFinal.SelectedText = "06" Or filterPeriodoFinal.SelectedText = "09" Or filterPeriodoFinal.SelectedText = "11" Then
            segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 30)
        ElseIf filterPeriodoFinal.SelectedText = "01" Or filterPeriodoFinal.SelectedText = "03" Or filterPeriodoFinal.SelectedText = "05" Or filterPeriodoFinal.SelectedText = "07" Or filterPeriodoFinal.SelectedText = "08" Or filterPeriodoFinal.SelectedText = "10" Or filterPeriodoFinal.SelectedText = "12" Then
            segundo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 31)
        End If

        '--- Llenar datos del ente
        With reporte
            If chkPageBreak.Checked = True Then
                .XrPageBreak1.Visible = True
                .pnl2.Visible = False
            Else
                .XrPageBreak1.Visible = False
                .pnl1.Visible = False
            End If
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = " Pólizas De " + cmbTipoPoliza.Text
            '.lblFechaRango.Text = ""
            .lblRptDescripcionFiltrado.Text = "" '"Ejercicio " + filterPeriodoAl.Time.Year.ToString() 
            .lblTitulo.Text = "" '"Clasificación por Objeto del Gasto (Capitulo y Concepto)"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.XrPictureBox1.Image = pRPTCFGDatosEntes.LogoEnte
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If
            '-------------------------
#If DEBUG Then
            MdlIdUsuario = 47
#End If
            Dim cmd2 As New SqlCommand("Select ApellidoPaterno + ' ' + ApellidoMaterno + ' ' + Nombres From C_Empleados Inner Join C_Usuarios On C_Empleados.NumeroEmpleado = C_Usuarios.NumeroEmpleado Where C_Usuarios.IdUsuario =" & MdlIdUsuario, New SqlConnection(cnnString))
            cmd2.Connection.Open()
            Dim reader2 = cmd2.ExecuteScalar()
            cmd2.Connection.Close()
            .lblUserName.Text = reader2
            'strUsuario = reader
            '-------------------------


            '.lblRptTituloTipo.Text = "Concepto"
            '.lblRptnomClaves.Text = "Capítulo"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & "Impresión de Polizas" & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & "Impresión de Polizas" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        'reporte.XrSubreport1.ReportSource.DataSource = dsC
        'reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        'reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"



        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        reporte = Nothing
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoInicio.EditValue = Now
        filterPeriodoFinal.EditValue = Now
        filterPeriodoAl.EditValue = Now
        cmbTipoPoliza.SelectedIndex = 0
        nmrDel.Maximum = Decimal.MaxValue
        nmrAl.Maximum = Decimal.MaxValue
        '---Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With cbTipoMov.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_TipoMovPolizas", " Order by IdTipoMovimiento asc")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


    End Sub



    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub cbTipoMov_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles cbTipoMov.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With cbTipoMov.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_TipoMovPolizas", " Order by IdTipoMovimiento asc")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoMovimiento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub


    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        nmrDel.Enabled = True
        nmrAl.Enabled = True
        cmbTipoPoliza.Enabled = True
        cbTipoMov.Properties.DataSource = Nothing
        cbTipoMov.Properties.NullText = ""
    End Sub

    Private Sub cbTipoMov_CloseUp(sender As System.Object, e As DevExpress.XtraEditors.Controls.CloseUpEventArgs) Handles cbTipoMov.CloseUp
        nmrDel.Enabled = False
        nmrAl.Enabled = False
        cmbTipoPoliza.Enabled = False
    End Sub
End Class
