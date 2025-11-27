from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'plantas', views.PlantaViewSet)
router.register(r'macetas', views.MacetaViewSet)
router.register(r'lecturas', views.LecturaSensorViewSet)
router.register(r'jardines', views.JardinVirtualViewSet)
router.register(r'notificaciones', views.NotificacionViewSet)
router.register(r'configuraciones', views.ConfiguracionMacetaViewSet)

app_name = 'macetas_api'

urlpatterns = [
    path('', include(router.urls)),
    path('recomendaciones/', views.plantas_recomendadas, name='plantas_recomendadas'),
    path('estadisticas/<int:maceta_id>/', views.estadisticas_maceta, name='estadisticas_maceta'),
    path('recibir_lectura/', views.recibir_lectura, name='recibir_lectura'),
    path('lecturas/ultima/<int:maceta_id>/', views.ultima_lectura, name='ultima_lectura'),
    path('configuracion/<int:maceta_id>/', views.configuracion_maceta, name='configuracion_maceta'),
]
