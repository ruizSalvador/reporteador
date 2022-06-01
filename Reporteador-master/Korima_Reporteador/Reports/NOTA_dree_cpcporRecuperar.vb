Imports DevExpress.XtraReports.UI
Public Class NOTA_dree_cpcporRecuperar


    Private Sub XrTableCell1_PreviewMouseMove(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell1.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub


    Private Sub XrTableCell1_PreviewClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrTableCell1.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

End Class

