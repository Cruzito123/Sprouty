from rest_framework import viewsets, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.shortcuts import get_object_or_404
from django.core.files.storage import default_storage

# Importamos tus modelos y serializadores
from .models import Planta, Maceta, ConfiguracionMaceta, LecturaSensor, JardinVirtual, Notificacion, Usuario
from .serializers import *

# -------------------------------------------------------------------------
# VIEWSETS (CRUD AUTOMÁTICO) - No se han tocado
# -------------------------------------------------------------------------

class PlantaViewSet(viewsets.ModelViewSet):
    queryset = Planta.objects.all()
    serializer_class = PlantaSerializer

class MacetaViewSet(viewsets.ModelViewSet):
    queryset = Maceta.objects.all()
    serializer_class = MacetaSerializer

class ConfiguracionMacetaViewSet(viewsets.ModelViewSet):
    queryset = ConfiguracionMaceta.objects.all()
    serializer_class = ConfiguracionMacetaSerializer

class LecturaSensorViewSet(viewsets.ModelViewSet):
    queryset = LecturaSensor.objects.all()
    serializer_class = LecturaSensorSerializer

class JardinVirtualViewSet(viewsets.ModelViewSet):
    queryset = JardinVirtual.objects.all()
    serializer_class = JardinVirtualSerializer

class NotificacionViewSet(viewsets.ModelViewSet):
    queryset = Notificacion.objects.all()
    serializer_class = NotificacionSerializer

# -------------------------------------------------------------------------
# ENDPOINTS PERSONALIZADOS (Sensores y Lógica)
# -------------------------------------------------------------------------

