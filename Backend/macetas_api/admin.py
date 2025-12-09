from django.contrib import admin
from .models import Usuario, Planta, Maceta, ConfiguracionMaceta, LecturaSensor, JardinVirtual, Notificacion
from django.contrib import admin
from .models import Usuario

@admin.register(Planta)
class PlantaAdmin(admin.ModelAdmin):
    list_display = ['nombre_comun', 'nombre_cientifico', 'humedad_min', 'humedad_max']
    search_fields = ['nombre_comun', 'nombre_cientifico']

@admin.register(Maceta)
class MacetaAdmin(admin.ModelAdmin):
    list_display = ['nombre_maceta', 'usuario', 'estado_conexion', 'fecha_configuracion']
    list_filter = ['estado_conexion', 'fecha_configuracion']

@admin.register(LecturaSensor)
class LecturaSensorAdmin(admin.ModelAdmin):
    list_display = ['maceta', 'humedad', 'luz', 'temperatura', 'fecha_lectura']
    list_filter = ['fecha_lectura', 'maceta']

@admin.register(JardinVirtual)
class JardinVirtualAdmin(admin.ModelAdmin):
    list_display = ['alias', 'usuario', 'maceta', 'planta', 'fecha_asignacion']

@admin.register(Notificacion)
class NotificacionAdmin(admin.ModelAdmin):
    list_display = ['titulo', 'tipo', 'usuario', 'leida', 'fecha_envio']
    list_filter = ['tipo', 'leida', 'fecha_envio']

# Registrar también los otros modelos
admin.site.register(Usuario)
admin.site.register(ConfiguracionMaceta)