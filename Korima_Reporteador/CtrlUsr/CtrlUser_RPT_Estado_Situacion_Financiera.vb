Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient



Public Class CtrlUser_RPT_Estado_Situacion_Financiera

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SP As String = ""
        Dim SPTotales As String = ""
        Dim reporte = New Object()
        'Dim reporte As New RPT_Estado_Situacion_Financiera()
        Dim Estructura As String = ""

        'Obtiene la estructra de las cuentas contables
        Dim cmd2 As New SqlCommand("SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'", New SqlConnection(cnnString))
        cmd2.Connection.Open()
        Dim reader2 = cmd2.ExecuteScalar()
        cmd2.Connection.Close()
        Estructura = reader2


        'Se valida si es en miles de pesos
        If CheckBox1.Checked Then
            'se valida si es estructura 6-6
            If Estructura.Trim = "6-6" Then
                reporte = New RPT_Estado_Situacion_Financiera_6_6()
                SPTotales = "REPORTE_Balanza_De_Comprobacion_Totalizado6-6"
                SP = "REPORTE_Balanza_De_Comprobacion6-6"
                reporte.XrLabel1.Text = "(En Miles de Pesos)"
            Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
                reporte = New RPT_Estado_Situacion_Financiera
                SPTotales = "REPORTE_Balanza_De_Comprobacion_Totalizado"
                SP = "REPORTE_Balanza_De_Comprobacion"
                reporte.XrLabel1.Text = "(En Miles de Pesos)"
            End If
        Else ' Si no es en miles de pesos
            'se valida si es estructura 6-6
            If Estructura.Trim = "6-6" Then
                reporte = New RPT_Estado_Situacion_Financiera_6_6
                SPTotales = "REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles6-6"
                SP = "REPORTE_Balanza_De_ComprobacionSinMiles6-6"
                reporte.XrLabel1.Text = ""
            Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
                reporte = New RPT_Estado_Situacion_Financiera
                SPTotales = "REPORTE_Balanza_De_Comprobacion_TotalizadoSinMiles"
                SP = "REPORTE_Balanza_De_ComprobacionSinMiles"
                reporte.XrLabel1.Text = ""
            End If
        End If


        Dim printTool As New ReportPrintTool(reporte)
        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SPTotales, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))


        '--- Armado de filtro
        'Dim FiltroSQL As String = ""
        'FiltroSQL &= "    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""
        ''---Se llenan los datos del reporte
        'Dim adapter As New SqlClient.SqlDataAdapter("SELECT     SUM(SaldoDeudor) AS SaldoDeudor, SUM(SaldoAcreedor) AS SaldoAcreedor, Mes, Year FROM dbo.VW_RPT_K2_Balanza_De_Comprobacion_Nivelada_Totalizado WHERE " & FiltroSQL & "GROUP BY Mes, Year", cnnString)

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SPTotales)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SPTotales
        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte


        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComandoA As New SqlCommand(SP, SQLConexion)
        SQLComandoA.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComandoA.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComandoA.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComandoA.Parameters.Add(New SqlParameter("@Tipo", 1))

        '--Fin SP

        '--- Armado de filtro y SubreporteActivos
        'Dim FiltroSQLSubActivos As String = ""
        'FiltroSQLSubActivos &= "    Mes  = " & Month(filterPeriodoDe.EditValue) & " And Year = " & Year(filterPeriodoAl.EditValue) & " And TipoCuenta='1'"
        'Dim adapterB As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Balanza_De_Comprobacion_Nivelada Where " & FiltroSQLSubActivos, cnnString)

        Dim adapterB As New SqlDataAdapter(SQLComandoA)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, SP)
        reporte.XrSubreport1.ReportSource.DataSource = dsB
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport1.ReportSource.DataMember = SP

        SQLComandoA.Dispose()
        SQLConexion.Close()
        '  SQLConexion.Dispose()
        '---Fin de llenado de reporte

        '--- Armado de filtro y SubreporteActivos

        SQLConexion.Open()
        Dim SQLComandoB As New SqlCommand(SP, SQLConexion)
        SQLComandoB.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComandoB.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComandoB.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComandoB.Parameters.Add(New SqlParameter("@Tipo", 2))


        'Dim FiltroSQLSubPasivosHacienda As String = ""
        'FiltroSQLSubPasivosHacienda &= "    Mes  = " & Month(filterPeriodoDe.EditValue) & " And Year = " & Year(filterPeriodoAl.EditValue) & " AND TipoCuenta<>'1'"
        'Dim adapterC As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Balanza_De_Comprobacion_Nivelada Where " & FiltroSQLSubPasivosHacienda, cnnString)
        Dim adapterC As New SqlDataAdapter(SQLComandoB)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, SP)
        reporte.XrSubreport2.ReportSource.DataSource = dsC
        reporte.XrSubreport2.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport2.ReportSource.DataMember = SP
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterD As SqlClient.SqlDataAdapter
        adapterD = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado de situacion financiera' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsD As New DataSet()
        dsD.EnforceConstraints = False
        adapterD.Fill(dsD, "VW_RPT_K2_Firmas")
        reporte.XrSubreport3.ReportSource.DataSource = dsD
        reporte.XrSubreport3.ReportSource.DataAdapter = adapterD
        reporte.XrSubreport3.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Situación Financiera"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblFechaRango.Text = "Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            .XrLabel3.Text = filterPeriodoAl.Text
            .XrLabel6.Text = filterPeriodoAl.Text
            .XrLabel4.Text = (Convert.ToInt16(filterPeriodoAl.Text) - 1).ToString
            .XrLabel5.Text = (Convert.ToInt16(filterPeriodoAl.Text) - 1).ToString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado de situacion financiera' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
    End Sub



    Private Sub LabelControl4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LabelControl4.Click

    End Sub
End Class
