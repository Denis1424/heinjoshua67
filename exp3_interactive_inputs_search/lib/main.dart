import 'package:flutter/material.dart';

void main() {
  runApp(const InteractiveSearchApp());
}

class InteractiveSearchApp extends StatelessWidget {
  const InteractiveSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 3: Interactive Search & Filters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.light,
        ),
      ),
      home: const ProductSearchScreen(),
    );
  }
}

/// Product data model
class CatalogItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String brand;
  final bool inStock;
  final String emoji;
  final String description;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.brand,
    required this.inStock,
    required this.emoji,
    required this.description,
  });
}

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  // Predefined catalog of products
  final List<CatalogItem> _allProducts = const [
    CatalogItem(
      id: '1',
      name: 'Sony WH-1000XM5 Headphones',
      category: 'Audio',
      price: 349.99,
      rating: 4.8,
      brand: 'Sony',
      inStock: true,
      emoji: '🎧',
      description: 'Industry-leading noise cancelation with two processors and 8 microphones.',
    ),
    CatalogItem(
      id: '2',
      name: 'Apple iPad Air M2',
      category: 'Tablets',
      price: 599.00,
      rating: 4.9,
      brand: 'Apple',
      inStock: true,
      emoji: '📱',
      description: 'Supercharged by the blazing-fast M2 chip with Liquid Retina display.',
    ),
    CatalogItem(
      id: '3',
      name: 'Logitech MX Master 3S',
      category: 'Accessories',
      price: 99.99,
      rating: 4.7,
      brand: 'Logitech',
      inStock: true,
      emoji: '🖱️',
      description: 'Quiet clicks and 8K DPI track-on-glass sensor for elite productivity.',
    ),
    CatalogItem(
      id: '4',
      name: 'Dell UltraSharp 27" 4K Monitor',
      category: 'Monitors',
      price: 549.99,
      rating: 4.6,
      brand: 'Dell',
      inStock: false,
      emoji: '🖥️',
      description: 'Brilliant 4K IPS Black panel with 98% DCI-P3 color coverage.',
    ),
    CatalogItem(
      id: '5',
      name: 'Keychron K2 Mechanical Keyboard',
      category: 'Accessories',
      price: 79.99,
      rating: 4.5,
      brand: 'Keychron',
      inStock: true,
      emoji: '⌨️',
      description: '75% layout compact wireless mechanical keyboard for Mac & Windows.',
    ),
    CatalogItem(
      id: '6',
      name: 'Bose SoundLink Flex Speaker',
      category: 'Audio',
      price: 149.00,
      rating: 4.7,
      brand: 'Bose',
      inStock: true,
      emoji: '🔊',
      description: 'Portable waterproof Bluetooth outdoor speaker with deep bass.',
    ),
    CatalogItem(
      id: '7',
      name: 'Samsung Galaxy Tab S9',
      category: 'Tablets',
      price: 699.99,
      rating: 4.8,
      brand: 'Samsung',
      inStock: false,
      emoji: '📲',
      description: 'Dynamic AMOLED 2X display, IP68 water resistance and S Pen included.',
    ),
    CatalogItem(
      id: '8',
      name: 'LG UltraGear 34" Curved Monitor',
      category: 'Monitors',
      price: 799.99,
      rating: 4.6,
      brand: 'LG',
      inStock: true,
      emoji: '🖥️',
      description: 'UltraWide QHD Nano IPS display with 1ms response time and 160Hz.',
    ),
    CatalogItem(
      id: '9',
      name: 'Anker 737 Power Bank 24,000mAh',
      category: 'Accessories',
      price: 119.99,
      rating: 4.9,
      brand: 'Anker',
      inStock: true,
      emoji: '🔋',
      description: 'High-speed 140W multi-device charging with smart digital display.',
    ),
    CatalogItem(
      id: '10',
      name: 'Apple AirPods Pro 2',
      category: 'Audio',
      price: 249.00,
      rating: 4.9,
      brand: 'Apple',
      inStock: true,
      emoji: '🎵',
      description: 'Adaptive Audio, Active Noise Cancellation, and USB-C MagSafe case.',
    ),
  ];

  // Interactive Filter States
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _onlyInStock = false;
  bool _onlyHighRated = false;
  String _sortBy = 'Featured';
  final Set<String> _favoriteIds = {};

  final List<String> _categories = const ['All', 'Audio', 'Tablets', 'Accessories', 'Monitors'];
  final List<String> _sortOptions = const [
    'Featured',
    'Price: Low to High',
    'Price: High to Low',
    'Rating: High to Low',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
      _priceRange = const RangeValues(0, 1000);
      _onlyInStock = false;
      _onlyHighRated = false;
      _sortBy = 'Featured';
    });
  }

  List<CatalogItem> _getFilteredProducts() {
    var result = _allProducts.where((p) {
      // 1. Search Query filter (matches name, brand, description)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesBrand = p.brand.toLowerCase().contains(q);
        final matchesDesc = p.description.toLowerCase().contains(q);
        if (!matchesName && !matchesBrand && !matchesDesc) return false;
      }

      // 2. Category filter
      if (_selectedCategory != 'All' && p.category != _selectedCategory) {
        return false;
      }

      // 3. Price range filter
      if (p.price < _priceRange.start || p.price > _priceRange.end) {
        return false;
      }

      // 4. In Stock only filter
      if (_onlyInStock && !p.inStock) {
        return false;
      }

      // 5. High rating filter (4.7+ stars)
      if (_onlyHighRated && p.rating < 4.7) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating: High to Low':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text('Interactive Product Finder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6200EE),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Filter Controls',
            icon: const Icon(Icons.tune),
            onPressed: () => _openFilterBottomSheet(context),
          ),
          IconButton(
            tooltip: 'Reset Filters',
            icon: const Icon(Icons.refresh),
            onPressed: _clearAllFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar Widget with interactive Clear button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by title, brand, or features...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6200EE)),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF6200EE), width: 2),
                ),
              ),
            ),
          ),

          // 2. Interactive Category Filter Chips
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFF6200EE),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                );
              },
            ),
          ),

          // 3. Status Bar: Results count & Sort dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} of ${_allProducts.length} items',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.sort, size: 18),
                  style: const TextStyle(color: Color(0xFF6200EE), fontWeight: FontWeight.bold, fontSize: 13),
                  items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _sortBy = val);
                  },
                ),
              ],
            ),
          ),

          // 4. Products List or Empty State
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No matching products found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search query, price range, or category filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _clearAllFilters,
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Reset All Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6200EE),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isFav = _favoriteIds.contains(item.id);
                      return Card(
                        elevation: 1.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Emoji container
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6200EE).withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
                              ),
                              const SizedBox(width: 14),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.brand} • ${item.category}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6200EE),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 14, color: Colors.amber),
                                            const SizedBox(width: 2),
                                            Text('${item.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: item.inStock ? Colors.green.shade50 : Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: item.inStock ? Colors.green : Colors.red, width: 0.6),
                                          ),
                                          child: Text(
                                            item.inStock ? 'In Stock' : 'Out of Stock',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: item.inStock ? Colors.green.shade800 : Colors.red.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Heart button
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isFav) {
                                      _favoriteIds.remove(item.id);
                                    } else {
                                      _favoriteIds.add(item.id);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const Text('Filter Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Price Range Slider
                  Text(
                    'Price Range: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: const Color(0xFF6200EE),
                    labels: RangeLabels('\$${_priceRange.start.round()}', '\$${_priceRange.end.round()}'),
                    onChanged: (values) {
                      setModalState(() => _priceRange = values);
                      setState(() => _priceRange = values);
                    },
                  ),

                  // Switches for Stock and Rating
                  SwitchListTile(
                    title: const Text('In Stock Only'),
                    subtitle: const Text('Hide items that are out of stock'),
                    value: _onlyInStock,
                    activeThumbColor: const Color(0xFF6200EE),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => _onlyInStock = val);
                      setState(() => _onlyInStock = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Highly Rated (4.7+ ★)'),
                    subtitle: const Text('Show only top reviewed items'),
                    value: _onlyHighRated,
                    activeThumbColor: const Color(0xFF6200EE),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => _onlyHighRated = val);
                      setState(() => _onlyHighRated = val);
                    },
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6200EE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
