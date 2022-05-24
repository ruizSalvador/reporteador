<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CtrlUsr_DatosEntidad
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.BarManager1 = New DevExpress.XtraBars.BarManager(Me.components)
        Me.Bar2 = New DevExpress.XtraBars.Bar()
        Me.ArchivoToolStripMenuItem = New DevExpress.XtraBars.BarSubItem()
        Me.AbrirToolStripMenuItem = New DevExpress.XtraBars.BarButtonItem()
        Me.GuardarToolStripMenuItem = New DevExpress.XtraBars.BarButtonItem()
        Me.CancelarToolStripMenuItem = New DevExpress.XtraBars.BarButtonItem()
        Me.CerrarToolStripMenuItem = New DevExpress.XtraBars.BarButtonItem()
        Me.Bar3 = New DevExpress.XtraBars.Bar()
        Me.barDockControlTop = New DevExpress.XtraBars.BarDockControl()
        Me.barDockControlBottom = New DevExpress.XtraBars.BarDockControl()
        Me.barDockControlLeft = New DevExpress.XtraBars.BarDockControl()
        Me.barDockControlRight = New DevExpress.XtraBars.BarDockControl()
        Me.LabelControl1 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_Nombre = New DevExpress.XtraEditors.TextEdit()
        Me.PE_LogoEnte = New DevExpress.XtraEditors.PictureEdit()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.LabelControl2 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_ClaveSistema = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl3 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_Domicilio = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl4 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_Ciudad = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl5 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_RFC = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl6 = New DevExpress.XtraEditors.LabelControl()
        Me.Txt_Telefonos = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl7 = New DevExpress.XtraEditors.LabelControl()
        Me.LabelControl8 = New DevExpress.XtraEditors.LabelControl()
        Me.Me_Texto = New DevExpress.XtraEditors.MemoEdit()
        Me.DxValidationProvider1 = New DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider(Me.components)
        Me.Txt_EF = New DevExpress.XtraEditors.TextEdit()
        Me.LabelControl9 = New DevExpress.XtraEditors.LabelControl()
        Me.PE_LogoEnteSecundario = New DevExpress.XtraEditors.PictureEdit()
        Me.PictureBox2 = New System.Windows.Forms.PictureBox()
        Me.LabelControl10 = New DevExpress.XtraEditors.LabelControl()
        CType(Me.BarManager1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_Nombre.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PE_LogoEnte.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_ClaveSistema.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_Domicilio.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_Ciudad.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_RFC.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_Telefonos.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Me_Texto.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DxValidationProvider1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.Txt_EF.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PE_LogoEnteSecundario.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'BarManager1
        '
        Me.BarManager1.Bars.AddRange(New DevExpress.XtraBars.Bar() {Me.Bar2, Me.Bar3})
        Me.BarManager1.DockControls.Add(Me.barDockControlTop)
        Me.BarManager1.DockControls.Add(Me.barDockControlBottom)
        Me.BarManager1.DockControls.Add(Me.barDockControlLeft)
        Me.BarManager1.DockControls.Add(Me.barDockControlRight)
        Me.BarManager1.Form = Me
        Me.BarManager1.Items.AddRange(New DevExpress.XtraBars.BarItem() {Me.ArchivoToolStripMenuItem, Me.AbrirToolStripMenuItem, Me.GuardarToolStripMenuItem, Me.CancelarToolStripMenuItem, Me.CerrarToolStripMenuItem})
        Me.BarManager1.MainMenu = Me.Bar2
        Me.BarManager1.MaxItemId = 7
        Me.BarManager1.StatusBar = Me.Bar3
        '
        'Bar2
        '
        Me.Bar2.BarName = "Main menu"
        Me.Bar2.DockCol = 0
        Me.Bar2.DockRow = 0
        Me.Bar2.DockStyle = DevExpress.XtraBars.BarDockStyle.Top
        Me.Bar2.LinksPersistInfo.AddRange(New DevExpress.XtraBars.LinkPersistInfo() {New DevExpress.XtraBars.LinkPersistInfo(Me.ArchivoToolStripMenuItem)})
        Me.Bar2.OptionsBar.MultiLine = True
        Me.Bar2.OptionsBar.UseWholeRow = True
        Me.Bar2.Text = "Main menu"
        '
        'ArchivoToolStripMenuItem
        '
        Me.ArchivoToolStripMenuItem.Caption = "&Archivo"
        Me.ArchivoToolStripMenuItem.Id = 0
        Me.ArchivoToolStripMenuItem.LinksPersistInfo.AddRange(New DevExpress.XtraBars.LinkPersistInfo() {New DevExpress.XtraBars.LinkPersistInfo(Me.AbrirToolStripMenuItem), New DevExpress.XtraBars.LinkPersistInfo(Me.GuardarToolStripMenuItem), New DevExpress.XtraBars.LinkPersistInfo(Me.CancelarToolStripMenuItem, True), New DevExpress.XtraBars.LinkPersistInfo(Me.CerrarToolStripMenuItem, True)})
        Me.ArchivoToolStripMenuItem.Name = "ArchivoToolStripMenuItem"
        '
        'AbrirToolStripMenuItem
        '
        Me.AbrirToolStripMenuItem.Caption = "&Abrir"
        Me.AbrirToolStripMenuItem.Glyph = Global.Korima_Reporteador.My.Resources.Resources.Open_16x16
        Me.AbrirToolStripMenuItem.Id = 1
        Me.AbrirToolStripMenuItem.Name = "AbrirToolStripMenuItem"
        '
        'GuardarToolStripMenuItem
        '
        Me.GuardarToolStripMenuItem.Caption = "&Guardar"
        Me.GuardarToolStripMenuItem.Enabled = False
        Me.GuardarToolStripMenuItem.Glyph = Global.Korima_Reporteador.My.Resources.Resources.Save_16x16
        Me.GuardarToolStripMenuItem.Id = 2
        Me.GuardarToolStripMenuItem.Name = "GuardarToolStripMenuItem"
        '
        'CancelarToolStripMenuItem
        '
        Me.CancelarToolStripMenuItem.Caption = "&Cancelar"
        Me.CancelarToolStripMenuItem.Enabled = False
        Me.CancelarToolStripMenuItem.Glyph = Global.Korima_Reporteador.My.Resources.Resources.Delete_16x16
        Me.CancelarToolStripMenuItem.Id = 4
        Me.CancelarToolStripMenuItem.Name = "CancelarToolStripMenuItem"
        '
        'CerrarToolStripMenuItem
        '
        Me.CerrarToolStripMenuItem.Caption = "C&errar"
        Me.CerrarToolStripMenuItem.Glyph = Global.Korima_Reporteador.My.Resources.Resources._16_On
        Me.CerrarToolStripMenuItem.Id = 6
        Me.CerrarToolStripMenuItem.Name = "CerrarToolStripMenuItem"
        Me.CerrarToolStripMenuItem.Visibility = DevExpress.XtraBars.BarItemVisibility.Never
        '
        'Bar3
        '
        Me.Bar3.BarName = "Status bar"
        Me.Bar3.CanDockStyle = DevExpress.XtraBars.BarCanDockStyle.Bottom
        Me.Bar3.DockCol = 0
        Me.Bar3.DockRow = 0
        Me.Bar3.DockStyle = DevExpress.XtraBars.BarDockStyle.Bottom
        Me.Bar3.OptionsBar.AllowQuickCustomization = False
        Me.Bar3.OptionsBar.DrawDragBorder = False
        Me.Bar3.OptionsBar.UseWholeRow = True
        Me.Bar3.Text = "Status bar"
        '
        'barDockControlTop
        '
        Me.barDockControlTop.CausesValidation = False
        Me.barDockControlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.barDockControlTop.Location = New System.Drawing.Point(0, 0)
        Me.barDockControlTop.Size = New System.Drawing.Size(677, 22)
        '
        'barDockControlBottom
        '
        Me.barDockControlBottom.CausesValidation = False
        Me.barDockControlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.barDockControlBottom.Location = New System.Drawing.Point(0, 352)
        Me.barDockControlBottom.Size = New System.Drawing.Size(677, 25)
        '
        'barDockControlLeft
        '
        Me.barDockControlLeft.CausesValidation = False
        Me.barDockControlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.barDockControlLeft.Location = New System.Drawing.Point(0, 22)
        Me.barDockControlLeft.Size = New System.Drawing.Size(0, 330)
        '
        'barDockControlRight
        '
        Me.barDockControlRight.CausesValidation = False
        Me.barDockControlRight.Dock = System.Windows.Forms.DockStyle.Right
        Me.barDockControlRight.Location = New System.Drawing.Point(677, 22)
        Me.barDockControlRight.Size = New System.Drawing.Size(0, 330)
        '
        'LabelControl1
        '
        Me.LabelControl1.Location = New System.Drawing.Point(21, 44)
        Me.LabelControl1.Name = "LabelControl1"
        Me.LabelControl1.Size = New System.Drawing.Size(137, 13)
        Me.LabelControl1.TabIndex = 4
        Me.LabelControl1.Text = "Logotipo/Escudo de Entidad:"
        '
        'Txt_Nombre
        '
        Me.Txt_Nombre.Enabled = False
        Me.Txt_Nombre.EnterMoveNextControl = True
        Me.Txt_Nombre.Location = New System.Drawing.Point(227, 60)
        Me.Txt_Nombre.MenuManager = Me.BarManager1
        Me.Txt_Nombre.Name = "Txt_Nombre"
        Me.Txt_Nombre.Properties.MaxLength = 100
        Me.Txt_Nombre.Size = New System.Drawing.Size(437, 20)
        Me.Txt_Nombre.TabIndex = 0
        '
        'PE_LogoEnte
        '
        Me.PE_LogoEnte.Enabled = False
        Me.PE_LogoEnte.Location = New System.Drawing.Point(36, 78)
        Me.PE_LogoEnte.MenuManager = Me.BarManager1
        Me.PE_LogoEnte.Name = "PE_LogoEnte"
        Me.PE_LogoEnte.Properties.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.PE_LogoEnte.Properties.Appearance.Options.UseBackColor = True
        Me.PE_LogoEnte.Properties.SizeMode = DevExpress.XtraEditors.Controls.PictureSizeMode.Squeeze
        Me.PE_LogoEnte.Size = New System.Drawing.Size(94, 94)
        Me.PE_LogoEnte.TabIndex = 8
        '
        'PictureBox1
        '
        Me.PictureBox1.Image = Global.Korima_Reporteador.My.Resources.Resources.Frame_Imagen_128
        Me.PictureBox1.Location = New System.Drawing.Point(21, 63)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(135, 125)
        Me.PictureBox1.TabIndex = 7
        Me.PictureBox1.TabStop = False
        '
        'LabelControl2
        '
        Me.LabelControl2.Location = New System.Drawing.Point(181, 63)
        Me.LabelControl2.Name = "LabelControl2"
        Me.LabelControl2.Size = New System.Drawing.Size(41, 13)
        Me.LabelControl2.TabIndex = 4
        Me.LabelControl2.Text = "Nombre:"
        '
        'Txt_ClaveSistema
        '
        Me.Txt_ClaveSistema.Enabled = False
        Me.Txt_ClaveSistema.EnterMoveNextControl = True
        Me.Txt_ClaveSistema.Location = New System.Drawing.Point(227, 216)
        Me.Txt_ClaveSistema.MenuManager = Me.BarManager1
        Me.Txt_ClaveSistema.Name = "Txt_ClaveSistema"
        Me.Txt_ClaveSistema.Properties.MaxLength = 100
        Me.Txt_ClaveSistema.Size = New System.Drawing.Size(437, 20)
        Me.Txt_ClaveSistema.TabIndex = 6
        Me.Txt_ClaveSistema.Visible = False
        '
        'LabelControl3
        '
        Me.LabelControl3.Location = New System.Drawing.Point(190, 219)
        Me.LabelControl3.Name = "LabelControl3"
        Me.LabelControl3.Size = New System.Drawing.Size(31, 13)
        Me.LabelControl3.TabIndex = 17
        Me.LabelControl3.Text = "Clave:"
        Me.LabelControl3.Visible = False
        '
        'Txt_Domicilio
        '
        Me.Txt_Domicilio.Enabled = False
        Me.Txt_Domicilio.EnterMoveNextControl = True
        Me.Txt_Domicilio.Location = New System.Drawing.Point(227, 86)
        Me.Txt_Domicilio.MenuManager = Me.BarManager1
        Me.Txt_Domicilio.Name = "Txt_Domicilio"
        Me.Txt_Domicilio.Properties.MaxLength = 250
        Me.Txt_Domicilio.Size = New System.Drawing.Size(437, 20)
        Me.Txt_Domicilio.TabIndex = 1
        '
        'LabelControl4
        '
        Me.LabelControl4.Location = New System.Drawing.Point(177, 89)
        Me.LabelControl4.Name = "LabelControl4"
        Me.LabelControl4.Size = New System.Drawing.Size(44, 13)
        Me.LabelControl4.TabIndex = 19
        Me.LabelControl4.Text = "Domicilio:"
        '
        'Txt_Ciudad
        '
        Me.Txt_Ciudad.Enabled = False
        Me.Txt_Ciudad.EnterMoveNextControl = True
        Me.Txt_Ciudad.Location = New System.Drawing.Point(227, 112)
        Me.Txt_Ciudad.MenuManager = Me.BarManager1
        Me.Txt_Ciudad.Name = "Txt_Ciudad"
        Me.Txt_Ciudad.Properties.MaxLength = 100
        Me.Txt_Ciudad.Size = New System.Drawing.Size(437, 20)
        Me.Txt_Ciudad.TabIndex = 2
        '
        'LabelControl5
        '
        Me.LabelControl5.Location = New System.Drawing.Point(184, 115)
        Me.LabelControl5.Name = "LabelControl5"
        Me.LabelControl5.Size = New System.Drawing.Size(37, 13)
        Me.LabelControl5.TabIndex = 21
        Me.LabelControl5.Text = "Ciudad:"
        '
        'Txt_RFC
        '
        Me.Txt_RFC.Enabled = False
        Me.Txt_RFC.EnterMoveNextControl = True
        Me.Txt_RFC.Location = New System.Drawing.Point(227, 164)
        Me.Txt_RFC.MenuManager = Me.BarManager1
        Me.Txt_RFC.Name = "Txt_RFC"
        Me.Txt_RFC.Properties.MaxLength = 20
        Me.Txt_RFC.Size = New System.Drawing.Size(135, 20)
        Me.Txt_RFC.TabIndex = 4
        '
        'LabelControl6
        '
        Me.LabelControl6.Location = New System.Drawing.Point(197, 167)
        Me.LabelControl6.Name = "LabelControl6"
        Me.LabelControl6.Size = New System.Drawing.Size(24, 13)
        Me.LabelControl6.TabIndex = 23
        Me.LabelControl6.Text = "RFC:"
        '
        'Txt_Telefonos
        '
        Me.Txt_Telefonos.Enabled = False
        Me.Txt_Telefonos.EnterMoveNextControl = True
        Me.Txt_Telefonos.Location = New System.Drawing.Point(227, 190)
        Me.Txt_Telefonos.MenuManager = Me.BarManager1
        Me.Txt_Telefonos.Name = "Txt_Telefonos"
        Me.Txt_Telefonos.Properties.MaxLength = 20
        Me.Txt_Telefonos.Size = New System.Drawing.Size(135, 20)
        Me.Txt_Telefonos.TabIndex = 5
        '
        'LabelControl7
        '
        Me.LabelControl7.Location = New System.Drawing.Point(175, 193)
        Me.LabelControl7.Name = "LabelControl7"
        Me.LabelControl7.Size = New System.Drawing.Size(46, 13)
        Me.LabelControl7.TabIndex = 25
        Me.LabelControl7.Text = "Telefono:"
        '
        'LabelControl8
        '
        Me.LabelControl8.Location = New System.Drawing.Point(189, 244)
        Me.LabelControl8.Name = "LabelControl8"
        Me.LabelControl8.Size = New System.Drawing.Size(32, 13)
        Me.LabelControl8.TabIndex = 27
        Me.LabelControl8.Text = "Texto:"
        Me.LabelControl8.Visible = False
        '
        'Me_Texto
        '
        Me.Me_Texto.Enabled = False
        Me.Me_Texto.EnterMoveNextControl = True
        Me.Me_Texto.Location = New System.Drawing.Point(227, 242)
        Me.Me_Texto.MenuManager = Me.BarManager1
        Me.Me_Texto.Name = "Me_Texto"
        Me.Me_Texto.Properties.MaxLength = 1000
        Me.Me_Texto.Size = New System.Drawing.Size(437, 59)
        Me.Me_Texto.TabIndex = 7
        Me.Me_Texto.Visible = False
        '
        'Txt_EF
        '
        Me.Txt_EF.Enabled = False
        Me.Txt_EF.EnterMoveNextControl = True
        Me.Txt_EF.Location = New System.Drawing.Point(227, 138)
        Me.Txt_EF.MenuManager = Me.BarManager1
        Me.Txt_EF.Name = "Txt_EF"
        Me.Txt_EF.Properties.MaxLength = 100
        Me.Txt_EF.Size = New System.Drawing.Size(437, 20)
        Me.Txt_EF.TabIndex = 3
        '
        'LabelControl9
        '
        Me.LabelControl9.Location = New System.Drawing.Point(156, 141)
        Me.LabelControl9.Name = "LabelControl9"
        Me.LabelControl9.Size = New System.Drawing.Size(65, 13)
        Me.LabelControl9.TabIndex = 33
        Me.LabelControl9.Text = "E Federativa:"
        '
        'PE_LogoEnteSecundario
        '
        Me.PE_LogoEnteSecundario.Enabled = False
        Me.PE_LogoEnteSecundario.Location = New System.Drawing.Point(36, 232)
        Me.PE_LogoEnteSecundario.MenuManager = Me.BarManager1
        Me.PE_LogoEnteSecundario.Name = "PE_LogoEnteSecundario"
        Me.PE_LogoEnteSecundario.Properties.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.PE_LogoEnteSecundario.Properties.Appearance.Options.UseBackColor = True
        Me.PE_LogoEnteSecundario.Properties.SizeMode = DevExpress.XtraEditors.Controls.PictureSizeMode.Squeeze
        Me.PE_LogoEnteSecundario.Size = New System.Drawing.Size(94, 94)
        Me.PE_LogoEnteSecundario.TabIndex = 40
        '
        'PictureBox2
        '
        Me.PictureBox2.Image = Global.Korima_Reporteador.My.Resources.Resources.Frame_Imagen_128
        Me.PictureBox2.Location = New System.Drawing.Point(21, 217)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(135, 125)
        Me.PictureBox2.TabIndex = 39
        Me.PictureBox2.TabStop = False
        '
        'LabelControl10
        '
        Me.LabelControl10.Location = New System.Drawing.Point(21, 198)
        Me.LabelControl10.Name = "LabelControl10"
        Me.LabelControl10.Size = New System.Drawing.Size(101, 13)
        Me.LabelControl10.TabIndex = 38
        Me.LabelControl10.Text = "Logotipo Secundario:"
        '
        'CtrlUsr_DatosEntidad
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.PE_LogoEnteSecundario)
        Me.Controls.Add(Me.PictureBox2)
        Me.Controls.Add(Me.LabelControl10)
        Me.Controls.Add(Me.Txt_EF)
        Me.Controls.Add(Me.LabelControl9)
        Me.Controls.Add(Me.Me_Texto)
        Me.Controls.Add(Me.LabelControl8)
        Me.Controls.Add(Me.Txt_Telefonos)
        Me.Controls.Add(Me.LabelControl7)
        Me.Controls.Add(Me.Txt_RFC)
        Me.Controls.Add(Me.LabelControl6)
        Me.Controls.Add(Me.Txt_Ciudad)
        Me.Controls.Add(Me.LabelControl5)
        Me.Controls.Add(Me.Txt_Domicilio)
        Me.Controls.Add(Me.LabelControl4)
        Me.Controls.Add(Me.Txt_ClaveSistema)
        Me.Controls.Add(Me.LabelControl3)
        Me.Controls.Add(Me.PE_LogoEnte)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.Txt_Nombre)
        Me.Controls.Add(Me.LabelControl2)
        Me.Controls.Add(Me.LabelControl1)
        Me.Controls.Add(Me.barDockControlLeft)
        Me.Controls.Add(Me.barDockControlRight)
        Me.Controls.Add(Me.barDockControlBottom)
        Me.Controls.Add(Me.barDockControlTop)
        Me.Name = "CtrlUsr_DatosEntidad"
        Me.Size = New System.Drawing.Size(677, 377)
        CType(Me.BarManager1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_Nombre.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PE_LogoEnte.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_ClaveSistema.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_Domicilio.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_Ciudad.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_RFC.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_Telefonos.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Me_Texto.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DxValidationProvider1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.Txt_EF.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PE_LogoEnteSecundario.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents BarManager1 As DevExpress.XtraBars.BarManager
    Friend WithEvents Bar2 As DevExpress.XtraBars.Bar
    Friend WithEvents ArchivoToolStripMenuItem As DevExpress.XtraBars.BarSubItem
    Friend WithEvents AbrirToolStripMenuItem As DevExpress.XtraBars.BarButtonItem
    Friend WithEvents GuardarToolStripMenuItem As DevExpress.XtraBars.BarButtonItem
    Friend WithEvents CancelarToolStripMenuItem As DevExpress.XtraBars.BarButtonItem
    Friend WithEvents CerrarToolStripMenuItem As DevExpress.XtraBars.BarButtonItem
    Friend WithEvents Bar3 As DevExpress.XtraBars.Bar
    Friend WithEvents barDockControlTop As DevExpress.XtraBars.BarDockControl
    Friend WithEvents barDockControlBottom As DevExpress.XtraBars.BarDockControl
    Friend WithEvents barDockControlLeft As DevExpress.XtraBars.BarDockControl
    Friend WithEvents barDockControlRight As DevExpress.XtraBars.BarDockControl
    Friend WithEvents PE_LogoEnte As DevExpress.XtraEditors.PictureEdit
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents Txt_Nombre As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl2 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents LabelControl1 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Me_Texto As DevExpress.XtraEditors.MemoEdit
    Friend WithEvents LabelControl8 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Txt_Telefonos As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl7 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Txt_RFC As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl6 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Txt_Ciudad As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl5 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Txt_Domicilio As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl4 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents Txt_ClaveSistema As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl3 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents DxValidationProvider1 As DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider
    Friend WithEvents Txt_EF As DevExpress.XtraEditors.TextEdit
    Friend WithEvents LabelControl9 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents PE_LogoEnteSecundario As DevExpress.XtraEditors.PictureEdit
    Friend WithEvents PictureBox2 As System.Windows.Forms.PictureBox
    Friend WithEvents LabelControl10 As DevExpress.XtraEditors.LabelControl

End Class
