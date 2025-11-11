from django.db import models
from django.contrib.auth.models import AbstractUser

# Modelo Usuario personalizado
class Usuario(AbstractUser):
    METODO_LOGIN_CHOICES = [
        ('local', 'Local'),
        ('google', 'Google'),
        ('facebook', 'Facebook'),
    ]
    
    metodo_login = models.CharField(
        max_length=20, 
        choices=METODO_LOGIN_CHOICES, 
        default='local'
    )
    foto_perfil = models.URLField(blank=True, null=True)
    fecha_registro = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'usuario'
    
    def __str__(self):
        return self.username

# Modelo Planta
class Planta(models.Model):
    nombre_comun = models.CharField(max_length=100)
    nombre_cientifico = models.CharField(max_length=150)
    descripcion = models.TextField(blank=True, null=True)
    humedad_min = models.DecimalField(max_digits=5, decimal_places=2)
    humedad_max = models.DecimalField(max_digits=5, decimal_places=2)
    luz_min = models.DecimalField(max_digits=5, decimal_places=2)
    luz_max = models.DecimalField(max_digits=5, decimal_places=2)
    temperatura_min = models.DecimalField(max_digits=5, decimal_places=2)
    temperatura_max = models.DecimalField(max_digits=5, decimal_places=2)
    recomendaciones = models.TextField(blank=True, null=True)
    
    class Meta:
        db_table = 'planta'
    
    def __str__(self):
        return f"{self.nombre_comun} ({self.nombre_cientifico})"

# Modelo Maceta
class Maceta(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    nombre_maceta = models.CharField(max_length=100)
    ssid_wifi = models.CharField(max_length=100, blank=True, null=True)
    estado_conexion = models.BooleanField(default=False)
    fecha_configuracion = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'maceta'
    
    def __str__(self):
        return self.nombre_maceta

# Modelo ConfiguracionMaceta
class ConfiguracionMaceta(models.Model):
    maceta = models.ForeignKey(Maceta, on_delete=models.CASCADE)
    humedad_objetivo = models.DecimalField(max_digits=5, decimal_places=2)
    luz_objetivo = models.DecimalField(max_digits=5, decimal_places=2)
    temperatura_objetivo = models.DecimalField(max_digits=5, decimal_places=2)
    notificar_alertas = models.BooleanField(default=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'configuracionmaceta'
    
    def __str__(self):
        return f"Config {self.maceta.nombre_maceta}"

# Modelo LecturaSensor
class LecturaSensor(models.Model):
    maceta = models.ForeignKey(Maceta, on_delete=models.CASCADE)
    humedad = models.DecimalField(max_digits=5, decimal_places=2)
    luz = models.DecimalField(max_digits=5, decimal_places=2)
    temperatura = models.DecimalField(max_digits=5, decimal_places=2)
    fecha_lectura = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'lecturasensor'
    
    def __str__(self):
        return f"Lectura {self.maceta.nombre_maceta} - {self.fecha_lectura}"

# Modelo JardinVirtual
class JardinVirtual(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    maceta = models.ForeignKey(Maceta, on_delete=models.CASCADE)
    planta = models.ForeignKey(Planta, on_delete=models.CASCADE)
    fecha_asignacion = models.DateTimeField(auto_now_add=True)
    alias = models.CharField(max_length=100, blank=True, null=True)
    
    class Meta:
        db_table = 'jardinvirtual'
    
    def __str__(self):
        return f"{self.alias or self.planta.nombre_comun} en {self.maceta.nombre_maceta}"

# Modelo Notificacion
class Notificacion(models.Model):
    TIPO_CHOICES = [
        ('alerta', 'Alerta'),
        ('recordatorio', 'Recordatorio'),
        ('informacion', 'Información'),
    ]
    
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    maceta = models.ForeignKey(Maceta, on_delete=models.CASCADE)
    titulo = models.CharField(max_length=100)
    mensaje = models.TextField()
    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES)
    fecha_envio = models.DateTimeField(auto_now_add=True)
    leida = models.BooleanField(default=False)
    
    class Meta:
        db_table = 'notification'
    
    def __str__(self):
        return f"{self.tipo}: {self.titulo}"