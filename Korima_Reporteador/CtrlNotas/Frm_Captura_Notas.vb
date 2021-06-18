Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraReports.Parameters
Imports DevExpress.XtraPrinting
Imports System.Data.SqlClient

Public Class Frm_Captura_Notas
    Private isParametro As Boolean = False

    Public Sub New(ByVal prm As Parameter)
        InitializeComponent()
        lblTexto.Text = prm.Description
        If Not prm.Value.ToString().Contains("Click") Then
            txtNota.Text = prm.Value
        End If
        txtNota.Select()
        isParametro = True
    End Sub

    Public Sub New(ByVal text As String)
        InitializeComponent()
        lblTexto.Text = "Describa:"
        If Not text.Contains("Click") Then
            txtNota.Text = text
        End If
        txtNota.Select()
    End Sub

    Private Sub btnEnviar_Click(sender As System.Object, e As System.EventArgs) Handles btnEnviar.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        isOpenNotes = False
        Me.Close()
    End Sub

    Private Sub btnCancelar_Click(sender As System.Object, e As System.EventArgs) Handles btnCancelar.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        isOpenNotes = False
        Me.Close()
    End Sub

    Private Sub Frm_Captura_Notas_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        isOpenNotes = True
    End Sub
End Class