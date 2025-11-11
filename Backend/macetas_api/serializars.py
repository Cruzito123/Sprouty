from rest_framework import serializers
from .models import Usuario, Planta, Maceta, ConfiguracionMaceta, LecturaSensor, JardinVirtual, Notificacion

class PlantaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Planta
        fields = '__all__'

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'foto_perfil', 'metodo_login', 'fecha_registro']

class MacetaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Maceta
        fields = '__all__'

class ConfiguracionMacetaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfiguracionMaceta
        fields = '__all__'

class LecturaSensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = LecturaSensor
        fields = '__all__'

class JardinVirtualSerializer(serializers.ModelSerializer):
    planta = PlantaSerializer(read_only=True)
    maceta = MacetaSerializer(read_only=True)
    
    class Meta:
        model = JardinVirtual
        fields = '__all__'

class NotificacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notificacion
        fields = '__all__'