Imports System.Data.SqlClient

Public Class MDI_Principal
    Dim IdUsuario As String = "Debug"
    'Dim bdd As String = "Korima_Pruebas"
    'Dim bdd As String = "KORIMAMUNICIPIO"
    'Dim bdd As String = "Korima_Pruebas"
    'Dim bdd As String = "CespteInicializacion"
    'Dim bdd As String = "FIARUM"
    'Dim bdd As String = "UNEME2020"
    'Dim bdd As String = "KorimaSGG"
    Dim bdd As String = "IECAN_PRODUCCION"
    'Dim bdd As String = "Korima_San_Miguel_Alto"
    'Dim bdd As String = "Korima_Municipio_Piedad"
    'Dim bdd As String = "Korima_TSJ"
    'Dim bdd As String = "KorimaNogales"
    'Dim bdd As String = "KorimaUPALT"


    'Dim server As String = "SRV-KORIMA\korima_2014"
    'Dim server As String = "LAPTOP-OC11LS61\SQLEXPRESS19"
    Dim server As String = "LAPTOP-OC11LS61\SQLEXPRESS17"
    'Dim server As String = "ARTURODEV\SQLEXPRESS01"
    'Dim server As String = "ARTURODEV\SQLEXPRESS02"
    'Dim server As String = "SRV-KORITEST\SQLEXPRESS14"
    'Dim server As String = "SRV-KORIMA\KORIMA_2014"
    'Dim server As String = "WIN-AUH6FIP79C3\KORIMA"
    'Dim server As String = "DESKTOP-QH8FRPG\SQLEXPRESS16"

    Dim user As String = "sa"
    Dim pass As String = "Kori$123"

    Public val As String = "0"
    Public strUsuario As String

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '---Versiones
        '1.0.0 - Se agregaron los 3 reportes iniciales
        lblVer.Caption = "Reportes Kórima Versión 2.30.1"
        '--- Asignación de Id de Usua.1o desde parametro en linea de comando
#If Not Debug Then
        If Environment.GetCommandLineArgs.Length > 1 Then
            IdUsuario = Environment.GetCommandLineArgs(1)
            server = Environment.GetCommandLineArgs(2)
            bdd = Environment.GetCommandLineArgs(3)
            user = Environment.GetCommandLineArgs(4)
            pass = Environment.GetCommandLineArgs(5)
            If Environment.GetCommandLineArgs.Length > 6 Then
                val = Environment.GetCommandLineArgs(6)
            Else
                val = "0"
            End If
        Else
            MsgBox("Parámetros incorrectos." + vbCr + "Inicie la aplicación desde el menú de Kórima.", MsgBoxStyle.Critical, "Kórima - Error de aplicación")
            Application.Exit()
        End If
        Bar2.OptionsBar.AllowQuickCustomization = False
#End If
        '---
        Cursor = Cursors.WaitCursor
        setConectionString(server, bdd, user, pass)

        MdlIdUsuario = IdUsuario

        LlenaStatuBar()
        '--
        Try
            tvMenu.Nodes.AddRange(getUserMenus(1073).ToArray())
            tvMenu.ShowNodeToolTips = True
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Critical, "Excepción al cargar los menús.")
            Application.Exit()
        End Try
        Cursor = Cursors.Default
        If val = "1" Then
            tvMenu.Visible = False
            LoadCtrlUser(New CtrlUsr_DatosEntidad, "Datos de la Entidad", , BarButtonItem5.Glyph)
        End If
    End Sub

    Private Sub LlenaStatuBar()
#If DEBUG Then
        TxtUser.Caption = "Usuario: " & IdUsuario
        strUsuario = IdUsuario
#Else
        Dim cmd As New SqlCommand("Select Login From C_Usuarios Where IdUsuario = " & IdUsuario, New SqlConnection(cnnString))
        cmd.Connection.Open()
        Dim reader = cmd.ExecuteScalar()
        cmd.Connection.Close()

        TxtUser.Caption = "Usuario: " & reader
        strUsuario = reader
#End If
    End Sub

    Private Sub BarButtonItem5_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem5.ItemClick
        LoadCtrlUser(New CtrlUsr_DatosEntidad, e.Item.Caption.Trim, , BarButtonItem5.Glyph)

    End Sub

    Private Sub LoadCtrlUser(ByVal CtrlForm As UserControl, ByVal NameControl As String, Optional ByVal Iconform As Icon = Nothing, Optional img As Image = Nothing)
        Me.Cursor = Cursors.WaitCursor
        '--- Creamos un nuevo Obj Formulario, y agregamos el control correspondiente
        Dim FormularioSecundario As Form = New Form
        FormularioSecundario.Tag = img
        '--- Agregar CtrlUser correspondiente
        CtrlForm.Dock = DockStyle.Fill
        FormularioSecundario.Controls.Add(CtrlForm)
        '--- Llamar formulario

        FormularioSecundario.MdiParent = Me
        FormularioSecundario.Text = NameControl.Replace("&", "")
        Application.DoEvents()
        FormularioSecundario.Icon = Iconform

        AddHandler FormularioSecundario.GotFocus, AddressOf frm_GotFocus
        FormularioSecundario.Show()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub frm_GotFocus(sender As Object, e As EventArgs)
        Dim frm As Form = sender
        MdluserCtrl = frm.Controls(0)
        Try
            Mdlrpt = MdluserCtrl.reporte
        Catch
        End Try
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem2.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraPartida, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem4.ItemClick
        MessageBox.Show("Kórima® " + DateTime.Now.Year.ToString + vbCr + _
                        vbCr + _
                        "Kórima® " + lblVer.Caption + ":" + vbCr + _
                        "Este programa esta protegido" + vbCr + _
                        "por Ley de Derechos de Autor", "Kórima® " + lblVer.Caption, MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button3)
    End Sub

#Region "botones sin uso"
    'Private Sub BarStaticItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
    '    Frm_PruebaReporte.Show()
    'End Sub

    Private Sub BarButtonItem6_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem6.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraPartida, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem7_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem7.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraProveedor, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem8_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem8.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraDependecia, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem9_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem9.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenComprasYServiciosDependecias, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem10_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem10.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenComprasYServiciosDependeciasYPartidas, e.Item.Caption.Trim)

    End Sub

    Private Sub BarButtonItem11_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem11.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraServicioDependenciaPartidaProveedor, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem12_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem12.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_OrdenesCompraServiciosProveedor, e.Item.Caption.Trim)

    End Sub

    Private Sub BarButtonItem13_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem13.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraServicioProveedorDetallado, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem14_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem14.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_LibroDiario, e.Item.Caption.Trim)
    End Sub

    Private Sub BarButtonItem15_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem15.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_LibroMayor, e.Item.Caption.Trim)
    End Sub

    'Private Sub BarButtonItem19_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem19.ItemClick
    '    LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion, e.Item.Caption.Trim)
    'End Sub

    'Private Sub BarButtonItem21_ItemClick_1(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem21.ItemClick
    '    LoadCtrlUser(New CtrlUser_RPT_Estado_De_Actividades, e.Item.Caption.Trim)
    'End Sub

    'Private Sub BarButtonItem20_ItemClick_1(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem20.ItemClick
    '    LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_Financiera, e.Item.Caption.Trim)
    'End Sub

    Private Sub BarButtonItem22_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem22.ItemClick
        LoadCtrlUser(New CtrlUser_RPT_Analiticodelactivo, e.Item.Caption.Trim)
    End Sub
