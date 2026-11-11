import 'package:flutter/material.dart';

void main() {
  runApp(const MileageCalculatorApp());
}

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 4: Car Mileage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B), // Teal
          brightness: Brightness.light,
        ),
      ),
      home: const MileageCalculatorScreen(),
    );
  }
}

/// Calculation history model
class CalculationRecord {
  final double distance;
  final double fuel;
  final double mileage;
  final double? cost;
  final String unitDistance;
  final String unitFuel;
  final DateTime timestamp;

  CalculationRecord({
    required this.distance,
    required this.fuel,
    required this.mileage,
    required this.cost,
    required this.unitDistance,
    required this.unitFuel,
    required this.timestamp,
  });
}

class MileageCalculatorScreen extends StatefulWidget {
  const MileageCalculatorScreen({super.key});

  @override
  State<MileageCalculatorScreen> createState() => _MileageCalculatorScreenState();
}

class _MileageCalculatorScreenState extends State<MileageCalculatorScreen> {
  // Global key for Form validation
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController _startOdoController = TextEditingController();
  final TextEditingController _endOdoController = TextEditingController();
  final TextEditingController _fuelAmountController = TextEditingController();
  final TextEditingController _fuelPriceController = TextEditingController();

  // Unit settings: Metric (km, L) or Imperial (miles, gal)
  bool _isMetric = true;

  // Calculation Results
  double? _calculatedDistance;
  double? _calculatedMileage;
  double? _consumptionPerHundred;
  double? _totalTripCost;
  double? _costPerDistance;

  // Saved calculation records
  final List<CalculationRecord> _history = [];

  @override
  void dispose() {
    _startOdoController.dispose();
    _endOdoController.dispose();
    _fuelAmountController.dispose();
    _fuelPriceController.dispose();
    super.dispose();
  }

