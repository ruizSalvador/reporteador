Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_RelacionBienesPatrimonio
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
        ErrorProvider1.Clear()

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_RelacionBienesPatrimonio
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        ErrorProvider1.Clear()

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_RelacionBienesPatrimonioPeriodo", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@mesInicio", Month(tmMesIni.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@mesFin", Month(tmMesFin.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@EjercicioInicio", filterPeriodoAl.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@EjercicioFin", filterPeriodoAl2.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@General", chkGeneral.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Depreciacion", chkDepreciacion.Checked))

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_RelacionBienesPatrimonioPeriodo")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_RelacionBienesPatrimonioPeriodo"

        Dim SQLComandoCuenta As New SqlCommand("SP_RPT_K2_RelacionBienesPatrimonio_CuentasPeriodo", SQLConexion)
        SQLComandoCuenta.CommandType = CommandType.StoredProcedure
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@mesInicio", Month(tmMesIni.EditValue)))
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@mesFin", Month(tmMesFin.EditValue)))
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@EjercicioInicio", filterPeriodoAl.Time.Year))
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@EjercicioFin", filterPeriodoAl2.Time.Year))
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@General", chkGeneral.Checked))
        SQLComandoCuenta.Parameters.Add(New SqlParameter("@Depreciacion", chkDepreciacion.Checked))
        SQLComandoCuenta.CommandTimeout = 999
        Dim adapterCuentas As New SqlClient.SqlDataAdapter(SQLComandoCuenta)

        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl2.EditValue), Month(tmMesFin.EditValue), 1))

        Dim dsCuentas As New _Korima2_00_ReporteadorDataSet
        dsCuentas.EnforceConstraints = False
        adapterCuentas.Fill(dsCuentas, "TotalCargos") 
        With reporte
            .lblTotalUno.Text = String.Format("{0:C}", dsCuentas.TotalCargos.Rows(0)(0)).Replace("$", String.Empty)
            .lblCuentaUno.Text = dsCuentas.TotalCargos.Rows(0)(1).ToString() & " " & dsCuentas.TotalCargos.Rows(0)(2).ToString()
            .lblTotalDos.Text = String.Format("{0:C}", dsCuentas.TotalCargos.Rows(1)(0)).Replace("$", String.Empty)
            .lblCuentaDos.Text = dsCuentas.TotalCargos.Rows(1)(1).ToString() & " " & dsCuentas.TotalCargos.Rows(1)(2).ToString()
            If (chkDepreciacion.Checked = False) Then
                .lblGranTotal.Text = String.Format("{0:C}", dsCuentas.TotalCargos.Rows(0)(4) + dsCuentas.TotalCargos.Rows(0)(0) + dsCuentas.TotalCargos.Rows(1)(0)).Replace("$", String.Empty)
            Else
                .lblGranTotal.Text = String.Format("{0:C}", dsCuentas.TotalCargos.Rows(0)(4)).Replace("$", String.Empty)
            End If
            .lblDiferencia.Text = String.Format("{0:C}", dsCuentas.TotalCargos.Rows(0)(5)).Replace("$", String.Empty)
        End With

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Relación de Bienes Muebles e Inmuebles' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        With reporte.XrSubreport1.ReportSource
            .DataSource = dsC
            .DataAdapter = adapterC
            .DataMember = "VW_RPT_K2_Firmas2"
        End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente  
        Dim total As Double
        total = 0
        Dim segundo As DateTime = New DateTime()


        With reporte
            If tmMesFin.SelectedText = "02" Then
                segundo = New DateTime(filterPeriodoAl2.Time.Year, tmMesFin.Time.Month, 28)
            ElseIf tmMesFin.SelectedText = "04" Or tmMesFin.SelectedText = "06" Or tmMesFin.SelectedText = "09" Or tmMesFin.SelectedText = "11" Then
                segundo = New DateTime(filterPeriodoAl2.Time.Year, tmMesFin.Time.Month, 30)
            ElseIf tmMesFin.SelectedText = "01" Or tmMesFin.SelectedText = "03" Or tmMesFin.SelectedText = "05" Or tmMesFin.SelectedText = "07" Or tmMesFin.SelectedText = "08" Or tmMesFin.SelectedText = "10" Or tmMesFin.SelectedText = "12" Then
                segundo = New DateTime(filterPeriodoAl2.Time.Year, tmMesFin.Time.Month, 31)
            End If
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Relación de bienes que componen su patrimonio"
            .lblTitulo.Text = ""
            If chkGeneral.Checked Then
                .lblRptDescripcionFiltrado.Text = "Cuenta Pública General"
            Else
                .lblRptDescripcionFiltrado.Text = "Cuenta Pública del 1/" + tmMesIni.Text + "/" + filterPeriodoAl.Text + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy") '+ tmMesFin.Text + "/" + filterPeriodoAl.Text
            End If
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Relación de Bienes Muebles e Inmuebles' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.Time = Now
        filterPeriodoAl.Time = Now
        filterPeriodoAl2.Time = Now
        tmMesIni.Time = Now
        tmMesFin.Time = Now

    End Sub




    Private Sub chkGeneral_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles chkGeneral.CheckedChanged
        If chkGeneral.Checked Then
            tmMesIni.Enabled = False
            tmMesFin.Enabled = False
            filterPeriodoAl.Enabled = False
            filterPeriodoAl2.Enabled = False

        Else
            tmMesIni.Enabled = True
            tmMesFin.Enabled = True
            filterPeriodoAl.Enabled = True
            filterPeriodoAl2.Enabled = True
        End If
    End Sub
End Class