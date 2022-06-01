﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_SolicitudTransferenciasPresupuestales
    'Private Function MesLetra(ByVal Mes As Integer) As String
    '    Select Case Mes
    '        Case 1
    '            Return "Enero"
    '        Case 2
    '            Return "Febrero"
    '        Case 3
    '            Return "Marzo"
    '        Case 4
    '            Return "Abril"
    '        Case 5
    '            Return "Mayo"
    '        Case 6
    '            Return "Junio"
    '        Case 7
    '            Return "Julio"
    '        Case 8
    '            Return "Agosto"
    '        Case 9
    '            Return "Septiembre"
    '        Case 10
    '            Return "Octubre"
    '        Case 11
    '            Return "Noviembre"
    '        Case 12
    '            Return "Diciembre"
    '        Case Else
    '            Return ""
    '    End Select
    'End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_SolicitudTransferenciasPresupuestales
        Dim printTool As New ReportPrintTool(reporte)
        'Dim SQLConexion As SqlConnection
        'Dim SQLmConnStr As String = ""
        'SQLmConnStr = cnnString

        'SQLConexion = New SqlConnection(SQLmConnStr)
        'SQLConexion.Open()
        'Dim SQLComando As New SqlCommand("SP_RPT_TransferenciasPresupuestales", SQLConexion)
        'SQLComando.CommandType = CommandType.StoredProcedure

        'SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", Convert.ToDateTime(filterPeriodoDe.Text)))
        'SQLComando.Parameters.Add(New SqlParameter("@FechaFin", Convert.ToDateTime(filterPeriodoAl.Text)))
        'SQLComando.CommandTimeout = 999

        'Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        'Dim ds As New DataSet()
        'ds.EnforceConstraints = False
        'adapter.Fill(ds, "SP_RPT_TransferenciasPresupuestales")
        'reporte.DataSource = ds
        'reporte.DataAdapter = adapter
        'reporte.DataMember = "SP_RPT_TransferenciasPresupuestales"

        'Firmas 
        Dim adapterD As SqlClient.SqlDataAdapter
        adapterD = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Formato Solicitud de Transferencia Presupuestal' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsD As New DataSet()
        dsD.EnforceConstraints = False
        adapterD.Fill(dsD, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsD
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterD
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Solicitud de Transferencias Presupuestales"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            ' .lblRptDescripcionFiltrado.Text = "Transferencias del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            '.lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .lblTitulo.Text = "Solicitud"

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Transferencias Presupuestales' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_SolicitudTransferenciasPresupuestales_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now

        '--Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuentaIni.Properties
            .DataSource = ObjTempSQL2.List("", 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "Sello"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        FilterCuentaIni.Properties.DataSource = Nothing
        FilterCuentaIni.Properties.NullText = ""
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuentaIni.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuentaIni.Properties
            .DataSource = ObjTempSQL2.List("", 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "Sello"
            .ValueMember = "Sello"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCuentaAfectable_EditValueChanged(sender As System.Object, e As System.EventArgs)
        FilterCuentaIni.Enabled = False
        SimpleButton3.Enabled = False
    End Sub

End Class