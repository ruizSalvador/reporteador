Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text

Public Class CtrlUser_RPT_PresupuestoEgresosTXT
    Dim IdMunicipio As String
    Dim Nomenclatura As String
    Dim Año As String
    Dim Num As String
    Dim Tipo As String

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
                PathArchivo = FolderBrowserDialog1.SelectedPath + "\" + Nomenclatura + "PRESUPUESTO" + Num + Año + ".txt"
                If File.Exists(PathArchivo) Then
                    strStreamW = File.Open(PathArchivo, FileMode.Open) 'Abrir
                Else
                    strStreamW = File.Create(PathArchivo) ' Crear
                End If
                strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.UTF8)
                Dim adapter As SqlClient.SqlDataAdapter
                adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_PresupuestoEgresosTXT WHERE Year= " + Año + " Order By CuentaPublica ", cnnString)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.FillSchema(ds, SchemaType.Source, "VW_RPT_K2_PresupuestoEgresosTXT")
                adapter.Fill(ds, "VW_RPT_K2_PresupuestoEgresosTXT")
                Dim tbl As DataTable
                tbl = ds.Tables(0)
                For Each curr As DataRow In tbl.Rows
                    strStreamWriter.WriteLine(IdMunicipio + "|" + Año + "|" + Num + "|" + Tipo + "|" + curr(0).ToString + "|" + curr(1).ToString + "|" + curr(2).ToString + "|" + curr(3).ToString + "|" + curr(4).ToString + "|" + curr(5).ToString + "|" + curr(6).ToString + "|" + curr(7).ToString)
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
        Nomenclatura = FilterMunicipio.GetColumnValue("Nomenclatura")
        Año = FilterAño.Text
        Num = SpinNum.Text
        If Num.Length = 1 Then Num = "0" + Num
        Tipo = Convert.ToString(cmbTipo.SelectedIndex + 1)
    End Sub
End Class