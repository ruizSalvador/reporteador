Public Class clsC_Usuarios
    Dim _IDUsuario As Integer
    Dim _NumeroEmpleado As Integer
    Dim _Login As String
    Dim _Pwd As String
    Dim _NivelAutorizacion As Integer
    Dim _Conectado As Integer
    Dim _IdGrupo As Integer
    Dim _TipoMenu As Integer
    Dim _Multiventana As Integer

    Public Property IDUsuario() As Integer
        Get
            Return _IDUsuario
        End Get
        Set(ByVal value As Integer)
            _IDUsuario = value
        End Set
    End Property
    Public Property NumeroEmpleado() As Integer
        Get
            Return _NumeroEmpleado
        End Get
        Set(ByVal value As Integer)
            _NumeroEmpleado = value
        End Set
    End Property
    Public Property Login() As String
        Get
            Return _Login
        End Get
        Set(ByVal value As String)
            _Login = value
        End Set
    End Property
    Public Property Pwd() As String
        Get
            Return _Pwd
        End Get
        Set(ByVal value As String)
            _Pwd = value
        End Set
    End Property
    Public Property NivelAutorizacion() As Integer
        Get
            Return _NivelAutorizacion
        End Get
        Set(ByVal value As Integer)
            _NivelAutorizacion = value
        End Set
    End Property
    Public Property Conectado() As Integer
        Get
            Return _Conectado
        End Get
        Set(ByVal value As Integer)
            _Conectado = value
        End Set
    End Property
    Public Property IdGrupo() As Integer
        Get
            Return _IdGrupo
        End Get
        Set(ByVal value As Integer)
            _IdGrupo = value
        End Set
    End Property
    Public Property TipoMenu() As Integer
        Get
            Return _TipoMenu
        End Get
        Set(ByVal value As Integer)
            _TipoMenu = value
        End Set
    End Property
    Public Property Multiventana() As Integer
        Get
            Return _Multiventana
        End Get
        Set(ByVal value As Integer)
            _Multiventana = value
        End Set
    End Property
End Class
