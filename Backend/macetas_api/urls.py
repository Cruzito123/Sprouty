from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

# Configuración del Router (Tus endpoints automáticos)
router = DefaultRouter()
router.register(r'plantas', views.PlantaViewSet)
router.register(r'macetas', views.MacetaViewSet)
router.register(r'lecturas', views.LecturaSensorViewSet)
router.register(r'jardines', views.JardinVirtualViewSet)
router.register(r'notificaciones', views.NotificacionViewSet)
router.register(r'configuraciones', views.ConfiguracionMacetaViewSet)

app_name = 'macetas_api'

urlpatterns = [
    # 1. Rutas del Router (CRUD automático)
    path('', include(router.urls)),

    # 2. Endpoints personalizados (Sensores y lógica de negocio)
    path('recomendaciones/', views.plantas_recomendadas, name='plantas_recomendadas'),
    path('estadisticas/<int:maceta_id>/', views.estadisticas_maceta, name='estadisticas_maceta'),
    path('recibir_lectura/', views.recibir_lectura, name='recibir_lectura'),
    path('lecturas/ultima/<int:maceta_id>/', views.ultima_lectura, name='ultima_lectura'),
    path('configuracion/<int:maceta_id>/', views.configuracion_maceta, name='configuracion_maceta'),
    
    # 3. 🔐 AUTENTICACIÓN (Registro y Logins)
    # Estas son las que buscará tu Flutter en /api/...
    path('registro/', views.registro_usuario, name='registro_usuario'),
    path('login_google_check/', views.login_google_check, name='login_google_check'), # 🆕 Agregada
    path('login_local/', views.login_local, name='login_local'),             # 🆕 Agregada
    path('perfil/<int:user_id>/', views.gestion_perfil, name='gestion_perfil'),
    path('cambiar-password/<int:user_id>/', views.cambiar_password, name='cambiar_password'),
    path('perfil/<int:user_id>/', views.gestion_perfil, name='gestion_perfil'),    
]