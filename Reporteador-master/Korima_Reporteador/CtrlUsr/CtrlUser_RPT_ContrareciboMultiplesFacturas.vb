﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient


Public Class CtrlUser_RPT_ContrareciboMultiplesFacturas

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

        Dim reporte = New RPT_ContrareciboMultiplesFacturas()
        Dim printTool As New ReportPrintTool(reporte)

        Dim s As String = ""
        If CheckedListBox1.CheckedItems.Count <> 0 Then

            Dim x As Integer

            For x = 0 To CheckedListBox1.CheckedItems.Count - 1
                'ControlChars.CrLf
                s = s & "," & "'" & CheckedListBox1.CheckedItems(x).ToString & "'"
            Next x
        End If

        Dim cadena As String
        Try
            cadena = s.Remove(0, 1)
        Catch ex As Exception
            cadena = "'false'"
        End Try

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_ContrareciboMultiplesFacturas", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure


        '--- Parametros IN

        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@Periodo", Month(filterPeriodoInicio.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@Periodo2", Month(filterPeriodoFinal.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Cadena", cadena))
        SQLComando.Parameters.Add(New SqlParameter("@IdProveedor", Convert.ToInt32(filterProv.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Convert.ToInt32(filterYear.Text)))



        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_ContrareciboMultiplesFacturas")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_ContrareciboMultiplesFacturas"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        Dim segundo As DateTime = New DateTime()
        If filterPeriodoFinal.SelectedText = "02" Then

            segundo = New DateTime(filterYear.Time.Year, filterPeriodoFinal.Time.Month, 28)
        ElseIf filterPeriodoFinal.SelectedText = "04" Or filterPeriodoFinal.SelectedText = "06" Or filterPeriodoFinal.SelectedText = "09" Or filterPeriodoFinal.SelectedText = "11" Then
            segundo = New DateTime(filterYear.Time.Year, filterPeriodoFinal.Time.Month, 30)
        ElseIf filterPeriodoFinal.SelectedText = "01" Or filterPeriodoFinal.SelectedText = "03" Or filterPeriodoFinal.SelectedText = "05" Or filterPeriodoFinal.SelectedText = "07" Or filterPeriodoFinal.SelectedText = "08" Or filterPeriodoFinal.SelectedText = "10" Or filterPeriodoFinal.SelectedText = "12" Then
            segundo = New DateTime(filterYear.Time.Year, filterPeriodoFinal.Time.Month, 31)
        End If

        '--- Llenar datos del ente
        With reporte
            
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = ""
            '.lblFechaRango.Text = ""
            .lblRptDescripcionFiltrado.Text = "CONTRA RECIBO" '"Ejercicio " + filterPeriodoAl.Time.Year.ToString()
            .lblTitulo.Text = "" '"Clasificación por Objeto del Gasto (Capitulo y Concepto)"
            .lblRazonSocial.Text = filterProv.Text
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



            '.lblRptTituloTipo.Text = "Concepto"
            '.lblRptnomClaves.Text = "Capítulo"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & "Auditoria Contable" & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & "Auditoria Contable" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
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
        filterYear.EditValue = Now

        '---Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterProv.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub


    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        filterProv.Properties.DataSource = Nothing
        filterProv.Properties.NullText = ""
    End Sub

    Private Sub filterProv_TextChanged(sender As System.Object, e As System.EventArgs) Handles filterProv.TextChanged
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        iProv = filterProv.EditValue
        Dim sql As String = "Select Factura From T_RecepcionFacturas where Estatus <> 'N' AND IdProveedor = " & iProv & " and YEAR(Fecha) = " & Convert.ToInt32(filterYear.Text) & " order by IdRecepcionServicios desc"
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        CheckedListBox1.Items.Clear()
        While reader.Read
            CheckedListBox1.BeginUpdate()
            CheckedListBox1.Items.Add(reader.Item("Factura"))
            CheckedListBox1.EndUpdate()
        End While

        CheckBox1.Checked = False
    End Sub

    Private Sub filterProv_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProv.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterProv.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        filterProv.Properties.DataSource = Nothing
        filterProv.Properties.NullText = ""
        CheckedListBox1.Items.Clear()
        CheckBox1.Checked = False
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles CheckBox1.CheckedChanged
        For x As Integer = 0 To CheckedListBox1.Items.Count - 1
            CheckedListBox1.SetItemChecked(x, CheckBox1.Checked)
        Next
    End Sub
    

    Private Sub filterYear_TextChanged(sender As System.Object, e As System.EventArgs) Handles filterYear.TextChanged
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int32 = 0
        Dim year As Int32
        Dim fecha As DateTime = filterYear.EditValue
        If (filterYear.Text = "") Then
            year = 0
        Else
            year = fecha.Year
        End If
        iProv = filterProv.EditValue
        Dim sql As String = "Select Factura From T_RecepcionFacturas where Estatus <> 'N' AND IdProveedor = " & iProv & " AND YEAR(Fecha) = " & year & " order by IdRecepcionServicios desc"
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        CheckedListBox1.Items.Clear()
        While reader.Read
            CheckedListBox1.BeginUpdate()
            CheckedListBox1.Items.Add(reader.Item("Factura"))
            CheckedListBox1.EndUpdate()
        End While

        CheckBox1.Checked = False
    End Sub
End Class
