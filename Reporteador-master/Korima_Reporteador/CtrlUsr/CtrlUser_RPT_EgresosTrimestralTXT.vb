Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text

Public Class CtrlUser_RPT_EgresosTrimestralTXT
    Dim IdMunicipio As String
    Dim IdDependencia As String
    Dim Nomenclatura As String
    Dim Año As String
    Dim Mes As String
    Dim trimestre As String

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'filterMes.Time = Now
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

        With FilterDependencia.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_ReferenciaMunicipios", " Order by Id")
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
                PathArchivo = FolderBrowserDialog1.SelectedPath + "\A9" + trimestre + Año + IdMunicipio + ".txt"
                If File.Exists(PathArchivo) Then
                    strStreamW = File.Open(PathArchivo, FileMode.Open) 'Abrir
                Else
                    strStreamW = File.Create(PathArchivo) ' Crear
                End If
                strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.UTF8)

                Dim SQLmConnStr As String = ""
                SQLmConnStr = cnnString
                Dim SQLConexion As SqlConnection
                Dim SP As String = "SP_Ingresos_EgresosTrimestralTXT"
                SQLConexion = New SqlConnection(SQLmConnStr)
                SQLConexion.Open()
                Dim SQLComando As New SqlCommand(SP, SQLConexion)
                SQLComando.CommandType = CommandType.StoredProcedure

                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(FilterAño.EditValue)))
                SQLComando.Parameters.Add(New SqlParameter("@Trimestre", cmbTrimestre.SelectedItem))
                SQLComando.Parameters.Add(New SqlParameter("@Tipo", 1))

                Dim adapter As New SqlDataAdapter(SQLComando)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.Fill(ds, SP)
                Dim tbl As DataTable
                tbl = ds.Tables(0)
                For Each curr As DataRow In tbl.Rows
                    strStreamWriter.WriteLine(IdMunicipio + ";" + IdDependencia + ";" + curr(0).ToString + ";" + curr(1).ToString + ";" + curr(2).ToString)
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
            MsgBox("Error al Guardar la información en el archivo. " & ex.ToString, MsgBoxStyle.Critical, Application.ProductName)
            strStreamWriter.Close() ' cerramos
            objReader.Close()
        End Try
    End Sub

    Sub ObtieneCadenas()
        IdMunicipio = FilterMunicipio.Properties.KeyValue.ToString
        If IdMunicipio.Length = 1 Then IdMunicipio = "0" + IdMunicipio
        IdDependencia = FilterDependencia.Properties.KeyValue.ToString
        If IdDependencia.Length = 1 Then IdDependencia = "0" + IdDependencia
        Nomenclatura = FilterMunicipio.GetColumnValue("Nomenclatura")
        Año = FilterAño.Text
        Mes = filterMes.Text
        If cmbTrimestre.SelectedItem = 1 Then
            trimestre = "T1"
        End If
        If cmbTrimestre.SelectedItem = 2 Then
            trimestre = "T2"
        End If
        If cmbTrimestre.SelectedItem = 3 Then
            trimestre = "T3"
        End If
        If cmbTrimestre.SelectedItem = 4 Then
            trimestre = "T4"
        End If

    End Sub

    Private Sub SimpleButton1_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton1.Click
        FilterDependencia.Properties.DataSource = Nothing
        FilterDependencia.Properties.NullText = ""
    End Sub
End Class