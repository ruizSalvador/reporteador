Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Estado_De_Actividades


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        Dim reporte = New Object()
        'Dim reporte As New RPT_Estado_De_Actividades()
        '--Agregado para SP
        Dim SQLConexion As SqlConnection
        Dim SP As String = ""

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
                reporte = New RPT_Estado_De_Actividades6_6
                SP = "REPORTE_Estado_De_Actividades6-6"
                reporte.XrLabel5.Text = "(En miles de Pesos)"
            Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
                reporte = New RPT_Estado_De_Actividades
                SP = "REPORTE_Estado_De_Actividades"
                reporte.XrLabel5.Text = "(En miles de Pesos)"
            End If


        Else
            'se valida si es estructura 6-6
            If Estructura.Trim = "6-6" Then
                reporte = New RPT_Estado_De_Actividades6_6
                SP = "REPORTE_Estado_De_ActividadesSinMiles6-6"
                reporte.XrLabel5.Text = ""
            Else 'Si no es estructura 6-6 es estructura 5-5 o 5-6 
                reporte = New RPT_Estado_De_Actividades
                SP = "REPORTE_Estado_De_ActividadesSinMiles"
                reporte.XrLabel5.Text = ""
            End If

        End If
        Dim printTool As New ReportPrintTool(reporte)
        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))


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
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado de actividades' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
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
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte Estado De Actividades"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblFechaRango.Text = "Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            .XrLabel2.Text = filterPeriodoAl.Text
            .XrLabel3.Text = Convert.ToInt16(filterPeriodoAl.Text) - 1
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
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
    End Sub
End Class
