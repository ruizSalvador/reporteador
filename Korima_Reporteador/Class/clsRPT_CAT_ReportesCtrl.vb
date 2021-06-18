'=======================================================================================================
'Autor:		Ing. Miguel Angel Quintana Martínez
'Elaboro:	Ing. Miguel Angel Quintana Martínez
'Reviso:		
'Aprobó:		
'
'Fecha:		2011-11-30
'Descripción:Clase para el manejo de datos de los documentos fuentes para la guia contabilizadora
'.......................................................................................................
'Aviso de Propiedad: Esta Clase VB-Class así como todo su contenido es propiedad intelectual 
'                    de Korima Sistemas de Gestión SAPI de CV queda prohibida su reproducción total o 
'  					 parcial así como su modificación por personal distinto al designado por Korima.
'					 Korima 2011
'=======================================================================================================
'|Versión  |Fecha      |Responsable         |Descripción de Cambio 
'-------------------------------------------------------------------------------------------------------
'| 1.0	   |2011.11.30 |Miguel Quintana     |Diseño de estructura
'| 1.0	   |2012.06.04 |Benjamin Meléndez   |Codificación de Clase
'=======================================================================================================
Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports Microsoft.SqlServer
Imports System.Configuration
Imports System.Data.SqlClient

Public Class clsRPT_CAT_ReportesCtrl
    Inherits clsRPT_CAT_Reportes
    Dim UsarWiko As Boolean = My.Settings.APP_CFG_CtrlErrorporWiko
    '--- Variables Privadas
    Private SQLmErrorDescr As String
    Private SQLmErrorCode As Integer
    Private SQLmIdOperacion As Integer
    Private NombreClase As String = "clsRPT_CAT_ReportesCtrl"

    '--- Procedimientos en SQL
    Private AddSPName As String = "SP_RPT_CAT_Reportes_ADD"
    Private UpdSPName As String = "SP_RPT_CAT_Reportes_UPD"
    Private DelSPName As String = "SP_RPT_CAT_Reportes_DEL"
    Private GetSPName As String = "SP_RPT_CAT_Reportes_GETONE"
    Private ListSPName As String = "SP_RPT_CAT_Reportes_LIST"
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

    Public Sub Add(ByVal pRPTCATReportes As clsRPT_CAT_Reportes, ByVal NotificarOper As Boolean)
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)

        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(AddSPName, SQLConexion)

            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ReporteNombre", pRPTCATReportes.ReporteNombre))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteDescripcion", pRPTCATReportes.ReporteDescripcion))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteVersion", pRPTCATReportes.ReporteVersion))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteFechaCambio", pRPTCATReportes.ReporteFechaCambio))
            SQLComando.Parameters.Add(New SqlParameter("@ArchivoNombre", pRPTCATReportes.ArchivoNombre))
            SQLComando.Parameters.Add(New SqlParameter("@ArchivoReporte", pRPTCATReportes.ArchivoReporte))
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
                MessageBox.Show("No se pudo agregar el registro…", SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try
    End Sub
    Public Sub Del(ByVal pRPTCATReportes As clsRPT_CAT_Reportes, ByVal NotificarOper As Boolean)
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(DelSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCATReportes.ID))
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
                MessageBox.Show("No se pudo eliminar el registro…", SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally
        End Try
    End Sub

    Public Sub Upd(ByVal pRPTCATReportes As clsRPT_CAT_Reportes)

        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(UpdSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCATReportes.ID))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteNombre", pRPTCATReportes.ReporteNombre))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteDescripcion", pRPTCATReportes.ReporteDescripcion))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteVersion", pRPTCATReportes.ReporteVersion))
            SQLComando.Parameters.Add(New SqlParameter("@ReporteFechaCambio", pRPTCATReportes.ReporteFechaCambio))
            SQLComando.Parameters.Add(New SqlParameter("@ArchivoNombre", pRPTCATReportes.ArchivoNombre))
            SQLComando.Parameters.Add(New SqlParameter("@ArchivoReporte", pRPTCATReportes.ArchivoReporte))
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
                MessageBox.Show("No se pudo actualizar el registro…", SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------
            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try
    End Sub
    Public Function GetOne(ByVal pRPTCATReportes As clsRPT_CAT_Reportes) As clsRPT_CAT_Reportes
        Dim SQLConexion As SqlConnection = New SqlConnection(cnnString)
        Dim tmpClass As New clsRPT_CAT_Reportes
        Try
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand(GetSPName, SQLConexion)
            SQLComando.CommandType = CommandType.StoredProcedure
            '--- Parametros IN
            SQLComando.Parameters.Add(New SqlParameter("@ID", pRPTCATReportes.ID))
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
                    
                    If IsDBNull(oReader.Item("ReporteNombre")) Then
                        tmpClass.ReporteNombre = ""
                    Else
                        tmpClass.ReporteNombre = oReader.Item("ReporteNombre")
                    End If
                    If IsDBNull(oReader.Item("ReporteDescripcion")) Then
                        tmpClass.ReporteDescripcion = ""
                    Else
                        tmpClass.ReporteDescripcion = oReader.Item("ReporteDescripcion")
                    End If
                    If IsDBNull(oReader.Item("ReporteVersion")) Then
                        tmpClass.ReporteVersion = ""
                    Else
                        tmpClass.ReporteVersion = oReader.Item("ReporteVersion")
                    End If
                    If IsDBNull(oReader.Item("ReporteFechaCambio")) Then
                        tmpClass.ReporteFechaCambio = ""
                    Else
                        tmpClass.ReporteFechaCambio = oReader.Item("ReporteFechaCambio")
                    End If
                    If IsDBNull(oReader.Item("ArchivoNombre")) Then
                        tmpClass.ArchivoNombre = ""
                    Else
                        tmpClass.ArchivoNombre = oReader.Item("ArchivoNombre")
                    End If
                    If IsDBNull(oReader.Item("ArchivoReporte")) Then
                        tmpClass.ArchivoReporte = Nothing
                    Else
                        tmpClass.ArchivoReporte = oReader.Item("ArchivoReporte")
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
                MessageBox.Show("No se pudo leer el registro…", SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, MessageBoxButtons.OK, MessageBoxIcon.Information)
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
                MessageBox.Show("No se pudo consultar los registros…", SQLmErrorDescr & Chr(13) & "Código de error:" & SQLmErrorCode, MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            '-----------------------------------------

            If ConnectionState.Open = 1 Then
                SQLConexion.Close()
                SQLConexion.Dispose()
            End If
        Finally

        End Try

    End Function
End Class
