from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'plantas', views.PlantaViewSet)
router.register(r'macetas', views.MacetaViewSet)
router.register(r'lecturas', views.LecturaSensorViewSet)
router.register(r'jardines', views.JardinVirtualViewSet)
router.register(r'notificaciones', views.NotificacionViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('recomendaciones/', views.plantas_recomendadas, name='plantas_recomendadas'),
    path('estadisticas/<int:maceta_id>/', views.estadisticas_maceta, name='estadisticas_maceta'),
]