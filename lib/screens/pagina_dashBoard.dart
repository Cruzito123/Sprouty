import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class PaginaDashboard extends StatefulWidget {
  const PaginaDashboard({super.key});

  @override
  State<PaginaDashboard> createState() => _PaginaDashboard();
}

class _PaginaDashboard extends State<PaginaDashboard> {
  // Datos de ejemplo para la planta
  double currentTemp = 15.6;
  double currentHumidity = 35.5;
  double currentLight = 388;

  // Parámetros ideales (estos se modificarían desde el diálogo)
  double idealMinTemp = 18;
  double idealMaxTemp = 24;
  double idealMinHumidity = 50;
  double idealMaxHumidity = 70;
  double idealMinLight = 300;
  double idealMaxLight = 700;

  // Función para mostrar el diálogo de parámetros
  void _showParametersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ParametersDialog(
          // Pasamos los valores actuales al diálogo
          minTemp: idealMinTemp,
          maxTemp: idealMaxTemp,
          minHumidity: idealMinHumidity,
          maxHumidity: idealMaxHumidity,
          minLight: idealMinLight,
          maxLight: idealMaxLight,
          // Callback para recibir los nuevos valores al guardar
          onSave: (newParams) {
            setState(() {
              idealMinTemp = newParams['minTemp']!;
              idealMaxTemp = newParams['maxTemp']!;
              idealMinHumidity = newParams['minHumidity']!;
              idealMaxHumidity = newParams['maxHumidity']!;
              idealMinLight = newParams['minLight']!;
              idealMaxLight = newParams['maxLight']!;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool tempOk =
        currentTemp >= idealMinTemp && currentTemp <= idealMaxTemp;
    final bool humidityOk = currentHumidity >= idealMinHumidity &&
        currentHumidity <= idealMaxHumidity;
    final bool lightOk =
        currentLight >= idealMinLight && currentLight <= idealMaxLight;
    final bool actionRequired = !tempOk || !humidityOk || !lightOk;

    return Scaffold(
      backgroundColor: kFondoCrema,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel Principal',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('1 planta activa',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tus Plantas',
                    style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimario.withOpacity(0.1),
                    foregroundColor: kPrimario,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPlantCard(
              tempOk: tempOk,
              humidityOk: humidityOk,
              lightOk: lightOk,
              actionRequired: actionRequired,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Colors.orangeAccent, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los datos se actualizan automáticamente cada 3 segundos. Modifica los parámetros ideales para cada planta según sus necesidades específicas.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget para la tarjeta principal de la planta
  Widget _buildPlantCard({
    required bool tempOk,
    required bool humidityOk,
    required bool lightOk,
    required bool actionRequired,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('ksdfkdsfsf',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 8),
                        if (actionRequired)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    Text('Ficus Elastica',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey.shade600)),
                  ],
                ),
                TextButton.icon(
                  onPressed: _showParametersDialog,
                  icon: const Icon(Icons.settings_outlined,
                      color: kPrimario, size: 20),
                  label: const Text('Parámetros',
                      style: TextStyle(color: kPrimario)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'Temperatura',
                    value: '$currentTemp°C',
                    statusColor: tempOk
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFFFEBEE),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    title: 'Humedad',
                    value: '$currentHumidity%',
                    statusColor: humidityOk
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFFFEBEE),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    title: 'Luz',
                    value: '$currentLight lux',
                    statusColor: lightOk
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFFFEBEE),
                  ),
                ),
              ],
            ),
            if (actionRequired) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4), // Yellowish background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text('Acción requerida',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notes),
              label: const Text('Ver Recomendaciones Detalladas'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                foregroundColor: kPrimario,
                side: const BorderSide(color: kDivisor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- WIDGET REUTILIZABLE PARA LAS TARJETAS DE SENSORES ---
class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (title) {
      case 'Temperatura':
        iconData = Icons.thermostat;
        break;
      case 'Humedad':
        iconData = Icons.water_drop_outlined;
        break;
      case 'Luz':
        iconData = Icons.wb_sunny_outlined;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              // FIX: Envolver el Text con Flexible para evitar el overflow
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                  overflow:
                      TextOverflow.fade, // Puedes usar ellipsis, fade, etc.
                  softWrap: false, // Evita que el texto salte a otra línea
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- DIÁLOGO EMERGENTE PARA MODIFICAR PARÁMETROS ---
class ParametersDialog extends StatefulWidget {
  final double minTemp, maxTemp, minHumidity, maxHumidity, minLight, maxLight;
  final Function(Map<String, double>) onSave;

  const ParametersDialog({
    super.key,
    required this.minTemp,
    required this.maxTemp,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minLight,
    required this.maxLight,
    required this.onSave,
  });

  @override
  State<ParametersDialog> createState() => _ParametersDialogState();
}

class _ParametersDialogState extends State<ParametersDialog> {
  late TextEditingController _minTempController;
  late TextEditingController _maxTempController;
  late TextEditingController _minHumidityController;
  late TextEditingController _maxHumidityController;
  late TextEditingController _minLightController;
  late TextEditingController _maxLightController;

  @override
  void initState() {
    super.initState();
    _minTempController = TextEditingController(text: widget.minTemp.toString());
    _maxTempController = TextEditingController(text: widget.maxTemp.toString());
    _minHumidityController =
        TextEditingController(text: widget.minHumidity.toString());
    _maxHumidityController =
        TextEditingController(text: widget.maxHumidity.toString());
    _minLightController =
        TextEditingController(text: widget.minLight.toString());
    _maxLightController =
        TextEditingController(text: widget.maxLight.toString());
  }

  @override
  void dispose() {
    _minTempController.dispose();
    _maxTempController.dispose();
    _minHumidityController.dispose();
    _maxHumidityController.dispose();
    _minLightController.dispose();
    _maxLightController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final newParams = {
      'minTemp': double.tryParse(_minTempController.text) ?? 0,
      'maxTemp': double.tryParse(_maxTempController.text) ?? 0,
      'minHumidity': double.tryParse(_minHumidityController.text) ?? 0,
      'maxHumidity': double.tryParse(_maxHumidityController.text) ?? 0,
      'minLight': double.tryParse(_minLightController.text) ?? 0,
      'maxLight': double.tryParse(_maxLightController.text) ?? 0,
    };
    widget.onSave(newParams);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: const Color(0xFFF5F5F0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Modificar Parámetros',
                      style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text('Configura los rangos ideales para ksdfkdsfsf',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              _buildParameterSection(
                icon: Icons.thermostat,
                title: 'Temperatura Ideal',
                minLabel: 'Mínima (°C)',
                maxLabel: 'Máxima (°C)',
                minController: _minTempController,
                maxController: _maxTempController,
              ),
              const SizedBox(height: 16),
              _buildParameterSection(
                icon: Icons.water_drop_outlined,
                title: 'Humedad Ideal',
                minLabel: 'Mínima (%)',
                maxLabel: 'Máxima (%)',
                minController: _minHumidityController,
                maxController: _maxHumidityController,
              ),
              const SizedBox(height: 16),
              _buildParameterSection(
                icon: Icons.wb_sunny_outlined,
                title: 'Luz Requerida',
                minLabel: 'Mínima (lux)',
                maxLabel: 'Máxima (lux)',
                minController: _minLightController,
                maxController: _maxLightController,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: kPrimario, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            'Los valores se utilizarán para determinar si las condiciones actuales son óptimas para esta planta específica.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      child: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimario,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterSection({
    required IconData icon,
    required String title,
    required String minLabel,
    required String maxLabel,
    required TextEditingController minController,
    required TextEditingController maxController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField(minLabel, minController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(maxLabel, maxController)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kDivisor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kDivisor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimario),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
