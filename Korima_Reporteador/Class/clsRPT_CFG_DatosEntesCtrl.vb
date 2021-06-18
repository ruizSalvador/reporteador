'=======================================================================================================
'Autor:		Ing. Miguel Angel Quintana Martínez
'Elaboro:	Ing. Miguel Angel Quintana Martínez
'Reviso:		
'Aprobó:		
'
'Fecha:		2011-11-30
'Descripción:Clase para el manejo de datos de los documentos fuentes para RPT_CFG_DatosEntes
'.......................................................................................................
'Aviso de Propiedad: Esta Clase VB-Class así como todo su contenido es propiedad intelectual 
'                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
'  					 parcial así como su modificación por personal distinto al designado por Korima.
'					 Korima 2011
'=======================================================================================================
'|Versión  |Fecha      |Responsable         |Descripción de Cambio 
'-------------------------------------------------------------------------------------------------------
'| 1.0	   |2011.11.30 |Miguel Quintana     |Diseño de estructura
'| 1.0	   |2012.06.05 |Benjamí Meléndez    |Codificación de Clase
'| 1.0	   |2014.02.28 |Enrique Hernandez   |Agregar Entidad Federativa
'=======================================================================================================
Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports Microsoft.SqlServer
Imports System.Configuration
Imports System.Data.SqlClient

