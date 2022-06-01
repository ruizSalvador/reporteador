Imports DevExpress.XtraReports.UI

Public Class NOTA_BMI_ARMSCSC
    
    Private Sub lbl_Notas_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell2.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)

    End Sub

    Private Sub XrTableCell2_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell2.PreviewMouseMove, lbl_Notas2.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lbl_Notas2_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lbl_Notas2.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)

    End Sub
End Class