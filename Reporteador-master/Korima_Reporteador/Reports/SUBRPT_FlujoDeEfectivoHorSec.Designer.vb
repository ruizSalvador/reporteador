<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class SUBRPT_FlujoDeEfectivoHorSec
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
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.FormattingRule2 = New DevExpress.XtraReports.UI.FormattingRule()
        Me._Korima2_00_ReporteadorDataSet1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet()
        Me.FormattingRule3 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.formattingRule1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.VW_C_UsuariosTableAdapter = New Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter()
        Me.cfSaldoActual = New DevExpress.XtraReports.UI.CalculatedField()
        Me.cfSaldoAnterior = New DevExpress.XtraReports.UI.CalculatedField()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.lblEjercicio = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblEjercicioAnt = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel4, Me.XrLabel3, Me.XrLabel1})
        Me.Detail.HeightF = 23.95833!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel4
        '
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "FlujoEfectivo.cfSaldoAnterior", "{0:n2}")})
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel4.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel4.FormattingRules.Add(Me.FormattingRule3)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(545.7432!, 0.0!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(100.0!, 23.0!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.StylePriority.UseTextAlignment = False
        Me.XrLabel4.Text = "XrLabel4"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'FormattingRule2
        '
        Me.FormattingRule2.Condition = "[negritas] == 1 Or [negritas] == 2"
        Me.FormattingRule2.DataSource = Me._Korima2_00_ReporteadorDataSet1
        '
        '
        '
        Me.FormattingRule2.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormattingRule2.Name = "FormattingRule2"
        '
        '_Korima2_00_ReporteadorDataSet1
        '
        Me._Korima2_00_ReporteadorDataSet1.DataSetName = "_Korima2_00_ReporteadorDataSet"
        Me._Korima2_00_ReporteadorDataSet1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'FormattingRule3
        '
        Me.FormattingRule3.Condition = "[orden] < 39"
        '
        '
        '
        Me.FormattingRule3.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.FormattingRule3.Name = "FormattingRule3"
        '
        'XrLabel3
        '
        Me.XrLabel3.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "FlujoEfectivo.cfSaldoActual", "{0:n2}")})
        Me.XrLabel3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel3.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel3.FormattingRules.Add(Me.FormattingRule3)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(428.125!, 0.0!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(105.1346!, 23.0!)
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.StylePriority.UseTextAlignment = False
        Me.XrLabel3.Text = "XrLabel3"
        Me.XrLabel3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'XrLabel1
        '
        Me.XrLabel1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "FlujoEfectivo.nombre")})
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel1.FormattingRules.Add(Me.formattingRule1)
        Me.XrLabel1.FormattingRules.Add(Me.FormattingRule3)
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(386.4585!, 23.0!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.Text = "XrLabel1"
        '
        'formattingRule1
        '
        Me.formattingRule1.Condition = "[negritas] == 1 Or [negritas] == 3"
        Me.formattingRule1.DataSource = Me._Korima2_00_ReporteadorDataSet1
        '
        '
        '
        Me.formattingRule1.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.formattingRule1.Name = "formattingRule1"
        '
        'TopMargin
        '
        Me.TopMargin.HeightF = 96.875!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'BottomMargin
        '
        Me.BottomMargin.HeightF = 0.0!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'VW_C_UsuariosTableAdapter
        '
        Me.VW_C_UsuariosTableAdapter.ClearBeforeFill = True
        '
        'cfSaldoActual
        '
        Me.cfSaldoActual.DataMember = "FlujoEfectivo"
        Me.cfSaldoActual.DataSource = Me._Korima2_00_ReporteadorDataSet1
        Me.cfSaldoActual.Expression = "Iif([negritas] == 3, '',[SaldoActual] )"
        Me.cfSaldoActual.Name = "cfSaldoActual"
        '
        'cfSaldoAnterior
        '
        Me.cfSaldoAnterior.DataMember = "FlujoEfectivo"
        Me.cfSaldoAnterior.DataSource = Me._Korima2_00_ReporteadorDataSet1
        Me.cfSaldoAnterior.Expression = "Iif([negritas] == 3, '',[SaldoAnterior] )"
        Me.cfSaldoAnterior.Name = "cfSaldoAnterior"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.lblEjercicio, Me.lblEjercicioAnt, Me.XrLabel2})
        Me.GroupHeader1.HeightF = 17.79134!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'lblEjercicio
        '
        Me.lblEjercicio.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblEjercicio.LocationFloat = New DevExpress.Utils.PointFloat(428.125!, 0.0!)
        Me.lblEjercicio.Name = "lblEjercicio"
        Me.lblEjercicio.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblEjercicio.SizeF = New System.Drawing.SizeF(105.1346!, 17.09227!)
        Me.lblEjercicio.StylePriority.UseFont = False
        Me.lblEjercicio.StylePriority.UseTextAlignment = False
        Me.lblEjercicio.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'lblEjercicioAnt
        '
        Me.lblEjercicioAnt.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblEjercicioAnt.LocationFloat = New DevExpress.Utils.PointFloat(540.625!, 0.0!)
        Me.lblEjercicioAnt.Name = "lblEjercicioAnt"
        Me.lblEjercicioAnt.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.lblEjercicioAnt.SizeF = New System.Drawing.SizeF(105.1182!, 17.79134!)
        Me.lblEjercicioAnt.StylePriority.UseFont = False
        Me.lblEjercicioAnt.StylePriority.UseTextAlignment = False
        Me.lblEjercicioAnt.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'XrLabel2
        '
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(342.7085!, 17.09227!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.Text = "Concepto"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'SUBRPT_FlujoDeEfectivoHorSec
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.GroupHeader1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.cfSaldoActual, Me.cfSaldoAnterior})
        Me.DataAdapter = Me.VW_C_UsuariosTableAdapter
        Me.DataMember = "FlujoEfectivo"
        Me.DataSource = Me._Korima2_00_ReporteadorDataSet1
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.formattingRule1, Me.FormattingRule2, Me.FormattingRule3})
        Me.Margins = New System.Drawing.Printing.Margins(100, 100, 97, 0)
        Me.Version = "11.1"
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents _Korima2_00_ReporteadorDataSet1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet
    Friend WithEvents VW_C_UsuariosTableAdapter As Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents cfSaldoActual As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents cfSaldoAnterior As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents formattingRule1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule2 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Public WithEvents lblEjercicio As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents lblEjercicioAnt As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents FormattingRule3 As DevExpress.XtraReports.UI.FormattingRule
End Class