Public Class clsRPT_CFG_DatosEntesCtrl
    Inherits clsRPT_CFG_DatosEntes
    Dim UsarWiko As Boolean = My.Settings.APP_CFG_CtrlErrorporWiko
    '--- Variables Privadas
    Private SQLmErrorDescr As String
    Private SQLmErrorCode As Integer
    Private SQLmIdOperacion As Integer
    Private NombreClase As String = "clsRPT_CFG_DatosEntesCtrl"

    '--- Procedimientos en SQL
    Private AddSPName As String = "SP_RPT_CFG_DatosEntes_ADD"
    Private UpdSPName As String = "SP_RPT_CFG_DatosEntes_UPD"
    Private DelSPName As String = "SP_RPT_CFG_DatosEntes_DEL"
    Private GetSPName As String = "SP_RPT_CFG_DatosEntes_GETONE"
    Private ListSPName As String = "SP_RPT_CFG_DatosEntes_LIST"
    '---------------------------------------------------
    '--- Errores Información
    Public ReadOnly Property ErrDescr() As String
        Get
            Return SQLmErrorDescr
        End Get
    End Property
    Public ReadOnly Property ErrCode() As String
        Get
            Return SQLmErrorCode
        End Get
    End Property
    '--- Id Asignado
    Public ReadOnly Property IdOperacion() As String
        Get
            Return SQLmIdOperacion
        End Get
    End Property
    '---Conexión
    Public Sub New()

    End Sub

    Public Sub Add(ByVal pRPTCFGDatosEntes As clsRPT_CFG_DatosEntes, ByVal NotificarOper As Boolean)
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)

        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(AddSPName, SQLConexion)

            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@Nombre", pRPTCFGDatosEntes.Nombre))
            SQLComando.Parameters.Add(New SqlParameter("@ClaveSistema", pRPTCFGDatosEntes.ClaveSistema))
            SQLComando.Parameters.Add(New SqlParameter("@Domicilio", pRPTCFGDatosEntes.Domicilio))
            SQLComando.Parameters.Add(New SqlParameter("@Ciudad", pRPTCFGDatosEntes.Ciudad))
            SQLComando.Parameters.Add(New SqlParameter("@EntidadFederativa", pRPTCFGDatosEntes.EntidadFederativa))
            SQLComando.Parameters.Add(New SqlParameter("@RFC", pRPTCFGDatosEntes.RFC))
            SQLComando.Parameters.Add(New SqlParameter("@Telefonos", pRPTCFGDatosEntes.Telefonos))
            SQLComando.Parameters.Add(New SqlParameter("@Texto", pRPTCFGDatosEntes.Texto))
            '--- Para Fotografia
            If Not pRPTCFGDatosEntes.LogoEnte Is Nothing Then
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoEnte.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoEnte", SqlDbType.Image)).Value = ms.GetBuffer
            End If
            If Not pRPTCFGDatosEntes.LogoKorima Is Nothing Then
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoKorima.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoKorima", SqlDbType.Image)).Value = ms.GetBuffer
            End If
            If Not pRPTCFGDatosEntes.LogoEnteSecundario Is Nothing Then
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoEnteSecundario.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoEnteSecundario", SqlDbType.Image)).Value = ms.GetBuffer
            End If

            'SQLComando.Parameters.Add(New SqlParameter("@LogoEnte", pRPTCFGDatosEntes.LogoEnte))
            'SQLComando.Parameters.Add(New SqlParameter("@LogoKorima", pRPTCFGDatosEntes.LogoKorima))
            '--- Parametros OUT
            SQLComando.Parameters.Add(New SqlParameter("@OperacionID", SQLmIdOperacion))
            SQLComando.Parameters("@OperacionID").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrCode", SQLmErrorCode))
            SQLComando.Parameters("@MjsErrCode").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrDescr", SQLmErrorDescr))
            SQLComando.Parameters("@MjsErrDescr").Direction = ParameterDirection.Output
            SQLComando.Parameters("@MjsErrDescr").Size = 255
            '--- Ejecutar SQL
            SQLComando.ExecuteNonQuery()

            SQLmIdOperacion = SQLComando.Parameters("@OperacionID").Value
            SQLmErrorCode = SQLComando.Parameters("@MjsErrCode").Value
            SQLmErrorDescr = SQLComando.Parameters("@MjsErrDescr").Value

            SQLComando.Dispose()
            SQLConexion.Close()
            SQLConexion.Dispose()
            '--- Notificar operación exitosa
            If NotificarOper = True Then
                MessageBox.Show("El registro fue agregado exitosamente.", "Registro Agregado…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As SqlException
            SQLmErrorDescr = ex.Message
            SQLmErrorCode = ex.ErrorCode
            '--- Control de Errores Wiko o Sin Wiko
            If UsarWiko = True Then
                With FRM_WikoErrorSender
                    .Text = "No se pudo agregar el registro..."
                    .lblTitulo.Text = "No se ha podido agregar el registro."
                    .lblDescripcion.Text = SQLmErrorDescr
                    .lblNumeroError.Text = SQLmErrorCode
                    .lblProcedimiento.Text = ex.Procedure
                    .lblServer.Text = ex.Server
                    .lblIDMensaje.Text = ex.Number
                    .lblOrigen.Text = NombreClase
                    .ShowDialog()
                End With
            Else
                MessageBox.Show(SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, "No se pudo agregar el registro…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try
    End Sub
    Public Sub Del(ByVal pRPTCFGDatosEntes As clsRPT_CFG_DatosEntes, ByVal NotificarOper As Boolean)
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(DelSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCFGDatosEntes.ID))
            '--- Parametros OUT
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrCode", SQLmErrorCode))
            SQLComando.Parameters("@MjsErrCode").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrDescr", SQLmErrorDescr))
            SQLComando.Parameters("@MjsErrDescr").Direction = ParameterDirection.Output
            SQLComando.Parameters("@MjsErrDescr").Size = 255
            '--- Ejecutar SQL
            Dim oReader As SqlDataReader
            oReader = SQLComando.ExecuteReader()
            SQLmErrorCode = SQLComando.Parameters("@MjsErrCode").Value
            SQLmErrorDescr = SQLComando.Parameters("@MjsErrDescr").Value
            SQLComando.Dispose()
            SQLConexion.Close()
            SQLConexion.Dispose()
            If NotificarOper = True And SQLmErrorCode = 0 Then
                MessageBox.Show("El registro fue eliminado exitosamente.", "Registro Eliminado…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                MessageBox.Show(SQLmErrorDescr, "Aviso...", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As SqlException
            SQLmErrorDescr = ex.Message
            SQLmErrorCode = ex.ErrorCode
            '--- Control de Errores Wiko o Sin Wiko
            If UsarWiko = True Then
                With FRM_WikoErrorSender
                    .Text = "No se pudo eliminar el registro..."
                    .lblTitulo.Text = "No se ha podido eliminar el registro."
                    .lblDescripcion.Text = SQLmErrorDescr
                    .lblNumeroError.Text = SQLmErrorCode
                    .lblProcedimiento.Text = ex.Procedure
                    .lblServer.Text = ex.Server
                    .lblIDMensaje.Text = ex.Number
                    .lblOrigen.Text = NombreClase
                    .ShowDialog()
                End With
            Else
                MessageBox.Show(SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, "No se pudo eliminar el registro…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally
        End Try
    End Sub

    Public Sub Upd(ByVal pRPTCFGDatosEntes As clsRPT_CFG_DatosEntes)

        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(UpdSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCFGDatosEntes.ID))
            SQLComando.Parameters.Add(New SqlParameter("@Nombre", pRPTCFGDatosEntes.Nombre))
            SQLComando.Parameters.Add(New SqlParameter("@ClaveSistema", pRPTCFGDatosEntes.ClaveSistema))
            SQLComando.Parameters.Add(New SqlParameter("@Domicilio", pRPTCFGDatosEntes.Domicilio))
            SQLComando.Parameters.Add(New SqlParameter("@EntidadFederativa", pRPTCFGDatosEntes.EntidadFederativa))
            SQLComando.Parameters.Add(New SqlParameter("@Ciudad", pRPTCFGDatosEntes.Ciudad))
            SQLComando.Parameters.Add(New SqlParameter("@RFC", pRPTCFGDatosEntes.RFC))
            SQLComando.Parameters.Add(New SqlParameter("@Telefonos", pRPTCFGDatosEntes.Telefonos))
            SQLComando.Parameters.Add(New SqlParameter("@Texto", pRPTCFGDatosEntes.Texto))

            If Not pRPTCFGDatosEntes.LogoEnte Is Nothing Then
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoEnte.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoEnte", SqlDbType.Image)).Value = ms.GetBuffer
            End If
            If Not pRPTCFGDatosEntes.LogoKorima Is Nothing Then
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoKorima.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoKorima", SqlDbType.Image)).Value = ms.GetBuffer
            End If
            If Not pRPTCFGDatosEntes.LogoEnteSecundario Is Nothing Then 'KAZB
                Dim ms As New System.IO.MemoryStream
                pRPTCFGDatosEntes.LogoEnteSecundario.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
                SQLComando.Parameters.Add(New SqlParameter("@LogoEnteSecundario", SqlDbType.Image)).Value = ms.GetBuffer
            Else
                SQLComando.Parameters.Add(New SqlParameter("@LogoEnteSecundario", SqlDbType.Image)).Value = DBNull.Value
            End If


            '--- Parametros OUT
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrCode", SQLmErrorCode))
            SQLComando.Parameters("@MjsErrCode").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrDescr", SQLmErrorDescr))
            SQLComando.Parameters("@MjsErrDescr").Direction = ParameterDirection.Output
            SQLComando.Parameters("@MjsErrDescr").Size = 255
            '--- Ejecutar SQL
            SQLComando.ExecuteNonQuery()
            '--- Asigna parametros de retorno
            SQLmErrorCode = SQLComando.Parameters("@MjsErrCode").Value
            SQLmErrorDescr = SQLComando.Parameters("@MjsErrDescr").Value

            SQLComando.Dispose()
            SQLConexion.Close()
            SQLConexion.Dispose()
        Catch ex As SqlException
            SQLmErrorDescr = ex.Message
            SQLmErrorCode = ex.ErrorCode
            '--- Control de Errores Wiko o Sin Wiko
            If UsarWiko = True Then
                With FRM_WikoErrorSender
                    .Text = "No se pudo actualizar el registro..."
                    .lblTitulo.Text = "No se ha podido actualizar el registro."
                    .lblDescripcion.Text = SQLmErrorDescr
                    .lblNumeroError.Text = SQLmErrorCode
                    .lblProcedimiento.Text = ex.Procedure
                    .lblServer.Text = ex.Server
                    .lblIDMensaje.Text = ex.Number
                    .lblOrigen.Text = NombreClase
                    .ShowDialog()
                End With
            Else
                MessageBox.Show(SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, "No se pudo actualizar el registro…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try
    End Sub
    Public Function GetOne() As clsRPT_CFG_DatosEntes
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Dim tmpClass As New clsRPT_CFG_DatosEntes
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(GetSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            'SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCFGDatosEntes.ID))

            '--- Parametros OUT
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrCode", SQLmErrorCode))
            SQLComando.Parameters("@MjsErrCode").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrDescr", SQLmErrorDescr))
            SQLComando.Parameters("@MjsErrDescr").Direction = ParameterDirection.Output
            SQLComando.Parameters("@MjsErrDescr").Size = 255
            '--- Ejecutar SQL
            Dim oReader As SqlDataReader
            oReader = SQLComando.ExecuteReader()

            '--- Asigna parametros de retorno
            SQLmErrorCode = SQLComando.Parameters("@MjsErrCode").Value
            SQLmErrorDescr = SQLComando.Parameters("@MjsErrDescr").Value

            '--- Asignar valores a clase
            If SQLmErrorCode = 0 Then
                oReader.Read()
                If oReader.HasRows Then
                    If IsDBNull(oReader.Item("ID")) Then
                        tmpClass.ID = ""
                    Else
                        tmpClass.ID = oReader.Item("ID")
                    End If
                    If IsDBNull(oReader.Item("Nombre")) Then
                        tmpClass.Nombre = ""
                    Else
                        tmpClass.Nombre = oReader.Item("Nombre")
                    End If
                    If IsDBNull(oReader.Item("ClaveSistema")) Then
                        tmpClass.ClaveSistema = ""
                    Else
                        tmpClass.ClaveSistema = oReader.Item("ClaveSistema")
                    End If
                    If IsDBNull(oReader.Item("Domicilio")) Then
                        tmpClass.Domicilio = ""
                    Else
                        tmpClass.Domicilio = oReader.Item("Domicilio")
                    End If
                    If IsDBNull(oReader.Item("Ciudad")) Then
                        tmpClass.Ciudad = ""
                    Else
                        tmpClass.Ciudad = oReader.Item("Ciudad")
                    End If
                    If IsDBNull(oReader.Item("EntidadFederativa")) Then
                        tmpClass.EntidadFederativa = ""
                    Else
                        tmpClass.EntidadFederativa = oReader.Item("EntidadFederativa")
                    End If
                    If IsDBNull(oReader.Item("RFC")) Then
                        tmpClass.RFC = ""
                    Else
                        tmpClass.RFC = oReader.Item("RFC")
                    End If
                    If IsDBNull(oReader.Item("Telefonos")) Then
                        tmpClass.Telefonos = ""
                    Else
                        tmpClass.Telefonos = oReader.Item("Telefonos")
                    End If
                    If IsDBNull(oReader.Item("Texto")) Then
                        tmpClass.Texto = ""
                    Else
                        tmpClass.Texto = oReader.Item("Texto")
                    End If
                    If IsDBNull(oReader.Item("LogoEnte")) Then
                        tmpClass.LogoEnte = Nothing
                    Else
                        tmpClass.LogoEnte = ConvertByteArrayToImage(oReader.Item("LogoEnte"))
                    End If
                    If IsDBNull(oReader.Item("LogoKorima")) Then
                        tmpClass.LogoKorima = Nothing
                    Else
                        tmpClass.LogoKorima = ConvertByteArrayToImage(oReader.Item("LogoKorima"))
                    End If
                    If IsDBNull(oReader.Item("LogoEnteSecundario")) Then
                        tmpClass.LogoEnteSecundario = Nothing
                    Else
                        tmpClass.LogoEnteSecundario = ConvertByteArrayToImage(oReader.Item("LogoEnteSecundario"))
                    End If
                    If IsDBNull(oReader.Item("LastUpdate")) Then
                        tmpClass.LastUpdate = Nothing
                    Else
                        tmpClass.LastUpdate = oReader.Item("LastUpdate")
                    End If
                Else
                    SQLmErrorCode = -1
                End If
            Else
                SQLmErrorDescr = SQLmErrorDescr
            End If
            SQLComando.Dispose()
            GetOne = tmpClass
            If SQLConexion.State = ConnectionState.Open Then
                SQLConexion.Close()
            End If
            SQLConexion.Dispose()
        Catch ex As SqlException
            SQLmErrorDescr = ex.Message()
            SQLmErrorCode = ex.ErrorCode
            '--- Control de Errores Wiko o Sin Wiko
            If UsarWiko = True Then
                With FRM_WikoErrorSender
                    .Text = "No se pudo leer el registro..."
                    .lblTitulo.Text = "No se ha podido leer el registro."
                    .lblDescripcion.Text = SQLmErrorDescr
                    .lblNumeroError.Text = SQLmErrorCode
                    .lblProcedimiento.Text = ex.Procedure
                    .lblServer.Text = ex.Server
                    .lblIDMensaje.Text = ex.Number
                    .lblOrigen.Text = NombreClase
                    .ShowDialog()
                End With
            Else
                MessageBox.Show(SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, "No se pudo leer el registro…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try
        GetOne = tmpClass
    End Function
    Public Function List(ByVal pFilter As String, ByVal pCounter As Integer, ByVal pViewTable As String, ByVal pOrder As String) As DataTable
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Dim miDataSet As New DataSet()
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(ListSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ViewTable", pViewTable))
            If pFilter.Trim = "" Then
                SQLComando.Parameters.Add(New SqlParameter("@Filter", Convert.DBNull))
            Else
                SQLComando.Parameters.Add(New SqlParameter("@Filter", pFilter))
            End If
            SQLComando.Parameters.Add(New SqlParameter("@Order", pOrder))
            SQLComando.Parameters.Add(New SqlParameter("@Counter", pCounter))
            '--- Parametros OUT
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrCode", SQLmErrorCode))
            SQLComando.Parameters("@MjsErrCode").Direction = ParameterDirection.Output
            SQLComando.Parameters.Add(New SqlParameter("@MjsErrDescr", SQLmErrorDescr))
            SQLComando.Parameters("@MjsErrDescr").Direction = ParameterDirection.Output
            SQLComando.Parameters("@MjsErrDescr").Size = 255
            '--- Ejecutar SQL
            Dim myAdap As New SqlDataAdapter(SQLComando)
            myAdap.Fill(miDataSet, pViewTable)
            ' SQLmErrorCode = SQLComando.Parameters("@MjsErrCode").Value
            ' SQLmErrorDescr = SQLComando.Parameters("@MjsErrDescr").Value
            If SQLmErrorCode = 0 Then
                SQLmErrorDescr = ""
                Return miDataSet.Tables(0)
            Else
                SQLmErrorDescr = "Error: " & SQLmErrorDescr
            End If
            SQLComando.Dispose()
            SQLConexion.Close()
            SQLConexion.Dispose()

        Catch ex As SqlException

            SQLmErrorDescr = "Error: " & ex.Message()
            SQLmErrorCode = ex.ErrorCode
            '--- Control de Errores Wiko o Sin Wiko
            If UsarWiko = True Then
                With FRM_WikoErrorSender
                    .Text = "No se pudo consultar los registros..."
                    .lblTitulo.Text = "No se ha podido consultar los registros."
                    .lblDescripcion.Text = SQLmErrorDescr
                    .lblNumeroError.Text = SQLmErrorCode
                    .lblProcedimiento.Text = ex.Procedure
                    .lblServer.Text = ex.Server
                    .lblIDMensaje.Text = ex.Number
                    .lblOrigen.Text = NombreClase
                    .ShowDialog()
                End With
            Else
                MessageBox.Show(SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, "No se pudo consultar los registros…", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------

            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try

    End Function

    ' ---- manejo de imagenes

    Public Shared Function ConvertImageToByteArray(ByVal imageIn As System.Drawing.Image) As Byte()
        Dim ms As New IO.MemoryStream()
        imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)
        Return ms.ToArray()
    End Function
    Public Shared Function ConvertByteArrayToImage(ByVal byteArrayIn As Byte()) As Image
        Dim ms As New IO.MemoryStream(byteArrayIn)
        Dim returnImage As Image = Image.FromStream(ms)
        Return returnImage
    End Function
End Class
