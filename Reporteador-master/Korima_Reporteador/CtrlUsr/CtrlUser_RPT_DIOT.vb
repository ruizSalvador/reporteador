Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions

Public Class CtrlUser_RPT_DIOT
    Dim Año As String
    Dim Mes As String

    Private Function IsCero(ByVal current As Integer) As String
        If current > 0 Then
            Return current
        Else
            Return ""
        End If

    End Function

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterMes.Time = Now
        FilterAño.Time = Now
        'RichTextBox1.BackColor = Color.White
        GridView1.OptionsView.ColumnAutoWidth = False
        GridView1.BestFitColumns()
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        Dim PathArchivo As String = Nothing
        Dim strStreamW As Stream = Nothing
        Dim strStreamWriter As StreamWriter = Nothing
        Dim objReader As StreamReader = Nothing
        'RichTextBox1.Refresh()
        ObtieneCadenas()

        Dim dr As DialogResult = FolderBrowserDialog1.ShowDialog()
        If dr = DialogResult.OK Then
            If FolderBrowserDialog1.SelectedPath <> "" Then 'And dr = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                SplitContainerControl1.Collapsed = True
                PathArchivo = FolderBrowserDialog1.SelectedPath + "\" + "DIOT_" + Mes + "-" + Año + ".txt"
            End If


            Dim count As Int32 = 1
            Dim filename As String = Path.GetFileNameWithoutExtension(PathArchivo)
            Dim folder As String = Path.GetDirectoryName(PathArchivo)
            Dim ext As String = Path.GetExtension(PathArchivo)

            While File.Exists(PathArchivo)
                Dim newName As String = String.Format("{0}({1}){2}", filename, count, ext)
                PathArchivo = Path.Combine(folder, newName)
                count += 1
            End While

            strStreamW = File.Create(PathArchivo) ' Crear
            strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.ASCII)
            'End If

            Try
                'Dim d As DialogResult = FolderBrowserDialog1.ShowDialog()
                'If FolderBrowserDialog1.SelectedPath <> "" And d = DialogResult.OK Then
                '    Me.Cursor = Cursors.WaitCursor
                '    SplitContainerControl1.Collapsed = True

                '-------------------------------------------
                Dim SQLConexion As SqlConnection

                '--Codgio para Llenar Reporte con SP
                SQLConexion = New SqlConnection(cnnString)
                SQLConexion.Open()
                Dim SQLComando As New SqlCommand("SP_RPT_K2_DIOT_V2", SQLConexion)
                SQLComando.CommandType = CommandType.StoredProcedure

                '--- Parametros IN

                SQLComando.Parameters.Add(New SqlParameter("@mes", filterMes.Time.Month))
                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterAño.Time.Year))

                Dim adapter As New SqlDataAdapter(SQLComando)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.Fill(ds, "SP_RPT_K2_DIOT_V2")
                SQLComando.Dispose()
                SQLConexion.Close()
                '------------------------------
                'Dim adapter As SqlClient.SqlDataAdapter
                'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_EstadoOrigenTXT WHERE Mes= " + Mes + "AND Year=" + Año + " Order By CuentaContable ", cnnString)
                'Dim ds As New DataSet()
                'ds.EnforceConstraints = False
                'adapter.FillSchema(ds, SchemaType.Source, "VW_RPT_K2_EstadoOrigenTXT")
                'adapter.Fill(ds, "VW_RPT_K2_EstadoOrigenTXT")


                Dim tbl As DataTable
                tbl = ds.Tables(0)
                For Each curr As DataRow In tbl.Rows
                    strStreamWriter.WriteLine(curr(0).ToString + "|" + curr(1).ToString + "|" + curr(2).ToString + "|" + curr(3).ToString + "|" + curr(4).ToString + "|" + curr(5).ToString + "|" + curr(6).ToString + "|" + Me.IsCero(curr(7)) + "|" + Me.IsCero(curr(8)) + "|" + Me.IsCero(curr(9)) + "|" + Me.IsCero(curr(10)) + "|" + Me.IsCero(curr(11)) + "|" + Me.IsCero(curr(12)) + "|" + Me.IsCero(curr(13)) + "|" + Me.IsCero(curr(14)) + "|" + Me.IsCero(curr(15)) + "|" + Me.IsCero(curr(16)) + "|" + Me.IsCero(curr(17)) + "|" + Me.IsCero(curr(18)) + "|" + Me.IsCero(curr(19)) + "|" + Me.IsCero(curr(20)) + "|" + Me.IsCero(curr(21)) + "|" + Me.IsCero(curr(22)) + "|" + Me.IsCero(curr(23)) + "|")

                Next
                strStreamWriter.Close()

                objReader = New System.IO.StreamReader(PathArchivo, System.Text.Encoding.ASCII)
                objReader = File.OpenText(PathArchivo)
                'RichTextBox1.Text = objReader.ReadToEnd

                Me.Cursor = Cursors.Default
                objReader.Close()
                tbl = Nothing
                ds = Nothing
                MessageBox.Show("El archivo ha sido guardado en: " + PathArchivo, "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
                'End If

            Catch ex As Exception
                MsgBox("Error al Guardar la información en el archivo. ", MsgBoxStyle.Information, Application.ProductName)
                'strStreamWriter.Close() ' cerramos
                'objReader.Close()
                Return
            End Try
        End If
    End Sub

    Sub ObtieneCadenas()
        Año = FilterAño.Text
        Mes = filterMes.Text
    End Sub

    Private Sub exitNow()
        Exit Sub
    End Sub

    Private Sub btnGrid_Click(sender As System.Object, e As System.EventArgs) Handles btnGrid.Click
        Try
            Dim SQLConexion As SqlConnection

            '--Codgio para Llenar Reporte con SP
            SQLConexion = New SqlConnection(cnnString)
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand("SP_RPT_K2_DIOT_V2", SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure

            '--- Parametros IN

            SQLComando.Parameters.Add(New SqlParameter("@mes", filterMes.Time.Month))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterAño.Time.Year))

            Dim adapterGrid As New SqlDataAdapter(SQLComando)
            Dim dsGrid As New DataSet()
            dsGrid.EnforceConstraints = False
            adapterGrid.Fill(dsGrid, "SP_RPT_K2_DIOT_V2")
            SQLComando.Dispose()
            SQLConexion.Close()
            '------------------------------

            dgView.DataSource = dsGrid.Tables(0)
            dgView.Refresh()
            Me.Cursor = Cursors.Default
            'tbl = Nothing
            dsGrid = Nothing
        Catch
            MsgBox("Error en la información. ", MsgBoxStyle.Information, Application.ProductName)
        End Try
    End Sub
End Class