<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class RPT_InformeEstudiosActuarialesLDF
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
        Me.lblDetail_Riesgos = New DevExpress.XtraReports.UI.XRLabel()
        Me.DsNotasBenn1 = New Korima_Reporteador.dsNotasBenn()
        Me.FormattingRule4 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule8 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule2 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.lblDetail_Invalidez = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblDetail_concepto = New DevExpress.XtraReports.UI.XRLabel()
        Me.FormattingRule5 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.lblDetail_OtrasPrestaciones = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblDetail_Pensiones = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblDetail_Salud = New DevExpress.XtraReports.UI.XRLabel()
        Me.FormattingRule1 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule3 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule6 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.FormattingRule7 = New DevExpress.XtraReports.UI.FormattingRule()
        Me.TopMargin = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.PICEnteLogoSecundario = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.XrPictureBox1 = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.pageInfo1 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.PICEnteLogo = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.pageInfo2 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.pageInfo3 = New DevExpress.XtraReports.UI.XRPageInfo()
        Me.lblRptNombreEnte = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblRptNombreReporte = New DevExpress.XtraReports.UI.XRLabel()
        Me.BottomMargin = New DevExpress.XtraReports.UI.BottomMarginBand()
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
        Me.RpT_FirmasHorizontalElectronica1 = New Korima_Reporteador.RPT_FirmasHorizontalElectronica()
        Me.XrLabel5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel10 = New DevExpress.XtraReports.UI.XRLabel()
        Me._Korima2_00_ReporteadorDataSet1 = New Korima_Reporteador._Korima2_00_ReporteadorDataSet()
        Me.VW_C_UsuariosTableAdapter = New Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter()
        Me.GroupFooter1 = New DevExpress.XtraReports.UI.GroupFooterBand()
        Me.XrLabel14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.lblHeader3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblHeader4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblHeader5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblHeader1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.lblHeader2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.SumaHorizontal = New DevExpress.XtraReports.UI.CalculatedField()
        Me.EvenStyle = New DevExpress.XtraReports.UI.XRControlStyle()
        prmNota1 = New DevExpress.XtraReports.Parameters.Parameter()
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RpT_FirmasHorizontalElectronica1, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.lblDetail_Riesgos, Me.lblDetail_Invalidez, Me.lblDetail_concepto, Me.lblDetail_OtrasPrestaciones, Me.lblDetail_Pensiones, Me.lblDetail_Salud})
        Me.Detail.Dpi = 254.0!
        Me.Detail.HeightF = 66.35754!
        Me.Detail.Name = "Detail"
        Me.Detail.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'lblDetail_Riesgos
        '
        Me.lblDetail_Riesgos.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_Riesgos.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.lblDetail_Riesgos.BorderWidth = 1
        Me.lblDetail_Riesgos.CanGrow = False
        Me.lblDetail_Riesgos.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Me.DsNotasBenn1, "SP_Informes_Actuarias.Riesgos_de_trabajo", "{0:n2}")})
        Me.lblDetail_Riesgos.Dpi = 254.0!
        Me.lblDetail_Riesgos.EvenStyleName = "EvenStyle"
        Me.lblDetail_Riesgos.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.lblDetail_Riesgos.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_Riesgos.FormattingRules.Add(Me.FormattingRule8)
        Me.lblDetail_Riesgos.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_Riesgos.LocationFloat = New DevExpress.Utils.PointFloat(2368.917!, 0.0!)
        Me.lblDetail_Riesgos.Name = "lblDetail_Riesgos"
        Me.lblDetail_Riesgos.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblDetail_Riesgos.SizeF = New System.Drawing.SizeF(317.4998!, 66.35754!)
        Me.lblDetail_Riesgos.StylePriority.UseBorders = False
        Me.lblDetail_Riesgos.StylePriority.UseBorderWidth = False
        Me.lblDetail_Riesgos.StylePriority.UseFont = False
        Me.lblDetail_Riesgos.StylePriority.UseTextAlignment = False
        Me.lblDetail_Riesgos.Text = "lblDetail_Riesgos"
        Me.lblDetail_Riesgos.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'DsNotasBenn1
        '
        Me.DsNotasBenn1.DataSetName = "dsNotasBenn"
        Me.DsNotasBenn1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'FormattingRule4
        '
        Me.FormattingRule4.Condition = "[NombreCuenta]='TOTAL'"
        '
        '
        '
        Me.FormattingRule4.Formatting.Borders = CType((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.FormattingRule4.Formatting.BorderWidth = 3
        Me.FormattingRule4.Name = "FormattingRule4"
        '
        'FormattingRule8
        '
        Me.FormattingRule8.Condition = "[NumeroCuenta] like '221%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '222%' "
        '
        '
        '
        Me.FormattingRule8.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule8.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.FormattingRule8.Name = "FormattingRule8"
        '
        'FormattingRule2
        '
        Me.FormattingRule2.Condition = "[Negritas]=1"
        '
        '
        '
        Me.FormattingRule2.Formatting.Font = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormattingRule2.Name = "FormattingRule2"
        '
        'lblDetail_Invalidez
        '
        Me.lblDetail_Invalidez.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_Invalidez.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.lblDetail_Invalidez.BorderWidth = 1
        Me.lblDetail_Invalidez.CanGrow = False
        Me.lblDetail_Invalidez.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Me.DsNotasBenn1, "SP_Informes_Actuarias.Invalidez_y_vida", "{0:n2}")})
        Me.lblDetail_Invalidez.Dpi = 254.0!
        Me.lblDetail_Invalidez.EvenStyleName = "EvenStyle"
        Me.lblDetail_Invalidez.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.lblDetail_Invalidez.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_Invalidez.FormattingRules.Add(Me.FormattingRule8)
        Me.lblDetail_Invalidez.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_Invalidez.LocationFloat = New DevExpress.Utils.PointFloat(2686.417!, 0.0!)
        Me.lblDetail_Invalidez.Name = "lblDetail_Invalidez"
        Me.lblDetail_Invalidez.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblDetail_Invalidez.SizeF = New System.Drawing.SizeF(285.7498!, 66.35754!)
        Me.lblDetail_Invalidez.StylePriority.UseBorders = False
        Me.lblDetail_Invalidez.StylePriority.UseBorderWidth = False
        Me.lblDetail_Invalidez.StylePriority.UseFont = False
        Me.lblDetail_Invalidez.StylePriority.UseTextAlignment = False
        Me.lblDetail_Invalidez.Text = "lblDetail_Invalidez"
        Me.lblDetail_Invalidez.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblDetail_concepto
        '
        Me.lblDetail_concepto.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_concepto.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Right), DevExpress.XtraPrinting.BorderSide)
        Me.lblDetail_concepto.BorderWidth = 1
        Me.lblDetail_concepto.CanGrow = False
        Me.lblDetail_concepto.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "SP_Informes_Actuarias.Concepto")})
        Me.lblDetail_concepto.Dpi = 254.0!
        Me.lblDetail_concepto.EvenStyleName = "EvenStyle"
        Me.lblDetail_concepto.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDetail_concepto.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_concepto.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_concepto.FormattingRules.Add(Me.FormattingRule5)
        Me.lblDetail_concepto.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 0.0!)
        Me.lblDetail_concepto.Name = "lblDetail_concepto"
        Me.lblDetail_concepto.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 5, 0, 0, 254.0!)
        Me.lblDetail_concepto.SizeF = New System.Drawing.SizeF(1765.667!, 66.35754!)
        Me.lblDetail_concepto.StylePriority.UseBorders = False
        Me.lblDetail_concepto.StylePriority.UseBorderWidth = False
        Me.lblDetail_concepto.StylePriority.UseFont = False
        Me.lblDetail_concepto.StylePriority.UsePadding = False
        Me.lblDetail_concepto.StylePriority.UseTextAlignment = False
        Me.lblDetail_concepto.Text = "lblDetail_concepto"
        Me.lblDetail_concepto.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft
        '
        'FormattingRule5
        '
        Me.FormattingRule5.Condition = "[NombreCuenta]='TOTAL'"
        '
        '
        '
        Me.FormattingRule5.Formatting.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight
        Me.FormattingRule5.Name = "FormattingRule5"
        '
        'lblDetail_OtrasPrestaciones
        '
        Me.lblDetail_OtrasPrestaciones.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_OtrasPrestaciones.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.lblDetail_OtrasPrestaciones.BorderWidth = 1
        Me.lblDetail_OtrasPrestaciones.CanGrow = False
        Me.lblDetail_OtrasPrestaciones.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Me.DsNotasBenn1, "SP_Informes_Actuarias.Otras_prestaciones_sociales", "{0:n2}")})
        Me.lblDetail_OtrasPrestaciones.Dpi = 254.0!
        Me.lblDetail_OtrasPrestaciones.EvenStyleName = "EvenStyle"
        Me.lblDetail_OtrasPrestaciones.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.lblDetail_OtrasPrestaciones.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_OtrasPrestaciones.FormattingRules.Add(Me.FormattingRule8)
        Me.lblDetail_OtrasPrestaciones.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_OtrasPrestaciones.LocationFloat = New DevExpress.Utils.PointFloat(2972.167!, 0.0!)
        Me.lblDetail_OtrasPrestaciones.Name = "lblDetail_OtrasPrestaciones"
        Me.lblDetail_OtrasPrestaciones.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblDetail_OtrasPrestaciones.SizeF = New System.Drawing.SizeF(278.8333!, 66.35754!)
        Me.lblDetail_OtrasPrestaciones.StylePriority.UseBorders = False
        Me.lblDetail_OtrasPrestaciones.StylePriority.UseBorderWidth = False
        Me.lblDetail_OtrasPrestaciones.StylePriority.UseFont = False
        Me.lblDetail_OtrasPrestaciones.StylePriority.UseTextAlignment = False
        Me.lblDetail_OtrasPrestaciones.Text = "lblDetail_OtrasPrestaciones"
        Me.lblDetail_OtrasPrestaciones.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblDetail_Pensiones
        '
        Me.lblDetail_Pensiones.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_Pensiones.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.lblDetail_Pensiones.BorderWidth = 1
        Me.lblDetail_Pensiones.CanGrow = False
        Me.lblDetail_Pensiones.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Me.DsNotasBenn1, "SP_Informes_Actuarias.Pensiones_y_Jubilaciones", "{0:n2}")})
        Me.lblDetail_Pensiones.Dpi = 254.0!
        Me.lblDetail_Pensiones.EvenStyleName = "EvenStyle"
        Me.lblDetail_Pensiones.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.lblDetail_Pensiones.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_Pensiones.FormattingRules.Add(Me.FormattingRule8)
        Me.lblDetail_Pensiones.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_Pensiones.LocationFloat = New DevExpress.Utils.PointFloat(1765.667!, 0.0!)
        Me.lblDetail_Pensiones.Name = "lblDetail_Pensiones"
        Me.lblDetail_Pensiones.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblDetail_Pensiones.SizeF = New System.Drawing.SizeF(317.501!, 66.35754!)
        Me.lblDetail_Pensiones.StylePriority.UseBorders = False
        Me.lblDetail_Pensiones.StylePriority.UseBorderWidth = False
        Me.lblDetail_Pensiones.StylePriority.UseFont = False
        Me.lblDetail_Pensiones.StylePriority.UseTextAlignment = False
        Me.lblDetail_Pensiones.Text = "lblDetail_Pensiones"
        Me.lblDetail_Pensiones.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblDetail_Salud
        '
        Me.lblDetail_Salud.AnchorVertical = CType((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top Or DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom), DevExpress.XtraReports.UI.VerticalAnchorStyles)
        Me.lblDetail_Salud.Borders = DevExpress.XtraPrinting.BorderSide.Right
        Me.lblDetail_Salud.BorderWidth = 1
        Me.lblDetail_Salud.CanGrow = False
        Me.lblDetail_Salud.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Me.DsNotasBenn1, "SP_Informes_Actuarias.Salud", "{0:n2}")})
        Me.lblDetail_Salud.Dpi = 254.0!
        Me.lblDetail_Salud.EvenStyleName = "EvenStyle"
        Me.lblDetail_Salud.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.lblDetail_Salud.FormattingRules.Add(Me.FormattingRule4)
        Me.lblDetail_Salud.FormattingRules.Add(Me.FormattingRule8)
        Me.lblDetail_Salud.FormattingRules.Add(Me.FormattingRule2)
        Me.lblDetail_Salud.LocationFloat = New DevExpress.Utils.PointFloat(2083.167!, 0.0!)
        Me.lblDetail_Salud.Name = "lblDetail_Salud"
        Me.lblDetail_Salud.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblDetail_Salud.SizeF = New System.Drawing.SizeF(285.7498!, 66.35754!)
        Me.lblDetail_Salud.StylePriority.UseBorders = False
        Me.lblDetail_Salud.StylePriority.UseBorderWidth = False
        Me.lblDetail_Salud.StylePriority.UseFont = False
        Me.lblDetail_Salud.StylePriority.UseTextAlignment = False
        Me.lblDetail_Salud.Text = "lblDetail_Salud"
        Me.lblDetail_Salud.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'FormattingRule1
        '
        Me.FormattingRule1.Condition = "[Parameters.prmNota1]  Like  'Espacio asignado para notas%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Parameters.prmTi" & _
            "po]  Like  'Espacio asignado para notas%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[Parameters.prmNaturaleza] Like  '" & _
            "Espacio asignado para notas%' "
        '
        '
        '
        Me.FormattingRule1.Formatting.Font = New System.Drawing.Font("Tahoma", 8.25!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Italic), System.Drawing.FontStyle), System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormattingRule1.Formatting.ForeColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.FormattingRule1.Name = "FormattingRule1"
        '
        'FormattingRule3
        '
        Me.FormattingRule3.Condition = "[NombreCuenta]='TOTAL'"
        '
        '
        '
        Me.FormattingRule3.Formatting.Borders = CType((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top), DevExpress.XtraPrinting.BorderSide)
        Me.FormattingRule3.Formatting.BorderWidth = 3
        Me.FormattingRule3.Name = "FormattingRule3"
        '
        'FormattingRule6
        '
        Me.FormattingRule6.Condition = "[NumeroCuenta] like '211%' or" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "[NumeroCuenta] like '212%' "
        '
        '
        '
        Me.FormattingRule6.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule6.Formatting.Visible = DevExpress.Utils.DefaultBoolean.[True]
        Me.FormattingRule6.Name = "FormattingRule6"
        '
        'FormattingRule7
        '
        Me.FormattingRule7.Condition = "[NumeroCuenta] = 'TOTAL'"
        '
        '
        '
        Me.FormattingRule7.Formatting.ForeColor = System.Drawing.Color.Transparent
        Me.FormattingRule7.Name = "FormattingRule7"
        '
        'TopMargin
        '
        Me.TopMargin.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PICEnteLogoSecundario, Me.XrPictureBox1, Me.pageInfo1, Me.PICEnteLogo, Me.pageInfo2, Me.pageInfo3, Me.lblRptNombreEnte, Me.lblRptNombreReporte})
        Me.TopMargin.Dpi = 254.0!
        Me.TopMargin.HeightF = 216.7466!
        Me.TopMargin.Name = "TopMargin"
        Me.TopMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'PICEnteLogoSecundario
        '
        Me.PICEnteLogoSecundario.Dpi = 254.0!
        Me.PICEnteLogoSecundario.LocationFloat = New DevExpress.Utils.PointFloat(2617.839!, 0.0!)
        Me.PICEnteLogoSecundario.Name = "PICEnteLogoSecundario"
        Me.PICEnteLogoSecundario.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogoSecundario.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'XrPictureBox1
        '
        Me.XrPictureBox1.Dpi = 254.0!
        Me.XrPictureBox1.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.XrPictureBox1.Name = "XrPictureBox1"
        Me.XrPictureBox1.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.XrPictureBox1.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'pageInfo1
        '
        Me.pageInfo1.Dpi = 254.0!
        Me.pageInfo1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo1.Format = "{0:dd/MM/yyyy}"
        Me.pageInfo1.LocationFloat = New DevExpress.Utils.PointFloat(2847.338!, 69.82653!)
        Me.pageInfo1.Name = "pageInfo1"
        Me.pageInfo1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo1.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo1.SizeF = New System.Drawing.SizeF(403.662!, 58.41997!)
        Me.pageInfo1.StylePriority.UseFont = False
        Me.pageInfo1.StylePriority.UseTextAlignment = False
        Me.pageInfo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'PICEnteLogo
        '
        Me.PICEnteLogo.Dpi = 254.0!
        Me.PICEnteLogo.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.PICEnteLogo.Name = "PICEnteLogo"
        Me.PICEnteLogo.SizeF = New System.Drawing.SizeF(215.3709!, 203.2!)
        Me.PICEnteLogo.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage
        '
        'pageInfo2
        '
        Me.pageInfo2.Dpi = 254.0!
        Me.pageInfo2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo2.Format = "{0:HH:mm}"
        Me.pageInfo2.LocationFloat = New DevExpress.Utils.PointFloat(2847.338!, 133.3265!)
        Me.pageInfo2.Name = "pageInfo2"
        Me.pageInfo2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo2.PageInfo = DevExpress.XtraPrinting.PageInfo.DateTime
        Me.pageInfo2.SizeF = New System.Drawing.SizeF(403.6619!, 58.42007!)
        Me.pageInfo2.StylePriority.UseFont = False
        Me.pageInfo2.StylePriority.UseTextAlignment = False
        Me.pageInfo2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'pageInfo3
        '
        Me.pageInfo3.Dpi = 254.0!
        Me.pageInfo3.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pageInfo3.Format = "Pagina {0} de {1}"
        Me.pageInfo3.LocationFloat = New DevExpress.Utils.PointFloat(2847.338!, 6.326528!)
        Me.pageInfo3.Name = "pageInfo3"
        Me.pageInfo3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.pageInfo3.SizeF = New System.Drawing.SizeF(403.6621!, 58.42002!)
        Me.pageInfo3.StylePriority.UseFont = False
        Me.pageInfo3.StylePriority.UseTextAlignment = False
        Me.pageInfo3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreEnte
        '
        Me.lblRptNombreEnte.Dpi = 254.0!
        Me.lblRptNombreEnte.Font = New System.Drawing.Font("Tahoma", 14.25!)
        Me.lblRptNombreEnte.LocationFloat = New DevExpress.Utils.PointFloat(220.6626!, 5.080054!)
        Me.lblRptNombreEnte.Name = "lblRptNombreEnte"
        Me.lblRptNombreEnte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreEnte.SizeF = New System.Drawing.SizeF(2397.176!, 58.41998!)
        Me.lblRptNombreEnte.StylePriority.UseFont = False
        Me.lblRptNombreEnte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreEnte.Text = "Nombre del Ente público"
        Me.lblRptNombreEnte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblRptNombreReporte
        '
        Me.lblRptNombreReporte.Dpi = 254.0!
        Me.lblRptNombreReporte.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRptNombreReporte.LocationFloat = New DevExpress.Utils.PointFloat(220.6626!, 63.49997!)
        Me.lblRptNombreReporte.Name = "lblRptNombreReporte"
        Me.lblRptNombreReporte.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblRptNombreReporte.SizeF = New System.Drawing.SizeF(2397.176!, 58.42!)
        Me.lblRptNombreReporte.StylePriority.UseFont = False
        Me.lblRptNombreReporte.StylePriority.UseTextAlignment = False
        Me.lblRptNombreReporte.Text = "Nombre del Reporte"
        Me.lblRptNombreReporte.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'BottomMargin
        '
        Me.BottomMargin.Dpi = 254.0!
        Me.BottomMargin.Name = "BottomMargin"
        Me.BottomMargin.Padding = New DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 254.0!)
        Me.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
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
        Me.XrLblIso.LocationFloat = New DevExpress.Utils.PointFloat(2706.719!, 62.08972!)
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
        Me.XrLblUsr.LocationFloat = New DevExpress.Utils.PointFloat(2706.72!, 19.54467!)
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
        Me.line2.SizeF = New System.Drawing.SizeF(3237.096!, 19.54469!)
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
        Me.XrSubreport1.LocationFloat = New DevExpress.Utils.PointFloat(381.0!, 63.5!)
        Me.XrSubreport1.Name = "XrSubreport1"
        Me.XrSubreport1.ReportSource = Me.RpT_FirmasHorizontalElectronica1
        Me.XrSubreport1.SizeF = New System.Drawing.SizeF(2494.0!, 87.52423!)
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
        Me.XrLabel14.SizeF = New System.Drawing.SizeF(1159.8!, 63.0!)
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
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.lblHeader3, Me.lblHeader4, Me.lblHeader5, Me.XrLabel2, Me.lblHeader1, Me.lblHeader2})
        Me.GroupHeader1.Dpi = 254.0!
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("Grupo", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 148.3784!
        Me.GroupHeader1.KeepTogether = True
        Me.GroupHeader1.Name = "GroupHeader1"
        Me.GroupHeader1.RepeatEveryPage = True
        '
        'lblHeader3
        '
        Me.lblHeader3.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.lblHeader3.BorderWidth = 1
        Me.lblHeader3.Dpi = 254.0!
        Me.lblHeader3.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblHeader3.LocationFloat = New DevExpress.Utils.PointFloat(2368.917!, 0.0!)
        Me.lblHeader3.Name = "lblHeader3"
        Me.lblHeader3.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblHeader3.SizeF = New System.Drawing.SizeF(317.5001!, 148.3783!)
        Me.lblHeader3.StylePriority.UseBorders = False
        Me.lblHeader3.StylePriority.UseBorderWidth = False
        Me.lblHeader3.StylePriority.UseFont = False
        Me.lblHeader3.StylePriority.UseTextAlignment = False
        Me.lblHeader3.Text = "Riesgos de Trabajo"
        Me.lblHeader3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblHeader4
        '
        Me.lblHeader4.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.lblHeader4.BorderWidth = 1
        Me.lblHeader4.Dpi = 254.0!
        Me.lblHeader4.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblHeader4.LocationFloat = New DevExpress.Utils.PointFloat(2686.417!, 0.0!)
        Me.lblHeader4.Name = "lblHeader4"
        Me.lblHeader4.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblHeader4.SizeF = New System.Drawing.SizeF(285.7495!, 148.3783!)
        Me.lblHeader4.StylePriority.UseBorders = False
        Me.lblHeader4.StylePriority.UseBorderWidth = False
        Me.lblHeader4.StylePriority.UseFont = False
        Me.lblHeader4.StylePriority.UseTextAlignment = False
        Me.lblHeader4.Text = "Invalidez y vida"
        Me.lblHeader4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblHeader5
        '
        Me.lblHeader5.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.lblHeader5.BorderWidth = 1
        Me.lblHeader5.Dpi = 254.0!
        Me.lblHeader5.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblHeader5.LocationFloat = New DevExpress.Utils.PointFloat(2972.167!, 0.0!)
        Me.lblHeader5.Name = "lblHeader5"
        Me.lblHeader5.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblHeader5.SizeF = New System.Drawing.SizeF(278.833!, 148.3783!)
        Me.lblHeader5.StylePriority.UseBorders = False
        Me.lblHeader5.StylePriority.UseBorderWidth = False
        Me.lblHeader5.StylePriority.UseFont = False
        Me.lblHeader5.StylePriority.UseTextAlignment = False
        Me.lblHeader5.Text = "Otras prestaciones sociales"
        Me.lblHeader5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'XrLabel2
        '
        Me.XrLabel2.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
                    Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.XrLabel2.BorderWidth = 1
        Me.XrLabel2.Dpi = 254.0!
        Me.XrLabel2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(5.291667!, 0.0!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(1760.375!, 148.3783!)
        Me.XrLabel2.StylePriority.UseBorders = False
        Me.XrLabel2.StylePriority.UseBorderWidth = False
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.StylePriority.UseTextAlignment = False
        Me.XrLabel2.Text = "Concepto"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblHeader1
        '
        Me.lblHeader1.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.lblHeader1.BorderWidth = 1
        Me.lblHeader1.Dpi = 254.0!
        Me.lblHeader1.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblHeader1.LocationFloat = New DevExpress.Utils.PointFloat(1765.667!, 0.0!)
        Me.lblHeader1.Name = "lblHeader1"
        Me.lblHeader1.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblHeader1.SizeF = New System.Drawing.SizeF(317.5!, 148.3783!)
        Me.lblHeader1.StylePriority.UseBorders = False
        Me.lblHeader1.StylePriority.UseBorderWidth = False
        Me.lblHeader1.StylePriority.UseFont = False
        Me.lblHeader1.StylePriority.UseTextAlignment = False
        Me.lblHeader1.Text = "Pensiones y Jubilaciones"
        Me.lblHeader1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'lblHeader2
        '
        Me.lblHeader2.Borders = CType(((DevExpress.XtraPrinting.BorderSide.Top Or DevExpress.XtraPrinting.BorderSide.Right) _
                    Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.lblHeader2.BorderWidth = 1
        Me.lblHeader2.Dpi = 254.0!
        Me.lblHeader2.Font = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold)
        Me.lblHeader2.LocationFloat = New DevExpress.Utils.PointFloat(2083.167!, 0.0!)
        Me.lblHeader2.Name = "lblHeader2"
        Me.lblHeader2.Padding = New DevExpress.XtraPrinting.PaddingInfo(5, 5, 0, 0, 254.0!)
        Me.lblHeader2.SizeF = New System.Drawing.SizeF(285.7499!, 148.3783!)
        Me.lblHeader2.StylePriority.UseBorders = False
        Me.lblHeader2.StylePriority.UseBorderWidth = False
        Me.lblHeader2.StylePriority.UseFont = False
        Me.lblHeader2.StylePriority.UseTextAlignment = False
        Me.lblHeader2.Text = "Salud"
        Me.lblHeader2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter
        '
        'SumaHorizontal
        '
        Me.SumaHorizontal.Expression = "Iif([NumeroCuenta] Like '22%' ,[MasDe365] ,[Nota1] + [Nota2] + [Nota3])"
        Me.SumaHorizontal.Name = "SumaHorizontal"
        '
        'EvenStyle
        '
        Me.EvenStyle.BackColor = System.Drawing.Color.Gainsboro
        Me.EvenStyle.Name = "EvenStyle"
        '
        'RPT_InformeEstudiosActuarialesLDF
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.TopMargin, Me.BottomMargin, Me.PageFooter, Me.ReportFooter, Me.GroupHeader1, Me.GroupFooter1})
        Me.CalculatedFields.AddRange(New DevExpress.XtraReports.UI.CalculatedField() {Me.SumaHorizontal})
        Me.DataAdapter = Me.VW_C_UsuariosTableAdapter
        Me.Dpi = 254.0!
        Me.FormattingRuleSheet.AddRange(New DevExpress.XtraReports.UI.FormattingRule() {Me.FormattingRule1, Me.FormattingRule2, Me.FormattingRule3, Me.FormattingRule4, Me.FormattingRule5, Me.FormattingRule6, Me.FormattingRule7, Me.FormattingRule8})
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(198, 101, 217, 100)
        Me.PageHeight = 2110
        Me.PageWidth = 3550
        Me.PaperKind = System.Drawing.Printing.PaperKind.Custom
        Me.Parameters.AddRange(New DevExpress.XtraReports.Parameters.Parameter() {prmNota1})
        Me.ReportUnit = DevExpress.XtraReports.UI.ReportUnit.TenthsOfAMillimeter
        Me.SnapGridSize = 31.75!
        Me.StyleSheet.AddRange(New DevExpress.XtraReports.UI.XRControlStyle() {Me.EvenStyle})
        Me.Version = "11.1"
        CType(Me.DsNotasBenn1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RpT_FirmasHorizontalElectronica1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me._Korima2_00_ReporteadorDataSet1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents TopMargin As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMargin As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents ReportFooter As DevExpress.XtraReports.UI.ReportFooterBand
    Friend WithEvents _Korima2_00_ReporteadorDataSet1 As Korima_Reporteador._Korima2_00_ReporteadorDataSet
    Friend WithEvents VW_C_UsuariosTableAdapter As Korima_Reporteador._Korima2_00_ReporteadorDataSetTableAdapters.VW_C_UsuariosTableAdapter
    Friend WithEvents XrLabel5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteDomicilio As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteTelefono As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteRFC As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptEnteCiudad As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents GroupFooter1 As DevExpress.XtraReports.UI.GroupFooterBand
    Friend WithEvents FormattingRule1 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents XrLabel14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents FormattingRule2 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule4 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule3 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule5 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule6 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule7 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents FormattingRule8 As DevExpress.XtraReports.UI.FormattingRule
    Friend WithEvents SumaHorizontal As DevExpress.XtraReports.UI.CalculatedField
    Friend WithEvents XrLblIso As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLblUsr As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents EvenStyle As DevExpress.XtraReports.UI.XRControlStyle
    Friend WithEvents lblHeader3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblHeader4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblHeader5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblHeader1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblHeader2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_Riesgos As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_Invalidez As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_concepto As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_OtrasPrestaciones As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_Pensiones As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblDetail_Salud As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptNombreEnte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents lblRptNombreReporte As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents pageInfo1 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents PICEnteLogo As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents pageInfo2 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents pageInfo3 As DevExpress.XtraReports.UI.XRPageInfo
    Friend WithEvents XrPictureBox1 As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents XrSubreport1 As DevExpress.XtraReports.UI.XRSubreport
    Private WithEvents RpT_FirmasHorizontalElectronica1 As Korima_Reporteador.RPT_FirmasHorizontalElectronica
    Friend WithEvents DsNotasBenn1 As Korima_Reporteador.dsNotasBenn
    Public WithEvents PICEnteLogoSecundario As DevExpress.XtraReports.UI.XRPictureBox
End Class
