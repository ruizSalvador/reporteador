Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_FormatoProgramaRecursosOrdenGob



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
        'ErrorProvider1.Clear()
        Dim reporte As New RPT_FormatoProgramasOrdenGobierno
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_FormatoProgramaRecursosOrdendeGob", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN

        Dim mes1 As String = ""
        Dim mes2 As String = ""

        If CheckBox1.Checked Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 12))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))
            mes1 = "Enero"
            mes2 = "Diciembre"
        Else
            If RadioButton1.Checked Then
                SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))
                SQLComando.Parameters.Add(New SqlParameter("@Mes2", 3))
                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))
                mes1 = "Enero"
                mes2 = "Marzo"
            End If

            If RadioButton2.Checked Then
                SQLComando.Parameters.Add(New SqlParameter("@Mes", 4))
                SQLComando.Parameters.Add(New SqlParameter("@Mes2", 6))
                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))
                mes1 = "Abril"
                mes2 = "Junio"
            End If

            If RadioButton3.Checked Then
                SQLComando.Parameters.Add(New SqlParameter("@Mes", 7))
                SQLComando.Parameters.Add(New SqlParameter("@Mes2", 9))
                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))
                mes1 = "Julio"
                mes2 = "Septiembre"
            End If

            If RadioButton4.Checked Then
                SQLComando.Parameters.Add(New SqlParameter("@Mes", 10))
                SQLComando.Parameters.Add(New SqlParameter("@Mes2", 12))
                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))
                mes1 = "Octubre"
                mes2 = "Diciembre"
            End If

        End If




        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_FormatoProgramaRecursosOrdendeGob")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_FormatoProgramaRecursosOrdendeGob"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Programas con Recursos Concurrente por Orden de Gobierno' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') order by orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = ""
            .lblRptNombreReporte.Text = "Programas con Recursos Concurrente por Orden de Gobierno"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblRptDescripcionFiltrado.Text = "Periodo: Trimestre Del   " & filterPeriodoDe.DateTime.Date.ToShortDateString & "   Al   " & filterPeriodoAl.DateTime.Date.ToShortDateString
            If CheckBox1.Checked Then
                .lblRptDescripcionFiltrado.Text = "Periodo: Anual " & filterPeriodoAl.EditValue.Year.ToString
            Else
                .lblRptDescripcionFiltrado.Text = "Periodo: Trimestre de " & mes1 & " a " & mes2 & " del año " & filterPeriodoAl.EditValue.Year.ToString

            End If
            .lblRptNombreEnte2.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreEnte3.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreEnte4.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreEnte5.Text = pRPTCFGDatosEntes.Nombre
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Programas con Recursos Concurrente por Orden de Gobierno' ", New SqlConnection(cnnString))
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
        'filterPeriodoInicio.EditValue = Now
        'filterPeriodoFinal.EditValue = Now
        filterPeriodoAl.EditValue = Now


    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked Then
            RadioButton1.Enabled = False
            RadioButton2.Enabled = False
            RadioButton3.Enabled = False
            RadioButton4.Enabled = False
        Else
            RadioButton1.Enabled = True
            RadioButton2.Enabled = True
            RadioButton3.Enabled = True
            RadioButton4.Enabled = True
        End If
    End Sub

End Class
