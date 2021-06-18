Public Class clsRPT_SEC_Accesos
    Dim _ID As Integer
    Dim _IdUsuario As Integer
    Dim _IdReporte As Integer
    Dim _Disponible As Boolean

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property
    Public Property IdUsuario() As Integer
        Get
            Return _IdUsuario
        End Get
        Set(ByVal value As Integer)
            _IdUsuario = value
        End Set
    End Property
    Public Property IdReporte() As Integer
        Get
            Return _IdReporte
        End Get
        Set(ByVal value As Integer)
            _IdReporte = value
        End Set
    End Property
    '---Comunes
    Public Property Disponible() As Boolean
        Get
            Return _Disponible
        End Get
        Set(ByVal value As Boolean)
            _Disponible = value
        End Set
    End Property
End Class
