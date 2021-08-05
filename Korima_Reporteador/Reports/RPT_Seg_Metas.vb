Imports System.Data.SqlClient
Public Class RPT_Seg_Metas
    'Dim Estimado As Double
    'Dim Modificado As Double
    'Dim Devengado As Double
    'Dim Recaudado As Double
    Private dt As DataTable
    Public Ejercicio As Integer
    Public Mes As Integer
    Public IdMeta As Integer
    Public Calendarizacion As Integer
    Private treeList As New DevExpress.XtraTreeList.TreeList()

    ''28 porc modificado
    'Private Sub XrLabel28_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel28.SummaryGetResult
    '    If Modificado <> 0 Then
    '        e.Result = (Modificado / Estimado)
    '        'XrLabel28.Text = (Modificado / Estimado).ToString
    '        e.Handled = True
    '        XrLabel28.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel28.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''29 porc devengado
    'Private Sub XrLabel29_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel29.SummaryGetResult
    '    If Devengado <> 0 Then
    '        e.Result = (Devengado / Estimado)
    '        e.Handled = True
    '        XrLabel29.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel29.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''30 porc recaudado
    'Private Sub XrLabel30_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel30.SummaryGetResult
    '    If Recaudado <> 0 Then
    '        e.Result = (Recaudado / Estimado)
    '        e.Handled = True
    '        XrLabel30.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel30.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''22 estimado
    'Private Sub XrLabel22_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel22.SummaryCalculated
    '    Estimado = Convert.ToDouble(XrLabel22.Summary.GetResult())
    'End Sub

    ''23 modificado
    'Private Sub XrLabel23_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel23.SummaryCalculated
    '    Modificado = Convert.ToDouble(XrLabel23.Summary.GetResult())
    'End Sub

    ''24 Devengado
    'Private Sub XrLabel24_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel24.SummaryCalculated
    '    Devengado = Convert.ToDouble(XrLabel24.Summary.GetResult())
    'End Sub

    ''25 Recaudado
    'Private Sub XrLabel25_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel25.SummaryCalculated
    '    Recaudado = Convert.ToDouble(XrLabel25.Summary.GetResult())
    'End Sub

    'Property DataSource As DataSet



    Private Sub RPT_Seg_Metas_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles MyBase.BeforePrint
        'Dim SQLConexion As SqlConnection
        'Dim SQLmConnStr As String = ""
        'SQLmConnStr = cnnString



        ''--Codgio para Llenar Reporte con SP
        'SQLConexion = New SqlConnection(SQLmConnStr)
        'SQLConexion.Open()
        'Dim SQLComando As New SqlCommand("RPT_SeguimientoIndicadoresMetas", SQLConexion)
        'SQLComando.CommandType = CommandType.StoredProcedure
        ''--- Parametros IN
        'SQLComando.Parameters.Add(New SqlParameter("@IdUsuario", 2))
        'SQLComando.Parameters.Add(New SqlParameter("@IdMeta", 0))
        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", 2020))
        ''SQLComando.Parameters.Add(New SqlParameter("@Proyecto", filterProyecto.Properties.KeyValue))
        'SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))


        'Dim adapter As New SqlDataAdapter(SQLComando)
        'Dim ds As New DataSet()
        'ds.EnforceConstraints = False
        'adapter.Fill(ds, "RPT_SeguimientoIndicadoresMetas")
        'Me.TreeRptMetas.DataSource = ds.Tables(0)
        'Me.TreeRptMetas.ExpandAll()
        ''Me.TreeRptMetas.DataAdapter = adapter
        ''Me.TreeRptMetas.DataMember = "RPT_SeguimientoIndicadoresMetas"
        ''TreeMetas.DataSource = ds.Tables(0)

        'SQLComando.Dispose()
        'SQLConexion.Close()
        'Me.TreeRptMetas.ExpandAll()
    End Sub

    Private Sub UpdateTreeList(ByVal treeList As DevExpress.XtraTreeList.TreeList())
        'If treeList IsNot Nothing Then
        '    Dim wcc As New DevExpress.XtraReports.UI.WinControlContainer()
        '    treeList. = New Form()
        '    Detail.Controls.Add(wcc)
        '    wcc.WinControl = treeList

        '    treeList.proKeyFieldName = "uniqueID"
        '    treeList.ParentFieldName = "parentID"
        '    treeList.DataSource = dt
        '    treeList.ExpandAll()
        '    treeList.ForceInitialize()
        'End If
    End Sub

    Private Sub TreeRptMetas_DoubleClick(sender As System.Object, e As System.EventArgs)
        'Dim SQLConexion As SqlConnection
        'Dim SQLmConnStr As String = ""
        'SQLmConnStr = cnnString



        ''--Codgio para Llenar Reporte con SP
        'SQLConexion = New SqlConnection(SQLmConnStr)
        'SQLConexion.Open()
        'Dim SQLComando As New SqlCommand("RPT_SeguimientoIndicadoresMetas", SQLConexion)
        'SQLComando.CommandType = CommandType.StoredProcedure
        ''--- Parametros IN
        'SQLComando.Parameters.Add(New SqlParameter("@IdUsuario", 2))
        'SQLComando.Parameters.Add(New SqlParameter("@IdMeta", 0))
        'SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", 2020))
        ''SQLComando.Parameters.Add(New SqlParameter("@Proyecto", filterProyecto.Properties.KeyValue))
        'SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))


        'Dim adapter As New SqlDataAdapter(SQLComando)
        'Dim ds As New DataSet()
        'ds.EnforceConstraints = False
        'adapter.Fill(ds, "RPT_SeguimientoIndicadoresMetas")
        'Me.TreeRptMetas.DataSource = ds.Tables(0)
        'Me.TreeRptMetas.ExpandAll()
        ''Me.TreeRptMetas.DataAdapter = adapter
        ''Me.TreeRptMetas.DataMember = "RPT_SeguimientoIndicadoresMetas"
        ''TreeMetas.DataSource = ds.Tables(0)

        'SQLComando.Dispose()
        'SQLConexion.Close()
        'Me.TreeRptMetas.ExpandAll()
    End Sub

    Private Sub Detail_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles Detail.BeforePrint
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("RPT_SeguimientoIndicadoresMetas", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@IdUsuario", 2))
        SQLComando.Parameters.Add(New SqlParameter("@IdMeta", Me.IdMeta))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Me.Ejercicio))
        'SQLComando.Parameters.Add(New SqlParameter("@Proyecto", filterProyecto.Properties.KeyValue))
        SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))
        SQLComando.Parameters.Add(New SqlParameter("@Calendarizacion", Calendarizacion))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "RPT_SeguimientoIndicadoresMetas")
        Me.TreeList1.DataSource = ds.Tables(0)
        Me.TreeList1.ExpandAll()
        'Me.TreeRptMetas.DataAdapter = adapter
        'Me.TreeRptMetas.DataMember = "RPT_SeguimientoIndicadoresMetas"
        'TreeMetas.DataSource = ds.Tables(0)

        SQLComando.Dispose()
        SQLConexion.Close()
        Me.TreeList1.ExpandAll()
    End Sub
End Class