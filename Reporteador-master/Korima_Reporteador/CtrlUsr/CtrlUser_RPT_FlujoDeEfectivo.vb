Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_FlujoDeEfectivo

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_FlujoDeEfectivo()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SP As String = ""
        'Dim Estructura As String = ""

        'Obtiene la estructra de las cuentas contables
        'Dim cmd2 As New SqlCommand("SELECT TOP(1) VALOR FROM T_PARAMETROSCONTABLES WHERE NOMBREPARAMETRO = 'ESTRUCTURA CONTABLE'", New SqlConnection(cnnString))
        'cmd2.Connection.Open()
        'Dim reader2 = cmd2.ExecuteScalar()
        'cmd2.Connection.Close()
        'Estructura = reader2

        'se valida si es estructura 6-6
        'If Estructura.Trim = "6-6" Then
        'If CheckBox1.Checked = True Then
        'SP = "sp_rpt_flujo_de_efectivo6-62"
        'Else
        'SP = "sp_rpt_flujo_de_efectivo6-6"
        'End If

        'Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
        'If CheckBox1.Checked = True Then
        '    SP = "sp_rpt_flujo_de_efectivo2Redondeo"
        'Else
        '    SP = "sp_rpt_flujo_de_efectivoRedondeo"
        'End If

        'End If

        SP = "SP_RPT_Flujo_de_Efectivo_Mensual"

        Dim conection As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo As New SqlParameter("periodo", Month(filterPeriodoDe.EditValue))
        'Dim prmPeriodoFin As New SqlParameter("PeriodoFin", Month(filterPeriodoDe.EditValue))
        Dim prmmiles As New SqlParameter("miles", CheckBox2.Checked)
        Dim prmSinSaldo As New SqlParameter("MostrarVacios", CheckBox3.Checked)
        Dim prmPeriodoFin As New SqlParameter()
        Dim redondeo As New SqlParameter("Redondeo", chkRedondeo.Checked)
        Dim command As New SqlCommand(SP, conection)
        If CheckBox1.Checked = True Then
            prmPeriodoFin.ParameterName = "PeriodoFin"
            prmPeriodoFin.Value = Month(filterPeriodoDe.EditValue)
            command.Parameters.Add(prmPeriodoFin)
            prmPeriodo.Value = Month(TE_periodoDe.EditValue)
        End If
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        'command.Parameters.Add(prmPeriodoFin)
        command.Parameters.Add(prmmiles)
        command.Parameters.Add(prmSinSaldo)
        command.Parameters.Add(redondeo)
        command.CommandTimeout = 0

        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = SP

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado de Flujos de Efectivo' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado de Flujos de Efectivo"
            If CheckBox1.Checked Then
                .lblRptDescripcionFiltrado.Text = "Del 01/" & TE_periodoDe.Text & "/" & filterPeriodoAl.Text & " al " & lastDay.AddMonths(1).AddDays(-1) '"Del " & lastDay & " al " & lastDay.AddMonths(1).AddDays(-1)
            Else
                .lblRptDescripcionFiltrado.Text = "Del 01/" & filterPeriodoDe.Text & "/" & filterPeriodoAl.Text & " al " & lastDay.AddMonths(1).AddDays(-1) '"Del " & lastDay & " al " & lastDay.AddMonths(1).AddDays(-1)
            End If

            .XrLabel1.Visible = CheckBox2.Checked
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblEjercicio.Text = Year(filterPeriodoAl.EditValue)
            .lblEjercicioAnt.Text = Year(filterPeriodoAl.EditValue) - 1
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
        TE_periodoDe.Time = DateTime.Now
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
        Else
            TE_periodoDe.Visible = False
            LabelControl1.Visible = False
        End If
    End Sub
End Class