#End Region

    Private Sub tvMenu_NodeMouseDoubleClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeNodeMouseClickEventArgs) Handles tvMenu.NodeMouseDoubleClick
        'If (TreeView1.SelectedNode.Level = 1) Or (TreeView1.SelectedNode.Level = 2) Thenes
        Select Case CInt(tvMenu.SelectedNode.Tag)
            Case 1075 '"Estado de situación financiera"
                'LoadCtrlUser(New CtrlUser_RPT_Formato_Espec_SP, tvMenu.SelectedNode.Text.Trim)
                'LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_Financiera, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraV1_1, tvMenu.SelectedNode.Text.Trim)
            Case 1076 '"Estado de actividades"
                LoadCtrlUser(New CtrlUser_RPT_Estado_De_Actividades_V2, tvMenu.SelectedNode.Text.Trim)
            Case 1077 '"Estado de Variaciones en la Hacienda Pública/Patrimonio"
                'LoadCtrlUser(New CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonio, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonioV2, tvMenu.SelectedNode.Text.Trim)
            Case 1078 '"Estado de Flujo de Efectivo"
                LoadCtrlUser(New CtrlUser_RPT_FlujoDeEfectivo, tvMenu.SelectedNode.Text.Trim)
            Case 1079 '"Analítico del activo"
                LoadCtrlUser(New CtrlUser_RPT_Analiticodelactivo, tvMenu.SelectedNode.Text.Trim)
            Case 1080 '"Analítico de la Deuda Pública"
                'LoadCtrlUser(New CtrlUser_RPT_AnaliticoDeLaDeuda, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_AnaliticoDeLaDeudaV2, tvMenu.SelectedNode.Text.Trim)
            Case 1081 '"Notas de desglose"
                LoadCtrlUser(New CtrlNota_IndiceDesgloseNotas, tvMenu.SelectedNode.Text.Trim)
            Case 1083 '"Efectivo y Equivalentes"
                LoadCtrlUser(New CtrlNotas_EE_FAE, tvMenu.SelectedNode.Text.Trim)
            Case 1084
                LoadCtrlUser(New CtrlNotas_EE_IF, tvMenu.SelectedNode.Text.Trim)
            Case 1085
                LoadCtrlUser(New CtrlNotas_dree_cpcporRecuperar, tvMenu.SelectedNode.Text.Trim)
            Case 1086
                LoadCtrlUser(New CtrlNotas_dreoe_dreeybsrv, tvMenu.SelectedNode.Text.Trim)
            Case 1087
                LoadCtrlUser(New CtrlNotas_BDToC_Inventarios, tvMenu.SelectedNode.Text.Trim)
            Case 1088
                LoadCtrlUser(New CtrlNotas_bdtc_almacen, tvMenu.SelectedNode.Text.Trim)
            Case 1089
                LoadCtrlUser(New CtrlNotas_if_fideicomisos, tvMenu.SelectedNode.Text.Trim)
            Case 1090
                LoadCtrlUser(New CtrlNotas_InvFinan_SPyAC, tvMenu.SelectedNode.Text.Trim)
            Case 1091
                LoadCtrlUser(New CtrlNotas_ESF_BMII_BMI, tvMenu.SelectedNode.Text.Trim)
            Case 1092
                LoadCtrlUser(New CtrlNotas_ESF_BMII_AID, tvMenu.SelectedNode.Text.Trim)
            Case 1093
                LoadCtrlUser(New CtrlNotas_ESF_ED_OA(1), tvMenu.SelectedNode.Text.Trim)
            Case 1094
                LoadCtrlUser(New CtrlNotas_ESF_ED_OA(2), tvMenu.SelectedNode.Text.Trim)
            Case 1096
                LoadCtrlUser(New CtrlNotas_ESF_CDP, tvMenu.SelectedNode.Text.Trim)
            Case 1097
                LoadCtrlUser(New CtrlNotas_ESF_ED_OA(3), tvMenu.SelectedNode.Text.Trim)
            Case 1098
                LoadCtrlUser(New CtrlNotas_ESF_PDO(1), tvMenu.SelectedNode.Text.Trim)
            Case 1100
                LoadCtrlUser(New CtrlNotas_ESF_PDO(2), tvMenu.SelectedNode.Text.Trim)
            Case 1101 '"Monto y procedencia de los recursos que modifican al patrimonio generado."
                LoadCtrlUser(New CtrlNotas_EVHPP_MPG_MPRMPG, tvMenu.SelectedNode.Text.Trim)
            Case 1103 '"Ingresos de Gestión."
                LoadCtrlUser(New CtrlNotas_EA_IG, tvMenu.SelectedNode.Text.Trim)
            Case 1104
                LoadCtrlUser(New CtrlNotas_OIB, tvMenu.SelectedNode.Text.Trim)
            Case 1105
                LoadCtrlUser(New CtrlNotas_EA_GOP, tvMenu.SelectedNode.Text.Trim)
            Case 1107 '"Efectivo y Equivalentes - Saldo Inicial y Final"
                LoadCtrlUser(New CtrlNota_EFE_SIF, tvMenu.SelectedNode.Text.Trim)
            Case 1108
                LoadCtrlUser(New CtrlNota_BMI_ARMSCSC, tvMenu.SelectedNode.Text.Trim)
            Case 1112 '"Balanza de comprobación"
                'LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion_V2, tvMenu.SelectedNode.Text.Trim)
            Case 1113 '"Libro Diario"
                LoadCtrlUser(New CtrlUser_RPT_LibroDiario, tvMenu.SelectedNode.Text.Trim)
            Case 1114 '"Libro mayor"
                LoadCtrlUser(New CtrlUser_RPT_LibroMayor, tvMenu.SelectedNode.Text.Trim)
            Case 1115
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayor, tvMenu.SelectedNode.Text.Trim)
            Case 1118
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_Rubro, tvMenu.SelectedNode.Text.Trim)
            Case 1119
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_Rubro_Tipo, tvMenu.SelectedNode.Text.Trim)
            Case 1120
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_Rubro_Tipo_Clase, tvMenu.SelectedNode.Text.Trim)
            Case 1121
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_Rubro_Tipo_Clase_Concepto, tvMenu.SelectedNode.Text.Trim)
            Case 1122
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_CE_Rubro_Tipo, tvMenu.SelectedNode.Text.Trim)
            Case 1123
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_CE_Rubro_Tipo_Clase, tvMenu.SelectedNode.Text.Trim)
            Case 1124
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_CE_Rubro_Tipo_Clase_Concepto, tvMenu.SelectedNode.Text.Trim)
            Case 1125
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_Concepto_FuenteFinanciamiento, tvMenu.SelectedNode.Text.Trim)
            Case 1127 '"Por Ramo"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(2, 2), tvMenu.SelectedNode.Text.Trim)
            Case 1128 '"Por Capítulo Gasto"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(6, 6), tvMenu.SelectedNode.Text.Trim)
            Case 1129 '"Por Clasificación Económica"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(4, 4), tvMenu.SelectedNode.Text.Trim)
            Case 1130 '"Por Clasificación Económica / Capítulo Gasto"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(9, 9), tvMenu.SelectedNode.Text.Trim)
            Case 1131 '"Por Clasificación Funcional"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(7, 7), tvMenu.SelectedNode.Text.Trim)
            Case 1132 '"Por Clasificación Funcional / Subfunción"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(8, 8), tvMenu.SelectedNode.Text.Trim)
            Case 1133 '"Ejercicio del Presupuesto Fuente Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(3, 3), tvMenu.SelectedNode.Text.Trim)
            Case 1134 '"Clasificación Geográfica"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(5, 5), tvMenu.SelectedNode.Text.Trim)
            Case 1135 '"Ejercicio del Presupuesto Clasificación General"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(1, 1), tvMenu.SelectedNode.Text.Trim)
            Case 1136 '"Por Partida / Fuente de Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(10, 10), tvMenu.SelectedNode.Text.Trim)
            Case 1138 '"Por Ramo / Unidad Responsable"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(1, 1), tvMenu.SelectedNode.Text.Trim)
            Case 1139 '"Por Ramo / Clasificación Económica"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(2, 2), tvMenu.SelectedNode.Text.Trim)
            Case 1140 '"Por Ramo / Clasificación Económica / Capítulo Gasto"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(3, 3), tvMenu.SelectedNode.Text.Trim)
            Case 1141 '"Por Ramo / Capítulo y Concepto Gasto"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(4, 4), tvMenu.SelectedNode.Text.Trim)
            Case 1142 '"Por Ramo / Clasificación Funcional / Subfunción"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(5, 5), tvMenu.SelectedNode.Text.Trim)
            Case 1143 '"Por Ramo / Unidad Responsable / Capítulo y Concepto Gasto"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(6, 6), tvMenu.SelectedNode.Text.Trim)
            Case 1144 '"Por Ramo / Programa"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(7, 7), tvMenu.SelectedNode.Text.Trim)
            Case 1145 '"Por Ramo / Unidad Responsable / Programa"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(8, 8), tvMenu.SelectedNode.Text.Trim)
            Case 1146 '"Por Ramo / Unidad Responsable / Programa / Objeto Gasto por Capítulo"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(13, 14), tvMenu.SelectedNode.Text.Trim)
            Case 1147 '"Por Ramo / Unidad Responsable / Programa / Actividad Institucional / Objeto Gasto 3N"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(27, 13), tvMenu.SelectedNode.Text.Trim)
            Case 1148 '"Por Ramo / Distribución Geográfica"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(9, 9), tvMenu.SelectedNode.Text.Trim)
            Case 1149 '"Por Ramo / Clasificación Económica / Distribución Geográfica"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(10, 10), tvMenu.SelectedNode.Text.Trim)
            Case 1150 '"Por Ramo / Unidad Responsable / Partida Genérica"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(11, 11), tvMenu.SelectedNode.Text.Trim)
            Case 1151 '"Por Ramo / Unidad Responsable / Partida Específica"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(12, 12), tvMenu.SelectedNode.Text.Trim)
            Case 1153 '"Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(1, 1), tvMenu.SelectedNode.Text.Trim)
            Case 1154 '"Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(2, 2), tvMenu.SelectedNode.Text.Trim)
            Case 1155 '"Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoV2(4, 4), tvMenu.SelectedNode.Text.Trim)
                'LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(3, 3), tvMenu.SelectedNode.Text.Trim)
            Case 1156 '"Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(4, 4), tvMenu.SelectedNode.Text.Trim)
            Case 1157 '"Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(5, 5), tvMenu.SelectedNode.Text.Trim)
            Case 1158 '"Ramo o Dependencia / Función / Programas y Proyectos de Inversión"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(6, 6), tvMenu.SelectedNode.Text.Trim)
            Case 1159 '"Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(7, 7), tvMenu.SelectedNode.Text.Trim)
            Case 1160 '"Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(8, 8), tvMenu.SelectedNode.Text.Trim)
            Case 1161 '"Ramo o Dependencia / Distribución Georgáfica / Programas y Proyectos de Inversión"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR(9, 9), tvMenu.SelectedNode.Text.Trim)
            Case 1163
                LoadCtrlUser(New CtrlNotas_RPT_CuentaEconomica, tvMenu.SelectedNode.Text.Trim)
            Case 1164
                LoadCtrlUser(New CtrlNotas_RPT_ClasificacionEconomica, tvMenu.SelectedNode.Text.Trim)
            Case 1165 'Plan de Cuentas
                LoadCtrlUser(New CtrlUser_RPT_PlanCuentas, tvMenu.SelectedNode.Text.Trim)
            Case 1168 '"OC/OS por unidad responsable"
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenComprasYServiciosDependecias, tvMenu.SelectedNode.Text.Trim)
            Case 1169 '"OC/OS por unidad responsable y partida"
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenComprasYServiciosDependeciasYPartidas, tvMenu.SelectedNode.Text.Trim)
            Case 1170 '"OC/OS por unidad responsable, partida y proveedor"
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraServicioDependenciaPartidaProveedor, tvMenu.SelectedNode.Text.Trim)
            Case 1171 '"OC/OS concentrado por proveedor"
                LoadCtrlUser(New CtrlUser_RPT_OrdenesCompraServiciosProveedor, tvMenu.SelectedNode.Text.Trim)
                'sustituido CtrlUser_RPT_Adquisiciones_OrdenCompraServicioProveedorDetallado
            Case 1172 '"OC/OS detallado por proveedor"
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraServicioProveedorDetalladoSinURDepartamento, tvMenu.SelectedNode.Text.Trim)
            Case 1173 '"OC/OS detallado por proveedor"
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_OrdenCompraServicioProveedorDetallado, tvMenu.SelectedNode.Text.Trim)
            Case 1181
                LoadCtrlUser(New CtrlNota_Indice_NotasdeMemoria, tvMenu.SelectedNode.Text.Trim)
            Case 1182
                LoadCtrlUser(New CtrlNotas_nm_contables, tvMenu.SelectedNode.Text.Trim)
            Case 1183
                LoadCtrlUser(New CtrlNotas_nm_presupuestarias, tvMenu.SelectedNode.Text.Trim)
            Case 1184
                LoadCtrlUser(New CtrlNota_IndiceNotasGestionAdmtva, tvMenu.SelectedNode.Text.Trim)
            Case 1185
                LoadCtrlUser(New CtrlNota_NOTAS_DE_GESTION_ADMTIVA, tvMenu.SelectedNode.Text.Trim)
                'Case 1191
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(1, 1), tvMenu.SelectedNode.Text.Trim)
                'Case 1192
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(2, 2), tvMenu.SelectedNode.Text.Trim)
                'Case 1193
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(3, 3), tvMenu.SelectedNode.Text.Trim)
                'Case 1194
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(4, 4), tvMenu.SelectedNode.Text.Trim)
                'Case 1195
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(5, 5), tvMenu.SelectedNode.Text.Trim)
                'Case 1196
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(6, 6), tvMenu.SelectedNode.Text.Trim)
                'Case 1197
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(7, 7), tvMenu.SelectedNode.Text.Trim)
                'Case 1198
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(8, 8), tvMenu.SelectedNode.Text.Trim)
                'Case 1199
                '    LoadCtrlUser(New CtrlUser_RPT_InforProgramComparativosEstadodelEjerciciodelPresupuestoEGR(9, 9), tvMenu.SelectedNode.Text.Trim)
            Case 1200
                LoadCtrlUser(New CtrlUser_RPT_IniciativaLeydeIngresos, tvMenu.SelectedNode.Text.Trim)
            Case 1201
                LoadCtrlUser(New CtrlUser_RPT_CalendarioPresupuestoEgresos, tvMenu.SelectedNode.Text.Trim)
            Case 1202
                LoadCtrlUser(New CtrlUser_RPT_FormatoProgramaRecursosOrdenGob, tvMenu.SelectedNode.Text.Trim)
            Case 1203
                LoadCtrlUser(New CtrlUser_RPT_CalendarioMensualIngresos, tvMenu.SelectedNode.Text.Trim)
            Case 1204
                LoadCtrlUser(New CtrlNotas_ESF_FEDGFR, tvMenu.SelectedNode.Text.Trim)
            Case 1205
                LoadCtrlUser(New CtrlUser_RPT_DifusionPresupuestoEgresos, tvMenu.SelectedNode.Text.Trim)
            Case 1206
                LoadCtrlUser(New CtrlUser_RPT_DifusionLeydeIngresos, tvMenu.SelectedNode.Text.Trim)
            Case 1207
                LoadCtrlUser(New CtrlNotas_FIOPoGFFed, tvMenu.SelectedNode.Text.Trim)
            Case 1209
                LoadCtrlUser(New CtrlUser_RPT_Conciliacion_MovimientosNoConciliados, tvMenu.SelectedNode.Text.Trim)
            Case 1210
                LoadCtrlUser(New CtrlUser_RPT_Conciliacion_MovimientosConciliados, tvMenu.SelectedNode.Text.Trim)
            Case 1214
                LoadCtrlUser(New CtrlUser_RPT_CataogoCuentasContablesTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1215
                LoadCtrlUser(New CtrlUser_RPT_MovimientosMensualesCuentasPublicasTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1216
                LoadCtrlUser(New CtrlUser_RPT_PresupuestoEgresosTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1217
                LoadCtrlUser(New CtrlUser_RPT_PronosticoIngresosTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1218
                LoadCtrlUser(New CtrlUser_RPT_EstadoOrigenTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1219
                LoadCtrlUser(New CtrlUser_RPT_ChequesTransferencias, tvMenu.SelectedNode.Text.Trim)
            Case 1220
                LoadCtrlUser(New CtrlNotas_RPT_Conciliacion_AhorroDesahorro, tvMenu.SelectedNode.Text.Trim)
            Case 1221
                LoadCtrlUser(New CtrlUser_RPT_CuentasBancariasProductivas, tvMenu.SelectedNode.Text.Trim)
            Case 1222
                LoadCtrlUser(New CtrlUser_RPT_AplicacionRecursosFORTAMUN, tvMenu.SelectedNode.Text.Trim)
            Case 1224
                LoadCtrlUser(New CtrlUser_RPT_SaldosPromedio, tvMenu.SelectedNode.Text.Trim)
            Case 1225
                LoadCtrlUser(New CtrlUser_RPT_Tarifario_Ingresos, tvMenu.SelectedNode.Text.Trim)
            Case 1226
                LoadCtrlUser(New CtrlNotas_IMP_AMSC(1), tvMenu.SelectedNode.Text.Trim)
            Case 1227
                LoadCtrlUser(New CtrlNotas_IMP_AMSC(2), tvMenu.SelectedNode.Text.Trim)
            Case 1228
                'LoadCtrlUser(New CtrlNotas_ASIBAAH, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_Libro_Inventario_AAH, tvMenu.SelectedNode.Text.Trim)
            Case 1229
                LoadCtrlUser(New CtrlUser_RPT_Libro_Inventario_BMI, tvMenu.SelectedNode.Text.Trim)
            Case 1230
                LoadCtrlUser(New CtrlUser_RPT_FacturasRecibidas, tvMenu.SelectedNode.Text.Trim)
            Case 1231
                LoadCtrlUser(New CtrlNotas_MPAS, tvMenu.SelectedNode.Text.Trim)
            Case 1232
                LoadCtrlUser(New CtrlUser_RPT_RelacionBienesPatrimonio, tvMenu.SelectedNode.Text.Trim)
            Case 1235
                LoadCtrlUser(New CtrlNotas_Personal_Licencia, tvMenu.SelectedNode.Text.Trim)
            Case 1236
                LoadCtrlUser(New CtrlNotas_Pagos_Retroactivos, tvMenu.SelectedNode.Text.Trim)
            Case 1237
                LoadCtrlUser(New CtrlNotas_Pagos_Dif_Costo_Plazas, tvMenu.SelectedNode.Text.Trim)
            Case 1238
                LoadCtrlUser(New CtrlNotas_Trabajadores_Comisionados, tvMenu.SelectedNode.Text.Trim)
            Case 1239
                LoadCtrlUser(New CtrlNotas_Trabajadores_Licencia, tvMenu.SelectedNode.Text.Trim)
            Case 1240
                LoadCtrlUser(New CtrlNotas_Trabajadores_Jubilados, tvMenu.SelectedNode.Text.Trim)
            Case 1241
                LoadCtrlUser(New CtrlNotas_Tabulador, tvMenu.SelectedNode.Text.Trim)
            Case 1242
                LoadCtrlUser(New CtrlUser_RPT_Analitico_Plazas, tvMenu.SelectedNode.Text.Trim)
            Case 1244
                LoadCtrlUser(New CtrlNotas_CCPD, tvMenu.SelectedNode.Text.Trim)
            Case 1245
                LoadCtrlUser(New CtrlNotas_PlazasExistentes, tvMenu.SelectedNode.Text.Trim)
            Case 1246
                LoadCtrlUser(New CtrlNotas_DifusionResultados, tvMenu.SelectedNode.Text.Trim)
            Case 1247
                LoadCtrlUser(New CtrlNotas_PersonalHonorarios, tvMenu.SelectedNode.Text.Trim)
            Case 1249
                LoadCtrlUser(New CtrlNotas_FETA_Personal_Comisionado, tvMenu.SelectedNode.Text.Trim)
            Case 1250
                LoadCtrlUser(New CtrlNotas_FETA_Pagos_Retroactivos, tvMenu.SelectedNode.Text.Trim)
            Case 1251
                LoadCtrlUser(New CtrlNotas_FETA_Personal_con_Licencia, tvMenu.SelectedNode.Text.Trim)
            Case 1252
                LoadCtrlUser(New CtrlNotas_FETA_Plaza_Funcion, tvMenu.SelectedNode.Text.Trim)
            Case 1253
                LoadCtrlUser(New CtrlNotas_FETA_Movimiento_de_Personal, tvMenu.SelectedNode.Text.Trim)
            Case 1254
                LoadCtrlUser(New CtrlNotas_FETA_Trabajadores_Jubilados, tvMenu.SelectedNode.Text.Trim)
            Case 1255
                LoadCtrlUser(New CtrlNotas_FETA_Licencia_Prejubilatoria, tvMenu.SelectedNode.Text.Trim)
            Case 1256
                LoadCtrlUser(New CtrlNotas_FETA_Trabajadores_por_Honorarios, tvMenu.SelectedNode.Text.Trim)
            Case 1257
                LoadCtrlUser(New CtrlNotas_FETA_Analitico_Categorias, tvMenu.SelectedNode.Text.Trim)
            Case 1258
                LoadCtrlUser(New CtrlNotas_FETA_Categorias_Tabuladores, tvMenu.SelectedNode.Text.Trim)
            Case 1259
                LoadCtrlUser(New CtrlNotas_FETA_Percepciones_Deducciones, tvMenu.SelectedNode.Text.Trim)
            Case 1260
                LoadCtrlUser(New CtrlNotas_FETA_Formato_Incorrecto, tvMenu.SelectedNode.Text.Trim)
            Case 1261
                LoadCtrlUser(New CtrlNotas_FETA_Doble_Asignacion, tvMenu.SelectedNode.Text.Trim)
            Case 1262
                LoadCtrlUser(New CtrlNotas_FETA_Horas_Superadas, tvMenu.SelectedNode.Text.Trim)
            Case 1263
                LoadCtrlUser(New CtrlNotas_FETA_Salario_Superior, tvMenu.SelectedNode.Text.Trim)
            Case 1265
                LoadCtrlUser(New CtrlUser_RPT_Proveedores, tvMenu.SelectedNode.Text.Trim)
            Case 1266
                LoadCtrlUser(New CtrlUser_RPT_Productos, tvMenu.SelectedNode.Text.Trim)
            Case 1267
                LoadCtrlUser(New CtrlUser_RPT_Empleados, tvMenu.SelectedNode.Text.Trim)
            Case 1268
                LoadCtrlUser(New CtrlUser_RPT_Proyecto_Presupuesto, tvMenu.SelectedNode.Text.Trim)
            Case 1269
                LoadCtrlUser(New CtrlUser_RPT_EstadoEjercicioIngresos_FuenteFinanciamiento, tvMenu.SelectedNode.Text.Trim)
            Case 1270
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraV2, tvMenu.SelectedNode.Text.Trim)
            Case 1272
                LoadCtrlUser(New CtrlUser_RPT_Formato_Gral_SP, tvMenu.SelectedNode.Text.Trim)
            Case 1273
                LoadCtrlUser(New CtrlUser_RPT_Formato_Espec_SP, tvMenu.SelectedNode.Text.Trim)
                'Case 1277
                'LoadCtrlUser(New CtrlUser_RPT_GastosDepartamento, tvMenu.SelectedNode.Text.Trim)
            Case 1277
                LoadCtrlUser(New CtrlUser_RPT_ClasificacionDeptoObjetoGasto(6, 6), tvMenu.SelectedNode.Text.Trim)
            Case 1278
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayorCvePres, tvMenu.SelectedNode.Text.Trim)
            Case 1280
                LoadCtrlUser(New CtrlUser_RPT_CuentasPorPagar, tvMenu.SelectedNode.Text.Trim)
            Case 1281
                LoadCtrlUser(New CtrlUser_RPT_CatalogoServicios, tvMenu.SelectedNode.Text.Trim)
            Case 1282
                LoadCtrlUser(New CtrlUser_RPT_AuxiliarPresupuestal, tvMenu.SelectedNode.Text.Trim)
            Case 1283
                LoadCtrlUser(New CtrlUser_RPT_FAIS, tvMenu.SelectedNode.Text.Trim)
            Case 1286
                LoadCtrlUser(New CtrlUser_RPT_ExistenciasAlmacen, tvMenu.SelectedNode.Text.Trim)
            Case 1288
                LoadCtrlUser(New CtrlUser_RPT_Ingresos, tvMenu.SelectedNode.Text.Trim)
            Case 1289
                LoadCtrlUser(New CtrlUser_RPT_EgresosClasificacionAdministrativaPoder, tvMenu.SelectedNode.Text.Trim)
            Case 1290
                LoadCtrlUser(New CtrlUser_RPT_EgresosClasificacionAdministrativaParaestatal, tvMenu.SelectedNode.Text.Trim)
            Case 1291
                LoadCtrlUser(New CtrlNotaInformePasivosContingentes, tvMenu.SelectedNode.Text.Trim)
            Case 1293
                LoadCtrlUser(New CtrlUser_RPT_ConciliacionIngresos, tvMenu.SelectedNode.Text.Trim)
            Case 1294
                LoadCtrlUser(New CtrlUser_RPT_ConciliacionEgresos, tvMenu.SelectedNode.Text.Trim)
            Case 1296
                LoadCtrlUser(New CtrlUser_RPT_IndicadoresPosturaFiscal, tvMenu.SelectedNode.Text.Trim)
            Case 1297
                LoadCtrlUser(New CtrlUser_RPT_InteresesDeuda, tvMenu.SelectedNode.Text.Trim)
            Case 1298
                LoadCtrlUser(New CtrlUser_RPT_EndeudamientoNeto, tvMenu.SelectedNode.Text.Trim)
            Case 1306
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuesto4Niveles, tvMenu.SelectedNode.Text.Trim)
            Case 1307
                LoadCtrlUser(New CtrlUser_RPT_DIOT, tvMenu.SelectedNode.Text.Trim)
            Case 1309
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion_Acumulada, tvMenu.SelectedNode.Text.Trim)
            Case 1310
                LoadCtrlUser(New CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonioPorRangoV2, tvMenu.SelectedNode.Text.Trim)
            Case 1311
                LoadCtrlUser(New CtrlUser_RPT_AnaliticodelactivoPorRango, tvMenu.SelectedNode.Text.Trim)
            Case 1312
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraRango, tvMenu.SelectedNode.Text.Trim)
            Case 1313
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral2, tvMenu.SelectedNode.Text.Trim)
            Case 1314 '"Analítico de la Deuda Pública Por Periodo"
                LoadCtrlUser(New CtrlUser_RPT_AnaliticoDeLaDeudaPorPeriodo, tvMenu.SelectedNode.Text.Trim)
            Case 1315 '"Consulta Estado  del Ejercicio - Egresos"
                LoadCtrlUser(New CtrlUser_RPT_ConsultaEstadodelEjerciciodelPresupuesto(1, 1), tvMenu.SelectedNode.Text.Trim)
            Case 1316 '"Catalogo Proveedores con Cuenta Contable"
                LoadCtrlUser(New CtrlUser_RPT_Proveedores2, tvMenu.SelectedNode.Text.Trim)
            Case 1317 '"Catalogo Proveedores con Importes Pagados"
                LoadCtrlUser(New CtrlUser_RPT_OrdenesCompraServiciosProveedor2, tvMenu.SelectedNode.Text.Trim)
            Case 1318 '"Relaciones Analíticas"
                LoadCtrlUser(New CtrlUser_RPT_RelacionesAnaliticas, tvMenu.SelectedNode.Text.Trim)
            Case 1319 '"Presupuesto Ingresos Concentrado"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral4(1, 1), tvMenu.SelectedNode.Text.Trim)
            Case 1320 '"Control Presupuestal"
                LoadCtrlUser(New CtrlUser_RPT_ControlPresupuestal, tvMenu.SelectedNode.Text.Trim)
            Case 1322 '"Analitico de la Deuda Rep. Fed."
                LoadCtrlUser(New CtrlUser_RPT_AnaliticoDeLaDeudaRepFed, tvMenu.SelectedNode.Text.Trim)
            Case 1323 '"Analítico del Activo Rep. Fed."
                LoadCtrlUser(New CtrlUser_RPT_AnaliticodelactivoPorRangoRepFed, tvMenu.SelectedNode.Text.Trim)
            Case 1324 '"Por Partida / Fuente de Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral(11, 11), tvMenu.SelectedNode.Text.Trim)
            Case 1325 '"Control Presupuestal del Ingreso"
                LoadCtrlUser(New CtrlUser_RPT_ControlPresupuestalIngreso, tvMenu.SelectedNode.Text.Trim)
            Case 1326 '"Tarifario Ingresos Usuario"
                LoadCtrlUser(New CtrlUser_RPT_Tarifario_IngresosUsuario, tvMenu.SelectedNode.Text.Trim)
            Case 1327 '"Ingresos Por CRI Tarifario"
                LoadCtrlUser(New CtrlUser_RPT_CriTarifario, tvMenu.SelectedNode.Text.Trim)
            Case 1328 '"Estado de Actividades"
                LoadCtrlUser(New CtrlUser_RPT_EstadodeActividadesHorizontal, tvMenu.SelectedNode.Text.Trim)
            Case 1329 '"Flujo Efectivo Horizontal"
                LoadCtrlUser(New CtrlUser_RPT_FlujoDeEfectivoHorizontal, tvMenu.SelectedNode.Text.Trim)
            Case 1330 '"Punto Recaudación Tarifario"
                LoadCtrlUser(New CtrlUser_RPT_PuntoRecaudacionTarifario, tvMenu.SelectedNode.Text.Trim)
            Case 1332 '"Estado de Actividades Analítico"
                LoadCtrlUser(New CtrlUser_RPT_Estado_De_ActividadesAnalitico, tvMenu.SelectedNode.Text.Trim)
            Case 1333 '"Archivo Catálogo Balanza TXT"
                LoadCtrlUser(New CtrlUser_RPT_CatalogoBalanzaTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1334 '"Archivo Egresos Trimestral TXT"
                LoadCtrlUser(New CtrlUser_RPT_EgresosTrimestralTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1335 '"Archivo Ingresos Trimestral TXT"
                LoadCtrlUser(New CtrlUser_RPT_IngresosTrimestralTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1336 '"Información Programática Presupuestal TXT"
                LoadCtrlUser(New CtrlUser_RPT_InformacionProgramaticaPresupuestalTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1337 '"Estado Analítico del Pasivo"
                LoadCtrlUser(New CtrlUser_RPT_AnaliticodelPasivo, tvMenu.SelectedNode.Text.Trim)
            Case 1338 '"Polizas Descuadre"
                LoadCtrlUser(New CtrlUser_RPT_PolizasDeCuadre, tvMenu.SelectedNode.Text.Trim)
            Case 1340 '"Estado de Situación Financiera Rep. Fed."
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraV1_1RepFed, tvMenu.SelectedNode.Text.Trim)
            Case 1341 '"Estado Variación Hacienda Pública Rep. Fed."
                LoadCtrlUser(New CtrlUser_RPT_VariacionesHaciendaPublicaPatrimonioRepFed, tvMenu.SelectedNode.Text.Trim)
            Case 1342 '"Estado Analítico del Activo Rango Rep. Fed."
                LoadCtrlUser(New CtrlUser_RPT_Estado_Cambio_Situacion_FinancieraRepFed, tvMenu.SelectedNode.Text.Trim)
            Case 1343 '"Cheques y Transferencias Electronicas XML"
                LoadCtrlUser(New CtrlUser_RPT_ChequesTransferenciasAudSup, tvMenu.SelectedNode.Text.Trim)
            Case 1344 '"Balanza de Comprobación TXT"
                LoadCtrlUser(New CtrlUser_RPT_BalanzaComprobacionTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1345 '"Información Programática Presupuestal TXT"
                LoadCtrlUser(New CtrlUser_RPT_InformacionProgramaticaPresupuestalAnualTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1346 '"Ingresos Anual TXT"
                LoadCtrlUser(New CtrlUser_RPT_IngresosAnualTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1347 '"Concentrado Gastos Partida Dep TXT"
                LoadCtrlUser(New CtrlUser_RPT_ConcentradoGastosPartidaDepTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1349 '"Información Programática Presupuestal TXT"
                LoadCtrlUser(New CtrlUser_RPT_Libro_Inventario_RepKor, tvMenu.SelectedNode.Text.Trim)
            Case 1350 '"Programas y Proyectos de Inversión"
                LoadCtrlUser(New CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresProgProyecto(10, 10), tvMenu.SelectedNode.Text.Trim)
            Case 1351 '"Estado de Situación Financiera"
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraV1_1Periodos, tvMenu.SelectedNode.Text.Trim)
            Case 1352 '"Polizas Fuente Financiamiento"
                LoadCtrlUser(New CtrlUser_RPT_PolizasFuenteFinanciamiento, tvMenu.SelectedNode.Text.Trim)
            Case 1353 '"Catálogo Matrices de Conversíon"
                LoadCtrlUser(New CtrlUser_RPT_CatalogoMatricesConversion, tvMenu.SelectedNode.Text.Trim)
            Case 1354 '"Movimientos Contables"
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayorMovimientos, tvMenu.SelectedNode.Text.Trim)
            Case 1355 '"Características Activo Fijo"
                LoadCtrlUser(New CtrlUser_RPT_CaracteristicasActivoFijo, tvMenu.SelectedNode.Text.Trim)
            Case 1356 '"Polizas Descuadradas"
                LoadCtrlUser(New CtrlUser_RPT_PolizasDescuadradasTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1357 '"Reporte Calendarizado Presupuestal"
                LoadCtrlUser(New CtrlUser_RPT_ReporteCalendarizadoPresupuestal, tvMenu.SelectedNode.Text.Trim)
            Case 1358 '"Reporte Calendarizado Presupuestal Por Sello"
                LoadCtrlUser(New CtrlUser_RPT_ReporteCalendarizadoPresupuestalPorSello, tvMenu.SelectedNode.Text.Trim)
            Case 1359 '"Gastos X Comprobar-Fondos Revolventes"
                LoadCtrlUser(New CtrlUser_RPT_GastosXComprobarFondos, tvMenu.SelectedNode.Text.Trim)
            Case 1360 '"Nóminas"
                LoadCtrlUser(New CtrlUser_RPT_Nominas, tvMenu.SelectedNode.Text.Trim)
            Case 1361 '"IngresosXRecaudar"
                LoadCtrlUser(New CtrlUser_RPT_IngresosPorRecaudar, tvMenu.SelectedNode.Text.Trim)
            Case 1362 '"IngresosRecaudados"
                LoadCtrlUser(New CtrlUser_RPT_IngresosRecaudados, tvMenu.SelectedNode.Text.Trim)
            Case 1363 '"Analítico por Proveedor Contable"
                LoadCtrlUser(New CtrlUser_RPT_AnaliticoPorProveedorContable, tvMenu.SelectedNode.Text.Trim)
            Case 1364 '"Conciliación  Bancaria"
                LoadCtrlUser(New CtrlUser_RPT_ConciliacionBancaria, tvMenu.SelectedNode.Text.Trim)
            Case 1365 '"Transferencias Presupuestales"
                LoadCtrlUser(New CtrlUser_RPT_TransferenciasPresupuestales, tvMenu.SelectedNode.Text.Trim)
            Case 1373 '"Reportes FONE Plaza/Función"
                LoadCtrlUser(New CtrlUser_RPT_Plaza_Función, tvMenu.SelectedNode.Text.Trim)
            Case 1374 '"Reportes FONE Retroactivos mayor 45 días"
                LoadCtrlUser(New CtrlUser_RPT_PagosRetroactivos, tvMenu.SelectedNode.Text.Trim)
            Case 1375 '"Reportes FONE Movimiento de Plazas"
                LoadCtrlUser(New CtrlUser_RPT_MovimientosPlazas, tvMenu.SelectedNode.Text.Trim)
            Case 1376 '"Reportes FONE Catálogo Percepciones Deducciones"
                LoadCtrlUser(New CtrlUser_RPT_CatalogoPercDeduc, tvMenu.SelectedNode.Text.Trim)
            Case 1377 '"Reportes FOONE Personal Federalizado por Rfc"
                LoadCtrlUser(New CtrlUser_RPT_PersonalFederalizadoXRfc, tvMenu.SelectedNode.Text.Trim)
            Case 1378 '"Reportes FOONE Jubilados en el Periodo"
                LoadCtrlUser(New CtrlUser_RPT_JubiladosPeriodo, tvMenu.SelectedNode.Text.Trim)
            Case 1379 '"Reportes FOONE Categorías Plazas Autorizadas"
                LoadCtrlUser(New CtrlUser_RPT_CategoriasPlazasAutorizadas, tvMenu.SelectedNode.Text.Trim)
            Case 1380 '"Reportes FOONE Categorías Tabuladores"
                LoadCtrlUser(New CtrlUser_RPT_CategoriasTabuladores, tvMenu.SelectedNode.Text.Trim)
            Case 1381 '"Reportes FOONE Personal con Licencia"
                LoadCtrlUser(New CtrlUser_RPT_PersonalConLicencia, tvMenu.SelectedNode.Text.Trim)
            Case 1382 '"Reportes FOONE Licencia Prejubilatoria"
                LoadCtrlUser(New CtrlUser_RPT_LicenciaPrejubilatoria, tvMenu.SelectedNode.Text.Trim)
            Case 1383 '"Reportes FOONE Personal Comisionado"
                LoadCtrlUser(New CtrlUser_RPT_PersonalComisionado, tvMenu.SelectedNode.Text.Trim)
            Case 1384 '"Reportes FOONE RFC Formato Incorrecto"
                LoadCtrlUser(New CtrlUser_RPT_RfcCurpFormatoIncorrecto, tvMenu.SelectedNode.Text.Trim)
            Case 1385 '"Impresión de Pólizas"
                LoadCtrlUser(New CtrlUser_RPT_ImpresionPolizas, tvMenu.SelectedNode.Text.Trim)
            Case 1386 '"Contrarecibo Múltiples Facturas"
                LoadCtrlUser(New CtrlUser_RPT_ContrareciboMultiplesFacturas, tvMenu.SelectedNode.Text.Trim)
            Case 1387 '"Contrarecibo Cuadro Comparativo"
                LoadCtrlUser(New CtrlUser_RPT_CuadroComparativo, tvMenu.SelectedNode.Text.Trim)
            Case 1388 '"Flujo de Efectivo Detallado"
                LoadCtrlUser(New CtrlUser_RPT_FlujoDeEfectivoDetallado, tvMenu.SelectedNode.Text.Trim)
            Case 1389 '"Reporte Orden de Compra"
                LoadCtrlUser(New CtrlUser_RPT_OrdenCompra, tvMenu.SelectedNode.Text.Trim)
            Case 1390 '"Reporte Orden de Servicio"
                LoadCtrlUser(New CtrlUser_RPT_OrdenServicio, tvMenu.SelectedNode.Text.Trim)
            Case 1396 '"Reporte Analítico Pasivo por Periodos"
                LoadCtrlUser(New CtrlUser_RPT_AnaliticodelPasivoPeriodos, tvMenu.SelectedNode.Text.Trim)
            Case 1397 '"Existencias con Mínimos y Máximos"
                LoadCtrlUser(New CtrlUser_RPT_ExistenciasMinimosMaximos, tvMenu.SelectedNode.Text.Trim)
            Case 1398 '"Reprote Últimos Costos"
                LoadCtrlUser(New CtrlUser_RPT_UltimosCostos, tvMenu.SelectedNode.Text.Trim)
            Case 1399 '"Entradas/Salidas de Almacén"
                LoadCtrlUser(New CtrlUser_RPT_EntradasSalidasAlmacen, tvMenu.SelectedNode.Text.Trim)
            Case 1401 '"Relación de Bienes Muebles e Inmuebles Filtrado"
                LoadCtrlUser(New CtrlUser_RPT_RelacionBienesPatrimonioFiltrado, tvMenu.SelectedNode.Text.Trim)
            Case 1403 '"Consulta de Viáticos"
                LoadCtrlUser(New CtrlUser_RPT_ConsultaDeViaticos, tvMenu.SelectedNode.Text.Trim)
            Case 1406 '"Estado de Situación Financiera Detallado LDF"
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraDetallado, tvMenu.SelectedNode.Text.Trim)
            Case 1407 '"Informe Analitico de la Deuda Pública y Otros Pasivos - LDF"
                LoadCtrlUser(New CtrlUser_RPT_AnaliticoDeLaDeudaPorPeriodoLDF, tvMenu.SelectedNode.Text.Trim)
            Case 1408 '"Informe Analitico de Obligaciones Diferentes de Financiamientos LDF"
                LoadCtrlUser(New CtrlUser_RPT_InformeAnaliticoOblDifFinEdit, tvMenu.SelectedNode.Text.Trim)
            Case 1409 '"Balance Presupuestario LDF"
                LoadCtrlUser(New CtrlUser_RPT_BalancePres3, tvMenu.SelectedNode.Text.Trim)
                'Case 1410 '"Analítico de Ingresos LDF"
                '    LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_IngresoDetallado, tvMenu.SelectedNode.Text.Trim)
            Case 1410 '"Analítico de Ingresos LDF"
                LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_Ingresos_Detallado_LDF, tvMenu.SelectedNode.Text.Trim)
            Case 1411 '"Clasificacion por Objeto del Gasto(Capitulo y Concepto) LDF"
                LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_ClasificacionporObjetodeGasto(6, 6), tvMenu.SelectedNode.Text.Trim)
            Case 1412 '"Clasificacion Administrativa LDF"
                'LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_Clasificacion_Administrativa, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_ClasificacionporObjetodeGasto(2, 2), tvMenu.SelectedNode.Text.Trim)

            Case 1413 '"Clasificación Funcional(Finalidad y Funcion) LDF"
                'LoadCtrlUser(New CtrlUser_RPT_LDF_Clasificacion_Funcional, tvMenu.SelectedNode.Text.Trim)
                LoadCtrlUser(New CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_ClasificacionporObjetodeGasto(7, 7), tvMenu.SelectedNode.Text.Trim)

            Case 1414 '"Clasificacion de servicios Personales por Categoria LDF"
                LoadCtrlUser(New CtrlUser_RPT_ClasificacionServiciosPresCat, tvMenu.SelectedNode.Text.Trim)
            Case 1415 '"Proyecciones de Ingresos LDF"
                LoadCtrlUser(New CtrlUser_RPT_Proyecciones_IngresosLDF2, tvMenu.SelectedNode.Text.Trim)
            Case 1416 '"Proyecciones de Egresos LDF"
                LoadCtrlUser(New CtrlUser_RPT_ProyeccionesEgresosLDF, tvMenu.SelectedNode.Text.Trim)
            Case 1417 '"Resultado Ingresos LDF"
                LoadCtrlUser(New CtrlUser_RPT_Resultados_IngresosLDF, tvMenu.SelectedNode.Text.Trim)
            Case 1418 '"Resultado Egresos LDF"
                LoadCtrlUser(New CtrlUser_RPT_Resultados_EgresosLDF, tvMenu.SelectedNode.Text.Trim)
            Case 1419 '"Informe sobre Estudio de Actuarias LDF"
                LoadCtrlUser(New CtrlUser_RPT_InformeEstudiosActuarialesLDF, tvMenu.SelectedNode.Text.Trim)
            Case 1421 '"Layout Ingresos"
                LoadCtrlUser(New CtrlUser_RPT_Layout_Ingresos, tvMenu.SelectedNode.Text.Trim)
            Case 1422 '"Layout Egresos"
                LoadCtrlUser(New CtrlUser_RPT_Layout_Egresos, tvMenu.SelectedNode.Text.Trim)
            Case 1423 '"Transferencias"
                LoadCtrlUser(New CtrlUser_RPT_Transferencias, tvMenu.SelectedNode.Text.Trim)
            Case 1424 '"Requisiciones de Servicios"
                LoadCtrlUser(New CtrlUser_RPT_RequisicionesDeServicios, tvMenu.SelectedNode.Text.Trim)
            Case 1425 '"Órdenes de Servicios Detalle"
                LoadCtrlUser(New CtrlUser_RPT_OrdenesServicioDetalle, tvMenu.SelectedNode.Text.Trim)
            Case 1426 '"Cuentas de Gasto por Factura"
                LoadCtrlUser(New CtrlUser_RPT_CuentasGastoFacturas, tvMenu.SelectedNode.Text.Trim)
            Case 1427 '"Reporte de Solicitudes de Pago"
                LoadCtrlUser(New CtrlUser_RPT_SolicitudesPago, tvMenu.SelectedNode.Text.Trim)
            Case 1428 '"Reporte de Balanza Txt"
                LoadCtrlUser(New CtrlUser_RPT_BalanzaTXT, tvMenu.SelectedNode.Text.Trim)
            Case 1429 '"Cuadro Comparativo nProveedores"
                LoadCtrlUser(New CtrlUser_RPT_CuadroComparativoNProveedores, tvMenu.SelectedNode.Text.Trim)
            Case 1430 '"Por Ramo / Unidad Responsable / Partida Específica Concentrado"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(15, 15), tvMenu.SelectedNode.Text.Trim)
            Case 1431 '"Por Ramo / Unidad Responsable / Partida Genérica Concentrado"
                LoadCtrlUser(New CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR(16, 16), tvMenu.SelectedNode.Text.Trim)
            Case 1432 '"Estado de Situación Financiera Analítico"
                LoadCtrlUser(New CtrlUser_RPT_Estado_Situacion_FinancieraAnalitico, tvMenu.SelectedNode.Text.Trim)
            Case 1433 '"CuentasBancarias"
                LoadCtrlUser(New CtrlUser_RPT_CuentasBancarias, tvMenu.SelectedNode.Text.Trim)
            Case 1434 '"Estado de Actividades Analitico Detallado"
                LoadCtrlUser(New CtrlUser_RPT_Estado_De_Actividades_Detallado, tvMenu.SelectedNode.Text.Trim)
            Case 1435 '"Reporte Comprobacion de Gastos"
                LoadCtrlUser(New CtrlUser_RPT_ComprobacionDeGastos, tvMenu.SelectedNode.Text.Trim)
            Case 1436
                LoadCtrlUser(New CtrlUser_RPT_AplicacionRecursosFORTAMUN_Detallado, tvMenu.SelectedNode.Text.Trim)
            Case 1437
                LoadCtrlUser(New CtrlUser_RPT_EstadodelEjerciciodelPresupuesto4NivelesRepKorima, tvMenu.SelectedNode.Text.Trim)
            Case 1438
                LoadCtrlUser(New CtrlUser_RPT_GastosPorConceptoDeNomina, tvMenu.SelectedNode.Text.Trim)
            Case 1439
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayorPorConcepto, tvMenu.SelectedNode.Text.Trim)
            Case 1440
                LoadCtrlUser(New CtrlUser_RPT_OC_OSTipoAsignacion, tvMenu.SelectedNode.Text.Trim)
            Case 1441
                LoadCtrlUser(New CtrlUser_RPT_ImportesPorTipoServicios, tvMenu.SelectedNode.Text.Trim)
            Case 1445 '"A.1 MATRIZ DEVENGADO DE GASTOS"
                LoadCtrlUser(New CtrlUser_RPT_Matriz_DevengadoGastos, tvMenu.SelectedNode.Text.Trim)
            Case 1446 '"A.2 MATRIZ PAGADO DE GASTOS" ----
                LoadCtrlUser(New CtrlUser_RPT_Matriz_PagadoGastos, tvMenu.SelectedNode.Text.Trim)
            Case 1447 '"B.1 MATRIZ INGRESOS DEVENGADOS"
                LoadCtrlUser(New CtrlUser_RPT_Matriz_IngresosDevengados, tvMenu.SelectedNode.Text.Trim)
            Case 1448 '"B.2 MATRIZ INGRESOS RECAUDADOS"
                LoadCtrlUser(New CtrlUser_RPT_Matriz_IngresosRecaudados, tvMenu.SelectedNode.Text.Trim)
            Case 1449 '"B.2.1 Matriz de recaudado de ingresos sin devengado previo de ingresos"
                LoadCtrlUser(New CtrlUser_RPT_Matriz_RecaudadoIngresosSinDevengado, tvMenu.SelectedNode.Text.Trim)
            Case 1450 '"Integración de reportes de Analitico de ingresos "
                LoadCtrlUser(New CtrlUser_RPT_EstadoAnaliticodeIngresos2, tvMenu.SelectedNode.Text.Trim)
            Case 1451
                LoadCtrlUser(New CtrlUser_RPT_MovimientosProducto, tvMenu.SelectedNode.Text.Trim)
            Case 1452 '"Catalogo de sellos presupuestales "
                LoadCtrlUser(New CtrlUser_RPT_ControlCatalogoDeSellos, tvMenu.SelectedNode.Text.Trim)
            Case 1453
                LoadCtrlUser(New CtrlUser_RPT_MovConcentradoAlmacen, tvMenu.SelectedNode.Text.Trim)
            Case 1454
                LoadCtrlUser(New CtrlUser_RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles, tvMenu.SelectedNode.Text.Trim)
            Case 1455
                LoadCtrlUser(New CtrlUser_RPT_ModeloAvancedelComprometido, tvMenu.SelectedNode.Text.Trim)
            Case 1456
                LoadCtrlUser(New CtrlUser_RPT_SolicitudTransferenciasPresupuestales, tvMenu.SelectedNode.Text.Trim)
            Case 1457
                LoadCtrlUser(New CtrlUser_RPT_Control_Presupuestal_Devengado, tvMenu.SelectedNode.Text.Trim)
            Case 1458
                LoadCtrlUser(New CtrlUser_RPT_Ramo_Programa_Objeto_Gasto_Capitulo(13, 14), tvMenu.SelectedNode.Text.Trim)
            Case 1460
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion_Sonora, tvMenu.SelectedNode.Text.Trim)
            Case 1461
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Comprobacion_Diaria, tvMenu.SelectedNode.Text.Trim)
            Case 1462
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Efectivo, tvMenu.SelectedNode.Text.Trim)
            Case 1463
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Bancos_Tesoreria, tvMenu.SelectedNode.Text.Trim)
            Case 1464
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_CXC_Corto_Plazo, tvMenu.SelectedNode.Text.Trim)
            Case 1465
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_De_Terrenos, tvMenu.SelectedNode.Text.Trim)
            Case 1466
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_De_Edificios_No_Habitacionales, tvMenu.SelectedNode.Text.Trim)
            Case 1467
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Mobiliario_Equipo_Admon, tvMenu.SelectedNode.Text.Trim)
            Case 1468
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Vehiculos_Equipo_Transporte, tvMenu.SelectedNode.Text.Trim)
            Case 1469
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Proveedores_por_Pagar_Corto_Plazo, tvMenu.SelectedNode.Text.Trim)
            Case 1470
                LoadCtrlUser(New CtrlUser_RPT_Relacion_Analitica_Otras_Cuentas_por_Pagar_Corto_Plazo, tvMenu.SelectedNode.Text.Trim)
            Case 1471
                LoadCtrlUser(New CtrlUser_RPT_Auxiliar_DIOT, tvMenu.SelectedNode.Text.Trim)
            Case 1472
                LoadCtrlUser(New CtrlUser_RPT_Pagos_ADEFAS, tvMenu.SelectedNode.Text.Trim)
            Case 1473
                LoadCtrlUser(New CtrlUser_RPT_Estado_De_Actividades_Periodos, tvMenu.SelectedNode.Text.Trim)
            Case 1474
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Anexos_Mayor, tvMenu.SelectedNode.Text.Trim)
            Case 1475
                LoadCtrlUser(New CtrlUser_RPT_FlujoDeEfectivo_EF, tvMenu.SelectedNode.Text.Trim)
            Case 1476
                LoadCtrlUser(New CtrlUser_RPT_ImpresionPolizas_Firmas, tvMenu.SelectedNode.Text.Trim)
            Case 1479 '"Gasto por Departamento"
                LoadCtrlUser(New CtrlUser_RPT_Gasto_Departamento, tvMenu.SelectedNode.Text.Trim)
            Case 1481 ' @PRodriguez 2020-01-20 B1226 - Ficha de indicador de proyecto
                LoadCtrlUser(New CtrlUser_RPT_FichaTecnicaIndicadorProyectoInstitucional, tvMenu.SelectedNode.Text.Trim)
            Case 1484 ' Facturas Recibidas UR
                LoadCtrlUser(New CtrlUser_RPT_FacturasRecibidasUR, tvMenu.SelectedNode.Text.Trim)
            Case 1485 ' Detalle Movimientos Almacén
                LoadCtrlUser(New CtrlUser_RPT_Detalle_Movimientos_Almacen, tvMenu.SelectedNode.Text.Trim)
            Case 1488 ' Auxiliar Mayor con Ref. Ingresos
                LoadCtrlUser(New CtrlUser_RPT_AuxiliarMayor_Ref_Ing, tvMenu.SelectedNode.Text.Trim)
            Case 1489 ' Impresión de Resguardo
                LoadCtrlUser(New CtrlUser_RPT_Formato_Resguardo, tvMenu.SelectedNode.Text.Trim)
            Case 1490 ' Informativa de Proveedores
                LoadCtrlUser(New CtrlUser_RPT_Informativa_Proveedores, tvMenu.SelectedNode.Text.Trim)
            Case 1491 ' Informativa de Proveedores
                LoadCtrlUser(New CtrlUser_RPT_Transferencias_Asignaciones_Ayudas, tvMenu.SelectedNode.Text.Trim)
            Case 1492 ' Informativa de Proveedores
                LoadCtrlUser(New CtrlUser_RPT_Informe_Deuda_Publica, tvMenu.SelectedNode.Text.Trim)
            Case 1494 ' Balanza ASEJ
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Auditoria_ASEJ, tvMenu.SelectedNode.Text.Trim)
            Case 1498 ' Layout Presupuestal COBACH
                LoadCtrlUser(New CtrlUser_RPT_Layout_Presupuestal, tvMenu.SelectedNode.Text.Trim)
            Case 1499 ' Guía de Cumplimiento de la Ley de Disciplina Financiera de las Entidades Federativas y Municipios
                LoadCtrlUser(New CtrlUser_RPT_Guia_Cumplimiento_LDF, tvMenu.SelectedNode.Text.Trim)
            Case 1501 ' Guía de Cumplimiento de la Ley de Disciplina Financiera de las Entidades Federativas y Municipios
                LoadCtrlUser(New CtrlUser_RPT_FoliosNoTramitados, tvMenu.SelectedNode.Text.Trim)
            Case 1502 ' Guía de Cumplimiento de la Ley de Disciplina Financiera de las Entidades Federativas y Municipios
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayorCveIng, tvMenu.SelectedNode.Text.Trim)
            Case 1503 ' Comparativo Presupuestal por Sello
                LoadCtrlUser(New CtrlUser_RPT_Comparativo_Calendarizado_Pres, tvMenu.SelectedNode.Text.Trim)
            Case 1506 ' Balanza de Comprobación – Devengado (Egresos/Ingresos)
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Devengado, tvMenu.SelectedNode.Text.Trim)
            Case 1507 ' Balanza de Comprobación Nivel Afectable
                LoadCtrlUser(New CtrlUser_RPT_Balanza_Nivel_Afectable, tvMenu.SelectedNode.Text.Trim)
            Case 1508 ' Adquisiciones – Proceso Administrativo – Devengado
                LoadCtrlUser(New CtrlUser_RPT_Adquisiciones_Adtvo_Devengado, tvMenu.SelectedNode.Text.Trim)
            Case 1509 ' Pagado en el Ejercicio
                LoadCtrlUser(New CtrlUser_RPT_Pagado_Ejercicio, tvMenu.SelectedNode.Text.Trim)
            Case 1510 ' Padrón de Proveedores
                LoadCtrlUser(New CtrlUser_RPT_Padron_Proveedores, tvMenu.SelectedNode.Text.Trim)
            Case 1512 ' Auxiliar de Mayor por Fechas
                LoadCtrlUser(New CtrlUser_RPT_PolizaAuxiliarMayor_Fechas, tvMenu.SelectedNode.Text.Trim)
            Case Else
                'MessageBox.Show("Error: Consulte al administrador", "Reporte no encontrado", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Select
        'End If
    End Sub

    Private Function getUserMenus(ByVal IdPadre As Integer) As List(Of TreeNode)
        Dim ListNodes As List(Of TreeNode) = New List(Of TreeNode)
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim qryMenus As String
#If DEBUG Then
        qryMenus = "Select * From C_Menu Where OrigenDll = 'Reporteador' And Utilizar = 1 And IdPadre = " & IdPadre & " Order By Orden"
