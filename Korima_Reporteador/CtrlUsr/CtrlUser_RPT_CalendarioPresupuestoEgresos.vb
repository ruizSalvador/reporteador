Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_CalendarioPresupuestoEgresos


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

    Public Function AsignaReporte() As Object

        If filterUnidadResponsable.Text = "" Then
            Dim reporte As New RPT_CalendarioPresupuestoMensualEGR
            Return reporte
        Else
            Dim reporte As New RPT_CalendarioPresupuestoMensualEGR2
            Return reporte
        End If

    End Function
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        'Dim reporte = New Object()
        'reporte = AsignaReporte()
        'Dim printTool As New ReportPrintTool(reporte)

        'ErrorProvider1.Clear()
        'Dim reporte As XtraReport
        If filterUnidadResponsable.Text = "" Then
            Dim reporte As New RPT_CalendarioPresupuestoMensualEGR
            Dim printTool As New ReportPrintTool(reporte)
            Dim SQLConexion As SqlConnection
            Dim SQLmConnStr As String = ""
            SQLmConnStr = cnnString

            'Salvador Ruiz 31052022
            'comente las líneas de Debug
            '#If DEBUG Then
            '            MdlIdUsuario = 8
            '#End If
            '--Codgio para Llenar Reporte con SP
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand("SP_CalendarioPresupuestoEgresos", SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
            If filterUnidadResponsable.Text <> "" Then
                SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.Properties.KeyValue))
            ElseIf filterUnidadResponsable.Text = "" Then
                SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", ""))
            End If
            If GetFiltrarXUR(MdlIdUsuario) = True Then
                SQLComando.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
            Else
                SQLComando.Parameters.Add(New SqlParameter("@IdArea", 0))
            End If

            Dim adapter As New SqlDataAdapter(SQLComando)
            Dim ds As New DataSet()
            ds.EnforceConstraints = False
            adapter.Fill(ds, "SP_CalendarioPresupuestoEgresos")
            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "SP_CalendarioPresupuestoEgresos"

            SQLComando.Dispose()
            SQLConexion.Close()
            '---Fin de llenado de reporte

            'Firmas 
            Dim adapterC As SqlClient.SqlDataAdapter
            adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Calendario de Egresos Base Mensual' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
                .lblRptNombreReporte.Text = "Calendario de Presupuesto de Egresos del Ejercicio Fiscal  " & Year(filterPeriodoAl.EditValue)
                .lblRptDescripcionFiltrado.Text = ""
                .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
                '.lblRptDescripcionFiltrado.Text = "Periodo: del " & filterPeriodoDe.DateTime.Date.ToShortDateString & " Al " & filterPeriodoAl.DateTime.Date.ToShortDateString
                .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Calendario de Egresos Base Mensual' ", New SqlConnection(cnnString))
                cmd.Connection.Open()
                Dim reader = cmd.ExecuteScalar()
                cmd.Connection.Close()
                .XrLblIso.Text = reader
            End With

            PrintControl1.PrintingSystem = reporte.PrintingSystem
            reporte.CreateDocument()
            Me.Cursor = Cursors.Default
        Else
            Dim reporte As New RPT_CalendarioPresupuestoMensualEGR2
            Dim printTool As New ReportPrintTool(reporte)
            Dim SQLConexion As SqlConnection
            Dim SQLmConnStr As String = ""
            SQLmConnStr = cnnString



            '--Codgio para Llenar Reporte con SP
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand("SP_CalendarioPresupuestoEgresos", SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
            If filterUnidadResponsable.Text <> "" Then
                SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.Properties.KeyValue))
            ElseIf filterUnidadResponsable.Text = "" Then
                SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", ""))

            End If
            If GetFiltrarXUR(MdlIdUsuario) = True Then
                SQLComando.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
            Else
                SQLComando.Parameters.Add(New SqlParameter("@IdArea", 0))
            End If

            Dim adapter As New SqlDataAdapter(SQLComando)
            Dim ds As New DataSet()
            ds.EnforceConstraints = False
            adapter.Fill(ds, "SP_CalendarioPresupuestoEgresos")
            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "SP_CalendarioPresupuestoEgresos"

            SQLComando.Dispose()
            SQLConexion.Close()
            '---Fin de llenado de reporte

            'Firmas 
            Dim adapterC As SqlClient.SqlDataAdapter
            adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Calendario de Egresos Base Mensual' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
                .lblRptNombreReporte.Text = "Calendario de Presupuesto de Egresos del Ejercicio Fiscal  " & Year(filterPeriodoAl.EditValue)
                .lblRptDescripcionFiltrado.Text = ""
                .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                '.lblRptDescripcionFiltrado.Text = "Periodo: del " & filterPeriodoDe.DateTime.Date.ToShortDateString & " Al " & filterPeriodoAl.DateTime.Date.ToShortDateString
                .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Calendario de Egresos Base Mensual' ", New SqlConnection(cnnString))
                cmd.Connection.Open()
                Dim reader = cmd.ExecuteScalar()
                cmd.Connection.Close()
                .XrLblIso.Text = reader
            End With

            PrintControl1.PrintingSystem = reporte.PrintingSystem
            reporte.CreateDocument()
            Me.Cursor = Cursors.Default
        End If

    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL1.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoAl.EditValue = Now
        filterUnidadResponsable.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub
End Class