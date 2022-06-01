Public Class cls_Config
    Dim _RutaIni As String
    Dim _Server As String
    Dim _User As String
    Dim _Psw As String
    Dim _BD As String


    Public Property RutaIni() As String
        Get
            Return _RutaIni
        End Get
        Set(ByVal value As String)
            _RutaIni = value
        End Set
    End Property
    Public Property Server() As String
        Get
            Return _Server
        End Get
        Set(ByVal value As String)
            _Server = value
        End Set
    End Property

    Public Property User As String
        Get
            Return _User
        End Get
        Set(ByVal value As String)
            _User = value
        End Set

    End Property

    Public Property Psw As String
        Get
            Return _Psw
        End Get
        Set(ByVal value As String)
            _Psw = value
        End Set
    End Property
    Public Property BD As String
        Get
            Return _BD
        End Get
        Set(ByVal value As String)
            _BD = value
        End Set
    End Property

End Class