  void _calculateMileage() {
    // Trigger Form validation
    if (_formKey.currentState!.validate()) {
      final start = double.parse(_startOdoController.text.trim());
      final end = double.parse(_endOdoController.text.trim());
      final fuel = double.parse(_fuelAmountController.text.trim());
      final price = _fuelPriceController.text.trim().isNotEmpty
          ? double.tryParse(_fuelPriceController.text.trim())
          : null;

      final distance = end - start;
      final mileage = distance / fuel;
      final perHundred = (fuel / distance) * 100;
      final totalCost = price != null ? fuel * price : null;
      final costPerUnit = totalCost != null ? totalCost / distance : null;

      setState(() {
        _calculatedDistance = distance;
        _calculatedMileage = mileage;
        _consumptionPerHundred = perHundred;
        _totalTripCost = totalCost;
        _costPerDistance = costPerUnit;

        _history.insert(
          0,
          CalculationRecord(
            distance: distance,
            fuel: fuel,
            mileage: mileage,
            cost: totalCost,
            unitDistance: _isMetric ? 'km' : 'mi',
            unitFuel: _isMetric ? 'L' : 'gal',
            timestamp: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mileage calculated successfully!'),
          backgroundColor: Color(0xFF00897B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _startOdoController.clear();
    _endOdoController.clear();
    _fuelAmountController.clear();
    _fuelPriceController.clear();
    setState(() {
      _calculatedDistance = null;
      _calculatedMileage = null;
      _consumptionPerHundred = null;
      _totalTripCost = null;
      _costPerDistance = null;
    });
  }

  String _getEfficiencyRating(double mileage) {
    if (_isMetric) {
      if (mileage >= 20.0) return 'Exceptional Efficiency 🌟';
      if (mileage >= 15.0) return 'Great Fuel Economy 🚗';
      if (mileage >= 10.0) return 'Average Economy ⛽';
      return 'High Consumption ⚠️';
    } else {
      if (mileage >= 45.0) return 'Exceptional Efficiency 🌟';
      if (mileage >= 35.0) return 'Great Fuel Economy 🚗';
      if (mileage >= 25.0) return 'Average Economy ⛽';
      return 'High Consumption ⚠️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final distUnit = _isMetric ? 'km' : 'miles';
    final fuelUnit = _isMetric ? 'Liters' : 'Gallons';
    final mileageUnit = _isMetric ? 'km/L' : 'MPG';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: const Text('Car Mileage Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Form',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card explaining Experiment 4
            Card(
              elevation: 0,
              color: const Color(0xFFE0F2F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.speed, size: 40, color: Color(0xFF00897B)),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXP 4: Form Validation & Stateful Widgets',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enter your odometer readings and fuel consumption to compute real-time mileage.',
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Unit Selector Switch
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Text('Measurement Units:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('Metric (km, L)')),
                        ButtonSegment(value: false, label: Text('Imperial (mi, gal)')),
                      ],
                      selected: {_isMetric},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _isMetric = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form with validation
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip & Fuel Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                      ),
                      const SizedBox(height: 16),

                      // Starting Odometer Reading
                      TextFormField(
                        controller: _startOdoController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Starting Odometer Reading ($distUnit)',
                          hintText: 'e.g. 12500',
                          prefixIcon: const Icon(Icons.play_circle_outline, color: Color(0xFF00897B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter starting odometer reading';
                          }
                          final num = double.tryParse(value.trim());
                          if (num == null || num < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Ending Odometer Reading
                      TextFormField(
                        controller: _endOdoController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Ending Odometer Reading ($distUnit)',
                          hintText: 'e.g. 12950',
                          prefixIcon: const Icon(Icons.stop_circle_outlined, color: Color(0xFF00897B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter ending odometer reading';
                          }
                          final end = double.tryParse(value.trim());
                          if (end == null || end < 0) {
                            return 'Please enter a valid positive number';
                          }
                          final start = double.tryParse(_startOdoController.text.trim());
                          if (start != null && end <= start) {
                            return 'Ending reading must be greater than starting reading';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Fuel Amount
                      TextFormField(
                        controller: _fuelAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Total Fuel Added ($fuelUnit)',
                          hintText: 'e.g. 25.5',
                          prefixIcon: const Icon(Icons.local_gas_station_outlined, color: Color(0xFF00897B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter fuel volume';
                          }
                          final fuel = double.tryParse(value.trim());
                          if (fuel == null || fuel <= 0) {
                            return 'Fuel amount must be greater than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Optional Fuel Price
                      TextFormField(
                        controller: _fuelPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Fuel Price per $fuelUnit (Optional)',
                          hintText: 'e.g. 1.85',
                          prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF00897B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final price = double.tryParse(value.trim());
                            if (price == null || price < 0) {
                              return 'Price must be a valid positive number';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _calculateMileage,
                              icon: const Icon(Icons.calculate),
                              label: const Text('Calculate Mileage', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00897B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic Results Card
            if (_calculatedMileage != null)
              Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF00897B), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Calculation Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00897B).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getEfficiencyRating(_calculatedMileage!),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Distance', '${_calculatedDistance!.toStringAsFixed(1)} $distUnit'),
                          _buildStatColumn('Mileage', '${_calculatedMileage!.toStringAsFixed(2)} $mileageUnit', isHighlight: true),
                          if (_isMetric)
                            _buildStatColumn('Consumption', '${_consumptionPerHundred!.toStringAsFixed(2)} L/100km'),
                        ],
                      ),
                      if (_totalTripCost != null) ...[
                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('Total Trip Cost', '\$${_totalTripCost!.toStringAsFixed(2)}'),
                            _buildStatColumn('Cost / $distUnit', '\$${_costPerDistance!.toStringAsFixed(3)}'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Calculation History Section
            if (_history.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Calculations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => setState(() => _history.clear()),
                    child: const Text('Clear History'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length > 5 ? 5 : _history.length,
                itemBuilder: (context, index) {
                  final record = _history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE0F2F1),
                        child: Icon(Icons.directions_car, color: Color(0xFF00897B)),
                      ),
                      title: Text(
                        '${record.mileage.toStringAsFixed(2)} ${record.unitDistance}/${record.unitFuel}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Distance: ${record.distance.toStringAsFixed(1)} ${record.unitDistance} • Fuel: ${record.fuel.toStringAsFixed(1)} ${record.unitFuel}',
                      ),
                      trailing: record.cost != null
                          ? Text(
                              '\$${record.cost!.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 18 : 15,
            fontWeight: FontWeight.bold,
            color: isHighlight ? const Color(0xFF00897B) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
