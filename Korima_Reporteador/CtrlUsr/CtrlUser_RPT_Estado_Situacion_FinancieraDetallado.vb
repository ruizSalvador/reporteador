﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Estado_Situacion_FinancieraDetallado

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
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SP As String = ""
        Dim SPTotales As String = ""
        Dim reporte As New RPT_Estado_Situacion_FinancieraDetallado
        SPTotales = "SP_RPT_K2_Estado_Situacion_FinancieraDetallado"
        SP = "SP_RPT_K2_Estado_Situacion_FinancieraDetallado"

        Dim printTool As New ReportPrintTool(reporte)
        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        ''--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SPTotales, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Mes2", 12))
        SQLComando.Parameters.Add(New SqlParameter("@Año2", (Year(filterPeriodoAl.EditValue) - 1)))
        SQLComando.Parameters.Add(New SqlParameter("@Tipo", 3))
        SQLComando.Parameters.Add(New SqlParameter("@Miles", CheckBox1.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Redondeo", CheckBox2.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SPTotales)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SPTotales
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComandoA As New SqlCommand(SP, SQLConexion)
        SQLComandoA.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComandoA.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComandoA.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComandoA.Parameters.Add(New SqlParameter("@Mes2", 12))
        SQLComandoA.Parameters.Add(New SqlParameter("@Año2", (Year(filterPeriodoAl.EditValue) - 1)))
        SQLComandoA.Parameters.Add(New SqlParameter("@Tipo", 1))
        SQLComandoA.Parameters.Add(New SqlParameter("@Miles", CheckBox1.Checked))
        SQLComandoA.Parameters.Add(New SqlParameter("@Redondeo", CheckBox2.Checked))

        '--Fin SP

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
        SQLComandoB.Parameters.Add(New SqlParameter("@Mes2", 12))
        SQLComandoB.Parameters.Add(New SqlParameter("@Año2", (Year(filterPeriodoAl.EditValue) - 1)))
        SQLComandoB.Parameters.Add(New SqlParameter("@Tipo", 2))
        SQLComandoB.Parameters.Add(New SqlParameter("@Miles", CheckBox1.Checked))
        SQLComandoB.Parameters.Add(New SqlParameter("@Redondeo", CheckBox2.Checked))

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
        adapterD = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado de situacion financiera LDF' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsD As New DataSet()
        dsD.EnforceConstraints = False
        adapterD.Fill(dsD, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport3.ReportSource.DataSource = dsD
        reporte.XrSubreport3.ReportSource.DataAdapter = adapterD
        reporte.XrSubreport3.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .XrLabel1.Visible = CheckBox1.Checked
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Situación Financiera LDF"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
            Dim ultimo As Date = New DateTime(filterPeriodoAl2.Time.Year, filterPeriodoDe2.Time.Month, 1)
            primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
            .lblFechaRango.Text = "Al 31  de Diciembre de " + (primero.Year - 1).ToString + " Y Al " + primero.Day.ToString + " de " + MesLetra(primero.Month) + " de " + primero.Year.ToString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado de situacion financiera LDF' ", New SqlConnection(cnnString))
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
        filterPeriodoDe2.EditValue = Now
        filterPeriodoAl2.EditValue = Now
    End Sub

End Class