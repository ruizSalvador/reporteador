Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text

Public Class CtrlUser_RPT_PolizasDescuadradasTXT
    Dim IdMunicipio As String
    Dim Nomenclatura As String
    Dim Año As String
    Dim Mes As String
    Dim Mes2 As String

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterMes.Time = Now
        filterMes2.Time = Now
        FilterAño.Time = Now
        RichTextBox1.BackColor = Color.White

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterMunicipio.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_ReferenciaMunicipios", " Order by Id ")
            .DisplayMember = "NombreMunicipio"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub

    Private Sub FilterCuentaAfectable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterMunicipio.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterMunicipio.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_ReferenciaMunicipios", " Order by Id ")
            .DisplayMember = "NombreMunicipio"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        FilterMunicipio.Properties.DataSource = Nothing
        FilterMunicipio.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        Dim PathArchivo As String = Nothing
        Dim strStreamW As Stream = Nothing
        Dim strStreamWriter As StreamWriter = Nothing
        Dim objReader As StreamReader = Nothing
        RichTextBox1.Text = ""
        ObtieneCadenas()
        Try
            Dim d As DialogResult = FolderBrowserDialog1.ShowDialog()
            If FolderBrowserDialog1.SelectedPath <> "" And d = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                SplitContainerControl1.Collapsed = True
                PathArchivo = FolderBrowserDialog1.SelectedPath + "\Polizas Descuadradas " + Año + " " + Mes + "-" + Mes2 + ".txt"
                If File.Exists(PathArchivo) Then
                    MessageBox.Show("El Archivo: " + PathArchivo + " ya Existe.", "Informacion", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    'strStreamW = File.Open(PathArchivo, FileMode.Open) 'Abrir
                Else
                    strStreamW = File.Create(PathArchivo) ' Crear
                End If
                strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.UTF8)

                Dim SQLmConnStr As String = ""
                SQLmConnStr = cnnString
                Dim SQLConexion As SqlConnection
                Dim SP As String = "SP_PolizasDescuadradasTXT"
                SQLConexion = New SqlConnection(SQLmConnStr)
                SQLConexion.Open()
                Dim SQLComando As New SqlCommand(SP, SQLConexion)
                SQLComando.CommandType = CommandType.StoredProcedure

                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(FilterAño.EditValue)))
                SQLComando.Parameters.Add(New SqlParameter("@periodo1", Month(filterMes.EditValue)))
                SQLComando.Parameters.Add(New SqlParameter("@periodo2", Month(filterMes2.EditValue)))

                Dim adapter As New SqlDataAdapter(SQLComando)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.Fill(ds, SP)
                Dim tbl As DataTable
                tbl = ds.Tables(0)
                For Each curr As DataRow In tbl.Rows
                    strStreamWriter.WriteLine("La poliza " + curr(1).ToString + " " + curr(2).ToString + " del mes " + Año + "-" + curr(0).ToString + " está descuadrada")
                Next
                strStreamWriter.Close()
                objReader = New System.IO.StreamReader(PathArchivo, System.Text.Encoding.UTF8)
                objReader = File.OpenText(PathArchivo)
                RichTextBox1.Text = objReader.ReadToEnd
                Me.Cursor = Cursors.Default
                objReader.Close()
                MessageBox.Show("El archivo ha sido guardado en: " + PathArchivo, "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If

        Catch ex As Exception
            'MsgBox("Error al Guardar la información en el archivo. " & ex.ToString, MsgBoxStyle.Critical, Application.ProductName)
            MsgBox("Error al Guardar la información en el archivo. ", MsgBoxStyle.Information, Application.ProductName)
            'strStreamWriter.Close() ' cerramos
            'objReader.Close()
        End Try
    End Sub

    Sub ObtieneCadenas()
        'IdMunicipio = FilterMunicipio.Properties.KeyValue.ToString
        'If IdMunicipio.Length = 1 Then IdMunicipio = "0" + IdMunicipio
        'Nomenclatura = FilterMunicipio.GetColumnValue("Nomenclatura")
        Año = FilterAño.Text
        Mes = filterMes.Text
        Mes2 = filterMes2.Text

    End Sub
End Class