#Else
        qryMenus = "Select * From C_MenuUsuarios Where OrigenDll = 'Reporteador' And Utilizar = 1 And IdMenuPadre = " & IdPadre & " And IdUsuario = " & IdUsuario & " Order By Orden"
#End If

        Dim cmd As SqlCommand = New SqlCommand(qryMenus, SQLConexion)
        cmd.CommandTimeout = 999
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        While reader.Read()
            Dim node As New TreeNode(reader(1))
            node.ToolTipText = reader(2)
            node.Tag = reader(0)

            If reader("TipoIcono") = 0 Then
                node.SelectedImageKey = "Cerrada.ico"
                node.ImageKey = "Cerrada.ico"
            ElseIf reader("TipoIcono") = 1 Then
                node.SelectedImageKey = "Print_48x48.png"
                node.ImageKey = "Print_48x48.png"
            ElseIf reader("TipoIcono") = 3 Then
                node.SelectedImageKey = "Msj_Conf.ico"
                node.ImageKey = "Msj_Conf.ico"
            End If

            node.Nodes.AddRange(getUserMenus(reader(0)).ToArray())

            ListNodes.Add(node)
        End While

        reader.Close()
        SQLConexion.Close()

        Return ListNodes

    End Function


    Dim Contraer As Boolean = False
    Private Sub SplitterControl1_DoubleClick(sender As System.Object, e As System.EventArgs) Handles SplitterControl1.DoubleClick

        If tvMenu.Width <= 50 Then
            Contraer = True
        Else
            Contraer = False
        End If
        If Contraer = False Then
            tvMenu.Width = 25
            Contraer = True
            Exit Sub
        End If
        If Contraer = True Then
            tvMenu.Width = 389
            Contraer = False
        End If
    End Sub

    Private Sub SplitterControl1_MouseHover(sender As System.Object, e As System.EventArgs) Handles SplitterControl1.MouseHover
        If tvMenu.Width <= 50 Then
            ToolTip1.SetToolTip(SplitterControl1, "Doble click para extender")
        Else
            ToolTip1.SetToolTip(SplitterControl1, "Doble click para contraer")
        End If
    End Sub

    Private Sub XtraTabbedMdiManager1_PageAdded(sender As System.Object, e As DevExpress.XtraTabbedMdi.MdiTabPageEventArgs) Handles XtraTabbedMdiManager1.PageAdded
        If e.Page.MdiChild.Tag Is Nothing Then
            e.Page.Image = My.Resources.Print_16x16
        Else
            e.Page.Image = e.Page.MdiChild.Tag
        End If
    End Sub
End Class
