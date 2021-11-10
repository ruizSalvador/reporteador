<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_Guia_Cumplimiento_LDF
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
        Dim prmNota1 As DevExpress.XtraReports.Parameters.Parameter
        Dim XrSummary1 As DevExpress.XtraReports.UI.XRSummary = New DevExpress.XtraReports.UI.XRSummary()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel24 = New DevExpress.XtraReports.UI.XRLabel()
        Me.FormattingRule2 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.DsNotasBenn1 = New Korima_Reporteador.dsNotasBenn()
        Me.FormattingRule4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.g1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.g2 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.g3 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel23 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel22 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel21 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel20 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel19 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.FormattingRule8 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule6 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule3 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule7 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.PageHeader = New DevExpress.XtraReports.UI.PageHeaderBand()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.line1 = New DevExpress.XtraReports.UI.XRLine()
        Me.lblSubtitulo = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblTitulo = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.pageInfo2 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo1 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo3 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.lblRptNombreReporte = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptNombreEnte = New DevExpress.XtraReports.UI.XRLabel()
        Me.PICEnteLogo = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.lblRptDescripcionFiltrado = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageFooter = New DevExpress.XtraReports.UI.PageFooterBand()
        Me.XrLblIso = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLblUsr = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteDomicilio = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteTelefono = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteRFC = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteCiudad = New DevExpress.XtraReports.UI.XRLabel()
        Me.line2 = New DevExpress.XtraReports.UI.XRLine()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        Me.XrSubreport1 = New DevExpress.XtraReports.UI.XRSubreport()
        Me.RpT_FirmasVertical1 = New Korima_Reporteador.RPT_FirmasVertical()
        Me.FormattingRule1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel10 = New DevExpress.XtraReports.UI.XRLabel()
        Me._Korima2_00_ReporteadorDataSet1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet()
        Me.VW_C_UsuariosTableAdapter = New Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLabel18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel16 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.SumaHorizontal = New DevExpress.XtraReports.UI.CalculatedField()
        Me.EvenStyle = New DevExpress.XtraReports.UI.XRControlStyle()
        prmNota1 = New DevExpress.XtraReports.Parameters.Parameter()
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RpT_FirmasVertical1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'prmNota1
        '
        prmNota1.Description = "Comentarios"
        prmNota1.Name = "prmNota1"
        prmNota1.Value = "Espacio asignado para notas... (Click para editar)"
        prmNota1.Visible = False
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel24, Me.XrLabel23, Me.XrLabel22, Me.XrLabel21, Me.XrLabel20, Me.XrLabel19, Me.XrLabel8})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 79.58672!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel24
        '
        Me.XrLabel24.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel24.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel24.BorderWidth = 1
        Me.XrLabel24.CanGrow = False
        Me.XrLabel24.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Comentarios")})
        Me.XrLabel24.Dpi = 254.0!
        Me.XrLabel24.EvenStyleName = "EvenStyle"
        Me.XrLabel24.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel24.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel24.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel24.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel24.FormattingRules.Add(Me.g1)
        Me.XrLabel24.FormattingRules.Add(Me.g2)
        Me.XrLabel24.FormattingRules.Add(Me.g3)
        Me.XrLabel24.LocationFloat = New DevExpress.Utils.PointFloat(3378.95!, 0.0!)
        Me.XrLabel24.Name = "XrLabel24"
        Me.XrLabel24.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel24.SizeF = New System.Drawing.SizeF(300.0!, 79.58672!)
        Me.XrLabel24.StylePriority.UseBackColor = False
        Me.XrLabel24.StylePriority.UseBorders = False
        Me.XrLabel24.StylePriority.UseBorderWidth = False
        Me.XrLabel24.StylePriority.UseFont = False
        Me.XrLabel24.StylePriority.UsePadding = False
        Me.XrLabel24.StylePriority.UseTextAlignment = False
        Me.XrLabel24.Text = "XrLabel24"
        Me.XrLabel24.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'FormattingRule2
        '
        Me.FormattingRule2.Condition = "[Negritas]=1"
        Me.FormattingRule2.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule2.Formatting.Font = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormattingRule2.Name = "FormattingRule2"
        '
        'DsNotasBenn1
        '
        Me.DsNotasBenn1.DataSetName = "dsNotasBenn"
        Me.DsNotasBenn1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'FormattingRule4
        '
        Me.FormattingRule4.Condition = "[NombreCuenta]='TOTAL'"
        Me.FormattingRule4.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule4.Formatting.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.FormattingRule4.Formatting.BorderWidth = 3
        Me.FormattingRule4.Name = "FormattingRule4"
        '
        'FormattingRule5
        '
        Me.FormattingRule5.Condition = "[NombreCuenta]='TOTAL'"
        Me.FormattingRule5.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule5.Formatting.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        Me.FormattingRule5.Name = "FormattingRule5"
        '
        'g1
        '
        Me.g1.Condition = "[g1]=1"
        '
        '
        '
        Me.g1.Formatting.BackColor = System.Drawing.Color.DarkGray
        Me.g1.Name = "g1"
        '
        'g2
        '
        Me.g2.Condition = "[g2]=1"
        '
        '
        '
        Me.g2.Formatting.BackColor = System.Drawing.Color.Silver
        Me.g2.Name = "g2"
        '
        'g3
        '
        Me.g3.Condition = "[g3]=1"
        '
        '
        '
        Me.g3.Formatting.BackColor = System.Drawing.Color.LightGray
        Me.g3.Name = "g3"
        '
        'XrLabel23
        '
        Me.XrLabel23.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel23.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel23.BorderWidth = 1
        Me.XrLabel23.CanGrow = False
        Me.XrLabel23.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Fundamento")})
        Me.XrLabel23.Dpi = 254.0!
        Me.XrLabel23.EvenStyleName = "EvenStyle"
        Me.XrLabel23.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel23.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel23.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel23.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel23.FormattingRules.Add(Me.g1)
        Me.XrLabel23.FormattingRules.Add(Me.g2)
        Me.XrLabel23.FormattingRules.Add(Me.g3)
        Me.XrLabel23.LocationFloat = New DevExpress.Utils.PointFloat(3033.971!, 0.0!)
        Me.XrLabel23.Name = "XrLabel23"
        Me.XrLabel23.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel23.SizeF = New System.Drawing.SizeF(344.979!, 79.58672!)
        Me.XrLabel23.StylePriority.UseBackColor = False
        Me.XrLabel23.StylePriority.UseBorders = False
        Me.XrLabel23.StylePriority.UseBorderWidth = False
        Me.XrLabel23.StylePriority.UseFont = False
        Me.XrLabel23.StylePriority.UsePadding = False
        Me.XrLabel23.StylePriority.UseTextAlignment = False
        Me.XrLabel23.Text = "XrLabel23"
        Me.XrLabel23.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel22
        '
        Me.XrLabel22.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel22.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel22.BorderWidth = 1
        Me.XrLabel22.CanGrow = False
        Me.XrLabel22.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Unidad")})
        Me.XrLabel22.Dpi = 254.0!
        Me.XrLabel22.EvenStyleName = "EvenStyle"
        Me.XrLabel22.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel22.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel22.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel22.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel22.FormattingRules.Add(Me.g1)
        Me.XrLabel22.FormattingRules.Add(Me.g2)
        Me.XrLabel22.FormattingRules.Add(Me.g3)
        Me.XrLabel22.LocationFloat = New DevExpress.Utils.PointFloat(2654.596!, 0.0!)
        Me.XrLabel22.Name = "XrLabel22"
        Me.XrLabel22.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel22.SizeF = New System.Drawing.SizeF(379.3748!, 79.58672!)
        Me.XrLabel22.StylePriority.UseBackColor = False
        Me.XrLabel22.StylePriority.UseBorders = False
        Me.XrLabel22.StylePriority.UseBorderWidth = False
        Me.XrLabel22.StylePriority.UseFont = False
        Me.XrLabel22.StylePriority.UsePadding = False
        Me.XrLabel22.StylePriority.UseTextAlignment = False
        Me.XrLabel22.Text = "XrLabel22"
        Me.XrLabel22.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel21
        '
        Me.XrLabel21.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel21.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel21.BorderWidth = 1
        Me.XrLabel21.CanGrow = False
        Me.XrLabel21.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Monto", "{0:n2}")})
        Me.XrLabel21.Dpi = 254.0!
        Me.XrLabel21.EvenStyleName = "EvenStyle"
        Me.XrLabel21.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel21.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel21.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel21.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel21.FormattingRules.Add(Me.g1)
        Me.XrLabel21.FormattingRules.Add(Me.g2)
        Me.XrLabel21.FormattingRules.Add(Me.g3)
        Me.XrLabel21.LocationFloat = New DevExpress.Utils.PointFloat(2275.221!, 0.0!)
        Me.XrLabel21.Name = "XrLabel21"
        Me.XrLabel21.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel21.SizeF = New System.Drawing.SizeF(379.3748!, 79.58672!)
        Me.XrLabel21.StylePriority.UseBackColor = False
        Me.XrLabel21.StylePriority.UseBorders = False
        Me.XrLabel21.StylePriority.UseBorderWidth = False
        Me.XrLabel21.StylePriority.UseFont = False
        Me.XrLabel21.StylePriority.UsePadding = False
        Me.XrLabel21.StylePriority.UseTextAlignment = False
        Me.XrLabel21.Text = "XrLabel21"
        Me.XrLabel21.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'XrLabel20
        '
        Me.XrLabel20.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel20.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel20.BorderWidth = 1
        Me.XrLabel20.CanGrow = False
        Me.XrLabel20.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Fecha")})
        Me.XrLabel20.Dpi = 254.0!
        Me.XrLabel20.EvenStyleName = "EvenStyle"
        Me.XrLabel20.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel20.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel20.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel20.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel20.FormattingRules.Add(Me.g1)
        Me.XrLabel20.FormattingRules.Add(Me.g2)
        Me.XrLabel20.FormattingRules.Add(Me.g3)
        Me.XrLabel20.LocationFloat = New DevExpress.Utils.PointFloat(1922.304!, 0.0!)
        Me.XrLabel20.Name = "XrLabel20"
        Me.XrLabel20.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel20.SizeF = New System.Drawing.SizeF(352.9174!, 79.58672!)
        Me.XrLabel20.StylePriority.UseBackColor = False
        Me.XrLabel20.StylePriority.UseBorders = False
        Me.XrLabel20.StylePriority.UseBorderWidth = False
        Me.XrLabel20.StylePriority.UseFont = False
        Me.XrLabel20.StylePriority.UsePadding = False
        Me.XrLabel20.StylePriority.UseTextAlignment = False
        Me.XrLabel20.Text = "XrLabel20"
        Me.XrLabel20.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel19
        '
        Me.XrLabel19.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel19.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.XrLabel19.BorderWidth = 1
        Me.XrLabel19.CanGrow = False
        Me.XrLabel19.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Mecanismo")})
        Me.XrLabel19.Dpi = 254.0!
        Me.XrLabel19.EvenStyleName = "EvenStyle"
        Me.XrLabel19.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel19.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel19.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel19.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel19.FormattingRules.Add(Me.g1)
        Me.XrLabel19.FormattingRules.Add(Me.g2)
        Me.XrLabel19.FormattingRules.Add(Me.g3)
        Me.XrLabel19.LocationFloat = New DevExpress.Utils.PointFloat(1437.095!, 0.0!)
        Me.XrLabel19.Name = "XrLabel19"
        Me.XrLabel19.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel19.SizeF = New System.Drawing.SizeF(485.2087!, 79.58672!)
        Me.XrLabel19.StylePriority.UseBackColor = False
        Me.XrLabel19.StylePriority.UseBorders = False
        Me.XrLabel19.StylePriority.UseBorderWidth = False
        Me.XrLabel19.StylePriority.UseFont = False
        Me.XrLabel19.StylePriority.UsePadding = False
        Me.XrLabel19.StylePriority.UseTextAlignment = False
        Me.XrLabel19.Text = "XrLabel19"
        Me.XrLabel19.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'XrLabel8
        '
        Me.XrLabel8.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel8.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel8.BorderWidth = 1
        Me.XrLabel8.CanGrow = False
        Me.XrLabel8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Guia_Cumplimiento_LDF.Concepto")})
        Me.XrLabel8.Dpi = 254.0!
        Me.XrLabel8.EvenStyleName = "EvenStyle"
        Me.XrLabel8.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel8.FormattingRules.Add(Me.FormattingRule2)
        Me.XrLabel8.FormattingRules.Add(Me.FormattingRule4)
        Me.XrLabel8.FormattingRules.Add(Me.FormattingRule5)
        Me.XrLabel8.FormattingRules.Add(Me.g1)
        Me.XrLabel8.FormattingRules.Add(Me.g2)
        Me.XrLabel8.FormattingRules.Add(Me.g3)
        Me.XrLabel8.LocationFloat = New DevExpress.Utils.PointFloat(5.475118!, 0.0!)
        Me.XrLabel8.Name = "XrLabel8"
        Me.XrLabel8.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel8.SizeF = New System.Drawing.SizeF(1431.62!, 79.58672!)
        Me.XrLabel8.StylePriority.UseBackColor = False
        Me.XrLabel8.StylePriority.UseBorders = False
        Me.XrLabel8.StylePriority.UseBorderWidth = False
        Me.XrLabel8.StylePriority.UseFont = False
        Me.XrLabel8.StylePriority.UsePadding = False
        Me.XrLabel8.StylePriority.UseTextAlignment = False
        Me.XrLabel8.Text = "XrLabel8"
        Me.XrLabel8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'FormattingRule8
        '
        Me.FormattingRule8.Condition = "[NumeroCuenta] like '221%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '222%' "
        Me.FormattingRule8.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule8.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule8.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.FormattingRule8.Name = "FormattingRule8"
        '
        'FormattingRule6
        '
        Me.FormattingRule6.Condition = "[NumeroCuenta] like '211%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '212%' "
        Me.FormattingRule6.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule6.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule6.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.FormattingRule6.Name = "FormattingRule6"
        '
        'FormattingRule3
        '
        Me.FormattingRule3.Condition = "[NombreCuenta]='TOTAL'"
        Me.FormattingRule3.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule3.Formatting.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.FormattingRule3.Formatting.BorderWidth = 3
        Me.FormattingRule3.Name = "FormattingRule3"
        '
        'FormattingRule7
        '
        Me.FormattingRule7.Condition = "[NumeroCuenta] = 'TOTAL'"
        Me.FormattingRule7.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule7.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule7.Name = "FormattingRule7"
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PICEnteLogoSecundario, Me.line1, Me.lblSubtitulo, Me.lblTitulo, Me.XrLabel1, Me.pageInfo2, Me.pageInfo1, Me.pageInfo3, Me.lblRptNombreReporte, Me.lblRptNombreEnte, Me.PICEnteLogo, Me.lblRptDescripcionFiltrado})
        Me.PageHeader.Dpi = 254.0!
        Me.PageHeader.HeightF = 438.7584!
        Me.PageHeader.Name = "PageHeader"
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(2824.685!, 66.14584!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'line1
        '
        Me.line1.Dpi = 254.0!
        Me.line1.LineWidth = 3
        Me.line1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 381.0!)
        Me.line1.Name = "line1"
        Me.line1.SizeF = New System.Drawing.SizeF(3678.949!, 15.875!)
        '
        'lblSubtitulo
        '
        Me.lblSubtitulo.Dpi = 254.0!
        Me.lblSubtitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSubtitulo.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 179.5993!)
        Me.lblSubtitulo.Name = "lblSubtitulo"
        Me.lblSubtitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblSubtitulo.SizeF = New System.Drawing.SizeF(1897.379!, 49.95338!)
        Me.lblSubtitulo.StylePriority.UseFont = False
        Me.lblSubtitulo.StylePriority.UseTextAlignment = False
        Me.lblSubtitulo.Text = "Sub titulo"
        Me.lblSubtitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblTitulo
        '
        Me.lblTitulo.Dpi = 254.0!
        Me.lblTitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitulo.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 129.6458!)
        Me.lblTitulo.Name = "lblTitulo"
        Me.lblTitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblTitulo.SizeF = New System.Drawing.SizeF(1897.379!, 49.9534!)
        Me.lblTitulo.StylePriority.UseFont = False
        Me.lblTitulo.StylePriority.UseTextAlignment = False
        Me.lblTitulo.Text = "Titulo"
        Me.lblTitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel1
        '
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 279.506!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(1897.379!, 58.41998!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "(En miles de pesos)"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo2
        '
        Me.pageInfo2.Dpi = 254.0!
        Me.pageInfo2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo2.Format = "{0:HH:mm}"
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(3275.288!, 171.1326!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(403.6619!, 58.42007!)
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo1
        '
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(3275.288!, 107.6325!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(403.662!, 58.41997!)
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo3
        '
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(3275.288!, 44.13264!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(403.6621!, 58.42002!)
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 66.14584!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(1897.379!, 58.41999!)
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 2.645833!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(1897.379!, 58.41998!)
        Me.lblRptNombreEnte.StylePriority.UseFont = False
        Me.lblRptNombreEnte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreEnte.Text = "Nombre del Ente público"
        Me.lblRptNombreEnte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PICEnteLogo
        '
        Me.PICEnteLogo.Dpi = 254.0!
        Me.PICEnteLogo.LocationFloat = New DevExpress.Utils.PointFloat(391.5835!, 66.14584!)
        Me.PICEnteLogo.Name = "PICEnteLogo"
        Me.PICEnteLogo.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogo.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'lblRptDescripcionFiltrado
        '
        Me.lblRptDescripcionFiltrado.Dpi = 254.0!
        Me.lblRptDescripcionFiltrado.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptDescripcionFiltrado.LocationFloat = New DevExpress.Utils.PointFloat(769.9375!, 229.5526!)
        Me.lblRptDescripcionFiltrado.Name = "lblRptDescripcionFiltrado"
        Me.lblRptDescripcionFiltrado.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptDescripcionFiltrado.SizeF = New System.Drawing.SizeF(1897.379!, 49.95337!)
        Me.lblRptDescripcionFiltrado.StylePriority.UseFont = False
        Me.lblRptDescripcionFiltrado.StylePriority.UseTextAlignment = False
        Me.lblRptDescripcionFiltrado.Text = "Fecha o Rango"
        Me.lblRptDescripcionFiltrado.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLblIso, Me.XrLblUsr, Me.lblRptEnteDomicilio, Me.lblRptEnteTelefono, Me.lblRptEnteRFC, Me.lblRptEnteCiudad, Me.line2})
        Me.PageFooter.Dpi = 254.0!
        Me.PageFooter.HeightF = 125.5897!
        Me.PageFooter.Name = "PageFooter"
        '
        'XrLblIso
        '
        Me.XrLblIso.Dpi = 254.0!
        Me.XrLblIso.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(3192.115!, 62.08973!)
        Me.XrLblIso.Name = "XrLblIso"
        Me.XrLblIso.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLblIso.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.XrLblIso.StylePriority.UseFont = False
        Me.XrLblIso.StylePriority.UseTextAlignment = False
        Me.XrLblIso.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'XrLblUsr
        '
        Me.XrLblUsr.Dpi = 254.0!
        Me.XrLblUsr.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(3192.116!, 19.54469!)
        Me.XrLblUsr.Name = "XrLblUsr"
        Me.XrLblUsr.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLblUsr.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.XrLblUsr.StylePriority.UseFont = False
        Me.XrLblUsr.StylePriority.UseTextAlignment = False
        Me.XrLblUsr.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'lblRptEnteDomicilio
        '
        Me.lblRptEnteDomicilio.Dpi = 254.0!
        Me.lblRptEnteDomicilio.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteDomicilio.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 19.54469!)
        Me.lblRptEnteDomicilio.Name = "lblRptEnteDomicilio"
        Me.lblRptEnteDomicilio.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteDomicilio.SizeF = New System.Drawing.SizeF(1119.188!, 42.545!)
        Me.lblRptEnteDomicilio.StylePriority.UseFont = False
        '
        'lblRptEnteTelefono
        '
        Me.lblRptEnteTelefono.Dpi = 254.0!
        Me.lblRptEnteTelefono.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteTelefono.LocationFloat = New DevExpress.Utils.PointFloat(635.0!, 62.08973!)
        Me.lblRptEnteTelefono.Name = "lblRptEnteTelefono"
        Me.lblRptEnteTelefono.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteTelefono.SizeF = New System.Drawing.SizeF(632.3541!, 42.54501!)
        Me.lblRptEnteTelefono.StylePriority.UseFont = False
        '
        'lblRptEnteRFC
        '
        Me.lblRptEnteRFC.Dpi = 254.0!
        Me.lblRptEnteRFC.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteRFC.LocationFloat = New DevExpress.Utils.PointFloat(1119.188!, 19.54469!)
        Me.lblRptEnteRFC.Name = "lblRptEnteRFC"
        Me.lblRptEnteRFC.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteRFC.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.lblRptEnteRFC.StylePriority.UseFont = False
        '
        'lblRptEnteCiudad
        '
        Me.lblRptEnteCiudad.Dpi = 254.0!
        Me.lblRptEnteCiudad.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteCiudad.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 62.08973!)
        Me.lblRptEnteCiudad.Name = "lblRptEnteCiudad"
        Me.lblRptEnteCiudad.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteCiudad.SizeF = New System.Drawing.SizeF(632.3541!, 42.545!)
        Me.lblRptEnteCiudad.StylePriority.UseFont = False
        '
        'line2
        '
        Me.line2.Dpi = 254.0!
        Me.line2.LineWidth = 3
        Me.line2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.line2.Name = "line2"
        Me.line2.SizeF = New System.Drawing.SizeF(3678.949!, 19.54469!)
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrSubreport1})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 214.8539!
        Me.ReportFooter.KeepTogether = True
        Me.ReportFooter.Name = "ReportFooter"
        '
        'XrSubreport1
        '
        Me.XrSubreport1.Dpi = 254.0!
        Me.XrSubreport1.LocationFloat = New DevExpress.Utils.PointFloat(635.0!, 63.5!)
        Me.XrSubreport1.Name = "XrSubreport1"
        Me.XrSubreport1.ReportSource = Me.RpT_FirmasVertical1
        Me.XrSubreport1.SizeF = New System.Drawing.SizeF(2930.179!, 58.41992!)
        '
        'FormattingRule1
        '
        Me.FormattingRule1.Condition = "[Parameters.prmNota1]  Like  'Espacio asignado para notas%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Parameters.prmTi" & _
    "po]  Like  'Espacio asignado para notas%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Parameters.prmNaturaleza] Like  '" & _
    "Espacio asignado para notas%' "
        Me.FormattingRule1.DataSource = Me.DsNotasBenn1
        '
        '
        '
        Me.FormattingRule1.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Italic), System.Drawing.FontStyle), System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormattingRule1.Formatting.ForeColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.FormattingRule1.Name = "FormattingRule1"
        '
        'XrLabel5
        '
        Me.XrLabel5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel5.BorderWidth = 1
        Me.XrLabel5.Dpi = 254.0!
        Me.XrLabel5.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel5.ForeColor = System.Drawing.Color.Transparent
        Me.XrLabel5.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.XrLabel5.Name = "XrLabel5"
        Me.XrLabel5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel5.SizeF = New System.Drawing.SizeF(1325.543!, 63.0!)
        Me.XrLabel5.StylePriority.UseBorders = False
        Me.XrLabel5.StylePriority.UseBorderWidth = False
        Me.XrLabel5.StylePriority.UseFont = False
        Me.XrLabel5.StylePriority.UseForeColor = False
        Me.XrLabel5.StylePriority.UseTextAlignment = False
        Me.XrLabel5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel10
        '
        Me.XrLabel10.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel10.BorderWidth = 1
        Me.XrLabel10.CanGrow = False
        Me.XrLabel10.Dpi = 254.0!
        Me.XrLabel10.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLabel10.ForeColor = System.Drawing.Color.Transparent
        Me.XrLabel10.LocationFloat = New DevExpress.Utils.PointFloat(1330.836!, 0.0!)
        Me.XrLabel10.Name = "XrLabel10"
        Me.XrLabel10.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 11, 0, 0, 254.0!)
        Me.XrLabel10.SizeF = New System.Drawing.SizeF(383.2084!, 63.0!)
        Me.XrLabel10.StylePriority.UseBorders = False
        Me.XrLabel10.StylePriority.UseBorderWidth = False
        Me.XrLabel10.StylePriority.UseFont = False
        Me.XrLabel10.StylePriority.UseForeColor = False
        Me.XrLabel10.StylePriority.UsePadding = False
        Me.XrLabel10.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Report
        Me.XrLabel10.Summary = XrSummary1
        Me.XrLabel10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        '_Korima2_00_ReporteadorDataSet1
        '
        Me._Korima2_00_ReporteadorDataSet1.DataSetName = "_Korima2_00_ReporteadorDataSet"
        Me._Korima2_00_ReporteadorDataSet1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'VW_C_UsuariosTableAdapter
        '
        Me.VW_C_UsuariosTableAdapter.ClearBeforeFill = True
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel14, Me.XrLabel13, Me.XrLabel5, Me.XrLabel10})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 63.0!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'XrLabel14
        '
        Me.XrLabel14.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel14.BorderWidth = 1
        Me.XrLabel14.Dpi = 254.0!
        Me.XrLabel14.ForeColor = System.Drawing.Color.Transparent
        Me.XrLabel14.LocationFloat = New DevExpress.Utils.PointFloat(2077.296!, 0.0!)
        Me.XrLabel14.Name = "XrLabel14"
        Me.XrLabel14.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel14.SizeF = New System.Drawing.SizeF(1601.653!, 63.0!)
        Me.XrLabel14.StylePriority.UseBorders = False
        Me.XrLabel14.StylePriority.UseBorderWidth = False
        Me.XrLabel14.StylePriority.UseForeColor = False
        '
        'XrLabel13
        '
        Me.XrLabel13.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel13.BorderWidth = 1
        Me.XrLabel13.Dpi = 254.0!
        Me.XrLabel13.ForeColor = System.Drawing.Color.Transparent
        Me.XrLabel13.LocationFloat = New DevExpress.Utils.PointFloat(1714.044!, 0.0!)
        Me.XrLabel13.Name = "XrLabel13"
        Me.XrLabel13.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel13.SizeF = New System.Drawing.SizeF(363.2515!, 63.0!)
        Me.XrLabel13.StylePriority.UseBorders = False
        Me.XrLabel13.StylePriority.UseBorderWidth = False
        Me.XrLabel13.StylePriority.UseForeColor = False
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel18, Me.XrLabel17, Me.XrLabel16, Me.XrLabel12, Me.XrLabel3, Me.XrLabel9, Me.XrLabel7, Me.XrLabel4, Me.XrLabel15, Me.XrLabel11, Me.XrLabel6, Me.XrLabel2})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("Grupo", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 214.5243!
        Me.GroupHeader1.KeepTogether = True
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.RepeatEveryPage = True
        '
        'XrLabel18
        '
        Me.XrLabel18.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel18.BorderWidth = 1
        Me.XrLabel18.Dpi = 254.0!
        Me.XrLabel18.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel18.LocationFloat = New DevExpress.Utils.PointFloat(2275.221!, 0.0001614888!)
        Me.XrLabel18.Name = "XrLabel18"
        Me.XrLabel18.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel18.SizeF = New System.Drawing.SizeF(758.7495!, 66.14584!)
        Me.XrLabel18.StylePriority.UseBorders = False
        Me.XrLabel18.StylePriority.UseBorderWidth = False
        Me.XrLabel18.StylePriority.UseFont = False
        Me.XrLabel18.StylePriority.UseTextAlignment = False
        Me.XrLabel18.Text = "Resultado"
        Me.XrLabel18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel17
        '
        Me.XrLabel17.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel17.BorderWidth = 1
        Me.XrLabel17.Dpi = 254.0!
        Me.XrLabel17.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel17.LocationFloat = New DevExpress.Utils.PointFloat(2275.221!, 66.14584!)
        Me.XrLabel17.Name = "XrLabel17"
        Me.XrLabel17.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel17.SizeF = New System.Drawing.SizeF(758.7495!, 66.14585!)
        Me.XrLabel17.StylePriority.UseBorders = False
        Me.XrLabel17.StylePriority.UseBorderWidth = False
        Me.XrLabel17.StylePriority.UseFont = False
        Me.XrLabel17.StylePriority.UseTextAlignment = False
        Me.XrLabel17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel16
        '
        Me.XrLabel16.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel16.BorderWidth = 1
        Me.XrLabel16.Dpi = 254.0!
        Me.XrLabel16.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel16.LocationFloat = New DevExpress.Utils.PointFloat(1922.304!, 66.14584!)
        Me.XrLabel16.Name = "XrLabel16"
        Me.XrLabel16.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel16.SizeF = New System.Drawing.SizeF(352.917!, 66.14585!)
        Me.XrLabel16.StylePriority.UseBorders = False
        Me.XrLabel16.StylePriority.UseBorderWidth = False
        Me.XrLabel16.StylePriority.UseFont = False
        Me.XrLabel16.StylePriority.UseTextAlignment = False
        Me.XrLabel16.Text = "NO"
        Me.XrLabel16.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel12
        '
        Me.XrLabel12.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel12.BorderWidth = 1
        Me.XrLabel12.Dpi = 254.0!
        Me.XrLabel12.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(1437.096!, 66.14584!)
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(485.2079!, 66.14584!)
        Me.XrLabel12.StylePriority.UseBorders = False
        Me.XrLabel12.StylePriority.UseBorderWidth = False
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.Text = "SI"
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel3
        '
        Me.XrLabel3.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel3.BorderWidth = 1
        Me.XrLabel3.Dpi = 254.0!
        Me.XrLabel3.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(1437.096!, 0.0!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(838.125!, 66.14584!)
        Me.XrLabel3.StylePriority.UseBorders = False
        Me.XrLabel3.StylePriority.UseBorderWidth = False
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.StylePriority.UseTextAlignment = False
        Me.XrLabel3.Text = "Implementación"
        Me.XrLabel3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel9
        '
        Me.XrLabel9.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel9.BorderWidth = 1
        Me.XrLabel9.Dpi = 254.0!
        Me.XrLabel9.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel9.LocationFloat = New DevExpress.Utils.PointFloat(3378.95!, 0.00008074442!)
        Me.XrLabel9.Name = "XrLabel9"
        Me.XrLabel9.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel9.SizeF = New System.Drawing.SizeF(300.0!, 214.5241!)
        Me.XrLabel9.StylePriority.UseBorders = False
        Me.XrLabel9.StylePriority.UseBorderWidth = False
        Me.XrLabel9.StylePriority.UseFont = False
        Me.XrLabel9.StylePriority.UseTextAlignment = False
        Me.XrLabel9.Text = "Comentarios (i)"
        Me.XrLabel9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel7
        '
        Me.XrLabel7.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel7.BorderWidth = 1
        Me.XrLabel7.Dpi = 254.0!
        Me.XrLabel7.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel7.LocationFloat = New DevExpress.Utils.PointFloat(3033.971!, 0.0001614888!)
        Me.XrLabel7.Name = "XrLabel7"
        Me.XrLabel7.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel7.SizeF = New System.Drawing.SizeF(344.979!, 214.5241!)
        Me.XrLabel7.StylePriority.UseBorders = False
        Me.XrLabel7.StylePriority.UseBorderWidth = False
        Me.XrLabel7.StylePriority.UseFont = False
        Me.XrLabel7.StylePriority.UseTextAlignment = False
        Me.XrLabel7.Text = "Fundamento (h)"
        Me.XrLabel7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel4
        '
        Me.XrLabel4.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel4.BorderWidth = 1
        Me.XrLabel4.Dpi = 254.0!
        Me.XrLabel4.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(2654.596!, 132.2918!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(379.375!, 82.23247!)
        Me.XrLabel4.StylePriority.UseBorders = False
        Me.XrLabel4.StylePriority.UseBorderWidth = False
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.StylePriority.UseTextAlignment = False
        Me.XrLabel4.Text = "Unidad (Pesos/Porcentaje) (g)"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel15
        '
        Me.XrLabel15.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel15.BorderWidth = 1
        Me.XrLabel15.Dpi = 254.0!
        Me.XrLabel15.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel15.LocationFloat = New DevExpress.Utils.PointFloat(2275.221!, 132.2918!)
        Me.XrLabel15.Name = "XrLabel15"
        Me.XrLabel15.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel15.SizeF = New System.Drawing.SizeF(379.375!, 82.23247!)
        Me.XrLabel15.StylePriority.UseBorders = False
        Me.XrLabel15.StylePriority.UseBorderWidth = False
        Me.XrLabel15.StylePriority.UseFont = False
        Me.XrLabel15.StylePriority.UseTextAlignment = False
        Me.XrLabel15.Text = "Monto o Valor (f)"
        Me.XrLabel15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel11
        '
        Me.XrLabel11.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel11.BorderWidth = 1
        Me.XrLabel11.Dpi = 254.0!
        Me.XrLabel11.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel11.LocationFloat = New DevExpress.Utils.PointFloat(1922.304!, 132.2917!)
        Me.XrLabel11.Name = "XrLabel11"
        Me.XrLabel11.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel11.SizeF = New System.Drawing.SizeF(352.9167!, 82.23245!)
        Me.XrLabel11.StylePriority.UseBorders = False
        Me.XrLabel11.StylePriority.UseBorderWidth = False
        Me.XrLabel11.StylePriority.UseFont = False
        Me.XrLabel11.StylePriority.UseTextAlignment = False
        Me.XrLabel11.Text = "Fecha Estimada de Cumplimiento (e)"
        Me.XrLabel11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel6
        '
        Me.XrLabel6.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel6.BorderWidth = 1
        Me.XrLabel6.Dpi = 254.0!
        Me.XrLabel6.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(1437.096!, 132.2917!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(485.2079!, 82.23242!)
        Me.XrLabel6.StylePriority.UseBorders = False
        Me.XrLabel6.StylePriority.UseBorderWidth = False
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        Me.XrLabel6.Text = "Mecanismo de Verificación (d)"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel2
        '
        Me.XrLabel2.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel2.BorderWidth = 1
        Me.XrLabel2.Dpi = 254.0!
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(5.475118!, 0.0!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(1431.621!, 214.5241!)
        Me.XrLabel2.StylePriority.UseBorders = False
        Me.XrLabel2.StylePriority.UseBorderWidth = False
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.Text = "Indicadores de Observancia (c)"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'SumaHorizontal
        '
        Me.SumaHorizontal.DataSource = Me.DsNotasBenn1
        Me.SumaHorizontal.Expression = "Iif([NumeroCuenta] Like '22%' ,[MasDe365] ,[Nota1] + [Nota2] + [Nota3])"
        Me.SumaHorizontal.Name = "SumaHorizontal"
        '
        'EvenStyle
        '
        Me.EvenStyle.BackColor = System.Drawing.Color.Transparent
        Me.EvenStyle.Name = "EvenStyle"
        '
        'RPT_Guia_Cumplimiento_LDF
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.PageHeader, Me.PageFooter, Me.ReportFooter, Me.GroupHeader1, Me.GroupFooter1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.SumaHorizontal})
        Me.DataAdapter = Me.VW_C_UsuariosTableAdapter
        Me.DataMember = "SP_Guia_Cumplimiento_LDF"
        Me.DataSource = Me.DsNotasBenn1
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.FormattingRule1, Me.FormattingRule2, Me.FormattingRule3, Me.FormattingRule4, Me.FormattingRule5, Me.FormattingRule6, Me.FormattingRule7, Me.FormattingRule8, Me.g1, Me.g2, Me.g3})
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(190, 93, 100, 100)
        Me.PageHeight = 2110
        Me.PageWidth = 4050
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {prmNota1})
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.StyleSheet.AddRange(New DevExpress.XtraReports.UI.XRControlStyle() {Me.EvenStyle})
        Me.Version = "11.1"
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RpT_FirmasVertical1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents PageHeader As DevExpress.XtraReports.UI.PageHeaderBand
    Friend WithEvents line1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents lblSubtitulo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblTitulo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents pageInfo2 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo1 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo3 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents lblRptNombreReporte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptNombreEnte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PICEnteLogo As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents lblRptDescripcionFiltrado As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents _Korima2_00_ReporteadorDataSet1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet
    Friend WithEvents VW_C_UsuariosTableAdapter As Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter
    Friend WithEvents XrLabel5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents FormattingRule1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents FormattingRule2 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule4 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule3 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel15 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents FormattingRule6 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule7 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule8 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents SumaHorizontal As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents EvenStyle As DevExpress.XtraReports.UI.XRControlStyle
    Friend WithEvents DsNotasBenn1 As Korima_Reporteador.dsNotasBenn
    Friend WithEvents XrSubreport1 As DevExpress.XtraReports.UI.XRSubreport
    Private WithEvents RpT_FirmasVertical1 As Korima_Reporteador.RPT_FirmasVertical
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents XrLabel18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel16 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents g1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents g2 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents g3 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel19 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel24 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel23 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel22 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel21 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel20 As DevExpress.XtraReports.UI.XRLabel
End Class
