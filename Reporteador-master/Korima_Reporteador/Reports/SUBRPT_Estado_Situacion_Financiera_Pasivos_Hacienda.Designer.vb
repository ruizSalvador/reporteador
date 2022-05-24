<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class SUBRPT_Estado_Situacion_Financiera_Pasivos_Hacienda
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SUBRPT_Estado_Situacion_Financiera_Pasivos_Hacienda))
        Me.CalculatedField3 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Negritas2000 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Negritas3000 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.LineaSubtotal = New DevExpress.XtraReports.UI.FormattingRule()
        Me.BottomMarginBand1 = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.XrLabel5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.TopMarginBand1 = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.XrLabel9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.MuestraTotalPasivo = New DevExpress.XtraReports.UI.FormattingRule()
        Me.GroupFooterBand1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.MuestaTotalHacienda = New DevExpress.XtraReports.UI.FormattingRule()
        Me.DetailBand1 = New DevExpress.XtraReports.UI.DetailBand()
        Me.Oculta211 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.OcultaVarios = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta214 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta213 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta32 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.Oculta2233 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.CalculatedField4 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.GroupHeaderBand1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'CalculatedField3
        '
        Me.CalculatedField3.DataMember = "View_Prueba"
        Me.CalculatedField3.Expression = "Iif([MaskNumeroCuenta]='10000',[SaldoDeudor]  ,Iif([MaskNumeroCuenta]='20000'  Or" & _
    " [MaskNumeroCuenta]='30000',[SaldoAcreedor]  ,0 ) )" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.CalculatedField3.Name = "CalculatedField3"
        '
        'XrLabel3
        '
        Me.XrLabel3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.MaskNombreCuenta")})
        Me.XrLabel3.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLabel3.FormattingRules.Add(Me.Negritas2000)
        Me.XrLabel3.FormattingRules.Add(Me.Negritas3000)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 2.000014!)
        Me.XrLabel3.Multiline = True
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(531.25!, 23.0!)
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.Text = "label1"
        '
        'Negritas2000
        '
        Me.Negritas2000.Condition = "[NumeroCuenta] like '2_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '2__00-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Nu" & _
    "meroCuenta] like '2_000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '2__00-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Mask" & _
    "NumeroCuenta] = ''"
        Me.Negritas2000.DataMember = Nothing
        '
        '
        '
        Me.Negritas2000.Formatting.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas2000.Name = "Negritas2000"
        '
        'Negritas3000
        '
        Me.Negritas3000.Condition = "[NumeroCuenta] like '3_000-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '3__00-00000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Nu" & _
    "meroCuenta] like '3_000-000000' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '3__00-000000' "
        '
        '
        '
        Me.Negritas3000.Formatting.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas3000.Name = "Negritas3000"
        '
        'XrLabel1
        '
        Me.XrLabel1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField1")})
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(685.4167!, 2.000014!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(28.125!, 23.0!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.Text = "label1"
        Me.XrLabel1.Visible = False
        '
        'XrLabel6
        '
        Me.XrLabel6.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel6.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.CalculatedField3")})
        Me.XrLabel6.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(572.9167!, 10.00001!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(140.625!, 23.0!)
        Me.XrLabel6.StylePriority.UseBorders = False
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.XrLabel6.Summary = XrSummary1
        Me.XrLabel6.Text = "XrLabel6"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel4
        '
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.MaskNumeroCuenta")})
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel4.ForeColor = System.Drawing.Color.Transparent
        Me.XrLabel4.FormattingRules.Add(Me.Negritas2000)
        Me.XrLabel4.FormattingRules.Add(Me.Negritas3000)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(531.2501!, 0.0!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(53.12494!, 23.0!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.StylePriority.UseForeColor = False
        Me.XrLabel4.StylePriority.UseTextAlignment = False
        Me.XrLabel4.Text = "label6"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel4.Visible = False
        '
        'XrLabel2
        '
        Me.XrLabel2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.SaldoAcreedor", "{0:n2}")})
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel2.FormattingRules.Add(Me.LineaSubtotal)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(584.375!, 0.0!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(129.1667!, 23.0!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.Text = "label3"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'LineaSubtotal
        '
        Me.LineaSubtotal.Condition = "[MaskNumeroCuenta] = ''"
        '
        '
        '
        Me.LineaSubtotal.Formatting.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.LineaSubtotal.Name = "LineaSubtotal"
        '
        'BottomMarginBand1
        '
        Me.BottomMarginBand1.HeightF = 0.0!
        Me.BottomMarginBand1.Name = "BottomMarginBand1"
        '
        'XrLabel5
        '
        Me.XrLabel5.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.calculatedField2")})
        Me.XrLabel5.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel5.LocationFloat = New DevExpress.Utils.PointFloat(713.5417!, 2.000014!)
        Me.XrLabel5.Name = "XrLabel5"
        Me.XrLabel5.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel5.SizeF = New System.Drawing.SizeF(31.25!, 23.0!)
        Me.XrLabel5.StylePriority.UseFont = False
        Me.XrLabel5.Text = "label2"
        Me.XrLabel5.Visible = False
        '
        'XrLabel7
        '
        Me.XrLabel7.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel7.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.CalculatedField4")})
        Me.XrLabel7.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel7.LocationFloat = New DevExpress.Utils.PointFloat(724.9999!, 10.00001!)
        Me.XrLabel7.Name = "XrLabel7"
        Me.XrLabel7.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel7.SizeF = New System.Drawing.SizeF(143.0001!, 23.0!)
        Me.XrLabel7.StylePriority.UseBorders = False
        Me.XrLabel7.StylePriority.UseFont = False
        Me.XrLabel7.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        XrSummary2.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.XrLabel7.Summary = XrSummary2
        Me.XrLabel7.Text = "XrLabel7"
        Me.XrLabel7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel8
        '
        Me.XrLabel8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "View_Prueba.SaldoAcreedorAnt", "{0:n2}")})
        Me.XrLabel8.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel8.FormattingRules.Add(Me.LineaSubtotal)
        Me.XrLabel8.LocationFloat = New DevExpress.Utils.PointFloat(724.9998!, 0.0!)
        Me.XrLabel8.Name = "XrLabel8"
        Me.XrLabel8.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel8.SizeF = New System.Drawing.SizeF(143.0002!, 23.0!)
        Me.XrLabel8.StylePriority.UseFont = False
        Me.XrLabel8.StylePriority.UseTextAlignment = False
        Me.XrLabel8.Text = "label1"
        Me.XrLabel8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'TopMarginBand1
        '
        Me.TopMarginBand1.HeightF = 0.0!
        Me.TopMarginBand1.Name = "TopMarginBand1"
        '
        'XrLabel9
        '
        Me.XrLabel9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_Balanza_De_Comprobacion_Nivelada.NombreCuenta")})
        Me.XrLabel9.Font = New System.Drawing.Font("Tahoma", 9.75!)
        Me.XrLabel9.FormattingRules.Add(Me.Negritas2000)
        Me.XrLabel9.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 10.00001!)
        Me.XrLabel9.Name = "XrLabel9"
        Me.XrLabel9.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel9.SizeF = New System.Drawing.SizeF(394.7917!, 23.0!)
        Me.XrLabel9.StylePriority.UseFont = False
        Me.XrLabel9.Text = "label2"
        Me.XrLabel9.Visible = False
        '
        'XrLabel10
        '
        Me.XrLabel10.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel10.FormattingRules.Add(Me.MuestraTotalPasivo)
        Me.XrLabel10.LocationFloat = New DevExpress.Utils.PointFloat(396.875!, 10.00001!)
        Me.XrLabel10.Name = "XrLabel10"
        Me.XrLabel10.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel10.SizeF = New System.Drawing.SizeF(134.375!, 23.0!)
        Me.XrLabel10.StylePriority.UseFont = False
        Me.XrLabel10.Text = "TOTAL DE PASIVO:"
        Me.XrLabel10.Visible = False
        '
        'MuestraTotalPasivo
        '
        Me.MuestraTotalPasivo.Condition = "[NumeroCuenta] like '2%'"
        '
        '
        '
        Me.MuestraTotalPasivo.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.MuestraTotalPasivo.Name = "MuestraTotalPasivo"
        '
        'GroupFooterBand1
        '
        Me.GroupFooterBand1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel14, Me.XrLabel7, Me.XrLabel10, Me.XrLabel6})
        Me.GroupFooterBand1.HeightF = 59.375!
        Me.GroupFooterBand1.Name = "GroupFooterBand1"
        '
        'XrLabel14
        '
        Me.XrLabel14.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel14.FormattingRules.Add(Me.MuestaTotalHacienda)
        Me.XrLabel14.LocationFloat = New DevExpress.Utils.PointFloat(203.7499!, 10.00001!)
        Me.XrLabel14.Name = "XrLabel14"
        Me.XrLabel14.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel14.SizeF = New System.Drawing.SizeF(327.5!, 23.0!)
        Me.XrLabel14.StylePriority.UseFont = False
        Me.XrLabel14.Text = "TOTAL DE HACIENDA PUBLICA / PATRIMONIO:"
        Me.XrLabel14.Visible = False
        '
        'MuestaTotalHacienda
        '
        Me.MuestaTotalHacienda.Condition = "[MaskNumeroCuenta] like '3%'"
        '
        '
        '
        Me.MuestaTotalHacienda.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.MuestaTotalHacienda.Name = "MuestaTotalHacienda"
        '
        'DetailBand1
        '
        Me.DetailBand1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel4, Me.XrLabel3, Me.XrLabel2, Me.XrLabel8, Me.XrLabel5, Me.XrLabel1})
        Me.DetailBand1.FormattingRules.Add(Me.Oculta211)
        Me.DetailBand1.FormattingRules.Add(Me.OcultaVarios)
        Me.DetailBand1.FormattingRules.Add(Me.Oculta214)
        Me.DetailBand1.FormattingRules.Add(Me.Oculta213)
        Me.DetailBand1.FormattingRules.Add(Me.Oculta32)
        Me.DetailBand1.FormattingRules.Add(Me.Oculta2233)
        Me.DetailBand1.HeightF = 25.00002!
        Me.DetailBand1.Name = "DetailBand1"
        Me.DetailBand1.SortFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("NumeroCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        '
        'Oculta211
        '
        Me.Oculta211.Condition = resources.GetString("Oculta211.Condition")
        '
        '
        '
        Me.Oculta211.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta211.Name = "Oculta211"
        '
        'OcultaVarios
        '
        Me.OcultaVarios.Condition = resources.GetString("OcultaVarios.Condition")
        '
        '
        '
        Me.OcultaVarios.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.OcultaVarios.Name = "OcultaVarios"
        '
        'Oculta214
        '
        Me.Oculta214.Condition = resources.GetString("Oculta214.Condition")
        '
        '
        '
        Me.Oculta214.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta214.Name = "Oculta214"
        '
        'Oculta213
        '
        Me.Oculta213.Condition = resources.GetString("Oculta213.Condition")
        '
        '
        '
        Me.Oculta213.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta213.Name = "Oculta213"
        '
        'Oculta32
        '
        Me.Oculta32.Condition = resources.GetString("Oculta32.Condition")
        '
        '
        '
        Me.Oculta32.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta32.Name = "Oculta32"
        '
        'Oculta2233
        '
        Me.Oculta2233.Condition = "([MaskNumeroCuenta] like '2233%' and [MaskNumeroCuenta] <> '22330') "
        '
        '
        '
        Me.Oculta2233.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.Oculta2233.Name = "Oculta2233"
        '
        'CalculatedField4
        '
        Me.CalculatedField4.DataMember = "View_Prueba"
        Me.CalculatedField4.Expression = "Iif([MaskNumeroCuenta]='10000',[SaldoDeudorAnt]  ,Iif([MaskNumeroCuenta]='20000' " & _
    " Or [MaskNumeroCuenta]='30000',[SaldoAcreedorAnt]  ,0 ) )"
        Me.CalculatedField4.Name = "CalculatedField4"
        '
        'GroupHeaderBand1
        '
        Me.GroupHeaderBand1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel13, Me.XrLabel12, Me.XrLabel9})
        Me.GroupHeaderBand1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("TipoCuenta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeaderBand1.HeightF = 33.00001!
        Me.GroupHeaderBand1.Name = "GroupHeaderBand1"
        Me.GroupHeaderBand1.Visible = False
        '
        'XrLabel13
        '
        Me.XrLabel13.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel13.LocationFloat = New DevExpress.Utils.PointFloat(735.0!, 10.00001!)
        Me.XrLabel13.Name = "XrLabel13"
        Me.XrLabel13.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel13.SizeF = New System.Drawing.SizeF(133.0!, 23.0!)
        Me.XrLabel13.StylePriority.UseFont = False
        Me.XrLabel13.StylePriority.UseTextAlignment = False
        Me.XrLabel13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel12
        '
        Me.XrLabel12.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(584.375!, 10.00001!)
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(129.1667!, 23.0!)
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'SUBRPT_Estado_Situacion_Financiera_Pasivos_Hacienda
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMarginBand1, Me.DetailBand1, Me.BottomMarginBand1, Me.GroupHeaderBand1, Me.GroupFooterBand1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.CalculatedField3, Me.CalculatedField4})
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas2000, Me.Oculta211, Me.OcultaVarios, Me.Oculta214, Me.Oculta213, Me.Oculta32, Me.Negritas3000, Me.Oculta2233, Me.MuestraTotalPasivo, Me.MuestaTotalHacienda, Me.LineaSubtotal})
        Me.Margins = New System.Drawing.Printing.Margins(0, 2, 0, 0)
        Me.PageWidth = 870
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.PrintOnEmptyDataSource = False
        Me.Version = "11.1"
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub

    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents label7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents formattingRule1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents label3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents VW_RPT_K2_Balanza_De_Comprobacion_NiveladaTableAdapter As System.Data.OleDb.OleDbDataAdapter
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents label6 As DevExpress.XtraReports.UI.XRLabel

    Friend WithEvents calculatedField2 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents label5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents calculatedField1 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents CalculatedField3 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents BottomMarginBand1 As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents XrLabel5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Negritas2000 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents TopMarginBand1 As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents XrLabel9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupFooterBand1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents DetailBand1 As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents CalculatedField4 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents GroupHeaderBand1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents Oculta211 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents OcultaVarios As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta214 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta213 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta32 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Negritas3000 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents Oculta2233 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents MuestraTotalPasivo As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents MuestaTotalHacienda As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents LineaSubtotal As DevExpress.XtraReports.UI.FormattingRule
    ' Friend Cnn As XtraReportSerialization.CnnDataSet
End Class
