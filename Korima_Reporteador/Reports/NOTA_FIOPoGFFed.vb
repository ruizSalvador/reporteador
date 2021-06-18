Imports DevExpress.XtraReports.UI
Public Class NOTA_FIOPoGFFed

    Private Sub lbl_prm1_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm1.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas1
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas1(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas1.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If

    End Sub

    Private Sub lbl_prm1_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm1.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas1.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas1(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas1
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas1(c)
            End If
        End If

    End Sub

    Private Sub lbl_prm2_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm2.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas2.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas2(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas2
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas2(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm2_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm2.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas2
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas2(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas2.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm3_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm3.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas3.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas3(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas3
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            e.Value = MdluserCtrl.notas3(c)
        End If
    End Sub

    Private Sub lbl_prm3_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm3.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas3
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas3(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas3.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm4_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm4.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas4.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas4(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas4
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas4(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm4_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm4.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas4
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas4(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas4.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm5_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm5.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas5.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas5(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas5
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas5(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm5_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm5.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas5
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas5(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas5.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub


    Private Sub lbl_prm6_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm6.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas6.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas6(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas6
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas6(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm6_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm6.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas6
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas6(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas6.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm7_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm7.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas7.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas7(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas7
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas7(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm7_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm7.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas7
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas7(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas7.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm8_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm8.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas8.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas8(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas8
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas8(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm8_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm8.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas8
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas8(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas8.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm9_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm9.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas9.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas9(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas9
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas9(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm9_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm9.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas9
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas9(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas9.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

    Private Sub lbl_prm10_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_prm10.EvaluateBinding
        If (MdluserCtrl Is Nothing) Then
            Exit Sub
        End If
        If e.Value.ToString.Contains("Click") Then
            Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
            If MdluserCtrl.notas10.ContainsKey(cnt) Then
                e.Value = MdluserCtrl.notas10(cnt)
            End If
        Else
            Dim c As String = ""
            For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas10
                If k.Value = e.Value Then
                    c = k.Key
                    Exit For
                End If
            Next
            If c <> "" Then
                e.Value = MdluserCtrl.notas10(c)
            End If
        End If
    End Sub

    Private Sub lbl_prm10_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prm10.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        Dim s As XRLabel = DirectCast(sender, XRLabel)

        Dim frm As Frm_Captura_Notas
        Dim strAnt As String = e.Brick.Text
        frm = New Frm_Captura_Notas(e.Brick.Text)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim cnt As String = ""
            If Not e.Brick.Text.Contains("Click") Then
                For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas10
                    If kvp.Value = strAnt Then
                        cnt = kvp.Key
                        Exit For
                    End If
                Next
                MdluserCtrl.notas10(cnt) = frm.txtNota.Text
            Else
                cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
                MdluserCtrl.notas10.Add(cnt, frm.txtNota.Text)
            End If
            Mdlrpt.CreateDocument()
        End If
    End Sub

   
End Class