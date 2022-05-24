Imports DevExpress.XtraReports.UI
Public Class NOTA_MPAS


    Private Sub lbl_prmTipo_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs)
        'If isOpenNotes Then
        '    Exit Sub
        'End If
        'Dim s As XRLabel = DirectCast(sender, XRLabel)

        'Dim frm As Frm_Captura_Notas
        'Dim strAnt As String = e.Brick.Text
        'frm = New Frm_Captura_Notas(e.Brick.Text)
        'If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
        '    Dim cnt As String = ""
        '    If Not e.Brick.Text.Contains("Click") Then
        '        For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas1
        '            If kvp.Value = strAnt Then
        '                cnt = kvp.Key
        '                Exit For
        '            End If
        '        Next
        '        MdluserCtrl.notas1(cnt) = frm.txtNota.Text
        '    Else
        '        cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
        '        MdluserCtrl.notas1.Add(cnt, frm.txtNota.Text)
        '    End If
        '    Mdlrpt.CreateDocument()
        'End If

    End Sub

    Private Sub lbl_prmTipo_EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs)
        'If (MdluserCtrl Is Nothing) Then
        '    Exit Sub
        'End If
        'If e.Value.ToString.Contains("Click") Then
        '    Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
        '    If MdluserCtrl.notas1.ContainsKey(cnt) Then
        '        e.Value = MdluserCtrl.notas1(cnt)
        '    End If
        'Else
        '    Dim c As String = ""
        '    For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas1
        '        If k.Value = e.Value Then
        '            c = k.Key
        '            Exit For
        '        End If
        '    Next
        '    e.Value = MdluserCtrl.notas1(c)
        'End If

    End Sub

    'Private Sub lbl_prmNaturaleza_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs)
    '    If (MdluserCtrl Is Nothing) Then
    '        Exit Sub
    '    End If
    '    If e.Value.ToString.Contains("Click") Then
    '        Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
    '        If MdluserCtrl.notas2.ContainsKey(cnt) Then
    '            e.Value = MdluserCtrl.notas2(cnt)
    '        End If
    '    Else
    '        Dim c As String = ""
    '        For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas2
    '            If k.Value = e.Value Then
    '                c = k.Key
    '                Exit For
    '            End If
    '        Next
    '        e.Value = MdluserCtrl.notas2(c)
    '    End If
    'End Sub

    'Private Sub lbl_prmNaturaleza_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs)
    '    If isOpenNotes Then
    '        Exit Sub
    '    End If

    '    Dim s As XRLabel = DirectCast(sender, XRLabel)

    '    Dim frm As Frm_Captura_Notas
    '    Dim strAnt As String = e.Brick.Text
    '    frm = New Frm_Captura_Notas(e.Brick.Text)
    '    If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
    '        Dim cnt As String = ""
    '        If Not e.Brick.Text.Contains("Click") Then
    '            For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas2
    '                If kvp.Value = strAnt Then
    '                    cnt = kvp.Key
    '                    Exit For
    '                End If
    '            Next
    '            MdluserCtrl.notas2(cnt) = frm.txtNota.Text
    '        Else
    '            cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
    '            MdluserCtrl.notas2.Add(cnt, frm.txtNota.Text)
    '        End If
    '        Mdlrpt.CreateDocument()
    '    End If
    'End Sub

    'Private Sub lbl_Nota31_EvaluateBinding(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs)

    '    If (MdluserCtrl Is Nothing) Then
    '        Exit Sub
    '    End If
    '    If e.Value.ToString.Contains("Click") Then
    '        Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
    '        If MdluserCtrl.notas31.ContainsKey(cnt) Then
    '            e.Value = MdluserCtrl.notas31(cnt)
    '        End If
    '    Else
    '        Dim c As String = ""
    '        For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas31
    '            If k.Value = e.Value Then
    '                c = k.Key
    '                Exit For
    '            End If
    '        Next
    '        e.Value = MdluserCtrl.notas31(c)
    '    End If




    'End Sub

    'Private Sub lbl_Nota31_PreviewClick(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs)

    '    If isOpenNotes Then
    '        Exit Sub
    '    End If

    '    Dim s As XRLabel = DirectCast(sender, XRLabel)

    '    Dim frm As Frm_Captura_Notas
    '    Dim strAnt As String = e.Brick.Text
    '    frm = New Frm_Captura_Notas(e.Brick.Text)
    '    If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
    '        Dim cnt As String = ""
    '        If Not e.Brick.Text.Contains("Click") Then
    '            For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas31
    '                If kvp.Value = strAnt Then
    '                    cnt = kvp.Key
    '                    Exit For
    '                End If
    '            Next
    '            MdluserCtrl.notas31(cnt) = frm.txtNota.Text
    '        Else
    '            cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
    '            MdluserCtrl.notas31.Add(cnt, frm.txtNota.Text)
    '        End If
    '        Mdlrpt.CreateDocument()
    '    End If


    'End Sub


    'Private Sub lbl_Nota3_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_Nota3.PreviewClick
    '    If isOpenNotes Then
    '        Exit Sub
    '    End If

    '    Dim s As XRLabel = DirectCast(sender, XRLabel)

    '    Dim frm As Frm_Captura_Notas
    '    Dim strAnt As String = e.Brick.Text
    '    frm = New Frm_Captura_Notas(e.Brick.Text)
    '    If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
    '        Dim cnt As String = ""
    '        If Not e.Brick.Text.Contains("Click") Then
    '            For Each kvp As KeyValuePair(Of String, String) In MdluserCtrl.notas3
    '                If kvp.Value = strAnt Then
    '                    cnt = kvp.Key
    '                    Exit For
    '                End If
    '            Next
    '            MdluserCtrl.notas3(cnt) = frm.txtNota.Text
    '        Else
    '            cnt = Mid(e.Brick.Text, 1, e.Brick.Text.IndexOf("Click") - 1)
    '            MdluserCtrl.notas3.Add(cnt, frm.txtNota.Text)
    '        End If
    '        Mdlrpt.CreateDocument()
    '    End If
    'End Sub

    'Private Sub lbl_Nota3_EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs) Handles lbl_Nota3.EvaluateBinding
    '    If (MdluserCtrl Is Nothing) Then
    '        Exit Sub
    '    End If
    '    If e.Value.ToString.Contains("Click") Then
    '        Dim cnt As String = Mid(e.Value, 1, e.Value.ToString().IndexOf("Click") - 1)
    '        If MdluserCtrl.notas3.ContainsKey(cnt) Then
    '            e.Value = MdluserCtrl.notas3(cnt)
    '        End If
    '    Else
    '        Dim c As String = ""
    '        For Each k As KeyValuePair(Of String, String) In MdluserCtrl.notas3
    '            If k.Value = e.Value Then
    '                c = k.Key
    '                Exit For
    '            End If
    '        Next
    '        e.Value = MdluserCtrl.notas3(c)
    '    End If
    'End Sub

End Class