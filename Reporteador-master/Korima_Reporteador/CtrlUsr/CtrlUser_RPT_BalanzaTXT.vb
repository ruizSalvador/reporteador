Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text

Public Class CtrlUser_RPT_BalanzaTXT
    Dim IdMunicipio As String
    Dim Nomenclatura As String
    Dim Año As String
    Dim Mes As String
    Dim trimestre As String

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'filterMes.Time = Now
        filterMes.EditValue = Now
        filterMesAl.EditValue = Now
        FilterAño.Time = Now
        RichTextBox1.BackColor = Color.White

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterMunicipio.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        cmbTrimestre.SelectedIndex = 0
        FilterMunicipio.ItemIndex = 0

    End Sub

    Private Sub FilterCuentaAfectable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterMunicipio.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterMunicipio.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        FilterMunicipio.ItemIndex = 0
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        Dim PathArchivo As String = Nothing, separador As String
        Dim strStreamW As Stream = Nothing
        Dim strStreamWriter As StreamWriter = Nothing
        Dim objReader As StreamReader = Nothing

        RichTextBox1.Text = ""
        ObtieneCadenas()
        Try
            Me.Cursor = Cursors.WaitCursor
            SplitContainerControl1.Collapsed = True
            'PathArchivo = FolderBrowserDialog1.SelectedPath + "\Balanza" + Año + cmbTrimestre.Text + IdMunicipio + ".txt"
            SaveFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"
            SaveFileDialog1.ShowDialog()
            If SaveFileDialog1.FileName <> "" Then
                PathArchivo = SaveFileDialog1.FileName
                If File.Exists(PathArchivo) Then
                    strStreamW = File.Open(PathArchivo, FileMode.Open) 'Abrir
                Else
                    strStreamW = File.Create(PathArchivo) ' Crear
                End If
                strStreamWriter = New StreamWriter(strStreamW, System.Text.Encoding.UTF8)

                Dim SQLmConnStr As String = ""
                SQLmConnStr = cnnString
                Dim SQLConexion As SqlConnection
                Dim SP As String = "SP_BalanzaTXT"
                SQLConexion = New SqlConnection(SQLmConnStr)
                SQLConexion.Open()
                Dim SQLComando As New SqlCommand(SP, SQLConexion)
                SQLComando.CommandType = CommandType.StoredProcedure

                SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(FilterAño.EditValue)))
                'SQLComando.Parameters.Add(New SqlParameter("@trimestre", cmbTrimestre.SelectedItem))
                SQLComando.Parameters.Add(New SqlParameter("@mes1", Month(filterMes.EditValue)))
                SQLComando.Parameters.Add(New SqlParameter("@mes2", Month(filterMesAl.EditValue)))
                If rdBtn4.Checked Then
                    SQLComando.Parameters.Add(New SqlParameter("@Nivel", 4))
                Else
                    SQLComando.Parameters.Add(New SqlParameter("@Nivel", 5))
                End If

                If rdBtnTab.Checked Then
                    separador = vbTab
                Else
                    separador = "|"
                End If

                Dim adapter As New SqlDataAdapter(SQLComando)
                Dim ds As New DataSet()
                ds.EnforceConstraints = False
                adapter.Fill(ds, SP)
                Dim tbl As DataTable
                tbl = ds.Tables(0)
                For Each curr As DataRow In tbl.Rows
                    '--- Estructura Anterior Luis Rojas 2018.11.05
                    'If curr(0).ToString = "TC" Then
                    '    strStreamWriter.WriteLine(curr(0).ToString + "      " + curr(1).ToString + "    " + IdMunicipio + " " + curr(2).ToString + "    " + curr(3).ToString + "    " + Convert.ToInt32(curr(4)).ToString + "   " + curr(5).ToString + "    " + curr(6).ToString + "    " + curr(7).ToString)
                    'Else
                    '    strStreamWriter.WriteLine(curr(0).ToString + "  " + curr(1).ToString + "    " + curr(2).ToString + "    " + curr(3).ToString + "    " + curr(4).ToString)
                    'End If
                    '---
                    If curr(0).ToString = "TC" Then
                        strStreamWriter.WriteLine(curr(0).ToString + separador + curr(1).ToString + separador + IdMunicipio + separador + curr(2).ToString + separador + curr(3).ToString + separador + Convert.ToInt32(curr(4)).ToString + separador + curr(5).ToString + separador + curr(6).ToString + separador + curr(7).ToString)
                    Else
                        strStreamWriter.WriteLine(curr(0).ToString + separador + curr(1).ToString + separador + curr(2).ToString + separador + curr(3).ToString + separador + curr(4).ToString)
                    End If
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
            MsgBox("Error al Guardar la información. Favor de Generar de nuevo el archivo. ", MsgBoxStyle.Exclamation, "Kórima®")
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Sub ObtieneCadenas()
        IdMunicipio = FilterMunicipio.EditValue.ToString
        If IdMunicipio.Length = 1 Then IdMunicipio = "0" + IdMunicipio
        Nomenclatura = FilterMunicipio.GetColumnValue("Nomenclatura")
        Año = FilterAño.Text
        Mes = filterMes.Text

    End Sub
End Class