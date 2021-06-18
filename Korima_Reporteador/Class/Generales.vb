Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Module Generales
    Private _cnn As String
    Public Mdlrpt As XtraReport
    Public MdluserCtrl As Object
    Public isOpenNotes As Boolean = False
    Public MdlIdUsuario As String

    Public ReadOnly Property cnnString As String
        Get
            Return _cnn
        End Get
    End Property

    Public Sub setConectionString(ByVal server As String, ByVal bdd As String, ByVal user As String, ByVal pwd As String)
        _cnn = String.Format("Server={0};Database={1};User Id={2};Password={3};Current Language=español;", server, bdd, user, pwd)
    End Sub

    Public Sub CapturaNota(sender As System.Object, e As PreviewMouseEventArgs)
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        If TypeOf s.Tag Is String Then ' cuando es por registros
            Dim strAnt As String = e.Brick.Text
            frm = New Frm_Captura_Notas(e.Brick.Text)
            If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
                Dim cnt As String = ""
                If Not e.Brick.Text.Contains("Click") Then
                    For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas
                        If kvp.Value = strAnt Then
                            cnt = kvp.Key
                            Exit For
                        End If
                    Next
                    MdluserCtrl.notas(cnt) = frm.txtNota.Text
                Else
                    cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                    MdluserCtrl.notas.Add(cnt, frm.txtNota.Text)
                End If
                Mdlrpt.CreateDocument()
            End If
        Else 'Cuando es parametros
            Dim prm = DirectCast(s.Tag, Parameter)
            frm = New Frm_Captura_Notas(prm)
            If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
                Mdlrpt.Parameters(prm.Name).Value = frm.txtNota.Text
                Mdlrpt.CreateDocument()
            End If
        End If

    End Sub

    Public Sub ctrlMouseUp(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs)
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Public Sub EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs)
        
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c = "" Then
                Exit Sub
            End If
            e.Value = MdluserCtrl.notas(c)
        End If
    End Sub

    Public Function GetLevel(ByVal idUsr As Integer) As Integer
        Dim cmd2 As New SqlCommand("Select NivelAutorizacion From C_Usuarios Where IdUsuario =" & idUsr, New SqlConnection(cnnString))

        Try
            cmd2.Connection.Open()
            Dim reader2 = cmd2.ExecuteScalar()
            Return reader2
        Catch ex As Exception
            Throw ex
        Finally
            cmd2.Connection.Close()
        End Try

    End Function
    Public Function GetFiltrarXUR(ByVal idUsr As Integer) As Integer
        Dim cmd2 As New SqlCommand("Select FiltraReportesxUR From C_Usuarios Where IdUsuario =" & idUsr, New SqlConnection(cnnString))

        Try
            cmd2.Connection.Open()
            Dim reader2 = cmd2.ExecuteScalar()
            Return reader2
        Catch ex As Exception
            Throw ex
        Finally
            cmd2.Connection.Close()
        End Try

    End Function

    Public Function GetIdUR(ByVal idusr As Integer) As Integer

        Dim cmd2 As New SqlCommand("Select IdAreaRespPresupuestal From C_Empleados Where NumeroEmpleado = (Select NumeroEmpleado from C_Usuarios where IdUsuario =" & idusr & ")", New SqlConnection(cnnString))
        Try
            cmd2.Connection.Open()
            Dim reader2 = cmd2.ExecuteScalar()
            If reader2 = Nothing Then
                MessageBox.Show("No se encontró Area de Responsabilidad")
            End If
            Return reader2
        Catch ex As Exception
            Throw ex
        Finally
            cmd2.Connection.Close()
        End Try
    End Function

End Module
