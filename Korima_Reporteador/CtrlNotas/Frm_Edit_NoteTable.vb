Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraReports.Parameters
Imports DevExpress.XtraPrinting
Imports System.Data.SqlClient

Public Class Frm_Edit_NoteTable
    Public dsNotas As DataSet

    Public Sub New(ByVal CampoLlave As String, ByVal CamposNotas As List(Of String), ByVal ds As DataSet, ByVal exceptions As List(Of String))

        ' This call is required by the designer.
        InitializeComponent()

        dsNotas = ds.Clone()
        For Each dr As DataRow In ds.Tables(0).Rows
            If exceptions.Contains(dr(CampoLlave)) Then
                Continue For
            End If
            dsNotas.Tables(0).ImportRow(dr)
        Next

        dgEditNotas.AutoGenerateColumns = False
        dgEditNotas.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        dgEditNotas.DataSource = dsNotas.Tables(0).DefaultView

        Dim clmLlave As New DataGridViewTextBoxColumn()
        clmLlave.ReadOnly = True
        clmLlave.HeaderText = "Cuenta"
        clmLlave.ValueType = ds.Tables(0).Columns(CampoLlave).DataType
        clmLlave.DataPropertyName = CampoLlave

        dgEditNotas.Columns.Add(clmLlave)

        Dim clmCampoNota As DataGridViewTextBoxColumn
        For Each col As String In CamposNotas
            clmCampoNota = New DataGridViewTextBoxColumn()
            clmCampoNota.ReadOnly = False
            clmCampoNota.HeaderText = col
            clmCampoNota.ValueType = ds.Tables(0).Columns(col).DataType
            clmCampoNota.DataPropertyName = col

            dgEditNotas.Columns.Add(clmCampoNota)
        Next

        dgEditNotas.Refresh()
        ' Add any initialization after the InitializeComponent() call.
    End Sub

    Private Sub btnAceptar_Click(sender As System.Object, e As System.EventArgs) Handles btnAceptar.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub btnCancelar_Click(sender As System.Object, e As System.EventArgs) Handles btnCancelar.Click
        dsNotas = Nothing
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub dgEditNotas_DataError(sender As System.Object, e As System.Windows.Forms.DataGridViewDataErrorEventArgs) Handles dgEditNotas.DataError
        MessageBox.Show("Formato incorrecto", "", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)

    End Sub
End Class