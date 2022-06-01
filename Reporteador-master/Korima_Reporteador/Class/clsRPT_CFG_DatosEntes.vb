Public Class clsRPT_CFG_DatosEntes
    Dim _ID As Integer
    Dim _Nombre As String
    Dim _ClaveSistema As String
    Dim _Domicilio As String
    Dim _Ciudad As String
    Dim _EntidadFederativa As String
    Dim _RFC As String
    Dim _Telefonos As String
    Dim _Texto As String
    Dim _LogoEnte As Image
    Dim _LogoEnteSecundario As Image
    Dim _LogoKorima As Image
    Dim _LastUpdate As String


    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property
    Public Property Nombre() As String
        Get
            Return _Nombre
        End Get
        Set(ByVal value As String)
            _Nombre = value
        End Set
    End Property
    Public Property ClaveSistema() As String
        Get
            Return _ClaveSistema
        End Get
        Set(ByVal value As String)
            _ClaveSistema = value
        End Set
    End Property
    '---Comunes
    Public Property Domicilio() As String
        Get
            Return _Domicilio
        End Get
        Set(ByVal value As String)
            _Domicilio = value
        End Set
    End Property

    Public Property Ciudad() As String
        Get
            Return _Ciudad
        End Get
        Set(ByVal value As String)
            _Ciudad = value
        End Set
    End Property

    Public Property EntidadFederativa() As String
        Get
            Return _EntidadFederativa
        End Get
        Set(ByVal value As String)
            _EntidadFederativa = value
        End Set
    End Property

    Public Property RFC() As String
        Get
            Return _RFC
        End Get
        Set(ByVal value As String)
            _RFC = value
        End Set
    End Property
    Public Property Telefonos() As String
        Get
            Return _Telefonos
        End Get
        Set(ByVal value As String)
            _Telefonos = value
        End Set
    End Property
    Public Property Texto() As String
        Get
            Return _Texto
        End Get
        Set(ByVal value As String)
            _Texto = value
        End Set
    End Property
    Public Property LogoEnte() As Image
        Get
            Return _LogoEnte
        End Get
        Set(ByVal value As Image)
            _LogoEnte = value
        End Set
    End Property
    Public Property LogoEnteSecundario() As Image
        Get
            Return _LogoEnteSecundario
        End Get
        Set(ByVal value As Image)
            _LogoEnteSecundario = value
        End Set
    End Property
    Public Property LogoKorima() As Image
        Get
            Return _LogoKorima
        End Get
        Set(ByVal value As Image)
            _LogoKorima = value
        End Set
    End Property
    Public Property LastUpdate() As String
        Get
            Return _LastUpdate
        End Get
        Set(ByVal value As String)
            _LastUpdate = value
        End Set
    End Property
End Class
