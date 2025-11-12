from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('macetas_api.urls')),  # 🔹 Aquí se define el prefijo /api/
]