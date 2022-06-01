<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_FirmasHorizontal
    Inherits DevExpress.XtraReports.UI.XtraReport

    'XtraReport overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.panel1 = New DevExpress.XtraReports.UI.XRPanel()
        Me.label1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.label9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.VW_RPT_K2_FirmasTableAdapter = New System.Data.OleDb.OleDbDataAdapter()
        Me.oleDbCommand1 = New System.Data.OleDb.OleDbCommand()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.panel1})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 248.8185!
        Me.Detail.Name = "Detail"
        '
        'panel1
        '
        Me.panel1.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.panel1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label1, Me.label3, Me.label4, Me.label2})
        Me.panel1.Dpi = 254.0!
        Me.panel1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.panel1.Name = "panel1"
        Me.panel1.SizeF = New System.Drawing.SizeF(2495.0!, 248.8185!)
        Me.panel1.StylePriority.UseBorders = False
        '
        'label1
        '
        Me.label1.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label1.BorderWidth = 2
        Me.label1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Firmas.Nombre1")})
        Me.label1.Dpi = 254.0!
        Me.label1.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label1.LocationFloat = New DevExpress.Utils.PointFloat(156.6554!, 127.2205!)
        Me.label1.Name = "label1"
        Me.label1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label1.ProcessNullValues = DevExpress.XtraReports.UI.ValueSuppressType.Suppress
        Me.label1.SizeF = New System.Drawing.SizeF(889.0!, 58.42001!)
        Me.label1.StylePriority.UseBorders = False
        Me.label1.StylePriority.UseBorderWidth = False
        Me.label1.StylePriority.UseFont = False
        Me.label1.StylePriority.UseTextAlignment = False
        Me.label1.Text = "label1"
        Me.label1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'label3
        '
        Me.label3.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label3.BorderWidth = 2
        Me.label3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Firmas.Nombre2")})
        Me.label3.Dpi = 254.0!
        Me.label3.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label3.LocationFloat = New DevExpress.Utils.PointFloat(1417.979!, 127.2205!)
        Me.label3.Name = "label3"
        Me.label3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label3.ProcessNullValues = DevExpress.XtraReports.UI.ValueSuppressType.Suppress
        Me.label3.SizeF = New System.Drawing.SizeF(898.5627!, 58.42001!)
        Me.label3.StylePriority.UseBorders = False
        Me.label3.StylePriority.UseBorderWidth = False
        Me.label3.StylePriority.UseFont = False
        Me.label3.StylePriority.UseTextAlignment = False
        Me.label3.Text = "label3"
        Me.label3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'label4
        '
        Me.label4.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.label4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Firmas.Puesto2")})
        Me.label4.Dpi = 254.0!
        Me.label4.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label4.LocationFloat = New DevExpress.Utils.PointFloat(1417.979!, 185.6405!)
        Me.label4.Name = "label4"
        Me.label4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label4.ProcessNullValues = DevExpress.XtraReports.UI.ValueSuppressType.Suppress
        Me.label4.SizeF = New System.Drawing.SizeF(898.5626!, 58.42001!)
        Me.label4.StylePriority.UseBorders = False
        Me.label4.StylePriority.UseFont = False
        Me.label4.StylePriority.UseTextAlignment = False
        Me.label4.Text = "label4"
        Me.label4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'label2
        '
        Me.label2.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.label2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Firmas.Puesto1")})
        Me.label2.Dpi = 254.0!
        Me.label2.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label2.LocationFloat = New DevExpress.Utils.PointFloat(156.6554!, 185.6405!)
        Me.label2.Name = "label2"
        Me.label2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label2.ProcessNullValues = DevExpress.XtraReports.UI.ValueSuppressType.Suppress
        Me.label2.SizeF = New System.Drawing.SizeF(889.0!, 58.42001!)
        Me.label2.StylePriority.UseBorders = False
        Me.label2.StylePriority.UseFont = False
        Me.label2.StylePriority.UseTextAlignment = False
        Me.label2.Text = "label2"
        Me.label2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'label5
        '
        Me.label5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label5.Dpi = 254.0!
        Me.label5.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.label5.Name = "label5"
        Me.label5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label5.SizeF = New System.Drawing.SizeF(2495.0!, 13.22917!)
        Me.label5.StylePriority.UseBorders = False
        '
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 53.0!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Visible = False
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 94.0!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Visible = False
        '
        'label9
        '
        Me.label9.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.label9.Dpi = 254.0!
        Me.label9.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label9.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.label9.Name = "label9"
        Me.label9.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label9.SizeF = New System.Drawing.SizeF(2495.0!, 95.46167!)
        Me.label9.StylePriority.UseBorders = False
        Me.label9.StylePriority.UseFont = False
        Me.label9.StylePriority.UseTextAlignment = False
        Me.label9.Text = """Bajo protesta de decir verdad declaramos que los estados financieros y sus notas" & _
    ", son razonablemente correctos y son responsabilidad del emisor."""
        Me.label9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'VW_RPT_K2_FirmasTableAdapter
        '
        Me.VW_RPT_K2_FirmasTableAdapter.SelectCommand = Me.oleDbCommand1
        Me.VW_RPT_K2_FirmasTableAdapter.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "VW_RPT_K2_Firmas", New System.Data.Common.DataColumnMapping(-1) {})})
        '
        'oleDbCommand1
        '
        Me.oleDbCommand1.CommandText = "Select [Formato], [NombreOriginal], [Nombre1], [Puesto1], [Nombre2], [Puesto2] fr" & _
    "om [dbo].[VW_RPT_K2_Firmas]"
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label5})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 13.22917!
        Me.GroupFooter1.Name = "GroupFooter1"
        Me.GroupFooter1.RepeatEveryPage = True
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label9})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("Formato", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 95.46167!
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.RepeatEveryPage = True
        '
        'RPT_FirmasHorizontal
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMargin, Me.Detail, Me.BottomMargin, Me.GroupHeader1, Me.GroupFooter1})
        Me.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.DataAdapter = Me.VW_RPT_K2_FirmasTableAdapter
        Me.DataMember = "VW_RPT_K2_Firmas"
        Me.Dpi = 254.0!
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(201, 98, 94, 53)
        Me.PageHeight = 2159
        Me.PageWidth = 2794
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents panel1 As DevExpress.XtraReports.UI.XRPanel
    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents label9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents VW_RPT_K2_FirmasTableAdapter As System.Data.OleDb.OleDbDataAdapter
    Friend WithEvents oleDbCommand1 As System.Data.OleDb.OleDbCommand
    'Friend ds As XtraReportSerialization.dsDataSet
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    'Friend ds As XtraReportSerialization.dsDataSet
End Class
