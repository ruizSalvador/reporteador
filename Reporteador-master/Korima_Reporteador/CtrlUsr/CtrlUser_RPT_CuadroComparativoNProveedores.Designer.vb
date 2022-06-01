<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CtrlUser_RPT_CuadroComparativoNProveedores
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
        Me.SplitContainerControl1 = New DevExpress.XtraEditors.SplitContainerControl()
        Me.btnExport = New DevExpress.XtraEditors.SimpleButton()
        Me.LabelControl1 = New DevExpress.XtraEditors.LabelControl()
        Me.FilterProv = New DevExpress.XtraEditors.LookUpEdit()
        Me.SimpleButton2 = New DevExpress.XtraEditors.SimpleButton()
        Me.LabelControl3 = New DevExpress.XtraEditors.LabelControl()
        Me.LabelControl4 = New DevExpress.XtraEditors.LabelControl()
        Me.SimpleButton1 = New DevExpress.XtraEditors.SimpleButton()
        Me.filterPeriodoDe = New DevExpress.XtraEditors.DateEdit()
        Me.FilterPeriodoAl = New DevExpress.XtraEditors.DateEdit()
        Me.gcData = New DevExpress.XtraGrid.GridControl()
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.ErrorProvider1 = New System.Windows.Forms.ErrorProvider(Me.components)
        CType(Me.SplitContainerControl1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainerControl1.SuspendLayout()
        CType(Me.FilterProv.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.filterPeriodoDe.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.filterPeriodoDe.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FilterPeriodoAl.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FilterPeriodoAl.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gcData, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ErrorProvider1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SplitContainerControl1
        '
        Me.SplitContainerControl1.CollapsePanel = DevExpress.XtraEditors.SplitCollapsePanel.Panel1
        Me.SplitContainerControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainerControl1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainerControl1.Name = "SplitContainerControl1"
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.btnExport)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.LabelControl1)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.FilterProv)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.SimpleButton2)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.LabelControl3)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.LabelControl4)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.SimpleButton1)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.filterPeriodoDe)
        Me.SplitContainerControl1.Panel1.Controls.Add(Me.FilterPeriodoAl)
        Me.SplitContainerControl1.Panel1.Text = "Panel1"
        Me.SplitContainerControl1.Panel2.Controls.Add(Me.gcData)
        Me.SplitContainerControl1.Panel2.Text = "Panel2"
        Me.SplitContainerControl1.Size = New System.Drawing.Size(752, 471)
        Me.SplitContainerControl1.SplitterPosition = 222
        Me.SplitContainerControl1.TabIndex = 4
        Me.SplitContainerControl1.Text = "SplitContainerControl1"
        '
        'btnExport
        '
        Me.btnExport.Location = New System.Drawing.Point(12, 186)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(200, 21)
        Me.btnExport.TabIndex = 29
        Me.btnExport.Text = "Exportar a Excel"
        '
        'LabelControl1
        '
        Me.LabelControl1.Location = New System.Drawing.Point(100, 59)
        Me.LabelControl1.Name = "LabelControl1"
        Me.LabelControl1.Size = New System.Drawing.Size(13, 13)
        Me.LabelControl1.TabIndex = 28
        Me.LabelControl1.Text = "Al:"
        Me.LabelControl1.Visible = False
        '
        'FilterProv
        '
        Me.FilterProv.Location = New System.Drawing.Point(12, 31)
        Me.FilterProv.Name = "FilterProv"
        Me.FilterProv.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.FilterProv.Properties.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("IdCotizacion", "IdCotizacion"), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("IdSolicitud", "IdSolicitud")})
        Me.FilterProv.Size = New System.Drawing.Size(170, 20)
        Me.FilterProv.TabIndex = 26
        '
        'SimpleButton2
        '
        Me.SimpleButton2.Image = Global.Korima_Reporteador.My.Resources.Resources.Delete_16x16
        Me.SimpleButton2.Location = New System.Drawing.Point(187, 31)
        Me.SimpleButton2.Name = "SimpleButton2"
        Me.SimpleButton2.Size = New System.Drawing.Size(25, 20)
        Me.SimpleButton2.TabIndex = 25
        Me.SimpleButton2.Text = "SimpleButton2"
        '
        'LabelControl3
        '
        Me.LabelControl3.Location = New System.Drawing.Point(12, 12)
        Me.LabelControl3.Name = "LabelControl3"
        Me.LabelControl3.Size = New System.Drawing.Size(53, 13)
        Me.LabelControl3.TabIndex = 23
        Me.LabelControl3.Text = "Cotización:"
        '
        'LabelControl4
        '
        Me.LabelControl4.Location = New System.Drawing.Point(15, 59)
        Me.LabelControl4.Name = "LabelControl4"
        Me.LabelControl4.Size = New System.Drawing.Size(50, 13)
        Me.LabelControl4.TabIndex = 3
        Me.LabelControl4.Text = "Fecha del:"
        Me.LabelControl4.Visible = False
        '
        'SimpleButton1
        '
        Me.SimpleButton1.Location = New System.Drawing.Point(12, 110)
        Me.SimpleButton1.Name = "SimpleButton1"
        Me.SimpleButton1.Size = New System.Drawing.Size(202, 21)
        Me.SimpleButton1.TabIndex = 2
        Me.SimpleButton1.Text = "Imprimir reporte"
        '
        'filterPeriodoDe
        '
        Me.filterPeriodoDe.EditValue = Nothing
        Me.filterPeriodoDe.Location = New System.Drawing.Point(12, 78)
        Me.filterPeriodoDe.Name = "filterPeriodoDe"
        Me.filterPeriodoDe.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.filterPeriodoDe.Properties.VistaTimeProperties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton()})
        Me.filterPeriodoDe.Size = New System.Drawing.Size(78, 20)
        Me.filterPeriodoDe.TabIndex = 6
        Me.filterPeriodoDe.Visible = False
        '
        'FilterPeriodoAl
        '
        Me.FilterPeriodoAl.EditValue = Nothing
        Me.FilterPeriodoAl.Location = New System.Drawing.Point(96, 78)
        Me.FilterPeriodoAl.Name = "FilterPeriodoAl"
        Me.FilterPeriodoAl.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.FilterPeriodoAl.Properties.VistaTimeProperties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton()})
        Me.FilterPeriodoAl.Size = New System.Drawing.Size(78, 20)
        Me.FilterPeriodoAl.TabIndex = 27
        Me.FilterPeriodoAl.Visible = False
        '
        'gcData
        '
        Me.gcData.Dock = System.Windows.Forms.DockStyle.Fill
        Me.gcData.ImeMode = System.Windows.Forms.ImeMode.[On]
        Me.gcData.Location = New System.Drawing.Point(0, 0)
        Me.gcData.MainView = Me.GridView1
        Me.gcData.Name = "gcData"
        Me.gcData.Size = New System.Drawing.Size(525, 471)
        Me.gcData.TabIndex = 0
        Me.gcData.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.GridControl = Me.gcData
        Me.GridView1.HorzScrollVisibility = DevExpress.XtraGrid.Views.Base.ScrollVisibility.Always
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsView.ColumnAutoWidth = False
        '
        'ErrorProvider1
        '
        Me.ErrorProvider1.ContainerControl = Me
        '
        'CtrlUser_RPT_CuadroComparativoNProveedores
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitContainerControl1)
        Me.Name = "CtrlUser_RPT_CuadroComparativoNProveedores"
        Me.Size = New System.Drawing.Size(752, 471)
        CType(Me.SplitContainerControl1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainerControl1.ResumeLayout(False)
        CType(Me.FilterProv.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.filterPeriodoDe.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.filterPeriodoDe.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FilterPeriodoAl.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FilterPeriodoAl.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gcData, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ErrorProvider1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SplitContainerControl1 As DevExpress.XtraEditors.SplitContainerControl
    Friend WithEvents SimpleButton1 As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents LabelControl4 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents ErrorProvider1 As System.Windows.Forms.ErrorProvider
    Friend WithEvents LabelControl3 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents SimpleButton2 As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents FilterProv As DevExpress.XtraEditors.LookUpEdit
    Friend WithEvents LabelControl1 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents filterPeriodoDe As DevExpress.XtraEditors.DateEdit
    Friend WithEvents FilterPeriodoAl As DevExpress.XtraEditors.DateEdit
    Friend WithEvents btnExport As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents gcData As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView

End Class
