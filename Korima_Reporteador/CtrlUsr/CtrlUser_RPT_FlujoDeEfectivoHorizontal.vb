Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_FlujoDeEfectivoHorizontal

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
        Dim subrpt As New SUBRPT_FlujoDeEfectivoHor
        Dim reporte As New RPT_FlujoDeEfectivoHor()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SPF As String = ""
        Dim SP As String = ""
        'Dim Estructura As String = ""

        'Obtiene la estructra de las cuentas contables
        'Dim cmd2 As New SqlCommand("SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'", New SqlConnection(cnnString))
        'cmd2.Connection.Open()
        'Dim reader2 = cmd2.ExecuteScalar()
        'cmd2.Connection.Close()
        'Estructura = reader2


        'Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
        'If CheckBox1.Checked = True Then
        '    SP = "sp_rpt_flujo_de_efectivo2RedondeoFinHor"
        'Else
        '    SP = "sp_rpt_flujo_de_efectivoRedondeoHor"
        'End If
        SP = "SP_RPT_Flujo_de_Efectivo_EF"

        If CheckBox1.Checked = True Then
            SPF = "SP_RPT_Flujo_de_Efectivo_EF"
        Else
            SPF = "SP_RPT_Flujo_de_Efectivo_EF"
        End If
        'End If

       
        '3-----------------------------------------------------------------------------------------------
        'Dim SQLConexion As SqlConnection

        ''--Codgio para Llenar Reporte con SP
        'SQLConexion = New SqlConnection(SQLmConnStr)
        'SQLConexion.Open()
        'Dim SQLComando As New SqlCommand(SPF, SQLConexion)
        'SQLComando.CommandType = CommandType.StoredProcedure
        'SQLComando.CommandTimeout = 0
        ''--- Parametros IN
        'SQLComando.Parameters.Add(New SqlParameter("@ejercicio", Year(filterPeriodoAl.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@periodo", Month(filterPeriodoDe.EditValue)))
        'If CheckBox1.Checked = True Then
        '    SQLComando.Parameters.Add(New SqlParameter("@PeriodoFin", Month(TE_periodoDe.EditValue)))
        '    SQLComando.Parameters.Add(New SqlParameter("@ejercicio2", Year(TE_periodoAl.EditValue)))
        '    SQLComando.Parameters.Add(New SqlParameter("@Tipo", 3))
        'End If
        'SQLComando.Parameters.Add(New SqlParameter("@miles", CheckBox2.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", CheckBox3.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))
        ''SQLComando.Parameters.Add(New SqlParameter("@Tipo", 3))


        'Dim adapter As New SqlDataAdapter(SQLComando)
        'Dim ds As New DataSet()
        'ds.EnforceConstraints = False
        'adapter.Fill(ds, SPF)
        reporte.XrSubreport4.ReportSource.DataSource = Nothing
        'reporte.XrSubreport4.ReportSource.DataAdapter = adapter
        'reporte.XrSubreport4.ReportSource.DataMember = SPF
        ''reporte.XrSubreport4.ReportSource.FindControl("year1", False).Text = filterPeriodoAl.Text
        '' reporte.XrSubreport4.ReportSource.FindControl("year2", False).Text = Convert.ToInt16(filterPeriodoAl.Text) - 1
        'SQLComando.Dispose()
        'SQLConexion.Close()
        '3-----------------------------------------------------------------------------------------------

        '1-----------------------------------------------------------------------------------------------

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComandoA As New SqlCommand(SP, SQLConexion)
        SQLComandoA.CommandType = CommandType.StoredProcedure
        SQLComandoA.CommandTimeout = 0
        '--- Parametros IN
        SQLComandoA.Parameters.Add(New SqlParameter("@ejercicio", Year(filterPeriodoAl.EditValue)))
        SQLComandoA.Parameters.Add(New SqlParameter("@periodo", Month(filterPeriodoDe.EditValue)))
        'If CheckBox1.Checked = True Then
        '    SQLComandoA.Parameters.Add(New SqlParameter("@PeriodoFin", Month(TE_periodoDe.EditValue)))
        '    SQLComandoA.Parameters.Add(New SqlParameter("@ejercicio2", Year(TE_periodoAl.EditValue)))
        'End If
        SQLComandoA.Parameters.Add(New SqlParameter("@miles", CheckBox2.Checked))
        SQLComandoA.Parameters.Add(New SqlParameter("@MostrarVacios", CheckBox3.Checked))
        SQLComandoA.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))
        ' SQLComandoA.Parameters.Add(New SqlParameter("@Tipo", 1))

        '--Fin SP

        Dim adapterB As New SqlDataAdapter(SQLComandoA)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, SP)
        reporte.XrSubreport1.ReportSource.DataSource = dsB
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport1.ReportSource.DataMember = SP
        reporte.XrSubreport1.ReportSource.FindControl("lblEjercicio", False).Text = filterPeriodoAl.Text
        reporte.XrSubreport1.ReportSource.FindControl("lblEjercicioAnt", False).Text = (Convert.ToInt32(filterPeriodoAl.Text) - 1).ToString

        reporte.XrSubreport2.ReportSource.DataSource = dsB
        reporte.XrSubreport2.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport2.ReportSource.DataMember = SP
        reporte.XrSubreport2.ReportSource.FindControl("lblEjercicio", False).Text = filterPeriodoAl.Text
        reporte.XrSubreport2.ReportSource.FindControl("lblEjercicioAnt", False).Text = (Convert.ToInt32(filterPeriodoAl.Text) - 1).ToString

        SQLComandoA.Dispose()
        SQLConexion.Close()

        '---Fin de llenado de reporte
        '1-----------------------------------------------------------------------------------------------
        '2-----------------------------------------------------------------------------------------------

       
        '2-----------------------------------------------------------------------------------------------

        '-----------------------------------------------------------------------------------------------
        'Firmas 
        Dim adapterD As SqlClient.SqlDataAdapter
        adapterD = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado de Flujos de Efectivo' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsD As New DataSet()
        dsD.EnforceConstraints = False
        adapterD.Fill(dsD, "VW_RPT_K2_Firmas2")
        With reporte.XrSubreport3.ReportSource
            .DataSource = dsD
            .DataAdapter = adapterD
            .DataMember = "VW_RPT_K2_Firmas2"
        End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
        Dim ultimo As Date = New DateTime(TE_periodoAl.Time.Year, TE_periodoDe.Time.Month, 1)
        primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Flujos de Efectivo"
            If CheckBox1.Checked Then
                .lblRptDescripcionFiltrado.Text = "Del 1 de Enero Al " + primero.Day.ToString + " de " + MesLetra(primero.Month) + " de " + primero.Year.ToString + " Y Del 1 de Enero Al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            Else
                .lblRptDescripcionFiltrado.Text = "Del 1 de Enero Al " + primero.Day.ToString + " de " + MesLetra(primero.Month) + " de " + primero.Year.ToString
            End If

            .XrLabel1.Visible = CheckBox2.Checked
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblEjercicio.Text = Year(filterPeriodoAl.EditValue)
            '.lblEjercicioAnt.Text = Year(filterPeriodoAl.EditValue) - 1
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado de Flujos de Efectivo' ", New SqlConnection(cnnString))
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
        TE_periodoDe.Time = Now
        TE_periodoAl.EditValue = Now
    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked = True Then
            TE_periodoDe.Visible = True
            LabelControl1.Visible = True
            TE_periodoAl.Visible = True
            Label1.Visible = True
        Else
            TE_periodoDe.Visible = False
            LabelControl1.Visible = False
            TE_periodoAl.Visible = False
            Label1.Visible = False
        End If
    End Sub
End Class