@api_view(['GET'])
def plantas_recomendadas(request):
    try:
        plantas = Planta.objects.filter(
            humedad_min__lte=50,
            humedad_max__gte=50,
            temperatura_min__lte=25,
            temperatura_max__gte=25
        )[:10]
        serializer = PlantaSerializer(plantas, many=True)
        return Response(serializer.data)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def estadisticas_maceta(request, maceta_id):
    try:
        lecturas = LecturaSensor.objects.filter(maceta_id=maceta_id).order_by('-fecha_lectura')[:50]
        if not lecturas:
            return Response({'message': 'No hay lecturas para esta maceta'})
        serializer = LecturaSensorSerializer(lecturas, many=True)
        return Response({
            'total_lecturas': len(lecturas),
            'lecturas_recientes': serializer.data
        })
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def recibir_lectura(request):
    print("📡 Datos recibidos del ESP:", request.data)
    try:
        temperatura = request.data.get('temperatura')
        humedad = request.data.get('humedad')
        maceta_id = request.data.get('maceta_id')

        if temperatura is None or humedad is None or maceta_id is None:
            return Response({'error': 'Faltan datos.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            temperatura = float(temperatura)
            humedad = float(humedad)
        except ValueError:
            return Response({'error': 'Valores deben ser numéricos.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            maceta = Maceta.objects.get(id=maceta_id)
        except Maceta.DoesNotExist:
            return Response({'error': 'Maceta no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

        lectura = LecturaSensor.objects.create(
            temperatura=temperatura,
            humedad=humedad,
            maceta=maceta
        )
        return Response({'mensaje': 'Lectura recibida correctamente ✅', 'id': lectura.id}, status=status.HTTP_201_CREATED)

    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def ultima_lectura(request, maceta_id: int):
    lec = LecturaSensor.objects.filter(maceta_id=maceta_id).order_by('-fecha_lectura').first()
    if not lec:
        return Response({'detail': 'Sin lecturas'}, status=status.HTTP_404_NOT_FOUND)
    return Response(LecturaSensorSerializer(lec).data, status=200)

@api_view(['GET'])
def configuracion_maceta(request, maceta_id: int):
    cfg = ConfiguracionMaceta.objects.filter(maceta_id=maceta_id).order_by('-fecha_actualizacion').first()
    if not cfg:
        return Response({'detail': 'Sin configuración'}, status=status.HTTP_404_NOT_FOUND)
    return Response(ConfiguracionMacetaSerializer(cfg).data, status=200)

# -------------------------------------------------------------------------
# AUTENTICACIÓN (Login y Registro)
# -------------------------------------------------------------------------

@api_view(['POST'])
def registro_usuario(request):
    print("DATA RECIBIDA:", request.data)
    nombre = request.data.get("nombre")
    email = request.data.get("email")
    password = request.data.get("password")

    if not nombre or not email or not password:
        return Response({"error": "Faltan datos"}, status=400)

    try:
        user = Usuario(first_name=nombre, email=email, metodo_login="local")
        user.username = email
        user.set_password(password)
        user.save(force_insert=True)
        return Response({"ok": True, "id": user.id}, status=201)
    except Exception as e:
        print("ERROR_BACKEND:", e)
        return Response({"error": str(e)}, status=500)

@api_view(['POST'])
def login_google_check(request):
    email = request.data.get('email')
    if not email:
        return Response({'error': 'Email requerido'}, status=400)
    try:
        usuario = Usuario.objects.get(email=email)
        return Response({
            'encontrado': True,
            'id': usuario.id,
            'nombre': usuario.first_name, 
            'mensaje': 'Usuario verificado correctamente'
        }, status=200)
    except Usuario.DoesNotExist:
        return Response({'encontrado': False, 'error': 'El usuario no está registrado'}, status=404)

@api_view(['POST'])
def login_local(request):
    email = request.data.get('email')
    password = request.data.get('password')
    user = authenticate(username=email, password=password)

    if user is not None:
        return Response({'ok': True, 'id': user.id, 'nombre': user.first_name}, status=200)
    else:
        return Response({'error': 'Credenciales incorrectas'}, status=401)

# -------------------------------------------------------------------------
# GESTIÓN DE PERFIL (Lo nuevo para Settings)
# -------------------------------------------------------------------------

@api_view(['GET', 'PUT'])
def gestion_perfil(request, user_id):
    try:
        usuario = Usuario.objects.get(id=user_id)
    except Usuario.DoesNotExist:
        return Response({'error': 'Usuario no encontrado'}, status=404)

    # GET: Obtener datos
    if request.method == 'GET':
        foto_url = None
        if usuario.foto_perfil:
            try:
                foto_url = usuario.foto_perfil.url
            except:
                foto_url = str(usuario.foto_perfil)

        return Response({
            'nombre': usuario.first_name,
            'email': usuario.email,
            'foto_perfil': foto_url,
        })

    # PUT: Actualizar (Texto o Foto)
    elif request.method == 'PUT':
        nombre = request.data.get('nombre')
        email = request.data.get('email')
        
        # 1. Actualizar Texto
        if nombre:
            usuario.first_name = nombre
        if email:
            usuario.email = email

        # 2. Actualizar Foto (ESTO ES LO NUEVO)
        # 'foto_perfil' es la clave que enviaremos desde Flutter
        foto = request.FILES.get('foto_perfil') 
        if foto:
            usuario.foto_perfil = foto # Django se encarga de guardarla

        usuario.save()
        
        # Devolvemos la nueva URL si se actualizó foto
        nueva_foto = None
        if usuario.foto_perfil:
             try: nueva_foto = usuario.foto_perfil.url
             except: pass

        return Response({
            'mensaje': 'Perfil actualizado',
            'foto_perfil': nueva_foto
        })

@api_view(['POST'])
def cambiar_password(request, user_id):
    usuario = get_object_or_404(Usuario, id=user_id)
    
    password_anterior = request.data.get('password_anterior')
    password_nueva = request.data.get('password_nueva')

    if not password_anterior or not password_nueva:
        return Response({'error': 'Faltan datos'}, status=400)

    # 1. Verificar pass anterior
    if not usuario.check_password(password_anterior):
        return Response({'error': 'La contraseña anterior es incorrecta'}, status=400)

    # 2. Poner nueva pass
    usuario.set_password(password_nueva)
    usuario.save()

    return Response({'mensaje': 'Contraseña actualizada con éxito'}, status=200)