Public Class clsRPT_CAT_Reportes
    Dim _ID As Integer
    Dim _ReporteNombre As String
    Dim _ReporteDescripcion As String
    Dim _ReporteVersion As String
    Dim _ReporteFechaCambio As String
    Dim _ArchivoNombre As String
    Dim _ArchivoReporte As Byte

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property
    Public Property ReporteNombre() As String
        Get
            Return _ReporteNombre
        End Get
        Set(ByVal value As String)
            _ReporteNombre = value
        End Set
    End Property
    Public Property ReporteDescripcion() As String
        Get
            Return _ReporteDescripcion
        End Get
        Set(ByVal value As String)
            _ReporteDescripcion = value
        End Set
    End Property
    '---Comunes
    Public Property ReporteVersion() As String
        Get
            Return _ReporteVersion
        End Get
        Set(ByVal value As String)
            _ReporteVersion = value
        End Set
    End Property
    Public Property ReporteFechaCambio() As String
        Get
            Return _ReporteFechaCambio
        End Get
        Set(ByVal value As String)
            _ReporteFechaCambio = value
        End Set
    End Property
    Public Property ArchivoNombre() As String
        Get
            Return _ArchivoNombre
        End Get
        Set(ByVal value As String)
            _ArchivoNombre = value
        End Set
    End Property
    Public Property ArchivoReporte() As Byte
        Get
            Return _ArchivoReporte
        End Get
        Set(ByVal value As Byte)
            _ArchivoReporte = value
        End Set
    End Property
End Class
