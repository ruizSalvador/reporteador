<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class NOTA_Indice_NotasdeMemoria
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
        Me.Negritas = New DevExpress.XtraReports.UI.FormattingRule()
        Me.prmNota1 = New DevExpress.XtraReports.Parameters.Parameter()
        Me.pageInfo2 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.pageInfo1 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.PageFooter = New DevExpress.XtraReports.UI.PageFooterBand()
        Me.XrLblIso = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLblUsr = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteDomicilio = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteTelefono = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteRFC = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptEnteCiudad = New DevExpress.XtraReports.UI.XRLabel()
        Me.line2 = New DevExpress.XtraReports.UI.XRLine()
        Me.line1 = New DevExpress.XtraReports.UI.XRLine()
        Me.label2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.label6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.label1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageHeader = New DevExpress.XtraReports.UI.PageHeaderBand()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.pageInfo3 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.lblRptNombreReporte = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptNombreEnte = New DevExpress.XtraReports.UI.XRLabel()
        Me.PICEnteLogo = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.Total = New DevExpress.XtraReports.UI.CalculatedField()
        Me.ReportFooter = New DevExpress.XtraReports.UI.ReportFooterBand()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Negritas
        '
        Me.Negritas.Condition = "[cuenta] == '12100' or [cuenta] == '12130'"
        '
        '
        '
        Me.Negritas.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Negritas.Name = "Negritas"
        '
        'prmNota1
        '
        Me.prmNota1.Description = "Comentarios"
        Me.prmNota1.Name = "prmNota1"
        Me.prmNota1.Value = "(Click para editar)"
        Me.prmNota1.Visible = False
        '
        'pageInfo2
        '
        Me.pageInfo2.Dpi = 254.0!
        Me.pageInfo2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo2.Format = "{0:HH:mm}"
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(1532.067!, 190.5!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(350.7448!, 58.42004!)
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'TopMargin
        '
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 99.0!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'pageInfo1
        '
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(1532.067!, 127.0!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(350.7454!, 58.41997!)
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLblIso, Me.XrLblUsr, Me.lblRptEnteDomicilio, Me.lblRptEnteTelefono, Me.lblRptEnteRFC, Me.lblRptEnteCiudad, Me.line2})
        Me.PageFooter.Dpi = 254.0!
        Me.PageFooter.HeightF = 131.0449!
        Me.PageFooter.Name = "PageFooter"
        '
        'XrLblIso
        '
        Me.XrLblIso.Dpi = 254.0!
        Me.XrLblIso.Font = New System.Drawing.Font("Tahoma", 8.0!)
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(1361.582!, 67.54498!)
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
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(1361.582!, 24.99993!)
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
        Me.lblRptEnteDomicilio.SizeF = New System.Drawing.SizeF(981.6047!, 42.545!)
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
        Me.lblRptEnteRFC.LocationFloat = New DevExpress.Utils.PointFloat(981.6047!, 19.54467!)
        Me.lblRptEnteRFC.Name = "lblRptEnteRFC"
        Me.lblRptEnteRFC.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptEnteRFC.SizeF = New System.Drawing.SizeF(379.9776!, 42.545!)
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
        Me.line2.SizeF = New System.Drawing.SizeF(1848.417!, 19.54467!)
        '
        'line1
        '
        Me.line1.Dpi = 254.0!
        Me.line1.LineWidth = 3
        Me.line1.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 298.45!)
        Me.line1.Name = "line1"
        Me.line1.SizeF = New System.Drawing.SizeF(1848.417!, 15.875!)
        '
        'label2
        '
        Me.label2.Dpi = 254.0!
        Me.label2.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label2.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.label2.Multiline = True
        Me.label2.Name = "label2"
        Me.label2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label2.SizeF = New System.Drawing.SizeF(1649.979!, 92.81588!)
        Me.label2.StylePriority.UseFont = False
        Me.label2.StylePriority.UseTextAlignment = False
        Me.label2.Text = "NOTAS DE MEMORIA"
        Me.label2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.label6, Me.label2, Me.label1})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 1021.505!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'label6
        '
        Me.label6.Dpi = 254.0!
        Me.label6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label6.LocationFloat = New DevExpress.Utils.PointFloat(125.3749!, 418.0417!)
        Me.label6.Multiline = True
        Me.label6.Name = "label6"
        Me.label6.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label6.SizeF = New System.Drawing.SizeF(763.6251!, 87.52405!)
        Me.label6.StylePriority.UseFont = False
        Me.label6.Text = "Nota 2" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Notas Presupuestarias"
        '
        'label1
        '
        Me.label1.Dpi = 254.0!
        Me.label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.label1.LocationFloat = New DevExpress.Utils.PointFloat(125.3749!, 225.2133!)
        Me.label1.Multiline = True
        Me.label1.Name = "label1"
        Me.label1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.label1.SizeF = New System.Drawing.SizeF(506.9792!, 87.52405!)
        Me.label1.StylePriority.UseFont = False
        Me.label1.Text = "Nota 1" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Notas Contables"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PICEnteLogoSecundario, Me.line1, Me.pageInfo2, Me.pageInfo1, Me.pageInfo3, Me.lblRptNombreReporte, Me.lblRptNombreEnte, Me.PICEnteLogo})
        Me.PageHeader.Dpi = 254.0!
        Me.PageHeader.HeightF = 370.4167!
        Me.PageHeader.Name = "PageHeader"
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(1316.696!, 63.5!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'pageInfo3
        '
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(1532.067!, 63.5!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(350.7454!, 58.42004!)
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(233.8918!, 127.0!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(1070.634!, 58.42!)
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(233.8918!, 63.5!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(1070.634!, 58.41997!)
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
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.HeightF = 99.0!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Total
        '
        Me.Total.Expression = "Iif([cuenta] == '12100', [Monto] ,0 )"
        Me.Total.Name = "Total"
        '
        'ReportFooter
        '
        Me.ReportFooter.Dpi = 254.0!
        Me.ReportFooter.HeightF = 87.52405!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'NOTA_Indice_NotasdeMemoria
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.PageHeader, Me.PageFooter, Me.ReportFooter})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.Total})
        Me.DataMember = "Nota"
        Me.DisplayName = "NOTA_Indice_NotasdeMemoria"
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.Negritas})
        Me.Margins = New System.Drawing.Printing.Margins(196, 69, 99, 99)
        Me.PageHeight = 2794
        Me.PageWidth = 2159
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {Me.prmNota1})
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.Version = "11.1"
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Negritas As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents prmNota1 As DevExpress.XtraReports.Parameters.Parameter
    Friend WithEvents pageInfo2 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents pageInfo1 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents line1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents label2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents label6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents label1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageHeader As DevExpress.XtraReports.UI.PageHeaderBand
    Friend WithEvents pageInfo3 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents lblRptNombreReporte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptNombreEnte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PICEnteLogo As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents Total As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Public WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
End Class
