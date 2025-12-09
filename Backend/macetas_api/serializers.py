from rest_framework import serializers
from .models import Usuario, Planta, Maceta, ConfiguracionMaceta, LecturaSensor, JardinVirtual, Notificacion
from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from .models import Usuario

class PlantaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Planta
        fields = '__all__'

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'username', 'email', 'first_name', 'foto_perfil', 'metodo_login', 'fecha_registro']

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
        # deja solo los campos que sí quieres exponer
        fields = ('id', 'humedad', 'temperatura', 'luz', 'maceta', 'fecha_lectura')
        read_only_fields = ('id', 'fecha_lectura')

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


class UserRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'first_name', 'email', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = Usuario(
            first_name=validated_data['first_name'],
            email=validated_data['email'],
            metodo_login='local'
        )
        user.set_password(validated_data['password'])
        user.save()
        return user
