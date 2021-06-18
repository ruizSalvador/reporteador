Imports DevExpress.XtraReports.UI
Public Class RPT_ClasifFuncionalFinalidadFuncion

#Region "EventosAntiguos"
    Private Sub lbl_prmTipo_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) 'Handles lbl_prmTipo.PreviewClick
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

    Private Sub lbl_prmTipo_EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs) 'Handles lbl_prmTipo.EvaluateBinding
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

    Private Sub lbl_prmNaturaleza_EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs) 'Handles lbl_prmNaturaleza.EvaluateBinding
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

    Private Sub lbl_prmNaturaleza_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) 'Handles lbl_prmNaturaleza.PreviewClick
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

    Private Sub XrLabel18_EvaluateBinding(sender As System.Object, e As DevExpress.XtraReports.UI.BindingEventArgs) 'Handles lbl_XrLabel18.EvaluateBinding
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
            If c <> "" Then
                e.Value = MdluserCtrl.notas3(c)
            End If
        End If
    End Sub

    Private Sub XrLabel18_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) 'Handles lbl_XrLabel18.PreviewClick
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
#End Region


    Private Sub lbl_prmTipo_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prmTipo.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lbl_prmTipo_PreviewClick_1(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prmTipo.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub lbl_prmNaturaleza_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prmNaturaleza.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lbl_prmNaturaleza_PreviewClick_1(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_prmNaturaleza.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub lbl_XrLabel18_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_XrLabel18.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lbl_XrLabel18_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_XrLabel18.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel19_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel19.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel19_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel19.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel20_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel20.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel20_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel20.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel21_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel21.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel21_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel21.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub
End Class