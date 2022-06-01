Public Class FRM_WikoErrorSender

    Private Sub Button1_Click(sender As System.Object, e As System.EventArgs) Handles Button1.Click
        Me.Close()
    End Sub

    Private Sub HLDetalles_OpenLink(sender As System.Object, e As DevExpress.XtraEditors.Controls.OpenLinkEventArgs) Handles HLDetalles.OpenLink
        If HLDetalles.Text = "Mostrar detalles..." Then
            HLDetalles.Text = "Ocultar detalles..."
            Me.Height = 284
        Else
            HLDetalles.Text = "Mostrar detalles..."
            Me.Height = 170

        End If
    End Sub

    Private Sub FRM_WikoErrorSender_Leave(sender As Object, e As System.EventArgs) Handles Me.Leave

    End Sub

    Private Sub FRM_WikoErrorSender_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Me.Height = 170
    End Sub
End Class