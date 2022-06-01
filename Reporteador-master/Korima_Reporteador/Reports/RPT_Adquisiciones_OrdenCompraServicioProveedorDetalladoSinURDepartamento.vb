Imports System
Imports System.Drawing
Imports DevExpress.XtraReports.UI
Public Class RPT_Adquisiciones_OrdenCompraServicioProveedorDetalladoSinURDepartamento

    Private Sub RPT_Adquisiciones_OrdenCompraServicioProveedorDetalladoSinURDepartamento_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles MyBase.BeforePrint
        Detail.SortFields.Add(New GroupField("PedidosDetalle_OrdenCompra", XRColumnSortOrder.Ascending))
    End Sub
End Class