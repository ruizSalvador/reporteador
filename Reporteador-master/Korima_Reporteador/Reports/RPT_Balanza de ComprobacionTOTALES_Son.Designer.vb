<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_Balanza_de_ComprobacionTOTALES_Son
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
        Dim XrSummary1 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary2 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary3 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary4 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary5 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary6 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary7 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary8 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary9 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Dim XrSummary10 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label20 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label21 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label22 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label19 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label23 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.DsNotasBenn1 = New Korima_Reporteador.dsNotasBenn()
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel4, Me.XrLabel3, Me.XrLabel2, Me.XrLabel1, Me.label20, Me.label21, Me.label22, Me.label19, Me.label23, Me.label17, Me.label18})
        Me.Detail.HeightF = 23.00002!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel4
        '
        Me.XrLabel4.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.XrLabel4.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel4.BorderWidth = 3
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.SaldoAcreedorPrevia", "{0:n2}")})
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(1464.698!, 0.00003178914!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.XrLabel4.StylePriority.UseBorderDashStyle = False
        Me.XrLabel4.StylePriority.UseBorders = False
        Me.XrLabel4.StylePriority.UseBorderWidth = False
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        Me.XrLabel4.Summary = XrSummary1
        Me.XrLabel4.Text = "XrLabel4"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel3
        '
        Me.XrLabel3.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.XrLabel3.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel3.BorderWidth = 3
        Me.XrLabel3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.SaldoDeudorPrevia", "{0:n2}")})
        Me.XrLabel3.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(1329.132!, 0.0!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.XrLabel3.StylePriority.UseBorderDashStyle = False
        Me.XrLabel3.StylePriority.UseBorders = False
        Me.XrLabel3.StylePriority.UseBorderWidth = False
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        Me.XrLabel3.Summary = XrSummary2
        Me.XrLabel3.Text = "XrLabel3"
        Me.XrLabel3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel2
        '
        Me.XrLabel2.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.XrLabel2.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel2.BorderWidth = 3
        Me.XrLabel2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.TotalAbonosIngEgr", "{0:n2}")})
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(1193.566!, 0.00003178914!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.XrLabel2.StylePriority.UseBorderDashStyle = False
        Me.XrLabel2.StylePriority.UseBorders = False
        Me.XrLabel2.StylePriority.UseBorderWidth = False
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        XrSummary3.FormatString = "{0:n2}"
        Me.XrLabel2.Summary = XrSummary3
        Me.XrLabel2.Text = "XrLabel2"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel1
        '
        Me.XrLabel1.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.XrLabel1.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel1.BorderWidth = 3
        Me.XrLabel1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.TotalCargosIngEgr", "{0:n2}")})
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(1058.0!, 0.0!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.XrLabel1.StylePriority.UseBorderDashStyle = False
        Me.XrLabel1.StylePriority.UseBorders = False
        Me.XrLabel1.StylePriority.UseBorderWidth = False
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        XrSummary4.FormatString = "{0:n2}"
        Me.XrLabel1.Summary = XrSummary4
        Me.XrLabel1.Text = "XrLabel1"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label20
        '
        Me.label20.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label20.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label20.BorderWidth = 3
        Me.label20.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.TotalAbonos", "{0:n2}")})
        Me.label20.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label20.LocationFloat = New DevExpress.Utils.PointFloat(652.9286!, 0.00003178914!)
        Me.label20.Name = "label20"
        Me.label20.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label20.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.label20.StylePriority.UseBorderDashStyle = False
        Me.label20.StylePriority.UseBorders = False
        Me.label20.StylePriority.UseBorderWidth = False
        Me.label20.StylePriority.UseFont = False
        Me.label20.StylePriority.UseTextAlignment = False
        XrSummary5.FormatString = "{0:n2}"
        Me.label20.Summary = XrSummary5
        Me.label20.Text = "label20"
        Me.label20.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label21
        '
        Me.label21.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label21.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label21.BorderWidth = 3
        Me.label21.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.SaldoDeudor", "{0:n2}")})
        Me.label21.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label21.LocationFloat = New DevExpress.Utils.PointFloat(788.4944!, 0.0!)
        Me.label21.Name = "label21"
        Me.label21.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label21.SizeF = New System.Drawing.SizeF(133.9399!, 22.99998!)
        Me.label21.StylePriority.UseBorderDashStyle = False
        Me.label21.StylePriority.UseBorders = False
        Me.label21.StylePriority.UseBorderWidth = False
        Me.label21.StylePriority.UseFont = False
        Me.label21.StylePriority.UseTextAlignment = False
        XrSummary6.FormatString = "{0:n2}"
        Me.label21.Summary = XrSummary6
        Me.label21.Text = "label21"
        Me.label21.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label22
        '
        Me.label22.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label22.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label22.BorderWidth = 3
        Me.label22.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.SaldoAcreedor", "{0:n2}")})
        Me.label22.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label22.LocationFloat = New DevExpress.Utils.PointFloat(922.4343!, 0.0!)
        Me.label22.Name = "label22"
        Me.label22.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label22.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.label22.StylePriority.UseBorderDashStyle = False
        Me.label22.StylePriority.UseBorders = False
        Me.label22.StylePriority.UseBorderWidth = False
        Me.label22.StylePriority.UseFont = False
        Me.label22.StylePriority.UseTextAlignment = False
        XrSummary7.FormatString = "{0:n2}"
        Me.label22.Summary = XrSummary7
        Me.label22.Text = "label22"
        Me.label22.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label19
        '
        Me.label19.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label19.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label19.BorderWidth = 3
        Me.label19.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.TotalCargos", "{0:n2}")})
        Me.label19.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label19.LocationFloat = New DevExpress.Utils.PointFloat(517.3629!, 0.0!)
        Me.label19.Name = "label19"
        Me.label19.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label19.SizeF = New System.Drawing.SizeF(135.5658!, 22.99998!)
        Me.label19.StylePriority.UseBorderDashStyle = False
        Me.label19.StylePriority.UseBorders = False
        Me.label19.StylePriority.UseBorderWidth = False
        Me.label19.StylePriority.UseFont = False
        Me.label19.StylePriority.UseTextAlignment = False
        XrSummary8.FormatString = "{0:n2}"
        Me.label19.Summary = XrSummary8
        Me.label19.Text = "label19"
        Me.label19.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label23
        '
        Me.label23.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label23.LocationFloat = New DevExpress.Utils.PointFloat(89.68436!, 0.0!)
        Me.label23.Name = "label23"
        Me.label23.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label23.SizeF = New System.Drawing.SizeF(133.3333!, 23.0!)
        Me.label23.StylePriority.UseFont = False
        Me.label23.Text = "TOTAL GENERAL :"
        '
        'label17
        '
        Me.label17.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label17.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label17.BorderWidth = 3
        Me.label17.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.CargosSinFlujo", "{0:n2}")})
        Me.label17.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label17.LocationFloat = New DevExpress.Utils.PointFloat(223.0177!, 0.0!)
        Me.label17.Name = "label17"
        Me.label17.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label17.SizeF = New System.Drawing.SizeF(140.625!, 22.99998!)
        Me.label17.StylePriority.UseBorderDashStyle = False
        Me.label17.StylePriority.UseBorders = False
        Me.label17.StylePriority.UseBorderWidth = False
        Me.label17.StylePriority.UseFont = False
        Me.label17.StylePriority.UseTextAlignment = False
        XrSummary9.FormatString = "{0:n2}"
        Me.label17.Summary = XrSummary9
        Me.label17.Text = "label17"
        Me.label17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label18
        '
        Me.label18.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label18.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label18.BorderWidth = 3
        Me.label18.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion.AbonosSinFlujo", "{0:n2}")})
        Me.label18.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label18.LocationFloat = New DevExpress.Utils.PointFloat(363.6426!, 0.0!)
        Me.label18.Name = "label18"
        Me.label18.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label18.SizeF = New System.Drawing.SizeF(153.7202!, 22.99998!)
        Me.label18.StylePriority.UseBorderDashStyle = False
        Me.label18.StylePriority.UseBorders = False
        Me.label18.StylePriority.UseBorderWidth = False
        Me.label18.StylePriority.UseFont = False
        Me.label18.StylePriority.UseTextAlignment = False
        XrSummary10.FormatString = "{0:n2}"
        Me.label18.Summary = XrSummary10
        Me.label18.Text = "label18"
        Me.label18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'TopMargin
        '
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        Me.TopMargin.Visible = False
        '
        'BottomMargin
        '
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        Me.BottomMargin.Visible = False
        '
        'DsNotasBenn1
        '
        Me.DsNotasBenn1.DataSetName = "dsNotasBenn"
        Me.DsNotasBenn1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'RPT_Balanza_de_ComprobacionTOTALES_Son
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin})
        Me.DataMember = "VW_RPT_K2_Balanza_De_Comprobacion"
        Me.DataSource = Me.DsNotasBenn1
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(0, 11, 100, 100)
        Me.PageHeight = 850
        Me.PageWidth = 1630
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.Version = "11.1"
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents label20 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label21 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label22 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label19 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label23 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DsNotasBenn1 As Korima_Reporteador.dsNotasBenn
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
End Class
