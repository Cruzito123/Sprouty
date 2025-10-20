class ParametrosPlanta {
  double minTemp;
  double maxTemp;
  double minHumedad;
  double maxHumedad;
  double minLuz;
  double maxLuz;

  ParametrosPlanta({
    required this.minTemp,
    required this.maxTemp,
    required this.minHumedad,
    required this.maxHumedad,
    required this.minLuz,
    required this.maxLuz,
  });

  ParametrosPlanta copia() => ParametrosPlanta(
        minTemp: minTemp,
        maxTemp: maxTemp,
        minHumedad: minHumedad,
        maxHumedad: maxHumedad,
        minLuz: minLuz,
        maxLuz: maxLuz,
      );
}
