<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_ConciliacionIngresos
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
        Me.ReportHeader = New DevExpress.XtraReports.UI.ReportHeaderBand()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.PICEnteLogo = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.lblRptNombreEnte = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptNombreReporte = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblTitulo = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblSubtitulo = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptDescripcionFiltrado = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.line1 = New DevExpress.XtraReports.UI.XRLine()
        Me.pageInfo3 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo1 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo2 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        Me.XrLblIso = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLblUsr = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteDomicilio = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteRFC = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteCiudad = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteTelefono = New DevExpress.XtraReports.UI.XRLabel()
        Me.line2 = New DevExpress.XtraReports.UI.XRLine()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Negritas = New DevExpress.XtraReports.UI.FormattingRule()
        Me.bordes1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.bordes2 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.XrLabel12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel11 = New DevExpress.XtraReports.UI.XRLabel()
        Me._Korima2_00_ReporteadorDataSet1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel27 = New DevExpress.XtraReports.UI.XRLabel()
        Me.visible = New DevExpress.XtraReports.UI.FormattingRule()
        Me.VW_C_UsuariosTableAdapter = New Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter()
        Me.DsNotasBenn1 = New Korima_Reporteador.dsNotasBenn()
        Me.XrSubreport1 = New DevExpress.XtraReports.UI.XRSubreport()
        Me.RpT_FirmasVerticalElectronica1 = New Korima_Reporteador.RPT_FirmasVerticalElectronica()
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RpT_FirmasVerticalElectronica1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PICEnteLogoSecundario, Me.PICEnteLogo, Me.lblRptNombreEnte, Me.lblRptNombreReporte, Me.lblTitulo, Me.lblSubtitulo, Me.lblRptDescripcionFiltrado, Me.XrLabel1, Me.line1, Me.pageInfo3, Me.pageInfo1, Me.pageInfo2})
        Me.ReportHeader.Dpi = 254.0!
        Me.ReportHeader.HeightF = 351.5785!
        Me.ReportHeader.KeepTogether = True
        Me.ReportHeader.Name = "ReportHeader"
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(1334.066!, 66.35754!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        Me.PICEnteLogoSecundario.StylePriority.UseBorders = False
        '
        'PICEnteLogo
        '
        Me.PICEnteLogo.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.PICEnteLogo.Dpi = 254.0!
        Me.PICEnteLogo.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 66.35751!)
        Me.PICEnteLogo.Name = "PICEnteLogo"
        Me.PICEnteLogo.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogo.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        Me.PICEnteLogo.StylePriority.UseBorders = False
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(215.3709!, 7.9375!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(1118.129!, 58.41998!)
        Me.lblRptNombreEnte.StylePriority.UseBorders = False
        Me.lblRptNombreEnte.StylePriority.UseFont = False
        Me.lblRptNombreEnte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreEnte.Text = "Nombre del Ente público"
        Me.lblRptNombreEnte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(215.3707!, 66.35754!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(1118.129!, 58.41998!)
        Me.lblRptNombreReporte.StylePriority.UseBorders = False
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblTitulo
        '
        Me.lblTitulo.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblTitulo.Dpi = 254.0!
        Me.lblTitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitulo.LocationFloat = New DevExpress.Utils.PointFloat(215.3707!, 124.7775!)
        Me.lblTitulo.Name = "lblTitulo"
        Me.lblTitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblTitulo.SizeF = New System.Drawing.SizeF(1118.129!, 49.95338!)
        Me.lblTitulo.StylePriority.UseBorders = False
        Me.lblTitulo.StylePriority.UseFont = False
        Me.lblTitulo.StylePriority.UseTextAlignment = False
        Me.lblTitulo.Text = "Titulo"
        Me.lblTitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblSubtitulo
        '
        Me.lblSubtitulo.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblSubtitulo.Dpi = 254.0!
        Me.lblSubtitulo.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSubtitulo.LocationFloat = New DevExpress.Utils.PointFloat(215.3707!, 174.731!)
        Me.lblSubtitulo.Name = "lblSubtitulo"
        Me.lblSubtitulo.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblSubtitulo.SizeF = New System.Drawing.SizeF(1118.129!, 49.95338!)
        Me.lblSubtitulo.StylePriority.UseBorders = False
        Me.lblSubtitulo.StylePriority.UseFont = False
        Me.lblSubtitulo.StylePriority.UseTextAlignment = False
        Me.lblSubtitulo.Text = "Subtitulo"
        Me.lblSubtitulo.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        Me.lblSubtitulo.Visible = False
        '
        'lblRptDescripcionFiltrado
        '
        Me.lblRptDescripcionFiltrado.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptDescripcionFiltrado.Dpi = 254.0!
        Me.lblRptDescripcionFiltrado.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptDescripcionFiltrado.LocationFloat = New DevExpress.Utils.PointFloat(215.3707!, 224.6842!)
        Me.lblRptDescripcionFiltrado.Name = "lblRptDescripcionFiltrado"
        Me.lblRptDescripcionFiltrado.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptDescripcionFiltrado.SizeF = New System.Drawing.SizeF(1118.129!, 49.95331!)
        Me.lblRptDescripcionFiltrado.StylePriority.UseBorders = False
        Me.lblRptDescripcionFiltrado.StylePriority.UseFont = False
        Me.lblRptDescripcionFiltrado.StylePriority.UseTextAlignment = False
        Me.lblRptDescripcionFiltrado.Text = "Fecha o Rango"
        Me.lblRptDescripcionFiltrado.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel1
        '
        Me.XrLabel1.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.XrLabel1.Dpi = 254.0!
        Me.XrLabel1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(215.3714!, 274.6377!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(1118.13!, 58.42017!)
        Me.XrLabel1.StylePriority.UseBorders = False
        Me.XrLabel1.StylePriority.UseFont = False
        Me.XrLabel1.StylePriority.UseTextAlignment = False
        Me.XrLabel1.Text = "(Cifras en Pesos)"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'line1
        '
        Me.line1.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.line1.Dpi = 254.0!
        Me.line1.LineWidth = 3
        Me.line1.LocationFloat = New DevExpress.Utils.PointFloat(0.00004037221!, 333.0577!)
        Me.line1.Name = "line1"
        Me.line1.SizeF = New System.Drawing.SizeF(1898.687!, 15.875!)
        Me.line1.StylePriority.UseBorders = False
        '
        'pageInfo3
        '
        Me.pageInfo3.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(1549.437!, 57.89109!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(349.2504!, 58.42001!)
        Me.pageInfo3.StylePriority.UseBorders = False
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo1
        '
        Me.pageInfo1.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(1549.437!, 116.311!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(349.2502!, 58.41996!)
        Me.pageInfo1.StylePriority.UseBorders = False
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo2
        '
        Me.pageInfo2.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.pageInfo2.Dpi = 254.0!
        Me.pageInfo2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo2.Format = "{0:HH:mm}"
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(1549.437!, 174.7312!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(349.2501!, 58.42007!)
        Me.pageInfo2.StylePriority.UseBorders = False
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrSubreport1, Me.XrLabel13})
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 127.0!
        Me.ReportFooter.KeepTogether = True
        Me.ReportFooter.Name = "ReportFooter"
        '
        'XrLblIso
        '
        Me.XrLblIso.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.XrLblIso.Dpi = 254.0!
        Me.XrLblIso.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(1372.167!, 80.39941!)
        Me.XrLblIso.Name = "XrLblIso"
        Me.XrLblIso.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLblIso.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.XrLblIso.StylePriority.UseBorders = False
        Me.XrLblIso.StylePriority.UseFont = False
        Me.XrLblIso.StylePriority.UseTextAlignment = False
        Me.XrLblIso.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'XrLblUsr
        '
        Me.XrLblUsr.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.XrLblUsr.Dpi = 254.0!
        Me.XrLblUsr.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(1372.167!, 37.85442!)
        Me.XrLblUsr.Name = "XrLblUsr"
        Me.XrLblUsr.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLblUsr.SizeF = New System.Drawing.SizeF(486.8334!, 42.545!)
        Me.XrLblUsr.StylePriority.UseBorders = False
        Me.XrLblUsr.StylePriority.UseFont = False
        Me.XrLblUsr.StylePriority.UseTextAlignment = False
        Me.XrLblUsr.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        '
        'lblRptEnteDomicilio
        '
        Me.lblRptEnteDomicilio.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptEnteDomicilio.Dpi = 254.0!
        Me.lblRptEnteDomicilio.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteDomicilio.LocationFloat = New DevExpress.Utils.PointFloat(0.0001925033!, 37.85442!)
        Me.lblRptEnteDomicilio.Name = "lblRptEnteDomicilio"
        Me.lblRptEnteDomicilio.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteDomicilio.SizeF = New System.Drawing.SizeF(964.6433!, 42.54499!)
        Me.lblRptEnteDomicilio.StylePriority.UseBorders = False
        Me.lblRptEnteDomicilio.StylePriority.UseFont = False
        '
        'lblRptEnteRFC
        '
        Me.lblRptEnteRFC.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptEnteRFC.Dpi = 254.0!
        Me.lblRptEnteRFC.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteRFC.LocationFloat = New DevExpress.Utils.PointFloat(980.4134!, 37.85442!)
        Me.lblRptEnteRFC.Name = "lblRptEnteRFC"
        Me.lblRptEnteRFC.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteRFC.SizeF = New System.Drawing.SizeF(391.753!, 42.54499!)
        Me.lblRptEnteRFC.StylePriority.UseBorders = False
        Me.lblRptEnteRFC.StylePriority.UseFont = False
        '
        'lblRptEnteCiudad
        '
        Me.lblRptEnteCiudad.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptEnteCiudad.Dpi = 254.0!
        Me.lblRptEnteCiudad.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteCiudad.LocationFloat = New DevExpress.Utils.PointFloat(0.0002018611!, 80.39941!)
        Me.lblRptEnteCiudad.Name = "lblRptEnteCiudad"
        Me.lblRptEnteCiudad.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteCiudad.SizeF = New System.Drawing.SizeF(632.3541!, 42.545!)
        Me.lblRptEnteCiudad.StylePriority.UseBorders = False
        Me.lblRptEnteCiudad.StylePriority.UseFont = False
        '
        'lblRptEnteTelefono
        '
        Me.lblRptEnteTelefono.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.lblRptEnteTelefono.Dpi = 254.0!
        Me.lblRptEnteTelefono.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.lblRptEnteTelefono.LocationFloat = New DevExpress.Utils.PointFloat(632.3544!, 80.39941!)
        Me.lblRptEnteTelefono.Name = "lblRptEnteTelefono"
        Me.lblRptEnteTelefono.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteTelefono.SizeF = New System.Drawing.SizeF(632.3541!, 42.54501!)
        Me.lblRptEnteTelefono.StylePriority.UseBorders = False
        Me.lblRptEnteTelefono.StylePriority.UseFont = False
        '
        'line2
        '
        Me.line2.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.line2.Dpi = 254.0!
        Me.line2.LineWidth = 3
        Me.line2.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 10.4543!)
        Me.line2.Name = "line2"
        Me.line2.SizeF = New System.Drawing.SizeF(1859.0!, 16.08662!)
        Me.line2.StylePriority.UseBorders = False
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel12, Me.XrLabel11})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 58.42!
        Me.Detail.Name = "Detail"
        '
        'XrLabel13
        '
        Me.XrLabel13.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel13.Borders = DevExpress.XtraPrinting.BorderSide.None
        Me.XrLabel13.CanGrow = False
        Me.XrLabel13.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_RPT_K2_ConciliacionIngresos.Suma", "{0:n2}")})
        Me.XrLabel13.Dpi = 254.0!
        Me.XrLabel13.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel13.FormattingRules.Add(Me.Negritas)
        Me.XrLabel13.FormattingRules.Add(Me.bordes1)
        Me.XrLabel13.FormattingRules.Add(Me.bordes2)
        Me.XrLabel13.LocationFloat = New DevExpress.Utils.PointFloat(1334.066!, 0.0!)
        Me.XrLabel13.Name = "XrLabel13"
        Me.XrLabel13.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel13.SizeF = New System.Drawing.SizeF(359.8334!, 58.42!)
        Me.XrLabel13.StylePriority.UseBorders = False
        Me.XrLabel13.StylePriority.UseFont = False
        Me.XrLabel13.StylePriority.UseTextAlignment = False
        Me.XrLabel13.Text = "XrLabel13"
        Me.XrLabel13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        Me.XrLabel13.Visible = False
        '
        'Negritas
        '
        Me.Negritas.Condition = "Negritas=1"
        '
        '
        '
        Me.Negritas.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas.Name = "Negritas"
        '
        'bordes1
        '
        Me.bordes1.Condition = "Orden= 1 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 2 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 9 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 13"
        '
        '
        '
        Me.bordes1.Formatting.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.bordes1.Name = "bordes1"
        '
        'bordes2
        '
        Me.bordes2.Condition = "Orden=1.1 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden=3 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden=10"
        '
        '
        '
        Me.bordes2.Formatting.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.bordes2.Name = "bordes2"
        '
        'XrLabel12
        '
        Me.XrLabel12.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel12.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_RPT_K2_ConciliacionIngresos.Abonos", "{0:n2}")})
        Me.XrLabel12.Dpi = 254.0!
        Me.XrLabel12.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel12.FormattingRules.Add(Me.Negritas)
        Me.XrLabel12.LocationFloat = New DevExpress.Utils.PointFloat(1498.999!, 0.0!)
        Me.XrLabel12.Multiline = True
        Me.XrLabel12.Name = "XrLabel12"
        Me.XrLabel12.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel12.SizeF = New System.Drawing.SizeF(344.3348!, 58.42!)
        Me.XrLabel12.StylePriority.UseBorders = False
        Me.XrLabel12.StylePriority.UseFont = False
        Me.XrLabel12.StylePriority.UseTextAlignment = False
        Me.XrLabel12.Text = "XrLabel12"
        Me.XrLabel12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'XrLabel11
        '
        Me.XrLabel11.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.XrLabel11.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel11.CanGrow = False
        Me.XrLabel11.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_RPT_K2_ConciliacionIngresos.Nombre")})
        Me.XrLabel11.Dpi = 254.0!
        Me.XrLabel11.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel11.FormattingRules.Add(Me.Negritas)
        Me.XrLabel11.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.XrLabel11.Name = "XrLabel11"
        Me.XrLabel11.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel11.SizeF = New System.Drawing.SizeF(1498.999!, 58.42!)
        Me.XrLabel11.StylePriority.UseBorders = False
        Me.XrLabel11.StylePriority.UseFont = False
        Me.XrLabel11.Text = "XrLabel11"
        '
        '_Korima2_00_ReporteadorDataSet1
        '
        Me._Korima2_00_ReporteadorDataSet1.DataSetName = "_Korima2_00_ReporteadorDataSet"
        Me._Korima2_00_ReporteadorDataSet1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.Name = "TopMargin"
        '
        'BottomMargin
        '
        Me.BottomMargin.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.line2, Me.lblRptEnteDomicilio, Me.lblRptEnteCiudad, Me.lblRptEnteTelefono, Me.lblRptEnteRFC, Me.XrLblUsr, Me.XrLblIso})
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 256.0!
        Me.BottomMargin.Name = "BottomMargin"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.HeightF = 55.2464!
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.Visible = False
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel27})
        Me.GroupFooter1.Dpi = 254.0!
        Me.GroupFooter1.HeightF = 58.41999!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'XrLabel27
        '
        Me.XrLabel27.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLabel27.Dpi = 254.0!
        Me.XrLabel27.Font = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel27.LocationFloat = New DevExpress.Utils.PointFloat(0.0001614888!, 0.0!)
        Me.XrLabel27.Name = "XrLabel27"
        Me.XrLabel27.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel27.SizeF = New System.Drawing.SizeF(1843.334!, 26.66999!)
        Me.XrLabel27.StylePriority.UseBorders = False
        Me.XrLabel27.StylePriority.UseFont = False
        Me.XrLabel27.StylePriority.UseTextAlignment = False
        Me.XrLabel27.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'visible
        '
        Me.visible.Condition = "Orden= 2 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 3 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 10 or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Orden= 15"
        Me.visible.Name = "visible"
        '
        'VW_C_UsuariosTableAdapter
        '
        Me.VW_C_UsuariosTableAdapter.ClearBeforeFill = True
        '
        'DsNotasBenn1
        '
        Me.DsNotasBenn1.DataSetName = "dsNotasBenn"
        Me.DsNotasBenn1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'XrSubreport1
        '
        Me.XrSubreport1.Dpi = 254.0!
        Me.XrSubreport1.LocationFloat = New DevExpress.Utils.PointFloat(0.0001925033!, 43.58!)
        Me.XrSubreport1.Name = "XrSubreport1"
        Me.XrSubreport1.ReportSource = Me.RpT_FirmasVerticalElectronica1
        Me.XrSubreport1.SizeF = New System.Drawing.SizeF(254.0!, 58.42!)
        '
        'RPT_ConciliacionIngresos
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.TopMargin, Me.Detail, Me.BottomMargin, Me.ReportHeader, Me.ReportFooter, Me.GroupHeader1, Me.GroupFooter1})
        Me.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.DataAdapter = Me.VW_C_UsuariosTableAdapter
        Me.DataMember = "SP_RPT_K2_ConciliacionIngresos"
        Me.DataSource = Me.DsNotasBenn1
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas, Me.bordes1, Me.bordes2, Me.visible})
        Me.Margins = New System.Drawing.Printing.Margins(201, 48, 100, 256)
        Me.PageHeight = 2794
        Me.PageWidth = 2159
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.ScriptsSource = "" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RpT_FirmasVerticalElectronica1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents ReportHeader As DevExpress.XtraReports.UI.ReportHeaderBand
    Friend WithEvents PICEnteLogo As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents lblRptNombreEnte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptNombreReporte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblTitulo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblSubtitulo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptDescripcionFiltrado As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents pageInfo3 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo1 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo2 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents _Korima2_00_ReporteadorDataSet1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents XrSubreport1 As DevExpress.XtraReports.UI.XRSubreport
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents XrLabel27 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents VW_C_UsuariosTableAdapter As Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter
    Friend WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DsNotasBenn1 As Korima_Reporteador.dsNotasBenn
    Friend WithEvents Negritas As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents bordes1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents bordes2 As DevExpress.XtraReports.UI.FormattingRule
    Private WithEvents RpT_FirmasVerticalElectronica1 As Korima_Reporteador.RPT_FirmasVerticalElectronica
    Friend WithEvents visible As DevExpress.XtraReports.UI.FormattingRule
    Public WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
End Class
