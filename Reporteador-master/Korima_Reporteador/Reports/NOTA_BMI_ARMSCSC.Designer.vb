<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class NOTA_BMI_ARMSCSC
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
        Me.XrTable1 = New DevExpress.XtraReports.UI.XRTable()
        Me.XrTableRow1 = New DevExpress.XtraReports.UI.XRTableRow()
        Me.XrTableCell2 = New DevExpress.XtraReports.UI.XRTableCell()
        Me.tipo = New DevExpress.XtraReports.UI.FormattingRule()
        Me.negritas = New DevExpress.XtraReports.UI.FormattingRule()
        Me.lbl_Notas2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lbl_Cuenta = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.encabezadosdatos = New DevExpress.XtraReports.UI.FormattingRule()
        Me.transparentes = New DevExpress.XtraReports.UI.FormattingRule()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.PageHeader = New DevExpress.XtraReports.UI.PageHeaderBand()
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
        Me.XrPanel1 = New DevExpress.XtraReports.UI.XRPanel()
        Me.lblhprmNota1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lbl_prmNota1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrSubreport1 = New DevExpress.XtraReports.UI.XRSubreport()
        Me.RpT_FirmasVertical1 = New Korima_Reporteador.RPT_FirmasVertical()
        Me.DataSetDavid1 = New Korima_Reporteador.DataSetDavid()
        Me.XrLabel5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLine1 = New DevExpress.XtraReports.UI.XRLine()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLabel7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine2 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrCrossBandBox1 = New DevExpress.XtraReports.UI.XRCrossBandBox()
        Me.XrCrossBandLine2 = New DevExpress.XtraReports.UI.XRCrossBandLine()
        Me.XrCrossBandLine1 = New DevExpress.XtraReports.UI.XRCrossBandLine()
        Me.XrCrossBandLine3 = New DevExpress.XtraReports.UI.XRCrossBandLine()
        Me.XrCrossBandLine4 = New DevExpress.XtraReports.UI.XRCrossBandLine()
        Me.XrCrossBandLine5 = New DevExpress.XtraReports.UI.XRCrossBandLine()
        Me.sumatoria = New DevExpress.XtraReports.UI.CalculatedField()
        Me.percent = New DevExpress.XtraReports.UI.CalculatedField()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        prmNota1 = New DevExpress.XtraReports.Parameters.Parameter()
        CType(Me.XrTable1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RpT_FirmasVertical1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DataSetDavid1, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrTable1, Me.lbl_Notas2, Me.XrLabel9, Me.XrLabel8, Me.lbl_Cuenta, Me.XrLabel4, Me.XrLabel14})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 37.04171!
        Me.Detail.KeepTogether = True
        Me.Detail.MultiColumn.Mode = DevExpress.XtraReports.UI.MultiColumnMode.UseColumnWidth
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrTable1
        '
        Me.XrTable1.Dpi = 254.0!
        Me.XrTable1.LocationFloat = New DevExpress.Utils.PointFloat(984.119!, 0.0!)
        Me.XrTable1.Name = "XrTable1"
        Me.XrTable1.Rows.AddRange(New DevExpress.XtraReports.UI.XRTableRow() {Me.XrTableRow1})
        Me.XrTable1.SizeF = New System.Drawing.SizeF(273.6517!, 35.0!)
        '
        'XrTableRow1
        '
        Me.XrTableRow1.Cells.AddRange(New DevExpress.XtraReports.UI.XRTableCell() {Me.XrTableCell2})
        Me.XrTableRow1.Dpi = 254.0!
        Me.XrTableRow1.Name = "XrTableRow1"
        Me.XrTableRow1.Weight = 1.0R
        '
        'XrTableCell2
        '
        Me.XrTableCell2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.Nota1", "{0:n2}")})
        Me.XrTableCell2.Dpi = 254.0!
        Me.XrTableCell2.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.XrTableCell2.FormattingRules.Add(Me.tipo)
        Me.XrTableCell2.FormattingRules.Add(Me.negritas)
        Me.XrTableCell2.Name = "XrTableCell2"
        Me.XrTableCell2.StylePriority.UseFont = False
        Me.XrTableCell2.StylePriority.UseTextAlignment = False
        Me.XrTableCell2.Text = "XrTableCell2"
        Me.XrTableCell2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrTableCell2.Weight = 2.9999999999999996R
        '
        'tipo
        '
        Me.tipo.Condition = "[Tipo] == True"
        '
        '
        '
        Me.tipo.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tipo.Name = "tipo"
        '
        'negritas
        '
        Me.negritas.Condition = "[Negritas]  == True"
        '
        '
        '
        Me.negritas.Formatting.Font = New System.Drawing.Font("Tahoma", 6.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.negritas.Name = "negritas"
        '
        'lbl_Notas2
        '
        Me.lbl_Notas2.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.Nota2")})
        Me.lbl_Notas2.Dpi = 254.0!
        Me.lbl_Notas2.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.lbl_Notas2.KeepTogether = True
        Me.lbl_Notas2.LocationFloat = New DevExpress.Utils.PointFloat(1358.286!, 0.0!)
        Me.lbl_Notas2.LockedInUserDesigner = True
        Me.lbl_Notas2.Multiline = True
        Me.lbl_Notas2.Name = "lbl_Notas2"
        Me.lbl_Notas2.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.lbl_Notas2.ProcessNullValues = DevExpress.XtraReports.UI.ValueSuppressType.Suppress
        Me.lbl_Notas2.SizeF = New System.Drawing.SizeF(488.7056!, 35.0!)
        Me.lbl_Notas2.StylePriority.UseFont = False
        Me.lbl_Notas2.StylePriority.UsePadding = False
        Me.lbl_Notas2.Text = "Click para editar..."
        '
        'XrLabel9
        '
        Me.XrLabel9.CanGrow = False
        Me.XrLabel9.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.Monto", "{0:n2}")})
        Me.XrLabel9.Dpi = 254.0!
        Me.XrLabel9.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.XrLabel9.FormattingRules.Add(Me.tipo)
        Me.XrLabel9.FormattingRules.Add(Me.negritas)
        Me.XrLabel9.LocationFloat = New DevExpress.Utils.PointFloat(786.75!, 0.0!)
        Me.XrLabel9.Name = "XrLabel9"
        Me.XrLabel9.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 11, 0, 0, 254.0!)
        Me.XrLabel9.SizeF = New System.Drawing.SizeF(190.3009!, 35.0!)
        Me.XrLabel9.StylePriority.UseFont = False
        Me.XrLabel9.StylePriority.UsePadding = False
        Me.XrLabel9.StylePriority.UseTextAlignment = False
        Me.XrLabel9.Text = "XrLabel9"
        Me.XrLabel9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel8
        '
        Me.XrLabel8.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.Nombre")})
        Me.XrLabel8.Dpi = 254.0!
        Me.XrLabel8.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.XrLabel8.FormattingRules.Add(Me.tipo)
        Me.XrLabel8.FormattingRules.Add(Me.negritas)
        Me.XrLabel8.LocationFloat = New DevExpress.Utils.PointFloat(167.118!, 0.0!)
        Me.XrLabel8.Name = "XrLabel8"
        Me.XrLabel8.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.XrLabel8.SizeF = New System.Drawing.SizeF(615.3822!, 35.0!)
        Me.XrLabel8.StylePriority.UseFont = False
        Me.XrLabel8.StylePriority.UsePadding = False
        Me.XrLabel8.Text = "XrLabel8"
        '
        'lbl_Cuenta
        '
        Me.lbl_Cuenta.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.Cuenta")})
        Me.lbl_Cuenta.Dpi = 254.0!
        Me.lbl_Cuenta.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.lbl_Cuenta.FormattingRules.Add(Me.tipo)
        Me.lbl_Cuenta.FormattingRules.Add(Me.negritas)
        Me.lbl_Cuenta.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.lbl_Cuenta.Name = "lbl_Cuenta"
        Me.lbl_Cuenta.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.lbl_Cuenta.SizeF = New System.Drawing.SizeF(157.118!, 35.0!)
        Me.lbl_Cuenta.StylePriority.UseFont = False
        Me.lbl_Cuenta.StylePriority.UsePadding = False
        Me.lbl_Cuenta.StylePriority.UseTextAlignment = False
        Me.lbl_Cuenta.Text = "lbl_Cuenta"
        Me.lbl_Cuenta.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'XrLabel4
        '
        Me.XrLabel4.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.sumatoria")})
        Me.XrLabel4.Dpi = 254.0!
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(1872.833!, 5.080036!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(29.10437!, 31.96167!)
        Me.XrLabel4.Text = "XrLabel4"
        Me.XrLabel4.Visible = False
        '
        'XrLabel14
        '
        Me.XrLabel14.CanGrow = False
        Me.XrLabel14.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.percent", "{0:0.00}")})
        Me.XrLabel14.Dpi = 254.0!
        Me.XrLabel14.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.XrLabel14.FormattingRules.Add(Me.tipo)
        Me.XrLabel14.FormattingRules.Add(Me.negritas)
        Me.XrLabel14.LocationFloat = New DevExpress.Utils.PointFloat(1266.25!, 0.0!)
        Me.XrLabel14.Name = "XrLabel14"
        Me.XrLabel14.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 11, 0, 0, 254.0!)
        Me.XrLabel14.SizeF = New System.Drawing.SizeF(83.82178!, 35.0!)
        Me.XrLabel14.StylePriority.UseFont = False
        Me.XrLabel14.StylePriority.UsePadding = False
        Me.XrLabel14.StylePriority.UseTextAlignment = False
        Me.XrLabel14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'encabezadosdatos
        '
        Me.encabezadosdatos.Condition = "[Negritas] == True"
        '
        '
        '
        Me.encabezadosdatos.Formatting.ForeColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.encabezadosdatos.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[False]
        Me.encabezadosdatos.Name = "encabezadosdatos"
        '
        'transparentes
        '
        Me.transparentes.Condition = "[Cuenta]  !=  [tmp1]"
        '
        '
        '
        Me.transparentes.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.transparentes.Name = "transparentes"
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
        Me.PageHeader.HeightF = 444.7118!
        Me.PageHeader.Name = "PageHeader"
        '
        'line1
        '
        Me.line1.Dpi = 254.0!
        Me.line1.LineWidth = 3
        Me.line1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 381.0!)
        Me.line1.Name = "line1"
        Me.line1.SizeF = New System.Drawing.SizeF(1858.0!, 15.875!)
        '
        'lblSubtitulo
        '
        Me.lblSubtitulo.Dpi = 254.0!
        Me.lblSubtitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSubtitulo.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 176.9534!)
        Me.lblSubtitulo.Name = "lblSubtitulo"
        Me.lblSubtitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblSubtitulo.SizeF = New System.Drawing.SizeF(1111.567!, 49.95338!)
        Me.lblSubtitulo.StylePriority.UseFont = False
        Me.lblSubtitulo.StylePriority.UseTextAlignment = False
        Me.lblSubtitulo.Text = "Sub titulo"
        Me.lblSubtitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblTitulo
        '
        Me.lblTitulo.Dpi = 254.0!
        Me.lblTitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitulo.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 127.0!)
        Me.lblTitulo.Name = "lblTitulo"
        Me.lblTitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblTitulo.SizeF = New System.Drawing.SizeF(1111.567!, 49.9534!)
        Me.lblTitulo.StylePriority.UseFont = False
        Me.lblTitulo.StylePriority.UseTextAlignment = False
        Me.lblTitulo.Text = "Titulo"
        Me.lblTitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel1
        '
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 276.8602!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(1111.567!, 58.42001!)
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
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(1571.755!, 190.5!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(276.6619!, 58.42006!)
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo1
        '
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(1571.755!, 127.0!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(276.662!, 58.41997!)
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo3
        '
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(1571.755!, 63.5!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(276.662!, 58.42003!)
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 63.5!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(1111.567!, 58.42!)
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 0.0!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(1111.567!, 58.41998!)
        Me.lblRptNombreEnte.StylePriority.UseFont = False
        Me.lblRptNombreEnte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreEnte.Text = "Nombre del Ente público"
        Me.lblRptNombreEnte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PICEnteLogo
        '
        Me.PICEnteLogo.Dpi = 254.0!
        Me.PICEnteLogo.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 63.5!)
        Me.PICEnteLogo.Name = "PICEnteLogo"
        Me.PICEnteLogo.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogo.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'lblRptDescripcionFiltrado
        '
        Me.lblRptDescripcionFiltrado.Dpi = 254.0!
        Me.lblRptDescripcionFiltrado.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptDescripcionFiltrado.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 226.9068!)
        Me.lblRptDescripcionFiltrado.Name = "lblRptDescripcionFiltrado"
        Me.lblRptDescripcionFiltrado.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptDescripcionFiltrado.SizeF = New System.Drawing.SizeF(1111.567!, 49.9534!)
        Me.lblRptDescripcionFiltrado.StylePriority.UseFont = False
        Me.lblRptDescripcionFiltrado.StylePriority.UseTextAlignment = False
        Me.lblRptDescripcionFiltrado.Text = "Fecha o Rango"
        Me.lblRptDescripcionFiltrado.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLblIso, Me.XrLblUsr, Me.lblRptEnteDomicilio, Me.lblRptEnteTelefono, Me.lblRptEnteRFC, Me.lblRptEnteCiudad, Me.line2})
        Me.PageFooter.Dpi = 254.0!
        Me.PageFooter.HeightF = 110.09!
        Me.PageFooter.Name = "PageFooter"
        '
        'XrLblIso
        '
        Me.XrLblIso.Dpi = 254.0!
        Me.XrLblIso.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(1360.158!, 67.54498!)
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
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(1361.833!, 24.99993!)
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
        Me.lblRptEnteDomicilio.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 19.54467!)
        Me.lblRptEnteDomicilio.Name = "lblRptEnteDomicilio"
        Me.lblRptEnteDomicilio.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteDomicilio.SizeF = New System.Drawing.SizeF(984.119!, 42.545!)
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
        Me.lblRptEnteRFC.LocationFloat = New DevExpress.Utils.PointFloat(984.119!, 19.54467!)
        Me.lblRptEnteRFC.Name = "lblRptEnteRFC"
        Me.lblRptEnteRFC.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteRFC.SizeF = New System.Drawing.SizeF(343.9584!, 42.545!)
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
        Me.line2.SizeF = New System.Drawing.SizeF(1858.958!, 19.54469!)
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrPanel1, Me.XrSubreport1})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 272.418!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'XrPanel1
        '
        Me.XrPanel1.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
                    Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrPanel1.BorderWidth = 2
        Me.XrPanel1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.lblhprmNota1, Me.lbl_prmNota1, Me.XrLabel3})
        Me.XrPanel1.Dpi = 254.0!
        Me.XrPanel1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 24.99993!)
        Me.XrPanel1.Name = "XrPanel1"
        Me.XrPanel1.SizeF = New System.Drawing.SizeF(1853.0!, 119.5204!)
        Me.XrPanel1.StylePriority.UseBorders = False
        Me.XrPanel1.StylePriority.UseBorderWidth = False
        '
        'lblhprmNota1
        '
        Me.lblhprmNota1.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblhprmNota1.Dpi = 254.0!
        Me.lblhprmNota1.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.lblhprmNota1.LocationFloat = New DevExpress.Utils.PointFloat(5.475118!, 77.68009!)
        Me.lblhprmNota1.Name = "lblhprmNota1"
        Me.lblhprmNota1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblhprmNota1.SizeF = New System.Drawing.SizeF(1780.29!, 36.23373!)
        Me.lblhprmNota1.StylePriority.UseBorders = False
        Me.lblhprmNota1.StylePriority.UseFont = False
        Me.lblhprmNota1.Text = "(1) Los valores de esta columna se obtienen mediante el reporte Estados del Ejerc" & _
            "icio del Presupuesto de Egresos - Por Partida - Fuente de Financiamiento"
        '
        'lbl_prmNota1
        '
        Me.lbl_prmNota1.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lbl_prmNota1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding(prmNota1, "Text", "")})
        Me.lbl_prmNota1.Dpi = 254.0!
        Me.lbl_prmNota1.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lbl_prmNota1.LocationFloat = New DevExpress.Utils.PointFloat(227.7251!, 6.000038!)
        Me.lbl_prmNota1.Multiline = True
        Me.lbl_prmNota1.Name = "lbl_prmNota1"
        Me.lbl_prmNota1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lbl_prmNota1.SizeF = New System.Drawing.SizeF(1619.275!, 41.68002!)
        Me.lbl_prmNota1.StylePriority.UseBorders = False
        Me.lbl_prmNota1.StylePriority.UseFont = False
        Me.lbl_prmNota1.Text = "lbl_prmNota1"
        '
        'XrLabel3
        '
        Me.XrLabel3.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.XrLabel3.Dpi = 254.0!
        Me.XrLabel3.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(5.475089!, 6.000025!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(215.3709!, 41.68001!)
        Me.XrLabel3.StylePriority.UseBorders = False
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.Text = "Comentarios:"
        '
        'XrSubreport1
        '
        Me.XrSubreport1.Dpi = 254.0!
        Me.XrSubreport1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 175.3536!)
        Me.XrSubreport1.Name = "XrSubreport1"
        Me.XrSubreport1.ReportSource = Me.RpT_FirmasVertical1
        Me.XrSubreport1.SizeF = New System.Drawing.SizeF(1859.0!, 58.41994!)
        '
        'DataSetDavid1
        '
        Me.DataSetDavid1.DataSetName = "DataSetDavid"
        Me.DataSetDavid1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'XrLabel5
        '
        Me.XrLabel5.Dpi = 254.0!
        Me.XrLabel5.Font = New System.Drawing.Font("Tahoma", 7.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel5.LocationFloat = New DevExpress.Utils.PointFloat(567.1292!, 13.22917!)
        Me.XrLabel5.Name = "XrLabel5"
        Me.XrLabel5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel5.SizeF = New System.Drawing.SizeF(215.3708!, 41.76395!)
        Me.XrLabel5.StylePriority.UseFont = False
        Me.XrLabel5.StylePriority.UseTextAlignment = False
        Me.XrLabel5.Text = "TOTAL"
        Me.XrLabel5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel10
        '
        Me.XrLabel10.CanGrow = False
        Me.XrLabel10.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "NotaDividendos.sumatoria")})
        Me.XrLabel10.Dpi = 254.0!
        Me.XrLabel10.Font = New System.Drawing.Font("Tahoma", 7.0!)
        Me.XrLabel10.LocationFloat = New DevExpress.Utils.PointFloat(786.75!, 13.22922!)
        Me.XrLabel10.Name = "XrLabel10"
        Me.XrLabel10.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 11, 0, 0, 254.0!)
        Me.XrLabel10.SizeF = New System.Drawing.SizeF(190.3009!, 41.76397!)
        Me.XrLabel10.StylePriority.UseFont = False
        Me.XrLabel10.StylePriority.UsePadding = False
        Me.XrLabel10.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.XrLabel10.Summary = XrSummary1
        Me.XrLabel10.Text = "XrLabel10"
        Me.XrLabel10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLine1, Me.XrLabel5, Me.XrLabel10})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 60.35423!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'XrLine1
        '
        Me.XrLine1.Dpi = 254.0!
        Me.XrLine1.LineWidth = 4
        Me.XrLine1.LocationFloat = New DevExpress.Utils.PointFloat(5.291674!, 0.0!)
        Me.XrLine1.Name = "XrLine1"
        Me.XrLine1.SizeF = New System.Drawing.SizeF(1847.708!, 13.22919!)
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel7, Me.XrLine2, Me.XrLabel13, Me.XrLabel12, Me.XrLabel11, Me.XrLabel6, Me.XrLabel2})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.HeightF = 97.0127!
        Me.GroupHeader1.KeepTogether = True
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.RepeatEveryPage = True
        '
        'XrLabel7
        '
        Me.XrLabel7.Dpi = 254.0!
        Me.XrLabel7.Font = New System.Drawing.Font("Tahoma", 6.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel7.LocationFloat = New DevExpress.Utils.PointFloat(984.1189!, 5.291667!)
        Me.XrLabel7.Name = "XrLabel7"
        Me.XrLabel7.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel7.SizeF = New System.Drawing.SizeF(273.6519!, 84.87828!)
        Me.XrLabel7.StylePriority.UseFont = False
        Me.XrLabel7.StylePriority.UseTextAlignment = False
        Me.XrLabel7.Text = "Adquisiciones mediante subsidios de capital del sector central (1)"
        Me.XrLabel7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLine2
        '
        Me.XrLine2.Dpi = 254.0!
        Me.XrLine2.LineWidth = 3
        Me.XrLine2.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 90.16997!)
        Me.XrLine2.Name = "XrLine2"
        Me.XrLine2.SizeF = New System.Drawing.SizeF(1841.7!, 6.842678!)
        '
        'XrLabel13
        '
        Me.XrLabel13.Dpi = 254.0!
        Me.XrLabel13.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel13.LocationFloat = New DevExpress.Utils.PointFloat(1357.369!, 5.291667!)
        Me.XrLabel13.Name = "XrLabel13"
        Me.XrLabel13.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel13.SizeF = New System.Drawing.SizeF(489.6226!, 84.87829!)
        Me.XrLabel13.StylePriority.UseFont = False
        Me.XrLabel13.StylePriority.UseTextAlignment = False
        Me.XrLabel13.Text = "CARACTERÍSTICAS"
        Me.XrLabel13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel12
        '
        Me.XrLabel12.Dpi = 254.0!
        Me.XrLabel12.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(1266.188!, 5.291667!)
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(83.85596!, 84.87829!)
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.Text = "%"
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel11
        '
        Me.XrLabel11.Dpi = 254.0!
        Me.XrLabel11.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel11.LocationFloat = New DevExpress.Utils.PointFloat(786.8294!, 5.291667!)
        Me.XrLabel11.Name = "XrLabel11"
        Me.XrLabel11.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel11.SizeF = New System.Drawing.SizeF(190.2215!, 84.87828!)
        Me.XrLabel11.StylePriority.UseFont = False
        Me.XrLabel11.StylePriority.UseTextAlignment = False
        Me.XrLabel11.Text = "MONTO"
        Me.XrLabel11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel6
        '
        Me.XrLabel6.Dpi = 254.0!
        Me.XrLabel6.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel6.LocationFloat = New DevExpress.Utils.PointFloat(167.118!, 5.291667!)
        Me.XrLabel6.Name = "XrLabel6"
        Me.XrLabel6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel6.SizeF = New System.Drawing.SizeF(615.382!, 84.87829!)
        Me.XrLabel6.StylePriority.UseFont = False
        Me.XrLabel6.StylePriority.UseTextAlignment = False
        Me.XrLabel6.Text = "DESCRIPCIÓN"
        Me.XrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel2
        '
        Me.XrLabel2.Dpi = 254.0!
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 5.291667!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(156.8263!, 84.8783!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.Text = "CUENTA"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrCrossBandBox1
        '
        Me.XrCrossBandBox1.Dpi = 254.0!
        Me.XrCrossBandBox1.EndBand = Me.GroupFooter1
        Me.XrCrossBandBox1.EndPointFloat = New DevExpress.Utils.PointFloat(0.0!, 60.28479!)
        Me.XrCrossBandBox1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrCrossBandBox1.Name = "XrCrossBandBox1"
        Me.XrCrossBandBox1.StartBand = Me.GroupHeader1
        Me.XrCrossBandBox1.StartPointFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrCrossBandBox1.WidthF = 1853.958!
        '
        'XrCrossBandLine2
        '
        Me.XrCrossBandLine2.Dpi = 254.0!
        Me.XrCrossBandLine2.EndBand = Me.GroupFooter1
        Me.XrCrossBandLine2.EndPointFloat = New DevExpress.Utils.PointFloat(782.75!, 59.00003!)
        Me.XrCrossBandLine2.LocationFloat = New DevExpress.Utils.PointFloat(782.75!, 0.0!)
        Me.XrCrossBandLine2.Name = "XrCrossBandLine2"
        Me.XrCrossBandLine2.StartBand = Me.GroupHeader1
        Me.XrCrossBandLine2.StartPointFloat = New DevExpress.Utils.PointFloat(782.75!, 0.0!)
        Me.XrCrossBandLine2.WidthF = 4.0!
        '
        'XrCrossBandLine1
        '
        Me.XrCrossBandLine1.Dpi = 254.0!
        Me.XrCrossBandLine1.EndBand = Me.GroupFooter1
        Me.XrCrossBandLine1.EndPointFloat = New DevExpress.Utils.PointFloat(162.75!, 59.00003!)
        Me.XrCrossBandLine1.LocationFloat = New DevExpress.Utils.PointFloat(162.75!, 0.0!)
        Me.XrCrossBandLine1.Name = "XrCrossBandLine1"
        Me.XrCrossBandLine1.StartBand = Me.GroupHeader1
        Me.XrCrossBandLine1.StartPointFloat = New DevExpress.Utils.PointFloat(162.75!, 0.0!)
        Me.XrCrossBandLine1.WidthF = 4.0!
        '
        'XrCrossBandLine3
        '
        Me.XrCrossBandLine3.Dpi = 254.0!
        Me.XrCrossBandLine3.EndBand = Me.GroupFooter1
        Me.XrCrossBandLine3.EndPointFloat = New DevExpress.Utils.PointFloat(977.25!, 59.00003!)
        Me.XrCrossBandLine3.LocationFloat = New DevExpress.Utils.PointFloat(977.25!, 0.0!)
        Me.XrCrossBandLine3.Name = "XrCrossBandLine3"
        Me.XrCrossBandLine3.StartBand = Me.GroupHeader1
        Me.XrCrossBandLine3.StartPointFloat = New DevExpress.Utils.PointFloat(977.25!, 0.0!)
        Me.XrCrossBandLine3.WidthF = 6.869019!
        '
        'XrCrossBandLine4
        '
        Me.XrCrossBandLine4.Dpi = 254.0!
        Me.XrCrossBandLine4.EndBand = Me.GroupFooter1
        Me.XrCrossBandLine4.EndPointFloat = New DevExpress.Utils.PointFloat(1350.5!, 59.00003!)
        Me.XrCrossBandLine4.LocationFloat = New DevExpress.Utils.PointFloat(1350.5!, 0.0!)
        Me.XrCrossBandLine4.Name = "XrCrossBandLine4"
        Me.XrCrossBandLine4.StartBand = Me.GroupHeader1
        Me.XrCrossBandLine4.StartPointFloat = New DevExpress.Utils.PointFloat(1350.5!, 0.0!)
        Me.XrCrossBandLine4.WidthF = 6.868896!
        '
        'XrCrossBandLine5
        '
        Me.XrCrossBandLine5.Dpi = 254.0!
        Me.XrCrossBandLine5.EndBand = Me.GroupFooter1
        Me.XrCrossBandLine5.EndPointFloat = New DevExpress.Utils.PointFloat(1258.25!, 60.0!)
        Me.XrCrossBandLine5.LocationFloat = New DevExpress.Utils.PointFloat(1258.25!, 2.645833!)
        Me.XrCrossBandLine5.Name = "XrCrossBandLine5"
        Me.XrCrossBandLine5.StartBand = Me.GroupHeader1
        Me.XrCrossBandLine5.StartPointFloat = New DevExpress.Utils.PointFloat(1258.25!, 2.645833!)
        Me.XrCrossBandLine5.WidthF = 7.9375!
        '
        'sumatoria
        '
        Me.sumatoria.DataMember = "NotaDividendos"
        Me.sumatoria.DataSource = Me.DataSetDavid1
        Me.sumatoria.Expression = "Iif([Cuenta] In ('12300', '12400'), [Monto],0)"
        Me.sumatoria.Name = "sumatoria"
        '
        'percent
        '
        Me.percent.DataMember = "NotaDividendos"
        Me.percent.DataSource = Me.DataSetDavid1
        Me.percent.Expression = "Iif([Nota1] == 0, 0 , [Monto]/[Nota1] )"
        Me.percent.FieldType = DevExpress.XtraReports.UI.FieldType.[Decimal]
        Me.percent.Name = "percent"
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(1350.5!, 63.50004!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'NOTA_BMI_ARMSCSC
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.PageHeader, Me.PageFooter, Me.ReportFooter, Me.GroupHeader1, Me.GroupFooter1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.sumatoria, Me.percent})
        Me.CrossBandControls.AddRange(New DevExpress.XtraReports.UI.XRCrossBandControl() {Me.XrCrossBandLine5, Me.XrCrossBandLine4, Me.XrCrossBandLine3, Me.XrCrossBandLine1, Me.XrCrossBandLine2, Me.XrCrossBandBox1})
        Me.DataMember = "NotaDividendos"
        Me.DataSource = Me.DataSetDavid1
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.tipo, Me.transparentes, Me.negritas, Me.encabezadosdatos})
        Me.Margins = New System.Drawing.Printing.Margins(200, 100, 100, 100)
        Me.PageHeight = 2794
        Me.PageWidth = 2159
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {prmNota1})
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.ScriptsSource = "" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.SnapGridSize = 31.75!
        Me.Tag = "1109"
        Me.Version = "11.1"
        CType(Me.XrTable1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RpT_FirmasVertical1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DataSetDavid1, System.ComponentModel.ISupportInitialize).EndInit()
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
    Friend WithEvents XrSubreport1 As DevExpress.XtraReports.UI.XRSubreport
    Friend WithEvents XrLabel5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lbl_Cuenta As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents XrLine1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrPanel1 As DevExpress.XtraReports.UI.XRPanel
    Friend WithEvents lbl_prmNota1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lbl_Notas2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DataSetDavid1 As Korima_Reporteador.DataSetDavid
    Private WithEvents RpT_FirmasVertical1 As Korima_Reporteador.RPT_FirmasVertical
    Friend WithEvents XrLine2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrCrossBandBox1 As DevExpress.XtraReports.UI.XRCrossBandBox
    Friend WithEvents lblhprmNota1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrCrossBandLine2 As DevExpress.XtraReports.UI.XRCrossBandLine
    Friend WithEvents XrCrossBandLine1 As DevExpress.XtraReports.UI.XRCrossBandLine
    Friend WithEvents XrCrossBandLine3 As DevExpress.XtraReports.UI.XRCrossBandLine
    Friend WithEvents XrCrossBandLine4 As DevExpress.XtraReports.UI.XRCrossBandLine
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrCrossBandLine5 As DevExpress.XtraReports.UI.XRCrossBandLine
    Friend WithEvents sumatoria As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents XrTable1 As DevExpress.XtraReports.UI.XRTable
    Friend WithEvents XrTableRow1 As DevExpress.XtraReports.UI.XRTableRow
    Friend WithEvents XrTableCell2 As DevExpress.XtraReports.UI.XRTableCell
    Friend WithEvents transparentes As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents tipo As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents negritas As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents encabezadosdatos As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents percent As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
End Class
