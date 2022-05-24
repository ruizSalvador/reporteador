﻿Imports DevExpress.XtraReports.UI


Public Class NOTA_nm_contables

    Private Sub XrLabel2_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs) Handles XrLabel2.EvaluateBinding
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
        End If

    End Sub

    Private Sub XrLabel2_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel2.PreviewClick
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

End Class

