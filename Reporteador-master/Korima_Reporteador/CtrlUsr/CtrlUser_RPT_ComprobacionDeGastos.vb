Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_ComprobacionDeGastos

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
        If (srchRangoDe.Text = "" And srchRangoA.Text <> "") Or (srchRangoDe.Text <> "" And srchRangoA.Text = "") Or (srchRangoDe.Text = "" And srchRangoA.Text = "") Then
            MessageBox.Show("Debe seleccionar ambos rangos", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_ComprobacionDeGastos()
        Dim printTool As New ReportPrintTool(reporte)



        '--Agregado para SP
        Dim SQLConexion As SqlConnection
        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_ComprobacionDeGastos", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        'SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", srchRangoA.Text))
        'SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", srchRangoDe.Text))
        'SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", srchRangoA.Text))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", IIf(srchRangoDe.Text.Length > 0, srchRangoDe.Text, "")))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", IIf(srchRangoA.Text.Length > 0, srchRangoA.Text, "")))
        SQLComando.Parameters.Add(New SqlParameter("@Mes", filterMes.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterAño.Time.Year))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_ComprobacionDeGastos")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_ComprobacionDeGastos"
        SQLComando.Dispose()
        SQLConexion.Close()

      


        Dim ultimo As Date = New DateTime(filterMes.Time.Year, filterMes.Time.Month, 1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Integración de recursos liberados por concepto de gastos a comprobar"
            '.lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "del 1 de Enero al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + FilterAño.Time.Year.ToString '31 de diciembre de " & Date.Now.Year.ToString()
            .lblFechaRango.Text = MesLetra(ultimo.Month) + " de " + FilterAño.Time.Year.ToString '31 de diciembre de " & Date.Now.Year.ToString()
            'If (IIf(IsDBNull(dt.Rows(0).Item(0)), 0, dt.Rows(0).Item(0)) <> IIf(IsDBNull(dt.Rows(0).Item(1)), 0, dt.Rows(0).Item(1))) Or (IIf(IsDBNull(dt.Rows(0).Item(2)), 0, dt.Rows(0).Item(2)) <> IIf(IsDBNull(dt.Rows(0).Item(3)), 0, dt.Rows(0).Item(3))) Or (IIf(IsDBNull(dt.Rows(0).Item(4)), 0, dt.Rows(0).Item(4)) <> IIf(IsDBNull(dt.Rows(0).Item(5)), 0, dt.Rows(0).Item(5))) Then
            '    .XrLabel3.Visible = True
            'End If
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Balanza de Comprobacion' ", New SqlConnection(cnnString))
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
        filterMes.Time = Now
        FilterAño.Time = Now

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchRangoDe.Properties
            .DataSource = ObjTempSQL2.List("(NumeroCuenta like '11230%' or NumeroCuenta like '11250%'or NumeroCuenta like '11110%') and Afectable = 1 and NombreCuenta not in('INGRESOS EN EFECTIVO') and  NumeroCuenta not in('11110-00001')", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True

            With srchRangoA.Properties
                .DataSource = ObjTempSQL2.List("(NumeroCuenta like '11230%' or NumeroCuenta like '11250%'or NumeroCuenta like '11110%') and Afectable = 1 and NombreCuenta not in('INGRESOS EN EFECTIVO') and  NumeroCuenta not in('11110-00001')", 0, "C_Contable", " Order by NumeroCuenta ")
                .DisplayMember = "NumeroCuenta"
                .ValueMember = "NumeroCuenta"
                '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
                .NullText = ""
                '.ShowHeader = True
            End With
        End With
    End Sub

    
    Private Sub srchRangoDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchRangoDe.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchRangoDe.Properties
            .DataSource = ObjTempSQL2.List("(NumeroCuenta like '11230%' or NumeroCuenta like '11250%'or NumeroCuenta like '11110%') and Afectable = 1 and NombreCuenta not in('INGRESOS EN EFECTIVO') and  NumeroCuenta not in('11110-00001')", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub

    Private Sub srchRangoA_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchRangoA.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchRangoA.Properties
            .DataSource = ObjTempSQL2.List("(NumeroCuenta like '11230%' or NumeroCuenta like '11250%'or NumeroCuenta like '11110%') and Afectable = 1 and NombreCuenta not in('INGRESOS EN EFECTIVO') and  NumeroCuenta not in('11110-00001')", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub



    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton5.Click
        srchRangoDe.Properties.DataSource = Nothing
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        srchRangoA.Properties.DataSource = Nothing
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        srchRangoDe.Properties.DataSource = Nothing
    End Sub
End Class
