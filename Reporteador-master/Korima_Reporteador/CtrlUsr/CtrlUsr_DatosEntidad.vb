Public Class CtrlUsr_DatosEntidad
    Dim CurrentId As Integer = 0

    Private Sub DATAControlLimpiaCampos()
        Txt_Nombre.Text = ""
        Txt_ClaveSistema.Text = ""
        Txt_Domicilio.Text = ""
        Txt_Ciudad.Text = ""
        Txt_EF.Text = ""
        Txt_RFC.Text = ""
        Txt_Telefonos.Text = ""
        Me_Texto.Text = ""
        PE_LogoEnte.Image = Nothing
        PE_LogoEnteSecundario.Image = Nothing
        '---Comun
        Dim ArrControles As New ArrayList(DxValidationProvider1.GetInvalidControls())
        For Each c In ArrControles
            DxValidationProvider1.RemoveControlError(c)
        Next
        'lblLastUpdate.Caption = "..."
        'lblLastUserName.Caption = "..."
    End Sub
    Private Sub GUIControl(Optional ByVal Nuevo As Boolean = False, Optional ByVal Abrir As Boolean = False, Optional ByVal Guardar As Boolean = False, Optional ByVal HabilitaAbrirEliminar As Boolean = False, Optional ByVal Cancelar As Boolean = False, Optional ByVal Reset As Boolean = False)
        '--- Controla el estado de los objetos en base a las acciones del registro
        If Nuevo = True Then
            DATAControlLimpiaCampos()

            '--- Act/Des Controles

            Txt_Nombre.Enabled = True
            Txt_ClaveSistema.Enabled = True
            Txt_Domicilio.Enabled = True
            Txt_Ciudad.Enabled = True
            Txt_EF.Enabled = True
            Txt_RFC.Enabled = True
            Txt_Telefonos.Enabled = True
            Me_Texto.Enabled = True
            PE_LogoEnte.Enabled = True
            PE_LogoEnteSecundario.Enabled = True
            '--- Menus: Principal
            ArchivoToolStripMenuItem.Enabled = True

            '--- Menus: Secundario
            AbrirToolStripMenuItem.Enabled = False
            GuardarToolStripMenuItem.Enabled = True
            CancelarToolStripMenuItem.Enabled = True
            CerrarToolStripMenuItem.Enabled = False


            '--- Enviar foco al control
            Txt_Nombre.Focus()

        ElseIf Abrir = True Then


            '--- Act/Des controles
            Txt_Nombre.Enabled = True
            Txt_ClaveSistema.Enabled = True
            Txt_Domicilio.Enabled = True
            Txt_Ciudad.Enabled = True
            Txt_EF.Enabled = True
            Txt_RFC.Enabled = True
            Txt_Telefonos.Enabled = True
            Me_Texto.Enabled = True
            PE_LogoEnte.Enabled = True
            PE_LogoEnteSecundario.Enabled = True
            '--- Menus: Principal
            ArchivoToolStripMenuItem.Enabled = True

            '--- Menus: Secundario
            AbrirToolStripMenuItem.Enabled = False
            GuardarToolStripMenuItem.Enabled = True
            CancelarToolStripMenuItem.Enabled = True
            CerrarToolStripMenuItem.Enabled = False

            '--- Enviar foco al control
            Txt_Nombre.Focus()
        ElseIf Guardar = True Then
            'DATAControlLimpiaCampos()

            '--- Act/Des controles
            Txt_Nombre.Enabled = False
            Txt_ClaveSistema.Enabled = False
            Txt_Domicilio.Enabled = False
            Txt_Ciudad.Enabled = False
            Txt_EF.Enabled = False
            Txt_RFC.Enabled = False
            Txt_Telefonos.Enabled = False
            Me_Texto.Enabled = False
            PE_LogoEnte.Enabled = False
            PE_LogoEnteSecundario.Enabled = False
            '--- Menus: Principal
            ArchivoToolStripMenuItem.Enabled = True

            '--- Menus: Secundario
            AbrirToolStripMenuItem.Enabled = True
            GuardarToolStripMenuItem.Enabled = False
            CancelarToolStripMenuItem.Enabled = False
            CerrarToolStripMenuItem.Enabled = True

            '--- Enviar foco al control

        ElseIf HabilitaAbrirEliminar = True Then
            AbrirToolStripMenuItem.Enabled = True
        ElseIf Cancelar = True Then
            'DATAControlLimpiaCampos()

            '--- Act/Des controles
            Txt_Nombre.Enabled = False
            Txt_ClaveSistema.Enabled = False
            Txt_Domicilio.Enabled = False
            Txt_Ciudad.Enabled = False
            Txt_EF.Enabled = False
            Txt_RFC.Enabled = False
            Txt_Telefonos.Enabled = False
            Me_Texto.Enabled = False
            PE_LogoEnte.Enabled = False
            PE_LogoEnteSecundario.Enabled = False
            '--- Menus: Principal
            ArchivoToolStripMenuItem.Enabled = True

            '--- Menus: Secundario
            AbrirToolStripMenuItem.Enabled = True
            GuardarToolStripMenuItem.Enabled = False
            CancelarToolStripMenuItem.Enabled = False
            CerrarToolStripMenuItem.Enabled = True

            '--- Enviar foco al control

        ElseIf Reset = True Then
            DATAControlLimpiaCampos()

            '--- Act/Des controles
            Txt_Nombre.Enabled = False
            Txt_ClaveSistema.Enabled = False
            Txt_Domicilio.Enabled = False
            Txt_Ciudad.Enabled = False
            Txt_EF.Enabled = False
            Txt_RFC.Enabled = False
            Txt_Telefonos.Enabled = False
            Me_Texto.Enabled = False
            PE_LogoEnte.Enabled = False
            PE_LogoEnteSecundario.Enabled = False
            '--- Menus: Principal
            ArchivoToolStripMenuItem.Enabled = True

            '--- Menus: Secundario
            AbrirToolStripMenuItem.Enabled = False
            GuardarToolStripMenuItem.Enabled = False
            CancelarToolStripMenuItem.Enabled = True
            CerrarToolStripMenuItem.Enabled = True

            '--- Enviar foco al control

        End If
    End Sub

    Private Sub CtrlUsr_DatosEntidad_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        AbrirToolStripMenuItem.PerformClick()
        CancelarToolStripMenuItem.PerformClick()
    End Sub

    

    Private Sub GuardarToolStripMenuItem_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles GuardarToolStripMenuItem.ItemClick
        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        If PE_LogoEnte.Image IsNot Nothing Then
            If DxValidationProvider1.Validate Then
                If CurrentId = 0 Then
                    ctrlRPTCFGDatosEntes.Nombre = Txt_Nombre.Text
                    ctrlRPTCFGDatosEntes.ClaveSistema = Txt_ClaveSistema.Text
                    ctrlRPTCFGDatosEntes.Domicilio = Txt_Domicilio.Text
                    ctrlRPTCFGDatosEntes.Ciudad = Txt_Ciudad.Text
                    ctrlRPTCFGDatosEntes.EntidadFederativa = Txt_EF.Text
                    ctrlRPTCFGDatosEntes.RFC = Txt_RFC.Text
                    ctrlRPTCFGDatosEntes.Telefonos = Txt_Telefonos.Text
                    ctrlRPTCFGDatosEntes.Texto = Me_Texto.Text
                    ctrlRPTCFGDatosEntes.LogoEnte = PE_LogoEnte.Image
                    ctrlRPTCFGDatosEntes.LogoKorima = My.Resources.Korima256
                    ctrlRPTCFGDatosEntes.LogoEnteSecundario = PE_LogoEnteSecundario.Image 'KAZB
                    ctrlRPTCFGDatosEntes.LastUpdate = Date.Now.ToString
                    ctrlRPTCFGDatosEntes.Add(ctrlRPTCFGDatosEntes, False)
                Else
                    ctrlRPTCFGDatosEntes.ID = CurrentId
                    ctrlRPTCFGDatosEntes.Nombre = Txt_Nombre.Text
                    ctrlRPTCFGDatosEntes.ClaveSistema = Txt_ClaveSistema.Text
                    ctrlRPTCFGDatosEntes.Domicilio = Txt_Domicilio.Text
                    ctrlRPTCFGDatosEntes.Ciudad = Txt_Ciudad.Text
                    ctrlRPTCFGDatosEntes.EntidadFederativa = Txt_EF.Text
                    ctrlRPTCFGDatosEntes.RFC = Txt_RFC.Text
                    ctrlRPTCFGDatosEntes.Telefonos = Txt_Telefonos.Text
                    ctrlRPTCFGDatosEntes.Texto = Me_Texto.Text
                    ctrlRPTCFGDatosEntes.LogoEnte = PE_LogoEnte.Image
                    ctrlRPTCFGDatosEntes.LogoKorima = My.Resources.Korima256
                    ctrlRPTCFGDatosEntes.LogoEnteSecundario = PE_LogoEnteSecundario.Image 'KAZB
                    ctrlRPTCFGDatosEntes.LastUpdate = Date.Now.ToString
                    ctrlRPTCFGDatosEntes.Upd(ctrlRPTCFGDatosEntes)
                End If
                GUIControl(, , True)
            End If
        Else
            MessageBox.Show("Debe  insertar una imagen", "Imagen", MessageBoxButtons.OK, MessageBoxIcon.Information)
            AbrirToolStripMenuItem.PerformClick()
            Exit Sub
        End If
        If MDI_Principal.val = "1" Then
            Application.Exit()

        End If
    End Sub

    Private Sub AbrirToolStripMenuItem_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles AbrirToolStripMenuItem.ItemClick
        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        GUIControl(, True)
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        CurrentId = pRPTCFGDatosEntes.ID
        Txt_Nombre.Text = pRPTCFGDatosEntes.Nombre
        Txt_ClaveSistema.Text = pRPTCFGDatosEntes.ClaveSistema
        Txt_Domicilio.Text = pRPTCFGDatosEntes.Domicilio
        Txt_Ciudad.Text = pRPTCFGDatosEntes.Ciudad
        Txt_EF.Text = pRPTCFGDatosEntes.EntidadFederativa
        Txt_RFC.Text = pRPTCFGDatosEntes.RFC
        Txt_Telefonos.Text = pRPTCFGDatosEntes.Telefonos
        Me_Texto.Text = pRPTCFGDatosEntes.Texto
        PE_LogoEnte.Image = pRPTCFGDatosEntes.LogoEnte
        PE_LogoEnteSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
    End Sub

    Private Sub CancelarToolStripMenuItem_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles CancelarToolStripMenuItem.ItemClick
        AbrirToolStripMenuItem.PerformClick()
        GUIControl(, , , , True)
    End Sub

    Private Sub LabelControl9_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LabelControl9.Click

    End Sub
End Class
