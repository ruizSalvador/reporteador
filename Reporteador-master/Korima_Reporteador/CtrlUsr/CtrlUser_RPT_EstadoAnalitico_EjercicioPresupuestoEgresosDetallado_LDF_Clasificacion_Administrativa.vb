Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_Clasificacion_Administrativa

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
    Public reporte As RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Administrativa_NoEtiquetadoPrincipal
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()

        reporte = New RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Administrativa_NoEtiquetadoPrincipal

        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@Tipo", 2))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado")

        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        '--Codgio para Llenar el SubReporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando2 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando2.Parameters.Add(New SqlParameter("@Tipo", 2))

        Dim adapter2 As New SqlDataAdapter(SQLComando2)
        Dim ds2 As New DataSet()
        ds2.EnforceConstraints = False
        adapter2.Fill(ds2, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado")

        reporte.SubReporteEtiquetado.ReportSource.DataSource = ds2
        reporte.SubReporteEtiquetado.ReportSource.DataAdapter = adapter2
        reporte.SubReporteEtiquetado.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado"

        SQLComando2.Dispose()
        SQLConexion.Close()
        '---Fin de llenado del subreporte

        '--Codgio para Llenar el SubReporte Totales con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando3 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado", SQLConexion)
        SQLComando3.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If

        SQLComando3.Parameters.Add(New SqlParameter("@Tipo", 2))

        Dim adapter3 As New SqlDataAdapter(SQLComando3)
        Dim ds3 As New DataSet()
        ds3.EnforceConstraints = False
        adapter3.Fill(ds3, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado")

        reporte.Totales.ReportSource.DataSource = ds3
        reporte.Totales.ReportSource.DataAdapter = adapter3
        reporte.Totales.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado"

        SQLComando3.Dispose()
        SQLConexion.Close()
        '---Fin de llenado del subreporte Totales

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado Analitico De Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado sobre el Ejercicio de los Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
            .lblTitulo.Text = "Clasificacion Administrativa"
            .lblRptNombreReporte.Text = "Estado Analitico del Ejercicio del Presupuesto de Egresos Detallado -LDF"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            Dim segundo As DateTime = New DateTime()
            If filterPeriodoFin.SelectedText = "" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 28)
            ElseIf filterPeriodoFin.SelectedText = "02" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 28)
            ElseIf filterPeriodoFin.SelectedText = "04" Or filterPeriodoFin.SelectedText = "06" Or filterPeriodoFin.SelectedText = "09" Or filterPeriodoFin.SelectedText = "11" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 30)
            ElseIf filterPeriodoFin.SelectedText = "01" Or filterPeriodoFin.SelectedText = "03" Or filterPeriodoFin.SelectedText = "05" Or filterPeriodoFin.SelectedText = "07" Or filterPeriodoFin.SelectedText = "08" Or filterPeriodoFin.SelectedText = "10" Or filterPeriodoFin.SelectedText = "12" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 31)
            End If

            Dim primero As DateTime = New DateTime()
            If filterPeriodoIni.SelectedText = "" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 28)
            ElseIf filterPeriodoIni.SelectedText = "02" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 28)
            ElseIf filterPeriodoIni.SelectedText = "04" Or filterPeriodoIni.SelectedText = "06" Or filterPeriodoIni.SelectedText = "09" Or filterPeriodoIni.SelectedText = "11" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 30)
            ElseIf filterPeriodoIni.SelectedText = "01" Or filterPeriodoIni.SelectedText = "03" Or filterPeriodoIni.SelectedText = "05" Or filterPeriodoIni.SelectedText = "07" Or filterPeriodoIni.SelectedText = "08" Or filterPeriodoIni.SelectedText = "10" Or filterPeriodoIni.SelectedText = "12" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 31)
            End If

            Dim ultimo As Date = New DateTime(filterPeriodoFin.Time.Year, filterPeriodoFin.Time.Month, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Del 1 de Enero" & " Al " & "31 de Diciembre de " & filterEjercicio.Time.Year.ToString
            Else
                '.lblRptDescripcionFiltrado.Text = "Del 1 enero " & " Al 31 de " & filterPeriodoFin.Time.Month.ToString & " de " & filterEjercicio.Time.Year.ToString
                .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " Al " + ultimo.Day.ToString + " del " + MesLetra(segundo.Month) + " del " & filterEjercicio.Time.Year.ToString
            End If

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado Analitico De Ingresos por Rubro' ", New SqlConnection(cnnString))
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
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now
    End Sub

    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub

    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) 'Handles BarButtonItem4.ItemClick
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("Aprobado_d")
        notas.Add("Ampliaciones_Reducciones")
        notas.Add("Modificado")
        notas.Add("Devengado")
        notas.Add("Pagado")
        notas.Add("Subejercicio_e")


        Dim excepciones As New List(Of String)()

        Dim frm As New Frm_Edit_NoteTable("Concepto", notas, ds, excepciones)
        frm.Text = "Clasificacion Administrativa"
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Concepto") = dr("Concepto") Then
                        ds.Tables(0).Rows(j)("Aprobado_d") = dr("Aprobado_d")
                        ds.Tables(0).Rows(j)("Ampliaciones_Reducciones") = dr("Ampliaciones_Reducciones")
                        ds.Tables(0).Rows(j)("Modificado") = dr("Modificado")
                        ds.Tables(0).Rows(j)("Devengado") = dr("Devengado")
                        ds.Tables(0).Rows(j)("Pagado") = dr("Pagado")
                        ds.Tables(0).Rows(j)("Subejercicio_e") = dr("Subejercicio_e")
                        i += 1
                        Exit For
                    End If
                    i += 1
                Next
            Next
            reporte.CreateDocument()
        End If
    End Sub
End Class