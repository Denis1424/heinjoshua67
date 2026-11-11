import 'package:flutter/material.dart';

void main() {
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 1: Fruit Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const FruitListScreen(),
    );
  }
}

/// Data model representing a fruit item
class FruitItem {
  final String name;
  final String scientificName;
  final String category;
  final double price;
  final int calories;
  final double rating;
  final String emoji;
  final Color themeColor;
  final String description;
  final List<String> benefits;

  const FruitItem({
    required this.name,
    required this.scientificName,
    required this.category,
    required this.price,
    required this.calories,
    required this.rating,
    required this.emoji,
    required this.themeColor,
    required this.description,
    required this.benefits,
  });
}

/// Main Screen showcasing ListView, Container, Row, Column, and Card
class FruitListScreen extends StatefulWidget {
  const FruitListScreen({super.key});

  @override
  State<FruitListScreen> createState() => _FruitListScreenState();
}

class _FruitListScreenState extends State<FruitListScreen> {
  final List<FruitItem> fruits = const [
    FruitItem(
      name: 'Honeycrisp Apple',
      scientificName: 'Malus domestica',
      category: 'Pome',
      price: 2.99,
      calories: 95,
      rating: 4.8,
      emoji: '🍎',
      themeColor: Color(0xFFE53935),
      description: 'Crisp, sweet, and juicy apple freshly picked from orchards.',
      benefits: ['Rich in fiber', 'Supports heart health', 'Boosts immunity'],
    ),
    FruitItem(
      name: 'Cavendish Banana',
      scientificName: 'Musa acuminata',
      category: 'Tropical',
      price: 1.29,
      calories: 105,
      rating: 4.6,
      emoji: '🍌',
      themeColor: Color(0xFFFBC02D),
      description: 'Naturally sweet energy booster loaded with potassium.',
      benefits: ['High in potassium', 'Aids digestion', 'Quick energy source'],
    ),
    FruitItem(
      name: 'Valencia Orange',
      scientificName: 'Citrus sinensis',
      category: 'Citrus',
      price: 3.49,
      calories: 62,
      rating: 4.7,
      emoji: '🍊',
      themeColor: Color(0xFFFB8C00),
      description: 'Bursting with sweet and tangy citrus juice and Vitamin C.',
      benefits: ['High Vitamin C', 'Hydrating', 'Promotes glowing skin'],
    ),
    FruitItem(
      name: 'Alphonso Mango',
      scientificName: 'Mangifera indica',
      category: 'Tropical',
      price: 5.99,
      calories: 135,
      rating: 4.9,
      emoji: '🥭',
      themeColor: Color(0xFFFFA000),
      description: 'The king of fruits with an unmatched sweet tropical aroma.',
      benefits: ['Rich in Vitamin A', 'Aids eye health', 'Antioxidant rich'],
    ),
    FruitItem(
      name: 'Organic Strawberry',
      scientificName: 'Fragaria ananassa',
      category: 'Berry',
      price: 4.50,
      calories: 49,
      rating: 4.7,
      emoji: '🍓',
      themeColor: Color(0xFFE91E63),
      description: 'Ruby red berries with an intoxicating floral sweetness.',
      benefits: ['Packed with antioxidants', 'Low glycemic index', 'Heart friendly'],
    ),
    FruitItem(
      name: 'Wild Blueberry',
      scientificName: 'Vaccinium sect. Cyanococcus',
      category: 'Berry',
      price: 4.99,
      calories: 84,
      rating: 4.9,
      emoji: '🫐',
      themeColor: Color(0xFF3F51B5),
      description: 'Potent superfruit full of anthocyanins and rich deep flavor.',
      benefits: ['Brain health booster', 'Anti-inflammatory', 'High in manganese'],
    ),
    FruitItem(
      name: 'Golden Pineapple',
      scientificName: 'Ananas comosus',
      category: 'Tropical',
      price: 3.99,
      calories: 82,
      rating: 4.5,
      emoji: '🍍',
      themeColor: Color(0xFFFFB300),
      description: 'Sweet tropical delight packed with bromelain enzymes.',
      benefits: ['Digestive enzyme bromelain', 'Immune support', 'Refreshing taste'],
    ),
    FruitItem(
      name: 'Crimson Watermelon',
      scientificName: 'Citrullus lanatus',
      category: 'Melon',
      price: 6.49,
      calories: 46,
      rating: 4.6,
      emoji: '🍉',
      themeColor: Color(0xFF43A047),
      description: '92% water content making it the ultimate summer thirst quencher.',
      benefits: ['Super hydrating', 'Rich in lycopene', 'Relieves muscle soreness'],
    ),
    FruitItem(
      name: 'Hass Avocado',
      scientificName: 'Persea americana',
      category: 'Stone Fruit',
      price: 2.49,
      calories: 160,
      rating: 4.8,
      emoji: '🥑',
      themeColor: Color(0xFF558B2F),
      description: 'Creamy nutrient-dense fruit loaded with healthy monounsaturated fats.',
      benefits: ['Healthy fats', 'Fiber powerhouse', 'Lowers LDL cholesterol'],
    ),
  ];

