<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class SUBRPT_TotalEdoActividades
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
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.label1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Negritas4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.negritas5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.label10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.year2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.year1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Visible5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.visible4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.line3 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLabel7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.DsEnrique1 = New Korima_Reporteador.DSEnrique()
        Me.VW_RPT_CFG_DatosEntesTableAdapter1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter()
        Me.calculatedField1 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.calculatedField2 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.calculatedField3 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.CalculatedField4 = New DevExpress.XtraReports.UI.CalculatedField()
        CType(Me.DsEnrique1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label1, Me.label10, Me.label9, Me.label6})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 82.0!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        Me.Detail.Visible = False
        '
        'label1
        '
        Me.label1.AutoWidth = True
        Me.label1.CanShrink = True
        Me.label1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.MaskNombreCuenta")})
        Me.label1.Dpi = 254.0!
        Me.label1.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.label1.FormattingRules.Add(Me.Negritas4)
        Me.label1.FormattingRules.Add(Me.negritas5)
        Me.label1.LocationFloat = New DevExpress.Utils.PointFloat(25.40002!, 0.0!)
        Me.label1.Multiline = True
        Me.label1.Name = "label1"
        Me.label1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label1.SizeF = New System.Drawing.SizeF(1902.333!, 39.98163!)
        Me.label1.StylePriority.UseFont = False
        Me.label1.Text = "label1"
        '
        'Negritas4
        '
        Me.Negritas4.Condition = "[NumeroCuenta] like '4_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '4_0000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[" & _
    "NumeroCuenta] like '4_000-000000' "
        '
        '
        '
        Me.Negritas4.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas4.Name = "Negritas4"
        '
        'negritas5
        '
        Me.negritas5.Condition = "[NumeroCuenta] like '5_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '5_0000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[" & _
    "NumeroCuenta] like '5_000-000000'"
        '
        '
        '
        Me.negritas5.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.negritas5.Name = "negritas5"
        '
        'label10
        '
        Me.label10.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label10.CanGrow = False
        Me.label10.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField2", "{0:n2}")})
        Me.label10.Dpi = 254.0!
        Me.label10.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label10.LocationFloat = New DevExpress.Utils.PointFloat(2343.15!, 0.0!)
        Me.label10.Name = "label10"
        Me.label10.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label10.SizeF = New System.Drawing.SizeF(406.6108!, 42.12166!)
        Me.label10.StylePriority.UseFont = False
        Me.label10.StylePriority.UseTextAlignment = False
        Me.label10.Text = "label10"
        Me.label10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label9
        '
        Me.label9.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label9.CanGrow = False
        Me.label9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField1", "{0:n2}")})
        Me.label9.Dpi = 254.0!
        Me.label9.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label9.LocationFloat = New DevExpress.Utils.PointFloat(1930.4!, 0.0!)
        Me.label9.Name = "label9"
        Me.label9.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label9.SizeF = New System.Drawing.SizeF(406.8236!, 42.12166!)
        Me.label9.StylePriority.UseFont = False
        Me.label9.StylePriority.UseTextAlignment = False
        Me.label9.Text = "label9"
        Me.label9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label6
        '
        Me.label6.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label6.CanGrow = False
        Me.label6.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.MaskNumeroCuenta")})
        Me.label6.Dpi = 254.0!
        Me.label6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label6.FormattingRules.Add(Me.Negritas4)
        Me.label6.FormattingRules.Add(Me.negritas5)
        Me.label6.LocationFloat = New DevExpress.Utils.PointFloat(2152.65!, 0.0!)
        Me.label6.Name = "label6"
        Me.label6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label6.SizeF = New System.Drawing.SizeF(108.4785!, 42.12166!)
        Me.label6.StylePriority.UseFont = False
        Me.label6.StylePriority.UseTextAlignment = False
        Me.label6.Text = "label6"
        Me.label6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label6.Visible = False
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 254.0!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 10.58333!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.year2, Me.year1, Me.label2})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.HeightF = 95.0!
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.Visible = False
        '
        'year2
        '
        Me.year2.Dpi = 254.0!
        Me.year2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.year2.LocationFloat = New DevExpress.Utils.PointFloat(2361.015!, 36.83!)
        Me.year2.Name = "year2"
        Me.year2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.year2.SizeF = New System.Drawing.SizeF(402.8018!, 58.42!)
        Me.year2.StylePriority.UseFont = False
        Me.year2.StylePriority.UseTextAlignment = False
        Me.year2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'year1
        '
        Me.year1.Dpi = 254.0!
        Me.year1.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.year1.LocationFloat = New DevExpress.Utils.PointFloat(1927.733!, 36.83!)
        Me.year1.Name = "year1"
        Me.year1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.year1.SizeF = New System.Drawing.SizeF(406.8241!, 58.42!)
        Me.year1.StylePriority.UseFont = False
        Me.year1.StylePriority.UseTextAlignment = False
        Me.year1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label2
        '
        Me.label2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.NombreCuenta")})
        Me.label2.Dpi = 254.0!
        Me.label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.label2.FormattingRules.Add(Me.Negritas4)
        Me.label2.FormattingRules.Add(Me.negritas5)
        Me.label2.LocationFloat = New DevExpress.Utils.PointFloat(25.4!, 36.83!)
        Me.label2.Name = "label2"
        Me.label2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label2.SizeF = New System.Drawing.SizeF(1902.333!, 58.42!)
        Me.label2.StylePriority.UseFont = False
        Me.label2.Text = "label2"
        Me.label2.Visible = False
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel4, Me.label5, Me.label8, Me.XrLabel6, Me.XrLabel1})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 127.2118!
        Me.GroupFooter1.Name = "GroupFooter1"
        Me.GroupFooter1.Visible = False
        '
        'XrLabel4
        '
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.NombreCuenta")})
        Me.XrLabel4.Dpi = 254.0!
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel4.FormattingRules.Add(Me.Negritas4)
        Me.XrLabel4.FormattingRules.Add(Me.negritas5)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 68.79166!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(150.8123!, 58.42!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.Text = "[NombreCuenta]"
        Me.XrLabel4.Visible = False
        '
        'label5
        '
        Me.label5.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.Solid
        Me.label5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label5.BorderWidth = 1
        Me.label5.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField1")})
        Me.label5.Dpi = 254.0!
        Me.label5.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label5.LocationFloat = New DevExpress.Utils.PointFloat(1789.516!, 68.79166!)
        Me.label5.Name = "label5"
        Me.label5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label5.SizeF = New System.Drawing.SizeF(576.7917!, 58.42!)
        Me.label5.StylePriority.UseBorderDashStyle = False
        Me.label5.StylePriority.UseBorders = False
        Me.label5.StylePriority.UseBorderWidth = False
        Me.label5.StylePriority.UseFont = False
        Me.label5.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Func = DevExpress.XtraReports.UI.SummaryFunc.Max
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label5.Summary = XrSummary1
        Me.label5.Text = "label5"
        Me.label5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label8
        '
        Me.label8.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField2")})
        Me.label8.Dpi = 254.0!
        Me.label8.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label8.LocationFloat = New DevExpress.Utils.PointFloat(2361.016!, 68.79166!)
        Me.label8.Name = "label8"
        Me.label8.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label8.SizeF = New System.Drawing.SizeF(402.8015!, 58.42!)
        Me.label8.StylePriority.UseBorders = False
        Me.label8.StylePriority.UseFont = False
        Me.label8.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        XrSummary2.Func = DevExpress.XtraReports.UI.SummaryFunc.Max
        XrSummary2.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label8.Summary = XrSummary2
        Me.label8.Text = "label8"
        Me.label8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel6
        '
        Me.XrLabel6.Dpi = 254.0!
        Me.XrLabel6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.FormattingRules.Add(Me.Visible5)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(964.0157!, 68.79166!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(564.5153!, 58.42004!)
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        Me.XrLabel6.Text = "Total de gastos y otras pérdidas:"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel6.Visible = False
        '
        'Visible5
        '
        Me.Visible5.Condition = "[MaskNumeroCuenta] like '5%'"
        '
        '
        '
        Me.Visible5.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.Visible5.Name = "Visible5"
        '
        'XrLabel1
        '
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.XrLabel1.FormattingRules.Add(Me.visible4)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(1059.266!, 68.79163!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(658.0983!, 58.42003!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "Total de Ingresos y otros beneficios:"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel1.Visible = False
        '
        'visible4
        '
        Me.visible4.Condition = "[MaskNumeroCuenta] like '4%'"
        '
        '
        '
        Me.visible4.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.visible4.Name = "visible4"
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel2, Me.line3, Me.XrLabel7, Me.label3, Me.label4})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 127.0!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'XrLabel2
        '
        Me.XrLabel2.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.XrLabel2.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.XrLabel2.BorderWidth = 3
        Me.XrLabel2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "CalculatedField4")})
        Me.XrLabel2.Dpi = 254.0!
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(1789.516!, 8.229149!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(576.7916!, 58.42!)
        Me.XrLabel2.StylePriority.UseBorderDashStyle = False
        Me.XrLabel2.StylePriority.UseBorders = False
        Me.XrLabel2.StylePriority.UseBorderWidth = False
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        XrSummary3.FormatString = "{0:n2}"
        XrSummary3.Running = DevExpress.XtraReports.UI.SummaryRunning.Report
        Me.XrLabel2.Summary = XrSummary3
        Me.XrLabel2.Text = "XrLabel2"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'line3
        '
        Me.line3.Dpi = 254.0!
        Me.line3.LineWidth = 3
        Me.line3.LocationFloat = New DevExpress.Utils.PointFloat(1789.516!, 0.0!)
        Me.line3.Name = "line3"
        Me.line3.SizeF = New System.Drawing.SizeF(974.3004!, 8.229167!)
        Me.line3.Visible = False
        '
        'XrLabel7
        '
        Me.XrLabel7.Dpi = 254.0!
        Me.XrLabel7.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLabel7.LocationFloat = New DevExpress.Utils.PointFloat(444.5!, 68.58!)
        Me.XrLabel7.Name = "XrLabel7"
        Me.XrLabel7.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel7.SizeF = New System.Drawing.SizeF(1714.5!, 58.42!)
        Me.XrLabel7.StylePriority.UseFont = False
        Me.XrLabel7.Text = "*No incluyen: Utilidades e Intereses. Por regla de presentación se revelan como I" & _
    "ngresos Financieros"
        Me.XrLabel7.Visible = False
        '
        'label3
        '
        Me.label3.Dpi = 254.0!
        Me.label3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.label3.LocationFloat = New DevExpress.Utils.PointFloat(1013.573!, 0.0!)
        Me.label3.Name = "label3"
        Me.label3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label3.SizeF = New System.Drawing.SizeF(703.7917!, 58.42!)
        Me.label3.StylePriority.UseFont = False
        Me.label3.StylePriority.UseTextAlignment = False
        Me.label3.Text = "Resultado del ejercicio (Ahorro/Desahorro) :"
        Me.label3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label4
        '
        Me.label4.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label4.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label4.BorderWidth = 3
        Me.label4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField3")})
        Me.label4.Dpi = 254.0!
        Me.label4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label4.LocationFloat = New DevExpress.Utils.PointFloat(2361.015!, 8.229149!)
        Me.label4.Name = "label4"
        Me.label4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label4.SizeF = New System.Drawing.SizeF(402.801!, 58.42!)
        Me.label4.StylePriority.UseBorderDashStyle = False
        Me.label4.StylePriority.UseBorders = False
        Me.label4.StylePriority.UseBorderWidth = False
        Me.label4.StylePriority.UseFont = False
        Me.label4.StylePriority.UseTextAlignment = False
        XrSummary4.FormatString = "{0:n2}"
        XrSummary4.Running = DevExpress.XtraReports.UI.SummaryRunning.Report
        Me.label4.Summary = XrSummary4
        Me.label4.Text = "label4"
        Me.label4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'DsEnrique1
        '
        Me.DsEnrique1.DataSetName = "DSEnrique"
        Me.DsEnrique1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'VW_RPT_CFG_DatosEntesTableAdapter1
        '
        Me.VW_RPT_CFG_DatosEntesTableAdapter1.ClearBeforeFill = True
        '
        'calculatedField1
        '
        Me.calculatedField1.Expression = "Iif([MaskNumeroCuenta] like '5%',(Iif([SaldoDeudor] > 0,[SaldoDeudor],0.00)),(Iif" & _
    "([SaldoAcreedor] > 0,[SaldoAcreedor] ,0.00)))"
        Me.calculatedField1.Name = "calculatedField1"
        '
        'calculatedField2
        '
        Me.calculatedField2.Expression = "Iif([MaskNumeroCuenta] like '5%',[SaldoDeudorAnt]  ,[SaldoAcreedorAnt] )"
        Me.calculatedField2.Name = "calculatedField2"
        '
        'calculatedField3
        '
        Me.calculatedField3.Expression = "(Iif([MaskNumeroCuenta]='40000' or [MaskNumeroCuenta]='400000' , + [SaldoAcreedor" & _
    "]  , " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Iif([MaskNumeroCuenta]='50000' or [MaskNumeroCuenta]='500000', - [SaldoDe" & _
    "udor]  ,0 ) )) "
        Me.calculatedField3.Name = "calculatedField3"
        '
        'CalculatedField4
        '
        Me.CalculatedField4.Expression = "(Iif([MaskNumeroCuenta]='40000' or [MaskNumeroCuenta]='400000' , + [SaldoAcreedor" & _
    "Ant]  , " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Iif([MaskNumeroCuenta]='50000' or [MaskNumeroCuenta]='500000', - [Sald" & _
    "oDeudorAnt]  ,0 ) )) "
        Me.CalculatedField4.Name = "CalculatedField4"
        '
        'SUBRPT_TotalEdoActividades
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.GroupHeader1, Me.GroupFooter1, Me.ReportFooter})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.calculatedField1, Me.calculatedField2, Me.calculatedField3, Me.CalculatedField4})
        Me.DataAdapter = Me.VW_RPT_CFG_DatosEntesTableAdapter1
        Me.DataMember = "REPORTE_Estado_De_Actividades"
        Me.DataSource = Me.DsEnrique1
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas4, Me.negritas5, Me.visible4, Me.Visible5})
        Me.Margins = New System.Drawing.Printing.Margins(147, 147, 254, 11)
        Me.PageHeight = 2794
        Me.PageWidth = 3302
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me.DsEnrique1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents DsEnrique1 As Korima_Reporteador.DSEnrique
    Friend WithEvents VW_RPT_CFG_DatosEntesTableAdapter1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter
    Public WithEvents year2 As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents year1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents calculatedField1 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents calculatedField2 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents calculatedField3 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents Negritas4 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents negritas5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents visible4 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Visible5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents CalculatedField4 As DevExpress.XtraReports.UI.CalculatedField
End Class
