import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Safe initialization that allows running in Demo mode if Firebase is not yet provisioned
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase not initialized with native config: $e. Using local simulated Firestore provider.');
  }
  runApp(FirestoreSearchApp(isFirebaseInitialized: firebaseReady));
}

class FirestoreSearchApp extends StatelessWidget {
  final bool isFirebaseInitialized;

  const FirestoreSearchApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 5: Cloud Firestore Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100), // Firestore Orange
          brightness: Brightness.light,
        ),
      ),
      home: FirestoreSearchScreen(isFirebaseConnected: isFirebaseInitialized),
    );
  }
}

/// Record data model
class StudentRecord {
  final String id;
  final String rollNo;
  final String name;
  final String department;
  final double cgpa;
  final String email;

  StudentRecord({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.department,
    required this.cgpa,
    required this.email,
  });

  factory StudentRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentRecord(
      id: doc.id,
      rollNo: data['rollNo'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      cgpa: (data['cgpa'] is num) ? (data['cgpa'] as num).toDouble() : 0.0,
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rollNo': rollNo,
      'name': name,
      'department': department,
      'cgpa': cgpa,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreSearchScreen extends StatefulWidget {
  final bool isFirebaseConnected;

  const FirestoreSearchScreen({super.key, required this.isFirebaseConnected});

  @override
  State<FirestoreSearchScreen> createState() => _FirestoreSearchScreenState();
}

class _FirestoreSearchScreenState extends State<FirestoreSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDept = 'All';

  // Demo fallback dataset (ensures app works offline or without live google-services.json)
  final List<StudentRecord> _localRecords = [
    StudentRecord(id: '1', rollNo: 'CS101', name: 'Aarav Sharma', department: 'Computer Science', cgpa: 9.2, email: 'aarav@univ.edu'),
    StudentRecord(id: '2', rollNo: 'CS102', name: 'Diya Patel', department: 'Computer Science', cgpa: 8.9, email: 'diya@univ.edu'),
    StudentRecord(id: '3', rollNo: 'EC201', name: 'Rohan Verma', department: 'Electronics', cgpa: 8.5, email: 'rohan@univ.edu'),
    StudentRecord(id: '4', rollNo: 'IT301', name: 'Ananya Iyer', department: 'Information Tech', cgpa: 9.5, email: 'ananya@univ.edu'),
    StudentRecord(id: '5', rollNo: 'ME401', name: 'Vikram Singh', department: 'Mechanical', cgpa: 7.8, email: 'vikram@univ.edu'),
    StudentRecord(id: '6', rollNo: 'CS103', name: 'Sneha Reddy', department: 'Computer Science', cgpa: 9.1, email: 'sneha@univ.edu'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Cloud Firestore query with prefix search range
  Stream<QuerySnapshot>? _getFirestoreStream() {
    if (!widget.isFirebaseConnected) return null;

    CollectionReference collection = FirebaseFirestore.instance.collection('students');
    Query query = collection;

    if (_searchQuery.isNotEmpty) {
      // Standard Firestore text prefix query pattern
      query = query
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    if (_selectedDept != 'All') {
      query = query.where('department', isEqualTo: _selectedDept);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Firestore Record Search', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
        actions: [
          // Indicator showing whether live Cloud Firestore or Demo Mode is active
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Chip(
              avatar: Icon(
                widget.isFirebaseConnected ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: widget.isFirebaseConnected ? Colors.green.shade800 : Colors.brown.shade800,
              ),
              label: Text(
                widget.isFirebaseConnected ? 'Cloud Firestore' : 'Offline / Mock Mode',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFF57C00)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.storage, color: Colors.white, size: 36),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXP 5: Google Cloud Firestore Search',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dynamic retrieval with StreamBuilder & QuerySnapshot',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search students by name or roll number...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFE65100)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Department Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text('Filter Dept: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedDept,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Departments')),
                    DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
                    DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                    DropdownMenuItem(value: 'Information Tech', child: Text('Information Tech')),
                    DropdownMenuItem(value: 'Mechanical', child: Text('Mechanical')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDept = val);
                  },
                ),
              ],
            ),
          ),

          // Dynamic Record Results
          Expanded(
            child: widget.isFirebaseConnected
                ? _buildFirestoreStreamBuilder()
                : _buildLocalFilteredList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        onPressed: () => _showAddRecordDialog(context),
      ),
    );
  }

  /// Live Firestore StreamBuilder implementation
  Widget _buildFirestoreStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getFirestoreStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error querying Firestore: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFE65100)));
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Text('No student records found in Firestore collection.', style: TextStyle(color: Colors.grey)),
          );
        }

        final records = docs.map((d) => StudentRecord.fromFirestore(d)).toList();
        return _buildRecordListView(records);
      },
    );
  }

  /// Local / Offline fallback list
  Widget _buildLocalFilteredList() {
    final filtered = _localRecords.where((s) {
      final matchesQuery = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.rollNo.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDept == 'All' || s.department == _selectedDept;
      return matchesQuery && matchesDept;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('No matching records found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return _buildRecordListView(filtered);
  }

  /// Common Reusable ListView for student records
  Widget _buildRecordListView(List<StudentRecord> records) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final student = records[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE65100).withValues(alpha: 0.15),
              child: Text(
                student.name.isNotEmpty ? student.name[0] : 'S',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
              ),
            ),
            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Roll: ${student.rollNo} • ${student.department}'),
                Text(student.email, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 0.8),
              ),
              child: Text(
                'CGPA ${student.cgpa.toStringAsFixed(1)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green.shade800),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Dialog to add a new document dynamically
  void _showAddRecordDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final rollCtrl = TextEditingController();
    final deptCtrl = TextEditingController(text: 'Computer Science');
    final cgpaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Student Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number')),
              TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department')),
              TextField(controller: cgpaCtrl, decoration: const InputDecoration(labelText: 'CGPA (e.g. 8.8)')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty && rollCtrl.text.isNotEmpty) {
                final newRecord = StudentRecord(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  rollNo: rollCtrl.text.trim(),
                  name: nameCtrl.text.trim(),
                  department: deptCtrl.text.trim(),
                  cgpa: double.tryParse(cgpaCtrl.text.trim()) ?? 0.0,
                  email: emailCtrl.text.trim(),
                );

                if (widget.isFirebaseConnected) {
                  // Add to Google Cloud Firestore
                  await FirebaseFirestore.instance.collection('students').add(newRecord.toMap());
                } else {
                  // Add to local state
                  setState(() {
                    _localRecords.insert(0, newRecord);
                  });
                }

                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100), foregroundColor: Colors.white),
            child: const Text('Save Record'),
          ),
        ],
      ),
    );
  }
}
