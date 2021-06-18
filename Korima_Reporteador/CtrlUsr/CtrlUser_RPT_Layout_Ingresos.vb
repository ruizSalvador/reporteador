Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions

Public Class CtrlUser_RPT_Layout_Ingresos
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
        RichTextBox1.BackColor = Color.White
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        Dim PathArchivo As String = Nothing
        Dim strStreamW As Stream = Nothing
        Dim strStreamWriter As StreamWriter = Nothing
        Dim objReader As StreamReader = Nothing
        RichTextBox1.Refresh()
        ObtieneCadenas()
        Try
            Dim d As DialogResult = FolderBrowserDialog1.ShowDialog()
            If FolderBrowserDialog1.SelectedPath <> "" And d = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                SplitContainerControl1.Collapsed = True
                PathArchivo = FolderBrowserDialog1.SelectedPath + "\Formato_Layout_Ingresos" + Año + Mes + ".txt"
                If File.Exists(PathArchivo) Then
                    MessageBox.Show("El Archivo: " + PathArchivo + " ya Existe.", "Informacion", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    'strStreamW = File.Open(PathArchivo, FileMode.CreateNew) 'Abrir
                    strStreamW = File.Create(PathArchivo)
                Else
                    strStreamW = File.Create(PathArchivo) ' Crear
                End If
                strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.ASCII)
                '-------------------------------------------
                Dim SQLConexion As SqlConnection

                '--Codgio para Llenar Reporte con SP
                SQLConexion = New SqlConnection(cnnString)
                SQLConexion.Open()
                Dim SQLComando As New SqlCommand("SP_RPT_LayoutIngresos", SQLConexion)
                SQLComando.CommandType = CommandType.StoredProcedure

                '--- Parametros IN

                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(FilterAño.EditValue)))
                SQLComando.Parameters.Add(New SqlParameter("@date", filterMes.Time))

                Dim adapter As New SqlDataAdapter(SQLComando)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.Fill(ds, "SP_RPT_LayoutIngresos")
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
                    If curr(0).ToString = "MI" Then
                        strStreamWriter.WriteLine(curr(0).ToString + "|" + curr(1).ToString + "|" + curr(2).ToString + "|" + curr(3).ToString + "|" + curr(4).ToString + "|" + curr(5).ToString + "|" + curr(6).ToString + "|" + curr(7).ToString + "|" + curr(8).ToString + "|" + curr(9).ToString + "|" + curr(10).ToString)
                    Else
                        strStreamWriter.WriteLine(curr(0).ToString + "|" + curr(1).ToString + "|" + curr(2).ToString + "|" + curr(3).ToString + "|" + curr(4).ToString + "|" + curr(5).ToString + "|" + curr(6).ToString + "|" + curr(7).ToString)
                    End If
                Next
                strStreamWriter.Close()
                objReader = New System.IO.StreamReader(PathArchivo, System.Text.Encoding.ASCII)
                objReader = File.OpenText(PathArchivo)
                RichTextBox1.Text = objReader.ReadToEnd
                Me.Cursor = Cursors.Default
                objReader.Close()
                tbl = Nothing
                ds = Nothing
                MessageBox.Show("El archivo ha sido guardado en: " + PathArchivo, "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If

        Catch ex As Exception
            MsgBox("Error al Guardar la información en el archivo. ", MsgBoxStyle.Information, Application.ProductName)
            'strStreamWriter.Close() ' cerramos
            'objReader.Close()
        End Try
    End Sub

    Sub ObtieneCadenas()
        Año = FilterAño.Text
        Mes = filterMes.Text
    End Sub

End Class