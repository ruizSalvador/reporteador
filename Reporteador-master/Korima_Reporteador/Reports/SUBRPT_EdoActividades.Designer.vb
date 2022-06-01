<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class SUBRPT_EdoActividades
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
        Me.label1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Negritas4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.DsEnrique1 = New Korima_Reporteador.DSEnrique()
        Me.negritas5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.label8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.label10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Visible5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.visible4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.calculatedField1 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.calculatedField2 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.label3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.line3 = New DevExpress.XtraReports.UI.XRLine()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        Me.label4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrPageBreak1 = New DevExpress.XtraReports.UI.XRPageBreak()
        Me.year2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.year1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.calculatedField3 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.VW_RPT_CFG_DatosEntesTableAdapter1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter()
        CType(Me.DsEnrique1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.label1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 6.879183!)
        Me.label1.Multiline = True
        Me.label1.Name = "label1"
        Me.label1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label1.SizeF = New System.Drawing.SizeF(748.95!, 33.41996!)
        Me.label1.StylePriority.UseFont = False
        Me.label1.Text = "label1"
        Me.label1.Visible = False
        '
        'Negritas4
        '
        Me.Negritas4.Condition = "[NumeroCuenta] like '4_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '4_0000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[" & _
    "NumeroCuenta] like '4_000-000000' " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.Negritas4.DataMember = Nothing
        Me.Negritas4.DataSource = Me.DsEnrique1
        '
        '
        '
        Me.Negritas4.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas4.Name = "Negritas4"
        '
        'DsEnrique1
        '
        Me.DsEnrique1.DataSetName = "DSEnrique"
        Me.DsEnrique1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'negritas5
        '
        Me.negritas5.Condition = "[NumeroCuenta] like '5_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '5_0000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[" & _
    "NumeroCuenta] like '5_000-000000'" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.negritas5.DataSource = Me.DsEnrique1
        '
        '
        '
        Me.negritas5.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.negritas5.Name = "negritas5"
        '
        'label8
        '
        Me.label8.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField2")})
        Me.label8.Dpi = 254.0!
        Me.label8.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label8.LocationFloat = New DevExpress.Utils.PointFloat(1345.425!, 0.00008010864!)
        Me.label8.Name = "label8"
        Me.label8.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label8.SizeF = New System.Drawing.SizeF(402.8015!, 58.41999!)
        Me.label8.StylePriority.UseBorders = False
        Me.label8.StylePriority.UseFont = False
        Me.label8.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Func = DevExpress.XtraReports.UI.SummaryFunc.Max
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label8.Summary = XrSummary1
        Me.label8.Text = "label8"
        Me.label8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label8.Visible = False
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label10, Me.label9, Me.label6, Me.label1})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 44.61493!
        Me.Detail.Name = "Detail"
        Me.Detail.SortFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("NumeroCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        '
        'label10
        '
        Me.label10.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label10.CanGrow = False
        Me.label10.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField2", "{0:n2}")})
        Me.label10.Dpi = 254.0!
        Me.label10.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label10.LocationFloat = New DevExpress.Utils.PointFloat(1171.649!, 6.879183!)
        Me.label10.Name = "label10"
        Me.label10.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label10.SizeF = New System.Drawing.SizeF(406.6108!, 28.61074!)
        Me.label10.StylePriority.UseFont = False
        Me.label10.StylePriority.UseTextAlignment = False
        Me.label10.Text = "label10"
        Me.label10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label10.Visible = False
        '
        'label9
        '
        Me.label9.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label9.CanGrow = False
        Me.label9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField1", "{0:n2}")})
        Me.label9.Dpi = 254.0!
        Me.label9.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label9.LocationFloat = New DevExpress.Utils.PointFloat(745.985!, 6.879183!)
        Me.label9.Name = "label9"
        Me.label9.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label9.SizeF = New System.Drawing.SizeF(406.8237!, 5.0!)
        Me.label9.StylePriority.UseFont = False
        Me.label9.StylePriority.UseTextAlignment = False
        Me.label9.Text = "label9"
        Me.label9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label9.Visible = False
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
        Me.label6.LocationFloat = New DevExpress.Utils.PointFloat(977.8881!, 6.879183!)
        Me.label6.Name = "label6"
        Me.label6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label6.SizeF = New System.Drawing.SizeF(108.4786!, 35.48992!)
        Me.label6.StylePriority.UseFont = False
        Me.label6.StylePriority.UseTextAlignment = False
        Me.label6.Text = "label6"
        Me.label6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label6.Visible = False
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel6, Me.XrLabel4, Me.label8, Me.XrLabel1, Me.label5})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 58.42007!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'XrLabel6
        '
        Me.XrLabel6.Dpi = 254.0!
        Me.XrLabel6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(167.0024!, 0.0!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(564.5153!, 58.42004!)
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        Me.XrLabel6.Text = "Total de gastos y otras pérdidas:"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel6.Visible = False
        '
        'XrLabel4
        '
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.NombreCuenta")})
        Me.XrLabel4.Dpi = 254.0!
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel4.FormattingRules.Add(Me.Negritas4)
        Me.XrLabel4.FormattingRules.Add(Me.negritas5)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(150.8123!, 58.42!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.Text = "[NombreCuenta]"
        Me.XrLabel4.Visible = False
        '
        'XrLabel1
        '
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(167.0024!, 0.00004196167!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(658.0983!, 58.42003!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "Total de Ingresos y otros beneficios:"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel1.Visible = False
        '
        'label5
        '
        Me.label5.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.Solid
        Me.label5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.label5.BorderWidth = 1
        Me.label5.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField1")})
        Me.label5.Dpi = 254.0!
        Me.label5.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label5.LocationFloat = New DevExpress.Utils.PointFloat(745.985!, 0.00004196167!)
        Me.label5.Name = "label5"
        Me.label5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label5.SizeF = New System.Drawing.SizeF(576.7916!, 58.42!)
        Me.label5.StylePriority.UseBorderDashStyle = False
        Me.label5.StylePriority.UseBorders = False
        Me.label5.StylePriority.UseBorderWidth = False
        Me.label5.StylePriority.UseFont = False
        Me.label5.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        XrSummary2.Func = DevExpress.XtraReports.UI.SummaryFunc.Max
        XrSummary2.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label5.Summary = XrSummary2
        Me.label5.Text = "label5"
        Me.label5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.label5.Visible = False
        '
        'Visible5
        '
        Me.Visible5.Condition = "[MaskNumeroCuenta] like '5%'"
        Me.Visible5.DataSource = Me.DsEnrique1
        '
        '
        '
        Me.Visible5.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.Visible5.Name = "Visible5"
        '
        'visible4
        '
        Me.visible4.Condition = "[MaskNumeroCuenta] like '4%'"
        Me.visible4.DataSource = Me.DsEnrique1
        '
        '
        '
        Me.visible4.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.visible4.Name = "visible4"
        '
        'calculatedField1
        '
        Me.calculatedField1.DataMember = "REPORTE_Estado_De_Actividades"
        Me.calculatedField1.DataSource = Me.DsEnrique1
        Me.calculatedField1.Expression = "Iif([MaskNumeroCuenta] like '5%',(Iif([SaldoDeudor] > 0,[SaldoDeudor],0.00)),(Iif" & _
    "([SaldoAcreedor] > 0,[SaldoAcreedor] ,0.00)))" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.calculatedField1.Name = "calculatedField1"
        '
        'calculatedField2
        '
        Me.calculatedField2.DataMember = "REPORTE_Estado_De_Actividades"
        Me.calculatedField2.DataSource = Me.DsEnrique1
        Me.calculatedField2.Expression = "Iif([MaskNumeroCuenta] like '5%',[SaldoDeudorAnt]  ,[SaldoAcreedorAnt] )"
        Me.calculatedField2.Name = "calculatedField2"
        '
        'label3
        '
        Me.label3.Dpi = 254.0!
        Me.label3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.label3.LocationFloat = New DevExpress.Utils.PointFloat(45.1582!, 0.0!)
        Me.label3.Name = "label3"
        Me.label3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label3.SizeF = New System.Drawing.SizeF(703.7918!, 58.42!)
        Me.label3.StylePriority.UseFont = False
        Me.label3.StylePriority.UseTextAlignment = False
        Me.label3.Text = "Resultado del ejercicio (Ahorro/Desahorro) :"
        Me.label3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'line3
        '
        Me.line3.Dpi = 254.0!
        Me.line3.LineWidth = 3
        Me.line3.LocationFloat = New DevExpress.Utils.PointFloat(978.4019!, 0.0!)
        Me.line3.Name = "line3"
        Me.line3.SizeF = New System.Drawing.SizeF(761.9988!, 8.229167!)
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.line3, Me.label4, Me.label3})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 174.8367!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'label4
        '
        Me.label4.BorderDashStyle = DevExpress.XtraPrinting.BorderDashStyle.[Double]
        Me.label4.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.label4.BorderWidth = 3
        Me.label4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.calculatedField3")})
        Me.label4.Dpi = 254.0!
        Me.label4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label4.LocationFloat = New DevExpress.Utils.PointFloat(978.4019!, 8.229149!)
        Me.label4.Name = "label4"
        Me.label4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label4.SizeF = New System.Drawing.SizeF(761.9999!, 58.42!)
        Me.label4.StylePriority.UseBorderDashStyle = False
        Me.label4.StylePriority.UseBorders = False
        Me.label4.StylePriority.UseBorderWidth = False
        Me.label4.StylePriority.UseFont = False
        Me.label4.StylePriority.UseTextAlignment = False
        XrSummary3.FormatString = "{0:n2}"
        XrSummary3.Running = DevExpress.XtraReports.UI.SummaryRunning.Report
        Me.label4.Summary = XrSummary3
        Me.label4.Text = "label4"
        Me.label4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label2
        '
        Me.label2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "REPORTE_Estado_De_Actividades.NombreCuenta")})
        Me.label2.Dpi = 254.0!
        Me.label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.label2.FormattingRules.Add(Me.Negritas4)
        Me.label2.FormattingRules.Add(Me.negritas5)
        Me.label2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 2.0!)
        Me.label2.Name = "label2"
        Me.label2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label2.SizeF = New System.Drawing.SizeF(748.95!, 58.01999!)
        Me.label2.StylePriority.UseFont = False
        Me.label2.Text = "label2"
        Me.label2.Visible = False
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrPageBreak1, Me.year2, Me.year1, Me.label2})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("TipoCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 60.42!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'XrPageBreak1
        '
        Me.XrPageBreak1.Dpi = 254.0!
        Me.XrPageBreak1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrPageBreak1.Name = "XrPageBreak1"
        '
        'year2
        '
        Me.year2.Dpi = 254.0!
        Me.year2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.year2.LocationFloat = New DevExpress.Utils.PointFloat(1171.649!, 2.0!)
        Me.year2.Name = "year2"
        Me.year2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.year2.SizeF = New System.Drawing.SizeF(402.8015!, 58.42!)
        Me.year2.StylePriority.UseFont = False
        Me.year2.StylePriority.UseTextAlignment = False
        Me.year2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.year2.Visible = False
        '
        'year1
        '
        Me.year1.Dpi = 254.0!
        Me.year1.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.year1.LocationFloat = New DevExpress.Utils.PointFloat(748.95!, 2.0!)
        Me.year1.Name = "year1"
        Me.year1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.year1.SizeF = New System.Drawing.SizeF(406.8242!, 58.42!)
        Me.year1.StylePriority.UseFont = False
        Me.year1.StylePriority.UseTextAlignment = False
        Me.year1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.year1.Visible = False
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 0.0!
        Me.TopMargin.Name = "TopMargin"
        '
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 0.0!
        Me.BottomMargin.Name = "BottomMargin"
        '
        'calculatedField3
        '
        Me.calculatedField3.DataMember = "REPORTE_Estado_De_Actividades"
        Me.calculatedField3.DataSource = Me.DsEnrique1
        Me.calculatedField3.Expression = "(Iif([MaskNumeroCuenta]='40000' or [MaskNumeroCuenta]='400000' , + [SaldoAcreedor" & _
    "]  , " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Iif([MaskNumeroCuenta]='50000' or [MaskNumeroCuenta]='500000', - [SaldoDe" & _
    "udor]  ,0 ) )) " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & " " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.calculatedField3.Name = "calculatedField3"
        '
        'VW_RPT_CFG_DatosEntesTableAdapter1
        '
        Me.VW_RPT_CFG_DatosEntesTableAdapter1.ClearBeforeFill = True
        '
        'SUBRPT_EdoActividades
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMargin, Me.Detail, Me.BottomMargin, Me.GroupHeader1, Me.GroupFooter1, Me.ReportFooter})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.calculatedField1, Me.calculatedField2, Me.calculatedField3})
        Me.DataAdapter = Me.VW_RPT_CFG_DatosEntesTableAdapter1
        Me.DataMember = "REPORTE_Estado_De_Actividades"
        Me.DataSource = Me.DsEnrique1
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas4, Me.negritas5, Me.visible4, Me.Visible5})
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(46, 4, 0, 0)
        Me.PageWidth = 1800
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.PrintOnEmptyDataSource = False
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me.DsEnrique1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Negritas4 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents label10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents calculatedField1 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents calculatedField2 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents label3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents label4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents calculatedField3 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents negritas5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Visible5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents visible4 As DevExpress.XtraReports.UI.FormattingRule
    Public WithEvents year1 As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents year2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DsEnrique1 As Korima_Reporteador.DSEnrique
    Friend WithEvents VW_RPT_CFG_DatosEntesTableAdapter1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter
    Friend WithEvents label6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrPageBreak1 As DevExpress.XtraReports.UI.XRPageBreak
    ' Friend Cnn As XtraReportSerialization.CnnDataSet
End Class
