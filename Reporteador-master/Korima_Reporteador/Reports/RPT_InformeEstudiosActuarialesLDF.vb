Imports DevExpress.XtraReports.UI
Public Class RPT_InformeEstudiosActuarialesLDF

    Private Sub lblDetail_Pensiones_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Pensiones.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lblDetail_Pensiones_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Pensiones.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    'lblDetail_Salud
    Private Sub lblDetail_Salud_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Salud.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub lblDetail_Salud_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Salud.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    'lblDetail_Riesgos
    Private Sub lblDetail_Riesgos_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Riesgos.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub
    '
    Private Sub lblDetail_Riesgos_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Riesgos.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    'lblDetail_Invalidez
    Private Sub lblDetail_Invalidez_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Invalidez.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub
    '
    Private Sub lblDetail_Invalidez_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_Invalidez.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    'lblDetail_OtrasPrestaciones
    Private Sub lblDetail_OtrasPrestaciones_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_OtrasPrestaciones.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub
    '
    Private Sub lblDetail_OtrasPrestaciones_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles lblDetail_OtrasPrestaciones.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub
End Class