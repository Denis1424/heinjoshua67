import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase native config not detected: $e. Running in simulated Firestore mode.');
  }
  runApp(FirestoreUpdateApp(isFirebaseInitialized: firebaseReady));
}

class FirestoreUpdateApp extends StatelessWidget {
  final bool isFirebaseInitialized;

  const FirestoreUpdateApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 6: Cloud Firestore Record Update',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          brightness: Brightness.light,
        ),
      ),
      home: FirestoreUpdateScreen(isFirebaseConnected: isFirebaseInitialized),
    );
  }
}

/// Item Data Model
class InventoryItem {
  final String id;
  String name;
  String category;
  double price;
  int stock;
  bool isAvailable;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.isAvailable,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
      stock: (data['stock'] is num) ? (data['stock'] as num).toInt() : 0,
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreUpdateScreen extends StatefulWidget {
  final bool isFirebaseConnected;

  const FirestoreUpdateScreen({super.key, required this.isFirebaseConnected});

  @override
  State<FirestoreUpdateScreen> createState() => _FirestoreUpdateScreenState();
}

class _FirestoreUpdateScreenState extends State<FirestoreUpdateScreen> {
  // Demo dataset for testing/offline presentation
  final List<InventoryItem> _localInventory = [
    InventoryItem(id: '1', name: 'Logitech Mechanical Keyboard', category: 'Hardware', price: 89.99, stock: 15, isAvailable: true),
    InventoryItem(id: '2', name: 'Dell UltraSharp Monitor 27"', category: 'Electronics', price: 499.00, stock: 8, isAvailable: true),
    InventoryItem(id: '3', name: 'Ergonomic Standing Desk', category: 'Furniture', price: 320.50, stock: 3, isAvailable: true),
    InventoryItem(id: '4', name: 'Sony Wireless ANC Headset', category: 'Audio', price: 249.99, stock: 0, isAvailable: false),
  ];

  /// Cloud Firestore Stream
  Stream<QuerySnapshot>? _getFirestoreStream() {
    if (!widget.isFirebaseConnected) return null;
    return FirebaseFirestore.instance.collection('inventory').snapshots();
  }

  /// Update Document in Firestore
  Future<void> _updateFirestoreRecord(InventoryItem item) async {
    if (widget.isFirebaseConnected) {
      await FirebaseFirestore.instance.collection('inventory').doc(item.id).update(item.toMap());
    } else {
      setState(() {
        final idx = _localInventory.indexWhere((e) => e.id == item.id);
        if (idx != -1) {
          _localInventory[idx] = item;
        }
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully updated "${item.name}"!'),
          backgroundColor: const Color(0xFF00796B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Update Firestore Records', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Chip(
              avatar: Icon(
                widget.isFirebaseConnected ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: widget.isFirebaseConnected ? Colors.green.shade800 : Colors.brown.shade800,
              ),
              label: Text(
                widget.isFirebaseConnected ? 'Live Firestore' : 'Mock Mode',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00796B)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit_note, color: Colors.white, size: 40),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXP 6: Firestore Document Update',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap the edit button on any item to update Firestore records dynamically.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Records List
          Expanded(
            child: widget.isFirebaseConnected
                ? StreamBuilder<QuerySnapshot>(
                    stream: _getFirestoreStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Center(child: Text('No inventory records found.'));
                      }
                      final items = docs.map((d) => InventoryItem.fromFirestore(d)).toList();
                      return _buildInventoryList(items);
                    },
                  )
                : _buildInventoryList(_localInventory),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(List<InventoryItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF00796B).withValues(alpha: 0.12),
                  child: const Icon(Icons.inventory_2, color: Color(0xFF00796B)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${item.category} • Stock: ${item.stock}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF00796B),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.isAvailable ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.isAvailable ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _openUpdateDialog(item),
                  tooltip: 'Update Record',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Interactive Dialog to edit & update Firestore document
  void _openUpdateDialog(InventoryItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final categoryCtrl = TextEditingController(text: item.category);
    final priceCtrl = TextEditingController(text: item.price.toString());
    final stockCtrl = TextEditingController(text: item.stock.toString());
    bool isAvailable = item.isAvailable;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Update: ${item.name}', style: const TextStyle(fontSize: 18)),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Product Name', prefixIcon: Icon(Icons.label)),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: categoryCtrl,
                      decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Price (\$)', prefixIcon: Icon(Icons.attach_money)),
                      validator: (v) => double.tryParse(v ?? '') == null ? 'Enter valid price' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock Units', prefixIcon: Icon(Icons.numbers)),
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Enter integer' : null,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Available for Sale'),
                      value: isAvailable,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setDialogState(() => isAvailable = val),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final updatedItem = InventoryItem(
                      id: item.id,
                      name: nameCtrl.text.trim(),
                      category: categoryCtrl.text.trim(),
                      price: double.parse(priceCtrl.text.trim()),
                      stock: int.parse(stockCtrl.text.trim()),
                      isAvailable: isAvailable,
                    );
                    _updateFirestoreRecord(updatedItem);
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }
}
