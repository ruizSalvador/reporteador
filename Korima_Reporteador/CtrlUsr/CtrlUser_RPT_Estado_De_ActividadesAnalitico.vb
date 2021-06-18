﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.Drawing.Imaging

Public Class CtrlUser_RPT_Estado_De_ActividadesAnalitico

    Public Function GetReport() As Object
        Dim rpt As XtraReport
        If chkPorcentaje.Checked = True Then
            rpt = New RPT_Estado_De_ActividadesAnaliticoPorcentaje()
        Else
            rpt = New RPT_Estado_De_ActividadesAnalitico()
        End If

        Return rpt

    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click


        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim Primer As String
        Dim Ultimo As String

        Primer = "01" & "/" & Format((CDate(filterPeriodoDe.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year
        Ultimo = Date.DaysInMonth((CDate(filterPeriodoAl.EditValue)).Year, (CDate(filterPeriodoDe2.EditValue)).Month) & "/" & Format((CDate(filterPeriodoDe2.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year
        'Dim reporte = New Object()

        '--Agregado para SP
        Dim SP As String
        Dim SQLConexion As SqlConnection
        If chkPorcentaje.Checked = True Then
            SP = "REPORTE_Estado_De_ActividadesAnaliticoRedondeoPorcentaje"
        Else
            SP = "REPORTE_Estado_De_ActividadesAnaliticoRedondeo"
        End If


        Dim reporte = New Object()
        reporte = GetReport()
        Dim printTool As New ReportPrintTool(reporte)
        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoDe2.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Miles", CheckBox1.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", CheckBox2.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SP
        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado de actividades Analítico' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))



        With reporte
            .XrLabel5.Visible = CheckBox1.Checked
            '.XrPageBreak1.Visible = CheckBox2.Checked
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Estado De Actividades Analítico"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del 01/01/" + filterPeriodoAl.Time.Year.ToString + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy") '"Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            .lblFechaRango.Text = "Del " & Primer & " al " & Ultimo
            '.XrLabel2.Text = filterPeriodoAl.Text
            '.XrLabel3.Text = Convert.ToInt16(filterPeriodoAl.Text) - 1
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado de actividades' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With



        'begin calc field
        ' Create a calculated field, mo
        ' and add it to the report's collection.
        'Dim calcField As New CalculatedField()
        'reporte.CalculatedFields.Add(calcField)

        '' Define its properties.
        'calcField.DataSource = reporte.DataSource
        'calcField.DataMember = reporte.DataMember
        'calcField.FieldType = FieldType.String
        'calcField.DisplayName = "A Calculated Field"
        'calcField.Name = "myField"
        'calcField.Expression = "Iif([MaskNumeroCuenta] like '4%','test','tezt2' )"

        '' Bind a label's Text property to the calculated field.
        ''reporte.FindControl("XrLabel1", True).DataBindings.Add("Text", Nothing, "REPORTE_Estado_De_Actividades.myField")
        'reporte.XrLabel1.DataBindings.Add("Text", Nothing, "REPORTE_Estado_De_Actividades.myField")
        ''end calc field

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Mdlrpt = reporte
        MdluserCtrl = Me
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
        filterPeriodoDe2.EditValue = Now
    End Sub
End Class
