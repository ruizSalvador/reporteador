<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_AplicaciónRecursosFORTAMUNDetallado
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
        Me.lblRptNombreEnte = New DevExpress.XtraReports.UI.XRLabel()
        Me.pageInfo3 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.formattingRule1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.DataSetBlanca1 = New Korima_Reporteador.DataSetBlanca()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.lblTitulo = New DevExpress.XtraReports.UI.XRLabel()
        Me.line1 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.pageInfo2 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo1 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.lblRptNombreReporte = New DevExpress.XtraReports.UI.XRLabel()
        Me.PICEnteLogo = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.lblRptDescripcionFiltrado = New DevExpress.XtraReports.UI.XRLabel()
        Me.label25 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader2 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.label45 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        Me.label34 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label42 = New DevExpress.XtraReports.UI.XRLabel()
        Me.line2 = New DevExpress.XtraReports.UI.XRLine()
        Me.lblRptTituloTipo = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteTelefono = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteRFC = New DevExpress.XtraReports.UI.XRLabel()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.label15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.line3 = New DevExpress.XtraReports.UI.XRLine()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.XrLblIso = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLblUsr = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteCiudad = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteDomicilio = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.VW_RPT_CFG_DatosEntesTableAdapter1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter()
        Me.CalculatedField1 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.CalculatedField2 = New DevExpress.XtraReports.UI.CalculatedField()
        Me.Firmas = New DevExpress.XtraReports.UI.XRSubreport()
        Me.RpT_FirmasHorizontalElectronica1 = New Korima_Reporteador.RPT_FirmasHorizontalElectronica()
        CType(Me.DataSetBlanca1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RpT_FirmasHorizontalElectronica1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(423.907!, 31.75!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(1511.832!, 58.41998!)
        Me.lblRptNombreEnte.StylePriority.UseFont = False
        Me.lblRptNombreEnte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreEnte.Text = "Nombre del Ente público"
        Me.lblRptNombreEnte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo3
        '
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(2251.95!, 90.17001!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(358.6831!, 58.42002!)
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'formattingRule1
        '
        Me.formattingRule1.Condition = "[IdClave] ==[IdClave2]"
        Me.formattingRule1.DataSource = Me.DataSetBlanca1
        Me.formattingRule1.Name = "formattingRule1"
        '
        'DataSetBlanca1
        '
        Me.DataSetBlanca1.DataSetName = "DataSetBlanca"
        Me.DataSetBlanca1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'TopMargin
        '
        Me.TopMargin.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PICEnteLogoSecundario, Me.lblTitulo, Me.line1, Me.XrLabel1, Me.pageInfo2, Me.pageInfo1, Me.pageInfo3, Me.lblRptNombreReporte, Me.lblRptNombreEnte, Me.PICEnteLogo, Me.lblRptDescripcionFiltrado})
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 378.0!
        Me.TopMargin.Name = "TopMargin"
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(2009.508!, 90.17001!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'lblTitulo
        '
        Me.lblTitulo.Dpi = 254.0!
        Me.lblTitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitulo.LocationFloat = New DevExpress.Utils.PointFloat(423.9075!, 148.59!)
        Me.lblTitulo.Name = "lblTitulo"
        Me.lblTitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblTitulo.SizeF = New System.Drawing.SizeF(1511.832!, 49.95334!)
        Me.lblTitulo.StylePriority.UseFont = False
        Me.lblTitulo.StylePriority.UseTextAlignment = False
        Me.lblTitulo.Text = "Titulo"
        Me.lblTitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'line1
        '
        Me.line1.Dpi = 254.0!
        Me.line1.LineWidth = 3
        Me.line1.LocationFloat = New DevExpress.Utils.PointFloat(0.00004037221!, 331.8702!)
        Me.line1.Name = "line1"
        Me.line1.SizeF = New System.Drawing.SizeF(2662.229!, 15.875!)
        '
        'XrLabel1
        '
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(423.9074!, 248.4967!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(1511.833!, 58.42007!)
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "(En miles de pesos)"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        Me.XrLabel1.Visible = False
        '
        'pageInfo2
        '
        Me.pageInfo2.Dpi = 254.0!
        Me.pageInfo2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo2.Format = "{0:HH:mm}"
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(2251.95!, 207.0101!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(358.6831!, 58.42007!)
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo1
        '
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(2251.95!, 148.5901!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(358.6831!, 58.41997!)
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(423.9066!, 90.17001!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(1511.832!, 58.42002!)
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PICEnteLogo
        '
        Me.PICEnteLogo.Dpi = 254.0!
        Me.PICEnteLogo.LocationFloat = New DevExpress.Utils.PointFloat(129.1457!, 90.17!)
        Me.PICEnteLogo.Name = "PICEnteLogo"
        Me.PICEnteLogo.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogo.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'lblRptDescripcionFiltrado
        '
        Me.lblRptDescripcionFiltrado.Dpi = 254.0!
        Me.lblRptDescripcionFiltrado.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptDescripcionFiltrado.LocationFloat = New DevExpress.Utils.PointFloat(423.9066!, 198.5434!)
        Me.lblRptDescripcionFiltrado.Name = "lblRptDescripcionFiltrado"
        Me.lblRptDescripcionFiltrado.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptDescripcionFiltrado.SizeF = New System.Drawing.SizeF(1511.832!, 49.95335!)
        Me.lblRptDescripcionFiltrado.StylePriority.UseFont = False
        Me.lblRptDescripcionFiltrado.StylePriority.UseTextAlignment = False
        Me.lblRptDescripcionFiltrado.Text = "Fecha o Rango"
        Me.lblRptDescripcionFiltrado.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'label25
        '
        Me.label25.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label25.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.label25.CanGrow = False
        Me.label25.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_EstadodelEjercicioPresupuesto.Pagado", "{0:n2}")})
        Me.label25.Dpi = 254.0!
        Me.label25.Font = New System.Drawing.Font("Tahoma", 6.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label25.LocationFloat = New DevExpress.Utils.PointFloat(1935.739!, 0.0!)
        Me.label25.Name = "label25"
        Me.label25.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label25.SizeF = New System.Drawing.SizeF(418.2874!, 58.42028!)
        Me.label25.StylePriority.UseBorders = False
        Me.label25.StylePriority.UseFont = False
        Me.label25.StylePriority.UseTextAlignment = False
        Me.label25.Text = "label25"
        Me.label25.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label10
        '
        Me.label10.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.label10.Dpi = 254.0!
        Me.label10.Font = New System.Drawing.Font("Tahoma", 6.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label10.LocationFloat = New DevExpress.Utils.PointFloat(1935.738!, 0.0!)
        Me.label10.Name = "label10"
        Me.label10.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label10.SizeF = New System.Drawing.SizeF(418.2856!, 61.70304!)
        Me.label10.StylePriority.UseBorders = False
        Me.label10.StylePriority.UseFont = False
        Me.label10.StylePriority.UseTextAlignment = False
        Me.label10.Text = "Monto Pagado"
        Me.label10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'GroupHeader2
        '
        Me.GroupHeader2.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label45, Me.label12})
        Me.GroupHeader2.Dpi = 254.0!
        Me.GroupHeader2.FormattingRules.Add(Me.formattingRule1)
        Me.GroupHeader2.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("IdClave", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader2.GroupUnion = DevExpress.XtraReports.UI.GroupUnion.WithFirstDetail
        Me.GroupHeader2.HeightF = 58.42312!
        Me.GroupHeader2.Name = "GroupHeader2"
        '
        'label45
        '
        Me.label45.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.label45.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.label45.CanGrow = False
        Me.label45.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_EstadodelEjercicioPresupuesto.Pagado")})
        Me.label45.Dpi = 254.0!
        Me.label45.Font = New System.Drawing.Font("Tahoma", 6.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label45.LocationFloat = New DevExpress.Utils.PointFloat(1935.739!, 0.0!)
        Me.label45.Name = "label45"
        Me.label45.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label45.SizeF = New System.Drawing.SizeF(418.2853!, 58.42287!)
        Me.label45.StylePriority.UseBorders = False
        Me.label45.StylePriority.UseFont = False
        Me.label45.StylePriority.UseTextAlignment = False
        XrSummary1.FormatString = "{0:n2}"
        XrSummary1.Running = DevExpress.XtraReports.UI.SummaryRunning.Group
        Me.label45.Summary = XrSummary1
        Me.label45.Text = "label45"
        Me.label45.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'label12
        '
        Me.label12.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.label12.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_EstadodelEjercicioPresupuesto.Descripcion")})
        Me.label12.Dpi = 254.0!
        Me.label12.Font = New System.Drawing.Font("Tahoma", 6.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label12.LocationFloat = New DevExpress.Utils.PointFloat(129.1457!, 0.003149033!)
        Me.label12.Name = "label12"
        Me.label12.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label12.SizeF = New System.Drawing.SizeF(1806.593!, 58.41996!)
        Me.label12.StylePriority.UseBorders = False
        Me.label12.StylePriority.UseFont = False
        Me.label12.Text = "label12"
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.Firmas, Me.label34, Me.label42})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 217.9616!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'label34
        '
        Me.label34.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.label34.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_EstadodelEjercicioPresupuesto.Pagado")})
        Me.label34.Dpi = 254.0!
        Me.label34.Font = New System.Drawing.Font("Tahoma", 5.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label34.LocationFloat = New DevExpress.Utils.PointFloat(1935.739!, 0.0!)
        Me.label34.Name = "label34"
        Me.label34.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label34.SizeF = New System.Drawing.SizeF(418.2853!, 58.41996!)
        Me.label34.StylePriority.UseBorders = False
        Me.label34.StylePriority.UseFont = False
        Me.label34.StylePriority.UseTextAlignment = False
        XrSummary2.FormatString = "{0:n2}"
        XrSummary2.Running = DevExpress.XtraReports.UI.SummaryRunning.Report
        Me.label34.Summary = XrSummary2
        Me.label34.Text = "label34"
        Me.label34.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'label42
        '
        Me.label42.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.label42.Dpi = 254.0!
        Me.label42.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label42.LocationFloat = New DevExpress.Utils.PointFloat(129.1457!, 0.0!)
        Me.label42.Name = "label42"
        Me.label42.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label42.SizeF = New System.Drawing.SizeF(1806.593!, 58.41996!)
        Me.label42.StylePriority.UseBorders = False
        Me.label42.StylePriority.UseFont = False
        Me.label42.StylePriority.UseTextAlignment = False
        Me.label42.Text = "Total"
        Me.label42.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'line2
        '
        Me.line2.Dpi = 254.0!
        Me.line2.LineWidth = 3
        Me.line2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 24.99993!)
        Me.line2.Name = "line2"
        Me.line2.SizeF = New System.Drawing.SizeF(2662.229!, 13.22917!)
        '
        'lblRptTituloTipo
        '
        Me.lblRptTituloTipo.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.lblRptTituloTipo.Dpi = 254.0!
        Me.lblRptTituloTipo.Font = New System.Drawing.Font("Tahoma", 6.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptTituloTipo.LocationFloat = New DevExpress.Utils.PointFloat(129.1467!, 0.0!)
        Me.lblRptTituloTipo.Multiline = True
        Me.lblRptTituloTipo.Name = "lblRptTituloTipo"
        Me.lblRptTituloTipo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptTituloTipo.SizeF = New System.Drawing.SizeF(1806.592!, 61.70303!)
        Me.lblRptTituloTipo.StylePriority.UseBorders = False
        Me.lblRptTituloTipo.StylePriority.UseFont = False
        Me.lblRptTituloTipo.StylePriority.UseTextAlignment = False
        Me.lblRptTituloTipo.Text = "Destino de las Aportaciones"
        Me.lblRptTituloTipo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptEnteTelefono
        '
        Me.lblRptEnteTelefono.Dpi = 254.0!
        Me.lblRptEnteTelefono.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteTelefono.LocationFloat = New DevExpress.Utils.PointFloat(962.0712!, 92.29928!)
        Me.lblRptEnteTelefono.Name = "lblRptEnteTelefono"
        Me.lblRptEnteTelefono.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteTelefono.SizeF = New System.Drawing.SizeF(632.3541!, 42.54501!)
        Me.lblRptEnteTelefono.StylePriority.UseFont = False
        '
        'lblRptEnteRFC
        '
        Me.lblRptEnteRFC.Dpi = 254.0!
        Me.lblRptEnteRFC.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteRFC.LocationFloat = New DevExpress.Utils.PointFloat(1448.905!, 49.75423!)
        Me.lblRptEnteRFC.Name = "lblRptEnteRFC"
        Me.lblRptEnteRFC.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteRFC.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.lblRptEnteRFC.StylePriority.UseFont = False
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label15, Me.label25})
        Me.Detail.Dpi = 254.0!
        Me.Detail.FormattingRules.Add(Me.formattingRule1)
        Me.Detail.HeightF = 58.42061!
        Me.Detail.Name = "Detail"
        Me.Detail.SortFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("IdClave2", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        '
        'label15
        '
        Me.label15.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.label15.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "VW_RPT_K2_EstadodelEjercicioPresupuesto.Descripcion2")})
        Me.label15.Dpi = 254.0!
        Me.label15.Font = New System.Drawing.Font("Tahoma", 6.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label15.LocationFloat = New DevExpress.Utils.PointFloat(129.1467!, 0.0003229777!)
        Me.label15.Name = "label15"
        Me.label15.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label15.SizeF = New System.Drawing.SizeF(1806.592!, 58.41996!)
        Me.label15.StylePriority.UseBorders = False
        Me.label15.StylePriority.UseFont = False
        Me.label15.StylePriority.UseTextAlignment = False
        Me.label15.Text = "label15"
        Me.label15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'line3
        '
        Me.line3.Dpi = 254.0!
        Me.line3.LineWidth = 2
        Me.line3.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.line3.Name = "line3"
        Me.line3.SizeF = New System.Drawing.SizeF(2354.024!, 5.0!)
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.line3})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 5.0!
        Me.GroupFooter1.Level = 1
        Me.GroupFooter1.Name = "GroupFooter1"
        Me.GroupFooter1.RepeatEveryPage = True
        '
        'BottomMargin
        '
        Me.BottomMargin.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLblIso, Me.XrLblUsr, Me.line2, Me.lblRptEnteTelefono, Me.lblRptEnteRFC, Me.lblRptEnteCiudad, Me.lblRptEnteDomicilio})
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 178.0!
        Me.BottomMargin.Name = "BottomMargin"
        '
        'XrLblIso
        '
        Me.XrLblIso.Dpi = 254.0!
        Me.XrLblIso.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(2123.8!, 92.29928!)
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
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(2123.8!, 49.75423!)
        Me.XrLblUsr.Name = "XrLblUsr"
        Me.XrLblUsr.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLblUsr.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.XrLblUsr.StylePriority.UseFont = False
        Me.XrLblUsr.StylePriority.UseTextAlignment = False
        Me.XrLblUsr.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'lblRptEnteCiudad
        '
        Me.lblRptEnteCiudad.Dpi = 254.0!
        Me.lblRptEnteCiudad.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteCiudad.LocationFloat = New DevExpress.Utils.PointFloat(0.00004037221!, 92.29928!)
        Me.lblRptEnteCiudad.Name = "lblRptEnteCiudad"
        Me.lblRptEnteCiudad.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteCiudad.SizeF = New System.Drawing.SizeF(632.3541!, 42.545!)
        Me.lblRptEnteCiudad.StylePriority.UseFont = False
        '
        'lblRptEnteDomicilio
        '
        Me.lblRptEnteDomicilio.Dpi = 254.0!
        Me.lblRptEnteDomicilio.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteDomicilio.LocationFloat = New DevExpress.Utils.PointFloat(0.00004037221!, 49.75423!)
        Me.lblRptEnteDomicilio.Name = "lblRptEnteDomicilio"
        Me.lblRptEnteDomicilio.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteDomicilio.SizeF = New System.Drawing.SizeF(1119.188!, 42.545!)
        Me.lblRptEnteDomicilio.StylePriority.UseFont = False
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label10, Me.lblRptTituloTipo})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.HeightF = 61.70304!
        Me.GroupHeader1.Level = 1
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.RepeatEveryPage = True
        '
        'VW_RPT_CFG_DatosEntesTableAdapter1
        '
        Me.VW_RPT_CFG_DatosEntesTableAdapter1.ClearBeforeFill = True
        '
        'CalculatedField1
        '
        Me.CalculatedField1.DataMember = "SP_RPT_EstadoEjercicioPresupuestoEGR"
        Me.CalculatedField1.DataSource = Me.DataSetBlanca1
        Me.CalculatedField1.Expression = "[Autorizado] + [Amp_Red]"
        Me.CalculatedField1.FieldType = DevExpress.XtraReports.UI.FieldType.[Decimal]
        Me.CalculatedField1.Name = "CalculatedField1"
        '
        'CalculatedField2
        '
        Me.CalculatedField2.DataMember = "SP_RPT_EstadoEjercicioPresupuestoEGR"
        Me.CalculatedField2.DataSource = Me.DataSetBlanca1
        Me.CalculatedField2.Expression = "([Autorizado] + [Amp_Red]) - [Devengado]"
        Me.CalculatedField2.Name = "CalculatedField2"
        '
        'Firmas
        '
        Me.Firmas.Dpi = 254.0!
        Me.Firmas.LocationFloat = New DevExpress.Utils.PointFloat(129.1457!, 149.6251!)
        Me.Firmas.Name = "Firmas"
        Me.Firmas.ReportSource = Me.RpT_FirmasHorizontalElectronica1
        Me.Firmas.SizeF = New System.Drawing.SizeF(2224.878!, 68.3365!)
        '
        'RPT_AplicaciónRecursosFORTAMUNDetallado
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMargin, Me.Detail, Me.BottomMargin, Me.GroupHeader2, Me.ReportFooter, Me.GroupFooter1, Me.GroupHeader1})
        Me.Bookmark = "RPT_EstadoEjercicioPresupuestal2Niveles"
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.CalculatedField1, Me.CalculatedField2})
        Me.DataAdapter = Me.VW_RPT_CFG_DatosEntesTableAdapter1
        Me.DataMember = "SP_RPT_EstadoEjercicioPresupuestoEGR"
        Me.DataSource = Me.DataSetBlanca1
        Me.DisplayName = "RPT_EstadoEjercicioPresupuestal2Niveles"
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.formattingRule1})
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(71, 0, 378, 178)
        Me.PageHeight = 2159
        Me.PageWidth = 2800
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.ScriptsSource = "" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me.DataSetBlanca1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RpT_FirmasHorizontalElectronica1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Public WithEvents lblRptNombreEnte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents pageInfo3 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents formattingRule1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Public WithEvents lblTitulo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line1 As DevExpress.XtraReports.UI.XRLine
    Public WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents pageInfo2 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo1 As DevExpress.XtraReports.UI.XRPageInfo
    Public WithEvents lblRptNombreReporte As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents PICEnteLogo As DevExpress.XtraReports.UI.XRPictureBox
    Public WithEvents lblRptDescripcionFiltrado As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label25 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupHeader2 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents label45 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents label42 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label34 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Public WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents line3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Public WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents lblRptTituloTipo As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents Firmas As DevExpress.XtraReports.UI.XRSubreport
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Public WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DataSetBlanca1 As Korima_Reporteador.DataSetBlanca
    Friend WithEvents VW_RPT_CFG_DatosEntesTableAdapter1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet1TableAdapters.VW_RPT_CFG_DatosEntesTableAdapter
    Private WithEvents RpT_FirmasHorizontalElectronica1 As Korima_Reporteador.RPT_FirmasHorizontalElectronica
    Friend WithEvents CalculatedField1 As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents CalculatedField2 As DevExpress.XtraReports.UI.CalculatedField
    Public WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents label15 As DevExpress.XtraReports.UI.XRLabel
End Class
