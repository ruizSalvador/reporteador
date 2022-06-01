Imports DevExpress.XtraReports.UI

Public Class NOTA_dreoe_dreeybsrv

   


    Private Sub XrLabel6_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs)
        If isOpenNotes Or e.Brick.Text = "BLANCO" Then
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

    Private Sub XrLabel6_EvaluateBinding(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.BindingEventArgs)
        If (MdluserCtrl Is Nothing) Or e.Value = "BLANCO" Then
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

    Private Sub XrTableCell1_PreviewMouseMove(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell1.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub


    Private Sub XrTableCell1_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell1.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrTableCell2_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell2.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrTableCell2_PreviewMouseMove(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell2.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrTableCell3_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell3.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrTableCell3_PreviewMouseMove(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell3.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub
End Class