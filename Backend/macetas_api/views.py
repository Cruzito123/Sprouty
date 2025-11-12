from rest_framework import viewsets, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Planta, Maceta, ConfiguracionMaceta, LecturaSensor, JardinVirtual, Notificacion
from .serializers import *

# ViewSet para Planta
class PlantaViewSet(viewsets.ModelViewSet):
    queryset = Planta.objects.all()
    serializer_class = PlantaSerializer

# ViewSet para Maceta
class MacetaViewSet(viewsets.ModelViewSet):
    queryset = Maceta.objects.all()
    serializer_class = MacetaSerializer

# ViewSet para LecturaSensor
class LecturaSensorViewSet(viewsets.ModelViewSet):
    queryset = LecturaSensor.objects.all()
    serializer_class = LecturaSensorSerializer

# ViewSet para JardinVirtual
class JardinVirtualViewSet(viewsets.ModelViewSet):
    queryset = JardinVirtual.objects.all()
    serializer_class = JardinVirtualSerializer

# ViewSet para Notificacion
class NotificacionViewSet(viewsets.ModelViewSet):
    queryset = Notificacion.objects.all()
    serializer_class = NotificacionSerializer

# API endpoint personalizado para recomendaciones
@api_view(['GET'])
def plantas_recomendadas(request):
    """
    Endpoint para obtener plantas recomendadas basadas en condiciones promedio
    """
    try:
        # Ejemplo: obtener plantas con requisitos moderados
        plantas = Planta.objects.filter(
            humedad_min__lte=50,
            humedad_max__gte=50,
            temperatura_min__lte=25,
            temperatura_max__gte=25
        )[:10]  # Limitar a 10 resultados
        
        serializer = PlantaSerializer(plantas, many=True)
        return Response(serializer.data)
    
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

# Endpoint para estadísticas
@api_view(['GET'])
def estadisticas_maceta(request, maceta_id):
    """
    Endpoint para obtener estadísticas de una maceta específica
    """
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
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
    

@api_view(['POST'])
def recibir_lectura(request):
    print("📡 Datos recibidos del ESP:", request.data)
    
    """
    Endpoint para recibir lecturas desde el ESP32.
    """
    try:
        temperatura = request.data.get('temperatura')
        humedad = request.data.get('humedad')
        maceta_id = request.data.get('maceta_id')

        # Validación básica
        if temperatura is None or humedad is None or maceta_id is None:
            return Response(
                {'error': 'Faltan datos de temperatura, humedad o maceta_id.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Convertir a tipo numérico si llega como string
        try:
            temperatura = float(temperatura)
            humedad = float(humedad)
        except ValueError:
            return Response(
                {'error': 'Los valores de temperatura y humedad deben ser numéricos.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Obtener la instancia de la maceta
        try:
            maceta = Maceta.objects.get(id=maceta_id)
        except Maceta.DoesNotExist:
            return Response({'error': 'Maceta no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

        # Crear registro en la BD
        lectura = LecturaSensor.objects.create(
            temperatura=temperatura,
            humedad=humedad,
            maceta=maceta
        )

        return Response(
            {
                'mensaje': 'Lectura recibida correctamente ✅',
                'id': lectura.id
            },
            status=status.HTTP_201_CREATED
        )

    except Exception as e:
        # Captura general de errores
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
@api_view(['GET'])
def ultima_lectura(request, maceta_id: int):
    """Devuelve la última lectura de una maceta."""
    lec = (LecturaSensor.objects
           .filter(maceta_id=maceta_id)
           .order_by('-fecha_lectura')
           .first())
    if not lec:
        return Response({'detail': 'Sin lecturas'}, status=status.HTTP_404_NOT_FOUND)
    return Response(LecturaSensorSerializer(lec).data, status=200)
