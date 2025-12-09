# ARCHIVO: Backend/backend/urls.py
from django.contrib import admin
from django.urls import path, include
from django.conf import settings             # <--- IMPORTANTE
from django.conf.urls.static import static   # <--- IMPORTANTE

# ⚠️ AQUÍ NO DEBE HABER NINGÚN IMPORT DE VIEWS
# Este archivo solo delega tráfico.

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # Esta línea envía todo lo que empieza con 'api/' a la carpeta macetas_api
    path('api/', include('macetas_api.urls')), 
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)