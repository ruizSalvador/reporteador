<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class SUBRPT_Estado_Situacion_Financiera_Activos
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SUBRPT_Estado_Situacion_Financiera_Activos))
        Me.label7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.LineaSubtotal = New DevExpress.XtraReports.UI.FormattingRule()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Negritas1000 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.label10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.calculatedField2 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.label1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.calculatedField1 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.label4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.label6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Oculta114 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta115 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta122 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta123 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta124 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta125 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta116_126_128 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta119_121_129 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'label7
        '
        Me.label7.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.SaldoDeudorAnt", "{0:n2}")})
        Me.label7.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label7.FormattingRules.Add(Me.LineaSubtotal)
        Me.label7.LocationFloat = New DevExpress.Utils.PointFloat(750.0001!, 2.000014!)
        Me.label7.Name = "label7"
        Me.label7.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label7.SizeF = New System.Drawing.SizeF(143.9997!, 23.0!)
        Me.label7.StylePriority.UseFont = False
        Me.label7.StylePriority.UseTextAlignment = False
        Me.label7.Text = "label7"
        Me.label7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'LineaSubtotal
        '
        Me.LineaSubtotal.Condition = "[MaskNumeroCuenta]=''"
        '
        '
        '
        Me.LineaSubtotal.Formatting.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.LineaSubtotal.Name = "LineaSubtotal"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel2, Me.XrLabel12, Me.label2})
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("TipoCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 34.375!
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.Visible = False
        '
        'XrLabel2
        '
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(592.375!, 10.00001!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(146.8749!, 23.0!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel12
        '
        Me.XrLabel12.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(764.8331!, 11.375!)
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(129.1667!, 23.0!)
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label2
        '
        Me.label2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.NombreCuenta")})
        Me.label2.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label2.FormattingRules.Add(Me.Negritas1000)
        Me.label2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 11.375!)
        Me.label2.Name = "label2"
        Me.label2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label2.SizeF = New System.Drawing.SizeF(478.125!, 23.0!)
        Me.label2.StylePriority.UseFont = False
        Me.label2.Text = "label2"
        Me.label2.Visible = False
        '
        'Negritas1000
        '
        Me.Negritas1000.Condition = "[NumeroCuenta] like '1_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '1__00-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Nu" & _
    "meroCuenta] like '1_000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '1__00-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Mask" & _
    "NumeroCuenta]= ''"
        Me.Negritas1000.DataMember = Nothing
        '
        '
        '
        Me.Negritas1000.Formatting.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas1000.Name = "Negritas1000"
        '
        'BottomMargin
        '
        Me.BottomMargin.HeightF = 0.0!
        Me.BottomMargin.Name = "BottomMargin"
        '
        'label10
        '
        Me.label10.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField2")})
        Me.label10.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label10.LocationFloat = New DevExpress.Utils.PointFloat(771.875!, 2.000014!)
        Me.label10.Name = "label10"
        Me.label10.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label10.SizeF = New System.Drawing.SizeF(18.75!, 23.0!)
        Me.label10.StylePriority.UseFont = False
        Me.label10.Text = "label10"
        Me.label10.Visible = False
        '
        'label8
        '
        Me.label8.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label8.BorderWidth = 1
        Me.label8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField2")})
        Me.label8.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label8.LocationFloat = New DevExpress.Utils.PointFloat(750.0001!, 12.16667!)
        Me.label8.Name = "label8"
        Me.label8.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label8.SizeF = New System.Drawing.SizeF(143.9999!, 23.0!)
        Me.label8.StylePriority.UseBorders = False
        Me.label8.StylePriority.UseBorderWidth = False
        Me.label8.StylePriority.UseFont = False
        Me.label8.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label8.Summary = XrSummary1
        Me.label8.Text = "label8"
        Me.label8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label9
        '
        Me.label9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField1")})
        Me.label9.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label9.LocationFloat = New DevExpress.Utils.PointFloat(750.0!, 0.0!)
        Me.label9.Name = "label9"
        Me.label9.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label9.SizeF = New System.Drawing.SizeF(21.875!, 23.0!)
        Me.label9.StylePriority.UseFont = False
        Me.label9.Text = "label9"
        Me.label9.Visible = False
        '
        'label3
        '
        Me.label3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.calculatedField1")})
        Me.label3.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label3.LocationFloat = New DevExpress.Utils.PointFloat(443.4167!, 0.0!)
        Me.label3.Name = "label3"
        Me.label3.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label3.SizeF = New System.Drawing.SizeF(100.0!, 23.0!)
        Me.label3.StylePriority.UseFont = False
        Me.label3.Text = "label3"
        Me.label3.Visible = False
        '
        'calculatedField2
        '
        Me.calculatedField2.DataMember = "View_Prueba"
        Me.calculatedField2.Expression = "Iif([MaskNumeroCuenta]='10000',[SaldoDeudorAnt]  ,Iif([MaskNumeroCuenta]='20000' " & _
    " Or [MaskNumeroCuenta]='30000',[SaldoAcreedorAnt]  ,0 ) )" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.calculatedField2.Name = "calculatedField2"
        '
        'label1
        '
        Me.label1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.MaskNombreCuenta")})
        Me.label1.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.label1.FormattingRules.Add(Me.Negritas1000)
        Me.label1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 2.000014!)
        Me.label1.Multiline = True
        Me.label1.Name = "label1"
        Me.label1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label1.SizeF = New System.Drawing.SizeF(543.4166!, 23.0!)
        Me.label1.StylePriority.UseFont = False
        Me.label1.Text = "label1"
        '
        'calculatedField1
        '
        Me.calculatedField1.DataMember = "View_Prueba"
        Me.calculatedField1.Expression = "Iif([MaskNumeroCuenta]='10000',[SaldoDeudor]  ,Iif([MaskNumeroCuenta]='20000'  Or" & _
    " [MaskNumeroCuenta]='30000',[SaldoAcreedor]  ,0 ) )" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.calculatedField1.Name = "calculatedField1"
        '
        'label4
        '
        Me.label4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.SaldoDeudor", "{0:n2}")})
        Me.label4.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label4.FormattingRules.Add(Me.LineaSubtotal)
        Me.label4.LocationFloat = New DevExpress.Utils.PointFloat(592.375!, 2.000014!)
        Me.label4.Name = "label4"
        Me.label4.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label4.SizeF = New System.Drawing.SizeF(146.875!, 23.0!)
        Me.label4.StylePriority.UseFont = False
        Me.label4.StylePriority.UseTextAlignment = False
        Me.label4.Text = "label4"
        Me.label4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label8, Me.XrLabel1, Me.label5})
        Me.GroupFooter1.HeightF = 59.375!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'XrLabel1
        '
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(397.5833!, 10.00001!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(145.8333!, 23.0!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.Text = "TOTAL DE ACTIVOS :"
        '
        'label5
        '
        Me.label5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label5.BorderWidth = 1
        Me.label5.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField1")})
        Me.label5.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.label5.LocationFloat = New DevExpress.Utils.PointFloat(577.6631!, 12.08334!)
        Me.label5.Name = "label5"
        Me.label5.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label5.SizeF = New System.Drawing.SizeF(161.5868!, 23.0!)
        Me.label5.StylePriority.UseBorders = False
        Me.label5.StylePriority.UseBorderWidth = False
        Me.label5.StylePriority.UseFont = False
        Me.label5.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        XrSummary2.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label5.Summary = XrSummary2
        Me.label5.Text = "label5"
        Me.label5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label10, Me.label9, Me.label6, Me.label1, Me.label3, Me.label4, Me.label7})
        Me.Detail.FormattingRules.Add(Me.Oculta114)
        Me.Detail.FormattingRules.Add(Me.Oculta115)
        Me.Detail.FormattingRules.Add(Me.Oculta122)
        Me.Detail.FormattingRules.Add(Me.Oculta123)
        Me.Detail.FormattingRules.Add(Me.Oculta124)
        Me.Detail.FormattingRules.Add(Me.Oculta125)
        Me.Detail.FormattingRules.Add(Me.Oculta116_126_128)
        Me.Detail.FormattingRules.Add(Me.Oculta119_121_129)
        Me.Detail.HeightF = 25.70833!
        Me.Detail.Name = "Detail"
        Me.Detail.SortFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("NumeroCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        '
        'label6
        '
        Me.label6.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.MaskNumeroCuenta")})
        Me.label6.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.label6.ForeColor = System.Drawing.Color.Transparent
        Me.label6.FormattingRules.Add(Me.Negritas1000)
        Me.label6.LocationFloat = New DevExpress.Utils.PointFloat(543.4167!, 2.0!)
        Me.label6.Name = "label6"
        Me.label6.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.label6.SizeF = New System.Drawing.SizeF(48.95831!, 23.0!)
        Me.label6.StylePriority.UseFont = False
        Me.label6.StylePriority.UseForeColor = False
        Me.label6.StylePriority.UseTextAlignment = False
        Me.label6.Text = "label6"
        Me.label6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'Oculta114
        '
        Me.Oculta114.Condition = resources.GetString("Oculta114.Condition")
        '
        '
        '
        Me.Oculta114.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta114.Name = "Oculta114"
        '
        'Oculta115
        '
        Me.Oculta115.Condition = resources.GetString("Oculta115.Condition")
        '
        '
        '
        Me.Oculta115.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta115.Name = "Oculta115"
        '
        'Oculta122
        '
        Me.Oculta122.Condition = resources.GetString("Oculta122.Condition")
        '
        '
        '
        Me.Oculta122.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta122.Name = "Oculta122"
        '
        'Oculta123
        '
        Me.Oculta123.Condition = resources.GetString("Oculta123.Condition")
        '
        '
        '
        Me.Oculta123.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta123.Name = "Oculta123"
        '
        'Oculta124
        '
        Me.Oculta124.Condition = resources.GetString("Oculta124.Condition")
        '
        '
        '
        Me.Oculta124.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta124.Name = "Oculta124"
        '
        'Oculta125
        '
        Me.Oculta125.Condition = resources.GetString("Oculta125.Condition")
        '
        '
        '
        Me.Oculta125.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta125.Name = "Oculta125"
        '
        'Oculta116_126_128
        '
        Me.Oculta116_126_128.Condition = "[MaskNumeroCuenta] like '116%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[MaskNumeroCuenta] like '126%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[MaskNumero" & _
    "Cuenta] like '128%'"
        '
        '
        '
        Me.Oculta116_126_128.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta116_126_128.Name = "Oculta116_126_128"
        '
        'Oculta119_121_129
        '
        Me.Oculta119_121_129.Condition = resources.GetString("Oculta119_121_129.Condition")
        '
        '
        '
        Me.Oculta119_121_129.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta119_121_129.Name = "Oculta119_121_129"
        '
        'TopMargin
        '
        Me.TopMargin.HeightF = 0.0!
        Me.TopMargin.Name = "TopMargin"
        '
        'SUBRPT_Estado_Situacion_Financiera_Activos
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMargin, Me.Detail, Me.BottomMargin, Me.GroupHeader1, Me.GroupFooter1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.calculatedField1, Me.calculatedField2})
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas1000, Me.Oculta114, Me.Oculta115, Me.Oculta119_121_129, Me.Oculta122, Me.Oculta123, Me.Oculta124, Me.Oculta125, Me.Oculta116_126_128, Me.LineaSubtotal})
        Me.Margins = New System.Drawing.Printing.Margins(0, 4, 0, 0)
        Me.PageWidth = 898
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.Version = "11.1"
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents label7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents label10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents calculatedField2 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents calculatedField1 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents label4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Negritas1000 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents label6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents Oculta114 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta115 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta119_121_129 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta122 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta123 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta124 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta125 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta116_126_128 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents LineaSubtotal As DevExpress.XtraReports.UI.FormattingRule
    ' Friend Cnn As XtraReportSerialization.CnnDataSet
End Class