  String _selectedCategory = 'All';
  int _cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Pome', 'Tropical', 'Citrus', 'Berry', 'Melon', 'Stone Fruit'];
    final filteredFruits = _selectedCategory == 'All'
        ? fruits
        : fruits.where((f) => f.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: const Text(
          'Fresh Fruit Market',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Reusable action container with Row and Badge
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cart contains $_cartItemCount fruit item(s)!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                if (_cartItemCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Header Banner using Container, Column, and Row
          const MarketHeaderBanner(),

          // 2. Category Filter Selector using Container and horizontal ListView
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2E7D32),
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

          // 3. Fruit List using ListView.builder displaying custom FruitCard widgets
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredFruits.length,
              itemBuilder: (context, index) {
                final fruit = filteredFruits[index];
                return FruitCard(
                  fruit: fruit,
                  onAddToCart: () {
                    setState(() {
                      _cartItemCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${fruit.name} to cart!'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onTap: () => _showFruitDetailsSheet(context, fruit),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFruitDetailsSheet(BuildContext context, FruitItem fruit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: fruit.themeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(fruit.emoji, style: const TextStyle(fontSize: 36)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fruit.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          fruit.scientificName,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${fruit.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                fruit.description,
                style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text(
                'Key Health Benefits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...fruit.benefits.map(
                (benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32), size: 18),
                      const SizedBox(width: 8),
                      Text(benefit, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _cartItemCount++;
                    });
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Basket', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// REUSABLE CUSTOM WIDGET 1: Market Header Banner
/// Demonstrates Container, Row, Column, and styling.
class MarketHeaderBanner extends StatelessWidget {
  const MarketHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade900.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'EXP 1: WIDGETS & LAYOUTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '100% Organic & Fresh Fruits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Explore Row, Column, Container, Card & ListView',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '🧺',
              style: TextStyle(fontSize: 32),
            ),
          ),
        ],
      ),
    );
  }
}

/// REUSABLE CUSTOM WIDGET 2: FruitCard
/// Combines Card, Container, Row, and Column widgets to present an item.
class FruitCard extends StatelessWidget {
  final FruitItem fruit;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const FruitCard({
    super.key,
    required this.fruit,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: fruit.themeColor,
                width: 5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Emoji / Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: fruit.themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  fruit.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 14),

              // Middle Column: Title, Category, Nutrition
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fruit.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      fruit.scientificName,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Inner Row: Category chip, Calories badge, and Rating
                    Row(
                      children: [
                        InfoBadge(
                          icon: Icons.local_fire_department,
                          iconColor: Colors.deepOrange,
                          label: '${fruit.calories} kcal',
                        ),
                        const SizedBox(width: 8),
                        InfoBadge(
                          icon: Icons.star_rounded,
                          iconColor: Colors.amber.shade800,
                          label: '${fruit.rating}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right Column: Price and Action Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${fruit.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF2E7D32)),
                      onPressed: onAddToCart,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      tooltip: 'Add to Cart',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// REUSABLE CUSTOM WIDGET 3: InfoBadge
/// Reusable metric badge composed of Container, Row, Icon, and Text.
class InfoBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const InfoBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
